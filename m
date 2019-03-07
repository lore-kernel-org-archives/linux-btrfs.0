Return-Path: <SRS0=nVQC=RK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6C3CC43381
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 11:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3382720851
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 11:32:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbfCGLcc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Mar 2019 06:32:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:50838 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726203AbfCGLcc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Mar 2019 06:32:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1DB3DBC7A;
        Thu,  7 Mar 2019 11:32:30 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Yoon Jungyeon <jungyeon@gatech.edu>
Subject: [PATCH 4/4] btrfs-progs: disk-io: Try to find a best copy when reading tree blocks
Date:   Thu,  7 Mar 2019 19:32:24 +0800
Message-Id: <20190307113224.27082-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[BUG]
If the first copy of a tree block has a bad key order, but the second
copy is completely good, then "btrfs ins dump-tree -b <bytenr>" fails to
print anything past the bad key:
  leaf 29786112 items 47 free space 983 generation 20 owner EXTENT_TREE
  leaf 29786112 flags 0x1(WRITTEN) backref revision 1
  fs uuid 3381d111-94a3-4ac7-8f39-611bbbdab7e6
  chunk uuid 9af1c3c7-2af5-488b-8553-530bd515f14c
  [snip]
  	item 9 key (20975616 METADATA_ITEM 0) itemoff 3543 itemsize 33
  		refs 1 gen 16 flags TREE_BLOCK
  		tree block skinny level 0
  		tree block backref root CHUNK_TREE
  	item 10 key (29360128 BLOCK_GROUP_ITEM 33554432) itemoff 3519 itemsize 24
  		block group used 94208 chunk_objectid 256 flags METADATA|DUP
  ERROR: leaf 29786112 slot 11 pointer invalid, offset 1245184 size 0 leaf data limit 3995
  ERROR: skip remaining slots

While kernel can locate the good copy and acts just like nothing
happened.

[CAUSE]
btrfs-progs uses read_tree_block() to try each copy. But it only uses
less strict check_tree_block(), which has less sanity check than
btrfs_check_node/leaf().

Some error like bad key order is ignored to allow btrfs check to fix it.

This leads to above problem.

[FIX]
Introduce a new member, @candidate_mirror in read_tree_block(), which
records the copy passes check_tree_block() but fails
btrfs_check_leaf/node() as last chance.

Only if no better copy found, then use @candidate_mirror.

So btrfs-progs can act just like kernel to use best copy.

Reported-by: Yoon Jungyeon <jungyeon@gatech.edu>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=202691
[Inspired by that image, not to fix any bug of that bugzilla]
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 disk-io.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/disk-io.c b/disk-io.c
index 1736d4a1f94b..737f1cdf6f4c 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -327,6 +327,7 @@ struct extent_buffer* read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
 	u32 sectorsize = fs_info->sectorsize;
 	int mirror_num = 1;
 	int good_mirror = 0;
+	int candidate_mirror = 0;
 	int num_copies;
 	int ignore = 0;
 
@@ -362,10 +363,30 @@ struct extent_buffer* read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
 					      &fs_info->recow_ebs);
 				eb->refs++;
 			}
-			btrfs_set_buffer_uptodate(eb);
-			return eb;
+
+			/*
+			 * check_tree_block() is less strict to allow btrfs
+			 * check to get raw eb with bad key order and fix it.
+			 * But we still need to try to get a good copy if
+			 * possible, or bad key order can go into tools like
+			 * btrfs ins dump-tree.
+			 */
+			if (btrfs_header_level(eb))
+				ret = btrfs_check_node(fs_info, NULL, eb);
+			else
+				ret = btrfs_check_leaf(fs_info, NULL, eb);
+			if (!ret || candidate_mirror == mirror_num) {
+				btrfs_set_buffer_uptodate(eb);
+				return eb;
+			}
+			if (candidate_mirror <= 0)
+				candidate_mirror = mirror_num;
 		}
 		if (ignore) {
+			if (candidate_mirror > 0) {
+				mirror_num = candidate_mirror;
+				continue;
+			}
 			if (check_tree_block(fs_info, eb)) {
 				if (!fs_info->suppress_check_block_errors)
 					print_tree_block_error(fs_info, eb,
@@ -387,7 +408,10 @@ struct extent_buffer* read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
 		}
 		mirror_num++;
 		if (mirror_num > num_copies) {
-			mirror_num = good_mirror;
+			if (candidate_mirror > 0)
+				mirror_num = candidate_mirror;
+			else
+				mirror_num = good_mirror;
 			ignore = 1;
 			continue;
 		}
-- 
2.21.0

