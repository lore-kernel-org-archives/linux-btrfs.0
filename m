Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:37745 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbbIIL2Y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Sep 2015 07:28:24 -0400
Subject: Re: mkfs.btrfs cannot find rotational file for SSD detection for a
 pmem device
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>
References: <94D0CD8314A33A4D9D801C0FE68B40295BD1BF1F@G4W3202.americas.hpqcorp.net>
 <55EEDAE8.1060905@gmail.com>
 <94D0CD8314A33A4D9D801C0FE68B40295BD1EB13@G4W3202.americas.hpqcorp.net>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "util-linux@vger.kernel.org" <util-linux@vger.kernel.org>,
        "Kani, Toshimitsu" <toshi.kani@hpe.com>,
        "Knippers, Linda" <linda.knippers@hpe.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55F017CE.1090505@gmail.com>
Date: Wed, 9 Sep 2015 07:28:14 -0400
MIME-Version: 1.0
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295BD1EB13@G4W3202.americas.hpqcorp.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms070507020203080801090900"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms070507020203080801090900
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-09-08 16:00, Elliott, Robert (Persistent Memory) wrote:
>
>> -----Original Message-----
>> From: Austin S Hemmelgarn [mailto:ahferroin7@gmail.com]
>> Sent: Tuesday, September 8, 2015 7:56 AM
>> Subject: Re: mkfs.btrfs cannot find rotational file for SSD detection =
for
>> a pmem device
>>
>> On 2015-09-06 13:51, Elliott, Robert (Persistent Memory) wrote:
> ...
>>> The impact looks limited to the print and causing it to not
>>> automatically disable "metadata duplication on a single device."
>> This is an issue inherent in the current pmem driver however, it shoul=
d
>> be fixed there and not in mkfs.btrfs, as other filesystems make
>> decisions based on this file also, as does the I/O scheduler, and some=

>> block storage servers.
>> ...
>
> The rotational file does exist, at:
> /sys/devices/LNXSYSTM\:00/LNXSYBUS\:00/ACPI0012\:00/ndbus1/region0/name=
space0.0/block/pmem0/queue/rotational
>
> One or more functions are having trouble parsing that 108-byte string
> ... mkfs.btrfs's is_ssd, libblkid's blkid_devno_to_wholedisk, or
> libblkid's sysfs_devno_to_wholedisk.  I'm not sure where the
> breakdown occurs.
Ah, sorry about the confusion, I didn't think to actually look before=20
commenting.  So, it looks like this amounts to some short-sighted=20
coding, although I could see why they wouldn't have accounted for the=20
possibility of having to parse some monstrous path like that, and that=20
also would explain why kernel side stuff isn't choking on it.  Now, the=20
real question is why we have to go through the full absolute path in=20
sysfs, and can't just go through /sys/block/pmem0.
>
> This is reminiscent of an issue that numactl has parsing the path to
> get to .../device/numa_node (rather than .../queue/rotational).  It
> was confused by not finding "/devices/pci" in a path for a storage
> device.
>
>> This gets tricky though because pmem isn't
>> technically a block device at the low level, and doesn't use some part=
s
>> of the block layer that most other block devices do.
>>
>> On that note however, if the pmem device is backed by actual RAM and n=
ot
>> flash storage (and most of them are from what I've seen), then the onl=
y
>> advantage of using single metadata mode over dup is space savings, as
>> RAM is not (usually) write limited.
>
> pmem devices will be a mix ranging from flash-backed DRAM to new
> technologies like 3D Crosspoint, usually offering high performance
> and good wearout characteristics.
Hmm, I've never actually seen flash-backed DRAM based NV-DIMM's,=20
although I've not necessarily been keeping up to date.  Most of what=20
I've seen have been small (512M or 1G) ferro-electric RAM based ones,=20
and an early design that was battery backed (which is just a crisis=20
waiting to happen).
>
> The btrfs driver does detect it as SSD after mkfs.btrfs did not:
> kernel: BTRFS info (device pmem0): disk space caching is enabled
> kernel: BTRFS: has skinny extents
> kernel: BTRFS: flagging fs with big metadata feature
> kernel: BTRFS: detected SSD devices, enabling SSD mode
>
That makes sense if it's an issue in userspace with parsing of the path, =

although depending on the actual underlying storage for the pmem device, =

this may actually make things slower (the particular effect of SSD mode=20
is that it tries to spread allocations out as much as possible, as this=20
helps with wear-leveling on many SSD's).


--------------ms070507020203080801090900
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
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwOTA5MTEyODE0WjBPBgkq
hkiG9w0BCQQxQgRAqKTs/D8iMJBBKdlBiXX+4F+2aTOVYJi2k5RPsaZ4tSwi6VxstsBvdld+
DQtBEbyO0+C3wFq7cjjhtJZ0i9pdczBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgCI31yGP2O57Ou7pehOPub/Mnlzn9qVFTvYRX06/wKqON3pAjbI
gdcDz2Xz5hu8mvSFF6O0Hm5rE3qdFjX3MGnxlasHDQg+P/qcy7CX/QAMk7IpmrJWIICWnTII
Mx6spcEYPmjWiQ5oYVwUuOUxidRXsQi4c2eBJeRh/gJtmN34k6febkHGsGGjPvpdH0Hl8Opo
/EoACJO1uF50bLjvhBTXgop7ggH+q/NPhTysHegWpzVN7RwCpvN4Kkjvma6W7ku3J1cV9OCe
LndyCbMnO4SRQJNZtiePZkL1exgNh4QqRqJTyjSZ3GfEqyg6hdtRUIuPSR4LWBa6pzwUYOps
SRwTZJfDRMfbCVKEo+ys5GdY1o9iOYy3TCRmEabrP8vNsHbV8185TrOnirKrecakGp66JfQP
N1kt9zjPA/r1ETPj/MzxsgNy+YHiVBGy9P4MS2xlqwpsnEHGm0Iyj9qd3L+GIRMQJ/IfOfYC
jhwntaiHnsXOd1LfvnsytFdQG50suNf2CZ+9XdVDvGO5doJuJi1T/VB8xDBOMu4ILq27Oa6t
JVWi+vss4mtybuzXL1U+F90FYeKbsaCWZV5yBz5vTOIKRio3XQdPi4xoy8XZkVYvVQfmPew7
6+3LmgTYSTvy8C9NsCfd63LT/blbCckDz5ZfvxuKWniSsg396PQm129BVwAAAAAAAA==
--------------ms070507020203080801090900--
