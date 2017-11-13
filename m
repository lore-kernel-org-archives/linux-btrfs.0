Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:54343 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751534AbdKMEcO (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Sun, 12 Nov 2017 23:32:14 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, chris@colorremedies.com
Subject: [PATCH 2/3] btrfs-progs: lowmem fsck: Fix false backref lost warning for keyed extent data ref
Date: Mon, 13 Nov 2017 12:32:02 +0800
Message-Id: <20171113043203.9859-2-wqu@suse.com>
In-Reply-To: <20171113043203.9859-1-wqu@suse.com>
References: <20171113043203.9859-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For keyed extent ref, its offset is calculated offset (file offset -
file extent offset), just like inlined extent data ref.

However the code is using file offset to hash extent data ref offset,
causing false backref lost warning like:
------
ERROR: data extent[16913485824 7577600] backref lost
------

Fixes: b0d360b541f0 ("btrfs-progs: check: introduce function to check data backref in extent tree")
Reported-by: Chris Murphy <chris@colorremedies.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds-check.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 0ceff5b7bbea..b9943a0d3a0f 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -10519,7 +10519,7 @@ static int check_extent_data_item(struct btrfs_root *root,
 		dbref_key.objectid = btrfs_file_extent_disk_bytenr(eb, fi);
 		dbref_key.type = BTRFS_EXTENT_DATA_REF_KEY;
 		dbref_key.offset = hash_extent_data_ref(root->objectid,
-				fi_key.objectid, fi_key.offset);
+				fi_key.objectid, fi_key.offset - offset);
 
 		ret = btrfs_search_slot(NULL, root->fs_info->extent_root,
 					&dbref_key, &path, 0, 0);
-- 
2.15.0

