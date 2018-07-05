Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54444 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753251AbeGEHqC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Jul 2018 03:46:02 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 946E1AF5B
        for <linux-btrfs@vger.kernel.org>; Thu,  5 Jul 2018 07:46:01 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs-progs: tests/fuzz: Add fuzzed test image for btrfs check BUG_ON
Date: Thu,  5 Jul 2018 15:45:57 +0800
Message-Id: <20180705074558.20022-2-wqu@suse.com>
In-Reply-To: <20180705074558.20022-1-wqu@suse.com>
References: <20180705074558.20022-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This fuzzed image will not only cause kernel BUG_ON(), but also btrfs
check BUG_ON() for original mode.

Checking filesystem on /home/adam/btrfs/crafted_images/runtime/0.img
UUID: 3381d111-94a3-4ac7-8f39-611bbbdab7e6
checking extents
check/main.c:3677: check_owner_ref: BUG_ON `rec->is_root` triggered, value 1
btrfs(+0x572c2)[0x562d65da72c2]
btrfs(+0x6098d)[0x562d65db098d]
btrfs(+0x60bb6)[0x562d65db0bb6]
btrfs(+0x6179b)[0x562d65db179b]
btrfs(cmd_check+0x1199)[0x562d65db5589]
btrfs(main+0x88)[0x562d65d62768]
/usr/lib/libc.so.6(__libc_start_main+0xeb)[0x7f4fcbb1b06b]
btrfs(_start+0x2a)[0x562d65d6288a]

Link: https://bugzilla.kernel.org/show_bug.cgi?id=200403
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/fuzz-tests/images/bko-200403.raw.txt |  93 +++++++++++++++++++++
 tests/fuzz-tests/images/bko-200403.raw.xz  | Bin 0 -> 23252 bytes
 2 files changed, 93 insertions(+)
 create mode 100644 tests/fuzz-tests/images/bko-200403.raw.txt
 create mode 100644 tests/fuzz-tests/images/bko-200403.raw.xz

