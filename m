Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55284 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751533AbeBTMnd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Feb 2018 07:43:33 -0500
Subject: Re: [PATCH] btrfs: Fix rcu_dereference usage outside of read critical
 section
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <1519126829-29742-1-git-send-email-nborisov@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <39c7aa3d-03c5-c7d0-1e69-9e3490679e93@oracle.com>
Date: Tue, 20 Feb 2018 20:44:57 +0800
MIME-Version: 1.0
In-Reply-To: <1519126829-29742-1-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/20/2018 07:40 PM, Nikolay Borisov wrote:
> Patch 11ac3f1da5fd ("btrfs: log, when replace, is canceled by the user")
> added a new btrfs_info call with a couple of btrfs_dev_name() args. This
> is wrong since the latter require being called in rcu read side
> critical section. Fix it by instead calling btrfs_info_in_rcu. This
> fixes the following splat:
> 
> =============================
> WARNING: suspicious RCU usage
> 4.16.0-rc2-nbor #463 Not tainted
> -----------------------------
> fs/btrfs/dev-replace.c:318 suspicious rcu_dereference_check() usage!
> 
> other info that might help us debug this:
> 
> rcu_scheduler_active = 2, debug_locks = 1
> 1 lock held by btrfs/5698:
>   #0:  (&fs_info->dev_replace.lock_finishing_cancel_unmount){+.+.}, at: [<00000000942cb4ee>] btrfs_dev_replace_cancel+0xac/0x3f0
> 
> stack backtrace:
> CPU: 2 PID: 5698 Comm: btrfs Not tainted 4.16.0-rc2-nbor #463
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
> Call Trace:
>   dump_stack+0x85/0xc9
>   lockdep_rcu_suspicious+0x123/0x170
>   btrfs_dev_name.part.1+0x6d/0x80
>   btrfs_dev_replace_cancel+0x330/0x3f0
>   btrfs_ioctl+0x2751/0x65b0
>   ? debug_check_no_locks_freed+0x290/0x290
>   ? trace_hardirqs_on_caller+0x400/0x570
>   ? trace_hardirqs_on+0xd/0x10
>   ? btrfs_ioctl_get_supported_features+0x30/0x30
>   ? __handle_mm_fault+0x1aca/0x3230
>   ? lock_downgrade+0x650/0x650
>   ? trace_hardirqs_on+0xd/0x10
>   ? mem_cgroup_commit_charge+0xc0/0xdd0
>   ? _raw_spin_unlock+0x27/0x40
>   ? __handle_mm_fault+0x1aca/0x3230
>   ? lock_downgrade+0x650/0x650
>   ? vm_insert_page+0x650/0x650
>   ? __vma_link_rb+0x125/0x1d0
>   do_vfs_ioctl+0x184/0xf00
>   ? do_vfs_ioctl+0x184/0xf00
>   ? lock_downgrade+0x650/0x650
>   ? ioctl_preallocate+0x1a0/0x1a0
>   ? up_read+0x1f/0x40
>   ? __do_page_fault+0x5c6/0xb30
>   ? SyS_brk+0x412/0x5f0
>   ? mm_fault_error+0x2e0/0x2e0
>   SyS_ioctl+0x41/0x70
>   ? do_vfs_ioctl+0xf00/0xf00
>   do_syscall_64+0x19d/0x5d0
>   entry_SYSCALL_64_after_hwframe+0x42/0xb7
> 
> Fixes: 11ac3f1da5fd ("btrfs: log, when replace, is canceled by the user")
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

  I notice too. Thanks Nikolay for the fix.

  Reviewed-by: Anand Jain <anand.jain@oracle.com>


> ---
>   fs/btrfs/dev-replace.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index 3b0760f7ec8a..0e776eb90ad8 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -744,7 +744,7 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
>   	ret = btrfs_commit_transaction(trans);
>   	WARN_ON(ret);
>   
> -	btrfs_info(fs_info, "dev_replace from %s (devid %llu) to %s canceled",
> +	btrfs_info_in_rcu(fs_info, "dev_replace from %s (devid %llu) to %s cancelled",
>   		   btrfs_dev_name(src_device), src_device->devid,
>   		   btrfs_dev_name(tgt_device));
>   
> 
