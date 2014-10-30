Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:63957 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932936AbaJ3MA5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Oct 2014 08:00:57 -0400
Received: by mail-ig0-f180.google.com with SMTP id h3so4967505igd.7
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Oct 2014 05:00:56 -0700 (PDT)
Message-ID: <54522876.5030607@gmail.com>
Date: Thu, 30 Oct 2014 08:00:54 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: luvar@plaintext.sk, linux-btrfs@vger.kernel.org
Subject: Re: btrfs deduplication and linux cache management
References: <650272300.271414661167523.JavaMail.root@shiva>
In-Reply-To: <650272300.271414661167523.JavaMail.root@shiva>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms080708080307010201060608"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080708080307010201060608
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-10-30 05:26, luvar@plaintext.sk wrote:
> Hi,
> I want to ask, if deduplicated file content will be cached in linux ker=
nel just once for two deduplicated files.
>
> To explain in deep:
>   - I use btrfs for whole system with few subvolumes with some compress=
ion on some subvolumes.
>   - I have two directories with eclipse SDK with slightly differences (=
same version, different config)
>   - I assume that given directories is deduplicated and so two eclipse =
installations take place on hdd like one would (in rough estimation)
>   - I will start one of given eclipse
>   - linux kernel will cache all opened files during start of eclipse (I=
 have enough free ram)
>   - I am just happy stupid linux user:
>      1. will kernel cache file content after decompression? (I think ye=
s)
>      2. cached data will be in VFS layer or in block device layer?
>   - When I will lunch second eclipse (different from first, but dedupli=
cated from first) after first one:
>      1. will second start require less data to be read from HDD?
>      2. will be metadata for second instance read from hdd? (I asume ye=
s)
>      3. will be actual data read second time? (I hope not)
>
> Thanks for answers,
> have a nice day,

I don't know for certain, but here is how I understand things work in=20
this case:
1. Individual blocks are cached in the block device layer, which means=20
that the de-duplicated data would only be cached at most as many times=20
as there are disks it is on (ie at most 1 time for a single device=20
filesystem, up to twice for a multi-device btrfs raid1 setup).
2. In the vfs layer, the cache handles decoded inodes (the actual file=20
metadata), dentries (the file's entry in the parent directory), and=20
individual pages of file content (after decompression).  AFAIK, the vfs=20
layer's cache is pathname based, so that would probably cache two copies =

of the data, but after the metadata look-up, wouldn't need to read from=20
the disk cause of the block layer cache.

Overall, this means that while de-duplicated data may be cached more=20
than once, it shouldn't need to be reread from disk if there is still a=20
copy in cache.  Metadata may or may not need to be read from the disk,=20
depending on what is in the VFS cache.


--------------ms080708080307010201060608
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQxMDMwMTIwMDU0
WjAjBgkqhkiG9w0BCQQxFgQUO5DvGvqCArrB4r1GiXLrHbJhHBYwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAqRt45nBO4kSqO8p8LG2AQF0JAu05
j/oybiWywZrJZCBtkOljpE2NNLFZ34solHhFq64IfH9vcxU2f4sbY0y6A4uhkquzfPFcz6zy
5UfSnfWlZIsdeElty38ghD1u424FWMUP3sCImBZcKRCxnVLUIE93qFvf0Naa4YILiUL0kJdG
aCofFTxEZk4Orpuaq8nITPAN1PpRtDgav4qhnshQEj1XcNkL5Eate5S8d3iTF1CjwXhLwFMN
s9PwcZfwepcDLw9MpXneIAwR1oVCyXQU8W3wYQ4mA0G/vosimq15vDCY3HyYcyuy5BiGD/+F
mio2jHsZrAT/dE3kwYrr0TAFmAAAAAAAAA==
--------------ms080708080307010201060608--
