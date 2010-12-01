From: Freddie Cash <fjwcash@gmail.com>
Subject: Re: What to do about subvolumes?
Date: Wed, 1 Dec 2010 15:32:21 -0800
Message-ID: <AANLkTimMDwza0U32HEWAFFbz57xJOPhRQaV+mT_CzHBQ@mail.gmail.com>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
	<20101201163800.GA4087@carfax.org.uk>
	<20101201173830.GA7021@localhost.localdomain>
	<20101201193512.GB4087@carfax.org.uk>
	<AANLkTink81Mcc9yEUF2cw3TZg=7F6=H52A-tfbtb8E39@mail.gmail.com>
	<20101201212822.GC4087@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Hugo Mills <hugo-lkml@carfax.org.uk>,
	Freddie Cash <fjwcash@gmail.com>,
	Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chris.mason@oracle.
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20101201212822.GC4087@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 1, 2010 at 1:28 PM, Hugo Mills <hugo-lkml@carfax.org.uk> wr=
ote:
> On Wed, Dec 01, 2010 at 12:24:28PM -0800, Freddie Cash wrote:
>> On Wed, Dec 1, 2010 at 11:35 AM, Hugo Mills <hugo-lkml@carfax.org.uk=
> wrote:
>> >> =C2=A0The idea is you are only charged for what blocks
>> >> you have on the disk. =C2=A0Thanks,
>> >
>> > =C2=A0 My point was that it's perfectly possible to have blocks on=
 the
>> > disk that are effectively owned by two people, and that the person=
 to
>> > charge for those blocks is, to me, far from clear. You either end =
up
>> > charging twice for a single set of blocks on the disk, or you end =
up
>> > in a situation where one person's actions can cause another person=
's
>> > quota to fill up. Neither of these is particularly obvious behavio=
ur.
>>
>> As a sysadmin and as a user, quotas shouldn't be about "physical
>> blocks of storage used" but should be about "logical storage used".
>>
>> IOW, if the filesystem is compressed, using 1 GB of physical space t=
o
>> store 10 GB of data, my "quota used" should be 10 GB.
>>
>> Similar for deduplication. =C2=A0The quota is based on the storage *=
before*
>> the file is deduped. =C2=A0Not after.
>>
>> Similar for snapshots. =C2=A0If UserA has 10 GB of quota used, I sna=
pshot
>> their filesystem, then my "quota used" would be 10 GB as well. =C2=A0=
As
>> data in my snapshot changes, my "quota used" is updated to reflect
>> that (change 1 GB of data compared to snapshot, use 1 GB of quota).
>
> =C2=A0 So if I've got 10G of data, and I snapshot it, I've just used
> another 10G of quota?

Sorry, forgot the "per user" bit above.

If UserA has 10 GB of data, then UserB snapshots it, UserB's quota
usage is 10 GB.

If UserA has 10 GB of data and snapshots it, then only 10 GB of quota
usage is used, as there is 0 difference between the snapshot and the
filesystem.  As UserA modifies data, their quota usage increases by
the amount that is modified (ie 10 GB data, snapshot, modify 1 GB data
=3D=3D 11 GB quota usage).

If you combine the two scenarios, you end up with:
  - UserA has 10 GB of data =3D=3D 10 GB quota usage
  - UserB snapshots UserA's filesystem (clone), so UserB has 10 GB
quota usage (even though 0 blocks have changed on disk)
  - UserA snapshots UserA's filesystem =3D=3D no change to quota usage =
(no
blocks on disk have changed)
  - UserA modifies 1 GB of data in the filesystem =3D=3D 1 GB new quota
usage (11 GB total) (1 GB of blocks owned by UserA have changed, plus
the 10 GB in the snapshot)
  - UserB still only has 10 GB quota usage, since their snapshot
hasn't changed (0 blocks changed)

If UserA deletes their filesystem and all their snapshots, freeing up
11 GB of quota usage on their account, UserB's quota will still be 10
GB, and the blocks on the disk aren't actually removed (still
referenced by UserB's snapshot).

Basically, within a user's account, only the data unique to a snapshot
should count toward the quota.

Across accounts, the original (root) snapshot would count completely
to the new user's quota, and then only data unique to subsequent
snapshots would count.

I hope that makes it more clear.  :)  All the different layers and
whatnot get confusing.  :)

--=20
=46reddie Cash
fjwcash@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
