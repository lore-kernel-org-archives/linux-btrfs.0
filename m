Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:35268 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495AbbLBOjR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Dec 2015 09:39:17 -0500
Received: by igl9 with SMTP id 9so111710448igl.0
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Dec 2015 06:39:16 -0800 (PST)
Subject: Re: compression disk space saving - what are your results?
To: Imran Geriskovan <imran.geriskovan@gmail.com>, linux-btrfs@vger.kernel.org
References: <4082684905f25f921ae4564b1c8a892e@admin.virtall.com>
 <pan$101f2$e235cddd$fea951cb$dcf70182@cox.net>
 <CAK5rZE6-SMfseAfEu1GxLrgYNOBMhNbiQ8tqWVWUr6dFDL8OKw@mail.gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <565F028C.6000707@gmail.com>
Date: Wed, 2 Dec 2015 09:39:08 -0500
MIME-Version: 1.0
In-Reply-To: <CAK5rZE6-SMfseAfEu1GxLrgYNOBMhNbiQ8tqWVWUr6dFDL8OKw@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms050101020009020604000701"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms050101020009020604000701
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-12-02 09:03, Imran Geriskovan wrote:
>>> What are your disk space savings when using btrfs with compression?
>
>> * There's the compress vs. compress-force option and discussion.  A
>> number of posters have reported that for mostly text, compress didn't
>> give them expected compression results and they needed to use compress=
-
>> force.
>
> "compress-force" option compresses regardless of the "compressibility"
> of the file.
>
> "compress" option makes some inference about the "compressibility"
> and decides to compress or not.
>
> I wonder how that inference is done?
> Can anyone provide some pseudo code for it?
I'm not certain how BTRFS does it, but my guess would be trying to=20
compress the block, then storing the uncompressed version if the=20
compressed one is bigger.

The program lrzip has an option to do per-block compression checks kind=20
of like this, but it's method is to try LZO compression on the block=20
(which is fast), and only use the selected compression method (bzip2 by=20
default I think, but it can also do zlib and xz) if the LZO compression=20
ratio is is good enough.  If we went with a similar method, I'd say we=20
should integrate LZ4 support first, and use that for the test.  I think=20
NTFS compression on Windows might do something similar, but they use an=20
old LZ77 derivative for their compression (I think it's referred to as=20
LZNT1, and it's designed for speed, and usually doesn't get much better=20
than a 30% compression ratio).

On a side note, I really wish BTRFS would just add LZ4 support.  It's a=20
lot more deterministic WRT decompression time than LZO, gets a similar=20
compression ratio, and runs faster on most processors for both=20
compression and decompression.


--------------ms050101020009020604000701
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMjAyMTQzOTA4WjBPBgkq
hkiG9w0BCQQxQgRA1gTXQSwqE3fFElaGgDu5Hu4Le/5goeTPXk2nu6PCIdztyvoXn0h+JM42
OX6F/omUoMfqLbgqLoojy16ZPTqq5DBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBxAU1jLAXE3NBlRsbs5kKk99oFFlBZ5R/VzSP/qX90YWsWp5Ln
5L+VYwV6/jn84JOFxzbkOwcIRxb08MmIFFivhIR2OrLrN48itDxByEnnqMPYHDMRxZvTIkB6
DQyCFycbxOtUaHHWA7xwZ4/1pjaH6AOo31AomtUtEKAVEU79RbkWN6sEYhKqpO81DBBMS1ss
Wba2/HhJuFtxoi7NY1rI38B6tq+U1GJM89n55SzbeIsJUEkWSyeLQNP6QXt+hEPQYTE2qPNe
oB92ehXbv69hC7uefp63+22hYHboOZvNWwef10DeaoD20ACZbXuQK2EkV+t+7tTLqbXOTlcC
Veory5P8F0o4bHfNroIdiT1Eg2q3I8U6LAvr0/T8mZibBnTKmZI/UwPxIdMb2aOyWBtxTWYl
YLp8qKzfJv6K1y0YvVo3cfyDM62j/wRZI1v1w/HvNRBaHQcfbqZcyVxA+q5nqybsS+OjQAIJ
WL5qeWtGnKo0yrX1hxVs0m9yzDixuDKOU4zVJwZ+uwSF18X4IpVOeua2tGWYTed2fMm0MKwT
0xKDD3NX4sIRWberlU/uaPVjJufXZUjY3DJgiQ1QEOc+QKCS4nHnXr7QvLkMAESZVQLfA9Hv
UBe5ZYgva4ZeZTxgzOn3eHg04Zc2ZOZBuseJ8GeGbVIbF4DTwRbCz6jJxQAAAAAAAA==
--------------ms050101020009020604000701--
