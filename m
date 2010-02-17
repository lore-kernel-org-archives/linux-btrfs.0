From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: [PATCH 0/2 V2] btrfs: a new tool to manage a btrfs filesystem
Date: Wed, 17 Feb 2010 15:35:26 -0800
Message-ID: <93cdabd21002171535w55ad862fpd5ea845117cdcb85@mail.gmail.com>
References: <201002172102.17816.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	Thomas Kupper <thomas@kupper.org>,
	"Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>,
	rk <rkasl@computer.org>
To: Goffredo Baroncelli <kreijack@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201002172102.17816.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

I think he need some command hierarchy here.

On Wed, Feb 17, 2010 at 12:02 PM, Goffredo Baroncelli
<kreijack@gmail.com> wrote:
> OPTIONS
> =C2=A0 =C2=A0 =C2=A0 snapshot|-s <source> [<dest>/]<name>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Create a writeble sna=
pshot of the subvolume =C2=A0<source> =C2=A0with =C2=A0the
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0name =C2=A0<name> =C2=
=A0in the <dest> directory. If <source> is not a sub=E2=80=90
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0volume, btrfs returns=
 an error.

This should be "btrfs subvolume snapshot <source> [<dest>/]<name>".
It only works on subvolumes.

>
>
> =C2=A0 =C2=A0 =C2=A0 delete|-D <subvolume>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Delete the subvolume =
<subvolume>. If <subvolume> is not =C2=A0a =C2=A0sub=E2=80=90
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0volume, btrfs returns=
 an error.
>

This becomes:

btrfs subvolume delete <subvolume>

This works with snapshots as well.

>
> =C2=A0 =C2=A0 =C2=A0 subvolume|-c [<dest>/]<name>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Create =C2=A0a =C2=A0=
subvolume =C2=A0in =C2=A0<dest> (or in the current directory if
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0<dest> is not passed)=
=2E

btrfs subvolume create [<dest>/]<name>

>
>
> =C2=A0 =C2=A0 =C2=A0 defrag|-f <file>|<dir> [<file>|<dir>...]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Defragment files and/=
or directories.

This will defrag individual files?  Does it defrag a directory tree?
Does it defrag a subvolume?  Does it defrag a pool?

>
>
> =C2=A0 =C2=A0 =C2=A0 scan|-n [<device> [<device>..]]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Scan devices for a bt=
rfs filesystem. If no devices =C2=A0are =C2=A0passed,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0btrfs scans all the b=
lock devices.

btrfs pool scan [<device> [<device>..]]

>
>
> =C2=A0 =C2=A0 =C2=A0 fssync|-y <path>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Force a sync for the =
filesystem identified by <path>.
>

Does it sync a pool or subvolume?  Assuming it works against
subvolumes, it would be:

btrfs subvolume sync <path>

>
>
> =C2=A0 =C2=A0 =C2=A0 resize|-z [+/-]<size>[gkm]|max <filesystem>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Resize a file system =
identified by <path>. =C2=A0The <size> parameter
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0specifies the new siz=
e of the filesystem. =C2=A0If the prefix + or =C2=A0-
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0is =C2=A0present =C2=A0=
the =C2=A0size is increased or decreased by the quantity
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0<size>. =C2=A0If no u=
nits are =C2=A0specified, =C2=A0the =C2=A0unit =C2=A0of =C2=A0the =C2=A0=
<size>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0parameter =C2=A0is =C2=
=A0the =C2=A0byte. =C2=A0Optionally, the size parameter may be
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0suffixed by one of th=
e following =C2=A0the =C2=A0units =C2=A0designators: =C2=A0'K',
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0'M', or 'G', kilobyte=
s, megabytes, or gigabytes, respectively.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0If =C2=A0'max' =C2=A0=
is =C2=A0passed, =C2=A0the filesystem will occupy all available
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0space on the volume(s=
).
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0The resize command do=
es not manipulate the =C2=A0size =C2=A0of =C2=A0underlying
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0partitions. =C2=A0 If=
 =C2=A0you =C2=A0wish =C2=A0to enlarge/reduce a filesystem, you
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0must make sure you ca=
n expand/reduce the size of =C2=A0the =C2=A0partition
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0also.
>

This works with physical devices, not a pool or subvolume.  I get the
name "physical volume" from lvm.  Also I think it should resize to max
without arguments, in order to do that, the size argument would need
to be the last argument.

It becomes:

btrfs pvolume resize [+/-]<size>[gkm]|max <filesystem>

Or:

btrfs pvolume resize <filesystem> [[+/-]<size>[gkm]]

>
> =C2=A0 =C2=A0 =C2=A0 show|-l [<dev>|<label>...]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Show =C2=A0the btrfs =
devices with some additional info. If no devices
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0or labels are passed,=
 btrfs scans all the block devices.

This becomes:

btrfs pool show [<dev>|<label>...]

>
>
> =C2=A0 =C2=A0 =C2=A0 balance|-b <path>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Balance the chunk of =
the filesystem identified by <path> =C2=A0across
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0the devices.

Is path to one of the block devices in the pool?

This becomes:

btrfs pool balance <path>

>
>
> =C2=A0 =C2=A0 =C2=A0 add-dev|-A =C2=A0<dev> [<dev>..] <path>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Add device(s) to the =
filesystem identified by <path>.

What is path?  Somewhere the pool is mounted?  The root of where the
pool is mounted?

this becomes:

btrfs pvolume add <dev> [<dev>..] <path>

>
>
> =C2=A0 =C2=A0 =C2=A0 rm-dev|-R =C2=A0<dev> [<dev>..] <path>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Remove device(s) to t=
he filesystem identified by <path>.

(same questions as with add)

This becomes:

btrfs pvolume remove <dev> [<dev>..] <path>

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
