Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:33068 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbaLARYm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 12:24:42 -0500
Received: by mail-ie0-f182.google.com with SMTP id x19so9814298ier.27
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 09:24:42 -0800 (PST)
Message-ID: <547CA452.6030009@gmail.com>
Date: Mon, 01 Dec 2014 12:24:34 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Roman Mamedov <rm@romanrm.net>, Marc MERLIN <marc@merlins.org>,
        Shriramana Sharma <samjnaa@gmail.com>
Subject: Re: Possible to undo subvol delete?
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>	<20141130042306.GE8916@merlins.org>	<547C6922.6030206@gmail.com>	<CAE8gLhmn3aX88t1FO2=BnHXk0-+2xQ4dnW57dga93iA-bFaUzQ@mail.gmail.com>	<20141201184749.0fd67b62@natsu> <CAE8gLhnyTWjfTk-W+BHdfovV8pJH-yqo7joR+kf6vgs1FU00hw@mail.gmail.com>
In-Reply-To: <CAE8gLhnyTWjfTk-W+BHdfovV8pJH-yqo7joR+kf6vgs1FU00hw@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms060905040208010604080905"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms060905040208010604080905
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-12-01 08:54, MegaBrutal wrote:
> 2014-12-01 14:47 GMT+01:00 Roman Mamedov <rm@romanrm.net>:
>> On Mon, 1 Dec 2014 14:38:16 +0100
>> MegaBrutal <megabrutal@gmail.com> wrote:
>>
>>> I've also noticed, a subvolume can just be deleted with an "rm -r",
>>> just like an ordinary directory. I'd consider to only allow subvolume=

>>> deletions with exact "btrfs subvolume delete" commands, and they
>>
>> This is already the case. 'rm -r' will remove all files in a subvolume=
, but
>> the empty subvolume itself is only deletable via the 'btrfs' command.
>
> That's great! And there is no way to protect against recursive
> deletions (besides setting the subvolume read-only, as you suggested
> below), as files are processes individually by "rm". But it's OK,
> people should always be very careful with "rm", and it doesn't change
> with btrfs. ;)
>
>
>> If you want to make snapshots which can't be removed by ordinary tools=
, use
>> the 'read-only' mode when creating them.
>
> Yeah, good idea! Anyway, is it possible to change a read-only snapshot
> to read-write and vica-versa, or you can only specify read-only while
> creating them?
>
IIRC, there is something that you can do with the properties interface.
Personally though, I just make the snapshot RW to start with, and then=20
recursively make it immutable (chattr -r +I), as I never use immutable=20
files for anything else, and it works on any _sane_ filesystem, not just =

btrfs.


--------------ms060905040208010604080905
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQxMjAxMTcyNDM0
WjAjBgkqhkiG9w0BCQQxFgQUmOuXaopcRbeiZr+Hya42pedrmqIwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAMoyyzdFfX/CfRus7Ioi77f4rKbq+
UGa57+QDf7D5tqJR8bmSg52QRbnDo0JklnnsKafUss2IpYXv5ZpOC09o5Oz0b4BRtD9yJeBL
VPsNeXl4GUiZPXPvAchHNvRrZdSOnJz5kBwmNWeUXoNd4ErlUUL/bR/8/RlnjoACc9UG9cuF
vFlZQEneXL+az8rPBjsKHol3JsTJeuwV5Lw0dxCHw4joK1Abv03nFqCDIgDpicnz/JfloGR2
a+WL+tbgdpc2xjeghE4YZ+2SEIDiUCY1/4owNEBajR2zo2Q61vjcQrS5BGUVJfknG4zRi5XY
uKN5QFbvfJ9yWvFJFih4XSFTNwAAAAAAAA==
--------------ms060905040208010604080905--
