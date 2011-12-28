From: Dave Chinner <david@fromorbit.com>
Subject: Re: Btrfs: blocked for more than 120 seconds, made worse by 3.2 rc7
Date: Thu, 29 Dec 2011 08:48:32 +1100
Message-ID: <20111228214832.GG12731@dastard>
References: <4EFB6D4F.6070002@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4EFB6D4F.6070002@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 28, 2011 at 09:26:07PM +0200, Konstantinos Skarlatos wrote:
> Hello all:
> I have two machines with btrfs, that give me the "blocked for more
> than 120 seconds" message. After that I cannot write anything to
> disk, i am unable to unmount the btrfs filesystem and i can only
> reboot with sysrq-trigger.
> 
> It always happens when i write many files with rsync over network.
> When i used 3.2rc6 it happened randomly on both machines after
> 50-500gb of writes. with rc7 it happens after much less writes,
> probably 10gb or so, but only on machine 1 for the time being.
> machine 2 has not crashed yet after 200gb of writes and I am still
> testing that.
> 
> machine 1: btrfs on a 6tb sparse file, mounted as loop, on a xfs
> filesystem that lies on a 10TB md raid5. mount options
> compress=zlib,compress-force
> 
> machine 2: btrfs over md raid 5 (4x2TB)=5.5TB filesystem. mount
> options compress=zlib,compress-force
> 
> pastebins:
> 
> machine1:
> 3.2rc7 http://pastebin.com/u583G7jK
> 3.2rc6 http://pastebin.com/L12TDaXa

These two are caused by it taking longer than 120s for XFS to fsync
the loop file. Writing a signficant chunk of a sparse 6TB file on a
software RAID5  volume is going to take some time.  However, if IO
is not occurring, then somewhere below XFS an IO has gone missing
(MD or hardware problem) because the fsync on the XFS file is
blocked waiting for an IO completion.

> machine2:
> 3.2rc6 http://pastebin.com/khD0wGXx
> 3.2rc7 (not crashed yet)

These don't have XFS in the picture, but also appear to be hung
waiting on IO completion with MD stuck in
make_request()->get_active_stripe(). That, to me, indicates an MD
problem.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
