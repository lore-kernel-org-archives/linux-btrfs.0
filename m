Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f169.google.com ([209.85.128.169]:43408 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab3GOE4a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jul 2013 00:56:30 -0400
Received: by mail-ve0-f169.google.com with SMTP id m1so9733607ves.0
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Jul 2013 21:56:29 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 15 Jul 2013 00:56:29 -0400
Message-ID: <CABF9=8i1Bd6mVOR8kNZmQJa2UJLg9tiCojWHbN1HLVWhEh7_0g@mail.gmail.com>
Subject: filebench varmail + scrubber = btrfs_update_root bug
From: George Amvrosiadis <gamvrosi@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm trying to run the varmail personality in filebench, on a 50GB btrfs
filesystem. I am also starting the scrubber at the same time. I have
applied the latest patches for 3.8.13 (hoping to fix log tree issues).
Every time, after the scrubber completes, however, I get the following:

[ 2558.676360] leaf 573280256 total ptrs 1 free space 30
[ 2558.676367]     item 0 key (18446744073709551606 80 6597246976)
itemoff 55 itemsize 3940
[ 2558.676371] unable to update root key 18446744073709551610 132 5
[ 2558.676396] ------------[ cut here ]------------
[ 2558.676401] kernel BUG at fs/btrfs/root-tree.c:154!
[ 2558.676407] invalid opcode: 0000 [#1] SMP
[ 2558.676427] parent transid verify failed on 572911616 wanted 83 found 32
[ 2558.676413] Modules linked in: btrfs zlib_deflate libcrc32c psmouse
sb_edac serio_raw edac_core hpilo ioatdma hpwdt acpi_power_meter
mac_hid lp parport igb dca ptp pps_core be2iscsi iscsi_boot_sysfs
mpt2sas libiscsi scsi_transpor
t_sas scsi_transport_iscsi raid_class be2net
[ 2558.676461] CPU 5
[ 2558.676468] Pid: 13636, comm: filebench Tainted: G        W
3.8.13 #9 HP ProLiant DL160 Gen8
[ 2558.676474] RIP: 0010:[<ffffffffa01c785c>]  [<ffffffffa01c785c>]
btrfs_update_root+0x28c/0x290 [btrfs]
[ 2558.676505] RSP: 0018:ffff8800024b7db8  EFLAGS: 00010292
[ 2558.676510] RAX: 0000000000000034 RBX: ffff880004222b40 RCX: 00000000ffffffff
[ 2558.676515] RDX: 0000000000004144 RSI: 0000000000000082 RDI: 0000000000000246
[ 2558.676520] RBP: ffff8800024b7e18 R08: 0000000000000000 R09: 0000000000000000
[ 2558.676525] R10: 0000000000000736 R11: 0000000000000735 R12: 0000000000000001
[ 2558.676530] R13: ffff880038cd7000 R14: ffff880038cd4800 R15: ffff880038cd4820
[ 2558.676535] FS:  00007fffe897d700(0000) GS:ffff88003dea0000(0000)
knlGS:0000000000000000
[ 2558.676543] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2558.676549] CR2: 00007ff4c81ebbf0 CR3: 0000000017618000 CR4: 00000000000407e0
[ 2558.676554] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2558.676560] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2558.676566] Process filebench (pid: 13636, threadinfo
ffff8800024b6000, task ffff88003a9dade0)
[ 2558.676572] Stack:
[ 2558.676576]  ffff880038cd4800 ffff880038cd49d7 ffff880004f49ee0
ffff880038cd7000
[ 2558.676589]  ffff8800024b7de8 ffff88003aeb7b24 ffff8800024b7e08
ffff88003aeb7800
[ 2558.676600]  ffff880004f49ee0 ffff880038cd7000 ffff880038cd4800
ffff880038cd4820
[ 2558.676611] Call Trace:
[ 2558.676639]  [<ffffffffa020f065>] btrfs_sync_log+0x255/0x5f0 [btrfs]
[ 2558.676652]  [<ffffffff81681efe>] ? _raw_spin_lock+0xe/0x20
[ 2558.676677]  [<ffffffffa01e52f2>] btrfs_sync_file+0x202/0x230 [btrfs]
[ 2558.676688]  [<ffffffff811b642d>] do_fsync+0x5d/0x90
[ 2558.676698]  [<ffffffff8115a9c9>] ? vm_munmap+0x59/0x70
[ 2558.676705]  [<ffffffff811b6810>] sys_fsync+0x10/0x20
[ 2558.676715]  [<ffffffff8168a959>] system_call_fastpath+0x16/0x1b
[ 2558.676720] Code: ff ff 48 8b 33 48 8b 7d b8 e8 21 ef ff ff 48 8b
45 a8 48 c7 c7 88 66 24 a0 0f b6 50 08 48 8b 48 09 48 8b 30 31 c0 e8
79 ff 4a e1 <0f> 0b 66 90 66 66 66 66 90 48 8b 81 a0 00 00 00 55 41 b8
b7 01
[ 2558.676784] RIP  [<ffffffffa01c785c>] btrfs_update_root+0x28c/0x290 [btrfs]
[ 2558.676804]  RSP <ffff8800024b7db8>
[ 2558.676813] ---[ end trace 1cf4adc709e16e0a ]---
[ 2558.688010] parent transid verify failed on 572911616 wanted 83 found 32
[ 2558.688026] ------------[ cut here ]------------
[ 2558.688055] WARNING: at fs/btrfs/tree-log.c:3882
btrfs_log_inode_parent+0x41e/0x480 [btrfs]()
[ 2558.688061] Hardware name: ProLiant DL160 Gen8
[ 2558.688065] Modules linked in: btrfs zlib_deflate libcrc32c psmouse
sb_edac serio_raw edac_core hpilo ioatdma hpwdt acpi_power_meter
mac_hid lp parport igb dca ptp pps_core be2iscsi iscsi_boot_sysfs
mpt2sas libiscsi scsi_transport_sas scsi_transport_iscsi raid_class
be2net
[ 2558.688109] Pid: 13631, comm: filebench Tainted: G      D W    3.8.13 #9
[ 2558.688115] Call Trace:
[ 2558.688128]  [<ffffffff8105824f>] warn_slowpath_common+0x7f/0xc0
[ 2558.688137]  [<ffffffff810582aa>] warn_slowpath_null+0x1a/0x20
[ 2558.688161]  [<ffffffffa020fcce>] btrfs_log_inode_parent+0x41e/0x480 [btrfs]
[ 2558.688182]  [<ffffffffa020fd76>] btrfs_log_dentry_safe+0x46/0x70 [btrfs]
[ 2558.688206]  [<ffffffffa01e527c>] btrfs_sync_file+0x18c/0x230 [btrfs]
[ 2558.688214]  [<ffffffff811b642d>] do_fsync+0x5d/0x90
[ 2558.688222]  [<ffffffff8115a9c9>] ? vm_munmap+0x59/0x70
[ 2558.688230]  [<ffffffff811b6810>] sys_fsync+0x10/0x20
[ 2558.688239]  [<ffffffff8168a959>] system_call_fastpath+0x16/0x1b
[ 2558.688245] ---[ end trace 1cf4adc709e16e0b ]---

And that root key (18446744073709551610) looks very suspicious. Any ideas?

Thanks,

--
George Amvrosiadis, B.Sc., Ph.D. Student
Graduate Students' Union Representative
Computer Science, University of Toronto
