Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59403 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbaE0L0H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 May 2014 07:26:07 -0400
Date: Tue, 27 May 2014 13:26:05 +0200
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>
Subject: Re: [PATCH v3] btrfs: allocate raid type kobjects dynamically
Message-ID: <20140527112604.GJ5346@suse.cz>
Reply-To: dsterba@suse.cz
References: <5383EBE0.2000906@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5383EBE0.2000906@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A different lockdep chain, from test btrfs/014:

[  229.850151] ======================================================
[  229.850788] [ INFO: possible circular locking dependency detected ]
[  229.850788] 3.15.0-rc7-default+ #146 Tainted: G        W
[  229.850788] -------------------------------------------------------
[  229.850788] btrfs/26558 is trying to acquire lock:
[  229.850788]  (s_active#149){++++.+}, at: [<ffffffff811ee787>] kernfs_remove+0x27/0x40
[  229.850788]
[  229.850788] but task is already holding lock:
[  229.850788]  (&found->groups_sem){++++..}, at: [<ffffffffa0023abe>] btrfs_remove_block_group+0x24e/0x580 [btrfs]
[  229.850788]
[  229.850788] which lock already depends on the new lock.
[  229.850788]
[  229.850788]
[  229.850788] the existing dependency chain (in reverse order) is:
[  229.850788]
-> #1 (&found->groups_sem){++++..}:
[  229.850788]        [<ffffffff810b0662>] lock_acquire+0x92/0x120
[  229.850788]        [<ffffffff81a0bedc>] down_read+0x4c/0xa0
[  229.850788]        [<ffffffffa004babe>] raid_bytes_show+0x3e/0xd0 [btrfs]
[  229.850788]        [<ffffffff813b9ef6>] kobj_attr_show+0x16/0x20
[  229.850788]        [<ffffffff811f04e9>] sysfs_kf_seq_show+0xd9/0x230
[  229.850788]        [<ffffffff811eec56>] kernfs_seq_show+0x26/0x30
[  229.850788]        [<ffffffff8119ec8f>] seq_read+0xef/0x410
[  229.850788]        [<ffffffff811efa35>] kernfs_fop_read+0x125/0x180
[  229.850788]        [<ffffffff81179fe4>] vfs_read+0xb4/0x180
[  229.850788]        [<ffffffff8117a269>] SyS_read+0x59/0xd0
[  229.850788]        [<ffffffff81a16cd2>] system_call_fastpath+0x16/0x1b
[  229.850788]
-> #0 (s_active#149){++++.+}:
[  229.850788]        [<ffffffff810afc5c>] __lock_acquire+0x1c4c/0x1fa0
[  229.850788]        [<ffffffff810b0662>] lock_acquire+0x92/0x120
[  229.850788]        [<ffffffff811edc07>] __kernfs_remove+0x2b7/0x380
[  229.850788]        [<ffffffff811ee787>] kernfs_remove+0x27/0x40
[  229.850788]        [<ffffffff811f0b3a>] sysfs_remove_dir+0x5a/0x90
[  229.850788]        [<ffffffff813ba028>] kobject_del+0x18/0x90
[  229.850788]        [<ffffffffa0023cb2>] btrfs_remove_block_group+0x442/0x580 [btrfs]
[  229.850788]        [<ffffffffa005caf4>] btrfs_relocate_chunk+0x624/0x770 [btrfs]
[  229.850788]        [<ffffffffa005f652>] btrfs_balance+0x902/0xf50 [btrfs]
[  229.850788]        [<ffffffffa006b090>] btrfs_ioctl_balance+0x1e0/0x350 [btrfs]
[  229.850788]        [<ffffffffa006d4a9>] btrfs_ioctl+0xc39/0x1830 [btrfs]
[  229.850788]        [<ffffffff8118c381>] do_vfs_ioctl+0x91/0x560
[  229.850788]        [<ffffffff8118c8a3>] SyS_ioctl+0x53/0x80
[  229.850788]        [<ffffffff81a16cd2>] system_call_fastpath+0x16/0x1b
[  229.850788]
[  229.850788] other info that might help us debug this:
[  229.850788]
[  229.850788]  Possible unsafe locking scenario:
[  229.850788]
[  229.850788]        CPU0                    CPU1
[  229.850788]        ----                    ----
[  229.850788]   lock(&found->groups_sem);
[  229.850788]                                lock(s_active#149);
[  229.850788]                                lock(&found->groups_sem);
[  229.850788]   lock(s_active#149);
[  229.850788]
[  229.850788]  *** DEADLOCK ***
[  229.850788]
[  229.850788] 5 locks held by btrfs/26558:
[  229.850788]  #0:  (sb_writers#11){.+.+.+}, at: [<ffffffff8119a828>] mnt_want_write_file+0x28/0x60
[  229.850788]  #1:  (&fs_info->volume_mutex){+.+.+.}, at: [<ffffffffa006afe1>] btrfs_ioctl_balance+0x131/0x350 [btrfs]
[  229.850788]  #2:  (sb_internal){.+.+..}, at: [<ffffffffa0035436>] start_transaction+0x456/0x550 [btrfs]
[  229.850788]  #3:  (&fs_info->chunk_mutex){+.+...}, at: [<ffffffffa005927e>] lock_chunks+0x1e/0x20 [btrfs]
[  229.850788]  #4:  (&found->groups_sem){++++..}, at: [<ffffffffa0023abe>] btrfs_remove_block_group+0x24e/0x580 [btrfs]
[  229.850788]
[  229.850788] stack backtrace:
[  229.850788] CPU: 1 PID: 26558 Comm: btrfs Tainted: G        W     3.15.0-rc7-default+ #146
[  229.850788] Hardware name: Intel Corporation Santa Rosa platform/Matanzas, BIOS TSRSCRB1.86C.0047.B00.0610170821 10/17/06
[  229.850788]  ffffffff8281faf0 ffff8800652a1818 ffffffff81a07898 0000000000000001
[  229.850788]  ffffffff82827310 ffff8800652a1868 ffffffff810acb74 00000000001d4500
[  229.850788]  ffff8800652a18e8 0000000000000004 ffff880075e0ac78 0000000000000004
[  229.850788] Call Trace:
[  229.850788]  [<ffffffff81a07898>] dump_stack+0x51/0x71
[  229.850788]  [<ffffffff810acb74>] print_circular_bug+0x214/0x310
[  229.850788]  [<ffffffff810afc5c>] __lock_acquire+0x1c4c/0x1fa0
[  229.850788]  [<ffffffff811ee787>] ? kernfs_remove+0x27/0x40
[  229.850788]  [<ffffffff810b0662>] lock_acquire+0x92/0x120
[  229.850788]  [<ffffffff811ee787>] ? kernfs_remove+0x27/0x40
[  229.850788]  [<ffffffff81a0bb39>] ? mutex_unlock+0x9/0x10
[  229.850788]  [<ffffffff811edc07>] __kernfs_remove+0x2b7/0x380
[  229.850788]  [<ffffffff811ee787>] ? kernfs_remove+0x27/0x40
[  229.850788]  [<ffffffff811ee77f>] ? kernfs_remove+0x1f/0x40
[  229.850788]  [<ffffffff811ee787>] kernfs_remove+0x27/0x40
[  229.850788]  [<ffffffff811f0b3a>] sysfs_remove_dir+0x5a/0x90
[  229.850788]  [<ffffffff813ba028>] kobject_del+0x18/0x90
[  229.850788]  [<ffffffffa0023cb2>] btrfs_remove_block_group+0x442/0x580 [btrfs]
[  229.850788]  [<ffffffff810b112d>] ? trace_hardirqs_on_caller+0x11d/0x1e0
[  229.850788]  [<ffffffffa005caf4>] btrfs_relocate_chunk+0x624/0x770 [btrfs]
[  229.850788]  [<ffffffffa0056ac6>] ? release_extent_buffer+0x36/0xe0 [btrfs]
[  229.850788]  [<ffffffffa005706a>] ? free_extent_buffer+0x4a/0xc0 [btrfs]
[  229.850788]  [<ffffffffa0057080>] ? free_extent_buffer+0x60/0xc0 [btrfs]
[  229.850788]  [<ffffffffa005f652>] btrfs_balance+0x902/0xf50 [btrfs]
[  229.850788]  [<ffffffffa006b090>] ? btrfs_ioctl_balance+0x1e0/0x350 [btrfs]
[  229.850788]  [<ffffffff8116e3fa>] ? kmem_cache_alloc_trace+0x12a/0x180
[  229.850788]  [<ffffffffa006b090>] btrfs_ioctl_balance+0x1e0/0x350 [btrfs]
[  229.850788]  [<ffffffffa006c870>] ? update_ioctl_balance_args+0x130/0x130 [btrfs]
[  229.850788]  [<ffffffffa006d4a9>] btrfs_ioctl+0xc39/0x1830 [btrfs]
[  229.850788]  [<ffffffff8118c381>] do_vfs_ioctl+0x91/0x560
[  229.850788]  [<ffffffff81197959>] ? __fget_light+0x9/0x70
[  229.850788]  [<ffffffff811979c9>] ? __fdget+0x9/0x20
[  229.850788]  [<ffffffff8118c8a3>] SyS_ioctl+0x53/0x80
[  229.850788]  [<ffffffff81a16cd2>] system_call_fastpath+0x16/0x1b

