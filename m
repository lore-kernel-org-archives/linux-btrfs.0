Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cobra.newdream.net ([66.33.216.30]:35989 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab3FED7G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Jun 2013 23:59:06 -0400
Received: from cobra.newdream.net (localhost [127.0.0.1])
	by cobra.newdream.net (Postfix) with ESMTP id 1D5E98004B
	for <linux-btrfs@vger.kernel.org>; Tue,  4 Jun 2013 20:59:06 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by cobra.newdream.net (Postfix) with ESMTP id E1CAD8004B
	for <linux-btrfs@vger.kernel.org>; Tue,  4 Jun 2013 20:59:05 -0700 (PDT)
Date: Tue, 4 Jun 2013 20:59:05 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
To: linux-btrfs@vger.kernel.org
Subject: v3.9 bug at /fs/btrfs/free-space-cache.c:1567 after powercycle
Message-ID: <alpine.DEB.2.00.1306042056350.19491@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi-

I'm pretty reliably triggering the following bug after powercycling an 
active btrfs + ceph workload and then trying to remount.  Is this a known 
issue?

sage


2013-06-04T18:54:28.532988-07:00 plana71 kernel: [   39.311120] ------------[ cut here ]------------
2013-06-04T18:54:28.533002-07:00 plana71 kernel: [   39.315802] kernel BUG at /srv/autobuild-ceph/gitbuilder.git/build/fs/btrfs/free-space-cache.c:1567!
2013-06-04T18:54:28.533004-07:00 plana71 kernel: [   39.325013] invalid opcode: 0000 [#1] SMP 
2013-06-04T18:54:28.533012-07:00 plana71 kernel: [   39.329278] Modules linked in: coretemp kvm_intel kvm ghash_clmulni_intel aesni_intel ablk_helper nfsd cryptd lrw aes_x86_64 nfs_acl xts auth_rpcgss gf128mul microcode psmouse exportfs nfs dcdbas lpc_ich mfd_core i7core_edac edac_core joydev serio_raw hed lp parport fscache lockd sunrpc hid_generic usbhid hid btrfs raid6_pq ixgbe dca ptp pps_core mdio mptsas mptscsih mptbase scsi_transport_sas bnx2 xor zlib_deflate crc32c_intel libcrc32c
2013-06-04T18:54:28.533014-07:00 plana71 kernel: [   39.370984] CPU 1 
2013-06-04T18:54:28.533017-07:00 plana71 kernel: [   39.372867] Pid: 1679, comm: mount Not tainted 3.9.0-ceph-00303-g19bb6a8 #1 Dell Inc. PowerEdge R410/01V648
2013-06-04T18:54:28.533021-07:00 plana71 kernel: [   39.382928] RIP: 0010:[<ffffffffa0187917>]  [<ffffffffa0187917>] remove_from_bitmap+0x1b7/0x1c0 [btrfs]
2013-06-04T18:54:28.533023-07:00 plana71 kernel: [   39.392479] RSP: 0018:ffff880212d456e8  EFLAGS: 00010287
2013-06-04T18:54:28.533025-07:00 plana71 kernel: [   39.397853] RAX: 0000000000000000 RBX: ffff88021fea1100 RCX: 0000000000000034
2013-06-04T18:54:28.533028-07:00 plana71 kernel: [   39.405051] RDX: 0000000000048000 RSI: 0000000061b0a000 RDI: 00000000000078c0
2013-06-04T18:54:28.533030-07:00 plana71 kernel: [   39.412249] RBP: ffff880212d45738 R08: ffff8802200350f0 R09: 0000000000000740
2013-06-04T18:54:28.533032-07:00 plana71 kernel: [   39.419447] R10: ffff88020a4e65d0 R11: 0000000000000001 R12: ffff880212d45760
2013-06-04T18:54:28.533034-07:00 plana71 kernel: [   39.426644] R13: ffff88020ad97400 R14: 0000000069400000 R15: ffff880212d45758
2013-06-04T18:54:28.533036-07:00 plana71 kernel: [   39.433843] FS:  00007f035dc1a800(0000) GS:ffff880227220000(0000) knlGS:0000000000000000
2013-06-04T18:54:28.533038-07:00 plana71 kernel: [   39.442011] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
2013-06-04T18:54:28.533040-07:00 plana71 kernel: [   39.447819] CR2: 00007ff46d4524d0 CR3: 000000020a52c000 CR4: 00000000000007e0
2013-06-04T18:54:28.533042-07:00 plana71 kernel: [   39.455017] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
2013-06-04T18:54:28.533044-07:00 plana71 kernel: [   39.462215] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
2013-06-04T18:54:28.533047-07:00 plana71 kernel: [   39.469414] Process mount (pid: 1679, threadinfo ffff880212d44000, task ffff88020a4e5eb0)
2013-06-04T18:54:28.533048-07:00 plana71 kernel: [   39.477669] Stack:
2013-06-04T18:54:28.533050-07:00 plana71 kernel: [   39.479739]  0000000000000000 ffff88020ad97454 0000000061b0c000 0000000000048000
2013-06-04T18:54:28.533052-07:00 plana71 kernel: [   39.487431]  ffff880200000000 ffff88020ad97400 0000000000000000 ffff88020ad97454
2013-06-04T18:54:28.533054-07:00 plana71 kernel: [   39.495123]  ffff88022012b400 0000000061b0a000 ffff880212d45798 ffffffffa0189073
2013-06-04T18:54:28.533055-07:00 plana71 kernel: [   39.502817] Call Trace:
2013-06-04T18:54:28.533058-07:00 plana71 kernel: [   39.505339]  [<ffffffffa0189073>] btrfs_remove_free_space+0x53/0x290 [btrfs]
2013-06-04T18:54:28.533061-07:00 plana71 kernel: [   39.512465]  [<ffffffffa0135d20>] btrfs_alloc_logged_file_extent+0x1c0/0x1e0 [btrfs]
2013-06-04T18:54:28.533063-07:00 plana71 kernel: [   39.520295]  [<ffffffffa01215fa>] ? btrfs_free_path+0x2a/0x40 [btrfs]
2013-06-04T18:54:28.533065-07:00 plana71 kernel: [   39.526815]  [<ffffffffa0183aef>] replay_one_extent+0x5ef/0x650 [btrfs]
2013-06-04T18:54:28.533068-07:00 plana71 kernel: [   39.533510]  [<ffffffffa017da3a>] ? btrfs_tree_read_lock+0x5a/0x140 [btrfs]
2013-06-04T18:54:28.533070-07:00 plana71 kernel: [   39.540553]  [<ffffffffa0183e2b>] replay_one_buffer+0x2db/0x390 [btrfs]
2013-06-04T18:54:28.533075-07:00 plana71 kernel: [   39.547247]  [<ffffffffa01629f1>] ? mark_extent_buffer_accessed+0x51/0x70 [btrfs]
2013-06-04T18:54:28.533078-07:00 plana71 kernel: [   39.554821]  [<ffffffffa013f6d0>] ? verify_parent_transid+0x160/0x160 [btrfs]
2013-06-04T18:54:28.533080-07:00 plana71 kernel: [   39.562037]  [<ffffffffa017ee53>] walk_up_log_tree+0x1c3/0x250 [btrfs]
2013-06-04T18:54:28.533082-07:00 plana71 kernel: [   39.568644]  [<ffffffffa017fce1>] walk_log_tree+0xb1/0x1f0 [btrfs]
2013-06-04T18:54:28.533085-07:00 plana71 kernel: [   39.574903]  [<ffffffffa0186032>] btrfs_recover_log_trees+0x212/0x3c0 [btrfs]
2013-06-04T18:54:28.533087-07:00 plana71 kernel: [   39.582119]  [<ffffffffa0183b50>] ? replay_one_extent+0x650/0x650 [btrfs]
2013-06-04T18:54:28.533089-07:00 plana71 kernel: [   39.588985]  [<ffffffffa014649d>] open_ctree+0x195d/0x1f60 [btrfs]
2013-06-04T18:54:28.533092-07:00 plana71 kernel: [   39.595238]  [<ffffffffa011dc1b>] btrfs_mount+0x56b/0x650 [btrfs]
2013-06-04T18:54:28.533094-07:00 plana71 kernel: [   39.601397]  [<ffffffff8166f60e>] ? mutex_unlock+0xe/0x10
2013-06-04T18:54:28.533096-07:00 plana71 kernel: [   39.606863]  [<ffffffff8118a703>] mount_fs+0x43/0x1b0
2013-06-04T18:54:28.533098-07:00 plana71 kernel: [   39.611978]  [<ffffffff811a5946>] vfs_kern_mount+0x76/0x120
2013-06-04T18:54:28.533100-07:00 plana71 kernel: [   39.617613]  [<ffffffff811a7c58>] do_mount+0x208/0x9e0
2013-06-04T18:54:28.533102-07:00 plana71 kernel: [   39.622813]  [<ffffffff811a78ba>] ? copy_mount_options+0x3a/0x180
2013-06-04T18:54:28.533104-07:00 plana71 kernel: [   39.628969]  [<ffffffff811a84c0>] sys_mount+0x90/0xe0
2013-06-04T18:54:28.533107-07:00 plana71 kernel: [   39.634083]  [<ffffffff8167b559>] system_call_fastpath+0x16/0x1b
2013-06-04T18:54:28.533111-07:00 plana71 kernel: [   39.640150] Code: 0f 1f 40 00 31 c0 48 83 7b 20 00 75 e4 48 89 de 4c 89 ef 89 45 b0 e8 f9 ea ff ff 8b 45 b0 eb d1 0f 1f 40 00 b8 ea ff ff ff eb c6 <0f> 0b 0f 0b e8 fe c5 02 00 66 66 66 66 90 55 48 89 e5 41 55 49 
2013-06-04T18:54:28.533113-07:00 plana71 kernel: [   39.662652] RIP  [<ffffffffa0187917>] remove_from_bitmap+0x1b7/0x1c0 [btrfs]
2013-06-04T18:54:28.533122-07:00 plana71 kernel: [   39.669834]  RSP <ffff880212d456e8>
2013-06-04T18:54:28.533124-07:00 plana71 kernel: [   39.673450] ---[ end trace 12042d91b5e39711 ]---
