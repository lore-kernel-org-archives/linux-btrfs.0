Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54454 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753220AbeGEHqE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Jul 2018 03:46:04 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2AC2EAF54
        for <linux-btrfs@vger.kernel.org>; Thu,  5 Jul 2018 07:46:03 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs-progs: test/fuzz: Add image for BUG_ON() when opening the fs by btrfs check
Date: Thu,  5 Jul 2018 15:45:58 +0800
Message-Id: <20180705074558.20022-3-wqu@suse.com>
In-Reply-To: <20180705074558.20022-1-wqu@suse.com>
References: <20180705074558.20022-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Link: https://bugzilla.kernel.org/show_bug.cgi?id=199839
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/fuzz-tests/images/bko-199839.raw.txt | 198 +++++++++++++++++++++
 tests/fuzz-tests/images/bko-199839.raw.xz  | Bin 0 -> 24400 bytes
 2 files changed, 198 insertions(+)
 create mode 100644 tests/fuzz-tests/images/bko-199839.raw.txt
 create mode 100644 tests/fuzz-tests/images/bko-199839.raw.xz

diff --git a/tests/fuzz-tests/images/bko-199839.raw.txt b/tests/fuzz-tests/images/bko-199839.raw.txt
new file mode 100644
index 000000000000..3e4b273d9ec7
--- /dev/null
+++ b/tests/fuzz-tests/images/bko-199839.raw.txt
@@ -0,0 +1,198 @@
+URL: https://bugzilla.kernel.org/show_bug.cgi?id=199839
+Wen Xu 2018-05-26 04:18:45 UTC
+
+Created attachment 276197 [details]
+The (compressed) crafted image which causes crash
+
+- Overview
+use-after-free in try_merge_free_space() when mounting a crafted btrfs image
+
+- Reproduce (4.17 KASAN build)
+# mkdir mnt
+# mount -t btrfs 8.img mnt
+
+- Kernel Message
+[  449.751861] BTRFS: device fsid 12b338de-a2e9-40fa-a4b0-90e53b7c5773 devid 1 transid 8 /dev/loop0
+[  449.757216] BTRFS info (device loop0): disk space caching is enabled
+[  449.757221] BTRFS info (device loop0): has skinny extents
+[  449.785096] BTRFS error (device loop0): bad tree block start 0 29396992
+[  449.788629] BTRFS info (device loop0): read error corrected: ino 0 off 29396992 (dev /dev/loop0 sector 73800)
+[  449.792965] BTRFS error (device loop0): bad fsid on block 29409280
+[  449.795193] BTRFS info (device loop0): read error corrected: ino 0 off 29409280 (dev /dev/loop0 sector 73824)
+[  449.795401] BTRFS info (device loop0): creating UUID tree
+[  449.883426] ==================================================================
+[  449.886228] BUG: KASAN: use-after-free in try_merge_free_space+0xc0/0x2e0
+[  449.888344] Read of size 8 at addr ffff8801ed10f030 by task mount/1291
+
+[  449.889947] CPU: 1 PID: 1291 Comm: mount Not tainted 4.17.0-rc5+ #6
+[  449.889951] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
+[  449.889953] Call Trace:
+[  449.889976]  dump_stack+0x7b/0xb5
+[  449.890274]  print_address_description+0x70/0x290
+[  449.890286]  kasan_report+0x291/0x390
+[  449.890296]  ? try_merge_free_space+0xc0/0x2e0
+[  449.890303]  __asan_load8+0x54/0x90
+[  449.890310]  try_merge_free_space+0xc0/0x2e0
+[  449.890318]  __btrfs_add_free_space+0x96/0x5e0
+[  449.890324]  ? kasan_check_write+0x14/0x20
+[  449.890331]  ? btrfs_get_block_group+0x1e/0x30
+[  449.890337]  ? block_group_cache_tree_search+0xef/0x150
+[  449.890343]  unpin_extent_range+0x376/0x670
+[  449.890350]  ? __exclude_logged_extent+0x160/0x160
+[  449.890358]  btrfs_finish_extent_commit+0x15b/0x490
+[  449.890371]  ? __find_get_block+0x106/0x400
+[  449.890378]  ? btrfs_prepare_extent_commit+0x1a0/0x1a0
+[  449.890384]  ? write_all_supers+0x714/0x1420
+[  449.890394]  btrfs_commit_transaction+0xaf4/0xfa0
+[  449.890402]  ? btrfs_apply_pending_changes+0xa0/0xa0
+[  449.890407]  ? start_transaction+0x153/0x640
+[  449.890414]  btrfs_create_uuid_tree+0x6a/0x170
+[  449.890419]  open_ctree+0x3b26/0x3ce9
+[  449.890429]  ? close_ctree+0x4a0/0x4a0
+[  449.890441]  ? bdi_register_va+0x44/0x50
+[  449.890451]  ? super_setup_bdi_name+0x11b/0x1a0
+[  449.890457]  ? kill_block_super+0x80/0x80
+[  449.890468]  ? snprintf+0x96/0xd0
+[  449.890479]  btrfs_mount_root+0xae6/0xc60
+[  449.890485]  ? btrfs_mount_root+0xae6/0xc60
+[  449.890491]  ? pcpu_block_update_hint_alloc+0x1f5/0x2a0
+[  449.890498]  ? btrfs_decode_error+0x40/0x40
+[  449.890510]  ? find_next_bit+0x57/0x90
+[  449.890517]  ? cpumask_next+0x1a/0x20
+[  449.890522]  ? pcpu_alloc+0x449/0x8c0
+[  449.890528]  ? pcpu_free_area+0x410/0x410
+[  449.890534]  ? memcg_kmem_put_cache+0x1b/0xa0
+[  449.890540]  ? memcpy+0x45/0x50
+[  449.890547]  mount_fs+0x60/0x1a0
+[  449.890553]  ? btrfs_decode_error+0x40/0x40
+[  449.890558]  ? mount_fs+0x60/0x1a0
+[  449.890565]  ? alloc_vfsmnt+0x309/0x360
+[  449.890570]  vfs_kern_mount+0x6b/0x1a0
+[  449.890576]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
+[  449.890583]  btrfs_mount+0x209/0xb71
+[  449.890589]  ? pcpu_block_update_hint_alloc+0x1f5/0x2a0
+[  449.890595]  ? btrfs_remount+0x8e0/0x8e0
+[  449.890601]  ? find_next_zero_bit+0x2c/0xa0
+[  449.890608]  ? find_next_bit+0x57/0x90
+[  449.890613]  ? cpumask_next+0x1a/0x20
+[  449.890617]  ? pcpu_alloc+0x449/0x8c0
+[  449.890624]  ? pcpu_free_area+0x410/0x410
+[  449.890629]  ? memcg_kmem_put_cache+0x1b/0xa0
+[  449.890634]  ? memcpy+0x45/0x50
+[  449.890641]  mount_fs+0x60/0x1a0
+[  449.890646]  ? btrfs_remount+0x8e0/0x8e0
+[  449.890652]  ? mount_fs+0x60/0x1a0
+[  449.890656]  ? alloc_vfsmnt+0x309/0x360
+[  449.890662]  vfs_kern_mount+0x6b/0x1a0
+[  449.890668]  do_mount+0x34a/0x18a0
+[  449.890673]  ? lockref_put_or_lock+0xcf/0x160
+[  449.890680]  ? copy_mount_string+0x20/0x20
+[  449.890685]  ? memcg_kmem_put_cache+0x1b/0xa0
+[  449.890691]  ? kasan_check_write+0x14/0x20
+[  449.890696]  ? _copy_from_user+0x6a/0x90
+[  449.890702]  ? memdup_user+0x42/0x60
+[  449.890708]  ksys_mount+0x83/0xd0
+[  449.890714]  __x64_sys_mount+0x67/0x80
+[  449.890723]  do_syscall_64+0x78/0x170
+[  449.890729]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
+[  449.890734] RIP: 0033:0x7fc36964fb9a
+[  449.890737] RSP: 002b:00007ffd268892f8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
+[  449.890744] RAX: ffffffffffffffda RBX: 0000000000e7f030 RCX: 00007fc36964fb9a
+[  449.890747] RDX: 0000000000e7f210 RSI: 0000000000e80f30 RDI: 0000000000e87ec0
+[  449.890750] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000014
+[  449.890753] R10: 00000000c0ed0000 R11: 0000000000000202 R12: 0000000000e87ec0
+[  449.890756] R13: 0000000000e7f210 R14: 0000000000000000 R15: 0000000000000003
+
+[  449.891109] Allocated by task 1291:
+[  449.891832]  save_stack+0x46/0xd0
+[  449.891838]  kasan_kmalloc+0xad/0xe0
+[  449.891843]  kasan_slab_alloc+0x11/0x20
+[  449.891848]  kmem_cache_alloc+0xd1/0x1e0
+[  449.891854]  __btrfs_add_free_space+0x43/0x5e0
+[  449.891859]  add_new_free_space+0x22b/0x240
+[  449.891864]  btrfs_read_block_groups+0xae3/0xc60
+[  449.891868]  open_ctree+0x2cfc/0x3ce9
+[  449.891873]  btrfs_mount_root+0xae6/0xc60
+[  449.891878]  mount_fs+0x60/0x1a0
+[  449.891883]  vfs_kern_mount+0x6b/0x1a0
+[  449.891888]  btrfs_mount+0x209/0xb71
+[  449.891893]  mount_fs+0x60/0x1a0
+[  449.891897]  vfs_kern_mount+0x6b/0x1a0
+[  449.891902]  do_mount+0x34a/0x18a0
+[  449.891906]  ksys_mount+0x83/0xd0
+[  449.891911]  __x64_sys_mount+0x67/0x80
+[  449.891916]  do_syscall_64+0x78/0x170
+[  449.891921]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
+
+[  449.892235] Freed by task 1291:
+[  449.892866]  save_stack+0x46/0xd0
+[  449.892872]  __kasan_slab_free+0x13c/0x1a0
+[  449.892877]  kasan_slab_free+0xe/0x10
+[  449.892882]  kmem_cache_free+0x89/0x1e0
+[  449.892888]  try_merge_free_space+0x274/0x2e0
+[  449.892894]  __btrfs_add_free_space+0x96/0x5e0
+[  449.892898]  unpin_extent_range+0x376/0x670
+[  449.892904]  btrfs_finish_extent_commit+0x15b/0x490
+[  449.892909]  btrfs_commit_transaction+0xaf4/0xfa0
+[  449.892913]  btrfs_create_uuid_tree+0x6a/0x170
+[  449.892917]  open_ctree+0x3b26/0x3ce9
+[  449.892922]  btrfs_mount_root+0xae6/0xc60
+[  449.892927]  mount_fs+0x60/0x1a0
+[  449.892932]  vfs_kern_mount+0x6b/0x1a0
+[  449.892937]  btrfs_mount+0x209/0xb71
+[  449.892942]  mount_fs+0x60/0x1a0
+[  449.892946]  vfs_kern_mount+0x6b/0x1a0
+[  449.892951]  do_mount+0x34a/0x18a0
+[  449.892955]  ksys_mount+0x83/0xd0
+[  449.892960]  __x64_sys_mount+0x67/0x80
+[  449.892965]  do_syscall_64+0x78/0x170
+[  449.892970]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
+
+[  449.893286] The buggy address belongs to the object at ffff8801ed10f000
+                which belongs to the cache btrfs_free_space of size 72
+[  449.895793] The buggy address is located 48 bytes inside of
+                72-byte region [ffff8801ed10f000, ffff8801ed10f048)
+[  449.898035] The buggy address belongs to the page:
+[  449.898979] page:ffffea0007b443c0 count:1 mapcount:0 mapping:0000000000000000 index:0x0
+[  449.900562] flags: 0x2ffff0000000100(slab)
+[  449.901379] raw: 02ffff0000000100 0000000000000000 0000000000000000 0000000180270027
+[  449.902881] raw: dead000000000100 dead000000000200 ffff8801e0a676c0 0000000000000000
+[  449.904396] page dumped because: kasan: bad access detected
+
+[  449.905800] Memory state around the buggy address:
+[  449.906748]  ffff8801ed10ef00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+[  449.908165]  ffff8801ed10ef80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+[  449.909577] >ffff8801ed10f000: fb fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc
+[  449.910969]                                      ^
+[  449.911933]  ffff8801ed10f080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
+[  449.913328]  ffff8801ed10f100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
+[  449.914720] ==================================================================
+[  449.916119] Disabling lock debugging due to kernel taint
+
+No kernel crash on plain kernel.
+
+- Reason
+https://elixir.bootlin.com/linux/v4.17-rc5/source/fs/btrfs/free-space-cache.c#L2161
+
+	if (left_info && !left_info->bitmap &&
+	    left_info->offset + left_info->bytes == offset) {
+		if (update_stat)
+			unlink_free_space(ctl, left_info);
+		else
+			__unlink_free_space(ctl, left_info);
+		info->offset = left_info->offset;
+		info->bytes += left_info->bytes;
+		kmem_cache_free(btrfs_free_space_cachep, left_info);
+		merged = true;
+	}
+
+	return merged;
+
+Regarding KASAN report, left_info is already freed but referenced (->bitmap). It is in fact freed just several lines after, namely kmem_cache_free(btrfs_free_space_cachep, left_info);
+
+Found by Wen Xu and Po-Ning Tseng from SSLab, Gatech.
+
+===== Extra info for btrfs-progs =====
+This image could cause btrfs-progs to BUG_ON() when opening the image.
+Fixed by "btrfs-progs: Don't BUG_ON() if we failed to load one device or one
+chunk".
diff --git a/tests/fuzz-tests/images/bko-199839.raw.xz b/tests/fuzz-tests/images/bko-199839.raw.xz
new file mode 100644
index 0000000000000000000000000000000000000000..c06d9540f708824e763b0e2cb0e66266326e31a6
GIT binary patch
literal 24400
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
Wul#J2m>+~B;yjOj`wT$RH~1H8_y~aj

literal 0
HcmV?d00001

-- 
2.18.0

