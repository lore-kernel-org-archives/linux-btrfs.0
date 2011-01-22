From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: Synching a Backup Server
Date: Sat, 22 Jan 2011 14:55:45 +0100
Message-ID: <201101221455.45968.hka@qbs.com.pl>
References: <201101060935.14059.CACook@quantum-sci.com> <20110109183030.GA29572@carfax.org.uk> <AANLkTikgsBx7UUeh9Un7KSus-F4f_5=FY2uu8imMhv8M@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
To: Freddie Cash <fjwcash@gmail.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikgsBx7UUeh9Un7KSus-F4f_5=FY2uu8imMhv8M@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 21 of January 2011 20:28:19 Freddie Cash wrote:
> On Sun, Jan 9, 2011 at 10:30 AM, Hugo Mills <hugo-lkml@carfax.org.uk>=
 wrote:
> > On Sun, Jan 09, 2011 at 09:59:46AM -0800, Freddie Cash wrote:
> >> Let see if I can match up the terminology and layers a bit:
> >>=20
> >> LVM Physical Volume =3D=3D Btrfs disk =3D=3D ZFS disk / vdevs
> >> LVM Volume Group =3D=3D Btrfs "filesystem" =3D=3D ZFS storage pool
> >> LVM Logical Volume =3D=3D Btrfs subvolume =3D=3D ZFS volume
> >> 'normal' filesysm =3D=3D Btrfs subvolume (when mounted) =3D=3D ZFS=
 filesystem
> >>=20
> >> Does that look about right?
> >=20
> >   Kind of. The thing is that the way that btrfs works is massively
> > different to the way that LVM works (and probably massively differe=
nt
> > to the way that ZFS works, but I don't know much about ZFS, so I ca=
n't
> > comment there). I think that trying to think of btrfs in LVM terms =
is
> > going to lead you to a large number of incorrect conclusions. It's
> > just not a good model to use.
>=20
> My biggest issue trying to understand Btrfs is figuring out the layer=
s
> involved.
>=20
> With ZFS, it's extremely easy:
>=20
> disks --> vdev --> pool --> filesystems
>=20
> With LVM, it's fairly easy:
>=20
> disks -> volume group --> volumes --> filesystems
>=20
> But, Btrfs doesn't make sense to me:
>=20
> disks --> filesystem --> sub-volumes???
>=20
> So, is Btrfs pooled storage or not?  Do you throw 24 disks into a
> single Btrfs filesystem, and then split that up into separate
> sub-volumes as needed?  From the looks of things, you don't have to
> partition disks or worry about sizes before formatting (if the space
> is available, Btrfs will use it).  But it also looks like you still
> have to manage disks.
>=20
> Or, maybe it's just that the initial creation is done via mkfs (as in=
,
> formatting a partition with a filesystem) that's tripping me up after
> using ZFS for so long (zpool creates the storage pool, manages the
> disks, sets up redundancy levels, etc;  zfs creates filesystems and
> volumes, and sets properties; no newfs/mkfs involved).
>=20
> It looks like ZFS, Btrfs, and LVM should work in similar manners, but
> the overloaded terminology (pool, volume, sub-volume, filesystem are
> different in all three) and new terminology that's only in Btrfs is
> confusing.

With btrfs you need to have *a* filesystem, once you have it, you can a=
dd and=20
remove disks/partitions from it, no need to use 'mkfs.btrfs', just 'btr=
fs'.

As for managing storage space: you don't. There's one single pool of st=
orage=20
that you can't divide. Quota support is also absent. The only thing you=
 can do=20
with storage is add more or remove some.

> >> Just curious, why all the new terminology in btrfs for things that
> >> already existed?  And why are old terms overloaded with new meanin=
gs?
> >> I don't think I've seen a write-up about that anywhere (or I don't
> >> remember it if I have).
> >=20
> >   The main awkward piece of btrfs terminology is the use of "RAID" =
to
> > describe btrfs's replication strategies. It's not RAID, and thinkin=
g
> > of it in RAID terms is causing lots of confusion. Most of the other
> > things in btrfs are, I think, named relatively sanely.
>=20
> No, the main awkward piece of btrfs terminology is overloading
> "filesystem" to mean "collection of disks" and creating "sub-volume"
> to mean "filesystem".  At least, that's how it looks from way over
> here.  :)

subvolumes are made to be able to snapshot only part of files residing =
on a=20
filesystem, that's their only feature right now

>=20
> >> Perhaps it's time to start looking at separating the btrfs pool
> >> creation tools out of mkfs (or renaming mkfs.btrfs), since you're
> >> really building a a storage pool, and not a filesystem.  It would
> >> prevent a lot of confusion with new users.  It's great that there'=
s a
> >> separate btrfs tool for manipulating btrfs setups, but "mkfs.btrfs=
" is
> >> just wrong for creating the btrfs setup.
> >=20
> >   I think this is the wrong thing to do. I hope my explanation abov=
e
> > helps.
>=20
> As I understand it, the mkfs.btrfs is used to create the initial
> filesystem across X disks with Y redundancy.  For everthing else
> afterward, the btrfs tool is used to add disks, create snapshots,
> delete snapshots, change redundancy settings, create sub-volumes, etc=
=2E
>  Why not just add a "create" option to btrfs and retire mkfs.btrfs
> completely.  Or rework mkfs.btrfs to create sub-volumes of an existin=
g
> btrfs setup?

all linux file systems use mkfs.<fs name>, there's no reason why btrfs=20
shouldn't. For creation of FS you use one command, for management you u=
se=20
other command. I'd say that's a pretty sane division.

>=20
> What would be great is if there was an image that showed the layers i=
n
> Btrfs and how they interacted with the userspace tools.

It would either be
* very complicated (if it included different allocation groups and how =
they=20
  interact) and useless for users=20
* very simple (you put one fs on many disks, snapshotable part of FS is=
 called=20
  subvolume) and pointless...

> Having a set of graphics that compared the layers in Btrfs with the
> layers in the "normal" Linux disk/filesystem partitioning scheme, and
> the LVM layering, would be best.

btrfs doesn't have layers to compare so it's rather hard to make such g=
raph.

> There's lots of info in the wiki, but no images, ASCII-art, graphics,
> etc.  Trying to picture this mentally is not working.  :)


--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=C3=B3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
