Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:34822 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200AbbHaTUL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 15:20:11 -0400
Subject: Re: [PATCH] generic/224: Increase filesystem instance size to 1.5 GiB
To: "Theodore Ts'o" <tytso@mit.edu>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>
References: <1440945981-323-1-git-send-email-chandan@linux.vnet.ibm.com>
 <20150831181127.GB7642@thunk.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, chandan@mykolab.com
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55E4A8BA.2050908@gmail.com>
Date: Mon, 31 Aug 2015 15:19:22 -0400
MIME-Version: 1.0
In-Reply-To: <20150831181127.GB7642@thunk.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms010405010803090402020308"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms010405010803090402020308
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-08-31 14:11, Theodore Ts'o wrote:
> On Sun, Aug 30, 2015 at 08:16:21PM +0530, Chandan Rajendra wrote:
>> For small filesystem instances (i.e. size <=3D 1 GiB), mkfs.btrfs fail=
s when
>> "data block size" does not match with the "metadata block size" specif=
ied on
>> the mkfs.btrfs command line. This commit increases the size of filesys=
tem
>> instance created so that the test can be executed on subpagesize-block=
size
>> Btrfs instances which have different values for data and metadata bloc=
ksizes.
>
> Stupid question --- why isn't this considered a bug in mkfs.btrfs?
> Does btrfs simply not support file systems <=3D 1 GB?  So if someone ha=
s
> a 1GB USB disk or SD card, what's the official advice from the btrfs
> developers?  Use xfs or ext4?
AFAIK, it shouldn't be failing that way, and should automatically switch =

to mixed mode allocation.  A 1G filesystem should work fine for BTRFS,=20
but smaller ones will have higher chances of ENOSPC issues (inversely=20
proportional to the size of the FS).  I would advise against using BTRFS =

on such a small disk (I avoid using it on anything smaller than 4G=20
personally), but I'm not one of the developers, and the fact that I feel =

it isn't a good idea doesn't mean it shouldn't work.



--------------ms010405010803090402020308
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwODMxMTkxOTIyWjBPBgkq
hkiG9w0BCQQxQgRAqNvL/rx0lygj5IWLa/Cye8fXe/NJPjBNwAqopjeSZQRwMYb6f/GTqJyM
VQDyAdhE9KbiQMRAjZrzYXvURlQzCTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgCQNxF8z1UffWTiqZ0t/LD/RzuWTLuNP305E/zjsNzprMHLOtWb
sgBGFdaGw40BESN6mXDit1nmLYsffkZwrESTQWJQ8OsSz0xG2IZrQgPWIgIte5cXcKZIFADe
ZaG38/ugUA9O0OCVHEeYDwwDcM61xXu4sFLVmE6GwveQmQ8rY8+aYug/gcxMpvXECQsfLbKM
Yy4qrL0B8a4R+xAiX7aShjVyhrGcfnbrj/mqfaBxCGVGfA0Sp7YFlHe4hAMymU/mP81Dzbd0
n/kPJW4HD2CBYw0Y7J0mB5A9UEsS7YFcUbTq12fNZwsFiA2E7dPpw465AEXWPj3YbsxKKwI6
Z7E69p8dNsy1fvkZYUKK+akNHORNvahtbRgP8Ske/bd8RUO38y50MP2issiM1PZYbGzMWocn
jQ0JHLARBqf7Y6GtwCCQh8+9/JGxCpazTELfhPgFQj8I2vDP3bJSx+zsbD8yWtW3i8RT1t2k
h9vrFdv27e+iuw0zt6aF5tBkQe1NVuDXxJV6zDxqWBZTlorbUcPcSakBMb3ADYbraTtnnzJy
oJ+9axmKj9mhs9Bd+4eRbky7KQI9ysMpP2Ym5EdAX9WcxhSVWT+fGExaUCgKehkW33FtXfnJ
dgOty1aD5ETs4xXS6NUPFbkBaJTGvQ4MzxBWpvvr0w4MSHNWGlLgtWQ+ywAAAAAAAA==
--------------ms010405010803090402020308--
