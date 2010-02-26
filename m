From: wfp5p@viridian.itc.virginia.edu (Bill Pemberton)
Subject: Re: assertion failures
Date: Fri, 26 Feb 2010 11:41:51 -0500 (EST)
Message-ID: <20100226164151.9830F414B9@viridian.itc.virginia.edu>
References: <20100226161730.GC12841@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com (Chris Mason)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100226161730.GC12841@think>
List-ID: <linux-btrfs.vger.kernel.org>

> > 
> > No dmesg.  This has happened on two different machines that both have
> > other active btrfs filesystems, so I suspect it's not a memory issue.
> > In both cases it was the same data that was being copied when the
> > crash occurred.
> 
> Ok, is there anything special about this data?
> 

There shouldn't be, it's the various backup files from a few
machines.  The only thing odd that I've seen in the data is there is
at least 1 file with some less-than-normally-used characters in the
name.

Rsyncing it from an ext4 fs to a btrfs fileystem on the same array
didn't cause the problem.  The original user was doing the rsync
remotely, so I don't know the exact options he was using.


> 
> What kind of array is this?  It really sounds like the IO isn't
> happening properly.
> 

Yeah, I'd be keen on blaming the arrays and/or machines if it weren't
for the fact that we have other btrfs filesystems on these machines
that hum along fine.

The array is from RAIDKing.  It's SCSI attached using SATA disks.  I
can get the exact module number if it'll help.  The SCSI card is a LSI
53c1030 (again, let me know if you need exact make/model).

-- 
Bill


