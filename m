Return-Path: <SRS0=y5XK=V5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FEE5C433FF
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Aug 2019 12:49:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1847E20665
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Aug 2019 12:49:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731472AbfHAMt6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 1 Aug 2019 08:49:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:34450 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731420AbfHAMt5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Aug 2019 08:49:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E3861ADF1
        for <linux-btrfs@vger.kernel.org>; Thu,  1 Aug 2019 12:49:56 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 18B83DA7D9; Thu,  1 Aug 2019 14:50:30 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 1/3] btrfs: tree-log: convert defines to enums
Date:   Thu,  1 Aug 2019 14:50:30 +0200
Message-Id: <95ac11cd7b04e4ea49cbdc53c6541a5de3539746.1564663765.git.dsterba@suse.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <cover.1564663765.git.dsterba@suse.com>
References: <cover.1564663765.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Used only for in-memory state tracking.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/tree-log.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 6c8297bcfeb7..5513e76cc336 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -24,10 +24,12 @@
  * LOG_INODE_EXISTS means to log just enough to recreate the inode
  * during log replay
  */
-#define LOG_INODE_ALL 0
-#define LOG_INODE_EXISTS 1
-#define LOG_OTHER_INODE 2
-#define LOG_OTHER_INODE_ALL 3
+enum {
+	LOG_INODE_ALL,
+	LOG_INODE_EXISTS,
+	LOG_OTHER_INODE,
+	LOG_OTHER_INODE_ALL,
+};
 
 /*
  * directory trouble cases
@@ -81,10 +83,12 @@
  * The last stage is to deal with directories and links and extents
  * and all the other fun semantics
  */
-#define LOG_WALK_PIN_ONLY 0
-#define LOG_WALK_REPLAY_INODES 1
-#define LOG_WALK_REPLAY_DIR_INDEX 2
-#define LOG_WALK_REPLAY_ALL 3
+enum {
+	LOG_WALK_PIN_ONLY,
+	LOG_WALK_REPLAY_INODES,
+	LOG_WALK_REPLAY_DIR_INDEX,
+	LOG_WALK_REPLAY_ALL,
+};
 
 static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, struct btrfs_inode *inode,
-- 
2.22.0

