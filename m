Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54806 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750952AbeGIGu7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Jul 2018 02:50:59 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3F260ACBB
        for <linux-btrfs@vger.kernel.org>; Mon,  9 Jul 2018 06:50:58 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs-progs: tests/fuzz: Add image for bko-200409
Date: Mon,  9 Jul 2018 14:50:54 +0800
Message-Id: <20180709065054.1392-2-wqu@suse.com>
In-Reply-To: <20180709065054.1392-1-wqu@suse.com>
References: <20180709065054.1392-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Reported-by: Xu Wen <wen.xu@gatech.edu>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=200409
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/fuzz-tests/images/bko-200409.raw.txt | 125 +++++++++++++++++++++
 tests/fuzz-tests/images/bko-200409.raw.xz  | Bin 0 -> 24480 bytes
 2 files changed, 125 insertions(+)
 create mode 100644 tests/fuzz-tests/images/bko-200409.raw.txt
 create mode 100644 tests/fuzz-tests/images/bko-200409.raw.xz

diff --git a/tests/fuzz-tests/images/bko-200409.raw.txt b/tests/fuzz-tests/images/bko-200409.raw.txt
new file mode 100644
index 000000000000..7df7924370eb
--- /dev/null
+++ b/tests/fuzz-tests/images/bko-200409.raw.txt
@@ -0,0 +1,125 @@
+Link: https://bugzilla.kernel.org/show_bug.cgi?id=200409
+Wen Xu 2018-07-04 17:47:09 UTC
+
+Created attachment 277173 [details]
+The (compressed) crafted image which causes crash
+
+- Reproduce
+# mkdir mnt
+# mount -t btrfs 5.img mnt
+
+- Kernel message
+[  333.770743] BTRFS: device fsid 3381d111-94a3-4ac7-8f39-611bbbdab7e6 devid 1 transid 8 /dev/loop0
+[  333.779221] BTRFS info (device loop0): disk space caching is enabled
+[  333.779234] BTRFS info (device loop0): has skinny extents
+[  333.798081] ------------[ cut here ]------------
+[  333.798090] kernel BUG at fs/btrfs/volumes.c:6564!
+[  333.799293] invalid opcode: 0000 [#1] SMP KASAN PTI
+[  333.800355] CPU: 0 PID: 1353 Comm: mount Not tainted 4.18.0-rc1+ #8
+[  333.801652] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
+[  333.803658] RIP: 0010:read_one_chunk+0x77c/0x880
+[  333.804630] Code: e8 a9 82 fd ff 48 8b 95 70 ff ff ff 48 8b bd 60 ff ff ff b9 01 00 00 00 4c 89 f6 e8 2e 14 ff ff b8 fe ff ff ff e9 cb fe ff ff <0f> 0b 48 8b bd 38 ff ff ff e8 76 82 fd ff e9 35 ff ff ff 48 8b 95
+[  333.808462] RSP: 0018:ffff8801eedf7230 EFLAGS: 00010282
+[  333.809542] RAX: ffff8801f2df2100 RBX: 00000000ffffffef RCX: ffffffffa5839143
+[  333.810991] RDX: 1ffff1003e5be444 RSI: e300000001c00000 RDI: ffff8801f2df2220
+[  333.812451] RBP: ffff8801eedf7310 R08: ffffed003e5be445 R09: ffffed003e5be445
+[  333.813905] R10: 0000000000000001 R11: ffffed003e5be444 R12: ffff8801e6788158
+[  333.815357] R13: 0000000000000001 R14: 0000000000000001 R15: ffff8801f2df2220
+[  333.846990] FS:  00007f2013519840(0000) GS:ffff8801f6e00000(0000) knlGS:0000000000000000
+[  333.848645] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
+[  333.849816] CR2: 00007f88a3c6b760 CR3: 00000001e655e000 CR4: 00000000000006f0
+[  333.851304] Call Trace:
+[  333.851864]  ? add_missing_dev+0xc0/0xc0
+[  333.852715]  ? read_extent_buffer+0xe9/0x130
+[  333.853604]  btrfs_read_chunk_tree+0x957/0xd20
+[  333.854551]  ? free_root_pointers+0xb0/0xb0
+[  333.855435]  ? btrfs_check_rw_degradable+0x240/0x240
+[  333.856491]  ? btree_read_extent_buffer_pages+0x1e0/0x3b0
+[  333.857617]  ? run_one_async_done+0xb0/0xb0
+[  333.858498]  ? cache_state.part.32+0x10/0x40
+[  333.859430]  ? unlock_page+0x16/0x40
+[  333.860202]  ? alloc_extent_buffer+0x4a1/0x4e0
+[  333.861149]  ? memcpy+0x45/0x50
+[  333.861818]  ? read_extent_buffer+0xe9/0x130
+[  333.862711]  open_ctree+0x246c/0x35c6
+[  333.863488]  ? close_ctree+0x460/0x460
+[  333.864302]  ? bdi_register_va+0x44/0x50
+[  333.865142]  ? super_setup_bdi_name+0x11b/0x1a0
+[  333.866089]  ? kill_block_super+0x80/0x80
+[  333.866970]  ? snprintf+0x96/0xd0
+[  333.867704]  btrfs_mount_root+0xae6/0xc60
+[  333.868550]  ? btrfs_mount_root+0xae6/0xc60
+[  333.869419]  ? pcpu_block_update_hint_alloc+0x1d2/0x2a0
+[  333.870492]  ? btrfs_decode_error+0x40/0x40
+[  333.871389]  ? find_next_bit+0x57/0x90
+[  333.872206]  ? cpumask_next+0x1a/0x20
+[  333.872986]  ? pcpu_alloc+0x449/0x8c0
+[  333.873761]  ? pcpu_free_area+0x410/0x410
+[  333.874614]  ? memcg_kmem_put_cache+0x1b/0xa0
+[  333.875531]  ? memcpy+0x45/0x50
+[  333.876209]  mount_fs+0x60/0x1a0
+[  333.876892]  ? btrfs_decode_error+0x40/0x40
+[  333.877763]  ? mount_fs+0x60/0x1a0
+[  333.878492]  ? alloc_vfsmnt+0x309/0x360
+[  333.879303]  vfs_kern_mount+0x6b/0x1a0
+[  333.880121]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
+[  333.881209]  btrfs_mount+0x209/0xb71
+[  333.881962]  ? pcpu_block_update_hint_alloc+0x1d2/0x2a0
+[  333.883044]  ? btrfs_remount+0x8e0/0x8e0
+[  333.883878]  ? find_next_zero_bit+0x2c/0xa0
+[  333.884753]  ? find_next_bit+0x57/0x90
+[  333.885538]  ? cpumask_next+0x1a/0x20
+[  333.886307]  ? pcpu_alloc+0x449/0x8c0
+[  333.887078]  ? pcpu_free_area+0x410/0x410
+[  333.887930]  ? memcg_kmem_put_cache+0x1b/0xa0
+[  333.888836]  ? memcpy+0x45/0x50
+[  333.889500]  mount_fs+0x60/0x1a0
+[  333.890182]  ? btrfs_remount+0x8e0/0x8e0
+[  333.891001]  ? mount_fs+0x60/0x1a0
+[  333.891728]  ? alloc_vfsmnt+0x309/0x360
+[  333.892533]  vfs_kern_mount+0x6b/0x1a0
+[  333.893323]  do_mount+0x34a/0x18c0
+[  333.894042]  ? copy_mount_string+0x20/0x20
+[  333.894898]  ? memcg_kmem_put_cache+0x1b/0xa0
+[  333.895832]  ? kasan_check_write+0x14/0x20
+[  333.896704]  ? _copy_from_user+0x6a/0x90
+[  333.897542]  ? memdup_user+0x42/0x60
+[  333.898300]  ksys_mount+0x83/0xd0
+[  333.899003]  __x64_sys_mount+0x67/0x80
+[  333.899831]  do_syscall_64+0x78/0x170
+[  333.900610]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
+[  333.901682] RIP: 0033:0x7f2012df9b9a
+[  333.902430] Code: 48 8b 0d 01 c3 2b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d ce c2 2b 00 f7 d8 64 89 01 48
+[  333.906311] RSP: 002b:00007ffd77e261b8 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
+[  333.907874] RAX: ffffffffffffffda RBX: 00000000019e7030 RCX: 00007f2012df9b9a
+[  333.909341] RDX: 00000000019e7210 RSI: 00000000019e8f30 RDI: 00000000019efec0
+[  333.910804] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000014
+[  333.912281] R10: 00000000c0ed0000 R11: 0000000000000206 R12: 00000000019efec0
+[  333.913747] R13: 00000000019e7210 R14: 0000000000000000 R15: 0000000000000003
+[  333.915224] Modules linked in: snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hwdep snd_hda_core snd_pcm snd_timer snd mac_hid i2c_piix4 soundcore ib_iser rdma_cm iw_cm ib_cm ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx raid1 raid0 multipath linear 8139too qxl drm_kms_helper crct10dif_pclmul syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32_pclmul aesni_intel drm aes_x86_64 crypto_simd cryptd glue_helper 8139cp mii pata_acpi floppy
+[  333.932460] ---[ end trace 2e85051acb5f6dc1 ]---
+[  333.933448] RIP: 0010:read_one_chunk+0x77c/0x880
+[  333.934397] Code: e8 a9 82 fd ff 48 8b 95 70 ff ff ff 48 8b bd 60 ff ff ff b9 01 00 00 00 4c 89 f6 e8 2e 14 ff ff b8 fe ff ff ff e9 cb fe ff ff <0f> 0b 48 8b bd 38 ff ff ff e8 76 82 fd ff e9 35 ff ff ff 48 8b 95
+[  333.938283] RSP: 0018:ffff8801eedf7230 EFLAGS: 00010282
+[  333.939361] RAX: ffff8801f2df2100 RBX: 00000000ffffffef RCX: ffffffffa5839143
+[  333.940846] RDX: 1ffff1003e5be444 RSI: e300000001c00000 RDI: ffff8801f2df2220
+[  333.942318] RBP: ffff8801eedf7310 R08: ffffed003e5be445 R09: ffffed003e5be445
+[  333.943878] R10: 0000000000000001 R11: ffffed003e5be444 R12: ffff8801e6788158
+[  333.945371] R13: 0000000000000001 R14: 0000000000000001 R15: ffff8801f2df2220
+[  333.946839] FS:  00007f2013519840(0000) GS:ffff8801f6e00000(0000) knlGS:0000000000000000
+[  333.948526] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
+[  333.949711] CR2: 00007f88a3c6b760 CR3: 00000001e655e000 CR4: 00000000000006f0
+
+- Location
+https://elixir.bootlin.com/linux/v4.18-rc3/source/fs/btrfs/volumes.c#L6564
+	write_lock(&map_tree->map_tree.lock);
+	ret = add_extent_mapping(&map_tree->map_tree, em, 0);
+	write_unlock(&map_tree->map_tree.lock);
+	BUG_ON(ret); /* Tree corruption */ <---
+	free_extent_map(em);
+
+Found by Wen Xu and Po-Ning Tseng from SSLab at Gatech.
+
+====== Extra info for btrfs-progs ======
+Btrfs-progs has the exact BUG_ON() in read_one_chunk().
+Fixed by "btrfs-progs: Exit gracefully when overlap chunks are detected".
diff --git a/tests/fuzz-tests/images/bko-200409.raw.xz b/tests/fuzz-tests/images/bko-200409.raw.xz
new file mode 100644
index 0000000000000000000000000000000000000000..8ec29cfd61420fd20924d7208a74205f08a3d7e3
GIT binary patch
literal 24480
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

literal 0
HcmV?d00001

-- 
2.18.0

