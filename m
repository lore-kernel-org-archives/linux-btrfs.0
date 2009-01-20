From: Dave Chinner <david@fromorbit.com>
Subject: Re: Warning and BUG with btrfs and corrupted image
Date: Tue, 20 Jan 2009 21:11:19 +1100
Message-ID: <20090120101119.GB10158@disturbed>
References: <20090113142147.GE16333@alice> <1231857643.29164.28.camel@think.oraclecorp.com> <20090113144307.GF16333@alice> <20090118174035.GG1944@ucw.cz> <20090120063150.GC5854@alice>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pavel Machek <pavel@suse.cz>, Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Eric Sesterhenn <snakebyte@gmx.de>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760455AbZATKLi@vger.kernel.org>
In-Reply-To: <20090120063150.GC5854@alice>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 20, 2009 at 07:31:50AM +0100, Eric Sesterhenn wrote:
> * Pavel Machek (pavel@suse.cz) wrote:
> > Does ext2/3 and vfat survive that kind of attacks? Those are 'in
> > production' and should survive it...
> 
> I regularly (once or twice a week) test 100 corrupted images of 
> vfat, udf, msdos, swap, iso9660, ext2, ext3, ext4, minix, bfs, befs,
> hfs, hfs+, qnx4, affs and cramfs on each of my two test machines.

Any reason you are not testing XFS in that set?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
