From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Atomicity or the ext4 open-write-close-rename debacle
Date: Wed, 08 Apr 2009 19:12:52 -0400
Message-ID: <1239232372.31826.4.camel@think.oraclecorp.com>
References: <49DCC0FD.3010200@math.utexas.edu>
	 <1239208095.22111.4.camel@think.oraclecorp.com>
	 <49DCECD5.3030801@math.utexas.edu>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Patrick Goetz <pgoetz@math.utexas.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49DCECD5.3030801@math.utexas.edu>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2009-04-08 at 13:28 -0500, Patrick Goetz wrote:
> Chris Mason wrote:
> > 
> > With 2.6.30, extra ordering is added to btrfs, making sure that metadata
> > and data are both atomically replaced during a rename.  In other words,
> > for renames it will work like ext3 data=ordered mode.
> > 
> 
> Thanks for the speedy response.
> 
> After spending several hours slogging through the discussion on Ted 
> Tso's blog and spending much more time than anticipated learning about 
> FUA, write barriers, fsync vs. fdatasync, how fsync is implemented in 
> linux, etc., I'm curious about the technical details of how this is 
> accomplished.  Any place where I can find this short of reading through 
> the source code?

The rename flushing is pretty simple.  When one file replaces another
during rename, btrfs puts the new file into a list of things that must
be flushed before the transaction commits.

This way, we know the data is on disk before the rename metadata changes
are on disk.

-chris


