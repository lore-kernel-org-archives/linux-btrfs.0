Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:33816 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751490AbeDJFzr (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 10 Apr 2018 01:55:47 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC] btrfs-progs: ctree: Don't return error if first key mismatch on leaf
Date: Tue, 10 Apr 2018 13:55:29 +0800
Message-Id: <20180410055529.28341-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When running btrfs/074 with enough CPUs, it's possible (around 1%) to
hit first key mismatch warning.

Most of such warning happens in split_leaf() where it can ignore error
from push_leaf_right(), some of such problem also happens in
btrfs_search_forward().

Since it could break normal tree operations, at least keep the warning
for debug build but change its return to 0 for leaf, so we won't break
normal tree operations.

And, any suggest/advice on this tree locking problem is welcome.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index bb38f4098e9c..cf58e9babe34 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -442,6 +442,7 @@ static int verify_level_key(struct btrfs_fs_info *fs_info,
 		btrfs_err(fs_info,
 "tree level mismatch detected, bytenr=%llu level expected=%u has=%u",
 			  eb->start, level, found_level);
+		btrfs_print_tree(eb, false);
 #endif
 		return -EIO;
 	}
@@ -463,8 +464,16 @@ static int verify_level_key(struct btrfs_fs_info *fs_info,
 			  eb->start, first_key->objectid, first_key->type,
 			  first_key->offset, found_key.objectid,
 			  found_key.type, found_key.offset);
+		btrfs_print_tree(eb, false);
 	}
 #endif
+	/*
+	 * XXX: We seems to have locking problem for leaf, where we have race
+	 * updating parent nodeptr's first key.
+	 * So if this eb is leaf and first key doesn't match, still let it go.
+	 */
+	if (level == 0 && ret)
+		ret = 0;
 	return ret;
 }
 
-- 
2.17.0

