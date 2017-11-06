Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54183 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933206AbdKFTcp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 14:32:45 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AEC7CABED
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Nov 2017 19:32:44 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 05/10] btrfs: sink get_extent parameter to extent_fiemap
Date: Mon,  6 Nov 2017 20:30:53 +0100
Message-Id: <58a7b0cc2bef9d626c4ad913f97d1c618384d5d2.1509996091.git.dsterba@suse.com>
In-Reply-To: <cover.1509996091.git.dsterba@suse.com>
References: <cover.1509996091.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All callers pass btrfs_get_extent_fiemap and we don't expect anything
else in the context of extent_fiemap.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 6 +++---
 fs/btrfs/extent_io.h | 2 +-
 fs/btrfs/inode.c     | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8f1d98bc11d0..a2815f335d38 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4451,7 +4451,7 @@ static int emit_last_fiemap_cache(struct btrfs_fs_info *fs_info,
 }
 
 int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
-		__u64 start, __u64 len, get_extent_t *get_extent)
+		__u64 start, __u64 len)
 {
 	int ret = 0;
 	u64 off = start;
@@ -4534,7 +4534,7 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			 &cached_state);
 
 	em = get_extent_skip_holes(inode, start, last_for_get_extent,
-				   get_extent);
+				   btrfs_get_extent_fiemap);
 	if (!em)
 		goto out;
 	if (IS_ERR(em)) {
@@ -4623,7 +4623,7 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 
 		/* now scan forward to see if this is really the last extent. */
 		em = get_extent_skip_holes(inode, off, last_for_get_extent,
-					   get_extent);
+					   btrfs_get_extent_fiemap);
 		if (IS_ERR(em)) {
 			ret = PTR_ERR(em);
 			goto out;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index b095aa787857..917b24bc7547 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -413,7 +413,7 @@ int extent_readpages(struct extent_io_tree *tree,
 		     struct list_head *pages, unsigned nr_pages,
 		     get_extent_t get_extent);
 int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
-		__u64 start, __u64 len, get_extent_t *get_extent);
+		__u64 start, __u64 len);
 void set_page_extent_mapped(struct page *page);
 
 struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 31f9552bd78a..588c269bfc13 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8840,7 +8840,7 @@ static int btrfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	if (ret)
 		return ret;
 
-	return extent_fiemap(inode, fieinfo, start, len, btrfs_get_extent_fiemap);
+	return extent_fiemap(inode, fieinfo, start, len);
 }
 
 int btrfs_readpage(struct file *file, struct page *page)
-- 
2.14.3

