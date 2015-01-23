Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63359 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750917AbbAWCcU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Jan 2015 21:32:20 -0500
Message-ID: <54C1B2B0.8040406@cn.fujitsu.com>
Date: Fri, 23 Jan 2015 10:32:16 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
CC: <guihc.fnst@cn.fujitsu.com>, <miaoxie@huawei.com>, <clm@fb.com>
Subject: Re: [PULL] [PATCH 0/3] Btrfs, fixes for freezing vs pending changes
References: <cover.1421776294.git.dsterba@suse.cz>
In-Reply-To: <cover.1421776294.git.dsterba@suse.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

Would you please delay this patchset to be merged into next rc?

In fact, I think there is a better solution for such problem.

1) mount option change problem.
In fact, there is no need to start a transaction to change mount option, 
since it doesn't change anything
on-disk.
What we need is just to keep the mount option doesn't change during 
transaction.
(Although several exceptions still exists, but should be OK)

So I prefer to add a rwsem to protect mount_opt, each btrfs_transaction 
will hold the read lock on it
and upon btrfs_put_transaction(), read unlock it.
btrfs_parse_option() should wait for write lock to change it.

BTW, current btrfs_parse_options() is not atomic, and for nospace_cache 
mount option,
SPACE_CACHE bit is always first set and later cleared, which created a 
window btrfs_commit_transaction()
can create space cache. I'll solve it by using copy-n-update method.

2) Sysfs label/feature change problem
For this problem, I agree with Miao to keep the behavior the same as 
"btrfs pro set" command,
since it will write something on disk.
And since btrfs_ioctl_set_fslabel() is synchronized, I didn't see the 
necessity to change it to async using sysfs.

What do you think about this idea?
Although, I'm afraid this may revert all your pending_changes 
patches.... :-<
(In fact, I'm already dealing the mount option change problem)

Thanks,
Qu

-------- Original Message --------
Subject: [PULL] [PATCH 0/3] Btrfs, fixes for freezing vs pending changes
From: David Sterba <dsterba@suse.cz>
To: <linux-btrfs@vger.kernel.org>
Date: 2015年01月21日 02:05
> There was some churn regarding the patches to $SUBJ, here's what I think is
> enough to fix it for 3.19.
>
> It's based on top of my other patch "btrfs: sync ioctl, handle errors after
> transaction start" that might land in Chris' for-linus already so it's not
> included here.
>
> The patches are for review by the involved people, also available in this
> branch:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git
>
> David Sterba (1):
>    btrfs: remove a no-op unfreeze superbock callback
>
> Qu Wenruo (2):
>    btrfs: Fix the bug that fs_info->pending_changes is never cleared.
>    btrfs: Don't call btrfs_start_transaction() on frozen fs to avoid
>      deadlock.
>
>   fs/btrfs/super.c       | 16 ++++++++++------
>   fs/btrfs/transaction.c |  2 +-
>   2 files changed, 11 insertions(+), 7 deletions(-)
>

