From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [Btrfs-devel] cloning file data
Date: Fri, 25 Apr 2008 09:50:42 -0700
Message-ID: <48120BE2.2080207@oracle.com>
References: <Pine.LNX.4.64.0804241352130.23551@cobra.newdream.net> <200804250941.35343.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Chris Mason <chris.mason@oracle.com>, btrfs-devel@oss.oracle.com,
	linux-btrfs@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200804250941.35343.chris.mason@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>


> We've written into the middle of that 100MB extent, and we need to do COW.  
> One option is to read the whole thing, change 4k and write it all back.  
> Instead, btrfs does something like this (+/- off by need more coffee errors):
> 
> file pos = 0 -> [ old extent, offset = 0, num_bytes = 400k ]
> file pos = 409600 -> [ new 4k extent, offset = 0, num_bytes = 4k ]
> file pos = 413696 -> [ old extent, offset = 413696, num_bytes = 100MB - 404k]
> 
> An extra reference is taken on the old extent to reflect that we're pointing 
> to it twice.

If you learn how to parse the debug-tree output then this can be seen
pretty easily.  To do this we can watch the leaves of the fs tree for
the inode and extent items of the file we work with:

# dd if=/dev/zero bs=1M count=1k of=/tmp/image
# losetup /dev/loop0 /tmp/image
# ./mkfs.btrfs /dev/loop0
# mount -t btrfs /dev/loop0 /mnt/btrfs

# dd if=/dev/zero bs=64M count=1 of=/mnt/btrfs/test
# sync

# ./debug-tree /tmp/image

	item 5 key (256 11 258) itemoff 3779 itemsize 26
		dir index 258 type 1
		namelen 4 datalen 0 name: test
	[...]
	item 1 key (258 1 0) itemoff 2699 itemsize 108
		inode generation 0 size 67108864 [...]
	[...]
	item 3 key (258 12 0) itemoff 2652 itemsize 41
		extent data disk byte 190382080 nr 67108864
		extent data offset 0 nr 67108864

In the root directory we found a dirent for our test file which shows it
has objectid 258, then we found its inode with size=64m and the file
extent which references the 64m extent on disk which starts at byte
offset 190382080.

So now we over-write a 4k region in the file at offset 64k.

# dd if=/dev/zero bs=4k count=1 seek=16 of=/mnt/btrfs/test conv=notrunc
# sync

# ./debug-tree /tmp/image

	item 1 key (258 1 0) itemoff 2699 itemsize 108
		inode generation 0 size 67108864 [...]
	[...]
	item 3 key (258 12 0) itemoff 2652 itemsize 41
		extent data disk byte 190382080 nr 67108864
		extent data offset 0 nr 65536
	item 4 key (258 12 65536) itemoff 2611 itemsize 41
		extent data disk byte 257490944 nr 4096
		extent data offset 0 nr 4096
	item 5 key (258 12 69632) itemoff 2570 itemsize 41
		extent data disk byte 190382080 nr 67108864
		extent data offset 69632 nr 67039232

We still have the same inode, and it has the same size, but its extent
items look very different.  The extent for the first 64k looks much the
same.  It references the old 64m extent on disk.  But see the 'nr
65536', it only maps 64k of that 64m into the file.  Then we have the 4k
extent that we just wrote.  Then we have another reference to that 64m
extent but for the remaining data after the new 4k.

The extra credit assignment is to observe the effect of these extent
reference item changes on the reference count items which are stored
over in the leaves of the extent allocation tree.

debug-tree is fantastic, but it can be kind of intimidating if you don't
already know what all the numbers mean :).  Reducing the barrier to
understanding its output might be a great project for someone interested
in learning the disk format without having to learn how to work with the
kernel code.

- z
