Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:36622 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbbLDMi1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Dec 2015 07:38:27 -0500
Received: by igcph11 with SMTP id ph11so31862439igc.1
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Dec 2015 04:38:26 -0800 (PST)
Subject: Re: compression disk space saving - what are your results?
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <4082684905f25f921ae4564b1c8a892e@admin.virtall.com>
 <pan$101f2$e235cddd$fea951cb$dcf70182@cox.net>
 <CAK5rZE6-SMfseAfEu1GxLrgYNOBMhNbiQ8tqWVWUr6dFDL8OKw@mail.gmail.com>
 <565F028C.6000707@gmail.com> <pan$6405b$7a197e29$8d0a71a9$2a5649b6@cox.net>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <5661891E.40600@gmail.com>
Date: Fri, 4 Dec 2015 07:37:50 -0500
MIME-Version: 1.0
In-Reply-To: <pan$6405b$7a197e29$8d0a71a9$2a5649b6@cox.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms080608000407070609080105"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080608000407070609080105
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-12-03 01:29, Duncan wrote:
> Austin S Hemmelgarn posted on Wed, 02 Dec 2015 09:39:08 -0500 as
> excerpted:
>
>> On 2015-12-02 09:03, Imran Geriskovan wrote:
>>>>> What are your disk space savings when using btrfs with compression?=

>>>
>>>> [Some] posters have reported that for mostly text, compress didn't
>>>> give them expected compression results and they needed to use
>>>> compress-force.
>>>
>>> "compress-force" option compresses regardless of the "compressibility=
"
>>> of the file.
>>>
>>> "compress" option makes some inference about the "compressibility" an=
d
>>> decides to compress or not.
>>>
>>> I wonder how that inference is done?
>>> Can anyone provide some pseudo code for it?
>
>> I'm not certain how BTRFS does it, but my guess would be trying to
>> compress the block, then storing the uncompressed version if the
>> compressed one is bigger.
>
> No pseudocode as I'm not a dev and wouldn't want to give the wrong
> impression, but as I believe I replied recently in another thread, base=
d
> on comments the devs have made...
>
> With compress, btrfs does a(n intended to be fast) trial compression of=

> the first 128 KiB block or two and uses the result of that to decide
> whether to compress the entire file.
>
> Compress-force simply bypasses that first decision point, processing th=
e
> file as if the test always succeeded and compression was chosen.
>
> If the decision to compress is made, the file is (evidently, again, not=
 a
> dev, but filefrag results support) compressed a 128 KiB block at a time=

> with the resulting size compared against the uncompressed version, with=

> the smaller version stored.
>
> (Filefrag doesn't understand btrfs compression and reports individual
> extents for each 128 KiB compression block, if compressed.  However, fo=
r
> many files processed with compress-force, filefrag doesn't report the
> expected size/128-KiB extents, but rather something lower.  If
> filefrag -v is used, details of each "extent" are listed, and some show=

> up as multiples of 128 KiB, indicating runs of uncompressable blocks th=
at
> unlike actually compressed blocks, filefrag can and does report correct=
ly
> as single extents.  The conclusion is thus as above, that btrfs is
> testing the compression result of each block, and not compressing if th=
e
> "compression" ends up being negative, that is, if the "compressed" size=

> is larger than the uncompressed size.)
>
>> On a side note, I really wish BTRFS would just add LZ4 support.  It's =
a
>> lot more deterministic WRT decompression time than LZO, gets a similar=

>> compression ratio, and runs faster on most processors for both
>> compression and decompression.
>
> There were patches (at least RFC level, IIRC) floating around years ago=

> to add lz4... I wonder what happened to them?  My impression was that a=

> large deployment somewhere may actually be running them as well, making=

