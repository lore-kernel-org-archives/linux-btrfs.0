Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:33961 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754302AbcHVWvl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Aug 2016 18:51:41 -0400
Received: by mail-oi0-f45.google.com with SMTP id l203so173137644oib.1
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Aug 2016 15:51:41 -0700 (PDT)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 22 Aug 2016 16:51:40 -0600
Message-ID: <CAJCQCtQZajfwrb-JGjLVzLk2eCvqDA_tqLbBSn81bHvT8XFFVw@mail.gmail.com>
Subject: possible recursive locking detected, 4.8.0-0.rc3.git0.1.fc25.x86_64+debug
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Trivially reproducible every boot, shortly after mount happens. Also
happened with rc2.



[   13.225891] virbr0: port 1(virbr0-nic) entered blocking state
[   13.225895] virbr0: port 1(virbr0-nic) entered listening state
[   13.299806] virbr0: port 1(virbr0-nic) entered disabled state

[   13.309179] =============================================
[   13.309181] [ INFO: possible recursive locking detected ]
[   13.309182] 4.8.0-0.rc3.git0.1.fc25.x86_64+debug #1 Not tainted
[   13.309183] ---------------------------------------------
[   13.309185] libvirt_leasesh/1174 is trying to acquire lock:
[   13.309186]  (&ei->log_mutex){+.+...}, at: [<ffffffffc0737e12>]
btrfs_log_inode+0x162/0x10f0 [btrfs]
[   13.309212]
               but task is already holding lock:
[   13.309213]  (&ei->log_mutex){+.+...}, at: [<ffffffffc0737e12>]
btrfs_log_inode+0x162/0x10f0 [btrfs]
[   13.309229]
               other info that might help us debug this:
[   13.309230]  Possible unsafe locking scenario:

[   13.309231]        CPU0
[   13.309232]        ----
[   13.309233]   lock(&ei->log_mutex);
[   13.309235]   lock(&ei->log_mutex);
[   13.309237]
                *** DEADLOCK ***

[   13.309238]  May be due to missing lock nesting notation

[   13.309240] 6 locks held by libvirt_leasesh/1174:
[   13.309241]  #0:  (sb_writers#8){.+.+.+}, at: [<ffffffff9f2a5944>]
__sb_start_write+0xb4/0xf0
[   13.309247]  #1:  (&type->i_mutex_dir_key#3/1){+.+.+.}, at:
[<ffffffff9f2ae2ba>] lock_rename+0xda/0x100
[   13.309252]  #2:  (&sb->s_type->i_mutex_key#14){+.+.+.}, at:
[<ffffffff9f2c2a2e>] lock_two_nondirectories+0x3e/0x70
[   13.309258]  #3:  (&sb->s_type->i_mutex_key#14/4){+.+...}, at:
[<ffffffff9f2c2a56>] lock_two_nondirectories+0x66/0x70
[   13.309263]  #4:  (sb_internal){.+.+.+}, at: [<ffffffff9f2a5908>]
__sb_start_write+0x78/0xf0
[   13.309266]  #5:  (&ei->log_mutex){+.+...}, at:
[<ffffffffc0737e12>] btrfs_log_inode+0x162/0x10f0 [btrfs]
[   13.309282]
               stack backtrace:
[   13.309284] CPU: 2 PID: 1174 Comm: libvirt_leasesh Not tainted
4.8.0-0.rc3.git0.1.fc25.x86_64+debug #1
[   13.309285] Hardware name: Apple Inc.
MacBookPro8,2/Mac-94245A3940C91C80, BIOS
MBP81.88Z.0047.B2C.1510261540 10/26/15
[   13.309287]  0000000000000086 0000000003b4acd5 ffff891b0a1d77a0
ffffffff9f466723
[   13.309290]  ffffffffa0b07910 ffff891adcf44000 ffff891b0a1d7868
ffffffff9f10f01e
[   13.309294]  00000000dcf44a78 ffffffff00000006 00000000b967c054
ffffffffa0408900
[   13.309297] Call Trace:
[   13.309301]  [<ffffffff9f466723>] dump_stack+0x86/0xc3
[   13.309303]  [<ffffffff9f10f01e>] __lock_acquire+0x78e/0x1290
[   13.309306]  [<ffffffff9f037f29>] ? sched_clock+0x9/0x10
[   13.309309]  [<ffffffff9f0ea5c7>] ? sched_clock_cpu+0xa7/0xc0
[   13.309312]  [<ffffffff9f8f561e>] ? mutex_unlock+0xe/0x10
[   13.309314]  [<ffffffff9f10ff86>] lock_acquire+0xf6/0x1f0
[   13.309326]  [<ffffffffc0737e12>] ? btrfs_log_inode+0x162/0x10f0 [btrfs]
[   13.309328]  [<ffffffff9f8f49a6>] mutex_lock_nested+0x86/0x3f0
[   13.309340]  [<ffffffffc0737e12>] ? btrfs_log_inode+0x162/0x10f0 [btrfs]
[   13.309341]  [<ffffffff9f8f561e>] ? mutex_unlock+0xe/0x10
[   13.309353]  [<ffffffffc0737e12>] ? btrfs_log_inode+0x162/0x10f0 [btrfs]
[   13.309365]  [<ffffffffc0737e12>] btrfs_log_inode+0x162/0x10f0 [btrfs]
[   13.309368]  [<ffffffff9f0deaa9>] ? __might_sleep+0x49/0x80
[   13.309380]  [<ffffffffc073893c>] btrfs_log_inode+0xc8c/0x10f0 [btrfs]
[   13.309382]  [<ffffffff9f037f29>] ? sched_clock+0x9/0x10
[   13.309394]  [<ffffffffc0739070>] btrfs_log_inode_parent+0x240/0x940 [btrfs]
[   13.309396]  [<ffffffff9f8f82e7>] ? _raw_spin_unlock+0x27/0x40
[   13.309408]  [<ffffffffc06f3dba>] ? btrfs_update_inode+0xda/0x110 [btrfs]
[   13.309420]  [<ffffffffc073acf1>] btrfs_log_new_name+0x71/0x90 [btrfs]
[   13.309432]  [<ffffffffc06fdcd0>] btrfs_rename2+0x1090/0x17a0 [btrfs]
[   13.309434]  [<ffffffff9f12dc1d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[   13.309437]  [<ffffffff9f2c2a56>] ? lock_two_nondirectories+0x66/0x70
[   13.309439]  [<ffffffff9f2afef2>] vfs_rename+0x5c2/0x970
[   13.309441]  [<ffffffff9f2ae100>] ? legitimize_path.isra.34+0x20/0x60
[   13.309443]  [<ffffffff9f2b6a77>] SyS_rename+0x3a7/0x3d0
[   13.309445]  [<ffffffff9f8f8c3c>] entry_SYSCALL_64_fastpath+0x1f/0xbd
[   13.318819] device virbr0-nic left promiscuous mode
[   13.318854] virbr0: port 1(virbr0-nic) entered disabled state

-- 
Chris Murphy
