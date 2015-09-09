Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:36071 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbbIIMkd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Sep 2015 08:40:33 -0400
Subject: Re: mkfs.btrfs cannot find rotational file for SSD detection for a
 pmem device
To: Boaz Harrosh <boaz@plexistor.com>,
        "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>
References: <94D0CD8314A33A4D9D801C0FE68B40295BD1BF1F@G4W3202.americas.hpqcorp.net>
 <55EEDAE8.1060905@gmail.com>
 <94D0CD8314A33A4D9D801C0FE68B40295BD1EB13@G4W3202.americas.hpqcorp.net>
 <55F017CE.1090505@gmail.com> <55F02239.3090809@plexistor.com>
Cc: "Knippers, Linda" <linda.knippers@hpe.com>,
        "util-linux@vger.kernel.org" <util-linux@vger.kernel.org>,
        "Kani, Toshimitsu" <toshi.kani@hpe.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55F028B7.9080707@gmail.com>
Date: Wed, 9 Sep 2015 08:40:23 -0400
MIME-Version: 1.0
In-Reply-To: <55F02239.3090809@plexistor.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms060300090808010408050400"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms060300090808010408050400
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-09-09 08:12, Boaz Harrosh wrote:
> On 09/09/2015 02:28 PM, Austin S Hemmelgarn wrote:
>> On 2015-09-08 16:00, Elliott, Robert (Persistent Memory) wrote:
> <>
>
>> this may actually make things slower (the particular effect of SSD mod=
e
>> is that it tries to spread allocations out as much as possible, as thi=
s
>> helps with wear-leveling on many SSD's).
>>
>
> For DRAM based NvDIMM it matters not at all. For Flash based or the new=

> 3d Xpoint it is a plus, so no harm in leaving it in
>
Looking at it from another perspective however, a lot of modern RAM=20
modules will stripe the bits across multiple chips to improve=20
performance.  In such a situation, BTRFS making the effort to spread out =

the allocation as much as possible may have an impact because that=20
allocation path is slower than the regular one (not by much, but even a=20
few microseconds can make a difference when it is getting called a lot).



--------------ms060300090808010408050400
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
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwOTA5MTI0MDIzWjBPBgkq
hkiG9w0BCQQxQgRAZkDMzo7WfvNZ/okWJ9PiSOhpLTfeQvMisbH/xPRijff+BQmP0T3Uviha
LgJolOA9WPV9yoX+e7rbtsxAUdL1pTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgA3Le3I9phDsihc0IJI82ED5/wTIn5BtbEe096G6fZ8WajdCX8B
dbektg8ZcvURMftBsZDpv5WZrycI+xXkV9DmnlIFQQA1cBeTLhuIQu8yN+/cbbQdddT1mIm1
wCsVasoehRJuB7Fban2eXmOy5w68coZvq5yaY/RzhnupO65rqfNWN7B5uB3sHvLpUP7K3eCe
GnxCDC9F0/ayMGT+BuIlzoXajA+u7d+G3pOimehkD/AxGjiUHVqpq1iJDaAU2XRsIYg4Q2rb
QuTGRQdYQscm5bmt4E8sDB7VC1holIXKJagfpfBGFVVkzU7HJx3+fXvTcBRhplIx4Spl6ApZ
0DJ7CKEk86mchM5U+AKOOvhzuKafZPZwvX5XDKPvP5A5RWbt4HH87NAYtrXnMO+53OoC/vPK
tjOVP8umqVORsqkBvVsgbnH67LCmhKOu5b0d0tfcJ6CYKOkIZrJtHen+uL4c8rmGtDtg2oNd
xMZ+nX+o02GznZEx8caGwgivKiMToVDETp4oVaDndktM2tduDU3S5AGcpjx3SVhMTenva+35
fFCKAIPkErHS2hHkn4t9/YMqeCWRx2LwuRnOPpbSX5JJElSZAHwaz20Zv9DIG4uFwY7Qh9px
HrYuVDGeDR21pQY4aWQYM3q0iOXe29+kUc6k71JNXkXge4xxAW2UnTT88gAAAAAAAA==
--------------ms060300090808010408050400--
