From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: [PATCH 0/2 V2] btrfs: a new tool to manage a btrfs filesystem
Date: Thu, 18 Feb 2010 22:04:12 +0100
Message-ID: <201002182204.12890.kreijack@libero.it>
References: <201002172102.17816.kreijack@libero.it> <93cdabd21002181246g7a46a767m8170859ce85eb0ab@mail.gmail.com> <20100218205809.GX10559@think>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: Chris Mason <chris.mason@oracle.com>,
	Mike Fedyk <mfedyk@mikefedyk.com>, linux-btrfs@vger.kernel.org,
	Thomas Kupper <thomas@kupper.org>,
	"Dipl.-Ing. Michael Niederle" <mniederle@gmx.a
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100218205809.GX10559@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 18 February 2010, Chris Mason wrote:
> On Thu, Feb 18, 2010 at 12:46:56PM -0800, Mike Fedyk wrote:
> > On Thu, Feb 18, 2010 at 11:59 AM, Goffredo Baroncelli
> > <kreijack@gmail.com> wrote:
> > > On Thursday 18 February 2010, Chris Mason wrote:
> > >> I do like the subcommand method, more details below.
> > >>
> > >
> > > I try to summarise your suggestions. But there are some cases not to 
clear for
> > > me.
> > > I grouped the commands in three categories: subvolume, devices, and
> > > filesystem.
> > >
> > >
> > > devices         scan
> > > devices         show
> > > devices         balance
> > > devices         add
> > > devices         remove
> > >
> > > subvolume       snapshot
> > > subvolume       delete
> > > subvolume       create
> > > [subvolume      list]
> > >
> > > filesystem      resize
> > > [filesystem     label]
> > >
> > > ???     defrag
> > > ???     sync
> > >
> > >
> > >
> > > For the first two categories both Chris and Mike agreed; but IMHO there 
are
> > > some commands that don't fit nor in devices, nor subvolume, like resize 
(we
> > > resize a filesystem) and label (not available now).
> > >
> > 
> > A btrfs filesystem can span multiple devices.  Resize resizes how big
> > of a chunk of one device btrfs uses.
> 
> Right, resize is actually always per device.  When there is one device
> resizing the FS and the device are the same thing.
> 
> > This would be used by
> > partitioning programs for instance.  zfs uses the term "pool" instead
> > of filesystem to solve this ambiguous use of the term "filesystem"
> > since btrfs and zfs break people's existing definition of the word
> > "filesystem".
> > 
> > > I don't know how classify defrag (per file / directory level ?) and sync
> > > (filesystem ?)
> > 
> > It turns out that defrag is per file, which seems most cumbersome.
> > Maybe since it will probably eventually work against several types of
> > objects we could have:
> > 
> > btrfs defrag file <file>
> > btrfs defrag directory <directory>
> > btrfs defrag subvol <subvol>
> 
> I like these, although we don't currently support the directory/subvol
> side.  But we can leave the option open to add these later.

Sorry, but why:

	$ btrfs defrag subvol

and not 

	$ btrfs  subvol defrag

What do you want:

	$ btrfs <object> <action>

or

	$ btrfs <action> <object>


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
