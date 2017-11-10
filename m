Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:62032 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752713AbdKJKQB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Nov 2017 05:16:01 -0500
Subject: Re: [PATCH 2/4] Btrfs: fix data corruption in raid6
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: bo.li.liu@oracle.com, Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
References: <20171102005405.20420-1-bo.li.liu@oracle.com>
 <20171102005405.20420-3-bo.li.liu@oracle.com>
 <133f72d7-4254-ccd4-76e5-1078f0b8a079@oracle.com>
 <20171108195315.GB14443@dhcp-10-11-181-32.int.fusionio.com>
 <ca33de53-1894-09d9-240d-d0f128a5fc83@oracle.com>
 <20171110001244.GA1494@dhcp-guadalajara-v701-172-21-36-39.mx.voip.oraclecorp.com>
 <a4b625d9-cf3d-f8b9-4153-9115be7b764a@gmx.com>
Message-ID: <a801c713-0913-a998-8ef0-d39991408e1b@gmx.com>
Date: Fri, 10 Nov 2017 18:15:50 +0800
MIME-Version: 1.0
In-Reply-To: <a4b625d9-cf3d-f8b9-4153-9115be7b764a@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JjlgblVaV8pjo7WoMI2O3WW5rkH2TR91E"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JjlgblVaV8pjo7WoMI2O3WW5rkH2TR91E
Content-Type: multipart/mixed; boundary="BSsgi4UdEU9HiNChNiSw9RNXsEVahvUr0";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: bo.li.liu@oracle.com, Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <a801c713-0913-a998-8ef0-d39991408e1b@gmx.com>
Subject: Re: [PATCH 2/4] Btrfs: fix data corruption in raid6
References: <20171102005405.20420-1-bo.li.liu@oracle.com>
 <20171102005405.20420-3-bo.li.liu@oracle.com>
 <133f72d7-4254-ccd4-76e5-1078f0b8a079@oracle.com>
 <20171108195315.GB14443@dhcp-10-11-181-32.int.fusionio.com>
 <ca33de53-1894-09d9-240d-d0f128a5fc83@oracle.com>
 <20171110001244.GA1494@dhcp-guadalajara-v701-172-21-36-39.mx.voip.oraclecorp.com>
 <a4b625d9-cf3d-f8b9-4153-9115be7b764a@gmx.com>
In-Reply-To: <a4b625d9-cf3d-f8b9-4153-9115be7b764a@gmx.com>

--BSsgi4UdEU9HiNChNiSw9RNXsEVahvUr0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8810=E6=97=A5 08:54, Qu Wenruo wrote:
>=20
>=20
> On 2017=E5=B9=B411=E6=9C=8810=E6=97=A5 08:12, Liu Bo wrote:
>> On Thu, Nov 09, 2017 at 05:29:25PM +0800, Anand Jain wrote:
>>>
>>>
>>> On 11/09/2017 03:53 AM, Liu Bo wrote:
>>>> On Tue, Nov 07, 2017 at 04:32:55PM +0800, Anand Jain wrote:
>>>>>
>>>>>
>>>>> On 11/02/2017 08:54 AM, Liu Bo wrote:
>>>>>> With raid6 profile, btrfs can end up with data corruption by the
>>>>>> following steps.
>>>>>>
>>>>>> Say we have a 5 disks that are set up with raid6 profile,
>>>>>>
>>>>>> 1) mount this btrfs
>>>>>> 2) one disk gets pulled out
>>>>>> 3) write something to btrfs and sync
>>>>>> 4) another disk gets pulled out
>>>>>> 5) write something to btrfs and sync
>>>>>> 6) umount this btrfs
>>>>>> 7) bring the two disk back
>>>>>> 8) reboot
>>>>>> 9) mount this btrfs
>>>>>>
>>>>>> Chances are mount will fail (even with -odegraded) because of fail=
ure
>>>>>> on reading metadata blocks, IOW, our raid6 setup is not able to
>>>>>> protect two disk failures in some cases.
>>>>>>
>>>>>> So it turns out that there is a bug in raid6's recover code, that =
is,
>>>>>>
>>>>>> if we have one of stripes in the raid6 layout as shown here,
>>>>>>
>>>>>> | D1(*)  | D2(*)  | D3 | D4 | D5    |
>>>>>> -------------------------------------
>>>>>> | data1  | data2  | P  | Q  | data0 |
>>>>>
>>>>>
>>>>>> D1 and D2 are the two disks which got pulled out and brought back.=

