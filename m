From: "Goffredo Baroncelli" <kreijack@libero.it>
Subject: Re: [RFC] proposal for a btrfs filesystem layout
Date: Tue, 24 Nov 2009 19:27:44 +0100
Message-ID: <KTMLY8$0856FD6739603291C7EB756874D48C83@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: "kreijack" <kreijack@gmail.com>,
	"linux-btrfs" <linux-btrfs@vger.kernel.org>
To: "chris\.mason" <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Sat, Nov 21, 2009 at 12:31:06AM +0100, Goffredo Baroncelli wrote:
[...]
> > My concern is about the btrfs user interface.
> > The biggest difficult that I had to learn the btrfs capabilities is its "user-
> > interface". I have to admit to be not the smartest person, but I spent a lot 
> > of time in order to understand which was the difference between a btrfs 
> > subvolume creation and a "mkfs + mount".
> > Finally I concluded that there no is difference (except the COW behaviour and 
> > other implementation detail). My impression was that in some area too often 
> > the VFS and btrfs do the same things. [*]
> > The point is that if btrfs do the same things of VFS, this may be called as 
> > "flexibility". 
> > But the history has highlight that from a long term point of view is the 
> > orthogonality of the subsystems that leads to the flexibility of the system..
> 
> Well, btrfs is using the VFS to expose the subvolumes.  Basically a
> subvolume is a special directory.

Let me explain better: what I would say was to expose the sub-volume content *only* with a command like "mount -o subvol=<name>".
To day when I create a snapshot, automatically it is placed in the btrfs filesystem with the snapshot name. IIRC when I move (rename) the directory I change the subvolume/snapshot name also.
Yes, I can remount the sub-volume with the mount command anywhere and with an arbitrary name. In fact the thing that seems strange to me is that when I create a snapshot, immediately it is mounted: it is not a real problem, it is only a strange behaviour. The "standard" behaviour is to create the file-system and then mount it: two separate actions.

> -chris
Goffredo


