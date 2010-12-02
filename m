From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: What to do about subvolumes?
Date: Wed, 1 Dec 2010 20:46:04 -0800
Message-ID: <AANLkTi=EhOj90gR3oUjkgKztkgtw4z_Zvp6ELso8K0zm@mail.gmail.com>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
	<20101201163800.GA4087@carfax.org.uk>
	<20101201173830.GA7021@localhost.localdomain>
	<20101201193512.GB4087@carfax.org.uk>
	<AANLkTink81Mcc9yEUF2cw3TZg=7F6=H52A-tfbtb8E39@mail.gmail.com>
	<20101201212822.GC4087@carfax.org.uk>
	<AANLkTimMDwza0U32HEWAFFbz57xJOPhRQaV+mT_CzHBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Hugo Mills <hugo-lkml@carfax.org.uk>,
	Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chris.mason@oracle.com, hch@lst.de,
	ssorce@redhat.com
To: Freddie Cash <fjwcash@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimMDwza0U32HEWAFFbz57xJOPhRQaV+mT_CzHBQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 1, 2010 at 3:32 PM, Freddie Cash <fjwcash@gmail.com> wrote:
> On Wed, Dec 1, 2010 at 1:28 PM, Hugo Mills <hugo-lkml@carfax.org.uk> =
wrote:
>> On Wed, Dec 01, 2010 at 12:24:28PM -0800, Freddie Cash wrote:
>>> On Wed, Dec 1, 2010 at 11:35 AM, Hugo Mills <hugo-lkml@carfax.org.u=
k> wrote:
>>> >> =C2=A0The idea is you are only charged for what blocks
>>> >> you have on the disk. =C2=A0Thanks,
>>> >
>>> > =C2=A0 My point was that it's perfectly possible to have blocks o=
n the
>>> > disk that are effectively owned by two people, and that the perso=
n to
>>> > charge for those blocks is, to me, far from clear. You either end=
 up
>>> > charging twice for a single set of blocks on the disk, or you end=
 up
>>> > in a situation where one person's actions can cause another perso=
n's
>>> > quota to fill up. Neither of these is particularly obvious behavi=
our.
>>>
>>> As a sysadmin and as a user, quotas shouldn't be about "physical
>>> blocks of storage used" but should be about "logical storage used".
>>>
>>> IOW, if the filesystem is compressed, using 1 GB of physical space =
to
>>> store 10 GB of data, my "quota used" should be 10 GB.
>>>
>>> Similar for deduplication. =C2=A0The quota is based on the storage =
*before*
>>> the file is deduped. =C2=A0Not after.
>>>
>>> Similar for snapshots. =C2=A0If UserA has 10 GB of quota used, I sn=
apshot
>>> their filesystem, then my "quota used" would be 10 GB as well. =C2=A0=
As
>>> data in my snapshot changes, my "quota used" is updated to reflect
>>> that (change 1 GB of data compared to snapshot, use 1 GB of quota).
>>
>> =C2=A0 So if I've got 10G of data, and I snapshot it, I've just used
>> another 10G of quota?
>
> Sorry, forgot the "per user" bit above.
>
> If UserA has 10 GB of data, then UserB snapshots it, UserB's quota
> usage is 10 GB.
>
> If UserA has 10 GB of data and snapshots it, then only 10 GB of quota
> usage is used, as there is 0 difference between the snapshot and the
> filesystem. =C2=A0As UserA modifies data, their quota usage increases=
 by
> the amount that is modified (ie 10 GB data, snapshot, modify 1 GB dat=
a
> =3D=3D 11 GB quota usage).
>
> If you combine the two scenarios, you end up with:
> =C2=A0- UserA has 10 GB of data =3D=3D 10 GB quota usage
> =C2=A0- UserB snapshots UserA's filesystem (clone), so UserB has 10 G=
B
> quota usage (even though 0 blocks have changed on disk)

Please define where the owner of a subvolume/snapshot is stored.

To my knowledge when you make a snapshot, you have the same set of
files with the same set of owners and groups.  Whatever user does the
snapshot this does not change this unless chown or chgrp are used.

Also a non-root user (or a process without CAP_whatever) should not be
able to snapshot a subvolume where the root directory of that
subvolume is not owned by the user attempting the snapshot.   If you
do not do so then you end up with the same security and quota issues
that hard links have when you don't have separate filesystems.

You could have separate subvolumes for / and /home/foo and user foo
could snapshot / to /home/foo/exploit_later_001 and then foo can just
wait for an exploit to come along for one of the binaries or libs in
/home/foo/exploit_later_001 and own.

Yes, snapshot creation should be more restricted than hard links, for
good reason.

I have other questions but the answer to this fundamental game changer
may solve many of the mentioned issues.

> =C2=A0- UserA snapshots UserA's filesystem =3D=3D no change to quota =
usage (no
> blocks on disk have changed)
> =C2=A0- UserA modifies 1 GB of data in the filesystem =3D=3D 1 GB new=
 quota
> usage (11 GB total) (1 GB of blocks owned by UserA have changed, plus
> the 10 GB in the snapshot)
> =C2=A0- UserB still only has 10 GB quota usage, since their snapshot
> hasn't changed (0 blocks changed)
>
> If UserA deletes their filesystem and all their snapshots, freeing up
> 11 GB of quota usage on their account, UserB's quota will still be 10
> GB, and the blocks on the disk aren't actually removed (still
> referenced by UserB's snapshot).
>
> Basically, within a user's account, only the data unique to a snapsho=
t
> should count toward the quota.
>
> Across accounts, the original (root) snapshot would count completely
> to the new user's quota, and then only data unique to subsequent
> snapshots would count.
>
> I hope that makes it more clear. =C2=A0:) =C2=A0All the different lay=
ers and
> whatnot get confusing. =C2=A0:)
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
