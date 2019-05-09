Return-Path: <SRS0=cuF+=TJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1882BC04AB1
	for <linux-btrfs@archiver.kernel.org>; Thu,  9 May 2019 15:11:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFEA820989
	for <linux-btrfs@archiver.kernel.org>; Thu,  9 May 2019 15:11:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbfEIPLR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 9 May 2019 11:11:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:35126 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726234AbfEIPLQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 9 May 2019 11:11:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DBA61AC58;
        Thu,  9 May 2019 15:11:15 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2] btrfs: Add comments on locking of several device-related fields
Date:   Thu,  9 May 2019 18:11:11 +0300
Message-Id: <20190509151111.12203-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190509135550.GS20156@twin.jikos.cz>
References: <20190509135550.GS20156@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

V2: 
 * Document post_commit_list is protected by chunk_mutex in the "Device Locking"
 section. 

 fs/btrfs/volumes.c |  4 +++-
 fs/btrfs/volumes.h | 11 ++++++++---
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b85ff32f851c..83603be86891 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -237,7 +237,9 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
  * chunk_mutex
  * -----------
  * protects chunks, adding or removing during allocation, trim or when a new
- * device is added/removed
+ * device is added/removed. Additionally it also protects post_commit_list of
+ * individual devices, since they can be added to the transaction's
+ * post_commit_list only with chunk_mutex held.
  *
  * cleaner_mutex
  * -------------
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 3b97e8092ba7..514799362244 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -52,8 +52,8 @@ struct btrfs_io_geometry {
 #define BTRFS_DEV_STATE_FLUSH_SENT	(4)
 
 struct btrfs_device {
-	struct list_head dev_list;
-	struct list_head dev_alloc_list;
+	struct list_head dev_list; /* device_list_mutex */
+	struct list_head dev_alloc_list; /* chunk mutex */
 	struct list_head post_commit_list; /* chunk mutex */
 	struct btrfs_fs_devices *fs_devices;
 	struct btrfs_fs_info *fs_info;
@@ -238,9 +238,14 @@ struct btrfs_fs_devices {
 	 * this mutex lock.
 	 */
 	struct mutex device_list_mutex;
+
+	/* List of all devices, protected by device_list_mutex */
 	struct list_head devices;
 
-	/* devices not currently being allocated */
+	/*
+	 * Devices which can satisfy space allocation. Protected by
+	 * chunk_mutex
+	 */
 	struct list_head alloc_list;
 
 	struct btrfs_fs_devices *seed;
-- 
2.17.1

