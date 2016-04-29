Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58109 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659AbcD2JUn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Apr 2016 05:20:43 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 9BFE2AD6E
	for <linux-btrfs@vger.kernel.org>; Fri, 29 Apr 2016 09:20:36 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 03/16] btrfs: sink gfp parameter to clear_record_extent_bits
Date: Fri, 29 Apr 2016 11:20:23 +0200
Message-Id: <f734c44a1bfffd762f6f5829cb41224d267b80d9.1461920675.git.dsterba@suse.com>
In-Reply-To: <cover.1461920675.git.dsterba@suse.com>
References: <cover.1461920675.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Callers pass GFP_NOFS. No need to pass the flags around.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 5 ++---
 fs/btrfs/extent_io.h | 3 +--
 fs/btrfs/qgroup.c    | 5 ++---
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 2946c1522870..164bda63c5ac 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1308,8 +1308,7 @@ int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 }
 
 int clear_record_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
-			     unsigned bits, gfp_t mask,
-			     struct extent_changeset *changeset)
+		unsigned bits, struct extent_changeset *changeset)
 {
 	/*
 	 * Don't support EXTENT_LOCKED case, same reason as
@@ -1317,7 +1316,7 @@ int clear_record_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 	 */
 	BUG_ON(bits & EXTENT_LOCKED);
 
-	return __clear_extent_bit(tree, start, end, bits, 0, 0, NULL, mask,
+	return __clear_extent_bit(tree, start, end, bits, 0, 0, NULL, GFP_NOFS,
 				  changeset);
 }
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 90c5c8176162..b7c258c9fa2d 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -221,8 +221,7 @@ int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		   unsigned bits, int filled,
 		   struct extent_state *cached_state);
 int clear_record_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
-			     unsigned bits, gfp_t mask,
-			     struct extent_changeset *changeset);
+		unsigned bits, struct extent_changeset *changeset);
 int clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		     unsigned bits, int wake, int delete,
 		     struct extent_state **cached, gfp_t mask);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 9e119552ed32..129392a78986 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2580,8 +2580,7 @@ static int __btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len,
 		return -ENOMEM;
 
 	ret = clear_record_extent_bits(&BTRFS_I(inode)->io_tree, start, 
-			start + len -1, EXTENT_QGROUP_RESERVED, GFP_NOFS,
-			&changeset);
+			start + len -1, EXTENT_QGROUP_RESERVED, &changeset);
 	if (ret < 0)
 		goto out;
 
@@ -2688,7 +2687,7 @@ void btrfs_qgroup_check_reserved_leak(struct inode *inode)
 		return;
 
 	ret = clear_record_extent_bits(&BTRFS_I(inode)->io_tree, 0, (u64)-1,
-			EXTENT_QGROUP_RESERVED, GFP_NOFS, &changeset);
+			EXTENT_QGROUP_RESERVED, &changeset);
 
 	WARN_ON(ret < 0);
 	if (WARN_ON(changeset.bytes_changed)) {
-- 
2.7.1

