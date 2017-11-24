Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:32752 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753100AbdKXKlg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Nov 2017 05:41:36 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <lakshmipathi.g@gmail.com>
Subject: [PATCH 1/5] btrfs-progs: Add location check when process share_data_ref item
Date: Fri, 24 Nov 2017 18:41:28 +0800
Message-ID: <1511520092-37101-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The following test failed becasuse share_data_ref be added into
extent_cache when deal with root tree node.

$sudo TEST=003\* make test-fuzz
cmds-check.c:5660: check_owner_ref: BUG_ON `rec->is_root` triggered, value 1
/home/adam/btrfs/btrfs-progs/btrfs[0x46a43b]
/home/adam/btrfs/btrfs-progs/btrfs[0x46a529]
/home/adam/btrfs/btrfs-progs/btrfs[0x479e55]
/home/adam/btrfs/btrfs-progs/btrfs[0x47af81]
/home/adam/btrfs/btrfs-progs/btrfs[0x47f69e]
/home/adam/btrfs/btrfs-progs/btrfs[0x484680]
/home/adam/btrfs/btrfs-progs/btrfs[0x484cb9]
/home/adam/btrfs/btrfs-progs/btrfs[0x4884f9]
/home/adam/btrfs/btrfs-progs/btrfs(cmd_check+0xb53)[0x48b7c3]
/home/adam/btrfs/btrfs-progs/btrfs(main+0x127)[0x40b39d]
/lib64/libc.so.6(__libc_start_main+0xea)[0x7f9ac76db03a]
/home/adam/btrfs/btrfs-progs/btrfs(_start+0x2a)[0x40ac9a]
failed (ignored, ret=134): /home/adam/btrfs/btrfs-progs/btrfs check --check-data-csum /home/adam/btrfs/btrfs-progs/tests/fuzz-tests/images/bko-156731.raw.restored
mayfail: returned code 134 (SIGABRT), not ignored
test failed for case 003-multi-check-unmounted

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 cmds-check.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 5c822b84..71b15de4 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -8018,6 +8018,14 @@ static int run_next_block(struct btrfs_root *root,
 			}
 			if (key.type == BTRFS_SHARED_DATA_REF_KEY) {
 				struct btrfs_shared_data_ref *ref;
+				if (root->root_key.objectid !=
+						BTRFS_EXTENT_TREE_OBJECTID) {
+					error(
+				"invaild location of share_data_ref [%d %d] root %d",
+						key.objectid, key.offset,
+						root->root_key.objectid);
+					continue;
+				}
 				ref = btrfs_item_ptr(buf, i,
 						struct btrfs_shared_data_ref);
 				add_data_backref(extent_cache,
-- 
2.14.3



