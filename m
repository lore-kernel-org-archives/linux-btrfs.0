From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Data De-duplication
Date: Thu, 11 Dec 2008 10:12:55 -0500
Message-ID: <1229008375.22236.63.camel@think.oraclecorp.com>
References: <1228862899.8130.1.camel@mattos-laptop>
	 <1228915802.11900.8.camel@think.oraclecorp.com>
	 <1228931592.6076.12.camel@mattos-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Oliver Mattos <oliver.mattos08@imperial.ac.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1228931592.6076.12.camel@mattos-laptop>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-12-10 at 17:53 +0000, Oliver Mattos wrote:
> > > 2)  Keep a tree of checksums for data blocks, so that a bit of data can
> > > be located by it's checksum.  Whenever a data block is about to be
> > > written check if the block matches any known block, and if it does then
> > > don't bother duplicating the data on disk.  I suspect this option may
> > > not be realistic for performance reasons.
> > > 
> > 
> > When compression was added, the writeback path was changed to make
> > option #2 viable, at least in the case where the admin is willing to
> > risk hash collisions on strong hashes.  When the a direct read
> > comparison is required before sharing blocks, it is probably best done
> > by a stand alone utility, since we don't want wait for a read of a full
> > extent every time we want to write on.
> > 
> 
> Can we assume hash collisions won't occur?  I mean if it's a 256 bit
> hash then even with 256TB of data, and one hash per block, the chances
> of collision are still too small to calculate on gnome calculator.

It depends on the use case.  We can assume that if someone really wants
collisions to occur they will eventually be able to trigger them.  So,
the code should have the option to verify the bytes are identical via  a
read.

For a backup farm or virtualization dataset, I personally wouldn't use
the read-verify stage.  But others will.

-chris


