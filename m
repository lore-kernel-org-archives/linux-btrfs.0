From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Minimum device size of 256 MiB?
Date: Mon, 14 May 2012 09:01:43 +0000 (UTC)
Message-ID: <pan.2012.05.14.09.01.43@cox.net>
References: <CAALTfKDFhNgCuvuA3C+wYCBL2b-qZkNrwti_MbNn4Aiob+QdkQ@mail.gmail.com>
	<20120511205032.GV21964@eightyeight.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Aaron Toponce posted on Fri, 11 May 2012 14:50:32 -0600 as excerpted:

> On Fri, May 11, 2012 at 03:57:24PM -0400, Berke Durak wrote:
>> There seems to be a 256 MiB lower limit on device size : mkfs.btrfs
>> refuses to create a filesystem on a device that is smaller than that.
> 
> I've noticed the same. I'm interested in researching the patterns the
> filesystem puts down on an encrypted container, but would like to use
> 1MB files as the block device for the filesystem. Looking for patterns
> in 256MB files is too expensive.

You don't mention what kernels or how recent your btrfs-tools builds are, 
but that has been fixed recently, I believe for the 3.3 kernels but 
certainly for 3.4-rcs, as I have a 128 MB /boot on btrfs, here.

You can read about it in the wiki at btrfs.wiki.kernel.org, but 
basically, btrfs' normal allocation pattern is separate data and metadata 
"chunks", which on large enough filesystems are a gig each.  As the 
filesystem shrinks, so does the chunk, but the chunksize minimum used to 
be 256 MiB (or possibly 128 MiB, but you needed one data and one metadata 
chunk, totaling 256 MiB but only half of it could be used).

With current kernels and tools, a filesystem below a gig in size defaults 
to "mixed" mode, data and metadata mixed in the same chunk, and the 
minimum size of the chunk has been eliminated or at least significantly 
reduced, as well.  (I'm not sure if the minimum is tiny, now, say a MiB, 
or eliminated entirely, but a 128 MiB filesystem works, I know that.)

Meanwhile, as the wiki states repeatedly, btrfs is still an experimental 
filesystem, with enough changes going in that if you're not at least 
using the latest stable kernel if not the -rcs, you're using old and 
stale code that has known bugs compared to current.  Obviously, that 
applies here, since you're obviously using stale code if you're still 
running into this problem...

Unless of course you're running a new kernel and have run into a 
different bug.  The mixed-chunk code /is/ quite new, after all, and could 
have some bugs to work out.  But if you're running current and still 
seeing a 256 MiB minimum, then you're definitely seeing a bug, as that's 
supposed to be gone!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

