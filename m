From: Chris Mason <chris.mason@oracle.com>
Subject: Re: kernel BUG when removing missing drive (Take 2)
Date: Thu, 28 Oct 2010 16:57:05 -0400
Message-ID: <20101028205705.GE27796@think>
References: <AANLkTimECim-kSVfuZkAS2pfNJi1rtA-voC98YR3iYoT@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Erik Jensen <eriksjunk@rkjnsn.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimECim-kSVfuZkAS2pfNJi1rtA-voC98YR3iYoT@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 19, 2010 at 07:17:16PM -0700, Erik Jensen wrote:
> One of my drives on my six drive btrfs setup recently died.  I
> initially wasn't too worried about it, since both my data and metadata
> are raid1.  However, I have so far not been able to remove the missing
> drive after several attempts.
> 
> After discussing my problem on IRC, Chris Mason asked me to list
> everything I've tried on the mailing list, so here goes:

Ok, so the current code in the scratch branch is probably going to get
rebased.  I've got some commits in there to add features to the bdi
code, but those features are still being discussed.

But, if you:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git scratch

You'll get the scratch branch of the btrfs-unstable repo.  It fixes the
oops on an unwritable missing drive, which I did reproduce locally.

Please let me know how this works

-chris

> 
> 1. I was attempting to cut commercials out of a TV recording when
> things seemed to stall.  A look a dmesg told me that one of my drives
> was having many read failures.
> 2. I shut down my computer and removed the failed drive.
> 3. I booted back up and mounted the array in degraded mode.  A quick
> ls showed all my files.
> 4. I checked my filesystem usage and concluded that I should have
> enough free space to build back up to full redundancy on the remaining
> drives, so I would be protected until my replacement arrived.
> 5. I executed "btrfs-vol -r missing", which churned the hard drives
> for a little bit and then stalled.  dmesg showed this kernel BUG:
> http://pastebin.com/KgjUUBq0
> 6. The system wouldn't reboot normally at this point, so I had to use SysRq
> 7. I temporarily booted a 2.6.35 kernel (I'm currently running 2.6.34)
> and tried to remove the missing drive again, with the same result.
> 8. [back on 2.6.34] My replacement drive arrived, so I installed it
> and added it to the btrfs pool.
> 9. I tried "btrfs-vol -r missing" again, and received the same kernel
> BUG once again.
> 10. After using SysRq to reboot, I tried doing a "btrfs-vol -b", which
> moved some data around and halted with the same BUG.
> 11. I checked the kernel source to find why the bug was being thrown.
> The offending line was "BUG_ON(rw == WRITE && !dev->writeable);" in
> btrfs_map_bio in volumes.c
> 12. I used "badblocks -nsv" to make sure of all my hard drives were
> writeable, which they were.
> 
> A paste of all of the logged kernel messages from 8 and 9 is at
> http://pastebin.org/322902
> 
> I would like to get this figured out as quickly as possible, since my
> data is currently spread across 6 drives with (effectively) no
> redundancy.
> 
> I do have C programming experience, so if there is a way that I can
> help track down the problem, please let me know.
> 
> Thanks,
> Erik
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
