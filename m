Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nightfall.bogus.net ([193.214.208.184]:48306 "EHLO
	nightfall.bogus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbaGAHam (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jul 2014 03:30:42 -0400
Received: from torh by nightfall.bogus.net with local (Exim 4.77)
	(envelope-from <torh@bogus.net>)
	id 1X1rpH-0007NM-VM
	for linux-btrfs@vger.kernel.org; Tue, 01 Jul 2014 08:46:00 +0200
Date: Tue, 1 Jul 2014 08:45:59 +0200
From: Tor Houghton <torh-btrfs@bogus.net>
To: linux-btrfs@vger.kernel.org
Subject: Kernel panic / Ubuntu 12.04.4
Message-ID: <20140701064559.GP30445@nightfall.bogus.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

List,

A few weeks ago I created a 1-disk RAID1 volume and migrated data from a 
decaying RAID1 md0 device. 

Last night I finally got the second device in the mail and added this to the
existing RAID1 setup and balanced the volume.

I use this setup for Time Machine backups using afpd, so I noticed this
morning that a backup had failed and decided to poke around to find out why.

Well, I probably should have looked at the logs first and not tried to delete
some old data, but as the command (rm -rf) hung, I got suspicious:

Jun 30 23:51:06 moonshade kernel: [ 1440.454721] btrfs: relocating block group 2939934474240 flags 1
Jun 30 23:51:07 moonshade kernel: [ 1440.637248] btrfs: relocating block group 2999510827008 flags 36
Jun 30 23:51:07 moonshade kernel: [ 1440.897153] btrfs: relocating block group 2997363343360 flags 36
Jun 30 23:51:07 moonshade kernel: [ 1441.147110] btrfs: relocating block group 2995215859712 flags 36
..
..
Jul  1 01:30:00 moonshade afpd[18090]: AFP3.3 Login by victoria
Jul  1 01:30:02 moonshade avahi-daemon[1252]: Invalid legacy unicast query packet.
Jul  1 01:30:05 moonshade kernel: [ 7378.747317] btrfs: found 32 extents
Jul  1 01:30:08 moonshade kernel: [ 7381.629998] btrfs: found 32 extents
Jul  1 01:30:08 moonshade kernel: [ 7382.243313] btrfs: relocating block group 2240928546816 flags 1
..
..
Jul  1 01:31:35 moonshade avahi-daemon[1252]: Invalid legacy unicast query packet.
Jul  1 01:31:45  avahi-daemon[1252]: last message repeated 2 times
Jul  1 01:31:45 moonshade kernel: [ 7478.605624] btrfs: found 61 extents
Jul  1 01:31:47 moonshade kernel: [ 7480.673719] ------------[ cut here ]------------
Jul  1 01:31:47 moonshade kernel: [ 7480.673742] kernel BUG at /build/buildd/linux-lts-quantal-3.5.0/fs/btrfs/extent-tree.c:1769!
Jul  1 01:31:47 moonshade kernel: [ 7480.673759] invalid opcode: 0000 [#1] SMP 
Jul  1 01:31:47 moonshade kernel: [ 7480.673771] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs reiserfs ext2 parport_pc ppdev nfsd des_generic md4 nfs nls_utf8 cifs lockd fscache auth_rpcgss nfs_acl sunrpc xt_LOG xt_limit nf_conntrack_ipv4 nf_defrag_ipv4 btrfs xt_state nf_conntrack zlib_deflate libcrc32c iptable_filter ip_tables x_tables lm90 nouveau ttm snd_hda_codec_idt drm_kms_helper drm snd_hda_intel snd_hda_codec gpio_ich i2c_algo_bit pcmcia snd_hwdep mxm_wmi snd_pcm video snd_timer yenta_socket lpc_ich snd wmi pcmcia_rsrc e100 soundcore psmouse pcmcia_core snd_page_alloc serio_raw dcdbas microcode mac_hid lp parport raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 multipath linear
Jul  1 01:31:47 moonshade kernel: [ 7480.673985] 
Jul  1 01:31:47 moonshade kernel: [ 7480.673992] Pid: 17884, comm: btrfs Not tainted 3.5.0-40-generic #62~precise1-Ubuntu Dell Inc.                 Dell DM051                   /0HJ054
Jul  1 01:31:47 moonshade kernel: [ 7480.674017] EIP: 0060:[<fa5fcf6c>] EFLAGS: 00210293 CPU: 0
Jul  1 01:31:47 moonshade kernel: [ 7480.674050] EIP is at insert_inline_extent_backref+0x13c/0x140 [btrfs]
Jul  1 01:31:47 moonshade kernel: [ 7480.674063] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
Jul  1 01:31:47 moonshade kernel: [ 7480.674074] ESI: 00000000 EDI: 00000001 EBP: e95a9b5c ESP: e95a9b08
Jul  1 01:31:47 moonshade kernel: [ 7480.674085]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Jul  1 01:31:47 moonshade kernel: [ 7480.674096] CR0: 8005003b CR2: b6952114 CR3: 28710000 CR4: 000007f0
Jul  1 01:31:47 moonshade kernel: [ 7480.674110] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
Jul  1 01:31:47 moonshade kernel: [ 7480.674122] DR6: ffff0ff0 DR7: 00000400
Jul  1 01:31:47 moonshade kernel: [ 7480.674130] Process btrfs (pid: 17884, ti=e95a8000 task=e94ef230 task.ti=e95a8000)
Jul  1 01:31:47 moonshade kernel: [ 7480.674143] Stack:
Jul  1 01:31:47 moonshade kernel: [ 7480.674149]  e95a9b4c b4835000 000002ba 00001000 00000000 00000000 00000000 00000102
Jul  1 01:31:47 moonshade kernel: [ 7480.674172]  00000000 00000001 00000000 00000000 00000000 00000001 f507ff50 f59cf400
Jul  1 01:31:47 moonshade kernel: [ 7480.674194]  f53ab270 00000cb5 00000000 f507ff50 f455ac00 e95a9bbc fa5fd013 b4835000
Jul  1 01:31:47 moonshade kernel: [ 7480.674216] Call Trace:
Jul  1 01:31:47 moonshade kernel: [ 7480.674237]  [<fa5fd013>] __btrfs_inc_extent_ref+0xa3/0x1d0 [btrfs]
Jul  1 01:31:47 moonshade kernel: [ 7480.674263]  [<fa5ff7f4>] run_delayed_tree_ref+0x1f4/0x220 [btrfs]
Jul  1 01:31:47 moonshade kernel: [ 7480.674288]  [<fa604704>] run_one_delayed_ref+0x134/0x150 [btrfs]
Jul  1 01:31:47 moonshade kernel: [ 7480.674313]  [<fa6047df>] run_clustered_refs+0xbf/0x2e0 [btrfs]
Jul  1 01:31:47 moonshade kernel: [ 7480.674339]  [<fa604b4c>] btrfs_run_delayed_refs+0x14c/0x2e0 [btrfs]
Jul  1 01:31:47 moonshade kernel: [ 7480.674367]  [<fa615d71>] __btrfs_end_transaction+0x71/0x2b0 [btrfs]
Jul  1 01:31:47 moonshade kernel: [ 7480.674396]  [<fa61600c>] btrfs_end_transaction_throttle+0x1c/0x20 [btrfs]
Jul  1 01:31:47 moonshade kernel: [ 7480.674427]  [<fa665cc4>] relocate_block_group+0x424/0x570 [btrfs]
Jul  1 01:31:47 moonshade kernel: [ 7480.674456]  [<fa665fa2>] btrfs_relocate_block_group+0x192/0x2e0 [btrfs]
Jul  1 01:31:47 moonshade kernel: [ 7480.674487]  [<fa641df9>] btrfs_relocate_chunk.isra.50+0x59/0x3c0 [btrfs]
Jul  1 01:31:47 moonshade kernel: [ 7480.674519]  [<fa63e5be>] ? free_extent_buffer+0x2e/0x80 [btrfs]
Jul  1 01:31:47 moonshade kernel: [ 7480.674548]  [<fa646c21>] __btrfs_balance+0x381/0x470 [btrfs]
Jul  1 01:31:47 moonshade kernel: [ 7480.674579]  [<fa647094>] btrfs_balance+0x384/0x560 [btrfs]
Jul  1 01:31:47 moonshade kernel: [ 7480.674595]  [<c1144401>] ? kmem_cache_alloc_trace+0x111/0x140
Jul  1 01:31:47 moonshade kernel: [ 7480.674624]  [<fa64e741>] btrfs_ioctl_balance+0x2d1/0x390 [btrfs]
Jul  1 01:31:47 moonshade kernel: [ 7480.674654]  [<fa650242>] btrfs_ioctl+0x6f2/0x7c0 [btrfs]
Jul  1 01:31:47 moonshade kernel: [ 7480.674683]  [<fa64fb50>] ? update_ioctl_balance_args+0x2c0/0x2c0 [btrfs]
Jul  1 01:31:47 moonshade kernel: [ 7480.674699]  [<c11646af>] do_vfs_ioctl+0x7f/0x2f0
Jul  1 01:31:47 moonshade kernel: [ 7480.674710]  [<c116498f>] sys_ioctl+0x6f/0x80
Jul  1 01:31:47 moonshade kernel: [ 7480.675038]  [<c1153d60>] ? sys_openat+0x30/0x40
Jul  1 01:31:47 moonshade kernel: [ 7480.675353]  [<c15e91df>] sysenter_do_call+0x12/0x28
Jul  1 01:31:47 moonshade kernel: [ 7480.675670] Code: 1c 89 44 24 04 8b 45 f0 89 54 24 08 8b 55 e8 89 04 24 8b 45 ec e8 f5 e4 ff ff eb 8e 8d 76 00 81 ff ff 00 00 00 0f 87 5d ff ff ff <0f> 0b 66 90 55 89 e5 57 56 53 83 ec 4c 3e 8d 74 26 00 89 45 f0 
Jul  1 01:31:47 moonshade kernel: [ 7480.676850] EIP: [<fa5fcf6c>] insert_inline_extent_backref+0x13c/0x140 [btrfs] SS:ESP 0068:e95a9b08
Jul  1 01:31:47 moonshade kernel: [ 7480.679402] ---[ end trace 0633959f47c2c769 ]---
Jul  1 01:31:47 moonshade kernel: [ 7480.712568] ------------[ cut here ]------------
Jul  1 01:31:47 moonshade kernel: [ 7480.712896] kernel BUG at /build/buildd/linux-lts-quantal-3.5.0/fs/btrfs/extent-tree.c:1769!
Jul  1 01:31:47 moonshade kernel: [ 7480.713206] invalid opcode: 0000 [#2] SMP 
Jul  1 01:31:47 moonshade kernel: [ 7480.713569] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs reiserfs ext2 parport_pc ppdev nfsd des_generic md4 nfs nls_utf8 cifs lockd fscache auth_rpcgss nfs_acl sunrpc xt_LOG xt_limit nf_conntrack_ipv4 nf_defrag_ipv4 btrfs xt_state nf_conntrack zlib_deflate libcrc32c iptable_filter ip_tables x_tables lm90 nouveau ttm snd_hda_codec_idt drm_kms_helper drm snd_hda_intel snd_hda_codec gpio_ich i2c_algo_bit pcmcia snd_hwdep mxm_wmi snd_pcm video snd_timer yenta_socket lpc_ich snd wmi pcmcia_rsrc e100 soundcore psmouse pcmcia_core snd_page_alloc serio_raw dcdbas microcode mac_hid lp parport raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 multipath linear
Jul  1 01:31:47 moonshade kernel: [ 7480.716351] 
Jul  1 01:31:47 moonshade kernel: [ 7480.716351] Pid: 13015, comm: btrfs-endio-wri Tainted: G      D      3.5.0-40-generic #62~precise1-Ubuntu Dell Inc.                 Dell DM051                   /0HJ054
Jul  1 01:31:47 moonshade kernel: [ 7480.716351] EIP: 0060:[<fa5fcf6c>] EFLAGS: 00010293 CPU: 1
Jul  1 01:31:47 moonshade kernel: [ 7480.716351] EIP is at insert_inline_extent_backref+0x13c/0x140 [btrfs]
Jul  1 01:31:47 moonshade kernel: [ 7480.716351] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
Jul  1 01:31:47 moonshade kernel: [ 7480.716351] ESI: 00000000 EDI: 00000001 EBP: f1635d34 ESP: f1635ce0
Jul  1 01:31:47 moonshade kernel: [ 7480.716351]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Jul  1 01:31:47 moonshade kernel: [ 7480.716351] CR0: 8005003b CR2: b7634150 CR3: 32dd2000 CR4: 000007f0
Jul  1 01:31:47 moonshade kernel: [ 7480.716351] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
Jul  1 01:31:47 moonshade kernel: [ 7480.716351] DR6: ffff0ff0 DR7: 00000400
Jul  1 01:31:47 moonshade kernel: [ 7480.716351] Process btrfs-endio-wri (pid: 13015, ti=f1634000 task=e237bf70 task.ti=f1634000)
Jul  1 01:31:47 moonshade kernel: [ 7480.716351] Stack:
Jul  1 01:31:47 moonshade kernel: [ 7480.716351]  f1635d24 bdc55000 000002ba 00001000 00000000 00000000 00000000 00000102
Jul  1 01:31:47 moonshade kernel: [ 7480.716351]  00000000 00000001 00000000 00000000 00000000 00000001 f506f850 f59cf400
Jul  1 01:31:47 moonshade kernel: [ 7480.716351]  f0965ba0 00000cdf 00000000 f506f850 f2e41c00 f1635d94 fa5fd013 bdc55000
Jul  1 01:31:47 moonshade kernel: [ 7480.716351] Call Trace:
Jul  1 01:31:47 moonshade kernel: [ 7480.716351]  [<fa5fd013>] __btrfs_inc_extent_ref+0xa3/0x1d0 [btrfs]
Jul  1 01:31:47 moonshade kernel: [ 7480.716351]  [<fa631a85>] ? btrfs_token_item_offset+0x55/0xd0 [btrfs]
Jul  1 01:31:47 moonshade kernel: [ 7480.716351]  [<fa5ff7f4>] run_delayed_tree_ref+0x1f4/0x220 [btrfs]
Jul  1 01:31:47 moonshade kernel: [ 7480.716351]  [<fa604704>] run_one_delayed_ref+0x134/0x150 [btrfs]
Jul  1 01:31:47 moonshade kernel: [ 7480.716351]  [<fa6047df>] run_clustered_refs+0xbf/0x2e0 [btrfs]
Jul  1 01:31:47 moonshade kernel: [ 7480.716351]  [<fa604b4c>] btrfs_run_delayed_refs+0x14c/0x2e0 [btrfs]
Jul  1 01:31:47 moonshade kernel: [ 7480.716351]  [<fa615d71>] __btrfs_end_transaction+0x71/0x2b0 [btrfs]
Jul  1 01:31:47 moonshade kernel: [ 7480.716351]  [<fa616029>] btrfs_end_transaction+0x19/0x20 [btrfs]
Jul  1 01:31:47 moonshade kernel: [ 7480.716351]  [<fa61d44d>] btrfs_finish_ordered_io+0x17d/0x450 [btrfs]
Jul  1 01:31:47 moonshade kernel: [ 7480.716351]  [<fa61d730>] finish_ordered_fn+0x10/0x20 [btrfs]
Jul  1 01:31:47 moonshade kernel: [ 7480.716351]  [<fa64a2e1>] worker_loop+0x71/0x2b0 [btrfs]
Jul  1 01:31:47 moonshade kernel: [ 7480.716351]  [<c106f557>] ? __wake_up_common+0x47/0x70
Jul  1 01:31:47 moonshade kernel: [ 7480.716351]  [<fa64a270>] ? check_pending_worker_creates.isra.1+0xd0/0xd0 [btrfs]
Jul  1 01:31:47 moonshade kernel: [ 7480.716351]  [<c1066c42>] kthread+0x72/0x80
Jul  1 01:31:47 moonshade kernel: [ 7480.716351]  [<c1066bd0>] ? flush_kthread_worker+0x90/0x90
Jul  1 01:31:47 moonshade kernel: [ 7480.716351]  [<c15e977e>] kernel_thread_helper+0x6/0x10
Jul  1 01:31:47 moonshade kernel: [ 7480.716351] Code: 1c 89 44 24 04 8b 45 f0 89 54 24 08 8b 55 e8 89 04 24 8b 45 ec e8 f5 e4 ff ff eb 8e 8d 76 00 81 ff ff 00 00 00 0f 87 5d ff ff ff <0f> 0b 66 90 55 89 e5 57 56 53 83 ec 4c 3e 8d 74 26 00 89 45 f0 
Jul  1 01:31:47 moonshade kernel: [ 7480.716351] EIP: [<fa5fcf6c>] insert_inline_extent_backref+0x13c/0x140 [btrfs] SS:ESP 0068:f1635ce0
Jul  1 01:31:47 moonshade kernel: [ 7480.737352] ---[ end trace 0633959f47c2c76a ]---
Jul  1 01:32:10 moonshade afpd[18072]: dsi_cmdreply(-1): No such file or directory
Jul  1 01:32:10 moonshade afpd[18072]: dsi_disconnect: entering disconnected state
Jul  1 01:32:10 moonshade afpd[18072]: dsi_disconnect: entering disconnected state
Jul  1 01:32:13 moonshade kernel: [ 7506.685116] ------------[ cut here ]------------
Jul  1 01:32:13 moonshade kernel: [ 7506.685448] kernel BUG at /build/buildd/linux-lts-quantal-3.5.0/fs/btrfs/extent-tree.c:1769!
Jul  1 01:32:13 moonshade kernel: [ 7506.685766] invalid opcode: 0000 [#3] SMP 
Jul  1 01:32:13 moonshade kernel: [ 7506.686162] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs reiserfs ext2 parport_pc ppdev nfsd des_generic md4 nfs nls_utf8 cifs lockd fscache auth_rpcgss nfs_acl sunrpc xt_LOG xt_limit nf_conntrack_ipv4 nf_defrag_ipv4 btrfs xt_state nf_conntrack zlib_deflate libcrc32c iptable_filter ip_tables x_tables lm90 nouveau ttm snd_hda_codec_idt drm_kms_helper drm snd_hda_intel snd_hda_codec gpio_ich i2c_algo_bit pcmcia snd_hwdep mxm_wmi snd_pcm video snd_timer yenta_socket lpc_ich snd wmi pcmcia_rsrc e100 soundcore psmouse pcmcia_core snd_page_alloc serio_raw dcdbas microcode mac_hid lp parport raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 multipath linear
Jul  1 01:32:13 moonshade kernel: [ 7506.688568] 
Jul  1 01:32:13 moonshade kernel: [ 7506.688568] Pid: 17910, comm: btrfs-endio-wri Tainted: G      D      3.5.0-40-generic #62~precise1-Ubuntu Dell Inc.                 Dell DM051                   /0HJ054
Jul  1 01:32:13 moonshade kernel: [ 7506.688568] EIP: 0060:[<fa5fcf6c>] EFLAGS: 00010293 CPU: 0
Jul  1 01:32:13 moonshade kernel: [ 7506.688568] EIP is at insert_inline_extent_backref+0x13c/0x140 [btrfs]
Jul  1 01:32:13 moonshade kernel: [ 7506.688568] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
Jul  1 01:32:13 moonshade kernel: [ 7506.688568] ESI: 00000000 EDI: 00000001 EBP: e90dbd34 ESP: e90dbce0
Jul  1 01:32:13 moonshade kernel: [ 7506.688568]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Jul  1 01:32:13 moonshade kernel: [ 7506.688568] CR0: 8005003b CR2: b7701000 CR3: 34b68000 CR4: 000007f0
Jul  1 01:32:13 moonshade kernel: [ 7506.688568] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
Jul  1 01:32:13 moonshade kernel: [ 7506.688568] DR6: ffff0ff0 DR7: 00000400
Jul  1 01:32:13 moonshade kernel: [ 7506.688568] Process btrfs-endio-wri (pid: 17910, ti=e90da000 task=f5531960 task.ti=e90da000)
Jul  1 01:32:13 moonshade kernel: [ 7506.688568] Stack:
Jul  1 01:32:13 moonshade kernel: [ 7506.688568]  e90dbd24 c6fed000 000002ba 00001000 00000000 00000000 00000000 00000102
Jul  1 01:32:13 moonshade kernel: [ 7506.688568]  00000000 00000001 00000000 00000000 00000000 00000001 f507fe70 f59cf400
Jul  1 01:32:13 moonshade kernel: [ 7506.688568]  f53ab930 00000f7f 00000000 f507fe70 f2e41c00 e90dbd94 fa5fd013 c6fed000
Jul  1 01:32:13 moonshade kernel: [ 7506.688568] Call Trace:
Jul  1 01:32:13 moonshade kernel: [ 7506.688568]  [<fa5fd013>] __btrfs_inc_extent_ref+0xa3/0x1d0 [btrfs]
Jul  1 01:32:13 moonshade kernel: [ 7506.688568]  [<fa631a85>] ? btrfs_token_item_offset+0x55/0xd0 [btrfs]
Jul  1 01:32:13 moonshade kernel: [ 7506.688568]  [<fa5ff7f4>] run_delayed_tree_ref+0x1f4/0x220 [btrfs]
Jul  1 01:32:13 moonshade kernel: [ 7506.688568]  [<fa604704>] run_one_delayed_ref+0x134/0x150 [btrfs]
Jul  1 01:32:13 moonshade kernel: [ 7506.688568]  [<fa6047df>] run_clustered_refs+0xbf/0x2e0 [btrfs]
Jul  1 01:32:13 moonshade kernel: [ 7506.688568]  [<fa604b4c>] btrfs_run_delayed_refs+0x14c/0x2e0 [btrfs]
Jul  1 01:32:13 moonshade kernel: [ 7506.688568]  [<fa615d71>] __btrfs_end_transaction+0x71/0x2b0 [btrfs]
Jul  1 01:32:13 moonshade kernel: [ 7506.688568]  [<fa616029>] btrfs_end_transaction+0x19/0x20 [btrfs]
Jul  1 01:32:13 moonshade kernel: [ 7506.688568]  [<fa61d44d>] btrfs_finish_ordered_io+0x17d/0x450 [btrfs]
Jul  1 01:32:13 moonshade kernel: [ 7506.688568]  [<fa61d730>] finish_ordered_fn+0x10/0x20 [btrfs]
Jul  1 01:32:13 moonshade kernel: [ 7506.688568]  [<fa64a2e1>] worker_loop+0x71/0x2b0 [btrfs]
Jul  1 01:32:13 moonshade kernel: [ 7506.688568]  [<c106f557>] ? __wake_up_common+0x47/0x70
Jul  1 01:32:13 moonshade kernel: [ 7506.688568]  [<fa64a270>] ? check_pending_worker_creates.isra.1+0xd0/0xd0 [btrfs]
Jul  1 01:32:13 moonshade kernel: [ 7506.688568]  [<c1066c42>] kthread+0x72/0x80
Jul  1 01:32:13 moonshade kernel: [ 7506.688568]  [<c1066bd0>] ? flush_kthread_worker+0x90/0x90
Jul  1 01:32:13 moonshade kernel: [ 7506.688568]  [<c15e977e>] kernel_thread_helper+0x6/0x10
Jul  1 01:32:13 moonshade kernel: [ 7506.688568] Code: 1c 89 44 24 04 8b 45 f0 89 54 24 08 8b 55 e8 89 04 24 8b 45 ec e8 f5 e4 ff ff eb 8e 8d 76 00 81 ff ff 00 00 00 0f 87 5d ff ff ff <0f> 0b 66 90 55 89 e5 57 56 53 83 ec 4c 3e 8d 74 26 00 89 45 f0 
Jul  1 01:32:13 moonshade kernel: [ 7506.688568] EIP: [<fa5fcf6c>] insert_inline_extent_backref+0x13c/0x140 [btrfs] SS:ESP 0068:e90dbce0
Jul  1 01:32:13 moonshade kernel: [ 7506.688896] ------------[ cut here ]------------
Jul  1 01:32:13 moonshade kernel: [ 7506.709947] ---[ end trace 0633959f47c2c76b ]---
Jul  1 01:32:13 moonshade kernel: [ 7506.688896] kernel BUG at /build/buildd/linux-lts-quantal-3.5.0/fs/btrfs/extent-tree.c:1769!
Jul  1 01:32:13 moonshade kernel: [ 7506.688896] invalid opcode: 0000 [#4] SMP 
Jul  1 01:32:13 moonshade kernel: [ 7506.688896] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs reiserfs ext2 parport_pc ppdev nfsd des_generic md4 nfs nls_utf8 cifs lockd fscache auth_rpcgss nfs_acl sunrpc xt_LOG xt_limit nf_conntrack_ipv4 nf_defrag_ipv4 btrfs xt_state nf_conntrack zlib_deflate libcrc32c iptable_filter ip_tables x_tables lm90 nouveau ttm snd_hda_codec_idt drm_kms_helper drm snd_hda_intel snd_hda_codec gpio_ich i2c_algo_bit pcmcia snd_hwdep mxm_wmi snd_pcm video snd_timer yenta_socket lpc_ich snd wmi pcmcia_rsrc e100 soundcore psmouse pcmcia_core snd_page_alloc serio_raw dcdbas microcode mac_hid lp parport raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 multipath linear
Jul  1 01:32:13 moonshade kernel: [ 7506.688896] 
Jul  1 01:32:13 moonshade kernel: [ 7506.688896] Pid: 17909, comm: btrfs-endio-wri Tainted: G      D      3.5.0-40-generic #62~precise1-Ubuntu Dell Inc.                 Dell DM051                   /0HJ054
Jul  1 01:32:13 moonshade kernel: [ 7506.688896] EIP: 0060:[<fa5fcf6c>] EFLAGS: 00010293 CPU: 1
Jul  1 01:32:13 moonshade kernel: [ 7506.688896] EIP is at insert_inline_extent_backref+0x13c/0x140 [btrfs]
Jul  1 01:32:13 moonshade kernel: [ 7506.688896] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
Jul  1 01:32:13 moonshade kernel: [ 7506.688896] ESI: 00000000 EDI: 00000001 EBP: d885dd34 ESP: d885dce0
Jul  1 01:32:13 moonshade kernel: [ 7506.688896]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Jul  1 01:32:13 moonshade kernel: [ 7506.688896] CR0: 8005003b CR2: b74ec5a0 CR3: 32e26000 CR4: 000007f0
Jul  1 01:32:13 moonshade kernel: [ 7506.688896] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
Jul  1 01:32:13 moonshade kernel: [ 7506.688896] DR6: ffff0ff0 DR7: 00000400
Jul  1 01:32:13 moonshade kernel: [ 7506.688896] Process btrfs-endio-wri (pid: 17909, ti=d885c000 task=f5532610 task.ti=d885c000)
Jul  1 01:32:13 moonshade kernel: [ 7506.688896] Stack:
Jul  1 01:32:13 moonshade kernel: [ 7506.688896]  d885dd24 d673a000 000002ba 00001000 00000000 00000000 00000000 00000102
Jul  1 01:32:13 moonshade kernel: [ 7506.688896]  00000000 00000001 00000000 00000000 00000000 00000001 f506fd20 f59cf400
Jul  1 01:32:13 moonshade kernel: [ 7506.688896]  f0965de0 00000cb5 00000000 f506fd20 f2e41c00 d885dd94 fa5fd013 d673a000
Jul  1 01:32:13 moonshade kernel: [ 7506.688896] Call Trace:
Jul  1 01:32:13 moonshade kernel: [ 7506.688896]  [<fa5fd013>] __btrfs_inc_extent_ref+0xa3/0x1d0 [btrfs]
Jul  1 01:32:13 moonshade kernel: [ 7506.688896]  [<fa631a85>] ? btrfs_token_item_offset+0x55/0xd0 [btrfs]
Jul  1 01:32:13 moonshade kernel: [ 7506.688896]  [<fa5ff7f4>] run_delayed_tree_ref+0x1f4/0x220 [btrfs]
Jul  1 01:32:13 moonshade kernel: [ 7506.688896]  [<fa604704>] run_one_delayed_ref+0x134/0x150 [btrfs]
Jul  1 01:32:13 moonshade kernel: [ 7506.688896]  [<fa6047df>] run_clustered_refs+0xbf/0x2e0 [btrfs]
Jul  1 01:32:13 moonshade kernel: [ 7506.688896]  [<fa604b4c>] btrfs_run_delayed_refs+0x14c/0x2e0 [btrfs]
Jul  1 01:32:13 moonshade kernel: [ 7506.688896]  [<fa615d71>] __btrfs_end_transaction+0x71/0x2b0 [btrfs]
Jul  1 01:32:13 moonshade kernel: [ 7506.688896]  [<fa616029>] btrfs_end_transaction+0x19/0x20 [btrfs]
Jul  1 01:32:13 moonshade kernel: [ 7506.688896]  [<fa61d44d>] btrfs_finish_ordered_io+0x17d/0x450 [btrfs]
Jul  1 01:32:13 moonshade kernel: [ 7506.688896]  [<fa61d730>] finish_ordered_fn+0x10/0x20 [btrfs]
Jul  1 01:32:13 moonshade kernel: [ 7506.688896]  [<fa64a2e1>] worker_loop+0x71/0x2b0 [btrfs]
Jul  1 01:32:13 moonshade kernel: [ 7506.688896]  [<c106f557>] ? __wake_up_common+0x47/0x70
Jul  1 01:32:13 moonshade kernel: [ 7506.688896]  [<fa64a270>] ? check_pending_worker_creates.isra.1+0xd0/0xd0 [btrfs]
Jul  1 01:32:13 moonshade kernel: [ 7506.688896]  [<c1066c42>] kthread+0x72/0x80
Jul  1 01:32:13 moonshade kernel: [ 7506.688896]  [<c1066bd0>] ? flush_kthread_worker+0x90/0x90
Jul  1 01:32:13 moonshade kernel: [ 7506.688896]  [<c15e977e>] kernel_thread_helper+0x6/0x10
Jul  1 01:32:13 moonshade kernel: [ 7506.688896] Code: 1c 89 44 24 04 8b 45 f0 89 54 24 08 8b 55 e8 89 04 24 8b 45 ec e8 f5 e4 ff ff eb 8e 8d 76 00 81 ff ff 00 00 00 0f 87 5d ff ff ff <0f> 0b 66 90 55 89 e5 57 56 53 83 ec 4c 3e 8d 74 26 00 89 45 f0 
Jul  1 01:32:13 moonshade kernel: [ 7506.688896] EIP: [<fa5fcf6c>] insert_inline_extent_backref+0x13c/0x140 [btrfs] SS:ESP 0068:d885dce0
Jul  1 01:32:13 moonshade kernel: [ 7506.735891] ---[ end trace 0633959f47c2c76c ]---
Jul  1 01:32:18 moonshade kernel: [ 7511.684741] ------------[ cut here ]------------
Jul  1 01:32:18 moonshade kernel: [ 7511.685069] kernel BUG at /build/buildd/linux-lts-quantal-3.5.0/fs/btrfs/extent-tree.c:1769!
Jul  1 01:32:18 moonshade kernel: [ 7511.685390] invalid opcode: 0000 [#5] SMP 
Jul  1 01:32:18 moonshade kernel: [ 7511.685779] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs reiserfs ext2 parport_pc ppdev nfsd des_generic md4 nfs nls_utf8 cifs lockd fscache auth_rpcgss nfs_acl sunrpc xt_LOG xt_limit nf_conntrack_ipv4 nf_defrag_ipv4 btrfs xt_state nf_conntrack zlib_deflate libcrc32c iptable_filter ip_tables x_tables lm90 nouveau ttm snd_hda_codec_idt drm_kms_helper drm snd_hda_intel snd_hda_codec gpio_ich i2c_algo_bit pcmcia snd_hwdep mxm_wmi snd_pcm video snd_timer yenta_socket lpc_ich snd wmi pcmcia_rsrc e100 soundcore psmouse pcmcia_core snd_page_alloc serio_raw dcdbas microcode mac_hid lp parport raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 multipath linear
Jul  1 01:32:18 moonshade kernel: [ 7511.688358] 
Jul  1 01:32:18 moonshade kernel: [ 7511.688358] Pid: 17908, comm: btrfs-endio-wri Tainted: G      D      3.5.0-40-generic #62~precise1-Ubuntu Dell Inc.                 Dell DM051                   /0HJ054
Jul  1 01:32:18 moonshade kernel: [ 7511.688358] EIP: 0060:[<fa5fcf6c>] EFLAGS: 00010293 CPU: 0
Jul  1 01:32:18 moonshade kernel: [ 7511.688358] EIP is at insert_inline_extent_backref+0x13c/0x140 [btrfs]
Jul  1 01:32:18 moonshade kernel: [ 7511.688358] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
Jul  1 01:32:18 moonshade kernel: [ 7511.688358] ESI: 00000000 EDI: 00000001 EBP: d8857d34 ESP: d8857ce0
Jul  1 01:32:18 moonshade kernel: [ 7511.688358]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Jul  1 01:32:18 moonshade kernel: [ 7511.688358] CR0: 8005003b CR2: b7701000 CR3: 32e26000 CR4: 000007f0
Jul  1 01:32:18 moonshade kernel: [ 7511.688358] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
Jul  1 01:32:18 moonshade kernel: [ 7511.688358] DR6: ffff0ff0 DR7: 00000400
Jul  1 01:32:18 moonshade kernel: [ 7511.688358] Process btrfs-endio-wri (pid: 17908, ti=d8856000 task=ef676580 task.ti=d8856000)
Jul  1 01:32:18 moonshade kernel: [ 7511.688358] Stack:
Jul  1 01:32:18 moonshade kernel: [ 7511.688358]  d8857d24 f5d0a000 000002ba 00001000 00000000 00000000 00000000 00000102
Jul  1 01:32:18 moonshade kernel: [ 7511.688358]  00000000 00000001 00000000 00000000 00000000 00000001 f507fb60 f59cf400
Jul  1 01:32:18 moonshade kernel: [ 7511.688358]  f53ab7e0 00000688 00000000 f507fb60 f2e41c00 d8857d94 fa5fd013 f5d0a000
Jul  1 01:32:18 moonshade kernel: [ 7511.688358] Call Trace:
Jul  1 01:32:18 moonshade kernel: [ 7511.688358]  [<fa5fd013>] __btrfs_inc_extent_ref+0xa3/0x1d0 [btrfs]
Jul  1 01:32:18 moonshade kernel: [ 7511.688358]  [<fa631a85>] ? btrfs_token_item_offset+0x55/0xd0 [btrfs]
Jul  1 01:32:18 moonshade kernel: [ 7511.688358]  [<fa5ff7f4>] run_delayed_tree_ref+0x1f4/0x220 [btrfs]
Jul  1 01:32:18 moonshade kernel: [ 7511.688358]  [<fa604704>] run_one_delayed_ref+0x134/0x150 [btrfs]
Jul  1 01:32:18 moonshade kernel: [ 7511.688358]  [<fa6047df>] run_clustered_refs+0xbf/0x2e0 [btrfs]
Jul  1 01:32:18 moonshade kernel: [ 7511.688358]  [<fa604b4c>] btrfs_run_delayed_refs+0x14c/0x2e0 [btrfs]
Jul  1 01:32:18 moonshade kernel: [ 7511.688358]  [<fa615d71>] __btrfs_end_transaction+0x71/0x2b0 [btrfs]
Jul  1 01:32:18 moonshade kernel: [ 7511.688358]  [<fa616029>] btrfs_end_transaction+0x19/0x20 [btrfs]
Jul  1 01:32:18 moonshade kernel: [ 7511.688358]  [<fa61d44d>] btrfs_finish_ordered_io+0x17d/0x450 [btrfs]
Jul  1 01:32:18 moonshade kernel: [ 7511.688358]  [<fa61d730>] finish_ordered_fn+0x10/0x20 [btrfs]
Jul  1 01:32:18 moonshade kernel: [ 7511.688358]  [<fa64a2e1>] worker_loop+0x71/0x2b0 [btrfs]
Jul  1 01:32:18 moonshade kernel: [ 7511.688358]  [<c106f557>] ? __wake_up_common+0x47/0x70
Jul  1 01:32:18 moonshade kernel: [ 7511.688358]  [<fa64a270>] ? check_pending_worker_creates.isra.1+0xd0/0xd0 [btrfs]
Jul  1 01:32:18 moonshade kernel: [ 7511.688358]  [<c1066c42>] kthread+0x72/0x80
Jul  1 01:32:18 moonshade kernel: [ 7511.688358]  [<c1066bd0>] ? flush_kthread_worker+0x90/0x90
Jul  1 01:32:18 moonshade kernel: [ 7511.688358]  [<c15e977e>] kernel_thread_helper+0x6/0x10
Jul  1 01:32:18 moonshade kernel: [ 7511.688358] Code: 1c 89 44 24 04 8b 45 f0 89 54 24 08 8b 55 e8 89 04 24 8b 45 ec e8 f5 e4 ff ff eb 8e 8d 76 00 81 ff ff 00 00 00 0f 87 5d ff ff ff <0f> 0b 66 90 55 89 e5 57 56 53 83 ec 4c 3e 8d 74 26 00 89 45 f0 
Jul  1 01:32:18 moonshade kernel: [ 7511.688358] EIP: [<fa5fcf6c>] insert_inline_extent_backref+0x13c/0x140 [btrfs] SS:ESP 0068:d8857ce0
Jul  1 01:32:18 moonshade kernel: [ 7511.688003] ------------[ cut here ]------------
Jul  1 01:32:18 moonshade kernel: [ 7511.709496] ---[ end trace 0633959f47c2c76d ]---
Jul  1 01:32:18 moonshade kernel: [ 7511.688003] kernel BUG at /build/buildd/linux-lts-quantal-3.5.0/fs/btrfs/extent-tree.c:1769!
Jul  1 01:32:18 moonshade kernel: [ 7511.688003] invalid opcode: 0000 [#6] SMP 
Jul  1 01:32:18 moonshade kernel: [ 7511.688003] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs reiserfs ext2 parport_pc ppdev nfsd des_generic md4 nfs nls_utf8 cifs lockd fscache auth_rpcgss nfs_acl sunrpc xt_LOG xt_limit nf_conntrack_ipv4 nf_defrag_ipv4 btrfs xt_state nf_conntrack zlib_deflate libcrc32c iptable_filter ip_tables x_tables lm90 nouveau ttm snd_hda_codec_idt drm_kms_helper drm snd_hda_intel snd_hda_codec gpio_ich i2c_algo_bit pcmcia snd_hwdep mxm_wmi snd_pcm video snd_timer yenta_socket lpc_ich snd wmi pcmcia_rsrc e100 soundcore psmouse pcmcia_core snd_page_alloc serio_raw dcdbas microcode mac_hid lp parport raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 multipath linear
Jul  1 01:32:18 moonshade kernel: [ 7511.688003] 
Jul  1 01:32:18 moonshade kernel: [ 7511.688003] Pid: 18096, comm: btrfs-delalloc- Tainted: G      D      3.5.0-40-generic #62~precise1-Ubuntu Dell Inc.                 Dell DM051                   /0HJ054
Jul  1 01:32:18 moonshade kernel: [ 7511.688003] EIP: 0060:[<fa5fcf6c>] EFLAGS: 00010293 CPU: 1
Jul  1 01:32:18 moonshade kernel: [ 7511.688003] EIP is at insert_inline_extent_backref+0x13c/0x140 [btrfs]
Jul  1 01:32:18 moonshade kernel: [ 7511.688003] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
Jul  1 01:32:18 moonshade kernel: [ 7511.688003] ESI: 00000000 EDI: 00000001 EBP: cb3a5cf4 ESP: cb3a5ca0
Jul  1 01:32:18 moonshade kernel: [ 7511.688003]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Jul  1 01:32:18 moonshade kernel: [ 7511.688003] CR0: 8005003b CR2: b74ec5a0 CR3: 32e26000 CR4: 000007f0
Jul  1 01:32:18 moonshade kernel: [ 7511.688003] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
Jul  1 01:32:18 moonshade kernel: [ 7511.688003] DR6: ffff0ff0 DR7: 00000400
Jul  1 01:32:18 moonshade kernel: [ 7511.688003] Process btrfs-delalloc- (pid: 18096, ti=cb3a4000 task=ef670000 task.ti=cb3a4000)
Jul  1 01:32:18 moonshade kernel: [ 7511.688003] Stack:
Jul  1 01:32:18 moonshade kernel: [ 7511.688003]  cb3a5ce4 28d1a000 000002bb 00001000 00000000 00000000 00000000 00000102
Jul  1 01:32:18 moonshade kernel: [ 7511.688003]  00000000 00000001 00000000 00000000 00000000 00000001 f506f0e0 f59cf400
Jul  1 01:32:18 moonshade kernel: [ 7511.688003]  f0965b70 00000ea1 00000000 f506f0e0 f2e41c00 cb3a5d54 fa5fd013 28d1a000
Jul  1 01:32:18 moonshade kernel: [ 7511.688003] Call Trace:
Jul  1 01:32:18 moonshade kernel: [ 7511.688003]  [<fa5fd013>] __btrfs_inc_extent_ref+0xa3/0x1d0 [btrfs]
Jul  1 01:32:18 moonshade kernel: [ 7511.688003]  [<fa5ff7f4>] run_delayed_tree_ref+0x1f4/0x220 [btrfs]
Jul  1 01:32:18 moonshade kernel: [ 7511.688003]  [<fa604704>] run_one_delayed_ref+0x134/0x150 [btrfs]
Jul  1 01:32:18 moonshade kernel: [ 7511.688003]  [<fa6047df>] run_clustered_refs+0xbf/0x2e0 [btrfs]
Jul  1 01:32:18 moonshade kernel: [ 7511.688003]  [<fa604b4c>] btrfs_run_delayed_refs+0x14c/0x2e0 [btrfs]
Jul  1 01:32:18 moonshade kernel: [ 7511.688003]  [<fa615d71>] __btrfs_end_transaction+0x71/0x2b0 [btrfs]
Jul  1 01:32:18 moonshade kernel: [ 7511.688003]  [<fa616029>] btrfs_end_transaction+0x19/0x20 [btrfs]
Jul  1 01:32:18 moonshade kernel: [ 7511.688003]  [<fa61fcae>] compress_file_range+0x64e/0x740 [btrfs]
Jul  1 01:32:18 moonshade kernel: [ 7511.688003]  [<fa61fdf1>] async_cow_start+0x51/0x80 [btrfs]
Jul  1 01:32:18 moonshade kernel: [ 7511.688003]  [<fa64a2e1>] worker_loop+0x71/0x2b0 [btrfs]
Jul  1 01:32:18 moonshade kernel: [ 7511.688003]  [<c106f557>] ? __wake_up_common+0x47/0x70
Jul  1 01:32:18 moonshade kernel: [ 7511.688003]  [<fa64a270>] ? check_pending_worker_creates.isra.1+0xd0/0xd0 [btrfs]
Jul  1 01:32:18 moonshade kernel: [ 7511.688003]  [<c1066c42>] kthread+0x72/0x80
Jul  1 01:32:18 moonshade kernel: [ 7511.688003]  [<c1066bd0>] ? flush_kthread_worker+0x90/0x90
Jul  1 01:32:18 moonshade kernel: [ 7511.688003]  [<c15e977e>] kernel_thread_helper+0x6/0x10
Jul  1 01:32:18 moonshade kernel: [ 7511.688003] Code: 1c 89 44 24 04 8b 45 f0 89 54 24 08 8b 55 e8 89 04 24 8b 45 ec e8 f5 e4 ff ff eb 8e 8d 76 00 81 ff ff 00 00 00 0f 87 5d ff ff ff <0f> 0b 66 90 55 89 e5 57 56 53 83 ec 4c 3e 8d 74 26 00 89 45 f0 
Jul  1 01:32:18 moonshade kernel: [ 7511.688003] EIP: [<fa5fcf6c>] insert_inline_extent_backref+0x13c/0x140 [btrfs] SS:ESP 0068:cb3a5ca0
Jul  1 01:32:18 moonshade kernel: [ 7511.734764] ---[ end trace 0633959f47c2c76e ]---
Jul  1 01:32:19 moonshade kernel: [ 7513.208142] ------------[ cut here ]------------
Jul  1 01:32:19 moonshade kernel: [ 7513.208456] kernel BUG at /build/buildd/linux-lts-quantal-3.5.0/fs/btrfs/extent-tree.c:1769!
Jul  1 01:32:19 moonshade kernel: [ 7513.208767] invalid opcode: 0000 [#7] SMP 
Jul  1 01:32:19 moonshade kernel: [ 7513.209181] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs reiserfs ext2 parport_pc ppdev nfsd des_generic md4 nfs nls_utf8 cifs lockd fscache auth_rpcgss nfs_acl sunrpc xt_LOG xt_limit nf_conntrack_ipv4 nf_defrag_ipv4 btrfs xt_state nf_conntrack zlib_deflate libcrc32c iptable_filter ip_tables x_tables lm90 nouveau ttm snd_hda_codec_idt drm_kms_helper drm snd_hda_intel snd_hda_codec gpio_ich i2c_algo_bit pcmcia snd_hwdep mxm_wmi snd_pcm video snd_timer yenta_socket lpc_ich snd wmi pcmcia_rsrc e100 soundcore psmouse pcmcia_core snd_page_alloc serio_raw dcdbas microcode mac_hid lp parport raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 multipath linear
Jul  1 01:32:19 moonshade kernel: [ 7513.212004] 
Jul  1 01:32:19 moonshade kernel: [ 7513.212004] Pid: 1035, comm: btrfs-transacti Tainted: G      D      3.5.0-40-generic #62~precise1-Ubuntu Dell Inc.                 Dell DM051                   /0HJ054
Jul  1 01:32:19 moonshade kernel: [ 7513.212004] EIP: 0060:[<fa5fcf6c>] EFLAGS: 00010293 CPU: 0
Jul  1 01:32:19 moonshade kernel: [ 7513.212004] EIP is at insert_inline_extent_backref+0x13c/0x140 [btrfs]
Jul  1 01:32:19 moonshade kernel: [ 7513.212004] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
Jul  1 01:32:19 moonshade kernel: [ 7513.212004] ESI: 00000000 EDI: 00000001 EBP: f2dddd84 ESP: f2dddd30
Jul  1 01:32:19 moonshade kernel: [ 7513.212004]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Jul  1 01:32:19 moonshade kernel: [ 7513.212004] CR0: 8005003b CR2: b7701000 CR3: 31cfd000 CR4: 000007f0
Jul  1 01:32:19 moonshade kernel: [ 7513.212004] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
Jul  1 01:32:19 moonshade kernel: [ 7513.212004] DR6: ffff0ff0 DR7: 00000400
Jul  1 01:32:19 moonshade kernel: [ 7513.212004] Process btrfs-transacti (pid: 1035, ti=f2ddc000 task=f558d8d0 task.ti=f2ddc000)
Jul  1 01:32:19 moonshade kernel: [ 7513.212004] Stack:
Jul  1 01:32:19 moonshade kernel: [ 7513.212004]  f2dddd74 34ad2000 000002bb 00001000 00000000 00000000 00000000 00000102
Jul  1 01:32:19 moonshade kernel: [ 7513.212004]  00000000 00000001 00000000 00000000 00000000 00000001 f507fcb0 f59cf400
Jul  1 01:32:19 moonshade kernel: [ 7513.212004]  f53ab480 00000fe5 00000000 f507fcb0 f455ac00 f2dddde4 fa5fd013 34ad2000
Jul  1 01:32:19 moonshade kernel: [ 7513.212004] Call Trace:
Jul  1 01:32:19 moonshade kernel: [ 7513.212004]  [<fa5fd013>] __btrfs_inc_extent_ref+0xa3/0x1d0 [btrfs]
Jul  1 01:32:19 moonshade kernel: [ 7513.212004]  [<c1079f3b>] ? sched_clock_local+0xcb/0x1c0
Jul  1 01:32:19 moonshade kernel: [ 7513.212004]  [<fa5ff7f4>] run_delayed_tree_ref+0x1f4/0x220 [btrfs]
Jul  1 01:32:19 moonshade kernel: [ 7513.212004]  [<fa604704>] run_one_delayed_ref+0x134/0x150 [btrfs]
Jul  1 01:32:19 moonshade kernel: [ 7513.212004]  [<fa6047df>] run_clustered_refs+0xbf/0x2e0 [btrfs]
Jul  1 01:32:19 moonshade kernel: [ 7513.212004]  [<fa604b4c>] btrfs_run_delayed_refs+0x14c/0x2e0 [btrfs]
Jul  1 01:32:19 moonshade kernel: [ 7513.212004]  [<fa6154ac>] btrfs_commit_transaction+0x8c/0x8b0 [btrfs]
Jul  1 01:32:19 moonshade kernel: [ 7513.212004]  [<c1075d58>] ? ttwu_do_activate.constprop.86+0x58/0x70
Jul  1 01:32:19 moonshade kernel: [ 7513.212004]  [<c10672e0>] ? add_wait_queue+0x50/0x50
Jul  1 01:32:19 moonshade kernel: [ 7513.212004]  [<fa616398>] ? start_transaction+0x38/0x50 [btrfs]
Jul  1 01:32:19 moonshade kernel: [ 7513.212004]  [<fa60fcbd>] transaction_kthread+0x1ed/0x260 [btrfs]
Jul  1 01:32:19 moonshade kernel: [ 7513.212004]  [<c1070b7e>] ? complete+0x4e/0x60
Jul  1 01:32:19 moonshade kernel: [ 7513.212004]  [<fa60fad0>] ? btrfs_destroy_delayed_refs.isra.86+0x1c0/0x1c0 [btrfs]
Jul  1 01:32:19 moonshade kernel: [ 7513.212004]  [<c1066c42>] kthread+0x72/0x80
Jul  1 01:32:19 moonshade kernel: [ 7513.212004]  [<c1066bd0>] ? flush_kthread_worker+0x90/0x90
Jul  1 01:32:19 moonshade kernel: [ 7513.212004]  [<c15e977e>] kernel_thread_helper+0x6/0x10
Jul  1 01:32:19 moonshade kernel: [ 7513.212004] Code: 1c 89 44 24 04 8b 45 f0 89 54 24 08 8b 55 e8 89 04 24 8b 45 ec e8 f5 e4 ff ff eb 8e 8d 76 00 81 ff ff 00 00 00 0f 87 5d ff ff ff <0f> 0b 66 90 55 89 e5 57 56 53 83 ec 4c 3e 8d 74 26 00 89 45 f0 
Jul  1 01:32:19 moonshade kernel: [ 7513.212004] EIP: [<fa5fcf6c>] insert_inline_extent_backref+0x13c/0x140 [btrfs] SS:ESP 0068:f2dddd30
Jul  1 01:32:19 moonshade kernel: [ 7513.232951] ---[ end trace 0633959f47c2c76f ]---
Jul  1 01:32:24 moonshade avahi-daemon[1252]: Invalid legacy unicast query packet.
Jul  1 01:33:36  avahi-daemon[1252]: last message repeated 5 times
Jul  1 01:34:26  avahi-daemon[1252]: last message repeated 3 times
Jul  1 01:34:26 moonshade afpd[18097]: AFP3.3 Login by victoria
Jul  1 01:34:26 moonshade afpd[18097]: afp_disconnect: trying primary reconnect
Jul  1 01:34:26 moonshade afpd[1576]: Reconnect: transfering session to child[18090]
Jul  1 01:34:26 moonshade afpd[1576]: Reconnect: killing new session child[18097] after transfer
Jul  1 01:34:33 moonshade afpd[18097]: afp_disconnect: primary reconnect succeeded
Jul  1 01:35:42 moonshade avahi-daemon[1252]: Invalid legacy unicast query packet.
Jul  1 01:37:07  avahi-daemon[1252]: last message repeated 5 times
Jul  1 01:37:08 moonshade afpd[18101]: AFP3.3 Login by victoria
Jul  1 01:37:08 moonshade kernel: [ 7801.863274] ------------[ cut here ]------------
Jul  1 01:37:08 moonshade kernel: [ 7801.863599] kernel BUG at /build/buildd/linux-lts-quantal-3.5.0/fs/btrfs/extent-tree.c:1769!
Jul  1 01:37:08 moonshade kernel: [ 7801.863918] invalid opcode: 0000 [#8] SMP 
Jul  1 01:37:08 moonshade kernel: [ 7801.864338] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs reiserfs ext2 parport_pc ppdev nfsd des_generic md4 nfs nls_utf8 cifs lockd fscache auth_rpcgss nfs_acl sunrpc xt_LOG xt_limit nf_conntrack_ipv4 nf_defrag_ipv4 btrfs xt_state nf_conntrack zlib_deflate libcrc32c iptable_filter ip_tables x_tables lm90 nouveau ttm snd_hda_codec_idt drm_kms_helper drm snd_hda_intel snd_hda_codec gpio_ich i2c_algo_bit pcmcia snd_hwdep mxm_wmi snd_pcm video snd_timer yenta_socket lpc_ich snd wmi pcmcia_rsrc e100 soundcore psmouse pcmcia_core snd_page_alloc serio_raw dcdbas microcode mac_hid lp parport raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 multipath linear
Jul  1 01:37:08 moonshade kernel: [ 7801.866748] 
Jul  1 01:37:08 moonshade kernel: [ 7801.866748] Pid: 18101, comm: afpd Tainted: G      D      3.5.0-40-generic #62~precise1-Ubuntu Dell Inc.                 Dell DM051                   /0HJ054
Jul  1 01:37:08 moonshade kernel: [ 7801.866748] EIP: 0060:[<fa5fcf6c>] EFLAGS: 00010293 CPU: 0
Jul  1 01:37:08 moonshade kernel: [ 7801.866748] EIP is at insert_inline_extent_backref+0x13c/0x140 [btrfs]
Jul  1 01:37:08 moonshade kernel: [ 7801.866748] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
Jul  1 01:37:08 moonshade kernel: [ 7801.866748] ESI: 00000000 EDI: 00000001 EBP: f4bd1bfc ESP: f4bd1ba8
Jul  1 01:37:08 moonshade kernel: [ 7801.866748]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Jul  1 01:37:08 moonshade kernel: [ 7801.866748] CR0: 80050033 CR2: b7510000 CR3: 20b16000 CR4: 000007f0
Jul  1 01:37:08 moonshade kernel: [ 7801.866748] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
Jul  1 01:37:08 moonshade kernel: [ 7801.866748] DR6: ffff0ff0 DR7: 00000400
Jul  1 01:37:08 moonshade kernel: [ 7801.866748] Process afpd (pid: 18101, ti=f4bd0000 task=ef6732c0 task.ti=f4bd0000)
Jul  1 01:37:08 moonshade kernel: [ 7801.866748] Stack:
Jul  1 01:37:08 moonshade kernel: [ 7801.866748]  f4bd1bec 34e28000 000002bb 00001000 00000000 00000000 00000000 00000102
Jul  1 01:37:08 moonshade kernel: [ 7801.866748]  00000000 00000001 00000000 00000000 00000000 00000001 f507f930 f59cf400
Jul  1 01:37:08 moonshade kernel: [ 7801.866748]  f53ab4e0 00000e1a 00000000 f507f930 f2e41c00 f4bd1c5c fa5fd013 34e28000
Jul  1 01:37:08 moonshade kernel: [ 7801.866748] Call Trace:
Jul  1 01:37:08 moonshade kernel: [ 7801.866748]  [<fa5fd013>] __btrfs_inc_extent_ref+0xa3/0x1d0 [btrfs]
Jul  1 01:37:08 moonshade kernel: [ 7801.866748]  [<fa5ff7f4>] run_delayed_tree_ref+0x1f4/0x220 [btrfs]
Jul  1 01:37:08 moonshade kernel: [ 7801.866748]  [<fa604704>] run_one_delayed_ref+0x134/0x150 [btrfs]
Jul  1 01:37:08 moonshade kernel: [ 7801.866748]  [<fa6047df>] run_clustered_refs+0xbf/0x2e0 [btrfs]
Jul  1 01:37:08 moonshade kernel: [ 7801.866748]  [<fa604b4c>] btrfs_run_delayed_refs+0x14c/0x2e0 [btrfs]
Jul  1 01:37:08 moonshade kernel: [ 7801.866748]  [<fa615d71>] __btrfs_end_transaction+0x71/0x2b0 [btrfs]
Jul  1 01:37:08 moonshade kernel: [ 7801.866748]  [<fa616029>] btrfs_end_transaction+0x19/0x20 [btrfs]
Jul  1 01:37:08 moonshade kernel: [ 7801.866748]  [<fa635836>] __btrfs_setxattr+0x96/0xf0 [btrfs]
Jul  1 01:37:08 moonshade kernel: [ 7801.866748]  [<fa635c22>] btrfs_setxattr+0x82/0xc0 [btrfs]
Jul  1 01:37:08 moonshade kernel: [ 7801.866748]  [<fa635ba0>] ? btrfs_getxattr+0x80/0x80 [btrfs]
Jul  1 01:37:08 moonshade kernel: [ 7801.866748]  [<c11732b7>] __vfs_setxattr_noperm+0x67/0x1b0
Jul  1 01:37:08 moonshade kernel: [ 7801.866748]  [<c1264e25>] ? security_inode_setxattr+0x55/0x70
Jul  1 01:37:08 moonshade kernel: [ 7801.866748]  [<c11734a1>] vfs_setxattr+0xa1/0xb0
Jul  1 01:37:08 moonshade kernel: [ 7801.866748]  [<c1173578>] setxattr+0xc8/0x150
Jul  1 01:37:08 moonshade kernel: [ 7801.866748]  [<c106f096>] ? lg_local_unlock+0x16/0x20
Jul  1 01:37:08 moonshade kernel: [ 7801.866748]  [<c1144227>] ? kmem_cache_alloc+0x77/0x140
Jul  1 01:37:08 moonshade kernel: [ 7801.866748]  [<c115df8a>] ? getname_flags+0x2a/0xd0
Jul  1 01:37:08 moonshade kernel: [ 7801.866748]  [<c115e07b>] ? putname+0x2b/0x40
Jul  1 01:37:08 moonshade kernel: last message repeated 2 times
Jul  1 01:37:08 moonshade kernel: [ 7801.866748]  [<c116228f>] ? user_path_at_empty+0x4f/0x80
Jul  1 01:37:08 moonshade kernel: [ 7801.866748]  [<c1298783>] ? apparmor_capable+0x23/0x80
Jul  1 01:37:08 moonshade kernel: [ 7801.866748]  [<c12648cc>] ? security_capable+0x1c/0x30
Jul  1 01:37:08 moonshade kernel: [ 7801.866748]  [<c11737c3>] sys_setxattr+0x83/0x90
Jul  1 01:37:08 moonshade kernel: [ 7801.866748]  [<c15e91df>] sysenter_do_call+0x12/0x28
Jul  1 01:37:08 moonshade kernel: [ 7801.866748] Code: 1c 89 44 24 04 8b 45 f0 89 54 24 08 8b 55 e8 89 04 24 8b 45 ec e8 f5 e4 ff ff eb 8e 8d 76 00 81 ff ff 00 00 00 0f 87 5d ff ff ff <0f> 0b 66 90 55 89 e5 57 56 53 83 ec 4c 3e 8d 74 26 00 89 45 f0 
Jul  1 01:37:08 moonshade kernel: [ 7801.866748] EIP: [<fa5fcf6c>] insert_inline_extent_backref+0x13c/0x140 [btrfs] SS:ESP 0068:f4bd1ba8
Jul  1 01:37:08 moonshade kernel: [ 7801.891976] ---[ end trace 0633959f47c2c770 ]---
Jul  1 01:37:21 moonshade avahi-daemon[1252]: Invalid legacy unicast query packet.
Jul  1 01:38:37  avahi-daemon[1252]: last message repeated 4 times
..
..
Jul  1 02:22:17 moonshade afpd[18129]: AFP3.3 Login by torh
Jul  1 02:22:42 moonshade avahi-daemon[1252]: Invalid legacy unicast query packet.
Jul  1 02:24:10  avahi-daemon[1252]: last message repeated 5 times
Jul  1 02:25:04  avahi-daemon[1252]: last message repeated 3 times
Jul  1 02:25:04 moonshade afpd[18129]: transmit: Request to dbd daemon (db_dir /local/backup/torh) timed out.
Jul  1 02:25:04 moonshade afpd[18129]: Reopen volume /local/backup/torh using in memory temporary CNID DB.
..
[ nothing untoward in the logs until 08:01:58 when i execute rm -rf ]
..
Jul  1 08:01:25 moonshade avahi-daemon[1252]: Invalid legacy unicast query packet.
Jul  1 08:01:58  avahi-daemon[1252]: last message repeated 2 times
Jul  1 08:01:58 moonshade kernel: [30892.128014] BUG: soft lockup - CPU#0 stuck for 22s! [rm:18820]
Jul  1 08:01:58 moonshade kernel: [30892.129369] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs reiserfs ext2 parport_pc ppdev nfsd des_generic md4 nfs nls_utf8 cifs lockd fscache auth_rpcgss nfs_acl sunrpc xt_LOG xt_limit nf_conntrack_ipv4 nf_defrag_ipv4 btrfs xt_state nf_conntrack zlib_deflate libcrc32c iptable_filter ip_tables x_tables lm90 nouveau ttm snd_hda_codec_idt drm_kms_helper drm snd_hda_intel snd_hda_codec gpio_ich i2c_algo_bit pcmcia snd_hwdep mxm_wmi snd_pcm video snd_timer yenta_socket lpc_ich snd wmi pcmcia_rsrc e100 soundcore psmouse pcmcia_core snd_page_alloc serio_raw dcdbas microcode mac_hid lp parport raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 multipath linear
Jul  1 08:01:58 moonshade kernel: [30892.132002] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs reiserfs ext2 parport_pc ppdev nfsd des_generic md4 nfs nls_utf8 cifs lockd fscache auth_rpcgss nfs_acl sunrpc xt_LOG xt_limit nf_conntrack_ipv4 nf_defrag_ipv4 btrfs xt_state nf_conntrack zlib_deflate libcrc32c iptable_filter ip_tables x_tables lm90 nouveau ttm snd_hda_codec_idt drm_kms_helper drm snd_hda_intel snd_hda_codec gpio_ich i2c_algo_bit pcmcia snd_hwdep mxm_wmi snd_pcm video snd_timer yenta_socket lpc_ich snd wmi pcmcia_rsrc e100 soundcore psmouse pcmcia_core snd_page_alloc serio_raw dcdbas microcode mac_hid lp parport raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 multipath linear
Jul  1 08:01:58 moonshade kernel: [30892.132002] 
Jul  1 08:01:58 moonshade kernel: [30892.132002] Pid: 18820, comm: rm Tainted: G      D      3.5.0-40-generic #62~precise1-Ubuntu Dell Inc.                 Dell DM051                   /0HJ054
Jul  1 08:01:58 moonshade kernel: [30892.132002] EIP: 0060:[<c12dae88>] EFLAGS: 00000287 CPU: 0
Jul  1 08:01:58 moonshade kernel: [30892.132002] EIP is at __write_lock_failed+0xc/0x20
Jul  1 08:01:58 moonshade kernel: [30892.132002] EAX: ee0a237c EBX: ee0a2320 ECX: 00000000 EDX: 00000000
Jul  1 08:01:58 moonshade kernel: [30892.132002] ESI: f507f2a0 EDI: 00000009 EBP: c92f9b50 ESP: c92f9b50
Jul  1 08:01:58 moonshade kernel: [30892.132002]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Jul  1 08:01:58 moonshade kernel: [30892.132002] CR0: 8005003b CR2: 09d1f094 CR3: 33cb3000 CR4: 000007f0
Jul  1 08:01:58 moonshade kernel: [30892.132002] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
Jul  1 08:01:58 moonshade kernel: [30892.132002] DR6: ffff0ff0 DR7: 00000400
Jul  1 08:01:58 moonshade kernel: [30892.132002] Process rm (pid: 18820, ti=c92f8000 task=ef62d8d0 task.ti=c92f8000)
Jul  1 08:01:58 moonshade kernel: [30892.132002] Stack:
Jul  1 08:01:58 moonshade kernel: [30892.132002]  c92f9b58 c15e1e56 c92f9b64 fa650588 00000000 c92f9bb4 fa5f6531 00000001
Jul  1 08:01:58 moonshade kernel: [30892.132002]  0000001b c92f9c27 c92f9ba4 00000002 00000002 00009b98 00000001 f53ab630
Jul  1 08:01:58 moonshade kernel: [30892.132002]  c92f9c27 00000001 f59cf400 ee0a2320 0000001b 00000002 f53ab630 00000001
Jul  1 08:01:58 moonshade kernel: [30892.132002] Call Trace:
Jul  1 08:01:58 moonshade kernel: [30892.132002]  [<c15e1e56>] _raw_write_lock+0x16/0x20
Jul  1 08:01:58 moonshade kernel: [30892.132002]  [<fa650588>] btrfs_try_tree_write_lock+0x28/0x70 [btrfs]
Jul  1 08:01:58 moonshade kernel: [30892.132002]  [<fa5f6531>] btrfs_search_slot+0x241/0x660 [btrfs]
Jul  1 08:01:58 moonshade kernel: [30892.132002]  [<fa5fc843>] lookup_inline_extent_backref+0xc3/0x560 [btrfs]
Jul  1 08:01:58 moonshade kernel: [30892.132002]  [<fa5fcd69>] lookup_extent_backref+0x89/0x150 [btrfs]
Jul  1 08:01:58 moonshade kernel: [30892.132002]  [<fa5fefb8>] __btrfs_free_extent+0xe8/0x730 [btrfs]
Jul  1 08:01:58 moonshade kernel: [30892.132002]  [<fa5ff75c>] run_delayed_tree_ref+0x15c/0x220 [btrfs]
Jul  1 08:01:58 moonshade kernel: [30892.132002]  [<fa604704>] run_one_delayed_ref+0x134/0x150 [btrfs]
Jul  1 08:01:58 moonshade kernel: [30892.132002]  [<fa6047df>] run_clustered_refs+0xbf/0x2e0 [btrfs]
Jul  1 08:01:58 moonshade kernel: [30892.132002]  [<fa604b4c>] btrfs_run_delayed_refs+0x14c/0x2e0 [btrfs]
Jul  1 08:01:58 moonshade kernel: [30892.132002]  [<fa615d71>] __btrfs_end_transaction+0x71/0x2b0 [btrfs]
Jul  1 08:01:58 moonshade kernel: [30892.132002]  [<fa616029>] btrfs_end_transaction+0x19/0x20 [btrfs]
Jul  1 08:01:58 moonshade kernel: [30892.132002]  [<fa618b20>] __unlink_end_trans+0x30/0x90 [btrfs]
Jul  1 08:01:58 moonshade kernel: [30892.132002]  [<fa61fefb>] btrfs_unlink+0x7b/0xc0 [btrfs]
Jul  1 08:01:58 moonshade kernel: [30892.132002]  [<c115f789>] vfs_unlink.part.23+0x69/0xe0
Jul  1 08:01:58 moonshade kernel: [30892.132002]  [<c115e955>] ? may_delete+0x65/0x90
Jul  1 08:01:58 moonshade kernel: [30892.132002]  [<c115f833>] vfs_unlink+0x33/0x50
Jul  1 08:01:58 moonshade kernel: [30892.132002]  [<c1161d47>] do_unlinkat+0x137/0x150
Jul  1 08:01:58 moonshade kernel: [30892.132002]  [<c118e77a>] ? dnotify_flush+0x4a/0xf0
Jul  1 08:01:58 moonshade kernel: [30892.132002]  [<c1152764>] ? filp_close+0x54/0x80
Jul  1 08:01:58 moonshade kernel: [30892.132002]  [<c116279b>] sys_unlinkat+0x2b/0x40
Jul  1 08:01:58 moonshade kernel: [30892.132002]  [<c15e91df>] sysenter_do_call+0x12/0x28
Jul  1 08:01:58 moonshade kernel: [30892.132002] Code: 00 e0 ff ff 21 e3 8b 5b 18 83 eb 07 39 d9 73 08 89 01 89 51 04 31 c0 c3 b8 f2 ff ff ff c3 90 55 89 e5 f0 81 00 00 00 10 00 f3 90 <81> 38 00 00 10 00 75 f6 f0 81 28 00 00 10 00 75 e6 5d c3 90 55 
Jul  1 08:02:26 moonshade kernel: [30920.128012] BUG: soft lockup - CPU#0 stuck for 22s! [rm:18820]
Jul  1 08:02:26 moonshade kernel: [30920.129586] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs reiserfs ext2 parport_pc ppdev nfsd des_generic md4 nfs nls_utf8 cifs lockd fscache auth_rpcgss nfs_acl sunrpc xt_LOG xt_limit nf_conntrack_ipv4 nf_defrag_ipv4 btrfs xt_state nf_conntrack zlib_deflate libcrc32c iptable_filter ip_tables x_tables lm90 nouveau ttm snd_hda_codec_idt drm_kms_helper drm snd_hda_intel snd_hda_codec gpio_ich i2c_algo_bit pcmcia snd_hwdep mxm_wmi snd_pcm video snd_timer yenta_socket lpc_ich snd wmi pcmcia_rsrc e100 soundcore psmouse pcmcia_core snd_page_alloc serio_raw dcdbas microcode mac_hid lp parport raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 multipath linear
Jul  1 08:02:26 moonshade kernel: [30920.132002] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs reiserfs ext2 parport_pc ppdev nfsd des_generic md4 nfs nls_utf8 cifs lockd fscache auth_rpcgss nfs_acl sunrpc xt_LOG xt_limit nf_conntrack_ipv4 nf_defrag_ipv4 btrfs xt_state nf_conntrack zlib_deflate libcrc32c iptable_filter ip_tables x_tables lm90 nouveau ttm snd_hda_codec_idt drm_kms_helper drm snd_hda_intel snd_hda_codec gpio_ich i2c_algo_bit pcmcia snd_hwdep mxm_wmi snd_pcm video snd_timer yenta_socket lpc_ich snd wmi pcmcia_rsrc e100 soundcore psmouse pcmcia_core snd_page_alloc serio_raw dcdbas microcode mac_hid lp parport raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 multipath linear
Jul  1 08:02:26 moonshade kernel: [30920.132002] 
Jul  1 08:02:26 moonshade kernel: [30920.132002] Pid: 18820, comm: rm Tainted: G      D      3.5.0-40-generic #62~precise1-Ubuntu Dell Inc.                 Dell DM051                   /0HJ054
Jul  1 08:02:26 moonshade kernel: [30920.132002] EIP: 0060:[<c12dae88>] EFLAGS: 00000287 CPU: 0
Jul  1 08:02:26 moonshade kernel: [30920.132002] EIP is at __write_lock_failed+0xc/0x20
Jul  1 08:02:26 moonshade kernel: [30920.132002] EAX: ee0a237c EBX: ee0a2320 ECX: 00000000 EDX: 00000000
Jul  1 08:02:26 moonshade kernel: [30920.132002] ESI: f507f2a0 EDI: 00000009 EBP: c92f9b50 ESP: c92f9b50
Jul  1 08:02:26 moonshade kernel: [30920.132002]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Jul  1 08:02:26 moonshade kernel: [30920.132002] CR0: 8005003b CR2: 09d1f094 CR3: 33cb3000 CR4: 000007f0
Jul  1 08:02:26 moonshade kernel: [30920.132002] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
Jul  1 08:02:26 moonshade kernel: [30920.132002] DR6: ffff0ff0 DR7: 00000400
Jul  1 08:02:26 moonshade kernel: [30920.132002] Process rm (pid: 18820, ti=c92f8000 task=ef62d8d0 task.ti=c92f8000)
Jul  1 08:02:26 moonshade kernel: [30920.132002] Stack:
Jul  1 08:02:26 moonshade kernel: [30920.132002]  c92f9b58 c15e1e56 c92f9b64 fa650588 00000000 c92f9bb4 fa5f6531 00000001
Jul  1 08:02:26 moonshade kernel: [30920.132002]  0000001b c92f9c27 c92f9ba4 00000002 00000002 00009b98 00000001 f53ab630
Jul  1 08:02:26 moonshade kernel: [30920.132002]  c92f9c27 00000001 f59cf400 ee0a2320 0000001b 00000002 f53ab630 00000001
Jul  1 08:02:26 moonshade kernel: [30920.132002] Call Trace:
Jul  1 08:02:26 moonshade kernel: [30920.132002]  [<c15e1e56>] _raw_write_lock+0x16/0x20
Jul  1 08:02:26 moonshade kernel: [30920.132002]  [<fa650588>] btrfs_try_tree_write_lock+0x28/0x70 [btrfs]
Jul  1 08:02:26 moonshade kernel: [30920.132002]  [<fa5f6531>] btrfs_search_slot+0x241/0x660 [btrfs]
Jul  1 08:02:26 moonshade kernel: [30920.132002]  [<fa5fc843>] lookup_inline_extent_backref+0xc3/0x560 [btrfs]
Jul  1 08:02:26 moonshade kernel: [30920.132002]  [<fa5fcd69>] lookup_extent_backref+0x89/0x150 [btrfs]
Jul  1 08:02:26 moonshade kernel: [30920.132002]  [<fa5fefb8>] __btrfs_free_extent+0xe8/0x730 [btrfs]
Jul  1 08:02:26 moonshade kernel: [30920.132002]  [<fa5ff75c>] run_delayed_tree_ref+0x15c/0x220 [btrfs]
Jul  1 08:02:26 moonshade kernel: [30920.132002]  [<fa604704>] run_one_delayed_ref+0x134/0x150 [btrfs]
Jul  1 08:02:26 moonshade kernel: [30920.132002]  [<fa6047df>] run_clustered_refs+0xbf/0x2e0 [btrfs]
Jul  1 08:02:26 moonshade kernel: [30920.132002]  [<fa604b4c>] btrfs_run_delayed_refs+0x14c/0x2e0 [btrfs]
Jul  1 08:02:26 moonshade kernel: [30920.132002]  [<fa615d71>] __btrfs_end_transaction+0x71/0x2b0 [btrfs]
Jul  1 08:02:26 moonshade kernel: [30920.132002]  [<fa616029>] btrfs_end_transaction+0x19/0x20 [btrfs]
Jul  1 08:02:26 moonshade kernel: [30920.132002]  [<fa618b20>] __unlink_end_trans+0x30/0x90 [btrfs]
Jul  1 08:02:26 moonshade kernel: [30920.132002]  [<fa61fefb>] btrfs_unlink+0x7b/0xc0 [btrfs]
Jul  1 08:02:26 moonshade kernel: [30920.132002]  [<c115f789>] vfs_unlink.part.23+0x69/0xe0
Jul  1 08:02:26 moonshade kernel: [30920.132002]  [<c115e955>] ? may_delete+0x65/0x90
Jul  1 08:02:26 moonshade kernel: [30920.132002]  [<c115f833>] vfs_unlink+0x33/0x50
Jul  1 08:02:26 moonshade kernel: [30920.132002]  [<c1161d47>] do_unlinkat+0x137/0x150
Jul  1 08:02:26 moonshade kernel: [30920.132002]  [<c118e77a>] ? dnotify_flush+0x4a/0xf0
Jul  1 08:02:26 moonshade kernel: [30920.132002]  [<c1152764>] ? filp_close+0x54/0x80
Jul  1 08:02:26 moonshade kernel: [30920.132002]  [<c116279b>] sys_unlinkat+0x2b/0x40
Jul  1 08:02:26 moonshade kernel: [30920.132002]  [<c15e91df>] sysenter_do_call+0x12/0x28
Jul  1 08:02:26 moonshade kernel: [30920.132002] Code: 00 e0 ff ff 21 e3 8b 5b 18 83 eb 07 39 d9 73 08 89 01 89 51 04 31 c0 c3 b8 f2 ff ff ff c3 90 55 89 e5 f0 81 00 00 00 10 00 f3 90 <81> 38 00 00 10 00 75 f6 f0 81 28 00 00 10 00 75 e6 5d c3 90 55 
Jul  1 08:02:32 moonshade kernel: [30926.271991] INFO: rcu_sched self-detected stall on CPU { 0}  (t=15000 jiffies)
Jul  1 08:02:32 moonshade kernel: [30926.272002] sending NMI to all CPUs:
Jul  1 08:02:32 moonshade kernel: [30926.272002] NMI backtrace for cpu 0
Jul  1 08:02:32 moonshade kernel: [30926.272002] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs reiserfs ext2 parport_pc ppdev nfsd des_generic md4 nfs nls_utf8 cifs lockd fscache auth_rpcgss nfs_acl sunrpc xt_LOG xt_limit nf_conntrack_ipv4 nf_defrag_ipv4 btrfs xt_state nf_conntrack zlib_deflate libcrc32c iptable_filter ip_tables x_tables lm90 nouveau ttm snd_hda_codec_idt drm_kms_helper drm snd_hda_intel snd_hda_codec gpio_ich i2c_algo_bit pcmcia snd_hwdep mxm_wmi snd_pcm video snd_timer yenta_socket lpc_ich snd wmi pcmcia_rsrc e100 soundcore psmouse pcmcia_core snd_page_alloc serio_raw dcdbas microcode mac_hid lp parport raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 multipath linear
Jul  1 08:02:32 moonshade kernel: [30926.272002] 
Jul  1 08:02:32 moonshade kernel: [30926.272002] Pid: 18820, comm: rm Tainted: G      D      3.5.0-40-generic #62~precise1-Ubuntu Dell Inc.                 Dell DM051                   /0HJ054
Jul  1 08:02:32 moonshade kernel: [30926.272002] EIP: 0060:[<c12d9def>] EFLAGS: 00000096 CPU: 0
Jul  1 08:02:32 moonshade kernel: [30926.272002] EIP is at delay_tsc+0x1f/0x70
Jul  1 08:02:32 moonshade kernel: [30926.272002] EAX: 1167f7a6 EBX: 00002710 ECX: c186b420 EDX: 00005f78
Jul  1 08:02:32 moonshade kernel: [30926.272002] ESI: 00000000 EDI: 003355ec EBP: c92f99bc ESP: c92f99ac
Jul  1 08:02:32 moonshade kernel: [30926.272002]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Jul  1 08:02:32 moonshade kernel: [30926.272002] CR0: 8005003b CR2: 09d1f094 CR3: 33cb3000 CR4: 000007f0
Jul  1 08:02:32 moonshade kernel: [30926.272002] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
Jul  1 08:02:32 moonshade kernel: [30926.272002] DR6: ffff0ff0 DR7: 00000400
Jul  1 08:02:32 moonshade kernel: [30926.272002] Process rm (pid: 18820, ti=c92f8000 task=ef62d8d0 task.ti=c92f8000)
Jul  1 08:02:32 moonshade kernel: [30926.272002] Stack:
Jul  1 08:02:32 moonshade kernel: [30926.272002]  00002710 00002710 c187c400 00000001 c92f99c4 c12d9d6b c92f99d4 c102f6f2
Jul  1 08:02:32 moonshade kernel: [30926.272002]  c178c6a4 c187c400 c92f99e8 c10ce662 c179e70e 00003a98 c187c400 c92f9a08
Jul  1 08:02:32 moonshade kernel: [30926.272002]  c10cff7a 00000001 f7bbcb80 00000000 00000000 00000000 ef62d8d0 c92f9a14
Jul  1 08:02:32 moonshade kernel: [30926.272002] Call Trace:
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<c12d9d6b>] __const_udelay+0x1b/0x20
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<c102f6f2>] arch_trigger_all_cpu_backtrace+0x62/0x80
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<c10ce662>] print_cpu_stall+0x72/0x100
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<c10cff7a>] __rcu_pending+0xda/0x1c0
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<c10d0081>] rcu_pending+0x21/0x50
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<c10d0752>] rcu_check_callbacks+0x92/0x130
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<c1056d2b>] update_process_times+0x3b/0x70
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<c109a87e>] tick_sched_timer+0x5e/0xc0
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<c106a760>] ? __remove_hrtimer+0x40/0xa0
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<c106addf>] __run_hrtimer+0x6f/0x1b0
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<c1093c54>] ? ktime_get_update_offsets+0x54/0x100
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<c109a820>] ? tick_nohz_handler+0x100/0x100
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<c106b985>] hrtimer_interrupt+0xf5/0x2b0
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<c15e3190>] ? nmi_handle.isra.0+0x40/0x60
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<c15e99e4>] smp_apic_timer_interrupt+0x54/0x88
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<c15e2615>] apic_timer_interrupt+0x31/0x38
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<c12dae88>] ? __write_lock_failed+0xc/0x20
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<c15e1e56>] _raw_write_lock+0x16/0x20
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<fa650588>] btrfs_try_tree_write_lock+0x28/0x70 [btrfs]
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<fa5f6531>] btrfs_search_slot+0x241/0x660 [btrfs]
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<fa5fc843>] lookup_inline_extent_backref+0xc3/0x560 [btrfs]
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<fa5fcd69>] lookup_extent_backref+0x89/0x150 [btrfs]
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<fa5fefb8>] __btrfs_free_extent+0xe8/0x730 [btrfs]
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<fa5ff75c>] run_delayed_tree_ref+0x15c/0x220 [btrfs]
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<fa604704>] run_one_delayed_ref+0x134/0x150 [btrfs]
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<fa6047df>] run_clustered_refs+0xbf/0x2e0 [btrfs]
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<fa604b4c>] btrfs_run_delayed_refs+0x14c/0x2e0 [btrfs]
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<fa615d71>] __btrfs_end_transaction+0x71/0x2b0 [btrfs]
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<fa616029>] btrfs_end_transaction+0x19/0x20 [btrfs]
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<fa618b20>] __unlink_end_trans+0x30/0x90 [btrfs]
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<fa61fefb>] btrfs_unlink+0x7b/0xc0 [btrfs]
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<c115f789>] vfs_unlink.part.23+0x69/0xe0
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<c115e955>] ? may_delete+0x65/0x90
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<c115f833>] vfs_unlink+0x33/0x50
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<c1161d47>] do_unlinkat+0x137/0x150
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<c118e77a>] ? dnotify_flush+0x4a/0xf0
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<c1152764>] ? filp_close+0x54/0x80
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<c116279b>] sys_unlinkat+0x2b/0x40
Jul  1 08:02:32 moonshade kernel: [30926.272002]  [<c15e91df>] sysenter_do_call+0x12/0x28
Jul  1 08:02:32 moonshade kernel: [30926.272002] Code: c3 8d 74 26 00 8d bc 27 00 00 00 00 55 89 e5 57 56 53 83 ec 04 3e 8d 74 26 00 89 c7 64 8b 35 28 f0 98 c1 8d 76 00 0f ae e8 0f 31 <8d> 74 26 00 89 45 f0 eb 0d f3 90 64 8b 1d 28 f0 98 c1 39 de 75 
Jul  1 08:02:32 moonshade kernel: [30926.272047] NMI backtrace for cpu 1
Jul  1 08:02:32 moonshade kernel: [30926.272047] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs reiserfs ext2 parport_pc ppdev nfsd des_generic md4 nfs nls_utf8 cifs lockd fscache auth_rpcgss nfs_acl sunrpc xt_LOG xt_limit nf_conntrack_ipv4 nf_defrag_ipv4 btrfs xt_state nf_conntrack zlib_deflate libcrc32c iptable_filter ip_tables x_tables lm90 nouveau ttm snd_hda_codec_idt drm_kms_helper drm snd_hda_intel snd_hda_codec gpio_ich i2c_algo_bit pcmcia snd_hwdep mxm_wmi snd_pcm video snd_timer yenta_socket lpc_ich snd wmi pcmcia_rsrc e100 soundcore psmouse pcmcia_core snd_page_alloc serio_raw dcdbas microcode mac_hid lp parport raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0 multipath linear
Jul  1 08:02:32 moonshade kernel: [30926.272047] 
Jul  1 08:02:32 moonshade kernel: [30926.272047] Pid: 0, comm: swapper/1 Tainted: G      D      3.5.0-40-generic #62~precise1-Ubuntu Dell Inc.                 Dell DM051                   /0HJ054
Jul  1 08:02:32 moonshade kernel: [30926.272047] EIP: 0060:[<c1018bfc>] EFLAGS: 00000246 CPU: 1
Jul  1 08:02:32 moonshade kernel: [30926.272047] EIP is at mwait_idle+0x7c/0x200
Jul  1 08:02:32 moonshade kernel: [30926.272047] EAX: 00000000 EBX: f6098000 ECX: 00000000 EDX: 00000000
Jul  1 08:02:32 moonshade kernel: [30926.272047] ESI: 00000000 EDI: 00000000 EBP: f6099f8c ESP: f6099f74
Jul  1 08:02:32 moonshade kernel: [30926.272047]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Jul  1 08:02:32 moonshade kernel: [30926.272047] CR0: 8005003b CR2: b773f000 CR3: 32e26000 CR4: 000007f0
Jul  1 08:02:32 moonshade kernel: [30926.272047] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
Jul  1 08:02:32 moonshade kernel: [30926.272047] DR6: ffff0ff0 DR7: 00000400
Jul  1 08:02:32 moonshade kernel: [30926.272047] Process swapper/1 (pid: 0, ti=f6098000 task=f607d8d0 task.ti=f6098000)
Jul  1 08:02:32 moonshade kernel: [30926.272047] Stack:
Jul  1 08:02:32 moonshade kernel: [30926.272047]  00000086 00000000 00000001 c18d1a8c 00000000 00000000 f6099fa0 c1019516
Jul  1 08:02:32 moonshade kernel: [30926.272047]  23b592fb 91bb5ae8 b8590119 f6099fb4 c15c708f 14cfba23 b8590119 01020800
Jul  1 08:02:32 moonshade kernel: [30926.272047]  00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
Jul  1 08:02:32 moonshade kernel: [30926.272047] Call Trace:
Jul  1 08:02:32 moonshade kernel: [30926.272047]  [<c1019516>] cpu_idle+0xb6/0xe0
Jul  1 08:02:32 moonshade kernel: [30926.272047]  [<c15c708f>] start_secondary+0xd5/0xda
Jul  1 08:02:32 moonshade kernel: [30926.272047] Code: ae 78 08 89 e3 31 d2 81 e3 00 e0 ff ff 89 d1 8d 43 08 0f 01 c8 0f ae f0 89 f6 8b 43 08 a8 08 0f 85 74 01 00 00 31 c0 fb 0f 01 c9 <64> 8b 0d 28 f0 98 c1 89 4d f0 3e 8d 74 26 00 64 a1 28 f0 98 c1 
Jul  1 08:02:32 moonshade kernel: [30926.411934] INFO: rcu_sched detected stalls on CPUs/tasks: { 0} (detected by 1, t=15034 jiffies)
Jul  1 08:02:32 moonshade kernel: [30926.413718] INFO: Stall ended before state dump start
Jul  1 08:02:40 moonshade kernel: [30933.858037] CIFS VFS: Server 192.168.16.2 has not responded in 120 seconds. Reconnecting...
Jul  1 08:02:40 moonshade kernel: [30933.858488] CIFS VFS: Server 192.168.16.2 has not responded in 120 seconds. Reconnecting...
Jul  1 08:02:56 moonshade afpd[18823]: AFP3.3 Login by torh
..
..
and so on -- this is still ongoing as it appears the 'rm' process is stuck and cannot be killed.

Tor
