From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Atomicity or the ext4 open-write-close-rename debacle
Date: Wed, 08 Apr 2009 12:28:15 -0400
Message-ID: <1239208095.22111.4.camel@think.oraclecorp.com>
References: <49DCC0FD.3010200@math.utexas.edu>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Patrick Goetz <pgoetz@math.utexas.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49DCC0FD.3010200@math.utexas.edu>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2009-04-08 at 10:21 -0500, Patrick Goetz wrote:
> Hi -
> 
> I've been trying to get up to speed on new linux filesystem efforts and 
> stumbled upon the following post from a btrfs developer to lwn.net:
> 
> -----------------------------------------------------------
> Posted Mar 16, 2009 16:50 UTC (Mon) by masoncl (subscriber, #47138)
> The btrfs data=ordered implementation is different from ext34 and 
> reiserfs. It decouples data writes from the metadata transaction, and 
> simply updates the metadata for file extents after the data blocks are 
> on disk.
> 
> This means the transaction commit doesn't have to wait for the data 
> blocks because the metadata for the file extents always reflects extents 
> that are actually on disk.
> 
> When you rename one file over another, the destination file is 
> atomically replaced with the new file. The new file is fully consistent 
> with the data that has already been written, which in the worst case 
> means it has a size of zero after a crash.
> ...
> -----------------------------------------------------------
> 
> Frankly this comment doesn't make any sense to me at all.  First of all, 
> "this means the transaction commit doesn't have to wait for the data 
> blocks...".  Is the data ordered or not? If you commit the transaction 
> -- i.e. update the metadata before the data blocks are committed -- then 
> the operations are occurring out of order and ext4 
> open-write-close-rename mayhem ensues.
> 
> Second, atomicity in this context means that when executing a rename, 
> you always get either the old data (exactly) or the new data (exactly) 
> even after a crash. The "worst case scenario" described above -- a size 
> of zero after crash -- precisely violates atomicity.
> 
> Any comments on this?

There isn't a quick and short description for this.  Before 2.6.30,
btrfs would allow renames to result in zero length files after a crash.
Filesystem developers have always considered the rename-is-atomic
requirement to refer only to the directory entries themselves.

With 2.6.30, extra ordering is added to btrfs, making sure that metadata
and data are both atomically replaced during a rename.  In other words,
for renames it will work like ext3 data=ordered mode.

-chris


