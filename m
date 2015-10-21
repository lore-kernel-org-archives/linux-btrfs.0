Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:37227 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317AbbJULvq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 07:51:46 -0400
Received: by igbhv6 with SMTP id hv6so35714907igb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2015 04:51:46 -0700 (PDT)
Subject: Re: Expected behavior of bad sectors on one drive in a RAID1
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <CA+X5Wn6Wu3RfX6rM6fpp9b4ZQQNm5WCbSOzxyOnE=+jDb0xDoA@mail.gmail.com>
 <201510201545.50705.russell@coker.com.au> <56263B0B.4050502@gmail.com>
 <201510210015.54337.russell@coker.com.au> <562648B5.2020401@gmail.com>
 <pan$6a87$d56eafce$4f04d0c$30b17c06@cox.net> <56269D1C.5080006@gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56277C4A.70300@gmail.com>
Date: Wed, 21 Oct 2015 07:51:38 -0400
MIME-Version: 1.0
In-Reply-To: <56269D1C.5080006@gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms090003060204070102020907"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms090003060204070102020907
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-20 15:59, Austin S Hemmelgarn wrote:
> On 2015-10-20 15:20, Duncan wrote:
>> Yes, there's some small but not infinitesimal chance the checksum may =
be
>> wrong, but if there's two copies of the data and the checksum on one i=
s
>> wrong while the checksum on the other verifies... yes, there's still t=
hat
>> small chance that the one that verifies is wrong too, but that it's an=
y
>> worse than the one that does not verify?  /That's/ getting close to
>> infinitesimal, or at least close enough for the purposes of a mailing-=

>> list claim without links to supporting evidence by someone who has
>> already characterized it as not mathematically rigorous... and for me,=

>> personally.  I'm not spending any serious time thinking about getting =
hit
>> by lightening, either, tho by the same token I don't go out flying kit=
es
>> or waving long metal rods around in lightning storms, either.
> With a 32-bit checksum and a 4k block (the math is easier with smaller
> numbers), that's 4128 bits, which means that a random single bit error
> will have a approximately 0.24% chance of occurring in a given bit,
> which translates to an approximately 7.75% chance that it will occur in=

> one of the checksum bits.  For a 16k block it's smaller of course
> (around 1.8% I think, but that's just a guess), but it's still
> sufficiently statistically likely that it should be considered.
As mentioned in my other reply to this, I did the math wrong (bit of a=20
difference between kilobit and kilobyte), so here's a (hopefully)=20
correct and more thorough analysis:

For 4kb blocks (32768 bits):
There are a total of 32800 bits when including a 32 bit checksum outside =

the block, this makes the chance of a single bit error in either the=20
block or the checksum ~0.30%.  This in turn means an approximately 9.7%=20
chance of a single bit error in the checksum.

For 16kb blocks (131072 bits):
There are a total of 131104 bits when including a 32 bit checksum=20
outside the block, this makes the chance of a single bit error in either =

the block or the checksum ~0.07%.  This in turn means an approximately=20
2.4% chance of a single bit error in the checksum.

This all of course assumes a naive interpretation of how modern block=20
storage devices work.  All modern hard drives and SSD's include at a=20
minimum the ability to correct single bit errors per byte, and detect=20
double bit errors per byte, which means that we need a triple bit error=20
in the same byte to get bad data back, which in turn makes the numbers=20
small enough that it's impractical to represent them without scientific=20
notation (on the order of 10^-5).

That in turn assumes zero correlation beyond what's required to get bad=20
data back from the storage, however, if there is enough correlation for=20
that to happen, it's statistically likely that there will be other=20
errors very close by.  This in turn means that it's more likely that the =

checksum is either correct or absolutely completely wrong, which=20
increases the chances that the resultant metadata block containing the=20
checksum will nnot appear to have an incorrect checksum itself (because=20
checksums are good at detecting proportionately small errors, but only=20
mediocre at detecting very big errors).

The approximate proportionate chances of an error in the data versus the =

checksum however are still roughly the same however, irrespective of how =

small the chances of getting any error are.  Based on this, the ratio of =

the size of the checksum to the size of the data is a tradeoff that=20
needs to be considered, the closer the ratio is to 1, the higher the=20
chance of having an error in the checksum, but the less data you need to =

correct/verify when there is an error.


--------------ms090003060204070102020907
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDIxMTE1MTM4WjBPBgkq
hkiG9w0BCQQxQgRASk2goSsRXbBTfkDppXFjGXZdQ2EDCMaaivszi8Vk6H3p5rL92Y13lZmk
DxnEzkc45IH0ILFK0dXByiQTW+FYYDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBObC+Isq7G9Ykzhg3ysRVKQCbRfz3wTThmWczg82zubsZouJua
17ExPByLo2WEfmUroYq5NQBnTfXMBDOtfVW9gx52xNR2g6wrDTD04wsR9qjZq4Iuf37a9fUx
r9Mi7ycejloo8riSwt8G6sEK8ixuTnmmehiB1MCr1YKt3k79ueT0MGBAXKrvTRx9JrOo4sgn
ep6MHe9UbrM7f1CZpdJ54DYlH+e4w5bwWofyRtksWdB7YBmf8Nk9VniwuBL7ivGlE0gk//Fv
ES589sBGZyv5VU4S9+xljbsJcjH4iCIo1RjpSiV/5lfWEb463K8gG7XBRZ293Y25hVzGdk5f
bSixcWtm6gmJ4blBs9iima1v/uFWiT4PaxXfhJrXavx67vYl/7qjHcAQQCnIurhbWTD/Jd/L
k/c+wVyqqJOaSgTpubIaVlET6hEz7F0xoz5Wh7p8BRncuJ7Egdp/kzgJov+DFtdD7Tk+URRw
x08kD5pyt3RgTZqow5rJYhEe5Qhsae5Om9ekQ9ymq2p+HVkZPokP4rCygCte0MM99o7Jxq0Y
elfwFTRilifrJWSaOMo4Uf4VcGSuFlKOmDJGeXZWyrObfIf7JAa1tQqLArL2ykOc/f8rpf4I
MWwC/B6Bero+yYK+zVHNVy4UN5HQHkn0/PTPEJ/dVNqmupNM6b4ku4ux5QAAAAAAAA==
--------------ms090003060204070102020907--
