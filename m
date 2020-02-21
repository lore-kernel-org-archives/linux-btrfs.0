Return-Path: <SRS0=i4Ze=4J=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5C66C35656
	for <linux-btrfs@archiver.kernel.org>; Fri, 21 Feb 2020 16:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB4EB20578
	for <linux-btrfs@archiver.kernel.org>; Fri, 21 Feb 2020 16:31:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgBUQbZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 11:31:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:43716 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726032AbgBUQbY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Feb 2020 11:31:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 854E1AEEE;
        Fri, 21 Feb 2020 16:31:23 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 3220FDA70E; Fri, 21 Feb 2020 17:31:06 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 03/11] btrfs: open code trivial helper btrfs_header_fsid
Date:   Fri, 21 Feb 2020 17:31:06 +0100
Message-Id: <bfd3971603fcea97ddf2a25b635966a0a3bc506f.1582302545.git.dsterba@suse.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <cover.1582302545.git.dsterba@suse.com>
References: <cover.1582302545.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The helper btrfs_header_fsid follows naming convention of other struct
accessors but does something compeletly different. As the offsetof
calculation is clear in the context of extent buffer operations we can
remove it.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h   | 5 -----
 fs/btrfs/disk-io.c | 6 ++++--
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index bb237d577725..6f4272006029 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1976,11 +1976,6 @@ static inline void btrfs_set_header_backref_rev(struct extent_buffer *eb,
 	btrfs_set_header_flags(eb, flags);
 }
 
-static inline unsigned long btrfs_header_fsid(void)
-{
-	return offsetof(struct btrfs_header, fsid);
-}
-
 static inline unsigned long btrfs_header_chunk_tree_uuid(const struct extent_buffer *eb)
 {
 	return offsetof(struct btrfs_header, chunk_tree_uuid);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 756bf2ab64cd..63d009816264 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -541,7 +541,8 @@ static int csum_dirty_buffer(struct btrfs_fs_info *fs_info, struct page *page)
 		return -EUCLEAN;
 
 	ASSERT(memcmp_extent_buffer(eb, fs_info->fs_devices->metadata_uuid,
-			btrfs_header_fsid(), BTRFS_FSID_SIZE) == 0);
+				    offsetof(struct btrfs_header, fsid),
+				    BTRFS_FSID_SIZE) == 0);
 
 	if (csum_tree_block(eb, result))
 		return -EINVAL;
@@ -571,7 +572,8 @@ static int check_tree_block_fsid(struct extent_buffer *eb)
 	u8 fsid[BTRFS_FSID_SIZE];
 	int ret = 1;
 
-	read_extent_buffer(eb, fsid, btrfs_header_fsid(), BTRFS_FSID_SIZE);
+	read_extent_buffer(eb, fsid, offsetof(struct btrfs_header, fsid),
+			   BTRFS_FSID_SIZE);
 	while (fs_devices) {
 		u8 *metadata_uuid;
 
-- 
2.25.0

