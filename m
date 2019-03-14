Return-Path: <SRS0=qFN0=RR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87E10C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 07:52:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 550A92087C
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 07:52:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfCNHwm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Mar 2019 03:52:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:45862 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726624AbfCNHwm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Mar 2019 03:52:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 05EBBACC5
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2019 07:52:41 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2] btrfs: Correctly free extent buffer in case btree_read_extent_buffer_pages fails
Date:   Thu, 14 Mar 2019 09:52:35 +0200
Message-Id: <20190314075235.22797-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

If a an eb fails to be read for whatever reason - it's corrupted on disk
and parent transid/key validations fail or IO for eb pages fail then
this buffer must be removed from the buffer cache. Currently the code
calls free_extent_buffer if an error occurs. Unfortunately this doesn't
achieve the desired behavior since btrfs_find_create_tree_block returns
with eb->refs == 2. On the other hand free_extent_buffer will only
decrement the refs once leavin it added to the buffer cache radix tree.
This enables later code to look up the buffer from the cache and utilize
it potentially leading to a crash.

The correct way to free the buffer is call free_extent_buffer_stale.
This function will correctly call atomic_dec explicitly for the buffer
and subsequently call release_extent_buffer which will decrement the
final reference thus correctly remove the invalid buffer from buffer
cache. This change affects only newly allocated buffers since they have
eb->refs == 2.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=202755
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

Changes since v1: 
 * Immediately remove a corrupted extent buffer from readahead_tree_block as 
 well. 

 fs/btrfs/disk-io.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f7010312d171..9dda16c27255 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1021,9 +1021,12 @@ void readahead_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr)
 	buf = btrfs_find_create_tree_block(fs_info, bytenr);
 	if (IS_ERR(buf))
 		return;
-	read_extent_buffer_pages(&BTRFS_I(btree_inode)->io_tree,
-				 buf, WAIT_NONE, 0);
-	free_extent_buffer(buf);
+
+	if (read_extent_buffer_pages(&BTRFS_I(btree_inode)->io_tree,
+				 buf, WAIT_NONE, 0))
+		free_extent_buffer_stale(buf);
+	else
+		free_extent_buffer(buf);
 }
 
 int reada_tree_block_flagged(struct btrfs_fs_info *fs_info, u64 bytenr,
@@ -1043,12 +1046,12 @@ int reada_tree_block_flagged(struct btrfs_fs_info *fs_info, u64 bytenr,
 	ret = read_extent_buffer_pages(io_tree, buf, WAIT_PAGE_LOCK,
 				       mirror_num);
 	if (ret) {
-		free_extent_buffer(buf);
+		free_extent_buffer_stale(buf);
 		return ret;
 	}
 
 	if (test_bit(EXTENT_BUFFER_CORRUPT, &buf->bflags)) {
-		free_extent_buffer(buf);
+		free_extent_buffer_stale(buf);
 		return -EIO;
 	} else if (extent_buffer_uptodate(buf)) {
 		*eb = buf;
@@ -1102,7 +1105,7 @@ struct extent_buffer *read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
 	ret = btree_read_extent_buffer_pages(fs_info, buf, parent_transid,
 					     level, first_key);
 	if (ret) {
-		free_extent_buffer(buf);
+		free_extent_buffer_stale(buf);
 		return ERR_PTR(ret);
 	}
 	return buf;
-- 
2.17.1

