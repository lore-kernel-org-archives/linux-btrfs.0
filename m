Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from detritus.pyropus.ca ([64.5.53.58]:52613 "HELO
	detritus.pyropus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752368AbaLUWtD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Dec 2014 17:49:03 -0500
Date: Sun, 21 Dec 2014 16:53:15 -0600
From: Charles Cazabon <charlesc-lists-btrfs@pyropus.ca>
To: btrfs list <linux-btrfs@vger.kernel.org>
Subject: Re: Oddly slow read performance with near-full largish FS
Message-ID: <20141221225315.GA19479@pyropus.ca>
References: <20141217024228.GA5544@pyropus.ca> <54955624.5040808@pobox.com>
 <20141221163207.GA18988@pyropus.ca> <54973C65.6070709@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54973C65.6070709@pobox.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Robert,

My performance issues with btrfs are more-or-less resolved now -- the
performance under btrfs still seems quite variable compared to other
filesystems -- my rsync speed is now varying between 40MB and ~90MB/s, with
occasional intervals where it drops further, down into the 10-20MB/s range.
Still no disk errors or SMART warnings that would indicate that problem is at
the hardware level.

> Do make sure you are regularly running the long "offline" test.

Ok, I'll do that.

> Otherwise SMART is just going to tell you the disk just died when it dies.

Ya, I'm aware of how limited/useful the SMART diagnostics are.  I'm also
paranoid enough to be using RAID 6...

> The thing with "movablecore=" will not lead to an "out of memory"
> condition or not, its a question of cache and buffer evictions.

I'm fairly certain memory isn't the issue here.  For what it's worth:

%Cpu(s):  2.1 us, 19.4 sy,  0.0 ni, 78.0 id,  0.2 wa,  0.3 hi,  0.0 si,  0.0 st
KiB Mem:  16469880 total, 16301252 used,   168628 free,      720 buffers
KiB Swap:  7811068 total,        0 used,  7811068 free, 15146580 cached

Swappiness I've left at the default of 60, but I'm not seeing swapping going
on regardless.

> > Is this remaining difference (25 vs 100+ MB/s) simply due to btrfs not being
> > tuned for performance yet

I found the cause of this.  Stupidly enough, there was a bwlimit set up in a
shell alias for rsync.

So btrfs is not nearly as slow as I was seeing.  It's still slower than
reading from an ext4 or XFS filesystem on these disks, but the absolute level
of read speed seems reasonable enough given that btrfs has not been under
heavy performance tuning to date.  My only remaining concern would be the
variability I still see in the read speed.

Charles
-- 
-----------------------------------------------------------------------
Charles Cazabon
GPL'ed software available at:               http://pyropus.ca/software/
-----------------------------------------------------------------------
