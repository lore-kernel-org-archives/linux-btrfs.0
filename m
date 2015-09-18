Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:33953 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbbIRNKd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Sep 2015 09:10:33 -0400
Received: by igcpb10 with SMTP id pb10so35219900igc.1
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2015 06:10:32 -0700 (PDT)
Subject: Re: FYIO: A rant about btrfs
To: Aneurin Price <aneurin.price@gmail.com>
References: <20150916144355.GA1285@invalid> <55F988A6.8070109@gmail.com>
 <CABL_Pd8nOj7B1_64Us+goP=corZkCtw_WJW8eMQpiP6iQpw=HA@mail.gmail.com>
 <55F9C136.3080800@gmail.com>
 <CAHb+SPDaU-FBD2b2UN+ecubZcmzX=7KKk_7PgstCpUgmVb=YuQ@mail.gmail.com>
Cc: Martin Tippmann <martin.tippmann@gmail.com>, linux-btrfs@vger.kernel.org
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55FC0D3B.9070805@gmail.com>
Date: Fri, 18 Sep 2015 09:10:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAHb+SPDaU-FBD2b2UN+ecubZcmzX=7KKk_7PgstCpUgmVb=YuQ@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms060501070301000103030104"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms060501070301000103030104
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-09-17 10:52, Aneurin Price wrote:
> On 16 September 2015 at 20:21, Austin S Hemmelgarn <ahferroin7@gmail.co=
m> wrote:
>> ZFS has been around for much longer, it's been mature and feature comp=
lete for more than a decade, and has had a long time to improve performan=
ce wise.  It is important to note though, that on low-end hardware, BTRFS=
 can (and often does in my experience) perform better than ZFS, because Z=
FS is a serious resource hog (I have yet to see a stable ZFS deployment w=
ith less than 16G of RAM, even with all the fancy features turned off).
>
> If you have a real example of ZFS becoming unstable with, say, 4 or
> 8GB of memory, that doesn't involve attempting deduplication (which I
> guess is what you mean by 'all the fancy features') on a many-TB pool,
> I'd be interested to hear about it. (Psychic debugger says 'possibly
> somebody trying to use a large L2ARC on a pool with many/large zvols')
>
> My home fileserver has been running zfs for about 5 years, on a system
> maxed out at 4GB RAM. Currently up to ~9TB of data. The only stability
> problems I ever had were towards the beginning when I was using
> zfs-fuse because zfsonlinux wasn't ready then, *and* I was trying out
> deduplication.
>
> I have a couple of work machines with 2GB RAM and pools currently
> around 2.5TB full; no problems with these either in the couple of
> years they've been in use, though granted these are lightly loaded
> machines since what they mostly do is receive backup streams.
>
> Bear in mind that these are Linux machines, and zfsonlinux's memory
> management is known to be inferior to ZFS on Solaris and FreeBSD
> (because it does not integrate with the page cache and instead grabs a
> [configurable] chunk of memory, and doesn't always do a great job of
> dropping it in response to memory pressure).
>
I should qualify this further, in particular I meant using ZFS on Linux=20
(not *BSD, they did an amazing job WRT stability), and actually taking=20
advantage of the volume-management (ie, not just storing files on it,=20
but also using zvols).  In essence, A better way to put it is that I've=20
never seen a truly stable system using zfsonlinux with less than 16G or=20
RAM which is using it for volume-management as well as file storage.


--------------ms060501070301000103030104
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
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwOTE4MTMxMDE5WjBPBgkq
hkiG9w0BCQQxQgRABKEWFC/wVpK+Gh/t6zMEXn5fZIsSarvGLUiOpoZv/Mtx/9bNyP4Nfnz9
TG6oVEnS3xfju6HrU5AkB/cQUs024jBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgCFDmUpiYG35q3+F5TR0Hl5Ior93Jzw0uV0W6VvsyScfpiasf1U
dJlprycfYhyg8vJhiUY0X1i+bg6lT7bvGGG4PUcKg7Qr65Nh5gNAtqdxAMD1vmAeibteluHH
EKCuiANs1g4y7szkj4cYrHRvmZ4dvON38fXPrYWUZCt2IBnCoAkjgfDu4haJAV8pA+VYynDX
XaD1hD9trOCKVVMGjpfi0um9UzzJVTWl6qVJKhRnKWrNdLzCWuht+c11eNbw0c0a3IoAUIBF
MPqCwsQuZPw72wP5w+Os+okfa1ZdMLFclfUXa3hY2ZC/s6fMx9DX2FYkeZSxc15IXM2jvYEm
lXQeKcoMzOY8xVsmKJzMalIbSAXk36RtiEyi5YNaS7FAvlazqY0+f+Pwy0NkgiZQYBz3MRap
l/hzMQ18UwK+MkuOi03Tz3fihBwrAeL5EOoEgaodi1vx/7uLiZBEVH38nbj0xl+Bybdn8ORF
CK2IqRv4v8+V48vqlNPIAKpp0gMQpfwTJZa7+nWlk4T5ZgBYdrksDyhjFg87UugX6XbmONL9
xp3Uzn3FYd3xdOO43CZsDGEslbGSl0DGa+ZQXY7BivoMeWjp1x7Z9cm3p5O59xv7pg8udznU
nDNO5Gnxm4rYIHYVByS4DnJLroBS7TcumEuViZCyKCts80EZj1AFWMuNcAAAAAAAAA==
--------------ms060501070301000103030104--
