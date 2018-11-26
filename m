Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC0D2C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 09:59:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FD3320850
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 09:59:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9FD3320850
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbeKZUxF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 26 Nov 2018 15:53:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:48992 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726184AbeKZUxF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Nov 2018 15:53:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D5733AF6A;
        Mon, 26 Nov 2018 09:59:26 +0000 (UTC)
Subject: Re: [PATCH 2/2] btrfs: scrub: fix circular locking dependency warning
To:     Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <1543223228-28232-1-git-send-email-anand.jain@oracle.com>
 <1543223228-28232-3-git-send-email-anand.jain@oracle.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <ed04b1e5-b187-7ea9-3f8d-0a14f1143232@suse.com>
Date:   Mon, 26 Nov 2018 11:59:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1543223228-28232-3-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 26.11.18 г. 11:07 ч., Anand Jain wrote:
> Circular locking dependency check reports warning[1], that's because
> the btrfs_scrub_dev() calls the stack #0 below with, the
> fs_info::scrub_lock held. The test case leading to this warning..
> 
>   mkfs.btrfs -fq /dev/sdb && mount /dev/sdb /btrfs
>   btrfs scrub start -B /btrfs
> 
> In fact we have fs_info::scrub_workers_refcnt to tack if the init and
> destroy of the scrub workers are needed. So once we have incremented
> and decremented the fs_info::scrub_workers_refcnt value in the thread,
> its ok to drop the scrub_lock, and then actually do the
> btrfs_destroy_workqueue() part. So this patch drops the scrub_lock
> before calling btrfs_destroy_workqueue().
> 
> [1]
> [   76.146826] ======================================================
> [   76.147086] WARNING: possible circular locking dependency detected
> [   76.147316] 4.20.0-rc3+ #41 Not tainted
> [   76.147489] ------------------------------------------------------
> [   76.147722] btrfs/4065 is trying to acquire lock:
> [   76.147984] 0000000038593bc0 ((wq_completion)"%s-%s""btrfs",
> name){+.+.}, at: flush_workqueue+0x70/0x4d0
> [   76.148337]
> but task is already holding lock:
> [   76.148594] 0000000062392ab7 (&fs_info->scrub_lock){+.+.}, at:
> btrfs_scrub_dev+0x316/0x5d0 [btrfs]
> [   76.148909]
> which lock already depends on the new lock.
> 
> [   76.149191]
> the existing dependency chain (in reverse order) is:
> [   76.149446]
> -> #3 (&fs_info->scrub_lock){+.+.}:
> [   76.149707]        btrfs_scrub_dev+0x11f/0x5d0 [btrfs]
> [   76.149924]        btrfs_ioctl+0x1ac3/0x2d80 [btrfs]
> [   76.150216]        do_vfs_ioctl+0xa9/0x6d0
> [   76.150468]        ksys_ioctl+0x60/0x90
> [   76.150716]        __x64_sys_ioctl+0x16/0x20
> [   76.150911]        do_syscall_64+0x50/0x180
> [   76.151182]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [   76.151469]
> -> #2 (&fs_devs->device_list_mutex){+.+.}:
> [   76.151851]        reada_start_machine_worker+0xca/0x3f0 [btrfs]
> [   76.152195]        normal_work_helper+0xf0/0x4c0 [btrfs]
> [   76.152489]        process_one_work+0x1f4/0x520
> [   76.152751]        worker_thread+0x46/0x3d0
> [   76.153715]        kthread+0xf8/0x130
> [   76.153912]        ret_from_fork+0x3a/0x50
> [   76.154178]
> -> #1 ((work_completion)(&work->normal_work)){+.+.}:
> [   76.154575]        worker_thread+0x46/0x3d0
> [   76.154828]        kthread+0xf8/0x130
> [   76.155108]        ret_from_fork+0x3a/0x50
> [   76.155357]
> -> #0 ((wq_completion)"%s-%s""btrfs", name){+.+.}:
> [   76.155751]        flush_workqueue+0x9a/0x4d0
> [   76.155911]        drain_workqueue+0xca/0x1a0
> [   76.156182]        destroy_workqueue+0x17/0x230
> [   76.156455]        btrfs_destroy_workqueue+0x5d/0x1c0 [btrfs]
> [   76.156756]        scrub_workers_put+0x2e/0x60 [btrfs]
> [   76.156931]        btrfs_scrub_dev+0x329/0x5d0 [btrfs]
> [   76.157219]        btrfs_ioctl+0x1ac3/0x2d80 [btrfs]
> [   76.157491]        do_vfs_ioctl+0xa9/0x6d0
> [   76.157742]        ksys_ioctl+0x60/0x90
> [   76.157910]        __x64_sys_ioctl+0x16/0x20
> [   76.158177]        do_syscall_64+0x50/0x180
> [   76.158429]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [   76.158716]
> other info that might help us debug this:
> 
> [   76.158908] Chain exists of:
>   (wq_completion)"%s-%s""btrfs", name --> &fs_devs->device_list_mutex
> --> &fs_info->scrub_lock
> 
> [   76.159629]  Possible unsafe locking scenario:
> 
> [   76.160607]        CPU0                    CPU1
> [   76.160934]        ----                    ----
> [   76.161210]   lock(&fs_info->scrub_lock);
> [   76.161458]
> lock(&fs_devs->device_list_mutex);
> [   76.161805]
> lock(&fs_info->scrub_lock);
> [   76.161909]   lock((wq_completion)"%s-%s""btrfs", name);
> [   76.162201]
>  *** DEADLOCK ***
> 
> [   76.162627] 2 locks held by btrfs/4065:
> [   76.162897]  #0: 00000000bef2775b (sb_writers#12){.+.+}, at:
> mnt_want_write_file+0x24/0x50
> [   76.163335]  #1: 0000000062392ab7 (&fs_info->scrub_lock){+.+.}, at:
> btrfs_scrub_dev+0x316/0x5d0 [btrfs]
> [   76.163796]
> stack backtrace:
> [   76.163911] CPU: 1 PID: 4065 Comm: btrfs Not tainted 4.20.0-rc3+ #41
> [   76.164228] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS
> VirtualBox 12/01/2006
> [   76.164646] Call Trace:
> [   76.164872]  dump_stack+0x5e/0x8b
> [   76.165128]  print_circular_bug.isra.37+0x1f1/0x1fe
> [   76.165398]  __lock_acquire+0x14aa/0x1620
> [   76.165652]  lock_acquire+0xb0/0x190
> [   76.165910]  ? flush_workqueue+0x70/0x4d0
> [   76.166175]  flush_workqueue+0x9a/0x4d0
> [   76.166420]  ? flush_workqueue+0x70/0x4d0
> [   76.166671]  ? drain_workqueue+0x52/0x1a0
> [   76.166911]  drain_workqueue+0xca/0x1a0
> [   76.167167]  destroy_workqueue+0x17/0x230
> [   76.167428]  btrfs_destroy_workqueue+0x5d/0x1c0 [btrfs]
> [   76.167720]  scrub_workers_put+0x2e/0x60 [btrfs]
> [   76.168233]  btrfs_scrub_dev+0x329/0x5d0 [btrfs]
> [   76.168504]  ? __sb_start_write+0x121/0x1b0
> [   76.168759]  ? mnt_want_write_file+0x24/0x50
> [   76.169654]  btrfs_ioctl+0x1ac3/0x2d80 [btrfs]
> [   76.169934]  ? find_held_lock+0x2d/0x90
> [   76.170204]  ? find_held_lock+0x2d/0x90
> [   76.170450]  do_vfs_ioctl+0xa9/0x6d0
> [   76.170690]  ? __fget+0x101/0x1f0
> [   76.170910]  ? __fget+0x5/0x1f0
> [   76.171157]  ksys_ioctl+0x60/0x90
> [   76.171391]  __x64_sys_ioctl+0x16/0x20
> [   76.171634]  do_syscall_64+0x50/0x180
> [   76.171892]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [   76.172186] RIP: 0033:0x7f61d422e567
> [   76.172425] Code: 44 00 00 48 8b 05 29 09 2d 00 64 c7 00 26 00 00 00
> 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f
> 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d f9 08 2d 00 f7 d8 64 89 01 48
> [   76.172911] RSP: 002b:00007f61d3936d68 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000010
> [   76.173328] RAX: ffffffffffffffda RBX: 00000000019026b0 RCX:
> 00007f61d422e567
> [   76.173649] RDX: 00000000019026b0 RSI: 00000000c400941b RDI:
> 0000000000000003
> [   76.173909] RBP: 0000000000000000 R08: 00007f61d3937700 R09:
> 0000000000000000
> [   76.174244] R10: 00007f61d3937700 R11: 0000000000000246 R12:
> 0000000000000000
> [   76.174566] R13: 0000000000801000 R14: 0000000000000000 R15:
> 00007f61d3937700
> [   76.175217] btrfs (4065) used greatest stack depth: 11424 bytes left
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/scrub.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index b1c2d1cdbd4b..3fc31eeef2a7 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -3757,10 +3757,13 @@ static noinline_for_stack int scrub_workers_get(struct btrfs_fs_info *fs_info,
>  
>  static noinline_for_stack void scrub_workers_put(struct btrfs_fs_info *fs_info)
>  {
> +	lockdep_assert_held(&fs_info->scrub_lock);
>  	if (--fs_info->scrub_workers_refcnt == 0) {
> +		mutex_unlock(&fs_info->scrub_lock);
>  		btrfs_destroy_workqueue(fs_info->scrub_workers);
>  		btrfs_destroy_workqueue(fs_info->scrub_wr_completion_workers);
>  		btrfs_destroy_workqueue(fs_info->scrub_parity_workers);
> +		mutex_lock(&fs_info->scrub_lock);
>  	}

This looks ok, however:

1. lockdep_assert_held should also be added to get scrub workers

2. scrub_workers_refcnt must eventually be converted to refcount_t type
and the _refcnt dropped from the name

3. Do we really need 3 workqueues for scrub? Are we really winning
anything by having that many instead of one or just queueing scrub to a
generic one?

>  	WARN_ON(fs_info->scrub_workers_refcnt < 0);
>  }
> 
