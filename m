Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:47469 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab3ERBZN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 May 2013 21:25:13 -0400
Date: Fri, 17 May 2013 18:25:12 -0700
From: Marc MERLIN <marc@merlins.org>
To: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: kernel 3.8.8: btrfs still crashes on boot when it can't replay a log
Message-ID: <20130518012512.GD28168@merlins.org>
References: <20130516150918.GB26762@merlins.org> <20130517154811.GA19176@merlins.org> <20130516150918.GB26762@merlins.org> <20130517165456.GH1765@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130517154811.GA19176@merlins.org> <20130517165456.GH1765@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 17, 2013 at 12:54:56PM -0400, Josef Bacik wrote:
> > If so, could you add this to the list of things to fix to make btrfs a bit
> > less scary to others? :)
> > (and of course more production ready, this repeated problem would kill any
> > server it happens on)
> 
> This has been all fixed in 3.10.  Thanks,

This is fantastic news, thanks a lot for that.

One question left: How can I tell in a problem like below whether btrfs is
having issues, or whether my hardware is hanging?
When this happened below, I didn't get any SATA errors from the kernel, but
I had to reboot to clear all those hangs (after reboot it was ok)

Thanks,
Marc

On Fri, May 17, 2013 at 08:48:11AM -0700, Marc MERLIN wrote:
> Sigh, last night my laptop hung again, I don't have a way to know why.
> 
> When I rebooted wit 3.9.2, soon after boot, I started to get this:
> INFO: task btrfs-transacti:520 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> btrfs-transacti D ffff8802139aa798     0   520      2 0x00000000
>  ffff88021435b8d8 0000000000000046 ffffffff8108b708 0000000000000296
>  ffff8802139aa380 ffff88021435bfd8 ffff88021435bfd8 0000000000013f00
>  ffff88021552e380 ffff8802139aa380 ffff88021435b8e8 ffff8801da07f120
> Call Trace:
>  [<ffffffff8108b708>] ? arch_local_irq_save+0x15/0x1b
>  [<ffffffff814f3f35>] schedule+0x5f/0x61
>  [<ffffffff8121dd64>] btrfs_tree_lock+0x78/0x234
>  [<ffffffff8105e35a>] ? add_wait_queue+0x44/0x44
>  [<ffffffff811d6191>] btrfs_lock_root_node+0x1d/0x3c
>  [<ffffffff811d9a9b>] btrfs_search_slot+0x184/0x517
>  [<ffffffff810ea7a8>] ? zone_statistics+0x77/0x7e
>  [<ffffffff811de0f9>] lookup_inline_extent_backref+0x99/0x374
>  [<ffffffff8106cd7b>] ? cpuacct_charge+0x5f/0x67
>  [<ffffffff811deeee>] insert_inline_extent_backref+0x57/0xd4
>  [<ffffffff81110c90>] ? kmem_cache_alloc+0x87/0x109
>  [<ffffffff811deffe>] __btrfs_inc_extent_ref+0x93/0x1c2
>  [<ffffffff811e38e1>] run_clustered_refs+0x705/0x7d4
>  [<ffffffff8122b200>] ? btrfs_find_ref_cluster+0xc7/0x120
>  [<ffffffff811e68ab>] btrfs_run_delayed_refs+0x234/0x3da
>  [<ffffffff81207f6f>] ? btrfs_run_ordered_operations+0x261/0x273
>  [<ffffffff811f3cb3>] btrfs_commit_transaction+0xac/0x886
>  [<ffffffff8105e35a>] ? add_wait_queue+0x44/0x44
>  [<ffffffff811edc7d>] transaction_kthread+0xe7/0x18a
>  [<ffffffff811edb96>] ? try_to_freeze+0x35/0x35
>  [<ffffffff8105daa5>] kthread+0x88/0x90
>  [<ffffffff8105da1d>] ? kthread_freezable_should_stop+0x39/0x39
>  [<ffffffff814f987c>] ret_from_fork+0x7c/0xb0
>  [<ffffffff8105da1d>] ? kthread_freezable_should_stop+0x39/0x39
> 
> INFO: task firefox-bin:8553 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> firefox-bin     D ffff8801ede4ea58     0  8553   4885 0x00000080
>  ffff8801c1e6f918 0000000000000086 ffffffff8108b708 0000000000000292
>  ffff8801ede4e640 ffff8801c1e6ffd8 ffff8801c1e6ffd8 0000000000013f00
>  ffff88021552a340 ffff8801ede4e640 ffff8801c1e6f928 ffff8801ce0299d0
> Call Trace:
>  [<ffffffff8108b708>] ? arch_local_irq_save+0x15/0x1b
>  [<ffffffff814f3f35>] schedule+0x5f/0x61
>  [<ffffffff8121ddc1>] btrfs_tree_lock+0xd5/0x234
>  [<ffffffff8105e35a>] ? add_wait_queue+0x44/0x44
>  [<ffffffff811d9ced>] btrfs_search_slot+0x3d6/0x517
>  [<ffffffff811de0f9>] lookup_inline_extent_backref+0x99/0x374
>  [<ffffffff811deeee>] insert_inline_extent_backref+0x57/0xd4
>  [<ffffffff81110c90>] ? kmem_cache_alloc+0x87/0x109
>  [<ffffffff811deffe>] __btrfs_inc_extent_ref+0x93/0x1c2
>  [<ffffffff811e38e1>] run_clustered_refs+0x705/0x7d4
>  [<ffffffff814f4b3c>] ? _raw_spin_lock_irq+0x9/0x24
>  [<ffffffff8122b200>] ? btrfs_find_ref_cluster+0xc7/0x120
>  [<ffffffff811e68ab>] btrfs_run_delayed_refs+0x234/0x3da
>  [<ffffffff81207f6f>] ? btrfs_run_ordered_operations+0x261/0x273
>  [<ffffffff811f3cb3>] btrfs_commit_transaction+0xac/0x886
>  [<ffffffff814f4bb6>] ? _raw_spin_lock+0x1b/0x1f
>  [<ffffffff8105e35a>] ? add_wait_queue+0x44/0x44
>  [<ffffffff8122428a>] ? btrfs_log_dentry_safe+0x43/0x51
>  [<ffffffff81202551>] btrfs_sync_file+0x23b/0x277
>  [<ffffffff81140286>] vfs_fsync_range+0x1e/0x20
>  [<ffffffff8114029f>] vfs_fsync+0x17/0x19
>  [<ffffffff81140317>] do_fsync+0x35/0x53
>  [<ffffffff8107fd29>] ? current_kernel_time+0x14/0x38
>  [<ffffffff811405ea>] sys_fsync+0xb/0xf
>  [<ffffffff814f992d>] system_call_fastpath+0x1a/0x1f

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
