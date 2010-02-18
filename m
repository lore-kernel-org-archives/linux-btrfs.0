From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: [PATCH 0/2 V2] btrfs: a new tool to manage a btrfs filesystem
Date: Thu, 18 Feb 2010 20:59:59 +0100
Message-ID: <201002182100.00624.kreijack@libero.it>
References: <201002172102.17816.kreijack@libero.it> <93cdabd21002171535w55ad862fpd5ea845117cdcb85@mail.gmail.com> <20100218165841.GO10559@think>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: Thomas Kupper <thomas@kupper.org>,
	"Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>,
	rk <rkasl@computer.org>
To: Chris Mason <chris.mason@oracle.com>,
	Mike Fedyk <mfedyk@mikefedyk.com>,
	Goffredo Baroncelli <kreijack@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100218165841.GO10559@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 18 February 2010, Chris Mason wrote:
> I do like the subcommand method, more details below.
>=20

I try to summarise your suggestions. But there are some cases not to cl=
ear for=20
me.=20
I grouped the commands in three categories: subvolume, devices, and=20
filesystem.


devices 	scan
devices		show
devices		balance
devices		add
devices		remove

subvolume	snapshot
subvolume	delete
subvolume	create
[subvolume	list]

filesystem	resize
[filesystem	label]

??? 	defrag
???	sync



=46or the first two categories both Chris and Mike agreed; but IMHO the=
re are=20
some commands that don't fit nor in devices, nor subvolume, like resize=
 (we=20
resize a filesystem) and label (not available now).

I don't know how classify defrag (per file / directory level ?) and syn=
c=20
(filesystem ?)

An option is to consider commands without classification. For examples:

$ btrfs subvolume create [path/]<subvolname>
$ btrfs sync <path>
$ btrfs defrag <file>

Any comments and/or suggestions ?

> On Wed, Feb 17, 2010 at 03:35:26PM -0800, Mike Fedyk wrote:
> > I think he need some command hierarchy here.
> >=20
> > On Wed, Feb 17, 2010 at 12:02 PM, Goffredo Baroncelli
> > <kreijack@gmail.com> wrote:
> > > OPTIONS
> > >       snapshot|-s <source> [<dest>/]<name>
> > >              Create a writeble snapshot of the subvolume  <source=
>  with=20
 the
> > >              name  <name>  in the <dest> directory. If <source> i=
s not a=20
sub=E2=80=90
> > >              volume, btrfs returns an error.
> >=20
> > This should be "btrfs subvolume snapshot <source> [<dest>/]<name>".
> > It only works on subvolumes.
>=20
> If we can type subvol instead of subvolume I like it.  Basically the
> perl/python arg parsing system where any short form of the command th=
at
> uniquely matches it is allowed.
>=20
> We keep the long forms but allow the user to pick a shorter form if i=
t
> isn't ambiguous.
>=20
> >=20
> > >
> > >
> > >       delete|-D <subvolume>
> > >              Delete the subvolume <subvolume>. If <subvolume> is =
not  a=20
 sub=E2=80=90
> > >              volume, btrfs returns an error.
> > >
> >=20
> > This becomes:
> >=20
> > btrfs subvolume delete <subvolume>
>=20
> subvol del (same as above).
>=20
> >=20
> > This works with snapshots as well.
> >=20
> > >
> > >       subvolume|-c [<dest>/]<name>
> > >              Create  a  subvolume  in  <dest> (or in the current=20
directory if
> > >              <dest> is not passed).
> >=20
> > btrfs subvolume create [<dest>/]<name>
> >=20
> > >
> > >
> > >       defrag|-f <file>|<dir> [<file>|<dir>...]
> > >              Defragment files and/or directories.
> >=20
> > This will defrag individual files?  Does it defrag a directory tree=
?
> > Does it defrag a subvolume?  Does it defrag a pool?
>=20
> For now lets change this to only do files.  That's the only thing the
> tool supports today.
>=20
> >=20
> > >
> > >
> > >       scan|-n [<device> [<device>..]]
> > >              Scan devices for a btrfs filesystem. If no devices  =
are=20
 passed,
