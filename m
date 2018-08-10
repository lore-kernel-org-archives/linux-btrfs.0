Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:54017 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727732AbeHJKYg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 06:24:36 -0400
Subject: Re: Report correct filesystem usage / limits on BTRFS subvolumes with
 quota
To: Tomasz Pala <gotar@polanet.pl>
Cc: linux-btrfs@vger.kernel.org
References: <0059606f-88bf-c919-450b-bf08e184b5a2@mailbox.org>
 <b10a3950-0b86-e4fb-3621-f4c5ad3d79e7@gmx.com>
 <20180809174811.GA27001@polanet.pl>
 <ecd793f3-55b3-84d4-80cf-3382a580037f@gmx.com>
 <20180810071748.GA5473@polanet.pl>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <33914565-224f-71b6-f319-7c66e3a69d4d@gmx.com>
Date: Fri, 10 Aug 2018 15:55:46 +0800
MIME-Version: 1.0
In-Reply-To: <20180810071748.GA5473@polanet.pl>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="PFkd64OTz9yFII8xvdtDYQaMkEbbrKHsU"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PFkd64OTz9yFII8xvdtDYQaMkEbbrKHsU
Content-Type: multipart/mixed; boundary="FsgppeXSeyCthQLojA45IVSY2oUQObRk1";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Tomasz Pala <gotar@polanet.pl>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <33914565-224f-71b6-f319-7c66e3a69d4d@gmx.com>
Subject: Re: Report correct filesystem usage / limits on BTRFS subvolumes with
 quota
References: <0059606f-88bf-c919-450b-bf08e184b5a2@mailbox.org>
 <b10a3950-0b86-e4fb-3621-f4c5ad3d79e7@gmx.com>
 <20180809174811.GA27001@polanet.pl>
 <ecd793f3-55b3-84d4-80cf-3382a580037f@gmx.com>
 <20180810071748.GA5473@polanet.pl>
In-Reply-To: <20180810071748.GA5473@polanet.pl>

--FsgppeXSeyCthQLojA45IVSY2oUQObRk1
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 8/10/18 3:17 PM, Tomasz Pala wrote:
> On Fri, Aug 10, 2018 at 07:35:32 +0800, Qu Wenruo wrote:
>=20
>>> when limiting somebody's data space we usually don't care about the
>>> underlying "savings" coming from any deduplicating technique - these =
are
>>> purely bonuses for system owner, so he could do larger resource overb=
ooking.
>>
>> In reality that's definitely not the case.
>=20
> Definitely? How do you "sell" a disk space when there is no upper bound=
?
> Every, and I mean _every_ resource quota out in the wild gives you an u=
ser-perspective.
> You can assign CPU cores/time, RAM or network bandwidth with HARD limit=
=2E
>=20
> Only after that you _can_ sometimes assign some best-effort
> outer, not guaranteed limits, like extra network bandwidth or grace
> periods with filesystem usage (disregarding technical details - in case=

> of quota you move hard limit beyond and apply lowere soft limit).
>=20
> This is the primary quota usage. Quotas don't save system resources,
> quotas are valuables to "sell" (by quotes I mean every possible
> allocations, including interorganisation accouting).
>=20
> Quotas are overbookable by design and like I said before, the underlyin=
g
> savings mechanism allow sysadm to increase actual overbooking ratio.
>=20
> If I run out of CPU, RAM, storage or network I simply need to expand
> such resource. I won't shrink quotas in such case.
> Or apply some other resuorce-saving technique, like LVM with VDO,
> swapping, RAM deduplication etc.
>=20
> If that is not the usecase of btrfs quotas, then it should be renamed t=
o
> not confuse users. Using the incorrect terms for things widely known
> leads to user frustration at least.
>=20
>> From what I see, most users would care more about exclusively used spa=
ce
>> (excl), other than the total space one subvolume is referring to (rfer=
).
>=20
> Consider this:
> 1. there is some "template" system-wide snapshot,
> 2. users X and Y have CoW copies of it - both see "0 bytes exclusive"?

Yep, although not zero, it's 16K.

> 3. sysadm removes "template" - what happens to X and Y quotas?

Still 16K, unless X or Y dropes their copy.

> 4. user X removes his copy - what happens to Y quota?

Now Y owns the all the snapshot exclusively.

In fact, it's not the correct way to organize your qgroups.
In your case, you should put a higher qgroup (1/0) to contain all the
original snapshot, and user X/Y's subvolume.

In that case, all the snapshots' data and X/Y's newer data are all
exclusive to qgroup 1/0 (as long as you don't do reflink to files out of
subvolume X/Y/snapshot).

And then exclusive number of qgroup 1/0 should be your total usage, and
as long as you don't do reflink out of X/Y/snapshot source, your rfer is
the same as excl, both representing how many bytes used by all three
subvolumes.

This is in btrfs-quota(5) man page.

>=20
> The first thing about virtually every mechanism should be
> discoverability and reliability. I expect my quota not to change withou=
t
> my interaction. Never. How did you cope with this?
> If not - how are you going to explain such weird behaviour to users?

Read the manual first.
Not every feature is suitable for every use case.

IIRC lvm thin is pretty much the same for the same case.

>=20
> Once again: numbers of quotas *I* got must not be influenced by externa=
l
> operations or foreign users.
>=20
>> The most common case is, you do a snapshot, user would only care how
>> much new space can be written into the subvolume, other than the total=

>> subvolume size.
>=20
> If only that would be the case... then exactly - I do care how much new=

> data is _guaranteed_ to fit on my storage.
>=20
> So please tell me, as I might get it wrong - what happens if source
> subvolume get's removed and the CoWed data are not shared anymore?

