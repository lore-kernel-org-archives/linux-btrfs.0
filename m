Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:11277 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751255AbaB1AMy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 19:12:54 -0500
Date: Fri, 28 Feb 2014 11:12:50 +1100
From: Dave Chinner <david@fromorbit.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: otakujunction@gmail.com, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Help with space
Message-ID: <20140228001250.GA13647@dastard>
References: <CAAmRLYx1L=o7a2PMSAiJbr7qH_JiuYG2-ncHG-mHLyLcM3Z-GQ@mail.gmail.com>
 <DCDC90E8-4834-416A-AC00-B11FC9A66281@colorremedies.com>
 <82E08C64-154E-460E-A052-E60BC00D662C@colorremedies.com>
 <B2988EF9-46EB-4804-A024-EE3B3A9E8771@gmail.com>
 <819E17EB-E4C2-4BD7-8D55-8C8DF9B8573B@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <819E17EB-E4C2-4BD7-8D55-8C8DF9B8573B@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 27, 2014 at 02:11:19PM -0700, Chris Murphy wrote:
> 
> On Feb 27, 2014, at 1:49 PM, otakujunction@gmail.com wrote:
> 
> > Yes it's an ancient 32 bit machine.  There must be a complex bug
> > involved as the system, when originally mounted, claimed the
> > correct free space and only as used over time did the
> > discrepancy between used and free grow.  I'm afraid I chose
> > btrfs because it appeared capable of breaking the 16 tera limit
> > on a 32 bit system.  If this isn't the case then it's incredible
> > that I've been using this file system for about a year without
> > difficulty until now.
> 
> Yep, it's not a good bug. This happened some years ago on XFS too,
> where people would use the file system for a long time and then at
> 16TB+1byte written to the volume, kablewy! And then it wasn't
> usable at all, until put on a 64-bit kernel.
> 
> http://oss.sgi.com/pipermail/xfs/2014-February/034588.html

Well, no, that's not what I said. I said that it was limited on XFS,
not that the limit was a result of a user making a filesystem too
large and then finding out it didn't work. Indeed, you can't do that
on XFS - mkfs will refuse to run on a block device it can't access the
last block on, and the kernel has the same "can I access the last
block of the filesystem" sanity checks that are run at mount and
growfs time.

IOWs, XFS has *never* allowed >16TB on 32 bit systems on Linux. And,
historically speaking, it didn't even allow it on Irix. Irix on 32
bit systems was limited to 1TB (2^31 sectors of 2^9 bytes = 1TB),
and only as Linux gained sufficient capability on 32 bit systems
(e.g.  CONFIG_LBD) was the limit increased. The limit we are now at
is the address space index being 32 bits, so the size is limited by
2^32 * PAGE_SIZE = 2^44 = 16TB....

i.e Back when XFS was still being ported to Linux from Irix in 2000:

203 #if !XFS_BIG_FILESYSTEMS
204         if (sbp->sb_dblocks > INT_MAX || sbp->sb_rblocks > INT_MAX)  {
205                 cmn_err(CE_WARN,
206 "XFS:  File systems greater than 1TB not supported on this system.\n");
207                 return XFS_ERROR(E2BIG);
208         }
209 #endif

(http://oss.sgi.com/cgi-bin/gitweb.cgi?p=archive/xfs-import.git;a=blob;f=fs/xfs/xfs_mount.c;hb=60a4726a60437654e2af369ccc8458376e1657b9)

So, good story, but is not true.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
