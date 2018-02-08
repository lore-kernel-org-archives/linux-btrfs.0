Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:13848 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752111AbeBHDXE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Feb 2018 22:23:04 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 47BEF48AE761
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Feb 2018 11:22:59 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v4 03/18] btrfs-progs: lowmem check: assign @parent early in repair_extent_data_item()
Date: Thu, 8 Feb 2018 11:27:22 +0800
Message-ID: <20180208032737.31561-4-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180208032737.31561-1-suy.fnst@cn.fujitsu.com>
References: <20180208032737.31561-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The variable @eb is assigned to leaf in fs_tree before insertion of
backref. It will causes wrong parent of new inserted backref.

Set @parent at beginning solves the problem.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 check/mode-lowmem.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 18ec6db098e7..1fc84f1e8c44 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -2475,6 +2475,11 @@ static int repair_extent_data_item(struct btrfs_trans_handle *trans,
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
@@ -2516,11 +2521,6 @@ static int repair_extent_data_item(struct btrfs_trans_handle *trans,
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
2.16.1