>>>>>> When mount reads data1 and finds out that data1 doesn't match its =
crc,
>>>>>> btrfs goes to recover data1 from other stripes, what it'll be doin=
g is
>>>>>>
>>>>>> 1) read data2, parity P, parity Q and data0
>>>>>>
>>>>>> 2) as we have a valid parity P and two data stripes, it goes to
>>>>>>    recover in raid5 style.
>>>>>
>>>>>
>>>>>> (However, since disk D2 was pulled out and data2 on D2 could be st=
ale,
>>>>>
>>>>>  data2 should end up crc error, if not then raid5 recover is as
>>>>>  expected OR this example is confusing to explain the context of
>>>>>  two data stipe missing.
>>>>
>>>> The assumption you have is not true,
>>>
>>>> when doing reconstruction, we
>>>> don't verify checksum for each data stripe that is read from disk.
>>>
>>>  Why ? what if data0 (which has InSync flag) was wrong ?
>>>
>>
>> (Wrinting these took me the whole afternoon, hopefully it makes
>> sense...)
>>
>> Checksum verification happens much later, in readpage's end io, and if=

>> data0 is wrong, then the rebuilt data couldn't match its checksum.
>>
>> As Qu Wenruo also has the same question, here is my input about why
>> checksum is not done,
>>
>> a) We may have mutliple different raid profiles within one btrfs, and
>>    checksum tree also resides somewhere on the disks, for
>>    raid1(default) and raid5, two disk failures may end up with data
>>    loss, it applies to raid6 as well because of the bug this patch is
>>    addressing.
>=20
> However, raid56 is more complex than other profiles, so it even has its=

> own raid56.[ch].
> Although currently it's mostly for the complex RMW cycle, I think it ca=
n
> also be enhanced to do csum verification at repair time.

BTW, repair can even be done without verifying csum of data2/data0.

Just try all repair combination, until the repair result matches
checksum, or no combination can result a good repair.

I know this sounds stupid, but at least this means it's possible.

The main point here is, we should at least ensure repair result matches
checksum.

This also reminds me that, checksum verification should be handled at
lower level, other than doing it at endio time.

(Not related to this topic, but I also want to implement optional csum
check hook in bio, so for case like dm-integrity on dm-raid1 can
recognize bad and good copy, and even let btrfs to reuse device mapper
to do chunk map, but that's another story)

Thanks,
Qu

>=20
>>
>> b) If this is a metadata stripe, then it's likely that the stale
>>    content still matches with its checksum as metadata blocks store
>>    their checksum in the header part, thus checksum verification can
>>    not be trusted.
>=20
> Metadata can be handled later, it's much more complex since (by default=
)
> metadata crosses several pages, which makes it impossible to verify
> until we rebuild all related pages.
>=20
> BTW, if metadata (tree block) has stale content, it will not match the =
csum.
> Tree block csum is for the whole tree block, so any stale data in the
> whole tree block will cause mismatched csum.
> It's hard to do just because we can't verify if the rebuilt/original
> tree block is good until we rebuild/read the whole tree block.
>=20
>>
>> c) If this is a data stripe, then chances are they're belonging to
>>    nocow/nodatasum inodes such that no checksum could be verified.  In=

>>    case that checksum is available, yes, finally we can verify
>>    checksum, but keep in mind, the whole data stripe may consist of
>>    several pieces of data which are from different inodes, some may
>>    nodatacow/nodatasum, some may not.
>=20
> Ignore such case too.
>=20
>>
>> Given all the troubles it could lead to, I'd like to avoid it.
>=20
> For hard parts, I think keeping them untouched until good solution is
> found is completely acceptable.
>=20
> No need to do it all-in-one, step by step should be the correct way.
>=20
>>
>> As a raid6 system, 2 disks failures can always be tolerated by
>> rebuilding data from other good copies.
>>
>> Now that we have known two things, i.e.
>> a) data1 fails its checksum verification and
>> b) data2 from a out-of-sync disk might be stale,
>> it's straightforward to rebuild data1 from other good copies.
>=20
> But the out-of-sync flag is too generic to determine if we can trust th=
e
> copy.
> Csum here is a much better indicator, which can provide page level (for=

> data) indicator other than device level.
>=20
> For case 3 devices out-of-sync, we just treat it as 3 missing devices?
>=20
> Thanks,
> Qu
>>
>>
>>>  I am wary about the In_sync approach. IMO we are loosing the
>>>  advantage of FS being merged with volume manager - which is to
>>>  know exactly which active stripes were lost for quicker reconstruct.=

