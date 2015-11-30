Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:36370 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbbK3QAq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 11:00:46 -0500
Received: by iofh3 with SMTP id h3so178842880iof.3
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Nov 2015 08:00:45 -0800 (PST)
Subject: Re: Bug/regression: Read-only mount not read-only
To: Hugo Mills <hugo@carfax.org.uk>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
References: <20151128134634.GF24333@carfax.org.uk>
 <565C645C.5030608@gmail.com> <20151130152837.GB8775@carfax.org.uk>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <565C72A0.4030002@gmail.com>
Date: Mon, 30 Nov 2015 11:00:32 -0500
MIME-Version: 1.0
In-Reply-To: <20151130152837.GB8775@carfax.org.uk>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms000009060405010009060700"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms000009060405010009060700
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-30 10:28, Hugo Mills wrote:
> On Mon, Nov 30, 2015 at 09:59:40AM -0500, Austin S Hemmelgarn wrote:
>> On 2015-11-28 08:46, Hugo Mills wrote:
>>>     We've just had someone on IRC with a problem mounting their FS. T=
he
>>> main problem is that they've got a corrupt log tree. That isn't the
>>> subject of this email, though.
>>>
>>>     The issue I'd like to raise is that even with -oro as a point
>>> option, the FS is trying to replay the log tree. The dmesg output fro=
m
>>> mount -oro is at the end of the email.
>>>
>>>     Now, my memory, experience and understanding is that the FS
>>> doesn't, and shouldn't replay the log tree on a RO mount, because the=

>>> FS should still be consistent even without the reply, and
>>> RO-means-actually-RO is possible and desirable. (Compared to a
>>> journalling FS, where journal replay is required for a consistent,
>>> usable FS).
>> This is exactly how it should behave (being able to say that a RO
>> mount is really RO (if atimes aren't enabled) is a huge selling
>> point).  On a side note, a properly designed journaling filesystem
>> _can_ be made to behave like this, but it makes the filesystem
>> _really_ slow if you don't have enough RAM to cache all the blocks
>> modified by the journal (because each block access has to check the
>> journal for modifications).
>>>
>>>     So, this looks to me like a regression that's come in somewhere.
>> I'm not sure that this ever worked the way it should.  It should be
>> fixed regardless of what state things were however.
>
>     I'm pretty sure it was like that at some point, because I've used
> it as a diagnostic tool: If you can mount OK with -oro, but not
> without, then the log tree is broken, and btrfs-zero-log can be used
> to good effect. (In fact, that's what I was trying to do with the OP
> when I spotted the issue).
Hmm, in that case, it looks like a bisection is in order, but that may=20
be tough without a known broken filesystem image.  I would offer to try=20
and bisect it myself, but I seem to have misplaced the scripts I had=20
been using to automate testing, and I won't be able to take the time to=20
look for them properly (and possibly re-write them) until this weekend.



--------------ms000009060405010009060700
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
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTMwMTYwMDMyWjBPBgkq
hkiG9w0BCQQxQgRAyex1QUrQibtspz78TeBIROdTCsLGw3jykp+/fyvc6OO+43nV8QIXLRMy
rARzQowj88h8LMkfGh6fa1r6G4T3gzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBWIgoXeqnLJ4WP79cKa3SzXg/W/TWrbm5o8/PBxx3BP5QvXRaF
jYFPkvqVeDSbjKyYUYykmnK0nHSnx9lMaqE6Erw4sqe1qesPQJy798xftBN/pATyl3Sb0GMg
Vxz/q4I4KE4YGBDy6BuXpv9oooaBuYBheo2KqLTugDYwl0kr3lAeQQcPyP2Lvgmk/fiFxvUS
J4kqHEklckghCNAm3bleLI3Nhg5Xr3U++H+QO5Bh2URpAJ7RO50g+d2juP3Mq5wj05HR21zN
2+lEbdtZg4qw08tkbMvnFzyG7bXpRwAObnYbFAARlu/fhOzC2P3hKMtmszWZWbRllQEMMPr4
4vI2AQGPc/k7nsoIvODYQ1MxZl618mhcXBL348Rvj7FEhOg77JNxg1afcOg9SxEc+7YO4J5G
4vkdJbeZUaPlcnRQLLtTKwpoHXbZBF2Ra7izvtJU22xdohpCmuSe/5dH+90KZw1B5xztzQlw
9m2bdJq3fsuNH//3QnFckJXrZQsaHOuwpG1zjJGZrF9DDPlYuyJsvvqxIVbFCnqq+p5wVMiI
1kvNQalY/xfrK97gRRFNvwuShwmsfZqP+qX4yifXq6m/31QSZf7qdbrInX9eRndi5Xuz6dCH
iDtmvrWeVBsUDpTkqsm2B3fzPgSJ35Nvov5Ts0SYFEsHk30EDNQh1amUyQAAAAAAAA==
--------------ms000009060405010009060700--
