Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DFC364951
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Mar 2026 07:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773129301; cv=none; b=NXhGXZhrpISJGJeqBddn4nrbrXGpcT7fEvgiPlAgFQ1Q2vFBrChqnOWjL0vT9sUIMJLk9fnhHlts11hBu/SmUgUiWH/siUqVoiJ4O2MLKu0WmWATfSGzSqsKD/ZjYyYaKrY9lQJMkzeO5Q71z5Bj9/ukJDWEwfcZNoPNU8Y3ECM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773129301; c=relaxed/simple;
	bh=EIPl/s34jrAmGYpuXVIZW16E7Jf/p7GwvfRwqQMJ0pA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dQj3V7z4eh9T7o71sNiPrWAK8AP6bgBQRYFrsttj/ar7j/7R0kryrpy85y3+R882KNRXJ04srIqSNMtxt38o9ZRTtmUACYAsfOsWkRgn4fadA/uYxj9B7Z2ROkexg8ifHkOzdb2bQ+gce+e8UhICdvDE40o1NVGO08jKSyVAT/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fu5SWn+v; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fu5SWn+v"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-829a9d08644so2197066b3a.1
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Mar 2026 00:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773129299; x=1773734099; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MeGJ6/I7dDVsZynsQyzX66bp2Bn9p9ixrGY7BHboZCM=;
        b=fu5SWn+vTIkoNQ4YeL0CvdQAZUsjGFkOYYgrXYJaUNEeD4TLZ30wX2rJn1jXUCL1Yd
         LSuTZb3uid3Zy0gd97vZSPxbmAiJG+venJChWV9g5FtrAyO5/OlYWNSCtlb90UrMuCEE
         WDexVagKtlXwekNOljk+SJnjccg6KaNArr6QgAekUlWyvnF4FcQTndxcDe77tcLHY2eP
         16f50FuQQegoRAp0ZOSoK67t9yGIDAbFdbqCeFMN+CyvWLTFX/Mw22gdOMbxWsqOv1gW
         DrYi5HZBaypo0jDTRBqB2uNAYp2DSAX3ez2+Xi/kZUJ9ugEfjoxMi75Hbdt1nVgLc+ja
         vZ8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773129299; x=1773734099;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MeGJ6/I7dDVsZynsQyzX66bp2Bn9p9ixrGY7BHboZCM=;
        b=ec1wMcO7GGM//umntCsEBaqKJV7XFrBKadGx6LWHTNaLMwNGB08J/VdHrrNkiPQ+Pn
         CUHtKmuspwL7BFX6d6IG1weSB6T3pXgaV8eH81/n2nVE8D1SvTXEH6ubOZ3ljyAF27rF
         B50J530xiQyrJKLY2C41niFRlF6tMdNVLlUi+ah31BxLN9AX8yfLThzsugjU2cnJUjsP
         mWb3LLBrzaWdMQX9aVtt1tMhzjKLOsx6zJ4d3lbcztb73qACgf/pWbzj+qkngZ1bPOuc
         P3WlnfCCDZ6WkrTEju3BzpVufzEZ+RivSghxrknl8z7ArbT6+WlJTIwK6nvuoszuSGkI
         WjuA==
X-Gm-Message-State: AOJu0Yw5xuhzD2dZRkxlTfvzt67uvqH33UgOEX2hfLOC3F1gUBvzAxFU
	JEi45c+fhJAaS34PEf5OxTn3BQDjC8iJOXsmrAHvE6cJS18M3DsUqBe2
X-Gm-Gg: ATEYQzxyCx6CeagBfjIGBEpm+IQuGnfjZoZuKjgqq7dhSGSo0fflIwapxzGh8tPwPTx
	vZtOpayjGwMNbdABcDB7XuWe3wF19E5q92XwGzKNDR1jzA/4wE6NG9DEHDT90kELmeaYzXn+/bV
	3jAyHtKYLojfxRu4Hi8tOKkUNKXkG1cELQAe1wjEIegK1zhPt276aYqttohUyiYGrkEtbYORANB
	c2J974QuonYwgdQuDDohaT+N8mBWf0Dm/rDwTbeWrPelNmwNiWVtxI0bQzCwrOvOJw0RjtGEV4O
	nCN5pLMAsFdB/WF8DNy8p3CybmNIiCa7aD+tHQI6/O2mU0Klhtx/AKJvXFdWPs1TrdnWSp0venz
	jIixhkCf6qQ0wTX7x+DIvsQqiejOm+LfATVr/E4VAOSjHA4awqS56AWFanltz+GDj5VFS60bjNP
	g1Ah0yL8NtadxC1eLEWwWga5jUan2wc6HuEhdrNi9GS+MONFx4gUJqOj1qMLLQksSSiiEVPA==
