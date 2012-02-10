From: Sage Weil <sage@newdream.net>
Subject: [LSF/MM TOPIC] COWing writeback pages
Date: Fri, 10 Feb 2012 11:25:27 -0800 (PST)
Message-ID: <Pine.LNX.4.64.1202081055170.24717@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: dan.mick@dreamhost.com, jecluis@gmail.com
To: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

The takeaway from the 'stable pages' discussions in the last few workshops 
was that pages under writeback should remain locked so that subsequent 
writers don't touch them while they are en route to the disk.  This 
prevents bad checksums and DIF/DIX type failures (whereas previously we 
didn't really care whether old or new data reached the disk).

The fear is/was that anyone subsequently modifying the page will have to 
wait for writeback io to complete before continuing.  I seem to remember 
somebody (Martin?) saying that in practice, under "real" workloads, that 
doesn't actually happen, so don't worry about it.  (Does anyone remember 
the details of what testing led to that conclusion?)

Anyway, we are seeing what looks like an analogous problem with btrfs, 
where operations sometimes block waiting for writeback of the btree pages.  
Although the 'keep rewriting the same page' pattern may not be prevalent 
in normal file workloads, it does seem to happen with the btrfs btree.

The obvious solution seems to be to COW the page if it is under writeback 
and we want to remodify it.  Presumably that can be done just in btrfs, to 
address the btrfs-specific symptoms we're hitting, but I'm interested in 
hearing from other folks about whether it's more generally useful VM 
functionality for other filesystems and other workloads.

Unfortunately, we haven't been able to pinpoint the exact scenarios under 
which this triggers under btrfs.  We regularly see long stalls for 
metadata operations (create() and similar metadata-only operations) that 
block after btrfs_commit_transaction has "finished" the previous 
transaction and is doing

		return filemap_write_and_wait(btree_inode->i_mapping);

What we're less clear about is when btrfs will modify the in-memory page 
in place (and thus wait) versus COWing the page... still digging into this 
now.

It's seems like there is a btrfs-specific question about exactly what is 
going on and why, which isn't super-relevant for LSF/MM (except that we'll 
all be there).  However, my suspicion is that the solution will be 
generally applicable to other filesystems, and that the tests that led us 
to believe that "normal" workloads aren't affected by locked writeback 
pages would inform which path to take in solving our specific btrfs 
problem.

sage

