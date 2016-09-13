Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:35119 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758038AbcIMQ23 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Sep 2016 12:28:29 -0400
Received: by mail-oi0-f43.google.com with SMTP id w11so19051510oia.2
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Sep 2016 09:28:28 -0700 (PDT)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 13 Sep 2016 10:28:27 -0600
Message-ID: <CAJCQCtTj+Tf96SUjjhwEQ2_XO2A5hBzgSG_vWtCdr835L5s3Cw@mail.gmail.com>
Subject: Re: possible recursive locking detected, 4.8.0-0.rc6.git0.1.fc25.x86_64+debug
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Still happens in rc6.



[  588.463987] =============================================
[  588.463988] [ INFO: possible recursive locking detected ]
[  588.463998] 4.8.0-0.rc6.git0.1.fc25.x86_64+debug #1 Tainted: G        W
[  588.463998] ---------------------------------------------
[  588.464000] URL Classifier/2203 is trying to acquire lock:
[  588.464001]  (&ei->log_mutex){+.+...}, at: [<ffffffffc08ba032>]
btrfs_log_inode+0x162/0x1190 [btrfs]
[  588.464024]
               but task is already holding lock:
[  588.464025]  (&ei->log_mutex){+.+...}, at: [<ffffffffc08ba032>]
btrfs_log_inode+0x162/0x1190 [btrfs]
[  588.464040]
               other info that might help us debug this:
[  588.464041]  Possible unsafe locking scenario:

[  588.464042]        CPU0
[  588.464042]        ----
[  588.464043]   lock(&ei->log_mutex);
[  588.464045]   lock(&ei->log_mutex);
[  588.464046]
                *** DEADLOCK ***

[  588.464048]  May be due to missing lock nesting notation

[  588.464049] 3 locks held by URL Classifier/2203:
[  588.464050]  #0:  (&sb->s_type->i_mutex_key#14){+.+.+.}, at:
[<ffffffffc0888a73>] btrfs_sync_file+0x163/0x4c0 [btrfs]
[  588.464064]  #1:  (sb_internal){.+.+.+}, at: [<ffffffff892a4e24>]
__sb_start_write+0xb4/0xf0
[  588.464069]  #2:  (&ei->log_mutex){+.+...}, at:
[<ffffffffc08ba032>] btrfs_log_inode+0x162/0x1190 [btrfs]
[  588.464082]
               stack backtrace:
[  588.464085] CPU: 2 PID: 2203 Comm: URL Classifier Tainted: G
W       4.8.0-0.rc6.git0.1.fc25.x86_64+debug #1
[  588.464086] Hardware name: Apple Inc.
MacBookPro8,2/Mac-94245A3940C91C80, BIOS
MBP81.88Z.0047.B2C.1510261540 10/26/15
[  588.464087]  0000000000000086 00000000b11b9806 ffff8bbba123f840
ffffffff89465753
[  588.464090]  ffffffff8ab07530 ffff8bbba1238000 ffff8bbba123f908
ffffffff8910eeae
[  588.464093]  0000000000000282 ffffffff00000003 00000000a123f870
ffffffff8a428200
[  588.464095] Call Trace:
[  588.464099]  [<ffffffff89465753>] dump_stack+0x86/0xc3
[  588.464102]  [<ffffffff8910eeae>] __lock_acquire+0x78e/0x1290
[  588.464105]  [<ffffffff89487754>] ? debug_check_no_obj_freed+0x154/0x260
[  588.464107]  [<ffffffff8910e1e6>] ? mark_held_locks+0x76/0xa0
[  588.464116]  [<ffffffffc083e986>] ? btrfs_free_path+0x26/0x30 [btrfs]
[  588.464118]  [<ffffffff8910fe16>] lock_acquire+0xf6/0x1f0
[  588.464129]  [<ffffffffc08ba032>] ? btrfs_log_inode+0x162/0x1190 [btrfs]
[  588.464132]  [<ffffffff898f1516>] mutex_lock_nested+0x86/0x3f0
[  588.464143]  [<ffffffffc08ba032>] ? btrfs_log_inode+0x162/0x1190 [btrfs]
[  588.464153]  [<ffffffffc08ba032>] ? btrfs_log_inode+0x162/0x1190 [btrfs]
[  588.464155]  [<ffffffff8926f2ca>] ? kmem_cache_alloc+0x27a/0x2d0
[  588.464163]  [<ffffffffc083e79a>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[  588.464174]  [<ffffffffc08ba032>] btrfs_log_inode+0x162/0x1190 [btrfs]
[  588.464176]  [<ffffffff890dea59>] ? __might_sleep+0x49/0x80
[  588.464187]  [<ffffffffc08babeb>] btrfs_log_inode+0xd1b/0x1190 [btrfs]
[  588.464189]  [<ffffffff89037e79>] ? sched_clock+0x9/0x10
[  588.464199]  [<ffffffffc08bb4ff>] btrfs_log_inode_parent+0x40f/0x940 [btrfs]
[  588.464202]  [<ffffffff892be589>] ? dget_parent+0x99/0x2a0
[  588.464212]  [<ffffffffc08bca12>] btrfs_log_dentry_safe+0x62/0x80 [btrfs]
[  588.464223]  [<ffffffffc0888c21>] btrfs_sync_file+0x311/0x4c0 [btrfs]
[  588.464226]  [<ffffffff892df57b>] vfs_fsync_range+0x4b/0xb0
[  588.464228]  [<ffffffff892df63d>] do_fsync+0x3d/0x70
[  588.464229]  [<ffffffff892df900>] SyS_fsync+0x10/0x20
[  588.464231]  [<ffffffff898f57bc>] entry_SYSCALL_64_fastpath+0x1f/0xbd
