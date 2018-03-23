Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46286 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751388AbeCWOsR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Mar 2018 10:48:17 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3CE15B00B
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Mar 2018 14:48:16 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/2] btrfs-progs: Fix DIR_ITEM checking in lowmem
Date: Fri, 23 Mar 2018 16:48:13 +0200
Message-Id: <1521816494-22947-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When checking the validity of a DIR_ITEM item the index variable
is explicitly set to -1 so that the index check in find_inode_ref()
is ignored. This is necessary due to possible name collisions in DIR_ITEMS
(i.e multiple files with the same crc32c for their names, resulting in the
identical key->offset). Currently the code is broken due to index being set to
-1 at the beginning of check_dir_item and subsequently reset to the index found
in find_inode_ref. On subsequent iterations of the while loop in check_dir_items
we are going to erroneously perform index checking, since index is not -1 but 
whatever the index value of the last handled INODE_REF ITEM.
Without this patch check in lowmem mode produces the following false warnings 
positivess:

ERROR: root 5 INODE REF[1991456, 256] name 5ab4e28b~~~~~~~~QBXUT2GBJDRT5CB6ZWAJVDHK filetype 1 missing

But the items for this name are in fact correct: 

------------------SNIP------------------------
item 13 key (256 DIR_ITEM 4227063046) itemoff 2945 itemsize 140
	location key (220890 INODE_ITEM 0) type FILE
	transid 2278 data_len 0 name_len 40
	name: 5ab4e1bb~~~~~~~~65KNTAWVJ5VD4SV2R3BKFCXL
	location key (1991456 INODE_ITEM 0) type FILE
	transid 2285 data_len 0 name_len 40
	name: 5ab4e28b~~~~~~~~QBXUT2GBJDRT5CB6ZWAJVDHK

item 21 key (1991456 INODE_REF 256) itemoff 2104 itemsize 50
	index 1934146 namelen 40 name: 5ab4e28b~~~~~~~~QBXUT2GBJDRT5CB6ZWAJVDHK
-------------------SNIP-------------------------

Fix this by moving the code setting index at the beginning of the while
loop. This ensure that for each item in DIR_ITEM we have index set
correctly.

Fixes: 564901eac7a4 ("btrfs-progs: check: introduce print_dir_item_err()")
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 check/mode-lowmem.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 2982e92..8bd50d1 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -1217,14 +1217,6 @@ static int check_dir_item(struct btrfs_root *root, struct btrfs_key *di_key,
 	int tmp_err;
 	int need_research = 0;
 
-	/*
-	 * For DIR_ITEM set index to (u64)-1, so that find_inode_ref
-	 * ignore index check.
-	 */
-	if (di_key->type == BTRFS_DIR_INDEX_KEY)
-		index = di_key->offset;
-	else
-		index = (u64)-1;
 begin:
 	err = 0;
 	cur = 0;
@@ -1254,6 +1246,15 @@ begin:
 	memset(namebuf, 0, sizeof(namebuf) / sizeof(*namebuf));
 
 	while (cur < total) {
+		/*
+		 * For DIR_ITEM set index to (u64)-1, so that find_inode_ref
+		 * ignore index check.
+		 */
+		if (di_key->type == BTRFS_DIR_INDEX_KEY)
+			index = di_key->offset;
+		else
+			index = (u64)-1;
+
 		data_len = btrfs_dir_data_len(node, di);
 		tmp_err = 0;
 		if (data_len)
-- 
2.7.4

