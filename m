From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [Btrfs-devel] cloning file data
Date: Fri, 25 Apr 2008 12:58:20 -0400
Message-ID: <200804251258.21129.chris.mason@oracle.com>
References: <Pine.LNX.4.64.0804241352130.23551@cobra.newdream.net> <200804250941.35343.chris.mason@oracle.com> <48120BDC.9000900@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: Sage Weil <sage@newdream.net>, btrfs-devel@oss.oracle.com,
	linux-btrfs@vger.kernel.org
To: Zach Brown <zach.brown@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48120BDC.9000900@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 25 April 2008, Zach Brown wrote:
> > We've written into the middle of that 100MB extent, and we need to do
> > COW. One option is to read the whole thing, change 4k and write it all
> > back. Instead, btrfs does something like this (+/- off by need more
> > coffee errors):
> >
> > file pos = 0 -> [ old extent, offset = 0, num_bytes = 400k ]
> > file pos = 409600 -> [ new 4k extent, offset = 0, num_bytes = 4k ]
> > file pos = 413696 -> [ old extent, offset = 413696, num_bytes = 100MB -
> > 404k]
> >
> > An extra reference is taken on the old extent to reflect that we're
> > pointing to it twice.
>
> If you learn how to parse the debug-tree output then this can be seen
> pretty easily.  To do this we can watch the leaves of the fs tree for
> the inode and extent items of the file we work with:

Thanks for this example Zach, it's great.  One small note:

>
> # dd if=/dev/zero bs=1M count=1k of=/tmp/image
> # losetup /dev/loop0 /tmp/image
> # ./mkfs.btrfs /dev/loop0
> # mount -t btrfs /dev/loop0 /mnt/btrfs
>
> # dd if=/dev/zero bs=64M count=1 of=/mnt/btrfs/test
> # sync
>
> # ./debug-tree /tmp/image

Running debug-tree on a live FS is a very good way to learn about trees that 
get left around while snapshot deletion is happening and cache aliasing 
caused by the way Btrfs puts metadata into its own address space.

But, if you're trying to learn the disk format, I'd stick an unmount between 
the dd and the debug-tree ;)

-chris
