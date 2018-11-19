Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DF15C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 09:38:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5153620823
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 09:38:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5153620823
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbeKSUBm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Nov 2018 15:01:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:60164 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727437AbeKSUBl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 15:01:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D72D7AEC7
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Nov 2018 09:38:35 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v2 2/5] btrfs: remove set but not used variable err in btrfs_add_link
Date:   Mon, 19 Nov 2018 10:38:14 +0100
Message-Id: <20181119093817.9291-3-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20181119093817.9291-1-jthumshirn@suse.de>
References: <20181119093817.9291-1-jthumshirn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

err holds the return value of either btrfs_del_root_ref() or
btrfs_del_inode_ref() but it hasn't been checked since it's introduction with
commit fe66a05a0679 (Btrfs: improve error handling for btrfs_insert_dir_item
callers) in 2012.

As the error value hasn't been of any interest for 6 years we can just drop it
as well.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/inode.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9becf8543489..7f56a235c0b1 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6395,17 +6395,16 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 fail_dir_item:
 	if (unlikely(ino == BTRFS_FIRST_FREE_OBJECTID)) {
 		u64 local_index;
-		int err;
-		err = btrfs_del_root_ref(trans, key.objectid,
-					 root->root_key.objectid, parent_ino,
-					 &local_index, name, name_len);
+
+		btrfs_del_root_ref(trans, key.objectid,
+				   root->root_key.objectid, parent_ino,
+				   &local_index, name, name_len);
 
 	} else if (add_backref) {
 		u64 local_index;
-		int err;
 
-		err = btrfs_del_inode_ref(trans, root, name, name_len,
-					  ino, parent_ino, &local_index);
+		btrfs_del_inode_ref(trans, root, name, name_len,
+				    ino, parent_ino, &local_index);
 	}
 	return ret;
 }
-- 
2.16.4

