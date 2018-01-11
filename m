Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:16872 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754076AbeAKHbA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 02:31:00 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 0B18348AEA11
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 15:30:59 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v3 03/17] btrfs-progs: lowmem check: assign @parent early in repair_extent_data_item()
Date: Thu, 11 Jan 2018 15:34:57 +0800
Message-ID: <20180111073511.25288-4-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180111073511.25288-1-suy.fnst@cn.fujitsu.com>
References: <20180111073511.25288-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The variable @eb is assigned to leaf in fs_tree before insertion of
backref. It will causes wrong parent of new inserted backref.

Set @parent in the begin solves the problem.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 4743a19421ec..24fb4bc50b95 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -11944,6 +11944,11 @@ static int repair_extent_data_item(struct btrfs_trans_handle *trans,
 	extent_offset = btrfs_file_extent_offset(eb, fi);
 	offset = file_offset - extent_offset;
 
+	if (nrefs->full_backref[0])
+		parent = btrfs_header_bytenr(eb);
+	else
+		parent = 0;
+
 	/* now repair only adds backref */
 	if ((err & BACKREF_MISSING) == 0)
 		return err;
@@ -11985,11 +11990,6 @@ static int repair_extent_data_item(struct btrfs_trans_handle *trans,
 		btrfs_release_path(&path);
 	}
 
-	if (nrefs->full_backref[0])
-		parent = btrfs_header_bytenr(eb);
-	else
-		parent = 0;
-
 	ret = btrfs_inc_extent_ref(trans, root, disk_bytenr, num_bytes, parent,
 				   root->objectid,
 		   parent ? BTRFS_FIRST_FREE_OBJECTID : fi_key.objectid,
-- 
2.15.1



