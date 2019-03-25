Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 662E4C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A08B20700
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730011AbfCYSpG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:45:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:38874 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728991AbfCYSpF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 14:45:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D3EC0AF94
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 18:45:04 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 40FC7DA98F; Mon, 25 Mar 2019 19:46:18 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 02/30] btrfs: get fs_info from eb in repair_eb_io_failure
Date:   Mon, 25 Mar 2019 19:46:18 +0100
Message-Id: <3d9623b7d66fa0fbf30d86ad2c1d71dd4e16885c.1553539114.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1553539114.git.dsterba@suse.com>
References: <cover.1553539114.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We can read fs_info from extent buffer and can drop it from the
parameters. As all callsites are updated, add the btrfs_ prefix as the
function is exported.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c   | 2 +-
 fs/btrfs/extent_io.c | 4 ++--
 fs/btrfs/extent_io.h | 3 +--
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5d58dd48342f..db0ed25999fd 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -497,7 +497,7 @@ static int btree_read_extent_buffer_pages(struct btrfs_fs_info *fs_info,
 	}
 
 	if (failed && !ret && failed_mirror)
-		repair_eb_io_failure(fs_info, eb, failed_mirror);
+		btrfs_repair_eb_io_failure(eb, failed_mirror);
 
 	return ret;
 }
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index af720b2c2aeb..a74278187fcd 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2088,9 +2088,9 @@ int repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 start,
 	return 0;
 }
 
-int repair_eb_io_failure(struct btrfs_fs_info *fs_info,
-			 struct extent_buffer *eb, int mirror_num)
+int btrfs_repair_eb_io_failure(struct extent_buffer *eb, int mirror_num)
 {
+	struct btrfs_fs_info *fs_info = eb->fs_info;
 	u64 start = eb->start;
 	int i, num_pages = num_extent_pages(eb);
 	int ret = 0;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 586baed03780..c4ec104ac157 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -502,8 +502,7 @@ int clean_io_failure(struct btrfs_fs_info *fs_info,
 		     struct extent_io_tree *io_tree, u64 start,
 		     struct page *page, u64 ino, unsigned int pg_offset);
 void end_extent_writepage(struct page *page, int err, u64 start, u64 end);
-int repair_eb_io_failure(struct btrfs_fs_info *fs_info,
-			 struct extent_buffer *eb, int mirror_num);
+int btrfs_repair_eb_io_failure(struct extent_buffer *eb, int mirror_num);
 
 /*
  * When IO fails, either with EIO or csum verification fails, we
-- 
2.21.0

