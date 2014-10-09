Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:57257 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbaJIMH5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Oct 2014 08:07:57 -0400
Received: by mail-oi0-f41.google.com with SMTP id u20so2246983oif.0
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Oct 2014 05:07:56 -0700 (PDT)
Message-ID: <54367A97.3080106@gmail.com>
Date: Thu, 09 Oct 2014 08:07:51 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: What is the vision for btrfs fs repair?
References: <54358C77.2070808@redhat.com> <54367193.6000202@gmail.com> <pan$3113d$a3bae425$2c8363e3$ea9c68d9@cox.net>
In-Reply-To: <pan$3113d$a3bae425$2c8363e3$ea9c68d9@cox.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms070703030404060201030901"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms070703030404060201030901
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-10-09 07:53, Duncan wrote:
> Austin S Hemmelgarn posted on Thu, 09 Oct 2014 07:29:23 -0400 as
> excerpted:
>
>> Also, you should be running btrfs scrub regularly to correct bit-rot
>> and force remapping of blocks with read errors.  While BTRFS
>> technically handles both transparently on reads, it only corrects thin=
g
>> on disk when you do a scrub.
>
> AFAIK that isn't quite correct.  Currently, the number of copies is
> limited to two, meaning if one of the two is bad, there's a 50% chance =
of
> btrfs reading the good one on first try.
>
> If btrfs reads the good copy, it simply uses it.  If btrfs reads the ba=
d
> one, it checks the other one and assuming it's good, replaces the bad o=
ne
> with the good one both for the read (which otherwise errors out), and b=
y
> overwriting the bad one.
>
> But here's the rub.  The chances of detecting that bad block are
> relatively low in most cases.  First, the system must try reading it fo=
r
> some reason, but even then, chances are 50% it'll pick the good one and=

> won't even notice the bad one.
>
> Thus, while btrfs may randomly bump into a bad block and rewrite it wit=
h
> the good copy, scrub is the only way to systematically detect and (if
> there's a good copy) fix these checksum errors.  It's not that btrfs
> doesn't do it if it finds them, it's that the chances of finding them a=
re
> relatively low, unless you do a scrub, which systematically checks the
> entire filesystem (well, other than files marked nocsum, or nocow, whic=
h
> implies nocsum, or files written when mounted with nodatacow or
> nodatasum).
>
> At least that's the way it /should/ work.  I guess it's possible that
> btrfs isn't doing those routine "bump-into-it-and-fix-it" fixes yet, bu=
t
> if so, that's the first /I/ remember reading of it.

I'm not 100% certain, but I believe it doesn't actually fix things on=20
disk when it detects an error during a read, I know it doesn't it the fs =

is mounted ro (even if the media is writable), because I did some=20
testing to see how 'read-only' mounting a btrfs filesystem really is.

Also, that's a much better description of how multiple copies work than=20
I could probably have ever given.



--------------ms070703030404060201030901
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQxMDA5MTIwNzUx
WjAjBgkqhkiG9w0BCQQxFgQUchf9MrA22W6JEFV2aOJpPcLxrekwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAv4ZKlwFcfN2WYQO2eFwpfhvYXoNH
TCchUBkKMWsYbawR6IuRoeG0WnFpz+yN2b/YtWIB/Tp8JGzd0clLeG19u/eJoAMvpx0yQYvw
Wwg5/WmWKNlG3M08tYLbQC5wJ/JCXbSpv9uIaRPPJm7DHukBlQPKbqn9SEU/xZnI6FBfK3Fx
u8Uwjn7BxqZekB8Kd12dsXOnbnXFA3q9wgmKiIsKXO8Zv/7rm5M+ZjKhq8YHS0LY1qCBH3rv
JcMxWyresqJIaiGchH92d83sMaNkUTu/4DfPXAuDVBCaehhRRKcDFAHpKAMyrd7WPC68LpFH
vY4AH1/4jzCsWG7Bfj08M+KI7wAAAAAAAA==
--------------ms070703030404060201030901--
