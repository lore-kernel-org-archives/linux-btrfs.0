From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Synching a Backup Server
Date: Sat, 22 Jan 2011 13:45:57 +0000
Message-ID: <20110122134557.GB29985@carfax.org.uk>
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
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fba/0zbH8Xs+Fj9o"
Cc: Hugo Mills <hugo-lkml@carfax.org.uk>,
	Alan Chandler <alan@chandlerfamily.org.uk>,
	linux-btrfs@vger.kernel.org
To: Freddie Cash <fjwcash@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikgsBx7UUeh9Un7KSus-F4f_5=FY2uu8imMhv8M@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--Fba/0zbH8Xs+Fj9o
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 21, 2011 at 11:28:19AM -0800, Freddie Cash wrote:
> On Sun, Jan 9, 2011 at 10:30 AM, Hugo Mills <hugo-lkml@carfax.org.uk> wro=
te:
> > On Sun, Jan 09, 2011 at 09:59:46AM -0800, Freddie Cash wrote:
> >> Let see if I can match up the terminology and layers a bit:
> >>
> >> LVM Physical Volume =3D=3D Btrfs disk =3D=3D ZFS disk / vdevs
> >> LVM Volume Group =3D=3D Btrfs "filesystem" =3D=3D ZFS storage pool
> >> LVM Logical Volume =3D=3D Btrfs subvolume =3D=3D ZFS volume
> >> 'normal' filesysm =3D=3D Btrfs subvolume (when mounted) =3D=3D ZFS fil=
esystem
> >>
> >> Does that look about right?
> >
> > =A0 Kind of. The thing is that the way that btrfs works is massively
> > different to the way that LVM works (and probably massively different
> > to the way that ZFS works, but I don't know much about ZFS, so I can't
> > comment there). I think that trying to think of btrfs in LVM terms is
> > going to lead you to a large number of incorrect conclusions. It's
> > just not a good model to use.
>=20
> My biggest issue trying to understand Btrfs is figuring out the layers in=
volved.
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
> sub-volumes as needed?

   Yes, except that the subvolumes aren't quite as separate as you
seem to think that they are. There's no preallocation of storage to a
subvolume (in the way that LVM works), so you're only limited by the
amount of free space in the whole pool. Also, data stored in the pool
is actually free for use by any subvolume, and can be shared (see the
deeper explanation below).

>  From the looks of things, you don't have to
> partition disks or worry about sizes before formatting (if the space
> is available, Btrfs will use it).  But it also looks like you still
> have to manage disks.
>=20
> Or, maybe it's just that the initial creation is done via mkfs (as in,
> formatting a partition with a filesystem) that's tripping me up after
> using ZFS for so long (zpool creates the storage pool, manages the
> disks, sets up redundancy levels, etc;  zfs creates filesystems and
> volumes, and sets properties; no newfs/mkfs involved).

   So potentially zpool -> mkfs.btrfs, and zfs -> btrfs. However, I
don't know enough about ZFS internals to know whether this is a
reasonable analogy to make or not.

> It looks like ZFS, Btrfs, and LVM should work in similar manners, but
> the overloaded terminology (pool, volume, sub-volume, filesystem are
> different in all three) and new terminology that's only in Btrfs is
> confusing.
>=20
> >> Just curious, why all the new terminology in btrfs for things that
> >> already existed? =A0And why are old terms overloaded with new meanings?
> >> I don't think I've seen a write-up about that anywhere (or I don't
> >> remember it if I have).
> >
> > =A0 The main awkward piece of btrfs terminology is the use of "RAID" to
> > describe btrfs's replication strategies. It's not RAID, and thinking
> > of it in RAID terms is causing lots of confusion. Most of the other
> > things in btrfs are, I think, named relatively sanely.
>=20
> No, the main awkward piece of btrfs terminology is overloading
> "filesystem" to mean "collection of disks" and creating "sub-volume"
> to mean "filesystem".  At least, that's how it looks from way over
> here.  :)

   As I've tried to explain, that's the wrong way of looking at it.
Let me have another go in more detail.

   There's *one* filesystem. It contains:

 - *One* set of metadata about the underlying disks (the dev tree).
 - *One* set of metadata about the distribution of the storage pool on thos=
e disks (the chunk tree)
 - *One* set of metadata about extents within that storage pool (the extent=
 tree).
 - *One* set of metadata about checksums for each 4k chunk of data within a=
n extent (the checksum tree).
 - *One* set of metadata about where to find all the other metadata (the ro=
ot tree).

   Note that an extent is a sequence of blocks which is both
contiguous on disk, and contiguous within one *or more* files.

   In addition to the above globally-shared metadata, there are
multiple metadata sets, each representing a mountable namespace --
these are the subvolumes. Each of these subvolumes holds a directory
structure, and all of the POSIX information for each file name within
that structure. For each file within a subvolume, there's a sequence
of pointers to the shared extent pool, indicating what blocks on disk
are actually holding the data for that file.

   Note that the actual file data, and the management of its location
on the disk (and its replication), is completely shared across
subvolumes. The same extent may be used multiple times by different
files, and those files may be in any subvolumes on the filesystem. In
theory, the same extent could even appear several times in the same
file. This sharing is how snapshots and COW copies are implemented.
It's also the basis for Josef's dedup implementation.

   Each subvolume (barring the root subvolume) is rooted in some other
subvolume, and appears within the namespace of its parent.

> >> Perhaps it's time to start looking at separating the btrfs pool
> >> creation tools out of mkfs (or renaming mkfs.btrfs), since you're
> >> really building a a storage pool, and not a filesystem. =A0It would
> >> prevent a lot of confusion with new users. =A0It's great that there's a
> >> separate btrfs tool for manipulating btrfs setups, but "mkfs.btrfs" is
> >> just wrong for creating the btrfs setup.
> >
> > =A0 I think this is the wrong thing to do. I hope my explanation above
> > helps.
>=20
> As I understand it, the mkfs.btrfs is used to create the initial
> filesystem across X disks with Y redundancy.  For everthing else
> afterward, the btrfs tool is used to add disks, create snapshots,
> delete snapshots, change redundancy settings, create sub-volumes, etc.
>  Why not just add a "create" option to btrfs and retire mkfs.btrfs
> completely.  Or rework mkfs.btrfs to create sub-volumes of an existing
> btrfs setup?

   Because creating a subvolume isn't making a btrfs filesystem. It's
simply creating a new namespace tree.

> What would be great is if there was an image that showed the layers in
> Btrfs and how they interacted with the userspace tools.
>=20
> Having a set of graphics that compared the layers in Btrfs with the
> layers in the "normal" Linux disk/filesystem partitioning scheme, and
> the LVM layering, would be best.

   There's a diagram at [1], which shows all of the on-disk data
structures. It's somewhat too detailed for this discussion, but in
conjunction with the above explanation, it might make more sense to
you. If it does, I'll have a go at putting together a simpler version.

> There's lots of info in the wiki, but no images, ASCII-art, graphics,
> etc.  Trying to picture this mentally is not working.  :)

   Understood. :)

   Hugo.

[1] https://btrfs.wiki.kernel.org/index.php/Data_Structures

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
     --- If the first-ever performance is the premi=E8re,  is the ---    =
=20
                  last-ever performance the derri=E8re?                  =
=20

--Fba/0zbH8Xs+Fj9o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNOt+VIKyzvlFcI40RAriiAKCd94qzlHMS7zJU/ycvX7N89Sa36gCfbD+k
gf6ejkpWCE2ratqnIDcmq+o=
=FU+/
-----END PGP SIGNATURE-----

--Fba/0zbH8Xs+Fj9o--
