Return-Path: <SRS0=V1nM=WT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59011C3A5A4
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Aug 2019 17:09:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3168F21019
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Aug 2019 17:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733014AbfHWRJO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 23 Aug 2019 13:09:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:54322 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732617AbfHWRIO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Aug 2019 13:08:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EF253ACEC
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2019 17:08:13 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 17BFCDA796; Fri, 23 Aug 2019 19:08:39 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 3/7] btrfs: move private raid56 definitions from ctree.h
Date:   Fri, 23 Aug 2019 19:08:39 +0200
Message-Id: <ab96b3ce62f9ba2e88c48b5cd6cb586faa1f1858.1566579823.git.dsterba@suse.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <cover.1566579823.git.dsterba@suse.com>
References: <cover.1566579823.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h  | 16 ----------------
 fs/btrfs/raid56.c | 16 ++++++++++++++++
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 70d1b9767a96..a7291e7dd574 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -470,22 +470,6 @@ enum btrfs_orphan_cleanup_state {
 	ORPHAN_CLEANUP_DONE	= 2,
 };
 
-/* used by the raid56 code to lock stripes for read/modify/write */
-struct btrfs_stripe_hash {
-	struct list_head hash_list;
-	spinlock_t lock;
-};
-
-/* used by the raid56 code to lock stripes for read/modify/write */
-struct btrfs_stripe_hash_table {
-	struct list_head stripe_cache;
-	spinlock_t cache_lock;
-	int cache_size;
-	struct btrfs_stripe_hash table[];
-};
-
-#define BTRFS_STRIPE_HASH_TABLE_BITS 11
-
 void btrfs_init_async_reclaim_work(struct work_struct *work);
 
 /* fs_info */
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index f3d0576dd327..57a2ac721985 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -35,6 +35,22 @@
 
 #define RBIO_CACHE_SIZE 1024
 
+#define BTRFS_STRIPE_HASH_TABLE_BITS				11
+
+/* Used by the raid56 code to lock stripes for read/modify/write */
+struct btrfs_stripe_hash {
+	struct list_head hash_list;
+	spinlock_t lock;
+};
+
+/* Used by the raid56 code to lock stripes for read/modify/write */
+struct btrfs_stripe_hash_table {
+	struct list_head stripe_cache;
+	spinlock_t cache_lock;
+	int cache_size;
+	struct btrfs_stripe_hash table[];
+};
+
 enum btrfs_rbio_ops {
 	BTRFS_RBIO_WRITE,
 	BTRFS_RBIO_READ_REBUILD,
-- 
2.22.0

