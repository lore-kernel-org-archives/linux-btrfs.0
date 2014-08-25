Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:44100 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151AbaHYLmp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Aug 2014 07:42:45 -0400
Received: by mail-ig0-f180.google.com with SMTP id l13so2615023iga.13
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Aug 2014 04:42:44 -0700 (PDT)
Message-ID: <53FB212E.8070208@gmail.com>
Date: Mon, 25 Aug 2014 07:42:38 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: superblock checksum mismatch after crash, cannot mount
References: <9896671408899573@web11g.yandex.ru> <401C8BD0-BE70-4FDF-A37A-D65D131E8843@colorremedies.com>
In-Reply-To: <401C8BD0-BE70-4FDF-A37A-D65D131E8843@colorremedies.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms020309000709020709050901"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020309000709020709050901
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2014-08-24 15:48, Chris Murphy wrote:
>=20
> On Aug 24, 2014, at 10:59 AM, Flash ROM <flashromguru@yandex.com> wrote=
:
>> While it sounds dumb, this strange thing being done to put partition t=
able in separate erase block, so it never read-modify-written when FAT en=
tries are updated. Should something go wrong, FAR can recover from backup=
 copy. But erased partition table just suxx. Then, FAT tables are aligned=
 in way to fit well around erase block bounds.
>=20
> I think you seriously overestimate the knowledge of camera manufacturer=
's about the details of flash storage; and any ability to discover it; an=
d any willingness on the part of the flash manufacturer to reveal such un=
derlying details. The whole point of these cards is to completely abstrac=
t the reality of the underlying hardware from the application layer - in =
this case the camera or mobile device using it.
>=20
If you really know what you are doing, it is possible to determine erase
block size by looking at device performance timings, with surprisingly
high accuracy (assuming you aren't trying to have software do it for
you).  I've actually done this before on several occasions, with nearly
100% success.
> Also, with SDXC exFAT is now specified. And it has only one FAT there i=
sn't a backup FAT. So they're even more difficult to recover data from sh=
ould things go awry filesystem wise.
>=20
It's too bad that TFAT didn't catch on, as it would have been great for
SD cards if it could be configured to put each FAT on a different erase
block.
>=20
>> This said, you can *try* to reformat, BUT no standard OS of firmware f=
ormatter will help you with default settings. They can't know geometry of=
 underlying NAND and controller properties. There is no standard, widely =
accepted way to get such information from card. No matter if you use OS f=
ormatter, camera formatter or whatever. YOU WILL RUIN factory format (whi=
ch is crafted in best possible way) and replace it with another, very lik=
ely suboptimal one.
>=20
> It's recommended by the card manufacturers to reformat it in each camer=
a its inserted into. It's the only recommended way to "erase" the sd card=
 for re-use, they don't recommend selectively deleting images. And it's k=
nown that one camera's partition table and formatting can irritate anothe=
r camera make/model if the card isn't reformatted by that camera.
>=20
It's not just cameras that have this issue, a lot of other hardware
makes stupid assumptions about the format of media.  The first firmware
release for the Nintendo Wii for example, chocked if you tried to use an
SD card with more than one partition on it, and old desktop versions of
Windows won't ever show you anything other than the first partition on
an SD card (or most USB storage devices for that matter).



--------------ms020309000709020709050901
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQwODI1MTE0MjM4
WjAjBgkqhkiG9w0BCQQxFgQUqqgzaN2oejnuukJI5KwOup5luj4wbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAyJkbIHEyqfJ3Obm/lTF46gpfwiSD
9u4RriuJsljj/NZ0fwZXAX6WaJMP9pW1jEt2uQJHIrl6S9Pf0H56J3Wo5G2e1PhA0ZQNJHlR
VK3+ZBGlz8M6f1Jwv69G4np6xlm0tOjusntJEe5ZQwYFfgB9H1knwjnX6nzy1knMsaRmER99
XqWbyrlKkIze7vRRkvl9D/oxePTzD1gfUxKBiRZGn1vvg/86ehgpyxdZX7g5vwn7OtEGN4xQ
Y7gwIXAjXPj8Z8vMLURVxRTGigh4kqnFoqXXylGKdFxfLbmEIrbXL89Ug/1uSKtp8Hte3MnV
Z4FK7FoqXVu2PqPsntBB7taTRwAAAAAAAA==
--------------ms020309000709020709050901--
