Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:30742 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753192AbdKXKlh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Nov 2017 05:41:37 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <lakshmipathi.g@gmail.com>
Subject: [PATCH 3/5] btrfs-progs: return error to upper caller instead of BUG_ON
Date: Fri, 24 Nov 2017 18:41:30 +0800
Message-ID: <1511520092-37101-3-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1511520092-37101-1-git-send-email-gujx@cn.fujitsu.com>
References: <1511520092-37101-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Return error to upper caller instead of BUG_ON.

The following test failed when trying to repair fs root,
because the bytenr of item below in fs tree is smaller than sectorsize.
key (256 INODE_ITEM 0) block 3835 (0) gen 6052837899185946625
It fails in function read_tree_block.

Here comes the call stack:
    at disk-io.c:324
    at ctree.c:652
    p=0x721ec0, ins_len=185, cow=1) at ctree.c:1173
    path=0x721ec0, cpu_key=0x7fffffffdc90, data_size=0x7fffffffdbcc, nr=1) at ctree.c:2485
    key=0x7fffffffdc90, data_size=160) at ctree.h:2603
    cpu_key=0x7fffffffdc90, data=0x7fffffffdce0, data_size=160) at ctree.c:2584
    inode_item=0x7fffffffdce0) at inode-item.c:155
    at utils.c:397
    at cmds-check.c:3925

Here comes the error message:
$ sudo TEST=003\* make test-fuzz
cmds-check.c:3938: check_inode_recs: BUG_ON `ret` triggered, value -5
/home/adam/btrfs/btrfs-progs/btrfs[0x46aba7]
/home/adam/btrfs/btrfs-progs/btrfs[0x46ac95]
/home/adam/btrfs/btrfs-progs/btrfs[0x4760ee]
/home/adam/btrfs/btrfs-progs/btrfs[0x477d01]
/home/adam/btrfs/btrfs-progs/btrfs[0x477ff1]
/home/adam/btrfs/btrfs-progs/btrfs[0x47cd3f]
/home/adam/btrfs/btrfs-progs/btrfs(cmd_check+0xd6b)[0x48fc86]
/home/adam/btrfs/btrfs-progs/btrfs(main+0x127)[0x40b49d]
/lib64/libc.so.6(__libc_start_main+0xea)[0x7fc7005a603a]
/home/adam/btrfs/btrfs-progs/btrfs(_start+0x2a)[0x40ad9a]
failed (ignored, ret=134): /home/adam/btrfs/btrfs-progs/btrfs check --init-csum-tree /home/adam/btrfs/btrfs-progs/tests/fuzz-tests/images/bko-172811.raw.restored

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 cmds-check.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index ac0375e5..49b0792b 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3489,9 +3489,10 @@ static int check_inode_recs(struct btrfs_root *root,
 				(unsigned long long)root->objectid);
 
 			ret = btrfs_make_root_dir(trans, root, root_dirid);
-			BUG_ON(ret);
 
 			btrfs_commit_transaction(trans, root);
+			if (ret)
+				return ret;
 			return -EAGAIN;
 		}
 
-- 
2.14.3



