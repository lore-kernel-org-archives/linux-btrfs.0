Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:57741 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755136AbdKJAye (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 Nov 2017 19:54:34 -0500
Subject: Re: [PATCH 2/4] Btrfs: fix data corruption in raid6
To: bo.li.liu@oracle.com, Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
References: <20171102005405.20420-1-bo.li.liu@oracle.com>
 <20171102005405.20420-3-bo.li.liu@oracle.com>
 <133f72d7-4254-ccd4-76e5-1078f0b8a079@oracle.com>
 <20171108195315.GB14443@dhcp-10-11-181-32.int.fusionio.com>
 <ca33de53-1894-09d9-240d-d0f128a5fc83@oracle.com>
 <20171110001244.GA1494@dhcp-guadalajara-v701-172-21-36-39.mx.voip.oraclecorp.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <a4b625d9-cf3d-f8b9-4153-9115be7b764a@gmx.com>
Date: Fri, 10 Nov 2017 08:54:23 +0800
MIME-Version: 1.0
In-Reply-To: <20171110001244.GA1494@dhcp-guadalajara-v701-172-21-36-39.mx.voip.oraclecorp.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Uhb7TaWJkbOwLHnWAWrUcjKQTQccW9Nrn"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Uhb7TaWJkbOwLHnWAWrUcjKQTQccW9Nrn
Content-Type: multipart/mixed; boundary="KDb2mQWthQt0pEhOcvG5GxPAhS40xHM6A";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: bo.li.liu@oracle.com, Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <a4b625d9-cf3d-f8b9-4153-9115be7b764a@gmx.com>
Subject: Re: [PATCH 2/4] Btrfs: fix data corruption in raid6
References: <20171102005405.20420-1-bo.li.liu@oracle.com>
 <20171102005405.20420-3-bo.li.liu@oracle.com>
 <133f72d7-4254-ccd4-76e5-1078f0b8a079@oracle.com>
 <20171108195315.GB14443@dhcp-10-11-181-32.int.fusionio.com>
 <ca33de53-1894-09d9-240d-d0f128a5fc83@oracle.com>
 <20171110001244.GA1494@dhcp-guadalajara-v701-172-21-36-39.mx.voip.oraclecorp.com>
In-Reply-To: <20171110001244.GA1494@dhcp-guadalajara-v701-172-21-36-39.mx.voip.oraclecorp.com>

--KDb2mQWthQt0pEhOcvG5GxPAhS40xHM6A
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8810=E6=97=A5 08:12, Liu Bo wrote:
> On Thu, Nov 09, 2017 at 05:29:25PM +0800, Anand Jain wrote:
>>
>>
>> On 11/09/2017 03:53 AM, Liu Bo wrote:
>>> On Tue, Nov 07, 2017 at 04:32:55PM +0800, Anand Jain wrote:
>>>>
>>>>
>>>> On 11/02/2017 08:54 AM, Liu Bo wrote:
>>>>> With raid6 profile, btrfs can end up with data corruption by the
>>>>> following steps.
>>>>>
>>>>> Say we have a 5 disks that are set up with raid6 profile,
>>>>>
>>>>> 1) mount this btrfs
>>>>> 2) one disk gets pulled out
>>>>> 3) write something to btrfs and sync
>>>>> 4) another disk gets pulled out
>>>>> 5) write something to btrfs and sync
>>>>> 6) umount this btrfs
>>>>> 7) bring the two disk back
>>>>> 8) reboot
>>>>> 9) mount this btrfs
>>>>>
>>>>> Chances are mount will fail (even with -odegraded) because of failu=
re
>>>>> on reading metadata blocks, IOW, our raid6 setup is not able to
>>>>> protect two disk failures in some cases.
>>>>>
>>>>> So it turns out that there is a bug in raid6's recover code, that i=
s,
>>>>>
>>>>> if we have one of stripes in the raid6 layout as shown here,
>>>>>
>>>>> | D1(*)  | D2(*)  | D3 | D4 | D5    |
>>>>> -------------------------------------
>>>>> | data1  | data2  | P  | Q  | data0 |
>>>>
>>>>
>>>>> D1 and D2 are the two disks which got pulled out and brought back.
>>>>> When mount reads data1 and finds out that data1 doesn't match its c=
rc,
>>>>> btrfs goes to recover data1 from other stripes, what it'll be doing=
 is
