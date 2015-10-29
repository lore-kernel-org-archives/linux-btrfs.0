Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vs2.lukas-pirl.de ([5.45.100.90]:58790 "EHLO pim.lukas-pirl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbbJ2Vns (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Oct 2015 17:43:48 -0400
Subject: Re: corrupted RAID1: unsuccessful recovery / help needed
References: <562DC606.3070602@lukas-pirl.de>
 <pan$deb9e$70dd599$c247d7fb$410817e7@cox.net>
From: Lukas Pirl <btrfs@lukas-pirl.de>
Cc: linux-btrfs@vger.kernel.org
To: 1i5t5.duncan@cox.net
Message-ID: <5632930D.4040000@lukas-pirl.de>
Date: Fri, 30 Oct 2015 10:43:41 +1300
MIME-Version: 1.0
In-Reply-To: <pan$deb9e$70dd599$c247d7fb$410817e7@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

TL;DR: thanks but recovery still preferred over recreation.

Hello Duncan and thanks for your reply!

On 10/26/2015 09:31 PM, Duncan wrote:
> FWIW... Older btrfs userspace such as your v3.17 is "OK" for normal
> runtime use, assuming you don't need any newer features, as in normal
> runtime, it's the kernel code doing the real work and userspace for the
> most part simply makes the appropriate kernel calls to do that work.
 >
> But, once you get into a recovery situation like the one you're in now,
> current userspace becomes much more important, as the various things
> you'll do to attempt recovery rely far more on userspace code directly
> accessing the filesystem, and it's only the newest userspace code that
> has the latest fixes.
>
> So for a recovery situation, the newest userspace release (4.2.2 at
> present) as well as a recent kernel is recommended, and depending on the
> problem, you may at times need to run integration or apply patches on top
> of that.

I am willing to update before trying further repairs. Is e.g. "balance" 
also influenced by the userspace tools or does the kernel the actual work?

> General note about btrfs and btrfs raid.  Given that btrfs itself remains
> a "stabilizing, but not yet fully mature and stable filesystem", while
> btrfs raid will often let you recover from a bad device, sometimes that
> recovery is in the form of letting you mount ro, so you can access the
> data and copy it elsewhere, before blowing away the filesystem and
> starting over.

If there is one subvolume that contains all other (read only) snapshots 
and there is insufficient storage to copy them all separately:
Is there an elegant way to preserve those when moving the data across disks?

> Back to the problem at hand.  Current btrfs has a known limitation when
> operating in degraded mode.  That being, a btrfs raid may be write-
> mountable only once, degraded, after which it can only be read-only
> mounted.  This is because under certain circumstances in degraded mode,
> btrfs will fall back from its normal raid mode to single mode chunk
> allocation for new writes, and once there's single-mode chunks on the
> filesystem, btrfs mount isn't currently smart enough to check that all
> chunks are actually available on present devices, and simply jumps to the
> conclusion that there's single mode chunks on the missing device(s) as
> well, so refuses to mount writable after that in ordered to prevent
> further damage to the filesystem and preserve the ability to mount at
> least ro, to copy off what isn't damaged.
>
> There's a patch in the pipeline for this problem, that checks individual
> chunks instead of leaping to conclusions based on the presence of single-
> mode chunks on a degraded filesystem with missing devices.  If that's
> your only problem (which the backtraces might reveal but I as a non-dev
> btrfs user can't tell), the patches should let you mount writable.

Interesting, thanks for the insights.

> But that patch isn't in kernel 4.2.  You'll need at least kernel 4.3-rc,
> and possibly btrfs integration, or to cherrypick the patches onto 4.2.

Well, before digging into that, a hint that this is actually the case 
would be appreciated. :)

> Meanwhile, in keeping with the admin's rule on backups, by definition, if
> you valued the data more than the time and resources necessary for a
> backup, by definition, you have a backup available, otherwise, by
> definition, you valued the data less than the time and resources
> necessary to back it up.
>
> Therefore, no worries.  Regardless of the fate of the data, you saved
> what your actions declared of most valuable to you, either the data, or
> the hassle and resources cost of the backup you didn't do.  As such, if
> you don't have a backup (or if you do but it's outdated), the data at
> risk of loss is by definition of very limited value.
>
> That said, it appears you don't even have to worry about loss of that
> very limited value data, since mounting degraded,recovery,ro gives you
> stable access to it, and you can use the opportunity provided to copy it
> elsewhere, at least to the extent that the data we already know is of
> limited value is even worth the hassle of doing that.
>
> Which is exactly what I'd do.  Actually, I've had to resort to btrfs
> restore[1] a couple times when the filesystem wouldn't mount at all, so
> the fact that you can mount it degraded,recovery,ro, already puts you
> ahead of the game. =:^)
>
> So yeah, first thing, since you have the opportunity, unless your backups
> are sufficiently current that it's not worth the trouble, copy off the
> data while you can.
>
> Then, unless you wish to keep the filesystem around in case the devs want
> to use it to improve btrfs' recovery system, I'd just blow it away and
> start over, restoring the data from backup once you have a fresh
> filesystem to restore to.  That's the simplest and fastest way to a fully
> working system once again, and what I did here after using btrfs restore
> to recover the delta between current and my backups.

Thanks for all the elaborations. I guess there are also other valid 
definitions of making backups out there – some that determine the amount 
and the types of redundancy by additionally taking factors like the 
anticipated risk of a failure or the severity of a failure into 
consideration.

However, you are perfectly correct with your advice to 
create/update/verify all backups as it is (still) possible.

Besides that, I'd still be willing to restore the file system and to 
provide additional information to devs.

Cheers,

Lukas