X-Received: by 2002:a05:6a00:2d1e:b0:827:32c1:a1cc with SMTP id d2e1a72fcca58-829a2f4fd83mr11578207b3a.42.1773129298723;
        Tue, 10 Mar 2026 00:54:58 -0700 (PDT)
Received: from kernel-fuzz.. ([138.199.21.245])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829a48b2c41sm12433318b3a.54.2026.03.10.00.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 00:54:58 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: dsterba@suse.com,
	clm@fb.com,
	wqu@suse.com
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] btrfs: reloc: unlink orphan reloc roots before dropping them
Date: Tue, 10 Mar 2026 15:54:47 +0800
Message-ID: <20260310075447.2088205-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

clean_dirty_subvols() walks rc->dirty_subvol_roots during relocation
recovery at mount time. That list can contain both normal subvolume
roots and orphan relocation roots.

For normal subvolume roots, clean_dirty_subvols() first removes
root->reloc_dirty_list from rc->dirty_subvol_roots and then drops the
associated relocation tree. But for orphan relocation roots it directly
calls btrfs_drop_snapshot(root, false, true) without unlinking
root->reloc_dirty_list first.

This leaves a freed btrfs_root still linked in rc->dirty_subvol_roots.
Later list_del_init() on a neighboring entry writes through that stale
list node, triggering a slab-use-after-free in clean_dirty_subvols().

Fix this by removing orphan relocation roots from
rc->dirty_subvol_roots before calling btrfs_drop_snapshot().

The bug is reproducible on 7.0.0-rc2-next-20260309 with our dynamic
metadata fuzzing tool that corrupts btrfs metadata at runtime. After
the fix, orphan relocation roots are removed from the dirty_subvol_roots
list before they can be freed, so the recovery path no longer writes
into freed memory.

Fixes: 30d40577e322 ("btrfs: reloc: Also queue orphan reloc tree for cleanup to avoid BUG_ON()")
Cc: stable@vger.kernel.org # 5.1+
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
Root cause
==========
clean_dirty_subvols() walks rc->dirty_subvol_roots, which can contain
both normal subvolume roots and orphan relocation roots.

For normal roots, it first removes root->reloc_dirty_list from the list
before dropping the related relocation tree. But for orphan relocation
roots it calls btrfs_drop_snapshot(root, false, true) directly, without
unlinking root->reloc_dirty_list first.

btrfs_drop_snapshot() can free the last reference to root via
btrfs_put_root(), leaving a freed btrfs_root still linked in
rc->dirty_subvol_roots. Later list_del_init() on a neighboring entry
writes through that stale list node and triggers the slab-use-after-free.

Reproduction (v6.18, x86_64, KASAN)
===================================
The PoC is relatively large, so it is provided separately through google drive:
https://drive.google.com/drive/folders/1-e2ynmoQ4JzWs4F-jMtndh5pe3Vce2Zm

To reproduce the issue:
  1. Build the ublk helper program from the ublk codebase, which is
	 used to provide the runtime corruption capability:
	  g++ -std=c++20 -fcoroutines -O2 -o standalone_replay \
      standalone_replay_btrfs.cpp targets/ublksrv_tgt.cpp \
      -I. -Iinclude -Itargets/include \
      -L./lib/.libs -lublksrv -luring -lpthread
  2. Attach the crafted image through ublk:
      ./standalone_replay add -t loop -f /path/to/image
  3. Mount the image:
	  mount -o loop /path/to/image /mnt
This reliably reproduces the bug.

Fix
===
Remove orphan relocation roots from rc->dirty_subvol_roots before
calling btrfs_drop_snapshot() on them.

That restores the normal list lifetime rule:
  unlink from external containers first,
  then allow the final put/free to happen.

This is a minimal fix. Since both branches now call
list_del_init(&root->reloc_dirty_list), it may be possible to move the
unlink before the if/else and simplify the flow. I left that out here to
avoid changing more than needed, but I can respin the patch that way if
preferred.

