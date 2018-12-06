require 'net/http'
require 'json'
require 'uri'

Puppet::Type.type(:grua_config).provide(:ruby) do
  def initialize(*args)
    super
    require 'net/http/post/multipart'
  end

  def exists?
    # If any of the certificate fields are nil should return false
    return false if master_data['signed_cert'].nil?
    return false if master_data['private_key'].nil?
    # Attempt to download the certificates
    request_cert = Net::HTTP.get_response(URI.parse(master_data['signed_cert']))
    request_pk = Net::HTTP.get_response(URI.parse(master_data['private_key']))
    # If any of the requests give a 404 should return false
    return false if request_cert.code == 404
    return false if request_pk.code == 404
    # If any of the uploaded files are not equal to the local files
    return false if request_cert.body != File.read(signed_cert)
    return false if request_pk.body != File.read(private_key)
    # The certificates are alright
    true
  end

  def create
    uri = grua_api_master_uri
    params = master_data
    params['signed_cert'] = upload_io_for(signed_cert)
    params['private_key'] = upload_io_for(private_key)
    Net::HTTP.start(uri.host, uri.port) do |http|
      request = Net::HTTP::Put::Multipart.new(uri, params)
      request['Authorization'] = "Token #{grua_token}"
      http.request(request)
    end
  end

  def destroy
    # TODO
  end

  def master_zone_id
    resource[:master_zone_id]
  end

  def signed_cert
    resource[:signed_cert]
  end

  def private_key
    resource[:private_key]
  end

  def puppetserver_address
    resource[:puppetserver_address]
  end

  def puppetserver_port
    resource[:puppetserver_port]
  end

  def puppetdb_address
    resource[:puppetdb_address]
  end

  def puppetdb_port
    resource[:puppetdb_port]
  end

  def grua_address
    resource[:grua_address]
  end

  def grua_port
    resource[:grua_port]
  end

  def grua_token
    resource[:grua_token]
  end

  private

  def upload_io_for(path)
    UploadIO.new(File.new(path), 'application/octet-stream', File.basename(path))
  end

  def master_data
    @master_data ||= begin
      http = Net::HTTP.new(grua_api_master_uri.host, grua_api_master_uri.port)
      request = Net::HTTP::Get.new(grua_api_master_uri.request_uri)
      request['Authorization'] = "Token #{grua_token}"
      response = http.request(request)
      if response.code == '200'
        JSON.parse(response.body)
      elsif response.body.include?('Not Found')
        raise(Puppet::Error, "Master with UUID (#{uuid}) not found in the GRUA API")
      else
        raise(Puppet::Error, "Error trying to contact GRUA API, please check 'address' and 'port' params")
      end
    end
  end

  def grua_api_master_uri
    @grua_api_master_uri ||= URI.parse("http://#{grua_address}:#{grua_port}/api/master_zones/#{master_zone_id}/")
  end
end
