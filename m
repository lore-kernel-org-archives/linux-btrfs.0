Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42109 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753061AbeAGLRW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 7 Jan 2018 06:17:22 -0500
Subject: Re: hang in btrfs_async_reclaim_metadata_space
To: Adam Borowski <kilobyte@angband.pl>, linux-btrfs@vger.kernel.org
References: <20180106051059.kpultyyfhgxjowf5@angband.pl>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <80c373ee-1bd7-d59b-a252-04309c8b0210@suse.com>
Date: Sun, 7 Jan 2018 13:17:19 +0200
MIME-Version: 1.0
In-Reply-To: <20180106051059.kpultyyfhgxjowf5@angband.pl>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  6.01.2018 07:10, Adam Borowski wrote:
> Hi!
> I got a reproducible infinite hang, reliably triggered by the testsuite of
> "flatpak"; fails on at least 4.15-rc6, 4.9.75, and on another machine with
> Debian's 4.14.2-1.
> 
> [580632.355107] INFO: task kworker/u8:2:11105 blocked for more than 120 seconds.
> [580632.355120]       Not tainted 4.14.0-1-amd64 #1 Debian 4.14.2-1
> [580632.355124] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [580632.355129] kworker/u8:2    D    0 11105      2 0x80000000
> [580632.355176] Workqueue: events_unbound btrfs_async_reclaim_metadata_space [btrfs]
> [580632.355179] Call Trace:
> [580632.355192]  __schedule+0x28e/0x880
> [580632.355196]  schedule+0x2c/0x80
> [580632.355200]  wb_wait_for_completion+0x64/0x90
> [580632.355205]  ? finish_wait+0x80/0x80
> [580632.355207]  __writeback_inodes_sb_nr+0xa1/0xd0
> [580632.355210]  writeback_inodes_sb_nr+0x10/0x20
> [580632.355235]  flush_space+0x3ed/0x520 [btrfs]
> [580632.355238]  ? pick_next_task_fair+0x158/0x590
> [580632.355242]  ? __switch_to+0x1f3/0x460
> [580632.355267]  btrfs_async_reclaim_metadata_space+0xf6/0x4a0 [btrfs]
> [580632.355278]  process_one_work+0x198/0x390
> [580632.355281]  worker_thread+0x35/0x3c0
> [580632.355284]  kthread+0x125/0x140
> [580632.355287]  ? process_one_work+0x390/0x390
> [580632.355289]  ? kthread_create_on_node+0x70/0x70
> [580632.355292]  ? SyS_exit_group+0x14/0x20
> [580632.355295]  ret_from_fork+0x25/0x30
> 
> The machines are distinct enough that this probably should happen
> everywhere:
> 
> AMD Phenom2, SSD, noatime,compress=lzo,space_cache=v2
> Intel Braswell, rust, noatime,autodefrag,space_cache=v2


Provide output of echo w > /proc/sysrq-trigger when the hang happens.

> 
> 
> Meow!
> 
