Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43158 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756012AbcINK3B (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Sep 2016 06:29:01 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u8EAS7fH109166
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Sep 2016 06:29:00 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0b-001b2d01.pphosted.com with ESMTP id 25exbyhkgu-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Sep 2016 06:28:59 -0400
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Wed, 14 Sep 2016 04:28:58 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, jbacik@fb.com
Subject: [PATCH] Btrfs: Free fs_info->eb_info only when it holds a valid pointer
Date: Wed, 14 Sep 2016 15:58:37 +0530
Message-Id: <1473848917-25442-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The following command line sequence causes a NULL pointer dereference,

mount /dev/loop0 /mnt/dir1
mount /dev/loop0 /mnt/dir2

[  159.964194] BUG: unable to handle kernel NULL pointer dereference at 0000000000000070
[  159.965147] IP: [<ffffffff8114e438>] list_lru_destroy+0x8/0x20
[  159.965147] PGD 0
[  159.965147] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[  159.965147] Modules linked in:
[  159.965147] CPU: 2 PID: 3043 Comm: mount Not tainted 4.7.0-ge96efee1-dirty #5
[  159.965147] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
[  159.965147] task: ffff8818b511a400 task.stack: ffff8818a5108000
[  159.965147] RIP: 0010:[<ffffffff8114e438>]  [<ffffffff8114e438>] list_lru_destroy+0x8/0x20
[  159.965147] RSP: 0018:ffff8818a510bbd8  EFLAGS: 00010246
[  159.965147] RAX: 0000000000000000 RBX: 0000000000000070 RCX: 00000000c0000100
[  159.965147] RDX: ffffffff82041b78 RSI: ffff8818b511a400 RDI: 0000000000000070
[  159.965147] RBP: ffff8818a510bbe0 R08: ffff8818a5108000 R09: ffff8818a50a6000
[  159.965147] R10: 0000000000000000 R11: 000000253e9b4bd4 R12: ffffffff82098f80
[  159.965147] R13: ffff8818b266e000 R14: ffff8818a4760000 R15: ffff8818b5449b50
[  159.965147] FS:  00007f29f0ab0840(0000) GS:ffff881933480000(0000) knlGS:0000000000000000
[  159.965147] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  159.965147] CR2: 0000000000000070 CR3: 00000018a5239000 CR4: 00000000000006e0
[  159.965147] Stack:
[  159.965147]  0000000000000000 ffff8818a510bcb8 ffffffff813464e5 0000000fa510bc00
[  159.965147]  000000200100243e ffff8818a4004d18 0000000800000046 ffff8818a510bc20
[  159.965147]  ffffffff8148243e ffff8818a510bc50 ffff8818b5449b30 0000000000000008
[  159.965147] Call Trace:
[  159.965147]  [<ffffffff813464e5>] btrfs_mount+0xad5/0xee0
[  159.965147]  [<ffffffff8148243e>] ? find_next_zero_bit+0x1e/0x20
[  159.965147]  [<ffffffff81184b64>] mount_fs+0x34/0x160
[  159.965147]  [<ffffffff81146fa0>] ? __alloc_percpu+0x10/0x20
[  159.965147]  [<ffffffff8119f032>] vfs_kern_mount+0x62/0x100
[  159.965147]  [<ffffffff81345b96>] btrfs_mount+0x186/0xee0
[  159.965147]  [<ffffffff8148243e>] ? find_next_zero_bit+0x1e/0x20
[  159.965147]  [<ffffffff81184b64>] mount_fs+0x34/0x160
[  159.965147]  [<ffffffff81146fa0>] ? __alloc_percpu+0x10/0x20
[  159.965147]  [<ffffffff8119f032>] vfs_kern_mount+0x62/0x100
[  159.965147]  [<ffffffff811a19b6>] do_mount+0x1b6/0xc40
[  159.965147]  [<ffffffff811422dd>] ? memdup_user+0x3d/0x70
[  159.965147]  [<ffffffff811a271e>] SyS_mount+0x7e/0xd0
[  159.965147]  [<ffffffff81a3ef1b>] entry_SYSCALL_64_fastpath+0x13/0x8f
[  159.965147] Code: 89 08 48 89 e5 48 8b 02 48 89 70 08 48 89 06 48 89 56 08 48 89 32 5d 48 83 6f 10 01 c3 66 0f 1f 44 00 00 55 48 89 e5 53 48 89 fb <48> 8b 3f 48 85 ff 74 0c e8 9b 99 02 00 48 c7 03 00 00 00 00 5b
[  159.965147] RIP  [<ffffffff8114e438>] list_lru_destroy+0x8/0x20
[  159.965147]  RSP <ffff8818a510bbd8>
[  159.965147] CR2: 0000000000000070
[  159.999634] ---[ end trace 04bad43e08a10198 ]---

When servicing the second mount command, btrfs_mount() invokes
free_fs_info() because super_block->s_root is already set. At this
instance we would not have initialized btrfs_fs_info->eb_info to a valid
memory address. Hence the statement,
list_lru_destroy(&fs_info->eb_info->lru_list); causes a NULL pointer
dereference.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/ctree.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index ee6956c..33ce069 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2882,8 +2882,11 @@ static inline int btrfs_need_cleaner_sleep(struct btrfs_root *root)
 
 static inline void free_fs_info(struct btrfs_fs_info *fs_info)
 {
-	list_lru_destroy(&fs_info->eb_info->lru_list);
-	kfree(fs_info->eb_info);
+	if (fs_info->eb_info) {
+		list_lru_destroy(&fs_info->eb_info->lru_list);
+		kfree(fs_info->eb_info);
+	}
+
 	kfree(fs_info->balance_ctl);
 	kfree(fs_info->delayed_root);
 	kfree(fs_info->extent_root);
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
