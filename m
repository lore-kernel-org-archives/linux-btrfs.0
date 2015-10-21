Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:34839 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbbJUMHz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 08:07:55 -0400
Received: by iofz202 with SMTP id z202so54478753iof.2
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2015 05:07:54 -0700 (PDT)
Subject: Re: Expected behavior of bad sectors on one drive in a RAID1
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <CA+X5Wn6Wu3RfX6rM6fpp9b4ZQQNm5WCbSOzxyOnE=+jDb0xDoA@mail.gmail.com>
 <201510201545.50705.russell@coker.com.au> <56263B0B.4050502@gmail.com>
 <201510210015.54337.russell@coker.com.au> <562648B5.2020401@gmail.com>
 <pan$6a87$d56eafce$4f04d0c$30b17c06@cox.net> <56269D1C.5080006@gmail.com>
 <56277C4A.70300@gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56278012.2060206@gmail.com>
Date: Wed, 21 Oct 2015 08:07:46 -0400
MIME-Version: 1.0
In-Reply-To: <56277C4A.70300@gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms060808080103060108060701"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms060808080103060108060701
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-21 07:51, Austin S Hemmelgarn wrote:
> On 2015-10-20 15:59, Austin S Hemmelgarn wrote:
>> On 2015-10-20 15:20, Duncan wrote:
>>> Yes, there's some small but not infinitesimal chance the checksum may=
 be
>>> wrong, but if there's two copies of the data and the checksum on one =
is
>>> wrong while the checksum on the other verifies... yes, there's still
>>> that
>>> small chance that the one that verifies is wrong too, but that it's a=
ny
>>> worse than the one that does not verify?  /That's/ getting close to
>>> infinitesimal, or at least close enough for the purposes of a mailing=
-
>>> list claim without links to supporting evidence by someone who has
>>> already characterized it as not mathematically rigorous... and for me=
,
>>> personally.  I'm not spending any serious time thinking about getting=

>>> hit
>>> by lightening, either, tho by the same token I don't go out flying ki=
tes
>>> or waving long metal rods around in lightning storms, either.
>> With a 32-bit checksum and a 4k block (the math is easier with smaller=

>> numbers), that's 4128 bits, which means that a random single bit error=

>> will have a approximately 0.24% chance of occurring in a given bit,
>> which translates to an approximately 7.75% chance that it will occur i=
n
>> one of the checksum bits.  For a 16k block it's smaller of course
>> (around 1.8% I think, but that's just a guess), but it's still
>> sufficiently statistically likely that it should be considered.
> As mentioned in my other reply to this, I did the math wrong (bit of a
> difference between kilobit and kilobyte)
And I realize of course right after sending this that my other reply=20
didn't get through because GMail refuses to send mail in plain text, no=20
matter how hard I beat it over the head...



--------------ms060808080103060108060701
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
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDIxMTIwNzQ2WjBPBgkq
hkiG9w0BCQQxQgRASiubXVpn/xBMB+daKDM4rG888wR+0KNQWgWFWI2/z25Dy/zPz8jM763h
gnts8RMJLobHfAQ6PnDi6NOCEUX4ZTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgAzAQ+yCcuZBvJyv+38+cbGOkeSRJrU4iEpU3Pby2nM77Sq7cyy
Pq+C+BTPMbHExfwzlawqP4mfO+An0yoAJ8xOEiaiU1+erjLoc8+6k3HX+Dwq9HE6Obr8IoX1
/rQWtzAjE8OI8Pjd6jXmUewrn7GjwfwYoTykU+pnKTleqTSr6wWKibxPgcUwKCV7ShpE7E8K
k0xHacTjTOGnnaHDwAFHS86yyvhpO9xRQIA9ZzCO+/L5fden9gzr6qKm5YAd5SskWS69Lm4k
2dPUGbxNrX9Xp+9AbvZHn29mD0WUbZHVk7+3hdab+RsnUt3dFRs7wjM46SqNXlSOvduDr5mr
kfNJptrN8svKUuks2YdHsLJBUfBFh4HkuIvF3THaWVNhgC4Mk+/IPNNV3I9QwHi5s9XagnGq
XVQA4RBJRauPhmr0vZGTQO6UpTjT0DB/osJSjZdgJNqgJJaJhL7UBGb2KpQURxJTGU80Fipd
mEbVDMLyIAev3lofuLB5NvREJSqEgGr7RrQMEzcQNfDCXjAN4jYryNlB+LX6vFwyIJDoQWe2
IaVNZdJUVM1NTHwcHwc3e0Rnv5XrXUNbUxXoNUCsUJhuTX3Xthj+D6RPQv7aT0TZ3me1hbib
pHgllqunh+NuiXGemej2umfLgp6EgiPfoYVxBATisNtQAKaV6mFhkX0/yQAAAAAAAA==
--------------ms060808080103060108060701--