>>>>>
>>>>> 1) read data2, parity P, parity Q and data0
>>>>>
>>>>> 2) as we have a valid parity P and two data stripes, it goes to
>>>>>    recover in raid5 style.
>>>>
>>>>
>>>>> (However, since disk D2 was pulled out and data2 on D2 could be sta=
le,
>>>>
>>>>  data2 should end up crc error, if not then raid5 recover is as
>>>>  expected OR this example is confusing to explain the context of
>>>>  two data stipe missing.
>>>
>>> The assumption you have is not true,
>>
>>> when doing reconstruction, we
>>> don't verify checksum for each data stripe that is read from disk.
>>
>>  Why ? what if data0 (which has InSync flag) was wrong ?
>>
>=20
> (Wrinting these took me the whole afternoon, hopefully it makes
> sense...)
>=20
> Checksum verification happens much later, in readpage's end io, and if
> data0 is wrong, then the rebuilt data couldn't match its checksum.
>=20
> As Qu Wenruo also has the same question, here is my input about why
> checksum is not done,
>=20
> a) We may have mutliple different raid profiles within one btrfs, and
>    checksum tree also resides somewhere on the disks, for
>    raid1(default) and raid5, two disk failures may end up with data
>    loss, it applies to raid6 as well because of the bug this patch is
>    addressing.

However, raid56 is more complex than other profiles, so it even has its
own raid56.[ch].
Although currently it's mostly for the complex RMW cycle, I think it can
also be enhanced to do csum verification at repair time.

>=20
> b) If this is a metadata stripe, then it's likely that the stale
>    content still matches with its checksum as metadata blocks store
>    their checksum in the header part, thus checksum verification can
>    not be trusted.

Metadata can be handled later, it's much more complex since (by default)
metadata crosses several pages, which makes it impossible to verify
until we rebuild all related pages.

BTW, if metadata (tree block) has stale content, it will not match the cs=
um.
Tree block csum is for the whole tree block, so any stale data in the
whole tree block will cause mismatched csum.
It's hard to do just because we can't verify if the rebuilt/original
tree block is good until we rebuild/read the whole tree block.

>=20
> c) If this is a data stripe, then chances are they're belonging to
>    nocow/nodatasum inodes such that no checksum could be verified.  In
>    case that checksum is available, yes, finally we can verify
>    checksum, but keep in mind, the whole data stripe may consist of
>    several pieces of data which are from different inodes, some may
>    nodatacow/nodatasum, some may not.

Ignore such case too.

>=20
> Given all the troubles it could lead to, I'd like to avoid it.

For hard parts, I think keeping them untouched until good solution is
found is completely acceptable.

No need to do it all-in-one, step by step should be the correct way.

>=20
> As a raid6 system, 2 disks failures can always be tolerated by
> rebuilding data from other good copies.
>=20
> Now that we have known two things, i.e.
> a) data1 fails its checksum verification and
> b) data2 from a out-of-sync disk might be stale,
> it's straightforward to rebuild data1 from other good copies.

But the out-of-sync flag is too generic to determine if we can trust the
copy.
Csum here is a much better indicator, which can provide page level (for
data) indicator other than device level.

For case 3 devices out-of-sync, we just treat it as 3 missing devices?

