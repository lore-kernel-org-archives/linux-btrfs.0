From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/2 V2] btrfs: a new tool to manage a btrfs filesystem
Date: Thu, 18 Feb 2010 11:58:41 -0500
Message-ID: <20100218165841.GO10559@think>
References: <201002172102.17816.kreijack@libero.it>
 <93cdabd21002171535w55ad862fpd5ea845117cdcb85@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Goffredo Baroncelli <kreijack@gmail.com>,
	linux-btrfs@vger.kernel.org, Thomas Kupper <thomas@kupper.org>,
	"Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>,
	rk <rkasl@computer.org>
To: Mike Fedyk <mfedyk@mikefedyk.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <93cdabd21002171535w55ad862fpd5ea845117cdcb85@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

I do like the subcommand method, more details below.

On Wed, Feb 17, 2010 at 03:35:26PM -0800, Mike Fedyk wrote:
> I think he need some command hierarchy here.
>=20
> On Wed, Feb 17, 2010 at 12:02 PM, Goffredo Baroncelli
> <kreijack@gmail.com> wrote:
> > OPTIONS
> > =C2=A0 =C2=A0 =C2=A0 snapshot|-s <source> [<dest>/]<name>
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Create a writeble s=
napshot of the subvolume =C2=A0<source> =C2=A0with =C2=A0the
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0name =C2=A0<name> =C2=
=A0in the <dest> directory. If <source> is not a sub=E2=80=90
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0volume, btrfs retur=
ns an error.
>=20
> This should be "btrfs subvolume snapshot <source> [<dest>/]<name>".
> It only works on subvolumes.

If we can type subvol instead of subvolume I like it.  Basically the
perl/python arg parsing system where any short form of the command that
uniquely matches it is allowed.

We keep the long forms but allow the user to pick a shorter form if it
isn't ambiguous.

>=20
> >
> >
> > =C2=A0 =C2=A0 =C2=A0 delete|-D <subvolume>
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Delete the subvolum=
e <subvolume>. If <subvolume> is not =C2=A0a =C2=A0sub=E2=80=90
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0volume, btrfs retur=
ns an error.
> >
>=20
> This becomes:
>=20
> btrfs subvolume delete <subvolume>

subvol del (same as above).

>=20
> This works with snapshots as well.
>=20
> >
> > =C2=A0 =C2=A0 =C2=A0 subvolume|-c [<dest>/]<name>
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Create =C2=A0a =C2=A0=
subvolume =C2=A0in =C2=A0<dest> (or in the current directory if
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0<dest> is not passe=
d).
>=20
> btrfs subvolume create [<dest>/]<name>
>=20
> >
> >
> > =C2=A0 =C2=A0 =C2=A0 defrag|-f <file>|<dir> [<file>|<dir>...]
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Defragment files an=
d/or directories.
>=20
> This will defrag individual files?  Does it defrag a directory tree?
> Does it defrag a subvolume?  Does it defrag a pool?

=46or now lets change this to only do files.  That's the only thing the
tool supports today.

>=20
> >
> >
> > =C2=A0 =C2=A0 =C2=A0 scan|-n [<device> [<device>..]]
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Scan devices for a =
btrfs filesystem. If no devices =C2=A0are =C2=A0passed,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0btrfs scans all the=
 block devices.
>=20
> btrfs pool scan [<device> [<device>..]]

Instead of btrfs pool, please use btrfs dev

>=20
> >
> >
> > =C2=A0 =C2=A0 =C2=A0 fssync|-y <path>
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Force a sync for th=
e filesystem identified by <path>.
> >
>=20
> Does it sync a pool or subvolume?  Assuming it works against
> subvolumes, it would be:
>=20
> btrfs subvolume sync <path>
>=20
> >
> >
> > =C2=A0 =C2=A0 =C2=A0 resize|-z [+/-]<size>[gkm]|max <filesystem>
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Resize a file syste=
m identified by <path>. =C2=A0The <size> parameter
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0specifies the new s=
ize of the filesystem. =C2=A0If the prefix + or =C2=A0-
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0is =C2=A0present =C2=
=A0the =C2=A0size is increased or decreased by the quantity
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0<size>. =C2=A0If no=
 units are =C2=A0specified, =C2=A0the =C2=A0unit =C2=A0of =C2=A0the =C2=
=A0<size>
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0parameter =C2=A0is =
=C2=A0the =C2=A0byte. =C2=A0Optionally, the size parameter may be
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0suffixed by one of =
the following =C2=A0the =C2=A0units =C2=A0designators: =C2=A0'K',
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0'M', or 'G', kiloby=
tes, megabytes, or gigabytes, respectively.
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0If =C2=A0'max' =C2=A0=
is =C2=A0passed, =C2=A0the filesystem will occupy all available
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0space on the volume=
(s).
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0The resize command =
does not manipulate the =C2=A0size =C2=A0of =C2=A0underlying
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0partitions. =C2=A0 =
If =C2=A0you =C2=A0wish =C2=A0to enlarge/reduce a filesystem, you
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0must make sure you =
can expand/reduce the size of =C2=A0the =C2=A0partition
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0also.
> >
>=20
> This works with physical devices, not a pool or subvolume.  I get the
> name "physical volume" from lvm.  Also I think it should resize to ma=
x
> without arguments, in order to do that, the size argument would need
> to be the last argument.

We don't have physical volumes and logical volumes the way lvm does, so
I'd like to avoid the pvolume theme.

>=20
> It becomes:
>=20
> btrfs pvolume resize [+/-]<size>[gkm]|max <filesystem>
>=20
> Or:
>=20
> btrfs pvolume resize <filesystem> [[+/-]<size>[gkm]]

btrfs dev resize

>=20
> >
> > =C2=A0 =C2=A0 =C2=A0 show|-l [<dev>|<label>...]
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Show =C2=A0the btrf=
s devices with some additional info. If no devices
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0or labels are passe=
d, btrfs scans all the block devices.
>=20
> This becomes:
>=20
> btrfs pool show [<dev>|<label>...]

btrfs dev show

>=20
> >
> >
> > =C2=A0 =C2=A0 =C2=A0 balance|-b <path>
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Balance the chunk o=
f the filesystem identified by <path> =C2=A0across
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0the devices.
>=20
> Is path to one of the block devices in the pool?
>=20
> This becomes:
>=20
> btrfs pool balance <path>

btrfs dev balance

>=20
> >
> >
> > =C2=A0 =C2=A0 =C2=A0 add-dev|-A =C2=A0<dev> [<dev>..] <path>
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Add device(s) to th=
e filesystem identified by <path>.
>=20
> What is path?  Somewhere the pool is mounted?  The root of where the
> pool is mounted?

The path just tells us which filesystem to work against.  It can really
be any path inside the mount point.

>=20
> this becomes:
>=20
> btrfs pvolume add <dev> [<dev>..] <path>

btrfs dev add=20
>=20
> >
> >
> > =C2=A0 =C2=A0 =C2=A0 rm-dev|-R =C2=A0<dev> [<dev>..] <path>
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Remove device(s) to=
 the filesystem identified by <path>.
>=20
> (same questions as with add)
>=20
> This becomes:
>=20
> btrfs pvolume remove <dev> [<dev>..] <path>

btrfs dev remove

-chris

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