>>>
>>
>> Thanks for pointing this out, I'd say filesystem still has some
>> advantages over a vanilla volume manager while resync-ing out-of-sync
>> disks.
>>
>>>  Lets say RAID6 is 50% full and disk1 is pulled out, and at 75%
>>>  full disk2 is pulled out and reaches 90% full.
>>>
>>>  So now when all the disks are back, two disks will not have
>>>  In_sync flag? hope I understood this correctly.
>>>
>>>  Now.
>>>  15% of the data have lost two stripes.
>>>  25% of the data have lost one stripe.
>>>  50% of the data did not loose any stripe at all.
>>>
>>>  Now for read and reconstruct..
>>>  50% of the data does not need any reconstruction.
>>
>> A 'Yes' for this, actually I should have avoided reading from
>> out-of-sync disks, but I forgot to do so. So as a side effect, if the
>> data read out from a out-of-sync disk matches its checksum, then it's
>> proven to be OK.
>>
>>>  25% of the data needs RAID5 style reconstruction as they have lost o=
nly one
>>> stripe.
>>>  15% of the data needs RAID6 reconstruction since they have lost two
>>> stripes.
>>>
>>
>> It depends, the stripes on the out-of-sync disks could be
>> a) all data stripes(as the example in this patch)
>> b) one data stripe and one stripe P
>> c) one data stripe and one stripe Q
>>
>> with In_sync flag,
>> for a) raid6 reconstruction,
>> for b) raid6 reconstruction,
>> for c) raid5 reconstruction.
>>
>>>  Does InSync design here help to work like this ?
>>>
>>>  Now for RAID1, lets say disk1 lost first 10% of the stripes and
>>>  disk2 lost the last 10% of the stripes and these stripes are mutuall=
y
>>>  exclusive. That means there is no single stripe which has lost
>>>  completely.
>>>
>>
>> True, probably we can drop patch 3 to let read happen on out-of-sync
>> disks and go the existing repair routine.
>>
>>>  There is no code yet where I can see when the In_sync will be reset,=

>>>  which is fine for this eg. Assume no reconstruction is done. But now=

>>>  when both the disks are being mounted and as the In_sync will be bas=
ed
>>>  on dev_item.generation, one of it will get In_sync to me it looks li=
ke
>>>  there will be 10% of stripes which will fail even though its not
>>>  practically true in this example.
>>>
>>
>> Not sure if I understand this paragraph, are you talking about raid1
>> or raid6?
>>
>> Regarding to when to reset In_sync, my naive idea is to utilize scrub
>> to verify checksum on all content that filesystem knows and do the
>> repair work, If it turns out that everything looks good, then we know
>> the disk is already resync, it's a good time to set In_sync.
>>
>> Thanks,
>>
>> -liubo
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>=20


--BSsgi4UdEU9HiNChNiSw9RNXsEVahvUr0--

--JjlgblVaV8pjo7WoMI2O3WW5rkH2TR91E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloFfFcXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiEOwf6AjSGsC0gAkfFJYrpvzzNq87h
VEWPYcH1Cs5xiAgqj1V7SdB/oAn/KzHuQrp6gBc+vKwTau2ef3Vvaz9A4fDUvx9Z
PHG/V5OD6hUNGSeYWzxYbP5AVzVWlHejtK5N3L9GkS8H+F55aSI+p+Rq+xeT/LRN
VqghAXEbjkAEL3UFWcNcuBrCHqUQF23S2SUSofCpAsW5tBkI06THKZpeC01sDmzP
Ix5l49DZGLMamHIaDjfxvQadQtWHijVSvgEF/YWNk4W0rVdJM6hI8972Pmz1zee6
fcnnfcfW3/e4bdryfUBmV8HZ4cBzZa4g2z3gRYFPMqVDLYVNnsZ1wMOCR6uw9Q==
=k/fl
-----END PGP SIGNATURE-----

--JjlgblVaV8pjo7WoMI2O3WW5rkH2TR91E--
