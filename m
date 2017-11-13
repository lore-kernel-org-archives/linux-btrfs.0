Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:59003 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751887AbdKMHfR (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Mon, 13 Nov 2017 02:35:17 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, chris@colorremedies.com
Subject: [PATCH 3/4] btrfs-progs: lowmem check: Fix false alerts for image with shared block ref only backref
Date: Mon, 13 Nov 2017 15:34:52 +0800
Message-Id: <20171113073453.29198-4-wqu@suse.com>
In-Reply-To: <20171113073453.29198-1-wqu@suse.com>
References: <20171113073453.29198-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[BUG]
For image with shared block ref only metadata item like:
------
        item 66 key (21573632 METADATA_ITEM 0) itemoff 3971 itemsize 24
                refs 66 gen 9 flags TREE_BLOCK|FULL_BACKREF
                tree block skinny level 0
        item 0 key (21573632 SHARED_BLOCK_REF 21676032) itemoff 3995 itemsize 0
                shared block backref
        item 1 key (21573632 SHARED_BLOCK_REF 21921792) itemoff 3995 itemsize 0
                shared block backref
        item 2 key (21573632 SHARED_BLOCK_REF 21995520) itemoff 3995 itemsize 0
                shared block backref
        item 3 key (21573632 SHARED_BLOCK_REF 22077440) itemoff 3995 itemsize 0
                shared block backref
...
------

Lowmem mode check will report false alerts like:
------
ERROR: extent[21573632 4096] backref lost (owner: 256, level: 0)
------

[CAUSE]
In fact, the false alerts is not even from extent tree verfication,  but
a fs tree helper which is designed to make sure there is some tree block
referring to the fs tree block.

The idea is to find inlined tree backref then keyed TREE_BLOCK_REF_KEY.
However it missed SHARED_BLOCK_REF_KEY, and caused such false alert.

[FIX]
Add SHARED_BLOCK_REF_KEY to make the warning shut up.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds-check.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 36e4a91b7e17..4805e11b752b 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -10377,6 +10377,30 @@ static int check_tree_block_ref(struct btrfs_root *root,
 		if (!ret)
 			found_ref = 1;
 	}
+	/*
+	 * Finally check SHARED BLOCK REF, any found will be good
+	 * Here we're not doing comprehensive extent backref checking,
+	 * only need to ensure there is some extent referring to this
+	 * tree block.
+	 */
+	if (!found_ref) {
+		btrfs_release_path(&path);
+		key.objectid = bytenr;
+		key.type = BTRFS_SHARED_BLOCK_REF_KEY;
+		key.offset = (u64)-1;
+
+		ret = btrfs_search_slot(NULL, extent_root, &key, &path, 0, 0);
+		if (ret < 0) {
+			err |= BACKREF_MISSING;
+			goto out;
+		}
+		ret = btrfs_previous_extent_item(extent_root, &path, bytenr);
+		if (ret) {
+			err |= BACKREF_MISSING;
+			goto out;
+		}
+		found_ref = 1;
+	}
 	if (!found_ref)
 		err |= BACKREF_MISSING;
 out:
-- 
2.15.0

