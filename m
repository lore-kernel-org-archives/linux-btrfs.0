Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:34215 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbbHERcz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Aug 2015 13:32:55 -0400
Received: by ioea135 with SMTP id a135so56501026ioe.1
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Aug 2015 10:32:54 -0700 (PDT)
Subject: Re: RAID1: system stability
To: Russell Coker <russell@coker.com.au>,
        Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <556457b8.e72b980a.ee08.ffffce60@mx.google.com>
 <CAGqmi774WEukmUt9NAFZQ8R9kCCyOFm3M_TP2ULgvtgpDnMM1w@mail.gmail.com>
 <CAJCQCtTXiWWie+OtkdNhjmUEjPoyx565LZ15KC3Kfr7DC9ucpQ@mail.gmail.com>
 <201507222100.22471.russell@coker.com.au>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55C248B9.20003@gmail.com>
Date: Wed, 5 Aug 2015 13:32:41 -0400
MIME-Version: 1.0
In-Reply-To: <201507222100.22471.russell@coker.com.au>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms070402010403040405030204"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms070402010403040405030204
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-07-22 07:00, Russell Coker wrote:
> On Tue, 23 Jun 2015 02:52:43 AM Chris Murphy wrote:
>> OK I actually don't know what the intended block layer behavior is
>> when unplugging a device, if it is supposed to vanish, or change state=

>> somehow so that thing that depend on it can know it's "missing" or
>> what. So the question here is, is this working as intended? If the
>> layer Btrfs depends on isn't working as intended, then Btrfs is
>> probably going to do wild and crazy things. And I don't know that the
>> part of the block layer Btrfs depends on for this is the same (or
>> different) as what the md driver depends on.
>
> I disagree with that statement.  BTRFS should be expected to not do wil=
d and
> crazy things regardless of what happens with block devices.
I would generally agree with this, although we really shouldn't be doing =

things like trying to handle hardware failures without user=20
intervention.  If a block device disappears from under us, we should=20
throw a warning and if it's the last device in the FS, kill anything=20
that is trying to read or write to that FS.  At the very least, we=20
should try to avoid hanging or panicking the system if all of the=20
devices in an FS disappear out from under us.
>
> A BTRFS RAID-1/5/6 array should cope with a single disk failing or retu=
rning
> any manner of corrupted data and should not lose data or panic the kern=
el.
It's debatable however whether the array should go read-only when=20
degraded.  MD/DM RAID (at least, AFAIK) and most hardware RAID=20
controllers I've seen will still accept writes to degraded arrays,=20
although there are arguments for forcing it read-only as well.
Personally, I think that should be controlled by a mount option, so the=20
sysadmin can decide, as it really is a policy decision.
>
> A BTRFS RAID-0 or single disk setup should cope with a disk giving erro=
rs by
> mounting read-only or failing all operations on the filesystem.  It sho=
uld not
> affect any other filesystem or have any significant impact on the syste=
m unless
> it's the root filesystem.
Or some other critical filesystem (there are still people who put /usr=20
and/or /var on separate filesystems).  Ideally, I'd love to see some=20
some kind of warning from the kernel if a filesystem gets mounted that=20
has the metadata/system profile set to raid0 (and possibly have some of=20
the tools spit out such a warning also).



--------------ms070402010403040405030204
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgMFADCABgkqhkiG9w0BBwEAAKCC
Brgwgga0MIIEnKADAgECAgMQblUwDQYJKoZIhvcNAQENBQAweTEQMA4GA1UEChMHUm9vdCBD
QTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNp
Z25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcwHhcN
MTUwMzI1MTkzNDM4WhcNMTUwOTIxMTkzNDM4WjBjMRgwFgYDVQQDEw9DQWNlcnQgV29UIFVz
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
b20wDQYJKoZIhvcNAQENBQADggIBABr5e8W+NiTER+Q/7wiA2LxWN3UdhT3eZJjqqSlP370P
KL5iWqeTfxQ67Ai/mHbJcT2PgAJ+/D2Ji+aRR03UWnU/vtOwzyDLUMstqnfl0Zs+sz/CJe7x
nBA5jlpjC2DKuMVfbPze7eySaen7XSGFHKE1QoVIIpQ2kVjC4nbbJQnUbAVX1Iz29WxeVGt9
XYigz3tDPf3tglN+q23E7YjQl4abTIoM7i98yV1H9gfY8lFfKZ6jREB9+n6ie2EwS3Kat2mG
tl2wBx4MfRnoSQSKsLKQ5oTwhWf0JqlFwpLfl374p0Njcykej9/jnWG8Ks1V/AXTHqI4eyIP
Mf5yMZkPv7n7LS9WWKdG4Nd38iv4T2EiAaWsmgu+r81qL5CJu9AyA0SBS4ttKf6k3e63w2Mv
N9R45vpQ3QhAhfWyFxFhZN95APe3YECDG3+XIRJpRYPEtHuIsOyzI70ajF93gg/BidvqKsmV
MM2ccktDMfqwZXea6zey7F8Geu9R7BqjXmG2HlNuXu7e/xnHOgXf5D3wPmnRLlBhXL1Ch97a
w2KjaupjpAHfFjv5kGnZXN87UvvlwzIZiKXwa3vTDwK+rrKn/sHPkfDZPSiyt/ZBIK6lX83P
34H/CzGg+Kx57rHYOIHGumIvpDa5vfWp8O0sGgawb1C2Aae4sTUVIWmIjVuGI062MYIE0TCC
BM0CAQEwgYAweTEQMA4GA1UEChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNl
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwODA1MTczMjQxWjBPBgkq
hkiG9w0BCQQxQgRADMN5CuEcDQsAMzcQsOftDxXKzSschMQT5BdoehzaEa1oA4Wy8tVSTihY
2YwQbAPnz28t2nbAJGhFlJDqeW1nhjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgBoXrMlDD9/qpftuv1poFDS2uvn0n1K+VlNAZmYrPa7i/h+ESKf
U74Q4DnEuxWrB0x1LeftkcxZuQFSTlo+Log0sSpUpOPrHOsOFZKa7MgYm8MRoi2ur3G3UnP3
4RfZjIHAZppKHRvmattLFR2/RYvKa9rfRklmRUQ4ucJpEATBEuO5a+enI5nbkjaB4B2kpV0Y
i9D+VDeZbzUJpkSBoavPt7u2e6XZY/BkVqtdE9f10EXI1dZjLgscXhrAFpLtCX0chXOFFmbh
ehMpvHrGocjwddBULXYvtWP5YUl+2JHxYr1QLtUkVlMqUwGJvYo3GIVaNxJDSuz3+GHWY5cW
//yovF/7TCHk7lYgtd8ykLfZG70A433SEFNmIBinVqPNo3y3l7UP3dQPSdXgPiNKuTEoj4eg
v+l3u7UzqjkuWy6MxiJ+FszWc9GyYxbVBhGK7YO7mR/dPGZ3J25FuQjxMIJxiD1t0kZD8oRU
O8dnqOww2bnMgjE0bx4paWNTCX/6/ajxCFZwonyFkK+K4S1SC8AODiKT4J5Vi0VKmvHRdrRW
vyCq2UMk9zKJzGHJ7UFPPCwSlkC6/x/BkCEU+SbYLh1zp7VR0Ck/hcxlVUfr7iMRVXG70lOe
nfwruAyZ8wGqWC6O+uW6pC5oIyJFTcOfoAXf93vNUfzD8GUtNOLtRhPXUQAAAAAAAA==
--------------ms070402010403040405030204--
