Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AD949B202
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 16:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789142859; cv=none; b=SiYZoPF1VGNkFkMa+XTXJRCTcEb0GkFgRBb8zbRl37S1xBZDfH/asv3hbGtELSP5B+o+1AhO23EIhJW+bT2ihOErqBpIJYRDWWBIFVBXl8PTGkxJcMWGnUJS31eka0h/iMZRsRexqO1BJ4tpe449olXTozk1pcmnUdn+GQKk0t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789142859; c=relaxed/simple;
	bh=dsSez3iIkwjff/1EbAtSPDeoRvW0W4YMmEGhRiZaz6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NMrgy766EKjT/cYVAfEuAiEmem9viG0lS/zTOGKY/6jh74X8GfIsuGHvJnPcRFm/nDTRwDDHCfI0KZLYq7upz1o9j6TDJsBDS+lKUijJZm/lwUrgNEGFd4Qw9h+x8zaqNYtlZzqe13wTDXQK4W3+pTUMRlFgFEPNs2p2Zei1VzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P9z3tej0; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P9z3tej0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789142858; x=1820678858;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=dsSez3iIkwjff/1EbAtSPDeoRvW0W4YMmEGhRiZaz6w=;
  b=P9z3tej0IQVZj+2CgBsQ949Zl46P6lOSGupAAEBchsmypMOVpPv17TWy
   Y8H/Z4hvZK2VxG+P4jzLESbE3kYwvMVPMu+1jQ6nyECrnHgrkoEJfIIlG
   ob1KNEcChnNuyjA1H4sFlvcrc7k7Of5DQ5IfVgi1CFBRylPRe8I/ZgEYJ
   RKhpDCTudBEAmQCN6m5iXPVPh6KPZm1hWsr0qWlkRx2PzyC0lyolSdWrP
   NM3CVSgQf/MgQ/zPXnsDZjKw5pX0fbZGncYdtnGg1uwspUH7xa9rQ1v/4
   ZRyvFBIdxTpiN2JN9G2+AUljWB2vLru2EkWBtHNOExnyEjv5ievY+3FSV
   Q==;
X-CSE-ConnectionGUID: klid+Uv9T5ScwPQzVDk8Pw==
X-CSE-MsgGUID: E9AxugUWTDW42qQ62xJfbA==
X-URL-LookUp-ScanningError: 1
X-IronPort-AV: E=McAfee;i="6800,10657,11902"; a="89480508"
X-IronPort-AV: E=Sophos;i="6.27,97,1787036400"; 
   d="p7s'346?scan'346,208,346";a="89480508"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 09:07:37 -0700
X-CSE-ConnectionGUID: 0V8chWv5QaS97ofS8FK72A==
X-CSE-MsgGUID: bHY92lSeRPyzpaIzzNO3WQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,97,1787036400"; 
   d="p7s'346?scan'346,208,346";a="270582591"
Received: from tjmaciei-mobl5.jf.intel.com (HELO tjmaciei-mobl5.localnet) ([10.24.81.190])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 09:07:37 -0700
From: Thiago Macieira <thiago.macieira@intel.com>
To: Dave Hansen <dave.hansen@intel.com>, Anand Suveer Jain <asj@kernel.org>
Cc: sashal@kernel.org, linux-btrfs@vger.kernel.org,
 David Woodhouse <dwmw2@infradead.org>, David Sterba <dsterba@suse.com>
Subject: Re: [PATCH 1/3] btrfs: derive f_fsid from on-disk fsuuid and dev_t
Date: Fri, 11 Sep 2026 09:07:29 -0700
Message-ID: <qH1wH2-sQO2cdJ17lf_wvw@intel.com>
Organization: Intel Corporation
In-Reply-To: <dc5401d6-19ec-4588-bc9c-a7a0084b299a@kernel.org>
References:
 <cover.1772095546.git.asj@kernel.org>
 <be0c08f5-2f31-40f5-8a3b-f2f58b3e00ff@intel.com>
 <dc5401d6-19ec-4588-bc9c-a7a0084b299a@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPartum1A8a6JTPS2ES6fvQVGjw";
 micalg="sha256"; protocol="application/pkcs7-signature"

--nextPartum1A8a6JTPS2ES6fvQVGjw
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