Thanks,
Qu
>=20
>=20
>>  I am wary about the In_sync approach. IMO we are loosing the
>>  advantage of FS being merged with volume manager - which is to
>>  know exactly which active stripes were lost for quicker reconstruct.
>>
>=20
> Thanks for pointing this out, I'd say filesystem still has some
> advantages over a vanilla volume manager while resync-ing out-of-sync
> disks.
>=20
>>  Lets say RAID6 is 50% full and disk1 is pulled out, and at 75%
>>  full disk2 is pulled out and reaches 90% full.
>>
>>  So now when all the disks are back, two disks will not have
>>  In_sync flag? hope I understood this correctly.
>>
>>  Now.
>>  15% of the data have lost two stripes.
>>  25% of the data have lost one stripe.
>>  50% of the data did not loose any stripe at all.
>>
>>  Now for read and reconstruct..
>>  50% of the data does not need any reconstruction.
>=20
> A 'Yes' for this, actually I should have avoided reading from
> out-of-sync disks, but I forgot to do so. So as a side effect, if the
> data read out from a out-of-sync disk matches its checksum, then it's
> proven to be OK.
>=20
>>  25% of the data needs RAID5 style reconstruction as they have lost on=
ly one
>> stripe.
>>  15% of the data needs RAID6 reconstruction since they have lost two
>> stripes.
>>
>=20
> It depends, the stripes on the out-of-sync disks could be
> a) all data stripes(as the example in this patch)
> b) one data stripe and one stripe P
> c) one data stripe and one stripe Q
>=20
> with In_sync flag,
> for a) raid6 reconstruction,
> for b) raid6 reconstruction,
> for c) raid5 reconstruction.
>=20
>>  Does InSync design here help to work like this ?
>>
>>  Now for RAID1, lets say disk1 lost first 10% of the stripes and
>>  disk2 lost the last 10% of the stripes and these stripes are mutually=

>>  exclusive. That means there is no single stripe which has lost
>>  completely.
>>
>=20
> True, probably we can drop patch 3 to let read happen on out-of-sync
> disks and go the existing repair routine.
>=20
>>  There is no code yet where I can see when the In_sync will be reset,
>>  which is fine for this eg. Assume no reconstruction is done. But now
>>  when both the disks are being mounted and as the In_sync will be base=
d
>>  on dev_item.generation, one of it will get In_sync to me it looks lik=
e
>>  there will be 10% of stripes which will fail even though its not
>>  practically true in this example.
>>
>=20
> Not sure if I understand this paragraph, are you talking about raid1
> or raid6?
>=20
> Regarding to when to reset In_sync, my naive idea is to utilize scrub
> to verify checksum on all content that filesystem knows and do the
> repair work, If it turns out that everything looks good, then we know
> the disk is already resync, it's a good time to set In_sync.
>=20
> Thanks,
>=20
> -liubo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--KDb2mQWthQt0pEhOcvG5GxPAhS40xHM6A--

--Uhb7TaWJkbOwLHnWAWrUcjKQTQccW9Nrn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloE+L8XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qisTQf8CCMlt0lfzLNbC7gFIKn0MlA0
APP85AtiIJ17HXtPwzxFC0xwrM/Px4cRwZf2TlmyFNSw3p2Rd6o8FvifJcEpEzNP
6hw831ANBle0TYaLK53OLIpKDVA3rlv8GX0pDrb/+DK5pPDVpgXf9T/0QmjUi/zh
GyS4OSXH6UvPmaKDrG3/o3mlq602K2pPERBcEg57IcbeabrqWDBTFrygzdsF1zrM
wooWGoukr7W6Gja1PQza5hbYAjnUzpb+tQzTI/jtypJx3CCAYe2aECg6yO+SUc8F
rRNOtqMwODCA5iAy1seiHMwOYyrvs43FBM/YgmJ1QMeCdaexJGCYvxx3Ue3nMg==
=l9ji
-----END PGP SIGNATURE-----

--Uhb7TaWJkbOwLHnWAWrUcjKQTQccW9Nrn--