diff --git a/tests/fuzz-tests/images/bko-200403.raw.txt b/tests/fuzz-tests/images/bko-200403.raw.txt
new file mode 100644
index 000000000000..aae8ea4810bb
--- /dev/null
+++ b/tests/fuzz-tests/images/bko-200403.raw.txt
@@ -0,0 +1,93 @@
+Link: https://bugzilla.kernel.org/show_bug.cgi?id=200403
+Wen Xu 2018-07-04 17:21:58 UTC
+
+Created attachment 277167 [details]
+The (compressed) crafted image which causes crash
+
+- Reproduce
+# mkdir mnt
+# mount -t btrfs 0.img mnt
+# gcc -o poc poc.c
+# ./poc ./mnt
+# umount mnt
+
+- Kernel message
+[  230.611533] BTRFS: device fsid 3381d111-94a3-4ac7-8f39-611bbbdab7e6 devid 1 transid 8 /dev/loop0
+[  230.632922] BTRFS info (device loop0): disk space caching is enabled
+[  230.632935] BTRFS info (device loop0): has skinny extents
+[  230.647496] BTRFS info (device loop0): creating UUID tree
+[  237.692643] ------------[ cut here ]------------
+[  237.692654] kernel BUG at fs/btrfs/volumes.c:1625!
+[  237.693822] invalid opcode: 0000 [#1] SMP KASAN PTI
+[  237.694867] CPU: 1 PID: 1387 Comm: umount Not tainted 4.18.0-rc1+ #8
+[  237.696177] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
+[  237.698177] RIP: 0010:btrfs_remove_chunk+0x37a/0xd60
+[  237.699209] Code: e0 48 39 85 28 ff ff ff 77 20 0f b6 85 27 ff ff ff 4d 89 6f 80 4c 89 f7 4d 89 67 89 41 88 47 88 e8 0b 01 f7 ff e9 f5 fe ff ff <0f> 0b 0f 85 5c 08 00 00 4d 8d 66 40 4c 89 f7 e8 42 f9 b6 ff 4c 89
+[  237.703034] RSP: 0018:ffff8801f0b0fad8 EFLAGS: 00010206
+[  237.704122] RAX: 0000000008000000 RBX: ffff8801ef4d7c38 RCX: 0000000000000000
+[  237.705572] RDX: ffffed003e161f30 RSI: 0000000000000e70 RDI: ffff8801f2a6ae70
+[  237.707035] RBP: ffff8801f0b0fc38 R08: ffff8801f0b0f9e0 R09: ffff8801f0b0fa20
+[  237.708485] R10: 0000000000000003 R11: ffffed003e161f7c R12: 0000000007400000
+[  237.709929] R13: 0000000000000001 R14: ffff8801f2bf0a50 R15: ffff8801f0b0fc10
+[  237.711391] FS:  00007f691b770840(0000) GS:ffff8801f6f00000(0000) knlGS:0000000000000000
+[  237.713034] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
+[  237.714206] CR2: 0000000000cb0348 CR3: 00000001f26f8000 CR4: 00000000000006e0
+[  237.719741] Call Trace:
+[  237.720274]  ? btrfs_grow_device+0x240/0x240
+[  237.721193]  ? kasan_check_read+0x11/0x20
+[  237.722080]  ? mutex_lock+0x99/0xf0
+[  237.722854]  btrfs_delete_unused_bgs+0x4b6/0x5c0
+[  237.723836]  close_ctree+0x40a/0x460
+[  237.724586]  ? transaction_kthread+0x250/0x250
+[  237.725523]  ? dispose_list+0xa0/0xa0
+[  237.726303]  btrfs_put_super+0x25/0x30
+[  237.727110]  generic_shutdown_super+0xb9/0x1c0
+[  237.728032]  kill_anon_super+0x24/0x40
+[  237.728814]  btrfs_kill_super+0x31/0x220
+[  237.729630]  deactivate_locked_super+0x6f/0xa0
+[  237.730548]  deactivate_super+0x5e/0x80
+[  237.731352]  cleanup_mnt+0x61/0xa0
+[  237.732060]  __cleanup_mnt+0x12/0x20
+[  237.732835]  task_work_run+0xc8/0xf0
+[  237.733605]  exit_to_usermode_loop+0x125/0x130
+[  237.734530]  do_syscall_64+0x138/0x170
+[  237.735331]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
+[  237.736676] RIP: 0033:0x7f691b050487
+[  237.737457] Code: 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e1 c9 2b 00 f7 d8 64 89 01 48
+[  237.741327] RSP: 002b:00007ffdf3a06d98 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
+[  237.742889] RAX: 0000000000000000 RBX: 0000000000ca7030 RCX: 00007f691b050487
+[  237.744351] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000000cae1e0
+[  237.745814] RBP: 0000000000cae1e0 R08: 0000000000000000 R09: 0000000000000015
+[  237.747289] R10: 00000000000006b2 R11: 0000000000000246 R12: 00007f691b55983c
+[  237.748750] R13: 0000000000000000 R14: 0000000000ca7210 R15: 00007ffdf3a07020
+[  237.750224] Modules linked in: snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hwdep snd_hda_core snd_pcm snd_timer snd mac_hid i2c_piix4 soundcore ib_iser rdma_cm iw_cm ib_cm ib_core iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx raid1 raid0 multipath linear 8139too qxl drm_kms_helper crct10dif_pclmul syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32_pclmul aesni_intel drm aes_x86_64 crypto_simd cryptd glue_helper 8139cp mii pata_acpi floppy
+[  237.760666] ---[ end trace 2e85051acb5f6dc1 ]---
+[  237.761718] RIP: 0010:btrfs_remove_chunk+0x37a/0xd60
+[  237.762827] Code: e0 48 39 85 28 ff ff ff 77 20 0f b6 85 27 ff ff ff 4d 89 6f 80 4c 89 f7 4d 89 67 89 41 88 47 88 e8 0b 01 f7 ff e9 f5 fe ff ff <0f> 0b 0f 85 5c 08 00 00 4d 8d 66 40 4c 89 f7 e8 42 f9 b6 ff 4c 89
+[  237.766977] RSP: 0018:ffff8801f0b0fad8 EFLAGS: 00010206
+[  237.768157] RAX: 0000000008000000 RBX: ffff8801ef4d7c38 RCX: 0000000000000000
+[  237.769672] RDX: ffffed003e161f30 RSI: 0000000000000e70 RDI: ffff8801f2a6ae70
+[  237.771147] RBP: ffff8801f0b0fc38 R08: ffff8801f0b0f9e0 R09: ffff8801f0b0fa20
+[  237.772650] R10: 0000000000000003 R11: ffffed003e161f7c R12: 0000000007400000
+[  237.774119] R13: 0000000000000001 R14: ffff8801f2bf0a50 R15: ffff8801f0b0fc10
+[  237.775598] FS:  00007f691b770840(0000) GS:ffff8801f6f00000(0000) knlGS:0000000000000000
+[  237.777297] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
+[  237.778496] CR2: 0000000000cb0348 CR3: 00000001f26f8000 CR4: 00000000000006e0
+
+
+===== Extra info for btrfs-progs ======
+It has one corrupted root item, (41 ROOT_ITEM 0) referring tree block
+29364224, which is also UUID tree root.
+It would cause original mode to hit BUG_ON().
+Checking filesystem on /home/adam/btrfs/crafted_images/runtime/0.img
+UUID: 3381d111-94a3-4ac7-8f39-611bbbdab7e6
+checking extents
+check/main.c:3677: check_owner_ref: BUG_ON `rec->is_root` triggered, value 1
+btrfs(+0x572c2)[0x562d65da72c2]
+btrfs(+0x6098d)[0x562d65db098d]
+btrfs(+0x60bb6)[0x562d65db0bb6]
+btrfs(+0x6179b)[0x562d65db179b]
+btrfs(cmd_check+0x1199)[0x562d65db5589]
+btrfs(main+0x88)[0x562d65d62768]
+/usr/lib/libc.so.6(__libc_start_main+0xeb)[0x7f4fcbb1b06b]
+btrfs(_start+0x2a)[0x562d65d6288a]
diff --git a/tests/fuzz-tests/images/bko-200403.raw.xz b/tests/fuzz-tests/images/bko-200403.raw.xz
new file mode 100644
index 0000000000000000000000000000000000000000..569594570e6c26220e8cc1d2d6c71032cb4ff74b
GIT binary patch
literal 23252
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

literal 0
HcmV?d00001

-- 
2.18.0

