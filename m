From: Freddie Cash <fjwcash@gmail.com>
Subject: Re: Synching a Backup Server
Date: Mon, 24 Jan 2011 09:45:37 -0800
Message-ID: <AANLkTi=beCF0Wh1w095AE5P6XQoazz8tj7+Unt4XnX0f@mail.gmail.com>
References: <201101060935.14059.CACook@quantum-sci.com>
	<201101061342.23991.CACook@quantum-sci.com>
	<AANLkTimOEsFiF7tiCzV-Y3NfGYHjK+uL_3O6PNDKum90@mail.gmail.com>
	<201101071720.08298.hka@qbs.com.pl>
	<4D29A033.7000803@chandlerfamily.org.uk>
	<AANLkTi=KASX7pFO8dxJ1P=OhP3qj6qjTgtA6g1Fw-ou4@mail.gmail.com>
	<4D29D508.6080006@chandlerfamily.org.uk>
	<AANLkTim96P3ZD-WpDonsOHB7aicNBQX-wK6v347r1z8s@mail.gmail.com>
	<20110109183030.GA29572@carfax.org.uk>
	<AANLkTikgsBx7UUeh9Un7KSus-F4f_5=FY2uu8imMhv8M@mail.gmail.com>
	<20110122134557.GB29985@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Hugo Mills <hugo-lkml@carfax.org.uk>,
	Freddie Cash <fjwcash@gmail.com>,
	Alan Chandler <alan@chandlerfamily.org.uk>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110122134557.GB29985@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 22, 2011 at 5:45 AM, Hugo Mills <hugo-lkml@carfax.org.uk> w=
rote:
> On Fri, Jan 21, 2011 at 11:28:19AM -0800, Freddie Cash wrote:
>> So, is Btrfs pooled storage or not? =C2=A0Do you throw 24 disks into=
 a
>> single Btrfs filesystem, and then split that up into separate
>> sub-volumes as needed?
>
> =C2=A0 Yes, except that the subvolumes aren't quite as separate as yo=
u
> seem to think that they are. There's no preallocation of storage to a
> subvolume (in the way that LVM works), so you're only limited by the
> amount of free space in the whole pool. Also, data stored in the pool
> is actually free for use by any subvolume, and can be shared (see the
> deeper explanation below).

Ah, perfect, that I understand.  :)  It's the same with ZFS:  you add
storage to a pool, filesystems in the pool are free to use as much as
there is available, you don't have to pre-allocate or partition or
anything that.  ZFS supports quotas and reservations, though, so you
can (if you want/need) allocate bytes to specific filesystems.

>> =C2=A0From the looks of things, you don't have to
>> partition disks or worry about sizes before formatting (if the space
>> is available, Btrfs will use it). =C2=A0But it also looks like you s=
till
>> have to manage disks.
>>
>> Or, maybe it's just that the initial creation is done via mkfs (as i=
n,
>> formatting a partition with a filesystem) that's tripping me up afte=
r
>> using ZFS for so long (zpool creates the storage pool, manages the
>> disks, sets up redundancy levels, etc; =C2=A0zfs creates filesystems=
 and
>> volumes, and sets properties; no newfs/mkfs involved).
>
> =C2=A0 So potentially zpool -> mkfs.btrfs, and zfs -> btrfs. However,=
 I
> don't know enough about ZFS internals to know whether this is a
> reasonable analogy to make or not.

That's what I figured.  It's not a perfect analogue, but it's close
enough.  Clears things up a bit.

The big different is that ZFS separates storage management (the pool)
from filesystem management; while btrfs "creates a pool" underneath
one filesystem, and allows you to split it up via sub-volumes.

I think I'm figuring this out.  :)

> =C2=A0 Note that the actual file data, and the management of its loca=
tion
> on the disk (and its replication), is completely shared across
> subvolumes. The same extent may be used multiple times by different
> files, and those files may be in any subvolumes on the filesystem. In
> theory, the same extent could even appear several times in the same
> file. This sharing is how snapshots and COW copies are implemented.
> It's also the basis for Josef's dedup implementation.

That's similar to how ZFS works, only they use "blocks" instead of
"extents", but it works in a similar manner.

I think I've got this mostly figured out.

Now, to just wait for multiple parity redundancy (RAID5/6/+) support
to hit the tree, so I can start playing around with it.  :)

Thanks for taking the time to explain some things.  Sorry if I came
across as being harsh or whatnot.

--=20
=46reddie Cash
fjwcash@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
