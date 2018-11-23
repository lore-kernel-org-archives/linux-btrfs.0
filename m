Return-Path: <SRS0=1Z4l=OC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D9DDC43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 08:42:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9E3820820
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 08:42:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C9E3820820
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393804AbeKWT0C (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 23 Nov 2018 14:26:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:58602 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2393753AbeKWT0C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Nov 2018 14:26:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 549A6AF77
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Nov 2018 08:42:45 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v2] btrfs: improve error handling of btrfs_add_link()
Date:   Fri, 23 Nov 2018 09:42:43 +0100
Message-Id: <20181123084243.25899-1-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

err holds the return value of either btrfs_del_root_ref() or
btrfs_del_inode_ref() but it hasn't been checked since it's
introduction with commit fe66a05a0679 (Btrfs: improve error handling
for btrfs_insert_dir_item callers) in 2012.

Instead of silently ignoring the return values, print a message so the user
knows what kind of error has encountered.

Link: https://lore.kernel.org/linux-btrfs/20181119141323.GC24115@twin.jikos.cz
Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---

Changes to v1:
* Only print an error message and let the callers abort the transaction (Dave)
---
 fs/btrfs/inode.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9becf8543489..8ca2f82b35a3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6351,6 +6351,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 	struct btrfs_root *root = parent_inode->root;
 	u64 ino = btrfs_ino(inode);
 	u64 parent_ino = btrfs_ino(parent_inode);
+	int err;
 
 	if (unlikely(ino == BTRFS_FIRST_FREE_OBJECTID)) {
 		memcpy(&key, &inode->root->root_key, sizeof(key));
@@ -6395,17 +6396,25 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 fail_dir_item:
 	if (unlikely(ino == BTRFS_FIRST_FREE_OBJECTID)) {
 		u64 local_index;
-		int err;
+
 		err = btrfs_del_root_ref(trans, key.objectid,
 					 root->root_key.objectid, parent_ino,
 					 &local_index, name, name_len);
+		if (err)
+			btrfs_info(trans->fs_info,
+		   "failed to delete reference to %.*s, root %llu ref %llu",
+				   name_len, name, key.objectid,
+				   root->root_key.objectid);
 
 	} else if (add_backref) {
 		u64 local_index;
-		int err;
 
 		err = btrfs_del_inode_ref(trans, root, name, name_len,
 					  ino, parent_ino, &local_index);
+		if (err)
+			btrfs_info(trans->fs_info,
+	   "failed to delete reference to %.*s, inode %llu parent %llu",
+				   name_len, name, ino, parent_ino);
 	}
 	return ret;
 }
-- 
2.16.4