> > >              btrfs scans all the block devices.
> >=20
> > btrfs pool scan [<device> [<device>..]]
>=20
> Instead of btrfs pool, please use btrfs dev
>=20
> >=20
> > >
> > >
> > >       fssync|-y <path>
> > >              Force a sync for the filesystem identified by <path>=
=2E
> > >
> >=20
> > Does it sync a pool or subvolume?  Assuming it works against
> > subvolumes, it would be:
> >=20
> > btrfs subvolume sync <path>
> >=20
> > >
> > >
> > >       resize|-z [+/-]<size>[gkm]|max <filesystem>
> > >              Resize a file system identified by <path>.  The <siz=
e>=20
parameter
> > >              specifies the new size of the filesystem.  If the pr=
efix +=20
or  -
> > >              is  present  the  size is increased or decreased by =
the=20
quantity
> > >              <size>.  If no units are  specified,  the  unit  of =
 the=20
 <size>
> > >              parameter  is  the  byte.  Optionally, the size para=
meter=20
may be
> > >              suffixed by one of the following  the  units  design=
ators:=20
 'K',
> > >              'M', or 'G', kilobytes, megabytes, or gigabytes,=20
respectively.
> > >
> > >              If  'max'  is  passed,  the filesystem will occupy a=
ll=20
available
> > >              space on the volume(s).
> > >
> > >              The resize command does not manipulate the  size  of=
=20
 underlying
> > >              partitions.   If  you  wish  to enlarge/reduce a=20
filesystem, you
> > >              must make sure you can expand/reduce the size of  th=
e=20
 partition
> > >              also.
> > >
> >=20
> > This works with physical devices, not a pool or subvolume.  I get t=
he
> > name "physical volume" from lvm.  Also I think it should resize to =
max
> > without arguments, in order to do that, the size argument would nee=
d
> > to be the last argument.
>=20
> We don't have physical volumes and logical volumes the way lvm does, =
so
> I'd like to avoid the pvolume theme.
>=20
> >=20
> > It becomes:
> >=20
> > btrfs pvolume resize [+/-]<size>[gkm]|max <filesystem>
> >=20
> > Or:
> >=20
> > btrfs pvolume resize <filesystem> [[+/-]<size>[gkm]]
>=20
> btrfs dev resize
>=20
> >=20
> > >
> > >       show|-l [<dev>|<label>...]
> > >              Show  the btrfs devices with some additional info. I=
f no=20
devices
> > >              or labels are passed, btrfs scans all the block devi=
ces.
> >=20
> > This becomes:
> >=20
> > btrfs pool show [<dev>|<label>...]
>=20
> btrfs dev show
>=20
> >=20
> > >
> > >
> > >       balance|-b <path>
> > >              Balance the chunk of the filesystem identified by <p=
ath>=20
 across
> > >              the devices.
> >=20
> > Is path to one of the block devices in the pool?
> >=20
> > This becomes:
> >=20
> > btrfs pool balance <path>
>=20
> btrfs dev balance
>=20
> >=20
> > >
> > >
> > >       add-dev|-A  <dev> [<dev>..] <path>
> > >              Add device(s) to the filesystem identified by <path>=
=2E
> >=20
> > What is path?  Somewhere the pool is mounted?  The root of where th=
e
> > pool is mounted?
>=20
> The path just tells us which filesystem to work against.  It can real=
ly
> be any path inside the mount point.
>=20
> >=20
> > this becomes:
> >=20
> > btrfs pvolume add <dev> [<dev>..] <path>
>=20
> btrfs dev add=20
> >=20
> > >
> > >
> > >       rm-dev|-R  <dev> [<dev>..] <path>
> > >              Remove device(s) to the filesystem identified by <pa=
th>.
> >=20
> > (same questions as with add)
> >=20
> > This becomes:
> >=20
> > btrfs pvolume remove <dev> [<dev>..] <path>
>=20
> btrfs dev remove
>=20
> -chris
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinw=
ind.it>
Key fingerprint =3D 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
