Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59314 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933173AbeCNHqK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Mar 2018 03:46:10 -0400
Subject: Re: WARN when unmounting a subvolume that is being synced
To: Tycho Andersen <tycho@tycho.ws>, linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
References: <20180314031051.n6e4ymnlkz4yztic@smitten>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <783b8c49-3844-21a2-9609-67f9b4c8a5e1@suse.com>
Date: Wed, 14 Mar 2018 09:46:07 +0200
MIME-Version: 1.0
In-Reply-To: <20180314031051.n6e4ymnlkz4yztic@smitten>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 14.03.2018 05:10, Tycho Andersen wrote:
> Hi all,
> 
> I'm getting the WARN below. I think (?) what I'm doing when I get it
> is that I'm unmounting a subvolume while it's being synced (concurrent
> uses of the subvolume, at least, happy to look into it further if the
> stack trace is not so useful). Anyway, I can fairly reliably reproduce
> this on 4.16-rc4.
> 
> Thoughts?

Yeah, you've mounted the filesystem with flushoncommit. THe easiest
thing would be to remount with that option ommitted i.e the default
behavior. This is a well-known issue, unfortunately fixing it is a bit
hairy and deadlock prone against fs freeze.


> 
> Tycho
> 
> Mar 13 22:18:53 stacker kernel: [ 1136.845064] WARNING: CPU: 2 PID: 4927 at fs/fs-writeback.c:2339 __writeback_inodes_sb_nr+0x189/0x1d0
> Mar 13 22:18:53 stacker kernel: [ 1136.845068] Modules linked in: fuse
> Mar 13 22:18:53 stacker kernel: [ 1136.845087] CPU: 2 PID: 4927 Comm: btrfs Not tainted 4.16.0-rc4+ #121
> Mar 13 22:18:53 stacker kernel: [ 1136.845090] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
> Mar 13 22:18:53 stacker kernel: [ 1136.845094] RIP: 0010:__writeback_inodes_sb_nr+0x189/0x1d0
> Mar 13 22:18:53 stacker kernel: [ 1136.845096] RSP: 0018:ffff88010eaff468 EFLAGS: 00010246
> Mar 13 22:18:53 stacker kernel: [ 1136.845103] RAX: 0000000000000000 RBX: 1ffff10021d5fe8e RCX: 0000000000000000
> Mar 13 22:18:53 stacker kernel: [ 1136.845106] RDX: 1ffff1002297444e RSI: 000000000000457f RDI: ffff880114ba2270
> Mar 13 22:18:53 stacker kernel: [ 1136.845108] RBP: ffff88010e319100 R08: dffffc0000000000 R09: 0000000000000004
> Mar 13 22:18:53 stacker kernel: [ 1136.845110] R10: 1ffff1002142311e R11: 0000000000000000 R12: ffff880114ba2200
> Mar 13 22:18:53 stacker kernel: [ 1136.845113] R13: ffff88010eaff490 R14: ffff88008ed7e930 R15: ffff880112731150
> Mar 13 22:18:53 stacker kernel: [ 1136.845116] FS:  00007f1c1d71c8c0(0000) GS:ffff880115f00000(0000) knlGS:0000000000000000
> Mar 13 22:18:53 stacker kernel: [ 1136.845118] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Mar 13 22:18:53 stacker kernel: [ 1136.845121] CR2: 00007f5ebaa3f010 CR3: 00000001121b1000 CR4: 00000000000006e0
> Mar 13 22:18:53 stacker kernel: [ 1136.845125] Call Trace:
> Mar 13 22:18:53 stacker kernel: [ 1136.845139]  ? wb_wait_for_completion+0x150/0x150
> Mar 13 22:18:53 stacker kernel: [ 1136.845145]  ? get_nr_inodes+0x80/0xf0
> Mar 13 22:18:53 stacker kernel: [ 1136.845152]  ? btrfs_commit_transaction+0x58c/0x1e80
> Mar 13 22:18:53 stacker kernel: [ 1136.845165]  ? get_nr_dirty_pages+0x6b/0x80
> Mar 13 22:18:53 stacker kernel: [ 1136.845171]  btrfs_commit_transaction+0x13ea/0x1e80
> Mar 13 22:18:53 stacker kernel: [ 1136.845183]  ? btrfs_apply_pending_changes+0xb0/0xb0
> Mar 13 22:18:53 stacker kernel: [ 1136.845189]  ? _raw_spin_unlock+0x1f/0x30
> Mar 13 22:18:53 stacker kernel: [ 1136.845194]  ? block_rsv_release_bytes+0x4f8/0x9a0
> Mar 13 22:18:53 stacker kernel: [ 1136.845203]  ? __kasan_slab_free+0x14a/0x180
> Mar 13 22:18:53 stacker kernel: [ 1136.845208]  ? create_subvol+0x11d0/0x133b
> Mar 13 22:18:53 stacker kernel: [ 1136.845215]  create_subvol+0x12ac/0x133b
> Mar 13 22:18:53 stacker kernel: [ 1136.845227]  ? may_destroy_subvol+0x478/0x478
> Mar 13 22:18:53 stacker kernel: [ 1136.845242]  ? lock_pin_lock+0x2b0/0x2b0
> Mar 13 22:18:53 stacker kernel: [ 1136.845251]  ? crypto_shash_update+0xc5/0x290
> Mar 13 22:18:53 stacker kernel: [ 1136.845260]  ? __lock_acquire.isra.30+0x4e4/0x1da0
> Mar 13 22:18:53 stacker kernel: [ 1136.845267]  ? btrfs_check_dir_item_collision+0xc2/0x250
> Mar 13 22:18:53 stacker kernel: [ 1136.845272]  ? kmem_cache_free+0xa9/0x240
> Mar 13 22:18:53 stacker kernel: [ 1136.845296]  ? btrfs_mksubvol+0x7b3/0x12e0
> Mar 13 22:18:53 stacker kernel: [ 1136.845298]  btrfs_mksubvol+0x7b3/0x12e0
> Mar 13 22:18:53 stacker kernel: [ 1136.845310]  ? _btrfs_ioctl_send+0x220/0x220
> Mar 13 22:18:53 stacker kernel: [ 1136.845316]  ? __sb_start_write+0x167/0x250
> Mar 13 22:18:53 stacker kernel: [ 1136.845320]  ? mnt_want_write_file+0xe8/0x300
> Mar 13 22:18:53 stacker kernel: [ 1136.845330]  btrfs_ioctl_snap_create_transid+0x11e/0x3d0
> Mar 13 22:18:53 stacker kernel: [ 1136.845338]  ? _copy_from_user+0x93/0xd0
> Mar 13 22:18:53 stacker kernel: [ 1136.845345]  btrfs_ioctl_snap_create+0xeb/0x130
> Mar 13 22:18:53 stacker kernel: [ 1136.845351]  btrfs_ioctl+0x1c9c/0x6050
> Mar 13 22:18:53 stacker kernel: [ 1136.845357]  ? find_held_lock+0x32/0x1c0
> Mar 13 22:18:53 stacker kernel: [ 1136.845369]  ? btrfs_ioctl_get_supported_features+0x20/0x20
> Mar 13 22:18:53 stacker kernel: [ 1136.845381]  ? find_held_lock+0x32/0x1c0
> Mar 13 22:18:53 stacker kernel: [ 1136.845389]  ? __handle_mm_fault+0xc3f/0x1980
> Mar 13 22:18:53 stacker kernel: [ 1136.845394]  ? lock_downgrade+0x5e0/0x5e0
> Mar 13 22:18:53 stacker kernel: [ 1136.845399]  ? mem_cgroup_commit_charge+0xb0/0x12f0
> Mar 13 22:18:53 stacker kernel: [ 1136.845408]  ? _raw_spin_unlock+0x1f/0x30
> Mar 13 22:18:53 stacker kernel: [ 1136.845412]  ? __handle_mm_fault+0xc3f/0x1980
> Mar 13 22:18:53 stacker kernel: [ 1136.845418]  ? __pmd_alloc+0x2d0/0x2d0
> Mar 13 22:18:53 stacker kernel: [ 1136.845423]  ? find_held_lock+0x32/0x1c0
> Mar 13 22:18:53 stacker kernel: [ 1136.845430]  ? do_vfs_ioctl+0x173/0xe90
> Mar 13 22:18:53 stacker kernel: [ 1136.845433]  do_vfs_ioctl+0x173/0xe90
> Mar 13 22:18:53 stacker kernel: [ 1136.845440]  ? ioctl_preallocate+0x170/0x170
> Mar 13 22:18:53 stacker kernel: [ 1136.845444]  ? lock_downgrade+0x5e0/0x5e0
> Mar 13 22:18:53 stacker kernel: [ 1136.845448]  ? __do_page_fault+0x2c7/0xb20
> Mar 13 22:18:53 stacker kernel: [ 1136.845455]  ? handle_mm_fault+0x29a/0x740
> Mar 13 22:18:53 stacker kernel: [ 1136.845461]  ? up_read+0x17/0x30
> Mar 13 22:18:53 stacker kernel: [ 1136.845464]  ? __do_page_fault+0x492/0xb20
> Mar 13 22:18:53 stacker kernel: [ 1136.845472]  SyS_ioctl+0x6f/0x80
> Mar 13 22:18:53 stacker kernel: [ 1136.845476]  ? do_vfs_ioctl+0xe90/0xe90
> Mar 13 22:18:53 stacker kernel: [ 1136.845481]  do_syscall_64+0x185/0x440
> Mar 13 22:18:53 stacker kernel: [ 1136.845486]  ? prepare_exit_to_usermode+0x88/0x130
> Mar 13 22:18:53 stacker kernel: [ 1136.845491]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> Mar 13 22:18:53 stacker kernel: [ 1136.845495] RIP: 0033:0x7f1c1c798f47
> Mar 13 22:18:53 stacker kernel: [ 1136.845499] RSP: 002b:00007ffd3982cb18 EFLAGS: 00000206 ORIG_RAX: 0000000000000010
> Mar 13 22:18:53 stacker kernel: [ 1136.845511] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f1c1c798f47
> Mar 13 22:18:53 stacker kernel: [ 1136.845513] RDX: 00007ffd3982cb38 RSI: 000000005000940e RDI: 0000000000000003
> Mar 13 22:18:53 stacker kernel: [ 1136.845516] RBP: 0000000000000003 R08: 0000000000000000 R09: 000000000000005d
> Mar 13 22:18:53 stacker kernel: [ 1136.845518] R10: 000000000000053f R11: 0000000000000206 R12: 0000000002088051
> Mar 13 22:18:53 stacker kernel: [ 1136.845520] R13: 0000000002088070 R14: 0000000002088010 R15: 0000000002088070
> Mar 13 22:18:53 stacker kernel: [ 1136.845534] Code: fc ff df 48 c7 04 03 00 00 00 00 48 c7 44 18 08 00 00 00 00 48 c7 44 18 10 00 00 00 00 48 81 c4 c8 00 00 00 5b 5d 41 5c 41 5d c3 <0f> 0b eb af 89 4c 24 04 e8 aa cd f4 ff 8b 4c 24 04 e9 65 ff ff 
> Mar 13 22:18:53 stacker kernel: [ 1136.845649] ---[ end trace 6770743c79a58904 ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
