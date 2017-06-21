Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from scorn.kernelslacker.org ([45.56.101.199]:35602 "EHLO
        scorn.kernelslacker.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751680AbdFUQbb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 12:31:31 -0400
Date: Wed, 21 Jun 2017 11:16:32 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: btrfs_wait_ordered_roots warning triggered
Message-ID: <20170621151632.dsipxge7zdklbink@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

WARNING: CPU: 2 PID: 7153 at fs/btrfs/ordered-data.c:753 btrfs_wait_ordered_roots+0x1a3/0x220
CPU: 2 PID: 7153 Comm: kworker/u8:7 Not tainted 4.12.0-rc6-think+ #4 
Workqueue: events_unbound btrfs_async_reclaim_metadata_space
task: ffff8804f08d5380 task.stack: ffffc9000895c000
RIP: 0010:btrfs_wait_ordered_roots+0x1a3/0x220
RSP: 0018:ffffc9000895fc70 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 00000000f7efdfb1 RCX: 00000000000025c3
RDX: ffff880507c0cde0 RSI: 0000000000000000 RDI: 0000000000000002
RBP: ffffc9000895fce8 R08: 0000000000000000 R09: 0000000000000001
R10: ffffc9000895fbd8 R11: ffff8804f08d5380 R12: ffff8804f4930008
R13: 0000000000000001 R14: ffff8804f36f0000 R15: ffff8804f4930850
FS:  0000000000000000(0000) GS:ffff880507c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd40c4a1bf2 CR3: 000000013995e000 CR4: 00000000001406e0
DR0: 00007f17be890000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
Call Trace:
 flush_space+0x285/0x6e0
 btrfs_async_reclaim_metadata_space+0xd7/0x420
 process_one_work+0x24d/0x680
 worker_thread+0x4e/0x3b0
 kthread+0x117/0x150
 ? process_one_work+0x680/0x680
 ? kthread_create_on_node+0x70/0x70
 ret_from_fork+0x27/0x40



This is 4.12rc6, with the following diff because I hit that ASSERT far too easily..

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ef3c98c527c1..8a5c906ad67c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4722,7 +4722,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
        }
 error:
        if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID) {
-               ASSERT(last_size >= new_size);
+//             ASSERT(last_size >= new_size);
                if (!err && last_size > new_size)
                        last_size = new_size;
                btrfs_ordered_update_i_size(inode, last_size, NULL);

