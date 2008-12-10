From: Oliver Mattos <oliver.mattos08@imperial.ac.uk>
Subject: Re: Data De-duplication
Date: Wed, 10 Dec 2008 17:53:12 +0000
Message-ID: <1228931592.6076.12.camel@mattos-laptop>
References: <1228862899.8130.1.camel@mattos-laptop>
	 <1228915802.11900.8.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1228915802.11900.8.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

> > 2)  Keep a tree of checksums for data blocks, so that a bit of data can
> > be located by it's checksum.  Whenever a data block is about to be
> > written check if the block matches any known block, and if it does then
> > don't bother duplicating the data on disk.  I suspect this option may
> > not be realistic for performance reasons.
> > 
> 
> When compression was added, the writeback path was changed to make
> option #2 viable, at least in the case where the admin is willing to
> risk hash collisions on strong hashes.  When the a direct read
> comparison is required before sharing blocks, it is probably best done
> by a stand alone utility, since we don't want wait for a read of a full
> extent every time we want to write on.
> 

Can we assume hash collisions won't occur?  I mean if it's a 256 bit
hash then even with 256TB of data, and one hash per block, the chances
of collision are still too small to calculate on gnome calculator.

The only issue is if the hash algorithm is later found to be flawed, a
malicious bit of data could be stored on the disk who's hash would
collide with some more important data, potentially allowing the contents
of one file to be replaced with another.

Even if we don't assume hash collisions won't occur (eg. for crc's), the
write performance when writing duplicate files is equal to the read
performance of the disk, since for every block written by a program, one
block will need to be read, and no blocks written.  This is still better
than the write case (as most devices read faster than write), and has
the added advantage of saving lots of space.

