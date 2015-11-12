Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:35431 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbbKLMrY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Nov 2015 07:47:24 -0500
Received: by ioc74 with SMTP id 74so63390423ioc.2
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2015 04:47:24 -0800 (PST)
Subject: Re: Potential to loose data in case of disk failure
To: Sean Greenslade <sean@seangreenslade.com>,
        Jim Murphy <srlinuxadmin@gmail.com>
References: <CAKJi5fik1RsPQ7SA1P6=VmTwr06jrGFAA1cSWrVm0xoCrnhujA@mail.gmail.com>
 <20151111202403.GA19245@wheatley.student.rit.edu>
Cc: linux-btrfs@vger.kernel.org
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56448A54.9020404@gmail.com>
Date: Thu, 12 Nov 2015 07:47:16 -0500
MIME-Version: 1.0
In-Reply-To: <20151111202403.GA19245@wheatley.student.rit.edu>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms030205020904040303050903"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030205020904040303050903
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-11 15:24, Sean Greenslade wrote:
> On Wed, Nov 11, 2015 at 11:30:57AM -0600, Jim Murphy wrote:
>> Hi all,
>>
>> What am I missing or misunderstanding?  I have a newly
>> purchased laptop I want/need to multi boot different OSs
>> on.  As a result after partitioning I have ended up with two
>> partitions on each of the two internal drives(sda3, sda8,
>> sdb3 and sdb8).  FWIW, sda3 and sdb3 are the same size
>> and sda8 and sdb8 are the same size.  As an end result
>> I want one btrfs raid1 filesystem.  For lack of better terms,
>> sda3 and sda8 "concatenated" together, sdb3 and sdb8
>> "concatenated" together and then mirroring "sda" to "sdb"
>> using only btrfs.  So far have found no use-case to cover
>> this.
>>
>> If I create a raid1 btrfs volume using all 4 "devices" as I
>> understand it I would loose data if I were to loose a drive
>> because two mirror possibilities would be:
>>
>> sda3 mirrored to sda8
>> sdb3 mirrored to sdb8
>>
>> Is what I want to do possible without using MD-RAID and/or
>> LVM?  If so would someone point me to the documentation
>> I missed.  For whatever reason, I don't want to believe that
>> this can't be done.  I want to believe that the code in btrfs
>> is smart enough to know that sda3 and sda8 are on the same
>> drive and would not try to mirror data between them except in
>> a test setup.  I hope  I just missed some documentation,
>> somewhere.
>>
>> Thanks in advance for your help.  And last but not least,
>> thanks to all for your work on btrfs.
>>
>> Jim
>
> That's a pretty unusual setup, so I'm not surprised there's no quick an=
d
> easy answer. The best solution in my opinion would be to shuffle your
> partitions around and combine sda3 and sda8 into a single partition.
> There's generally no reason to present btrfs with two different
> partitions on the same disk.
>
> If there's something that prevents you from doing that, you may be able=

> to use RAID10 or RAID6 somehow. I'm not really sure, though, so I'll
> defer to others on the list for implementation details.
RAID10 has the same issue.  Assume you have 1 block.  This gets stored=20
as 2 copies, each with 2 stripes, with the stripes split symmetrically.=20
  For this, call the first half of the first copy 1a, the second half=20
1b, and likewise for 2a and 2b with the second copy.  1a and 2a have=20
identical contents, and 1b and 2b have identical contents.  It is fully=20
possible that you will end up with this block striped such that 1a and=20
2a are on one disk, and 1b and 2b on the other.  Based on this, losing=20
one disk would mean losing half the block, which would mean based on how =

BTRFS works that you would lose the whole block (because neither copy=20
would be complete).



--------------ms030205020904040303050903
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTEyMTI0NzE2WjBPBgkq
hkiG9w0BCQQxQgRA5ARR18uM8S6NFqC6JL53Gv/1zEH1VVkyyIAcNvquqgykmh0gMm3hUAc2
42KnRF08UBhOTaHLjk8nZ9pSPCkvGDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBdh07ACQHlaIY6eSGmEn41EO/0hc+CEeXRdif5LXaJr6uOQa/F
UsR/K/nqhRlu/+2sfqHVuycUoJaB3E7WLtzfxcOK8rnc3g3Wkym0quH/5aL1oCX1nhgCR2x/
pfnN6bXuxC+ZY5uL2CEMR75g5NpA3P4UaGuxuDgZSl7MoMPievQNPeiE6+kKmduFmk8Z3AJH
zZgxrptl6bnFvTalR5hNGDu05Mlodthh5RqNpu+sbsQzGOv3EukKHieO1xn5bEA3WeN2KsS7
aVR7zzqQ/vvM3WFrRlXiT5JLVl+1WERVlp2c2StwhCqcvgphaOdNRT0B3CjwzrVXh3AQT/v/
KJfJjv53fZdClzNDFMLRuqPb1CyVsZT73K2aqeFHjytbGNo4BOK0m+t6c8ZBUm7a+NjODumb
eVdyi3k8zCQ5GsHccXdyft1BrerrJbys7WMQPong9t2Mz+hM7XFre9TspFMbE/mz9jQ3pQAu
VTsV69foqWCFa7NQl6QkWZot5YBvWE5SKwjn9oHXjVAKuvKp52x1YTxGqNMza0lGX0V3hJyU
FoGuTIMo65cVRA1XW0wri3jHm3sv8GP7nv4Qb4jcnmidwsZi9hzcwjGea17np859mC8PAUn4
5dv1kP8Q2+lwTXEn7SSs1RsNfKWAt0e5K/QMdK2GbdrsmU0t/BmED98YCQAAAAAAAA==
--------------ms030205020904040303050903--