> them well tested (and obviously well beyond preliminary RFC level) by
> now, altho that impression could well be wrong.
>
Hmm, I'll have to see if I can find those and rebase them.  IIRC, the=20
argument against adding it was 'but we already have a fast compression=20
algorithm!', which in turn says to me they didn't try to sell it on the=20
most significant parts, namely that it's faster at decompression than=20
LZO (even when you use the lz4hc variant, which takes longer to compress =

to give a (usually) better compression ratio, but decompresses just as=20
fast as regular lz4), and the timings are a lot more deterministic=20
(which is really important if you're doing real-time stuff).


--------------ms080608000407070609080105
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgMFADCABgkqhkiG9w0BBwEAAKCC
Brgwgga0MIIEnKADAgECAgMRLfgwDQYJKoZIhvcNAQENBQAweTEQMA4GA1UEChMHUm9vdCBD
QTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNp
Z25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcwHhcN
MTUwOTIxMTEzNTEzWhcNMTYwMzE5MTEzNTEzWjBjMRgwFgYDVQQDEw9DQWNlcnQgV29UIFVz
ZXIxIzAhBgkqhkiG9w0BCQEWFGFoZmVycm9pbjdAZ21haWwuY29tMSIwIAYJKoZIhvcNAQkB
FhNhaGVtbWVsZ0BvaGlvZ3QuY29tMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA
nQ/81tq0QBQi5w316VsVNfjg6kVVIMx760TuwA1MUaNQgQ3NyUl+UyFtjhpkNwwChjgAqfGd
LIMTHAdObcwGfzO5uI2o1a8MHVQna8FRsU3QGouysIOGQlX8jFYXMKPEdnlt0GoQcd+BtESr
pivbGWUEkPs1CwM6WOrs+09bAJP3qzKIr0VxervFrzrC5Dg9Rf18r9WXHElBuWHg4GYHNJ2V
Ab8iKc10h44FnqxZK8RDN8ts/xX93i9bIBmHnFfyNRfiOUtNVeynJbf6kVtdHP+CRBkXCNRZ
qyQT7gbTGD24P92PS2UTmDfplSBcWcTn65o3xWfesbf02jF6PL3BCrVnDRI4RgYxG3zFBJuG
qvMoEODLhHKSXPAyQhwZINigZNdw5G1NqjXqUw+lIqdQvoPijK9J3eijiakh9u2bjWOMaleI
SMRR6XsdM2O5qun1dqOrCgRkM0XSNtBQ2JjY7CycIx+qifJWsRaYWZz0aQU4ZrtAI7gVhO9h
pyNaAGjvm7PdjEBiXq57e4QcgpwzvNlv8pG1c/hnt0msfDWNJtl3b6elhQ2Pz4w/QnWifZ8E
BrFEmjeeJa2dqjE3giPVWrsH+lOvQQONsYJOuVb8b0zao4vrWeGmW2q2e3pdv0Axzm/60cJQ
haZUv8+JdX9ZzqxOm5w5eUQSclt84u+D+hsCAwEAAaOCAVkwggFVMAwGA1UdEwEB/wQCMAAw
VgYJYIZIAYb4QgENBEkWR1RvIGdldCB5b3VyIG93biBjZXJ0aWZpY2F0ZSBmb3IgRlJFRSBo
ZWFkIG92ZXIgdG8gaHR0cDovL3d3dy5DQWNlcnQub3JnMA4GA1UdDwEB/wQEAwIDqDBABgNV
HSUEOTA3BggrBgEFBQcDBAYIKwYBBQUHAwIGCisGAQQBgjcKAwQGCisGAQQBgjcKAwMGCWCG
SAGG+EIEATAyBggrBgEFBQcBAQQmMCQwIgYIKwYBBQUHMAGGFmh0dHA6Ly9vY3NwLmNhY2Vy
dC5vcmcwMQYDVR0fBCowKDAmoCSgIoYgaHR0cDovL2NybC5jYWNlcnQub3JnL3Jldm9rZS5j
cmwwNAYDVR0RBC0wK4EUYWhmZXJyb2luN0BnbWFpbC5jb22BE2FoZW1tZWxnQG9oaW9ndC5j
b20wDQYJKoZIhvcNAQENBQADggIBADMnxtSLiIunh/TQcjnRdf63yf2D8jMtYUm4yDoCF++J
jCXbPQBGrpCEHztlNSGIkF3PH7ohKZvlqF4XePWxpY9dkr/pNyCF1PRkwxUURqvuHXbu8Lwn
8D3U2HeOEU3KmrfEo65DcbanJCMTTW7+mU9lZICPP7ZA9/zB+L0Gm1UNFZ6AU50N/86vjQfY
WgkCd6dZD4rQ5y8L+d/lRbJW7ZGEQw1bSFVTRpkxxDTOwXH4/GpQfnfqTAtQuJ1CsKT12e+H
NSD/RUWGTr289dA3P4nunBlz7qfvKamxPymHeBEUcuICKkL9/OZrnuYnGROFwcdvfjGE5iLB
kjp/ttrY4aaVW5EsLASNgiRmA6mbgEAMlw3RwVx0sVelbiIAJg9Twzk4Ct6U9uBKiJ8S0sS2
8RCSyTmCRhJs0vvva5W9QUFGmp5kyFQEoSfBRJlbZfGX2ehI2Hi3U2/PMUm2ONuQG1E+a0AP
u7I0NJc/Xil7rqR0gdbfkbWp0a+8dAvaM6J00aIcNo+HkcQkUgtfrw+C2Oyl3q8IjivGXZqT
5UdGUb2KujLjqjG91Dun3/RJ/qgQlotH7WkVBs7YJVTCxfkdN36rToPcnMYOI30FWa0Q06gn
F6gUv9/mo6riv3A5bem/BdbgaJoPnWQD9D8wSyci9G4LKC+HQAMdLmGoeZfpJzKHMYIE0TCC
BM0CAQEwgYAweTEQMA4GA1UEChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNl
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMjA0MTIzNzUwWjBPBgkq
hkiG9w0BCQQxQgRAxdz+M77vbR9pWNcJaMXmTlilzAsTJHdpkrDbgDFweno87zQBQAigfg2w
q08Dp0iz8cx0g/s7uVwBrw6IAuq2MzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBO9MR8xHy+T0g6BD3C2hv/dUIegSsvKWVN5GcnoWR23YVEO3a8
jvCJAWBcIyZUV+TH5Htrhi1RvAIQsAUWNyfwZPMq6nzAkNjgR0IZHM6BuQOh2vlCRacQb7bo
iTSbeXy9rUM0qZkpdmO4ZtoTzQhjyjpvvTMzo8TmjXPjzUOWTRPGVrGCvP/wWtbWsyPL+uOP
hx8zR+FtcdN5GbgPGpNC0CH09GVjLfQ0jY+uWW1mrrwNGrsUbnG8snhe4cu+CoPbeYwcEQH0
T1KGHSOWMfWMH35Run5wOh+TNfQbamcq992aCxNCuBYQoku0o/1oc7bJJB10Nyd/IMH761RC
Xi/2s9A0kTOvXYH7PVZTroVgyzrMxUZ3Tj/Y48QTw2u9F4HZqugNIWkz079Rw7XRr6lBNLHa
Qlnr57C2qyiOeAb3x7wMuoLYZhGE9rX0KYNgttzGoSCCcEwg5wrigigixkmH+eVzPBH8nych
wptwWFplAUcp7AUStpw1nnG6qNhFF/PGjJ8HBeElpM0/wV1gcAl6E0B4w3rVFleRF22Rpil0
2jnj8dzg1dD2lZ4g4uKgWN2rW+jGMUep/3YMIqahi46/3aVDR6c7q5zF7a0/i8MFtJQFhb/V
pwVdAtez1QHdf3EOof4NLIiJDXIP9RiHqka/yr62u6VjQvuvA8XrIplwdgAAAAAAAA==
--------------ms080608000407070609080105--
