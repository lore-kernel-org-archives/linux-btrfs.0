Return-Path: <SRS0=yXFy=OU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7E46C07E85
	for <linux-btrfs@archiver.kernel.org>; Tue, 11 Dec 2018 15:03:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B35D62082F
	for <linux-btrfs@archiver.kernel.org>; Tue, 11 Dec 2018 15:03:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B35D62082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbeLKPDV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 11 Dec 2018 10:03:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:51772 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726366AbeLKPDV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Dec 2018 10:03:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B0C71AEFD
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Dec 2018 15:03:19 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v3] btrfs: improve error handling of btrfs_add_link()
Date:   Tue, 11 Dec 2018 16:03:15 +0100
Message-Id: <20181211150315.18414-1-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

err holds the return value of either btrfs_del_root_ref() or
btrfs_del_inode_ref() but it hasn't been checked since it's
introduction with commit fe66a05a0679 (Btrfs: improve error handling
for btrfs_insert_dir_item callers) in 2012.

To quote David:

"If the error handling in the error handling fails, there's not much left to do
and the abort either happened earlier in the callees or is necessary here."

So if one of btrfs_del_root_ref() or btrfs_del_inode_ref() failed, abort the
transaction.

Link: https://lore.kernel.org/linux-btrfs/20181126183759.GJ2842@twin.jikos.cz/
Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 fs/btrfs/inode.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c5c27d5457cc..c9457d2580c0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6311,6 +6311,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 	struct btrfs_root *root = parent_inode->root;
 	u64 ino = btrfs_ino(inode);
 	u64 parent_ino = btrfs_ino(parent_inode);
+	int err = 0;
 
 	if (unlikely(ino == BTRFS_FIRST_FREE_OBJECTID)) {
 		memcpy(&key, &inode->root->root_key, sizeof(key));
@@ -6355,18 +6356,21 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 fail_dir_item:
 	if (unlikely(ino == BTRFS_FIRST_FREE_OBJECTID)) {
 		u64 local_index;
-		int err;
+
 		err = btrfs_del_root_ref(trans, key.objectid,
 					 root->root_key.objectid, parent_ino,
 					 &local_index, name, name_len);
 
 	} else if (add_backref) {
 		u64 local_index;
-		int err;
 
 		err = btrfs_del_inode_ref(trans, root, name, name_len,
 					  ino, parent_ino, &local_index);
 	}
+
+	if (err)
+		btrfs_abort_transaction(trans, err);
+
 	return ret;
 }
 
-- 
2.16.4

