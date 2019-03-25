Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43F82C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 12:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1428B2085A
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 12:31:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731190AbfCYMbo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 08:31:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:55604 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731158AbfCYMbl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 08:31:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A2FD6AD38
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 12:31:40 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v3 06/12] btrfs: Introduce new bits for device allocation tree
Date:   Mon, 25 Mar 2019 14:31:26 +0200
Message-Id: <20190325123132.27835-7-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190325123132.27835-1-nborisov@suse.com>
References: <20190325123132.27835-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Rather than hijacking the existing defines let's just define new bits,
with more descriptive names. Instead of using yet more (currently at 18)
bits for the new flags, use the fact those flags will be specific to
the device allocation tree so define them using existing EXTENT_* flags.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/disk-io.c   | 2 +-
 fs/btrfs/extent_io.h | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 80f0787eb278..81183694f8ea 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4055,8 +4055,8 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 		btrfsic_unmount(fs_info->fs_devices);
 #endif
 
-	btrfs_close_devices(fs_info->fs_devices);
 	btrfs_mapping_tree_free(&fs_info->mapping_tree);
+	btrfs_close_devices(fs_info->fs_devices);
 
 	percpu_counter_destroy(&fs_info->dirty_metadata_bytes);
 	percpu_counter_destroy(&fs_info->delalloc_bytes);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 7732b6a7384d..0fda249e5982 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -27,6 +27,10 @@
 				 EXTENT_CLEAR_DATA_RESV)
 #define EXTENT_CTLBITS		(EXTENT_DO_ACCOUNTING)
 
+
+/* Redefined bits above which are used only in the device allocation tree */
+#define CHUNK_ALLOCATED EXTENT_DIRTY
+
 /*
  * flags for bio submission. The high bits indicate the compression
  * type for this bio
-- 
2.17.1