KASAN reports
=============
BUG: KASAN: slab-use-after-free in __list_del include/linux/list.h:204 [inline]
BUG: KASAN: slab-use-after-free in __list_del_entry include/linux/list.h:226 [inline]
BUG: KASAN: slab-use-after-free in list_del_init include/linux/list.h:295 [inline]
BUG: KASAN: slab-use-after-free in clean_dirty_subvols+0x2dc/0x350 fs/btrfs/relocation.c:1472
Write of size 8 at addr ffff888014172838 by task syz-executor/265

CPU: 1 UID: 0 PID: 265 Comm: syz-executor Not tainted 6.18.0+ #14 PREEMPT(voluntary) 
Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0xbe/0x130 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xd1/0x650 mm/kasan/report.c:482
 kasan_report+0xfb/0x140 mm/kasan/report.c:595
 __asan_report_store8_noabort+0x17/0x30 mm/kasan/report_generic.c:386
 __list_del include/linux/list.h:204 [inline]
 __list_del_entry include/linux/list.h:226 [inline]
 list_del_init include/linux/list.h:295 [inline]
 clean_dirty_subvols+0x2dc/0x350 fs/btrfs/relocation.c:1472
 btrfs_recover_relocation+0xe64/0x11d0 fs/btrfs/relocation.c:4207
 btrfs_start_pre_rw_mount+0xa4d/0x1810 fs/btrfs/disk-io.c:3130
 open_ctree+0x5824/0x5fe0 fs/btrfs/disk-io.c:3640
 btrfs_fill_super fs/btrfs/super.c:987 [inline]
 btrfs_get_tree_super fs/btrfs/super.c:1951 [inline]
 btrfs_get_tree_subvol fs/btrfs/super.c:2094 [inline]
 btrfs_get_tree+0x111c/0x2190 fs/btrfs/super.c:2128
 vfs_get_tree+0x9a/0x370 fs/super.c:1758
 fc_mount fs/namespace.c:1199 [inline]
 do_new_mount_fc fs/namespace.c:3642 [inline]
 do_new_mount fs/namespace.c:3718 [inline]
 path_mount+0x5b8/0x1ea0 fs/namespace.c:4028
 do_mount fs/namespace.c:4041 [inline]
 __do_sys_mount fs/namespace.c:4229 [inline]
 __se_sys_mount fs/namespace.c:4206 [inline]
 __x64_sys_mount+0x282/0x320 fs/namespace.c:4206
 x64_sys_call+0x1a7d/0x26a0 arch/x86/include/generated/asm/syscalls_64.h:166
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x93/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7dcca37a8fde
Code: 0f 1f 40 00 48 c7 c2 b0 ff ff ff f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc521c2e08 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffc521c31b0 RCX: 00007dcca37a8fde
RDX: 00007ffc521c35d0 RSI: 00007ffc521c31b0 RDI: 00007dcca3865d4f
RBP: 00007dcca3865d4f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000400 R11: 0000000000000246 R12: 00007ffc521c35d0
R13: 00007dcca3865dde R14: 00000000ffffffff R15: 585858582e7a7973
 </TASK>

