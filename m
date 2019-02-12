Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B9ABC282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 16:46:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A17B217D9
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 16:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730744AbfBLQqK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 11:46:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:40968 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728035AbfBLQqK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 11:46:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C444FAF76;
        Tue, 12 Feb 2019 16:46:08 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 32BDCDA84E; Tue, 12 Feb 2019 17:45:25 +0100 (CET)
Date:   Tue, 12 Feb 2019 17:45:23 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 1/3] btrfs: scrub: fix circular locking dependency
 warning
Message-ID: <20190212164522.GE2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1548830702-14676-1-git-send-email-anand.jain@oracle.com>
 <1548830702-14676-2-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548830702-14676-2-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 30, 2019 at 02:45:00PM +0800, Anand Jain wrote:
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

Please next time make sure the log messages are copied without
whitespace damage. In many cases it's easy to glue the lines together,
but specially the above locking scenario needs to be exact as the
indentaion matters.

I'll replace the whole report with the one in my logs as it does not
have the device_list_mutex in the locking chain. This would be confusing
as the problem with device_list_mutex was fixed already.

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

This like can be ommitted from the log unless we really want to decode
the instructions.
