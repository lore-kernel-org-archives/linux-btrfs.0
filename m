From: Chris Mason <chris.mason@ORACLE.COM>
Subject: Re: error during umuont after set-default with 2.6.34-rc2
Date: Tue, 23 Mar 2010 11:10:56 -0400
Message-ID: <20100323151056.GB30249@think>
References: <201003212045.o2LKjBgg002162@indigo.cs.bgu.ac.il>
 <20100322133858.GB32521@think>
 <4BA7D24E.3040600@cs.bgu.ac.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Piavlo <piavka@cs.bgu.ac.il>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BA7D24E.3040600@cs.bgu.ac.il>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 22, 2010 at 10:25:50PM +0200, Piavlo wrote:
> On 03/22/2010 03:38 PM, Chris Mason wrote:
> > On Sun, Mar 21, 2010 at 10:45:11PM +0200, Alexander Piavlo wrote:
> >   
> >> Hi,
> >> trying the new btrfs tool and set-default with 2.6.34-rc2 i hit the the
> >> following problem:
> >>
> >> mkfs.btrfs -d single /dev/sys/btrfs
> >> mount -t btrfs /dev/sys/btrfs /btrfs
> >> btrfs subvolume create /btrfs/newroot
> >> mkdir /btrfs/newroot/.btrfs
> >> btrfs subvolume set-default 256 /btrfs
> >> umount /btrfs
> >> mount -t btrfs /dev/sys/btrfs /btrfs
> >>
> >> up till now everything works ok
> >>
> >> A question How do i access or mount the original root of btrfs? Which
> >> tree id does it have?
> >> It would be great if "btrfs subvolume list ..." would also list the
> >> original root.
> >>
> >> I guessed I need to use 0, so i tried:
> >>   mount -t btrfs -o subvol=0 /dev/sys/btrfs /btrfs/.btrfs
> >> and:
> >>   mount -t btrfs -o subvol=. /dev/sys/btrfs /btrfs/.btrfs
> >> but in both cases it mounted the newroot subvolume with id 256 under
> >> /btrfs/.btrfs
> >>
> >> So I tried setting the original root back with:
> >>   btrfs subvolume set-default 0 /btrfs
> >>     
> > Looks like set-default needs to understand 0 means use the old default,
> >   
> 
> old default = previous default
> 
> or
> 
> old default = top level subvolume

Sorry old default = top level subvolume.  It doesn't store the last
default when you run set-default.

> ?
> 
> > I'll add this in.
> >
> > btrfs subvolume set-default 5 /btrfs
> >
> >   
> Why 5? is this the tree id of the root subvolume = top level path?

Yes, its a magic number.

> > or mount -o subvolid=0 /dev/xxx /mnt
> > or mount -o subvolid=5 /dev/xxx /mnt
> >   
> Did not know about the subvolid option, I though one can pass treeid to
> subvol option.

We could change the mount -o subvol option to parse the parameter and do
different things if it finds a number, but I think less magic in the
code is better.  So I added a new mount -o subvolid option instead, and
mount -o subvol works inside the subvolid.

-chris

