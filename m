Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:37075 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbbLDMdm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Dec 2015 07:33:42 -0500
Received: by igcto18 with SMTP id to18so34739901igc.0
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Dec 2015 04:33:42 -0800 (PST)
Subject: Re: compression disk space saving - what are your results?
To: Imran Geriskovan <imran.geriskovan@gmail.com>, linux-btrfs@vger.kernel.org
References: <4082684905f25f921ae4564b1c8a892e@admin.virtall.com>
 <pan$101f2$e235cddd$fea951cb$dcf70182@cox.net>
 <CAK5rZE6-SMfseAfEu1GxLrgYNOBMhNbiQ8tqWVWUr6dFDL8OKw@mail.gmail.com>
 <565F028C.6000707@gmail.com> <pan$6405b$7a197e29$8d0a71a9$2a5649b6@cox.net>
 <CAK5rZE6Y8Pa68yMDr-a-zNqFdb8VM+t9jv+HwxGck8SJ_vCR+A@mail.gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56618801.9060802@gmail.com>
Date: Fri, 4 Dec 2015 07:33:05 -0500
MIME-Version: 1.0
In-Reply-To: <CAK5rZE6Y8Pa68yMDr-a-zNqFdb8VM+t9jv+HwxGck8SJ_vCR+A@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms080007000901030109040608"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080007000901030109040608
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-12-03 07:09, Imran Geriskovan wrote:
>>> On a side note, I really wish BTRFS would just add LZ4 support.  It's=
 a
>>> lot more deterministic WRT decompression time than LZO, gets a simila=
r
>>> compression ratio, and runs faster on most processors for both
>>> compression and decompression.
>
> Relative ratios according to
> http://catchchallenger.first-world.info//wiki/Quick_Benchmark:_Gzip_vs_=
Bzip2_vs_LZMA_vs_XZ_vs_LZ4_vs_LZO
>
> Compressed size
> gzip (1) - lzo (1.4) - lz4 (1.4)
>
> Compression Time
> gzip (5) - lzo (1) - lz4 (0.8)
>
> Decompression Time
> gzip (9) - lzo (4) - lz4 (1)
>
> Compression Memory
> gzip (1) - lzo (2) - lz4 (20)
>
> Decompression Memory
> gzip (1) - lzo (2) - lz4 (130). Yes 130! not a typo.
>
> But there is a note:
> Note: lz4 it's the program using this size, the
> code for internal lz4 use very less memory.
>
> However, I could not find any better apples to apples
> comparison.
>
> If lz4's real memory consumption is in orders of lzo,
> than it looks good.
AFAICT, it's similar memory consumption.  I did some tests a while back=20
comparing the options for kernel image compression using a VM, and one=20
of the things I tested (although I can't for the life of me remember how =

exactly except that it involved using QEMU hooked up to GDB) was=20
run-time decompressor footprint.  LZO really should have a smaller=20
memory footprint too, it's just that lzop needs to handle almost a dozen =

different LZO compression formats.


--------------ms080007000901030109040608
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMjA0MTIzMzA1WjBPBgkq
hkiG9w0BCQQxQgRADs6bU59K/Sqdau+ZLURC1y6TRqZ/ImV1JrjhJCU+3nIy35aiRM3sztwV
wvIadAxTnsZbvHHujE3iIWNeefWbQDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgA5Z2UmXl9FfeuwEYeaWi7BCoSnBg1FZLHlwK/kBc0CW5KulQ4W
2zn0YuRqvrxPkcPlQGHjP9+NFQqmudvaybhK6Glv/ooxCt565OWA5WsBV7UXK69T0u6VW4bB
malPpqmfj6PXeyZ2YEySp88EgDPIxrrpEeCCgnYFmhRgxl1Oro0x6tZbUCBrMNceFtODkjJB
3ROlLLReFkP8V57O4PWuEwjog30sZ6f8CfhtQryU2ztyEkNSj1cu1pABVEZNSWvUuUlAMb8k
njhv3TXFZ9hgscEEYwMkEsGgPgWoZowf3wEH/A/aZcHXx1XLToup6VXHPxWyozLaD0ur3rf3
+Ew4+cxVfYmMf11ww8KtAii1dc7aohd3vosJmlL75g4SKxaZR2LtT8uH5UiWIEVlTgQE9+jo
k94UaQM8KAXKXyoGEikLVhiOVEZmU64AhOut7f6vTccIhzpmTkPRPv86Hjb33irdumhcaq9C
68HFzaFqnhWzo0g70NpUQgoDqsfJfXZSy4ldFyb2kUuXTj0jjuHM3CBUtk2pHPM0YLAdYTza
7S/CTCmDo9XMraNTbJM+R5uyN+DSXS643Noe8jhVy4dKbi5QBHyrkgfTMoZO47u3RrLxfH7J
VcvJgELswYcGFYjW/WB+C5GE1ly0jg0xnJObJL96XMCPnL60WeTfsERl8gAAAAAAAA==
--------------ms080007000901030109040608--
