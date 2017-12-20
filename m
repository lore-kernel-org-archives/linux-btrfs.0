Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:7023 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754293AbdLTExh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 23:53:37 -0500
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo.btrfs@gmx.com>, <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v2 03/17] btrfs-progs: lowmem check: assign @parent early in repair_extent_data_item()
Date: Wed, 20 Dec 2017 12:57:17 +0800
Message-ID: <20171220045731.19343-4-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
References: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The variable @eb is assigned to leaf in fs_tree before insertion of
backref. It will causes wrong parent of new inserted backref.

Set @parent in the begin solves the problem.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index ebede26cef01..1f06f0a0ea61 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -11938,6 +11938,11 @@ static int repair_extent_data_item(struct btrfs_trans_handle *trans,
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
@@ -11979,11 +11984,6 @@ static int repair_extent_data_item(struct btrfs_trans_handle *trans,
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