It's exclusive to the only owner.

> Is the quota recalculated? - this would be wrong, as there were no new =
data written.

It's recalculated and due to the owner change, the number will change.
It's about extent ownership, as already stated, not all solution suit
all use case.

If you don't think ownership change should change quota, then just don't
use btrfs quota (nor LVM thin if I didn't miss something), it doesn't
fit your use case.

Your use case need LVM snapshot (dm-snapshot), or follow my multi-level
qgroup setup above.

> Is the quota left intact? - this is wrong too, as this gives the false =
view of exclusive space taken.
>=20
> This is just another reincarnation of famous "btrfs df" problem you
> couldn't comprehend so long - when reporting "disk FREE" status I want
> to know the amount of data that is guaranteed to be written in current
> RAID profile, i.e. ignoring any possible savings from compression etc.

Because we have so many ways to use the unallocated space.
It's just impossible to give you a single number of how many space you
can use.

For 4 disk with 1T free space each, if you're using RAID5 for data, then
you can write 3T data.
But if you're also using RAID10 for metadata, and you're using default
inline, we can use small files to fill the free space, resulting 2T
available space.

So in this case how would you calculate the free space? 3T or 2T or
anything between them?

Only yourself know what the heck you're going to use the that 4 disks
with 1T free space each.
Btrfs can't look into your head and know what you're thinking.

>=20
>=20
> Please note: my assumptions are based on
> https://btrfs.wiki.kernel.org/index.php/Quota_support
>=20
> "File copy and file deletion may both affect limits since the unshared
> limit of another qgroup can change if the original volume's files are
> deleted and only one copy is remaining"
>=20
> so if I write something invalid this might be the source of my mistake.=

>=20
>=20
>>> And the numbers accounted should reflect the uncompressed sizes.
>>
>> No way for current extent based solution.
>=20
> OK, since the data is provided by the user, it's "compressableness"
> might be considered his saving (we only provide transparency).
>=20
>>> Moreover - if there would be per-subvolume RAID levels someday, the d=
ata
>>> should be accouted in relation to "default" (filesystem) RAID level,
>>> i.e. having a RAID0 subvolume on RAID1 fs should account half of the
>>> data, and twice the data in an opposite scenario (like "dup" profile =
on
>>> single-drive filesystem).
>>
>> No possible again for current extent based solution.
>=20
> Doesn't extent have information about devices it's cloned on? But OK,
> this is not important until per-subvolume profiles are available.

For device related info, it's block group related, and in fact you
shouldn't do the cross level calculation (mixing extent and block group
level together).

For extent level, there is just a super large plain address space from
0~U64_MAX.
Without extra inspection into block group/chunk mapping, we don't know
and have no need to know which extent is located.

Just consider btrfs as a filesystem on a dm-linear device, and parts of
the dm-linear space is mapped using dm-raid1/10/5/6, like:

                 Btrfs logical address space
            /                                  \
 /                                                           \
0///////|       ...           |////////|    ...               u64_max
 \     /                       \      /
 Chunk1                         Chunk N
 SINGLE                         RAID 1
 Mapped using dev A             Mapped using dev B and C
 Physical range X-Y             Physical range B, X-Y, C W-Z

Then you should understand what's going on and why your idea of mixing
extent and chunk are making things worse and confusing.

>=20
>>> In short: values representing quotas are user-oriented ("the numbers =
one
>>> bought"), not storage-oriented ("the numbers they actually occupy").
>>
>> Well, if something is not possible or brings so big performance impact=
,
>> there will be no argument on how it should work in the first place.
>=20
> Actually I think you did something overcomplicated (shared/exclusive),
> which would only lead to user confusion (especially when his data
> becomes "exclusive" one day without any known reason), misnamed ...and
> not reflecting anything valuable, unless the problems with extent
> fragmentation are already resolved somehow?

That's the design from the very beginning of btrfs, yelling at me makes
no sense at all.

If you want some solution to fit your case, I can only tell what btrfs
can do and can't.
I have tried to explain what btrfs quota does and it doesn't, if it
doesn't fit you use case, that's all.
(Whether you have ever tried to understand is another problem)

In fact your idea is pretty hard or even impossible to implement in near
future in btrfs.

>=20
> So IMHO current quotas are:
> - not discoverable for user (shared->exclusive transition of my data by=
 someone's else action),
> - not reliable for sysadm (offensive write pattern by any user can allo=
cate virtually any space despite of quotas).


--FsgppeXSeyCthQLojA45IVSY2oUQObRk1--

--PFkd64OTz9yFII8xvdtDYQaMkEbbrKHsU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlttRQIACgkQwj2R86El
/qjUEwf9Gsg64wnr4sguThCQUKavREDVjvrtJ8cAMyg5WdwhSb7ANKMSlTL/VjHd
dm9ca8R9ULr7PApRI2nAgrOuwBHbW0crwpcPTUThKrsNI0VJd+D74FjmRERaDpQp
PIzFTdpgm4OPtRqm/3Ev6jLdGpWhIUWGlkmyHx8H20YMmH1i+fsbwyO6YBngs+iD
vxWO9VdKWiT5OoDo5s8DvsstsUbmPsJgbn8V38htPNdJLhaibKgkVLQ9xAze1wa6
u/rwImNIEO6cvq+WNGcEdfwZ15PerCiNI6QLQzL0Rhp+v29GIdSzGXnvvwiTBPDE
S/OThd4NOd/ke6u7ePhb2Tt7Y42qQA==
=iHPB
-----END PGP SIGNATURE-----

--PFkd64OTz9yFII8xvdtDYQaMkEbbrKHsU--
