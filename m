From: Patrick Goetz <pgoetz@math.utexas.edu>
Subject: Atomicity or the ext4 open-write-close-rename debacle
Date: Wed, 08 Apr 2009 10:21:33 -0500
Message-ID: <49DCC0FD.3010200@math.utexas.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi -

I've been trying to get up to speed on new linux filesystem efforts and 
stumbled upon the following post from a btrfs developer to lwn.net:

-----------------------------------------------------------
Posted Mar 16, 2009 16:50 UTC (Mon) by masoncl (subscriber, #47138)
The btrfs data=ordered implementation is different from ext34 and 
reiserfs. It decouples data writes from the metadata transaction, and 
simply updates the metadata for file extents after the data blocks are 
on disk.

This means the transaction commit doesn't have to wait for the data 
blocks because the metadata for the file extents always reflects extents 
that are actually on disk.

When you rename one file over another, the destination file is 
atomically replaced with the new file. The new file is fully consistent 
with the data that has already been written, which in the worst case 
means it has a size of zero after a crash.
...
-----------------------------------------------------------

Frankly this comment doesn't make any sense to me at all.  First of all, 
"this means the transaction commit doesn't have to wait for the data 
blocks...".  Is the data ordered or not? If you commit the transaction 
-- i.e. update the metadata before the data blocks are committed -- then 
the operations are occurring out of order and ext4 
open-write-close-rename mayhem ensues.

Second, atomicity in this context means that when executing a rename, 
you always get either the old data (exactly) or the new data (exactly) 
even after a crash. The "worst case scenario" described above -- a size 
of zero after crash -- precisely violates atomicity.

Any comments on this?