Allocated by task 265:
 kasan_save_stack+0x39/0x70 mm/kasan/common.c:56
 kasan_save_track+0x14/0x40 mm/kasan/common.c:77
 kasan_save_alloc_info+0x37/0x60 mm/kasan/generic.c:573
 poison_kmalloc_redzone mm/kasan/common.c:400 [inline]
 __kasan_kmalloc+0xc3/0xd0 mm/kasan/common.c:417
 kasan_kmalloc include/linux/kasan.h:262 [inline]
 __kmalloc_cache_noprof+0x25f/0x800 mm/slub.c:5771
 kmalloc_noprof include/linux/slab.h:957 [inline]
 kzalloc_noprof include/linux/slab.h:1094 [inline]
 btrfs_alloc_root+0xb6/0xd20 fs/btrfs/disk-io.c:643
 read_tree_root_path+0x15d/0xaa0 fs/btrfs/disk-io.c:1025
 btrfs_read_tree_root+0x42/0x70 fs/btrfs/disk-io.c:1086
 btrfs_recover_relocation+0x298/0x11d0 fs/btrfs/relocation.c:4104
 btrfs_start_pre_rw_mount+0xa4d/0x1810 fs/btrfs/disk-io.c:3130
 open_ctree+0x5824/0x5fe0 fs/btrfs/disk-io.c:3640
 btrfs_fill_super fs/btrfs/super.c:987 [inline]
 btrfs_get_tree_super fs/btrfs/super.c:1951 [inline]
 btrfs_get_tree_subvol fs/btrfs/super.c:2094 [inline]
 btrfs_get_tree+0x111c/0x2190 fs/btrfs/super.c:2128
 vfs_get_tree+0x9a/0x370 fs/super.c:1758
 fc_mount fs/namespace.c:1199 [inline]
 do_new_mount_fc fs/namespace.c:3642 [inline]
 do_new_mount fs/namespace.c:3718 [inline]
 path_mount+0x5b8/0x1ea0 fs/namespace.c:4028
 do_mount fs/namespace.c:4041 [inline]
 __do_sys_mount fs/namespace.c:4229 [inline]
 __se_sys_mount fs/namespace.c:4206 [inline]
 __x64_sys_mount+0x282/0x320 fs/namespace.c:4206
 x64_sys_call+0x1a7d/0x26a0 arch/x86/include/generated/asm/syscalls_64.h:166
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x93/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Freed by task 265:
 kasan_save_stack+0x39/0x70 mm/kasan/common.c:56
 kasan_save_track+0x14/0x40 mm/kasan/common.c:77
 __kasan_save_free_info+0x3b/0x60 mm/kasan/generic.c:587
 kasan_save_free_info mm/kasan/kasan.h:406 [inline]
 poison_slab_object mm/kasan/common.c:252 [inline]
 __kasan_slab_free+0x6f/0xa0 mm/kasan/common.c:284
 kasan_slab_free include/linux/kasan.h:234 [inline]
 slab_free_hook mm/slub.c:2543 [inline]
 slab_free mm/slub.c:6642 [inline]
 kfree+0x2bf/0x6b0 mm/slub.c:6849
 btrfs_put_root fs/btrfs/disk-io.c:1851 [inline]
 btrfs_put_root+0x1f7/0x2f0 fs/btrfs/disk-io.c:1832
 btrfs_drop_snapshot+0x1e78/0x2a60 fs/btrfs/extent-tree.c:6286
 clean_dirty_subvols+0x23e/0x350 fs/btrfs/relocation.c:1496
 btrfs_recover_relocation+0xe64/0x11d0 fs/btrfs/relocation.c:4207
 btrfs_start_pre_rw_mount+0xa4d/0x1810 fs/btrfs/disk-io.c:3130
 open_ctree+0x5824/0x5fe0 fs/btrfs/disk-io.c:3640
 btrfs_fill_super fs/btrfs/super.c:987 [inline]
 btrfs_get_tree_super fs/btrfs/super.c:1951 [inline]
 btrfs_get_tree_subvol fs/btrfs/super.c:2094 [inline]
 btrfs_get_tree+0x111c/0x2190 fs/btrfs/super.c:2128
 vfs_get_tree+0x9a/0x370 fs/super.c:1758
 fc_mount fs/namespace.c:1199 [inline]
 do_new_mount_fc fs/namespace.c:3642 [inline]
 do_new_mount fs/namespace.c:3718 [inline]
 path_mount+0x5b8/0x1ea0 fs/namespace.c:4028
 do_mount fs/namespace.c:4041 [inline]
 __do_sys_mount fs/namespace.c:4229 [inline]
 __se_sys_mount fs/namespace.c:4206 [inline]
 __x64_sys_mount+0x282/0x320 fs/namespace.c:4206
 x64_sys_call+0x1a7d/0x26a0 arch/x86/include/generated/asm/syscalls_64.h:166
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x93/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

The buggy address belongs to the object at ffff888014172000
 which belongs to the cache kmalloc-rnd-06-4k of size 4096
The buggy address is located 2104 bytes inside of
 freed 4096-byte region [ffff888014172000, ffff888014173000)
---
 fs/btrfs/relocation.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 0765e06d00b8..2bff2db7afbd 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1492,7 +1492,8 @@ static int clean_dirty_subvols(struct reloc_control *rc)
 			}
 			btrfs_put_root(root);
 		} else {
-			/* Orphan reloc tree, just clean it up */
+			/* Orphan reloc tree, unlink it first and clean it up */
+			list_del_init(&root->reloc_dirty_list);
 			ret2 = btrfs_drop_snapshot(root, false, true);
 			if (ret2 < 0) {
 				btrfs_put_root(root);
-- 
2.43.0

