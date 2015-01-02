Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:47427 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbbABNm6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Jan 2015 08:42:58 -0500
Received: by mail-ie0-f172.google.com with SMTP id tr6so16771619ieb.3
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Jan 2015 05:42:57 -0800 (PST)
Message-ID: <54A6A05D.6000200@gmail.com>
Date: Fri, 02 Jan 2015 08:42:53 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: ashford@whisperpc.com, Phillip Susi <psusi@ubuntu.com>
CC: Jose Manuel Perez Bethencourt <jmperezbeth@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        "sys.syphus" <syssyphus@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: I need to P. are we almost there yet?
References: <CAAe=sHWT9G9PNYUh8yxG0dS7xCjy0Fhv03GATvkQHq64kM0oBA@mail.gmail.com>    <CAAe=sHUez9eNCSck5do7sBK=6nV1v9ZNNdqDVfnud1j5s1kJzQ@mail.gmail.com>    <CAJCQCtR=Hinq_w6ELXFT-Ema-5THoz5EpuXkCOU_fE1gv--+qQ@mail.gmail.com>    <7e0d08fddb1e0060f756690f6c82c350.squirrel@webmail.wanet.net>    <54A31CAE.4020606@ubuntu.com>    <40b56c60ddd4801295a92c4b11d5c08e.squirrel@webmail.wanet.net>    <54A3633C.3040609@ubuntu.com> <1da0cf9a75a357c960af323aa56c7530.squirrel@webmail.wanet.net>
In-Reply-To: <1da0cf9a75a357c960af323aa56c7530.squirrel@webmail.wanet.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms090909060005080709030506"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms090909060005080709030506
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-12-31 12:27, ashford@whisperpc.com wrote:
> Phillip
>
>> I had a similar question a year or two ago (
>> specifically about raid10  ) so I both experimented and read the code
>> myself to find out.  I was disappointed to find that it won't do
>> raid10 on 3 disks since the chunk metadata describes raid10 as a
>> stripe layered on top of a mirror.
>>
>> Jose's point was also a good one though; one chunk may decide to
>> mirror disks A and B, so a failure of A and C it could recover from,
>> but a different chunk could choose to mirror on disks A and C, so that=

>> chunk would be lost if A and C fail.  It would probably be nice if the=

>> chunk allocator tried to be more deterministic about that.
>
> I see this as a CRITICAL design flaw.  The reason for calling it CRITIC=
AL
> is that System Administrators have been trained for >20 years that RAID=
-10
> can usually handle a dual-disk failure, but the BTRFS implementation ha=
s
> effectively ZERO chance of doing so.
No, some rather simple math will tell you that a 4 disk BTRFS filesystem =

in raid10 mode has exactly a 50% chance of surviving a dual disk=20
failure, and that as the number of disks goes up, the chance of survival =

will asymptotically approach 100% (but never reach it).
This is the case for _every_ RAID-10 implementation that I have ever=20
seen, including hardware raid controllers; the only real difference is=20
in the stripe length (usually 512 bytes * half the number of disks for=20
hardware raid, 4k * half the number of disks for software raid, and the=20
filesystem block size (default is 16k in current versions) * half the=20
number of disks for BTRFS).



--------------ms090909060005080709030506
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwMTAyMTM0MjUz
WjAjBgkqhkiG9w0BCQQxFgQUwY+kR5DNss0pQrr+4fP3r8czymEwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAGBYEwV7FCG6JQjBWWbZLBJ6MuAdZ
bVXKyjmLiYkIqpnL42FGjrPCotMfm0DNwwon8TaR6enR/y5qxvId2h0ZUMtL4VU9J/Wfu7nr
xrRjKNpBaydnj+xHU+RumGS7rg5tzpoOlt6mkHyiuD5f1rYb8nmpvKUPzGxbCtAe2+bv2HNl
vOTRCNdHPkUUk55PnLRlyxf+ns9h8tV5KMkjLllIOTf20EtbDrf4TxCNyjj3oGvoZExs8WST
gWI84yRcHPjIy/h6xz2evQOeJsqj4Ys+UJEJ8R0vtqilr9xPZwIDHI3QFITU9YqcVRUGfC7o
DXSai3OaHv9YSiojuYOsYm1BiwAAAAAAAA==
--------------ms090909060005080709030506--
