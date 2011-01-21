From: Freddie Cash <fjwcash@gmail.com>
Subject: Re: Synching a Backup Server
Date: Fri, 21 Jan 2011 11:28:19 -0800
Message-ID: <AANLkTikgsBx7UUeh9Un7KSus-F4f_5=FY2uu8imMhv8M@mail.gmail.com>
References: <201101060935.14059.CACook@quantum-sci.com>
	<201101061342.23991.CACook@quantum-sci.com>
	<AANLkTimOEsFiF7tiCzV-Y3NfGYHjK+uL_3O6PNDKum90@mail.gmail.com>
	<201101071720.08298.hka@qbs.com.pl>
	<4D29A033.7000803@chandlerfamily.org.uk>
	<AANLkTi=KASX7pFO8dxJ1P=OhP3qj6qjTgtA6g1Fw-ou4@mail.gmail.com>
	<4D29D508.6080006@chandlerfamily.org.uk>
	<AANLkTim96P3ZD-WpDonsOHB7aicNBQX-wK6v347r1z8s@mail.gmail.com>
	<20110109183030.GA29572@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Hugo Mills <hugo-lkml@carfax.org.uk>,
	Freddie Cash <fjwcash@gmail.com>,
	Alan Chandler <alan@chandlerfamily.org.uk>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110109183030.GA29572@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 9, 2011 at 10:30 AM, Hugo Mills <hugo-lkml@carfax.org.uk> w=
rote:
> On Sun, Jan 09, 2011 at 09:59:46AM -0800, Freddie Cash wrote:
>> Let see if I can match up the terminology and layers a bit:
>>
>> LVM Physical Volume =3D=3D Btrfs disk =3D=3D ZFS disk / vdevs
>> LVM Volume Group =3D=3D Btrfs "filesystem" =3D=3D ZFS storage pool
>> LVM Logical Volume =3D=3D Btrfs subvolume =3D=3D ZFS volume
>> 'normal' filesysm =3D=3D Btrfs subvolume (when mounted) =3D=3D ZFS f=
ilesystem
>>
>> Does that look about right?
>
> =C2=A0 Kind of. The thing is that the way that btrfs works is massive=
ly
> different to the way that LVM works (and probably massively different
> to the way that ZFS works, but I don't know much about ZFS, so I can'=
t
> comment there). I think that trying to think of btrfs in LVM terms is
> going to lead you to a large number of incorrect conclusions. It's
> just not a good model to use.

My biggest issue trying to understand Btrfs is figuring out the layers =
involved.

With ZFS, it's extremely easy:

disks --> vdev --> pool --> filesystems

With LVM, it's fairly easy:

disks -> volume group --> volumes --> filesystems

But, Btrfs doesn't make sense to me:

disks --> filesystem --> sub-volumes???

So, is Btrfs pooled storage or not?  Do you throw 24 disks into a
single Btrfs filesystem, and then split that up into separate
sub-volumes as needed?  From the looks of things, you don't have to
partition disks or worry about sizes before formatting (if the space
is available, Btrfs will use it).  But it also looks like you still
have to manage disks.

Or, maybe it's just that the initial creation is done via mkfs (as in,
formatting a partition with a filesystem) that's tripping me up after
using ZFS for so long (zpool creates the storage pool, manages the
disks, sets up redundancy levels, etc;  zfs creates filesystems and
volumes, and sets properties; no newfs/mkfs involved).

It looks like ZFS, Btrfs, and LVM should work in similar manners, but
the overloaded terminology (pool, volume, sub-volume, filesystem are
different in all three) and new terminology that's only in Btrfs is
confusing.

>> Just curious, why all the new terminology in btrfs for things that
>> already existed? =C2=A0And why are old terms overloaded with new mea=
nings?
>> I don't think I've seen a write-up about that anywhere (or I don't
>> remember it if I have).
>
> =C2=A0 The main awkward piece of btrfs terminology is the use of "RAI=
D" to
> describe btrfs's replication strategies. It's not RAID, and thinking
> of it in RAID terms is causing lots of confusion. Most of the other
> things in btrfs are, I think, named relatively sanely.

No, the main awkward piece of btrfs terminology is overloading
"filesystem" to mean "collection of disks" and creating "sub-volume"
to mean "filesystem".  At least, that's how it looks from way over
here.  :)

>> Perhaps it's time to start looking at separating the btrfs pool
>> creation tools out of mkfs (or renaming mkfs.btrfs), since you're
>> really building a a storage pool, and not a filesystem. =C2=A0It wou=
ld
>> prevent a lot of confusion with new users. =C2=A0It's great that the=
re's a
>> separate btrfs tool for manipulating btrfs setups, but "mkfs.btrfs" =
is
>> just wrong for creating the btrfs setup.
>
> =C2=A0 I think this is the wrong thing to do. I hope my explanation a=
bove
> helps.

As I understand it, the mkfs.btrfs is used to create the initial
filesystem across X disks with Y redundancy.  For everthing else
afterward, the btrfs tool is used to add disks, create snapshots,
delete snapshots, change redundancy settings, create sub-volumes, etc.
 Why not just add a "create" option to btrfs and retire mkfs.btrfs
completely.  Or rework mkfs.btrfs to create sub-volumes of an existing
btrfs setup?

What would be great is if there was an image that showed the layers in
Btrfs and how they interacted with the userspace tools.

Having a set of graphics that compared the layers in Btrfs with the
layers in the "normal" Linux disk/filesystem partitioning scheme, and
the LVM layering, would be best.

There's lots of info in the wiki, but no images, ASCII-art, graphics,
etc.  Trying to picture this mentally is not working.  :)

--=20
=46reddie Cash
fjwcash@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
