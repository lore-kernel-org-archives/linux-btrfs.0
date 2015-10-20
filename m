Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:36808 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbbJTT7c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Oct 2015 15:59:32 -0400
Received: by igdg1 with SMTP id g1so71400257igd.1
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2015 12:59:31 -0700 (PDT)
Subject: Re: Expected behavior of bad sectors on one drive in a RAID1
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <CA+X5Wn6Wu3RfX6rM6fpp9b4ZQQNm5WCbSOzxyOnE=+jDb0xDoA@mail.gmail.com>
 <201510201545.50705.russell@coker.com.au> <56263B0B.4050502@gmail.com>
 <201510210015.54337.russell@coker.com.au> <562648B5.2020401@gmail.com>
 <pan$6a87$d56eafce$4f04d0c$30b17c06@cox.net>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56269D1C.5080006@gmail.com>
Date: Tue, 20 Oct 2015 15:59:24 -0400
MIME-Version: 1.0
In-Reply-To: <pan$6a87$d56eafce$4f04d0c$30b17c06@cox.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms030503000703020602080402"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030503000703020602080402
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-20 15:20, Duncan wrote:
> Austin S Hemmelgarn posted on Tue, 20 Oct 2015 09:59:17 -0400 as
> excerpted:
>
>
>>>> It is worth clarifying also that:
>>>> a. While BTRFS will not return bad data in this case, it also won't
>>>> automatically repair the corruption.
>>>
>>> Really?  If so I think that's a bug in BTRFS.  When mounted rw I thin=
k
>>> that every time corruption is discovered it should be automatically
>>> fixed.
>> That's debatable.  While it is safer to try and do this with BTRFS tha=
n
>> say with MD-RAID, it's still not something many seasoned system
>> administrators would want happening behind their back.  It's worth
>> noting that ZFS does not automatically fix errors, it just reports the=
m
>> and works around them, and many distributed storage options (like Ceph=

>> for example) behave like this also.  All that the checksum mismatch
>> really tells you is that at some point, the data got corrupted, it cou=
ld
>> be that the copy on the disk is bad, but it could also be caused by ba=
d
>> RAM, a bad storage controller, a loose cable, or even a bad power
>> supply.
>
> There's a significant difference between btrfs in dup/raid1/raid10 mode=
s
> anyway and some of the others you mentioned, however.  Btrfs in these
> modes actually has a second copy of the data itself available.  That's =
a
> world of difference compared to parity, for instance.  With parity you'=
re
> reconstructing the data and thus have dangers such as the write hole, a=
nd
> the possibility of bad-ram corrupting the data before it was ever saved=

> (this last one being the reason zfs has such strong recommendations/
> warnings regarding the use of non-ecc RAM, based on what a number of
> posters with zfs experience have said, here).  With btrfs, there's an
> actual second copy, with both copies covered by checksum.  If one of th=
e
> copies verifies against its checksum and the other doesn't, the odds of=

> the one that verifies being any worse than the one that doesn't are...
> pretty slim, to say the least.  (So slim I'd intuitively compare them t=
o
> the odds of getting hit by lightning, tho I've no idea what the
> mathematically rigorous comparison might be.)
ZFS doesn't just do parity, it also does RAID1 and RAID10 (and RAID0,=20
although I doubt that most people actually use that with ZFS), and Ceph=20
uses n-way replication by default, not erasure coding (which is=20
technically a super-set of the parity algorithms used for RAID[56]).  In =

both cases, they behave just like BTRFS, they log the error and fetch a=20
good copy to return to userspace, but do not modify the copy with the=20
error unless explicitly told to do so.
>
> Yes, there's some small but not infinitesimal chance the checksum may b=
e
> wrong, but if there's two copies of the data and the checksum on one is=

> wrong while the checksum on the other verifies... yes, there's still th=
at
> small chance that the one that verifies is wrong too, but that it's any=

> worse than the one that does not verify?  /That's/ getting close to
> infinitesimal, or at least close enough for the purposes of a mailing-
> list claim without links to supporting evidence by someone who has
> already characterized it as not mathematically rigorous... and for me,
> personally.  I'm not spending any serious time thinking about getting h=
it
> by lightening, either, tho by the same token I don't go out flying kite=
s
> or waving long metal rods around in lightning storms, either.
With a 32-bit checksum and a 4k block (the math is easier with smaller=20
numbers), that's 4128 bits, which means that a random single bit error=20
will have a approximately 0.24% chance of occurring in a given bit,=20
which translates to an approximately 7.75% chance that it will occur in=20
one of the checksum bits.  For a 16k block it's smaller of course=20
(around 1.8% I think, but that's just a guess), but it's still=20
sufficiently statistically likely that it should be considered.
>
> Meanwhile, it's worth noting that btrfs itself isn't yet entirely stabl=
e
> or mature, and that the chances of just plain old bugs killing the
> filesystem are far *FAR* higher than of a verified-checksum copy being
> any worse than a failed-checksum copy.  If you're worried about that at=

> this point, why are you even on the btrfs list in the first place?
Actually, the improved data safety relative to ext4 is just a bonus for=20
me, my biggest reason for using BTRFS is the ease of reprovisioning=20
(there are few other ways to move entire systems to new storage devices=20
online with zero downtime).



--------------ms030503000703020602080402
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDIwMTk1OTI0WjBPBgkq
hkiG9w0BCQQxQgRAT0+G7IkPXHrXBjTLvBinccyb33MVUPedqQOCTp/OYjCGq40Hm0NO1YrV
flJkEgYBt8Hj/nRlHVXnNnOaIc2+jDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgB/QOhOmh3q8jr3PkpvJIvGZtZDuR/m6fNoDMvQV7WO2g1BsYoW
D4WF9K9XhiP2stC8advNgy52H1aPvysFq67+0VgjC2+pDVcmhMZkEtJ7o29qxW2vMTq3uvPn
EIaQmkY8XE/h5PDQtSQBL93ennS7qPyFngrG0RblZXajy4ozPq54DUh13ovxNQFcCa0ku6QB
AATKLabEZg2PJ7uaD6sT+hCcrJoIGxvnfNhdsWosidePexyhr3nVAt88MWDEZEs3+L4/rpGn
jfWp1JJOQk0WN8FT01fujZTAkj+yGo9jmcy29rb16XqI0Px4N/gYGTUxIyX2ScoGfHD9gJtD
FQ+htZSttsCOMllmRDw/4/w1R+UMbCAKtwaVvkPI5Wehn1APjx+LvJOjJoSir8lN85L3+U11
/Sc6/K3f0+dEKrN0IU8VijpqYL25rpX7CBe7SgG0Ip8hMnP32xNdwvKsUZ/ELnBvZ/Un5L1j
oX5K+3YomPjJBoW4YA53mWNgjZ7/F472NLlsye3k6a5NnTbAnjZb/+4lhO8rSkxzDUmprTX3
kIK1yg3/r0aZNzU+x30NyMLh24pl+ApKrJro2VVEU/OWRIdV0K9cCBv37fzKpjGMxbigB0/G
DRz5a7Vpxv57iTjxPeni5Mz4kKkck0ZyzvhtIar6mfcCauiPD005ZdmuwgAAAAAAAA==
--------------ms030503000703020602080402--
