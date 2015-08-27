Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:36101 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbbH0MCT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Aug 2015 08:02:19 -0400
Received: by iodv127 with SMTP id v127so53870129iod.3
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Aug 2015 05:02:18 -0700 (PDT)
Subject: Re: Understanding BTRFS storage
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <CAG__1a4T=d_O49CnOw+0gtKr56xtrmcjRcmujtUff_s_-oL0Jw@mail.gmail.com>
 <20150826165024.05af044f@natsu> <55DDAB1C.90406@gmail.com>
 <pan$7fd63$2b2fd6ee$53e6fc05$7a0aab72@cox.net>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55DEFC36.5000608@gmail.com>
Date: Thu, 27 Aug 2015 08:01:58 -0400
MIME-Version: 1.0
In-Reply-To: <pan$7fd63$2b2fd6ee$53e6fc05$7a0aab72@cox.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms000309040906080109060409"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms000309040906080109060409
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-08-26 22:58, Duncan wrote:
> Austin S Hemmelgarn posted on Wed, 26 Aug 2015 08:03:40 -0400 as
> excerpted:
>
>> On 2015-08-26 07:50, Roman Mamedov wrote:
>>> On Wed, 26 Aug 2015 10:56:03 +0200 George Duffield
>>> <forumscollective@gmail.com> wrote:
>>>
>>>> I'm looking to switch from a 5x3TB mdadm raid5 array to a Btrfs base=
d
>>>> solution that will involve duplicating a data store on a second
>>>> machine for backup purposes (the machine is only powered up for
>>>> backups).
>>>
>>> What do you want to achieve by switching? As Btrfs RAID5/6 is not saf=
e
>>> yet, do you also plan to migrate to RAID10, losing in storage
>>> efficiency?
>>>
>>> Why not use Btrfs in single-device mode on top of your mdadm RAID5/6?=

>>> Can even migrate without moving any data if you currently use Ext4, a=
s
>>> it can be converted to Btrfs in-place.
>
> Someone (IIRC it was Austin H) posted what I thought was an extremely
> good setup, a few weeks ago.  Create two (or more) mdraid0s, and put
> btrfs raid1 (or raid5/6 when it's a bit more mature, I've been
> recommending waiting until 4.4 and see what the on-list reports for it
> look like then) on top.  The btrfs raid on top lets you use btrfs' data=

> integrity features, while the mdraid0s beneath help counteract the fact=

> that btrfs isn't well optimized for speed yet, the way mdraid has been.=

> And the btrfs raid on top means all is not lost with a device going bad=

> in the mdraid0, as would normally be the case, since the other raid0(s)=
,
> functioning as the remaining btrfs devices, let you rebuild the missing=

> btrfs device, by recreating the missing raid0.
>
> Normally, that sort of raid01 is discouraged in favor of raid10, with
> raid1 at the lower level and raid0 on top, for more efficient rebuilds,=

> but btrfs' data integrity features change that story entirely. =3D:^)
>
Two additional things:
1. If you use MD RAID1 instead of RAID0, it's just as fast for reads, no =

slower than on top of single disks for writes, and get's you better data =

safety guarantees than even raid6 (if you do 2 MD RAID 1 devices with=20
BTRFS raid1 on top, you can lose all but one disk and still have all=20
your data).

2. I would be cautious of MD/DM RAID on the most recent kernels, the=20
clustered MD code that went in recently broke a lot of things initially, =

and I'm not yet convinced that they have managed to glue everything back =

together yet (I'm still having occasional problems with RAID1 and RAID10 =

on LVM), so do some testing on a non-production system first.



--------------ms000309040906080109060409
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
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwODI3MTIwMTU4WjBPBgkq
hkiG9w0BCQQxQgRAG67wHiRpyYGobU/TkD/oLhkBxxjzokj2Ey3zvx+0DcCtvb98GCmwO4Ph
lDq1bBDmd8Bz2J0H7c+htTmxY7YSlTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgBnI2um7ebRg8YknNFimDbTYTIAvS7gmFew/G3weuorIDKNt2N2
otBuXE08Kd4I9V3CoWutbtH8bpORrb8BVigR59al518I/qVXlLqyIDIX2hMoyUjLs1RN60nP
NR9cPFoi9NnNhCbKxTcL/kR7tfZeXDbqHqqA9+tUEoHDDJobzsJcSJKpegaZer+FoYzhI34h
8rRUPjeiANh4cwaR2offE3/sLFqic0JNoQnerDef1pGR+8XvXzYfxmA4DO7VsDYH9g8IqbWt
77OZUfcCg8NO1vvE08/BoRURlH5lRdHF28seWmzWoZho6N8Fn7bi2PNq25JhaKjm8xPl/0Eb
wpcXQT6xIZdlgnehjDjzWeaapwIYJlJuj1EHMxHn6kArB6DZXqPDpjAAro4d6ZmIqFGxZAxT
emtUDMMfC7Bzcw1ZX1mdqPH8gItKXVdAyVGqvUEBqyo+b8S157gEtWeyIR3z11uLKHm8d+bI
Ph5UfWjfSfUEXOVN0TE47huQfHw1L4t0k0yZqtC1Ttgya0vts92kWPOfDfIFT0yfFoVxg3eL
fLgtvoTMAJpvZIyPvAsQ3lrBRKxYQ2F0oOGoox7pzl7dXx2Jer9Fap6ExMG9WcO5/7etTo11
Ysa+/2bw5Ly3sl4YGM/28/mVc3iPTL/wldgcxsno6+j7RSAwFgg4qArWEAAAAAAAAA==
--------------ms000309040906080109060409--
