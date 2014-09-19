Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:45466 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696AbaISOxT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Sep 2014 10:53:19 -0400
Received: by mail-ie0-f179.google.com with SMTP id rl12so3669832iec.38
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Sep 2014 07:53:18 -0700 (PDT)
Message-ID: <541C434F.4060500@gmail.com>
Date: Fri, 19 Sep 2014 10:53:03 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: =?UTF-8?B?SG9sZ2VyIEhvZmZzdMOkdHRl?=
	<holger.hoffstaette@googlemail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: Performance Issues
References: <1411129114.1811.7.camel@zarniwoop.blob> <pan.2014.09.19.13.51.22@googlemail.com>
In-Reply-To: <pan.2014.09.19.13.51.22@googlemail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms010801080905000400050801"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms010801080905000400050801
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-09-19 09:51, Holger Hoffst=C3=A4tte wrote:
>
> On Fri, 19 Sep 2014 13:18:34 +0100, Rob Spanton wrote:
>
>> I have a particularly uncomplicated setup (a desktop PC with a hard
>> disk) and I'm seeing particularly slow performance from btrfs.  A `git=

>> status` in the linux source tree takes about 46 seconds after dropping=

>> caches, whereas on other machines using ext4 this takes about 13s.  My=

>> mail client (evolution) also seems to perform particularly poorly on
>> this setup, and my hunch is that it's spending a lot of time waiting o=
n
>> the filesystem.
>
> This is - unfortunately - a particular btrfs oddity/characteristic/flaw=
,
> whatever you want to call it. git relies a lot on fast stat() calls,
> and those seem to be particularly slow with btrfs esp. on rotational
> media. I have the same problem with rsync on a freshly mounted volume;
> it gets fast (quite so!) after the first run.
I find that kind of funny, because regardless of filesystem, stat() is=20
one of the *slowest* syscalls on almost every *nix system in existence.
>
> The simplest thing to fix this is a "du -s >/dev/null" to pre-cache all=

> file inodes.
>
> I'd also love a technical explanation why this happens and how it could=

> be fixed. Maybe it's just a consequence of how the metadata tree(s)
> are laid out on disk.
While I don't know for certain, I think it's largely just a side effect=20
of the lack of performance tuning in the BTRFS code.
>
>> I've tried mounting with noatime, and this has had no effect.  Anyone
>> got any ideas?
>
> Don't drop the caches :-)
>
> -h




--------------ms010801080905000400050801
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIFuDCC
BbQwggOcoAMCAQICAw9gVDANBgkqhkiG9w0BAQ0FADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xNDA4
MDgxMTMwNDRaFw0xNTAyMDQxMTMwNDRaMGMxGDAWBgNVBAMTD0NBY2VydCBXb1QgVXNlcjEj
MCEGCSqGSIb3DQEJARYUYWhmZXJyb2luN0BnbWFpbC5jb20xIjAgBgkqhkiG9w0BCQEWE2Fo
ZW1tZWxnQG9oaW9ndC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDdmm8R
BM5D6fGiB6rpogPZbLYu6CkU6834rcJepfmxKnLarYUYM593/VGygfaaHAyuc8qLaRA3u1M0
Qp29flqmhv1VDTBZ+zFu6JgHjTDniBii1KOZRo0qV3jC5NvaS8KUM67+eQBjm29LhBWVi3+e
a8jLxmogFXV0NGej+GHIr5zA9qKz2WJOEoGh0EfqZ2MQTmozcGI43/oqIYhRj8fRMkWXLUAF
WsLzPQMpK19hD8fqwlxQWhBV8gsGRG54K5pyaQsjne7m89SF5M8JkNJPH39tHEvfv2Vhf7EM
Y4WGyhLAULSlym1AI1uUHR1FfJaj3AChaEJZli/AdajYsqc7AgMBAAGjggFZMIIBVTAMBgNV
HRMBAf8EAjAAMFYGCWCGSAGG+EIBDQRJFkdUbyBnZXQgeW91ciBvd24gY2VydGlmaWNhdGUg
Zm9yIEZSRUUgaGVhZCBvdmVyIHRvIGh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzAOBgNVHQ8BAf8E
BAMCA6gwQAYDVR0lBDkwNwYIKwYBBQUHAwQGCCsGAQUFBwMCBgorBgEEAYI3CgMEBgorBgEE
AYI3CgMDBglghkgBhvhCBAEwMgYIKwYBBQUHAQEEJjAkMCIGCCsGAQUFBzABhhZodHRwOi8v
b2NzcC5jYWNlcnQub3JnMDEGA1UdHwQqMCgwJqAkoCKGIGh0dHA6Ly9jcmwuY2FjZXJ0Lm9y
Zy9yZXZva2UuY3JsMDQGA1UdEQQtMCuBFGFoZmVycm9pbjdAZ21haWwuY29tgRNhaGVtbWVs
Z0BvaGlvZ3QuY29tMA0GCSqGSIb3DQEBDQUAA4ICAQCr4klxcZU/PDRBpUtlb+d6JXl2dfto
OUP/6g19dpx6Ekt2pV1eujpIj5whh5KlCSPUgtHZI7BcksLSczQbxNDvRu6LNKqGJGvcp99k
cWL1Z6BsgtvxWKkOmy1vB+2aPfDiQQiMCCLAqXwHiNDZhSkwmGsJ7KHMWgF/dRVDnsl6aOQZ
jAcBMpUZxzA/bv4nY2PylVdqJWp9N7x86TF9sda1zRZiyUwy83eFTDNzefYPtc4MLppcaD4g
Wt8U6T2ffQfCWVzDirhg4WmDH3MybDItjkSB2/+pgGOS4lgtEBMHzAGQqQ+5PojTHRyqu9Jc
O59oIGrTaOtKV9nDeDtzNaQZgygJItJi9GoAl68AmIHxpS1rZUNV6X8ydFrEweFdRTVWhUEL
70Cnx84YBojXv01LYBSZaq18K8cERPLaIrUD2go+2ffjdE9ejvYDhNBllY+ufvRizIjQA1uC
OdktVAN6auQob94kOOsWpoMSrzHHvOvVW/kbokmKzaLtcs9+nJoL+vPi2AyzbaoQASVZYOGW
pE3daA0F5FJfcPZKCwd5wdnmT3dU1IRUxa5vMmgjP20lkfP8tCPtvZv2mmI2Nw5SaXNY4gVu
WQrvkV2in+TnGqgEIwUrLVbx9G6PSYZZs07czhO+Q1iVuKdAwjL/AYK0Us9v50acIzbl5CWw
ZGj3wjGCA6EwggOdAgEBMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6
Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEh
MB8GCSqGSIb3DQEJARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwCQYFKw4DAhoFAKCCAfUw
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQwOTE5MTQ1MzAz
WjAjBgkqhkiG9w0BCQQxFgQUszknY/8F9DCKHtVuQzvShpo9pjwwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEA2hACnnNBhJRba9sSCp0cx6pAOQa9
dBEuYHDtOlv3/ECXoTV4miyeiLtHMPSTBBdnUXWXpj/IcQZvoB5d5Sesy1yXhMwuxuLrRd/e
WjVCVllv+kdvcjX9BjhOgvHxy/VCSrQYolK1xLvoZEohlpVdS4gWz7d+Io6qFAaMWD9zk/RK
xsOgBg96d7N35lyFvC3CxaiT8z8adwDEz9EMFPL5FvLZErt1ata1zC16jHBy7FBTCZmqaADs
04LmqFK0dW7zahQAqGBoS6PxN2XqcdIKolo/VPtp21wAmZVj91VFFZfELmvvsnX81lw78io5
TOwet76IBpZbwihxf40B5Oe4/AAAAAAAAA==
--------------ms010801080905000400050801--
