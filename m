Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:33076 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbbHTRbd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Aug 2015 13:31:33 -0400
Received: by iods203 with SMTP id s203so54316975iod.0
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Aug 2015 10:31:32 -0700 (PDT)
Subject: Re: Questions on use of NOCOW impact to subvolumes and snapshots
To: Chris Murphy <lists@colorremedies.com>,
        Russell Coker <russell@coker.com.au>
References: <D3CC3E72-929E-4ADF-826F-62DCB6BD827C@lime-technology.com>
 <CAJCQCtSVn7BSYY=Ofq6OsKfHyv_PTKGOg7uP=tUC4XTNQ42v0w@mail.gmail.com>
 <201508201343.07618.russell@coker.com.au>
 <CAJCQCtSf=ZK4Avu4nPeBWaDgbHv1xUzegvhfAGbLcBFGrLSM1g@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55D60EE2.9090803@gmail.com>
Date: Thu, 20 Aug 2015 13:31:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSf=ZK4Avu4nPeBWaDgbHv1xUzegvhfAGbLcBFGrLSM1g@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms070203060102010706080600"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms070203060102010706080600
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-08-20 12:44, Chris Murphy wrote:
> On Wed, Aug 19, 2015 at 9:43 PM, Russell Coker <russell@coker.com.au> w=
rote:
>> On Thu, 20 Aug 2015 11:55:43 AM Chris Murphy wrote:
>>>> Question 1:  If I apply the NOCOW attribute to a file or directory, =
how
>>>> does that affect my ability to run btrfs scrub?
>>>
>>> nodatacow includes nodatasum and no compression. So it means these
>>> files are presently immune from scrub check and repair so long as it'=
s
>>> based on checksums. I don't know if raid56 scrub compares to parity
>>> and recomputes parity (assumes data is correct), absent checksums,
>>> which would be similar to how md raid 56 does it.
>>
>> Linux Software RAID could recreate a mismatched block from RAID-6 pari=
ty but
>> doesn't do so.  It could be that a block was changed correctly but did=
n't get
>> the parity data written so such "correction" would be reverting a chan=
ge.  So
>> Linux Software RAID only regenerates parity for a scrub and makes both=
 disks
>> have the same data for RAID-1.
>
> https://www.kernel.org/pub/linux/kernel/people/hpa/raid6.pdf
>
> Discussion starts in section 4 on page 7. The relevant part I'm
> confused about is on page 8, " once the faulty drive has been
> identified" doesn't clarify a mechanism to determine which data drive
> is corrupt. Iti seems without that knowledge, it's not possible to
> reconstruct. Further, should there be two corruptions, however
> unlikely, reconstruction causes a third corruption. So it's a bit
> risky.
IIUC, the checksumming is done on each part of the block written (in=20
which case it's really easy to see which is bogus.  There's also the=20
fact that if one of the parities is wrong, but the other isn't, the=20
parity block that is wrong is probably faulty (although this isn't a=20
100% guarantee).
>
> In any case though, in normal operation, md raid6 isn't checking
> parity. It always assumes the data chunks are valid unless the drive
> itself returns a read error. For scrub repair, it assumes data is
> correct and writes new parity, which is different than with a raid1
> scrub repair where there's something of a random (?) assumption which
> mirrored chunk is correct and the other(s) are overwritten. I don't
> even know that with n-way mirroring this scrub assumes majority rules.
Based on my own testing, it doesn't handle that sanely.



--------------ms070203060102010706080600
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
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwODIwMTczMTE0WjBPBgkq
hkiG9w0BCQQxQgRAmanHSvWrjA037WpC67v79uaN9n1KBicM4Z/Hx67pEQ71exS4G4AoBYGi
FJ3GzW7xlc9xcIuFj6o+Zl96HIpAEzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgAtzg3ExAB0DFrokIavA00OfgOl0KfjJ78MVT0biVEKb+y0sAyI
wBsugyQ+QIkMTcMFCF9JoG8NshRlR4rJWxe86zQZql5bdaNyKtw+1UWiXAABYT9oEaRUqCo6
8jZzY48MFNCme7jWCH+b7LlCp3qVEazGyzrw77CKgifzCZrys9AjuoTfzDCyOwihq5IiQvrH
NMbq6964Mh89urbR1dfkeKzKwLmCmSKclAr2inZ+YYn9VnI7f3MPJGjrMctHo0oRZteNKFC4
ZtGLTkxZkccVX/qI4R84TKkfv2+6NJ8XR2OITpZpG5+yJeAbQod9y+kdI/czrutABSi+b4Ft
RV318EhPhemm71LSSMAC4IiFQ0VLeJ+XVNmedpBnApbPqr8/QEdSjclU+GFQn/0XmkKbqolp
xosCIDHFzfETXOVwogmm3RWoRCQXylh12Lm/yTMfs8O0UY5dTyFl1VeLdPPmDaCAPD8IKGm8
mkmSkO6Nr1se2tnIYkaDsZ7QyuIgD9TV+UunZbZovpqDgDaWrwf9gnNP0Y1V49BMPCZHdrGD
kLHpEjxyXkq3v7O8yC9/h/NNnneIo+mjPOJcjXZf+4UbtpB3OLVizQzb/wg03s+h1l3+7p49
4TtldcZQACQmazpuDRw85G4LnpjeCZI9rX7QRPXHAiGkfnlHCi5HZePiIgAAAAAAAA==
--------------ms070203060102010706080600--
