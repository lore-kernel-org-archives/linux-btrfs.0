Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:46398 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139AbaLARmR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 12:42:17 -0500
Received: by mail-ie0-f176.google.com with SMTP id tr6so9533681ieb.7
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 09:42:16 -0800 (PST)
Message-ID: <547CA870.9040904@gmail.com>
Date: Mon, 01 Dec 2014 12:42:08 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: John Williams <jwilliams4200@gmail.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com>	<20141125163905.GJ26471@twin.jikos.cz>	<m5dash$58v$1@ger.gmane.org>	<CAJBj3vd5tY93jkN7S25Am=c1A5iW=msqFDrOe-i9vYx9Phxwcg@mail.gmail.com>	<m5dcia$tk8$1@ger.gmane.org>	<CAJBj3ve8rfdAVLNwQ0ZxD8nQ3+5TwtTYXZ6BOMK0NquzHK15WA@mail.gmail.com>	<547C618C.8020201@gmail.com> <CAJBj3vfvBd5robRak1j-q0qGVT46BTR6VM=SRg5S-2p8GxjX6A@mail.gmail.com>
In-Reply-To: <CAJBj3vfvBd5robRak1j-q0qGVT46BTR6VM=SRg5S-2p8GxjX6A@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms020404040508070205060401"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020404040508070205060401
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-12-01 12:22, John Williams wrote:
> On Mon, Dec 1, 2014 at 4:39 AM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>
>> Just because it's a filesystem doesn't always mean that speed is the m=
ost
>> important thing.  Personally, I can think of multiple cases where usin=
g a
>> cryptographically strong hash would be preferable, for example:
>>   * On an fs used solely for backup purposes
>>   * On a fs used for /boot
>>   * On an fs spread across a very large near-line disk array and mount=
ed
>>     by a system with a powerful CPU
>>   * Almost any other case where data integrity is more important than
>>     speed
>
> What does data integrity have to do with whether the hash is
> cryptographic or not? The primary difference between a cryptographic
> and non-cryptographic hash is that the non-cryptographic hash can be
> easily guessed / predicted (eg., an attack to deliberately create
> collisions) whereas the cryptographic hash cannot (given reasonable
> assumptions of CPU power).
>
> For filesystem checksums it is difficult to imagine a deliberate
> attack on the checksums. Consequently, the only really important
> quality for the hash besides speed is collision resistance. The
> non-crypto hashes that I have mentioned in this thread have excellent
> collision resistant properties.
I'm not saying they don't have excellent collision resistance=20
properties.  I'm also not saying that we shouldn't support such=20
non-cryptographic hashes, just that we shouldn't explicitly NOT support=20
other hashes, and that if we are going to support more than one hash=20
algorithm, we should use the infrastructure already in place in the=20
kernel for such things because it greatly simplifies maintaining the code=
=2E

In fact, if I had the time, I'd just write CryptoAPI implementations of=20
those hashes myself.
>
>> The biggest reason to use the in-kernel Crypto API though, is that it =
gives
>> a huge amount of flexibility, and provides pretty much transparent
>> substitution of CPU optimized versions of the exported hash functions =
(for
>> example, you don't have to know whether or not your processor supports=

>> Intel's CRC32 ISA extensions).
>
> Which is worse than useless if the CPU-optimized crypto hash is slower
> than the default non-crypto hash, and that will almost always be the
> case. Besides, there is nothing magic happening in the Crypto API
> library. If you implement your own hash, you can easily do a few
> checks and choose the best code for the CPU.
>
Except most of the CPU optimized hashes aren't crypto hashes (other than =

the various SHA implementations).  Furthermore, I've actually tested the =

speed of a generic CRC32c implementation versus SHA-1 using the SHA=20
instructions on an UltraSPARC processor, and the difference ammounts to=20
a few microseconds in _favor_ of the optimized crypto hash; and I've run =

the math for every other ISA that has instructions for computing SHA=20
hashes (I don't have the hardware for any of the others), and expect=20
similar results for those as well.



--------------ms020404040508070205060401
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQxMjAxMTc0MjA4
WjAjBgkqhkiG9w0BCQQxFgQUccLQ2KBd/lhpi1egp2Mt7LRhu4IwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAMDI2lbsuvUmBVPZNbWqYDcCd1c2W
LQR+kRz/gHnY7pZwKLlTHnWv7kNXFDGQO1QxwkEWFba3td9h+M2J1Eqx1dk7/dEnLbL93xXW
EwE+WC9gLw2ySDzB8YaEG08zAiBMGsPYDlU8oM2WiGGnPQf3bca3YLdC5HfH/vEz0iSfs2e8
yCewGlCVPpm28L4Jyeoq98VR3yUsr83Cf/p/cvlvpPk8MN8OIsjFLtKG/5yCDUHkGCpHNztj
UjZSLJO//Djo8APBzG2QniyCrrGBSxTr7c0hojZXxnU0eY+mEQomfJo6eOIpjOc1NAV6cR7O
v++dzF09Oovi5WxgBJVcAjkxIAAAAAAAAA==
--------------ms020404040508070205060401--
