locals {
  common_tags = {
    Environment = "dev"
    Project     = "home-proxy"
    ManagedBy   = "terraform"
  }

  # CIDRブロック定義
  vcn_proxy_vpc = {
    name     = "proxy-01-vpc"
    vcn_cidr = "10.1.0.0/20"
    subnet = {
      vpc-subnet-01 = { cidr_block = "10.1.0.0/24", prohibit_internet_ingress = false, prohibit_public_access = false }
    }
  }

  # IP制限を行う場合の接続許可元
  nsg_ingress_rules = {
    from_home1 = {
      source_ip = "[set your ip address]/32"
      ports = {
        ssh = {
          port        = 22
          description = "Allow SSH"
        }
        http_proxy = {
          port        = 10080
          description = "Allow Squid HTTP Proxy"
        }
        https_proxy = {
          port        = 10443
          description = "Allow Squid HTTPS Proxy"
        }
      }
    }
    from_home2 = {
      source_ip = "[set your ip address]/32"
      ports = {
        http_proxy = {
          port        = 10080
          description = "Allow Squid HTTP Proxy"
        }
        https_proxy = {
          port        = 10443
          description = "Allow Squid HTTPS Proxy"
        }
      }
    }
  }
}
