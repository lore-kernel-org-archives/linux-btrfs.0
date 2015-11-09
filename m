Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:33582 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbbKIOJO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Nov 2015 09:09:14 -0500
Received: by iodd200 with SMTP id d200so186728500iod.0
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2015 06:09:14 -0800 (PST)
Subject: Re: [PATCH 00/15] btrfs: Hot spare and Auto replace
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <5640A903.9030209@gmail.com>
Date: Mon, 9 Nov 2015 09:09:07 -0500
MIME-Version: 1.0
In-Reply-To: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms080601090801010705060308"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms080601090801010705060308
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-09 05:56, Anand Jain wrote:
> These set of patches provides btrfs hot spare and auto replace support
> for you review and comments.
It's absolutely awesome to see that someone picked up this project, it's =

something that's very useful and helps BTRFS to compete with many=20
established storage technologies.  I've got some specific questions below=
=2E
>
> First, here below are the simple example steps to configure the same:
>
> Add a spare device:
>      btrfs spare add /dev/sde -f
>
> OR if there is a spare device which is already added before the, just
> run
>
>      btrfs dev scan [/dev/sde]
>
> this will register the spare device to the kernel.
>
>      btrfs fi show
>      Label: none  uuid: 52f170c1-725c-457d-8cfd-d57090460091
> 	Total devices 2 FS bytes used 112.00KiB
> 	devid    1 size 2.00GiB used 417.50MiB path /dev/sdc
> 	devid    2 size 2.00GiB used 417.50MiB path /dev/sdd
>
>      Global spare
> 	device size 3.00GiB path /dev/sde
Would I be correct in assuming that we can have more than one hot-spare=20
device at a time?  If so, what method is used to select which one to use =

when one is needed?
>
> Thats it.
>
> Auto replace:
>   Replace happens automatically, that is when there is any write
>   failed or flush failed, the device will be marked as failed, which
>   will stop any further IO attempt to that device. And in the next comm=
it
>   thread cycle the auto replace will pick the spare device (/dev/sde is=

>   above example) to replace the failed device. And so the btrfs volume =
is
>   back to a healthy state.
Is there any possibility we could add a knob to control how many errors=20
are needed before the device is marked as failed?  For an enterprise=20
environment, immediately marking the device failed is the right thing to =

do, but for home usage it may make more sense to retry the I/O at least=20
once before marking the device failed (especially considering that most=20
home users don't have ECC memory, and a transient memory error can cause =

an I/O request to fail (I've actually had this happen on my laptop before=
)).
>
>
> Its btrfs Global spare:
>   as of now only global hot spare is supported, that is hot spare(s)
>   are for all the btrfs FS in the system.
How hard would it be to eventually extend this to per-filesystem hot-spar=
es?
>
> No spare when device failed:
>   It would scan for spare device at the rate of transaction commit
>   and will trigger the auto replace when ever spare device is added.
Does this absolutely have to be polled every commit?  This has serious=20
potential to make running on a degraded array have a much bigger impact=20
than it does now.  While we obviously want people to notice that their=20
array is degraded, killing performance is not the proper way to do that. =

  Couldn't we have a callback when adding a hot-spare that would check=20
for failed devices and initiate the replacement automatically for the=20
first one found?  Ideally, we should keep the current behavior (assume=20
the error was transient, and retry the I/O) when there is no hot-spare=20
available.


--------------ms080601090801010705060308
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
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTA5MTQwOTA3WjBPBgkq
hkiG9w0BCQQxQgRAWE27gJSHWI6HDDrH4pg+hVudptGdFgFpRlOZUhhTpxbZx7K7Y3BsiiaR
GyR5XeP7pdBm7yr9nib2vX6HrvIk1jBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgB80vB7gRNfW9ldxn3jciblYd06ZO1yimurvSWdviW788CJFRKx
ffg3FTpsOL3eiuNyObuF2dKyr5u8QI6AdzOA92ZAc33+wIqS87KLQFqlcJy/LbXVhOzfK3xb
ZpUNH6Si/s53L7OhF7FtVxN3jy1XiakrqhED04isrk6NwzTatD0SsmLlP3Ar1jH9QFolsax8
S/XgBD2B4Kglg3ScZJRLo3L5YC1QK9R5lZZwEC+OVgdnKvdKqoSLB3cX4DG1uQ3ovZ6U2eF2
DziBfcHsvQy3YUqj6oYJq4o5MCEnKQ/0KLPseyqL5ucphTM7IKzKhJ2q3iapTFAKkP6SMEGg
AYNiTHA/IA3zY+eQnxrqILuONWYBQXVzj58SM9BJLvabQIJWpolN0l9dAQwm/Z8Stsaw7BQV
eXfztdWZ50U5idlDWdXhtIUYrjfCvcEol/rpOt++d5sVkrYthGEcm5oxpv8w8wJ8KFzn3AUW
3bLMNVcDLAWlKXG3Ksg8uPOzjHHp+rWl2SyTgrGxHQfBRwQRvZqXXVp3hLjdjkxrdnmW3E5F
DDkXfLTooSbnM4PZGN7E2VCwcA8AT/l7Attxmk0LUHNcRtOawGmmeJnkNu2TmO42LGtbPTZS
X//zcDEA7K2Q9ma6MVA8EEEc2u/gRGo+pU71EGxlLq/+LvGH5LRUuWyoKwAAAAAAAA==
--------------ms080601090801010705060308--
