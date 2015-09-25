Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:34709 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221AbbIYOVc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 10:21:32 -0400
Received: by iofb144 with SMTP id b144so112473224iof.1
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2015 07:21:31 -0700 (PDT)
Subject: Re: BTRFS as image store for KVM?
To: Timofey Titovets <nefelim4ag@gmail.com>, Jim Salter <jim@jrs-s.net>
References: <55F88ECC.1040604@menke.ac> <55FE0B42.50300@jrs-s.net>
 <CAGfcS_=bst0S8YLsr6y4oGDu7Gy-ox9ow5+_nD4c3zFdj-Y6ug@mail.gmail.com>
 <56054665.1020608@gmail.com> <5605518B.2020103@jrs-s.net>
 <CAGqmi75-Wc-YOwCJhRD1ahgKhEM5tPPBVjCYmvgjMZNhEnk77w@mail.gmail.com>
Cc: Rich Freeman <r-btrfs@thefreemanclan.net>, Gert Menke <gert@menke.ac>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56055839.9000904@gmail.com>
Date: Fri, 25 Sep 2015 10:20:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAGqmi75-Wc-YOwCJhRD1ahgKhEM5tPPBVjCYmvgjMZNhEnk77w@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms020600010404010208020004"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020600010404010208020004
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-09-25 10:02, Timofey Titovets wrote:
> 2015-09-25 16:52 GMT+03:00 Jim Salter <jim@jrs-s.net>:
>> Pretty much bog-standard, as ZFS goes.  Nothing different than what's
>> recommended for any generic ZFS use.
>>
>> * set blocksize to match hardware blocksize - 4K drives get 4K blocksi=
ze, 8K
>> drives get 8K blocksize (Samsung SSDs)
>> * LZO compression is a win.  But it's not like anything sucks without =
it.
>> No real impact on performance for most use, + or -. Just saves space.
>> * > 4GB allocated to the ARC.  General rule of thumb: half the RAM bel=
ongs
>> to the host (which is mostly ARC), half belongs to the guests.
>>
>> I strongly prefer pool-of-mirrors topology, but nothing crazy happens =
if you
>> use striped-with-parity instead.  I use to use RAIDZ1 (the rough equiv=
alent
>> of RAID5) quite frequently, and there wasn't anything amazingly sucky =
about
>> it; it performed at least as well as you'd expect ext4 on mdraid5 to
>> perform.
>>
>> ZFS might or might not do a better job of managing fragmentation; I re=
ally
>> don't know.  I strongly suspect the design difference between the kern=
el's
>> simple FIFO page cache and ZFS' weighted cache makes a really, really =
big
>> difference.
>>
>>
>>
>> On 09/25/2015 09:04 AM, Austin S Hemmelgarn wrote:
>>> you really need to give specifics on how you have ZFS set up in that =
case.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> FYI:
> Linux pagecache use LRU cache algo, and in general case it's working go=
od enough
>
I'd argue that 'general usage' should be better defined in this=20
statement.  Obviously, ZFS's ARC implementation provides better=20
performance in a significant number of common use cases for Linux,=20
otherwise people wouldn't be using it to the degree they are.  LRU often =

gives abysmal performance for VM images in my experience, and=20
virtualization is becoming a very common use case for Linux.  On top of=20
that, there are lots of applications that bypass the cache almost=20
completely, and while that is a valid option in some cases, it shouldn't =

be needed most of the time.

If it's just plain LRU, I may take the time at some point to try and=20
write some patches to test if SLRU works any better (as SLRU is=20
essentially ARC without the auto-tuning), although I have nowhere near=20
the resources to test something like that to the degree that would be=20
required to get it even considered for inclusion in mainline.


--------------ms020600010404010208020004
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
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwOTI1MTQyMDQxWjBPBgkq
hkiG9w0BCQQxQgRALQwvkU6fUsq47IK9igwsrIP7Li/Lroo6vKCw50I7AoxDbBjvlrovqelZ
+qlFe8q8dotMEMAxrTPiDA4TaaYYxjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgCPvdCZ0eA7X52WzvoObLiUsa5tBLVSTNZCG8uiJrvUnc9lTB31
+8vmHeCYuDv7VRWHkT5TClWiK/5HW0bVrAPbO/0m2A3gghVd3i48YhHxtxmON1Fx7AF1VpDa
ecJkErB5wlSO1ZkRxA5VugV2L6Mgp9Y4ckG936SbdWhOdoPOp3cPZuIRG8zkOLjFZ2xnnZhK
UlsN5pRAVjUqkuD1ionWDlquFC6rku2vsIjr2KSK3cgAbXU6rnOLsrf1b+jLbj4c5U9KtPk0
Z72bma8Lh0r2mX4Cq8SED3c4p+ZyqWZ2f1H3eww+ENKAkOrcCoQBKHo0qVgNpKVS0ZVc+1Mo
lXUSHpBYgMUDMW0smLS1Wq++WX3IRHjZgnViEgufJyuEWoxH0/3M2Z+pwECEKVNQOmPwZLS0
zT8br+NtLHA7oQH13VTeSj9nom89J5Nk+VszfaqoJuJmQ7muJndACg2uwq96MiAxmg2oombX
DWkpRxex+flmFAbkqrdcfCkrpNTt9JMnxXm9aKgmQqtsgv0TYmjKv8hIJTM85gwOnECNxuGP
EvUSkbfQtEst5za1wPW/UGkwjah5tom1tl0CxP3jz0f/Uy8aioGFu0+1egqBzHECmT8JsAh3
W46fwSSNX2hdpvNq/Zl9kEGVTQrLJRvBN7k80NyhJVa2ECG48YuyZFGszwAAAAAAAA==
--------------ms020600010404010208020004--
