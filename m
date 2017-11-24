Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:32752 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753150AbdKXKlj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Nov 2017 05:41:39 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <lakshmipathi.g@gmail.com>
Subject: [PATCH 5/5] btrfs-progs: return error to caller instead of BUG_ON
Date: Fri, 24 Nov 2017 18:41:32 +0800
Message-ID: <1511520092-37101-5-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1511520092-37101-1-git-send-email-gujx@cn.fujitsu.com>
References: <1511520092-37101-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The following test fails when deal with corrupt block below in fs tree.
key (3742682168 UNKNOWN.0 51539611375) block 256 (0) gen 298824472660

And when try to repair this fs tree, it fails in repair_btree.
Because in repair_btree, it attempt to balance, but can not
find the following item in extent tree.
key (34084861431808 UNKNOWN.0 256) block 131072 (32) gen 36283884678912

Since from returned value, we can know the result of a procedure,
so using return error instead of BUG_ON.

Here comes the error message:
$ sudo TEST=003\* make test-fuzz
ctree.c:197: update_ref_for_cow: BUG_ON `ret` triggered, value -5
/home/adam/btrfs/btrfs-progs/btrfs[0x40b5d4]
/home/adam/btrfs/btrfs-progs/btrfs[0x40b6c2]
/home/adam/btrfs/btrfs-progs/btrfs[0x40c727]
/home/adam/btrfs/btrfs-progs/btrfs(__btrfs_cow_block+0x2cf)[0x40cda4]
/home/adam/btrfs/btrfs-progs/btrfs(btrfs_cow_block+0x105)[0x40d0fc]
/home/adam/btrfs/btrfs-progs/btrfs[0x40dd8a]
/home/adam/btrfs/btrfs-progs/btrfs(btrfs_search_slot+0x355)[0x40f14f]
/home/adam/btrfs/btrfs-progs/btrfs[0x477546]
/home/adam/btrfs/btrfs-progs/btrfs[0x477c19]
/home/adam/btrfs/btrfs-progs/btrfs[0x477ff1]
/home/adam/btrfs/btrfs-progs/btrfs[0x47cd3f]
/home/adam/btrfs/btrfs-progs/btrfs(cmd_check+0xd6b)[0x48fc86]
/home/adam/btrfs/btrfs-progs/btrfs(main+0x127)[0x40b49d]
/lib64/libc.so.6(__libc_start_main+0xea)[0x7fe14bf1803a]
/home/adam/btrfs/btrfs-progs/btrfs(_start+0x2a)[0x40ad9a]
failed (ignored, ret=134): /home/adam/btrfs/btrfs-progs/btrfs check --init-csum-tree /home/adam/btrfs/btrfs-progs/tests/fuzz-tests/images/bko-172811.raw.restored
mayfail: returned code 134 (SIGABRT), not ignored

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 ctree.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/ctree.c b/ctree.c
index 4fc33b14..f4cf006b 100644
--- a/ctree.c
+++ b/ctree.c
@@ -194,8 +194,10 @@ static noinline int update_ref_for_cow(struct btrfs_trans_handle *trans,
 		ret = btrfs_lookup_extent_info(trans, root, buf->start,
 					       btrfs_header_level(buf), 1,
 					       &refs, &flags);
-		BUG_ON(ret);
-		BUG_ON(refs == 0);
+		if (refs == 0)
+			ret = -EIO;
+		if (ret)
+			return ret;
 	} else {
 		refs = 1;
 		if (root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID ||
-- 
2.14.3



