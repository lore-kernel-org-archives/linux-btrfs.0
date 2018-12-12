Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB7FBC65BAF
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 07:42:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C09620849
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 07:42:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9C09620849
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbeLLHmi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 02:42:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:40898 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726519AbeLLHmi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 02:42:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 604D5AED4
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2018 07:42:36 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/3] btrfs: Remove unused arguments from btrfs_get_extent_fiemap
Date:   Wed, 12 Dec 2018 09:42:32 +0200
Message-Id: <20181212074234.20613-2-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20181212074234.20613-1-nborisov@suse.com>
References: <20181212074234.20613-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This function is a simple wrapper over btrfs_get_extent that returns
either:

a) A real extent in the passed range or
b) Adjusted extent based on whether delalloc bytes are found backing up
a hole.

To support these semantics it doesn't need the page/pg_offset/create
arguments which are passed to btrfs_get_extent in case an extent is to
be created. So simplify the function by removing the unused arguments.
No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h     | 3 +--
 fs/btrfs/extent_io.c | 3 +--
 fs/btrfs/file.c      | 3 +--
 fs/btrfs/inode.c     | 6 ++----
 4 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 6520e8e70b09..2dc94698c2fa 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3177,8 +3177,7 @@ void btrfs_extent_item_to_extent_map(struct btrfs_inode *inode,
 
 /* inode.c */
 struct extent_map *btrfs_get_extent_fiemap(struct btrfs_inode *inode,
-		struct page *page, size_t pg_offset, u64 start,
-		u64 len, int create);
+					   u64 start, u64 len);
 noinline int can_nocow_extent(struct inode *inode, u64 offset, u64 *len,
 			      u64 *orig_start, u64 *orig_block_len,
 			      u64 *ram_bytes);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index f7e167ad01c4..2a72a7b5f033 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4236,8 +4236,7 @@ static struct extent_map *get_extent_skip_holes(struct inode *inode,
 		if (len == 0)
 			break;
 		len = ALIGN(len, sectorsize);
-		em = btrfs_get_extent_fiemap(BTRFS_I(inode), NULL, 0, offset,
-				len, 0);
+		em = btrfs_get_extent_fiemap(BTRFS_I(inode), offset, len);
 		if (IS_ERR_OR_NULL(em))
 			return em;
 
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 81aae230d1a5..9b77c3a1b9c6 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3218,8 +3218,7 @@ static int find_desired_extent(struct inode *inode, loff_t *offset, int whence)
 			 &cached_state);
 
 	while (start < inode->i_size) {
-		em = btrfs_get_extent_fiemap(BTRFS_I(inode), NULL, 0,
-				start, len, 0);
+		em = btrfs_get_extent_fiemap(BTRFS_I(inode), start, len);
 		if (IS_ERR(em)) {
 			ret = PTR_ERR(em);
 			em = NULL;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index de912d6e48e6..67eee4d345c9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6961,9 +6961,7 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 }
 
 struct extent_map *btrfs_get_extent_fiemap(struct btrfs_inode *inode,
-		struct page *page,
-		size_t pg_offset, u64 start, u64 len,
-		int create)
+					   u64 start, u64 len)
 {
 	struct extent_map *em;
 	struct extent_map *hole_em = NULL;
@@ -6973,7 +6971,7 @@ struct extent_map *btrfs_get_extent_fiemap(struct btrfs_inode *inode,
 	u64 found_end;
 	int err = 0;
 
-	em = btrfs_get_extent(inode, page, pg_offset, start, len, create);
+	em = btrfs_get_extent(inode, NULL, 0, start, len, 0);
 	if (IS_ERR(em))
 		return em;
 	/*
-- 
2.17.1