On Friday, 11 September 2026 07:51:16 Pacific Daylight Time Anand Suveer Jain 
wrote:
> I wish I had more clarity on how OpenConnect uses the FSID before I
> comment. Do you know? Can you shed some light on this?

It's openconnect's option --key-password-from-fsid. It uses the FSID encoded 
in hex format as the key's passphrase.

To reproduce, take any key without a password and do:
  openssl rsa -in unencrypted-key.pem -out encrypted-key.pem
And paste your FSID as the password.

This is not real security, we all agree. David W can probably remember better 
why this option exists, but I would suspect it was an IT mandate that a) the 
key not be left unencrypted on disk and b) be specific to a given machine, 
avoiding reuse by being copied to another. Ideally, we'd use TPM these days, 
but there are still a lot of systems without it where Linux runs, and 
especially a lot of legacy set ups.

But very simply, it's the fact that the FSID has been used as a stable 
identifier and no longer is if the device in question is not itself stable. 

> Also, a couple of quick checks:
> 
>  Is the underlying device MAJ:MIN changing before and after the upgrade?

Unknown. It's LVM and I don't know if the order of activation of LVs is 
guaranteed. I wouldn't rely on it. I'll tell you next time I reboot if the 
order is the same as this:

brw-rw---- 1 root disk 254,   0 Sep  7 20:28 cr-auto-1
brw-rw---- 1 root disk 254,   1 Sep  7 20:28 system-root
brw-rw---- 1 root disk 254,   2 Sep  7 20:28 system-swap
brw-rw---- 1 root disk 254,   3 Sep  7 20:28 system-pool_tmeta
brw-rw---- 1 root disk 254,   4 Sep  7 20:28 system-pool_tdata
brw-rw---- 1 root disk 254,   5 Sep  7 20:28 system-pool-tpool
brw-rw---- 1 root disk 254,   6 Sep  7 20:28 system-pool
brw-rw---- 1 root disk 254,   7 Sep  7 20:28 system-stuff
brw-rw---- 1 root disk 254,   8 Sep  7 20:28 system-home
brw-rw---- 1 root disk 254,   9 Sep  7 20:28 system-stuff2

Either way, the point is that it changed from 7.1 when the MAJ:MIN was not 
mixed in.

>  Are the original and cloned Btrfs filesystems mounted simultaneously?

No cloning is involved.

> Patch v3 (1/2) keeps the FSID persistent from the on-disk superblock and
> stops exposing the internal random FSID. However, if OpenConnect relies
> on statfs.f_fsid, patch v3 (2/2) now derives f_fsid from the underlying
> MAJ:MIN.


-- 
Thiago Macieira - thiago.macieira (AT) intel.com
  Principal Engineer - Intel DCG - Platform & Sys. Eng.

