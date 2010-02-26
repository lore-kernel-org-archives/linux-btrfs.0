From: Chris Mason <chris.mason@oracle.com>
Subject: Re: assertion failures
Date: Fri, 26 Feb 2010 12:59:27 -0500
Message-ID: <20100226175927.GG12841@think>
References: <20100226161730.GC12841@think>
 <20100226164151.9830F414B9@viridian.itc.virginia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Bill Pemberton <wfp5p@viridian.itc.virginia.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100226164151.9830F414B9@viridian.itc.virginia.edu>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 26, 2010 at 11:41:51AM -0500, Bill Pemberton wrote:
> > > 
> > > No dmesg.  This has happened on two different machines that both have
> > > other active btrfs filesystems, so I suspect it's not a memory issue.
> > > In both cases it was the same data that was being copied when the
> > > crash occurred.
> > 
> > Ok, is there anything special about this data?
> > 
> 
> There shouldn't be, it's the various backup files from a few
> machines.  The only thing odd that I've seen in the data is there is
> at least 1 file with some less-than-normally-used characters in the
> name.
> 
> Rsyncing it from an ext4 fs to a btrfs fileystem on the same array
> didn't cause the problem.  The original user was doing the rsync
> remotely, so I don't know the exact options he was using.

Ok, rsync doesn't do anything especially scarey.

> 
> 
> > 
> > What kind of array is this?  It really sounds like the IO isn't
> > happening properly.
> > 
> 
> Yeah, I'd be keen on blaming the arrays and/or machines if it weren't
> for the fact that we have other btrfs filesystems on these machines
> that hum along fine.
> 
> The array is from RAIDKing.  It's SCSI attached using SATA disks.  I
> can get the exact module number if it'll help.  The SCSI card is a LSI
> 53c1030 (again, let me know if you need exact make/model).

Does the array have any kind of writeback cache?

Are all of the filesystems spread across all of the drives?  Or do some
filesystems use some drives only?

-chris

