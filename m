From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/2 V2] btrfs: a new tool to manage a btrfs filesystem
Date: Thu, 18 Feb 2010 15:58:09 -0500
Message-ID: <20100218205809.GX10559@think>
References: <201002172102.17816.kreijack@libero.it>
 <93cdabd21002171535w55ad862fpd5ea845117cdcb85@mail.gmail.com>
 <20100218165841.GO10559@think>
 <201002182100.00624.kreijack@libero.it>
 <93cdabd21002181246g7a46a767m8170859ce85eb0ab@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Goffredo Baroncelli <kreijack@gmail.com>,
	linux-btrfs@vger.kernel.org, Thomas Kupper <thomas@kupper.org>,
	"Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>,
	rk <rkasl@computer.org>
To: Mike Fedyk <mfedyk@mikefedyk.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <93cdabd21002181246g7a46a767m8170859ce85eb0ab@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 18, 2010 at 12:46:56PM -0800, Mike Fedyk wrote:
> On Thu, Feb 18, 2010 at 11:59 AM, Goffredo Baroncelli
> <kreijack@gmail.com> wrote:
> > On Thursday 18 February 2010, Chris Mason wrote:
> >> I do like the subcommand method, more details below.
> >>
> >
> > I try to summarise your suggestions. But there are some cases not t=
o clear for
> > me.
> > I grouped the commands in three categories: subvolume, devices, and
> > filesystem.
> >
> >
> > devices =A0 =A0 =A0 =A0 scan
> > devices =A0 =A0 =A0 =A0 show
> > devices =A0 =A0 =A0 =A0 balance
> > devices =A0 =A0 =A0 =A0 add
> > devices =A0 =A0 =A0 =A0 remove
> >
> > subvolume =A0 =A0 =A0 snapshot
> > subvolume =A0 =A0 =A0 delete
> > subvolume =A0 =A0 =A0 create
> > [subvolume =A0 =A0 =A0list]
> >
> > filesystem =A0 =A0 =A0resize
> > [filesystem =A0 =A0 label]
> >
> > ??? =A0 =A0 defrag
> > ??? =A0 =A0 sync
> >
> >
> >
> > For the first two categories both Chris and Mike agreed; but IMHO t=
here are
> > some commands that don't fit nor in devices, nor subvolume, like re=
size (we
> > resize a filesystem) and label (not available now).
> >
>=20
> A btrfs filesystem can span multiple devices.  Resize resizes how big
> of a chunk of one device btrfs uses.

Right, resize is actually always per device.  When there is one device
resizing the FS and the device are the same thing.

> This would be used by
> partitioning programs for instance.  zfs uses the term "pool" instead
> of filesystem to solve this ambiguous use of the term "filesystem"
> since btrfs and zfs break people's existing definition of the word
> "filesystem".
>=20
> > I don't know how classify defrag (per file / directory level ?) and=
 sync
> > (filesystem ?)
>=20
> It turns out that defrag is per file, which seems most cumbersome.
> Maybe since it will probably eventually work against several types of
> objects we could have:
>=20
> btrfs defrag file <file>
> btrfs defrag directory <directory>
> btrfs defrag subvol <subvol>

I like these, although we don't currently support the directory/subvol
side.  But we can leave the option open to add these later.

> btrfs defrag pool <pool>

I don't think we'll need defrag pool.

>=20
> >
> > An option is to consider commands without classification. For examp=
les:
> >
> > $ btrfs subvolume create [path/]<subvolname>
> > $ btrfs sync <path>
> > $ btrfs defrag <file>
>=20
> Maybe if the btrfs developers are agreeable, we could do this as well=
:
>=20
> btrfs sync file <file>
> btrfs sync directory <directory>

fsync on files and dirs already does this, we don't need a btrfsctl for
it.

> btrfs sync subvol <subvol>

btrfs sync subvol is nice.

> btrfs sync pool <pool>
>=20

I don't think we need sync pool.

-chris

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