--nextPartum1A8a6JTPS2ES6fvQVGjw
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIIUNAYJKoZIhvcNAQcCoIIUJTCCFCECAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
ghFkMIIFgTCCBGmgAwIBAgIQOXJEOvkit1HX02wQ3TE1lTANBgkqhkiG9w0BAQwFADB7MQswCQYD
VQQGEwJHQjEbMBkGA1UECAwSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHDAdTYWxmb3JkMRow
GAYDVQQKDBFDb21vZG8gQ0EgTGltaXRlZDEhMB8GA1UEAwwYQUFBIENlcnRpZmljYXRlIFNlcnZp
Y2VzMB4XDTE5MDMxMjAwMDAwMFoXDTI4MTIzMTIzNTk1OVowgYgxCzAJBgNVBAYTAlVTMRMwEQYD
VQQIEwpOZXcgSmVyc2V5MRQwEgYDVQQHEwtKZXJzZXkgQ2l0eTEeMBwGA1UEChMVVGhlIFVTRVJU
UlVTVCBOZXR3b3JrMS4wLAYDVQQDEyVVU0VSVHJ1c3QgUlNBIENlcnRpZmljYXRpb24gQXV0aG9y
aXR5MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAgBJlFzYOw9sIs9CsVw127c0n00yt
UINh4qogTQktZAnczomfzD2p7PbPwdzx07HWezcoEStH2jnGvDoZtF+mvX2do2NCtnbyqTsrkfji
b9DsFiCQCT7i6HTJGLSR1GJk23+jBvGIGGqQIjy8/hPwhxR79uQfjtTkUcYRZ0YIUcuGFFQ/vDP+
fmyc/xadGL1RjjWmp2bIcmfbIWax1Jt4A8BQOujM8Ny8nkz+rwWWNR9XWrf/zvk9tyy29lTdyOcS
Ok2uTIq3XJq0tyA9yn8iNK5+O2hmAUTnAU5GU5szYPeUvlM3kHND8zLDU+/bqv50TmnHa4xgk97E
xwzf4TKuzJM7UXiVZ4vuPVb+DNBpDxsP8yUmazNt925H+nND5X4OpWaxKXwyhGNVicQNwZNUMBkT
rNN9N6frXTpsNVzbQdcS2qlJC9/YgIoJk2KOtWbPJYjNhLixP6Q5D9kCnusSTJV882sFqV4Wg8y4
Z+LoE53MW4LTTLPtW//e5XOsIzstAL81VXQJSdhJWBp/kjbmUZIO8yZ9HE0XvMnsQybQv0FfQKlE
RPSZ51eHnlAfV1SoPv10Yy+xUGUJ5lhCLkMaTLTwJUdZ+gQek9QmRkpQgbLevni3/GcV4clXhB4P
Y9bpYrrWX1Uu6lzGKAgEJTm4Diup8kyXHAc/DVL17e8vgg8CAwEAAaOB8jCB7zAfBgNVHSMEGDAW
gBSgEQojPpbxB+zirynvgqV/0DCktDAdBgNVHQ4EFgQUU3m/WqorSs9UgOHYm8Cd8rIDZsswDgYD
VR0PAQH/BAQDAgGGMA8GA1UdEwEB/wQFMAMBAf8wEQYDVR0gBAowCDAGBgRVHSAAMEMGA1UdHwQ8
MDowOKA2oDSGMmh0dHA6Ly9jcmwuY29tb2RvY2EuY29tL0FBQUNlcnRpZmljYXRlU2VydmljZXMu
Y3JsMDQGCCsGAQUFBwEBBCgwJjAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuY29tb2RvY2EuY29t
MA0GCSqGSIb3DQEBDAUAA4IBAQAYh1HcdCE9nIrgJ7cz0C7M7PDmy14R3iJvm3WOnnL+5Nb+qh+c
li3vA0p+rvSNb3I8QzvAP+u431yqqcau8vzY7qN7Q/aGNnwU4M309z/+3ri0ivCRlv79Q2R+/czS
AaF9ffgZGclCKxO/WIu6pKJmBHaIkU4MiRTOok3JMrO66BQavHHxW/BBC5gACiIDEOUMsfnNkjcZ
7Tvx5Dq2+UUTJnWvu6rvP3t3O9LEApE9GQDTF1w52z97GA1FzZOFli9d31kWTz9RvdVFGD/tSo7o
BmF0Ixa1DVBzJ0RHfxBdiSprhTEUxOipakyAvGp4z7h/jnZymQyd/teRCBaho1+VMIIGEDCCA/ig
AwIBAgIQTZQsENQ74JQJxYEtOisGTzANBgkqhkiG9w0BAQwFADCBiDELMAkGA1UEBhMCVVMxEzAR
BgNVBAgTCk5ldyBKZXJzZXkxFDASBgNVBAcTC0plcnNleSBDaXR5MR4wHAYDVQQKExVUaGUgVVNF
UlRSVVNUIE5ldHdvcmsxLjAsBgNVBAMTJVVTRVJUcnVzdCBSU0EgQ2VydGlmaWNhdGlvbiBBdXRo
b3JpdHkwHhcNMTgxMTAyMDAwMDAwWhcNMzAxMjMxMjM1OTU5WjCBljELMAkGA1UEBhMCR0IxGzAZ
BgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYGA1UEChMPU2Vj
dGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVudGljYXRpb24g
YW5kIFNlY3VyZSBFbWFpbCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMo87ZQK
Qf/e+Ua56NY75tqSvysQTqoavIK9viYcKSoq0s2cUIE/bZQu85eoZ9X140qOTKl1HyLTJbazGl6n
BEibivHbSuejQkq6uIgymiqvTcTlxZql19szfBxxo0Nm9l79L9S+TZNTEDygNfcXlkHKRhBhVFHd
JDfqB6Mfi/Wlda43zYgo92yZOpCWjj2mz4tudN55/yE1+XvFnz5xsOFbme/SoY9WAa39uJORHtbC
0x7C7aYivToxuIkEQXaumf05Vcf4RgHs+Yd+mwSTManRy6XcCFJE6k/LHt3ndD3sA3If/JBz6OX2
ZebtQdHnKav7Azf+bAhudg7PkFOTuRMCAwEAAaOCAWQwggFgMB8GA1UdIwQYMBaAFFN5v1qqK0rP
VIDh2JvAnfKyA2bLMB0GA1UdDgQWBBQJwPL8C9qU21/+K9+omULPyeCtADAOBgNVHQ8BAf8EBAMC
AYYwEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwEQYD
VR0gBAowCDAGBgRVHSAAMFAGA1UdHwRJMEcwRaBDoEGGP2h0dHA6Ly9jcmwudXNlcnRydXN0LmNv
bS9VU0VSVHJ1c3RSU0FDZXJ0aWZpY2F0aW9uQXV0aG9yaXR5LmNybDB2BggrBgEFBQcBAQRqMGgw
PwYIKwYBBQUHMAKGM2h0dHA6Ly9jcnQudXNlcnRydXN0LmNvbS9VU0VSVHJ1c3RSU0FBZGRUcnVz
dENBLmNydDAlBggrBgEFBQcwAYYZaHR0cDovL29jc3AudXNlcnRydXN0LmNvbTANBgkqhkiG9w0B
AQwFAAOCAgEAQUR1AKs5whX13o6VbTJxaIwA3RfXehwQOJDI47G9FzGR87bjgrShfsbMIYdhqpFu
SUKzPM1ZVPgNlT+9istp5UQNRsJiD4KLu+E2f102qxxvM3TEoGg65FWM89YN5yFTvSB5PelcLGnC
LwRfCX6iLPvGlh9j30lKzcT+mLO1NLGWMeK1w+vnKhav2VuQVHwpTf64ZNnXUF8p+5JJpGtkUG/X
fdJ5jR3YCq8H0OPZkNoVkDQ5CSSF8Co2AOlVEf32VBXglIrHQ3v9AAS0yPo4Xl1FdXqGFe5TcDQS
qXh3TbjugGnG+d9yZX3lB8bwc/Tn2FlIl7tPbDAL4jNdUNA7jGee+tAnTtlZ6bFz+CsWmCIb6j6l
DFqkXVsp+3KyLTZGXq6F2nnBtN4t5jO3ZIj2gpIKHAYNBAWLG2Q2fG7Bt2tPC8BLC9WIM90gbMhA
mtMGquITn/2fORdsNmaV3z/sPKuIn8DvdEhmWVfh0fyYeqxGlTw0RfwhBlakdYYrkDmdWC+XszE1
9GUi8K8plBNKcIvyg2omAdebrMIHiAHAOiczxX/aS5ABRVrNUDcjfvp4hYbDOO6qHcfzy/uY0fO5
ssebmHQREJJA3PpSgdVnLernF6pthJrGkNDPeUI05svqw1o5A2HcNzLOpklhNwZ+4uWYLcAi14AC
HuVvJsmzNicwggXHMIIEr6ADAgECAhBjVZxdREz9JWD5eu4aNslDMA0GCSqGSIb3DQEBCwUAMIGW
MQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxm
b3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNlY3RpZ28gUlNBIENsaWVu
dCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTI2MDExMzAwMDAwMFoXDTI3
MDExMzIzNTk1OVowgcExCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRowGAYDVQQK
ExFJbnRlbCBDb3Jwb3JhdGlvbjEZMBcGA1UEYRMQTlRSVVMrQ0EtMTYzNjAzMjEoMCYGCSqGSIb3
DQEJARYZdGhpYWdvLm1hY2llaXJhQGludGVsLmNvbTERMA8GA1UEBBMITWFjaWVpcmExDzANBgNV
BCoTBlRoaWFnbzEYMBYGA1UEAxMPVGhpYWdvIE1hY2llaXJhMIIBIjANBgkqhkiG9w0BAQEFAAOC
AQ8AMIIBCgKCAQEApmNIlVC71J5+ScSe7KHu9ldGhNvaYqq6Qr7A58ExVWXvxy73EgE3lc2di7xO
I+8xKOHEB4G6OHIez26SjW8CoCQsYj1QiB7VjJ3quGyPM5xRw85KkC9ilpWTRlebacnocOIpmfuF
mCOjdF8qmoH/biLbCHZh20rYIV4wefbLcxAvEYM8wPmURt2wfGQYqzNkOcek2Ul5hIWhnuUnFwNI
uBj8YQRlTH8mG36gVEWyYEAyw7WckQbKYYd8MSIIyYKHfKAZj2vHCRquqMBBrE/ffetOJWLqwV4n
TTVVQLfLRJXt2+h9/V1LgbhRzhImxvXw/yWyyULyCjIT2MyBVPko5QIDAQABo4IB4jCCAd4wHwYD
VR0jBBgwFoAUCcDy/AvalNtf/ivfqJlCz8ngrQAwHQYDVR0OBBYEFEKdEKoajvhxYeOba5fyjwbe
mDUmMA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMB0GA1UdJQQWMBQGCCsGAQUFBwMEBggr
BgEFBQcDAjBQBgNVHSAESTBHMDoGDCsGAQQBsjEBAgEKBDAqMCgGCCsGAQUFBwIBFhxodHRwczov
L3NlY3RpZ28uY29tL1NNSU1FQ1BTMAkGB2eBDAEFAwIwWgYDVR0fBFMwUTBPoE2gS4ZJaHR0cDov
L2NybC5zZWN0aWdvLmNvbS9TZWN0aWdvUlNBQ2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVF
bWFpbENBLmNybDCBigYIKwYBBQUHAQEEfjB8MFUGCCsGAQUFBzAChklodHRwOi8vY3J0LnNlY3Rp
Z28uY29tL1NlY3RpZ29SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWlsQ0EuY3J0
MCMGCCsGAQUFBzABhhdodHRwOi8vb2NzcC5zZWN0aWdvLmNvbTAkBgNVHREEHTAbgRl0aGlhZ28u
bWFjaWVpcmFAaW50ZWwuY29tMA0GCSqGSIb3DQEBCwUAA4IBAQBVxypipJcDRGhksbFm5d4S4bRD
o/g0JE2mmTOrf9iWUJkY4PjzVryMDxFh80HJzsoMtStlw0mck61wJ730YCa+X6wwfoSZpcNt3WwV
r5Q4AVy+5u6wYe21w9eQrn2gD8OTZlo6sGdOHr4h80GS7bJD6MsF9UHK5vK6s6dnRmnRsuX1AwYA
9by6CHXuxhC3epmvWq1jMueMvhGATfcsEMcjBRW3B8uOqksiZi3kNQ/7HVhEOT7DSBRxMXJ8huRc
ORV5eH75EfDweDs9/dWyvv2ivKnVD4+Zz5lRL4GC/97uDbxFU6avsP9tTgVsg6Pf9MMr1LQaslWF
o22dfsZ1QY0UMYIClDCCApACAQEwgaswgZYxCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVy
IE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGDAWBgNVBAoTD1NlY3RpZ28gTGltaXRlZDE+
MDwGA1UEAxM1U2VjdGlnbyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEGNVnF1ETP0lYPl67ho2yUMwDQYJYIZIAWUDBAIBBQCggbowGAYJKoZIhvcNAQkDMQsG
CSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjYwOTExMTYwNzI5WjAvBgkqhkiG9w0BCQQxIgQg
F2j548HwpSM88zi8wWAxb+aM6yB3YLeuNlor4eyMyrgwTwYJKoZIhvcNAQkPMUIwQDALBglghkgB
ZQMEAS4wCwYJYIZIAWUDBAEGMAsGCWCGSAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcw
DQYJKoZIhvcNAQEBBQAEggEAT20eZCie2UylkGZ687gr9D18+P4yD4xf4QeI8jvsZFok/DGcnELa
V82svxgiI7gjTB4Pl2wEekektES5T4OzvCCQxtSAWokmrEFkjy+Nq2vehSinNCCkCN1PGKxAeFjs
vcS/9yKRloruUCkXb16CU6vGCz3WoRKLb+zgA/sgqrgQaBzuCWHExbg7t/yw7FSAMzLer2pURvM9
s5tg+9ZCMiKDhit5o3N6QrI6g2HuiNWQmJ1yT1qx2RQ0rZ7zK67oFMDncb+Ea2HMhy10BWk3bYgN
FqsQsVZTIZpNDZ4AL4ZdTHzi4S8ryimXG8zFwRg9C5xackuTHdXXK/S3bB8LEQ==


--nextPartum1A8a6JTPS2ES6fvQVGjw--



