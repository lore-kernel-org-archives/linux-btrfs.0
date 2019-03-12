Return-Path: <SRS0=uY43=RP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0117C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 13:18:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABA692171F
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 13:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbfCLNSw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Mar 2019 09:18:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:46722 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726193AbfCLNSu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Mar 2019 09:18:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DAA0DAE12
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2019 13:18:48 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Correctly free extent buffer in case btree_read_extent_buffer_pages fails
Date:   Tue, 12 Mar 2019 15:18:47 +0200
Message-Id: <20190312131847.20311-1-nborisov@suse.com>
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
This patch was inspired by Qu's "btrfs: Check the first key and level for
cached extent buffer". Though fixing Qu's crash is only a side effect, what  I 
was aiming for is "correct behavior" - in this case immediately remove an eb 
from the eb cache if it's detected broken. This, however, doesn't eliminate 
the need for Qu's patch which adds the parent check in read_block_for_search.
 
I have validated it it using the image from the bugzilla issue and reading 
/MOUNT/foo/bar/stress/f7. Without my patch (or Qu's) it crashes with either of 
them I get: 

cat: scratch/foo/bar/stress/f7: Input/output error

This also survived a full xfstest run with no regressions. 

 fs/btrfs/disk-io.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f7010312d171..03df73de475c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1043,12 +1043,12 @@ int reada_tree_block_flagged(struct btrfs_fs_info *fs_info, u64 bytenr,
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
@@ -1102,7 +1102,7 @@ struct extent_buffer *read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
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

