Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:39069 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbbBRG0g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Feb 2015 01:26:36 -0500
Received: by pdjy10 with SMTP id y10so49283650pdj.6
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Feb 2015 22:26:35 -0800 (PST)
Date: Tue, 17 Feb 2015 22:26:29 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Steven Schlansker <sschlansker@opentable.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Forever blocked in bit_wait with kernel 3.19
Message-ID: <20150218062629.GA18372@mew>
References: <9E2DE950-1434-424B-974C-2ABE4BD22EE5@opentable.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9E2DE950-1434-424B-974C-2ABE4BD22EE5@opentable.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 12, 2015 at 11:12:25AM +0000, Steven Schlansker wrote:
> [ Please CC me on replies, I'm not on the list ]
> [ This is a followup to http://www.spinics.net/lists/linux-btrfs/msg41496.html ]
> 
> Hello linux-btrfs,
> I've been having troubles keeping my Apache Mesos / Docker slave nodes stable.  After some period of load, tasks begin to hang.  Once this happens task after task ends up waiting at the same point, never to return.  The system quickly becomes unusable and must be terminated.
> 
> After the previous issues, I was encouraged to upgrade and retry.  I am now running
> 
> Linux 3.19.0 #1 SMP Mon Feb 9 09:43:11 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
> Btrfs v3.18.2 (and this version was also used to mkfs)
> 
> root@ip-10-30-38-86:~# btrfs fi show
> Label: none  uuid: 0e8c3f1d-b07b-4643-9834-a41dafb80257
> 	Total devices 2 FS bytes used 3.92GiB
> 	devid    1 size 74.99GiB used 4.01GiB path /dev/xvdc
> 	devid    2 size 74.99GiB used 4.01GiB path /dev/xvdd
> 
> Btrfs v3.18.2
> 
> Data, RAID0: total=6.00GiB, used=3.69GiB
> System, RAID0: total=16.00MiB, used=16.00KiB
> Metadata, RAID0: total=2.00GiB, used=229.30MiB
> GlobalReserve, single: total=80.00MiB, used=0.00B
> 
> This is the first hung task:
> 
> [146280.252086] INFO: task java:28252 blocked for more than 120 seconds.
> [146280.252096]       Tainted: G            E  3.19.0 #1
> [146280.252098] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [146280.252102] java            D ffff8805584df528     0 28252   1400 0x00000000
> [146280.252106]  ffff8805584df528 ffff880756a24aa0 0000000000014100 ffff8805584dffd8
> [146280.252108]  0000000000014100 ffff8807567c31c0 ffff880756a24aa0 ffff8805584df5d0
> [146280.252109]  ffff88075a314a00 ffff8805584df5d0 ffff88077c3f8ce8 0000000000000002
> [146280.252111] Call Trace:
> [146280.252120]  [<ffffffff8194efa0>] ? bit_wait+0x50/0x50
> [146280.252122]  [<ffffffff8194e770>] io_schedule+0xa0/0x130
> [146280.252125]  [<ffffffff8194efcc>] bit_wait_io+0x2c/0x50
> [146280.252127]  [<ffffffff8194ec05>] __wait_on_bit+0x65/0x90
> [146280.252131]  [<ffffffff81169ad7>] wait_on_page_bit+0xc7/0xd0
> [146280.252134]  [<ffffffff810b0840>] ? autoremove_wake_function+0x40/0x40
> [146280.252137]  [<ffffffff8117d9ed>] shrink_page_list+0x2fd/0xa90
> [146280.252139]  [<ffffffff8117e7ad>] shrink_inactive_list+0x1cd/0x590
> [146280.252141]  [<ffffffff8117f5b5>] shrink_lruvec+0x5f5/0x810
> [146280.252144]  [<ffffffff81086d01>] ? pwq_activate_delayed_work+0x31/0x90
> [146280.252146]  [<ffffffff8117f867>] shrink_zone+0x97/0x240
> [146280.252148]  [<ffffffff8117fd75>] do_try_to_free_pages+0x155/0x440
> [146280.252150]  [<ffffffff81180257>] try_to_free_mem_cgroup_pages+0xa7/0x130
> [146280.252154]  [<ffffffff811d2931>] try_charge+0x151/0x620
> [146280.252158]  [<ffffffff81815a05>] ? tcp_schedule_loss_probe+0x145/0x1e0
> [146280.252160]  [<ffffffff811d6f48>] mem_cgroup_try_charge+0x98/0x110
> [146280.252164]  [<ffffffff8170957e>] ? __alloc_skb+0x7e/0x2b0
> [146280.252166]  [<ffffffff8116accf>] __add_to_page_cache_locked+0x7f/0x290
> [146280.252169]  [<ffffffff8116af28>] add_to_page_cache_lru+0x28/0x80
> [146280.252171]  [<ffffffff8116b00f>] pagecache_get_page+0x8f/0x1c0
> [146280.252173]  [<ffffffff81952570>] ? _raw_spin_unlock_bh+0x20/0x40
> [146280.252189]  [<ffffffffa0045935>] prepare_pages.isra.19+0xc5/0x180 [btrfs]
> [146280.252199]  [<ffffffffa00464ec>] __btrfs_buffered_write+0x1cc/0x590 [btrfs]
> [146280.252208]  [<ffffffffa0049c07>] btrfs_file_write_iter+0x287/0x510 [btrfs]
> [146280.252211]  [<ffffffff813f7076>] ? aa_path_perm+0xd6/0x170
> [146280.252214]  [<ffffffff811dfd91>] new_sync_write+0x81/0xb0
> [146280.252216]  [<ffffffff811e0537>] vfs_write+0xb7/0x1f0
> [146280.252217]  [<ffffffff81950636>] ? mutex_lock+0x16/0x37
> [146280.252219]  [<ffffffff811e1146>] SyS_write+0x46/0xb0
> [146280.252221]  [<ffffffff819529ed>] system_call_fastpath+0x16/0x1b
> 
> Here is a slightly different stacktrace:
> 
> [158880.240245] INFO: task kworker/u16:6:13974 blocked for more than 120 seconds.
> [158880.240249]       Tainted: G            E  3.19.0 #1
> [158880.240252] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [158880.240254] kworker/u16:6   D ffff88064e7b76c8     0 13974      2 0x00000000
> [158880.240259] Workqueue: writeback bdi_writeback_workfn (flush-btrfs-1)
> [158880.240260]  ffff88064e7b76c8 ffff88066f0c18e0 0000000000014100 ffff88064e7b7fd8
> [158880.240262]  0000000000014100 ffffffff8201e4a0 ffff88066f0c18e0 ffff88077c3e06e8
> [158880.240264]  ffff88075a214a00 ffff88077c3e06e8 ffff88064e7b7770 0000000000000002
> [158880.240266] Call Trace:
> [158880.240268]  [<ffffffff8194efa0>] ? bit_wait+0x50/0x50
> [158880.240270]  [<ffffffff8194e770>] io_schedule+0xa0/0x130
> [158880.240273]  [<ffffffff8194efcc>] bit_wait_io+0x2c/0x50
> [158880.240275]  [<ffffffff8194ed9b>] __wait_on_bit_lock+0x4b/0xb0
> [158880.240277]  [<ffffffff81169f2e>] __lock_page+0xae/0xb0
> [158880.240279]  [<ffffffff810b0840>] ? autoremove_wake_function+0x40/0x40
> [158880.240289]  [<ffffffffa00501bd>] lock_delalloc_pages+0x13d/0x1d0 [btrfs]
> [158880.240299]  [<ffffffffa005fc8a>] ? btrfs_map_block+0x1a/0x20 [btrfs]
> [158880.240308]  [<ffffffffa0050476>] ? find_delalloc_range.constprop.46+0xa6/0x160 [btrfs]
> [158880.240318]  [<ffffffffa0052cb3>] find_lock_delalloc_range+0x143/0x1f0 [btrfs]
> [158880.240326]  [<ffffffffa00534e0>] ? end_extent_writepage+0xa0/0xa0 [btrfs]
> [158880.240335]  [<ffffffffa0052de1>] writepage_delalloc.isra.32+0x81/0x160 [btrfs]
> [158880.240343]  [<ffffffffa0053fab>] __extent_writepage+0xbb/0x2a0 [btrfs]
> [158880.240350]  [<ffffffffa00544ca>] extent_write_cache_pages.isra.29.constprop.49+0x33a/0x3f0 [btrfs]
> [158880.240359]  [<ffffffffa0055f1d>] extent_writepages+0x4d/0x70 [btrfs]
> [158880.240368]  [<ffffffffa0039090>] ? btrfs_submit_direct+0x7a0/0x7a0 [btrfs]
> [158880.240371]  [<ffffffff8109c0a0>] ? default_wake_function+0x10/0x20
> [158880.240378]  [<ffffffffa00360a8>] btrfs_writepages+0x28/0x30 [btrfs]
> [158880.240380]  [<ffffffff81176d2e>] do_writepages+0x1e/0x40
> [158880.240383]  [<ffffffff81209400>] __writeback_single_inode+0x40/0x220
> [158880.240385]  [<ffffffff81209f13>] writeback_sb_inodes+0x263/0x430
> [158880.240387]  [<ffffffff8120a17f>] __writeback_inodes_wb+0x9f/0xd0
> [158880.240389]  [<ffffffff8120a3f3>] wb_writeback+0x243/0x2c0
> [158880.240392]  [<ffffffff8120c9b3>] bdi_writeback_workfn+0x113/0x440
> [158880.240394]  [<ffffffff810981bc>] ? finish_task_switch+0x6c/0x1a0
> [158880.240397]  [<ffffffff81088f3f>] process_one_work+0x14f/0x3f0
> [158880.240399]  [<ffffffff810896a1>] worker_thread+0x121/0x4e0
> [158880.240402]  [<ffffffff81089580>] ? rescuer_thread+0x3a0/0x3a0
> [158880.240404]  [<ffffffff8108ea72>] kthread+0xd2/0xf0
> [158880.240406]  [<ffffffff8108e9a0>] ? kthread_create_on_node+0x180/0x180
> [158880.240408]  [<ffffffff8195293c>] ret_from_fork+0x7c/0xb0
> [158880.240411]  [<ffffffff8108e9a0>] ? kthread_create_on_node+0x180/0x180
> 
> 
> Help!
> Thanks,
> Steven
> 
Hi, Steven,

Are you seeing any ENOMEM Btrfs-related errors in your dmesg? In your
previous thread you trigged an ENOMEM BUG_ON and you mentioned that your
containers often get OOM'ed.

I experimented with Btrfs in a memory-constrained cgroup and saw all
sorts of buggy behavior (https://lkml.org/lkml/2015/2/17/131), but I
haven't been able to reproduce this particular issue. This is a wild
guess, but there could be a buggy error handling path somewhere that
forgets to unlock a page.

-- 
Omar
