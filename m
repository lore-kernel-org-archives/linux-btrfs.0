From: Greg Kochanski <gpk@kochanski.org>
Subject: Are enormous extents harmful?
Date: Sun, 01 Aug 2010 14:28:33 +0100
Message-ID: <4C557681.90905@kochanski.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I created a btrfs file system with a single 420 megabyte file
in it.     And, when I look at the file system with btrfs-debug,
I see gigantic extents, as large as 99 megabytes:

 > $ sudo btrfs-debug-tree /dev/sdb | grep extent
 > ...
 >         dev extent chunk_tree 3
 >         dev extent chunk_tree 3
 >         extent data disk byte 80084992 nr 99958784
 >         extent data offset 0 nr 99958784 ram 99958784
 >         extent compression 0
 >         extent data disk byte 181534720 nr 74969088
 >         extent data offset 0 nr 74969088 ram 74969088
 > ...


This may be too much of a good thing.   From the point
of view of efficient reading, large extents are good, because
they minimize seeks in sequential reads.
But there will be diminishing returns when
the extent gets bigger than the size of a physical disk cylinder.

For instance, modern disks have a data transfer rate of (about) 200MB/s,
so adding one extra seek (about 8ms) in the middle of a
200MB extent can't possibly slow things down by more than 1%.
(And, that's the worst-possible case.)

But, large extents (I think) also have costs.   For instance, if you are
writing a byte into the middle of an extent, doesn't Btrfs have to copy
the entire extent?    If so, and if you have a 99MB extent, the cost
of that write operation will be *huge*.

Likewise, if you have compressed extents, and you want to read one
byte near the end of the extent, Btrfs needs to uncompress the
entire extent.    Under some circumstances, you might have to
decompress 99MB to read one short block of data.   (Admittedly,
cacheing will make this worst-case scenario less common, but
it will still be there sometimes.)

So, it seems that if we are doing random reads or writes of small
blocks, there is a large cost to having a large extent.    The cost
will be proportional to the extent size.

To get the best performance, one wants to balance these costs
against the efficiency gains of large extents in the sequential-read
case.   There will be some optimum size for extents.

I don't want to pretend to know exactly what that size is,
and it's going to depend on the usage patterns, but
I'd guess it would be just a few megabytes.

So, I'd propose that Btrfs should place a maximum limit on the
size of extents.   This should probably be a tuneable parameter.


