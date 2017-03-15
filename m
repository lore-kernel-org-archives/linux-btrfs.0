Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40068 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753273AbdCOQD5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Mar 2017 12:03:57 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 918EFADA6
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Mar 2017 16:03:09 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/7] btrfs: remove redundant parameter from btree_readahead_hook
Date: Wed, 15 Mar 2017 17:02:33 +0100
Message-Id: <eec160ff8a025b4580b374a525e678c3457c1a6a.1489593696.git.dsterba@suse.com>
In-Reply-To: <cover.1489593696.git.dsterba@suse.com>
References: <cover.1489593696.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can read fs_info from eb.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h   | 3 +--
 fs/btrfs/disk-io.c | 4 ++--
 fs/btrfs/reada.c   | 4 ++--
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 29b7fc28c607..173fac68323a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3671,8 +3671,7 @@ struct reada_control *btrfs_reada_add(struct btrfs_root *root,
 			      struct btrfs_key *start, struct btrfs_key *end);
 int btrfs_reada_wait(void *handle);
 void btrfs_reada_detach(void *handle);
-int btree_readahead_hook(struct btrfs_fs_info *fs_info,
-			 struct extent_buffer *eb, int err);
+int btree_readahead_hook(struct extent_buffer *eb, int err);
 
 static inline int is_fstree(u64 rootid)
 {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 1d4c30327247..995b28179af9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -762,7 +762,7 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 err:
 	if (reads_done &&
 	    test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags))
-		btree_readahead_hook(fs_info, eb, ret);
+		btree_readahead_hook(eb, ret);
 
 	if (ret) {
 		/*
@@ -787,7 +787,7 @@ static int btree_io_failed_hook(struct page *page, int failed_mirror)
 	eb->read_mirror = failed_mirror;
 	atomic_dec(&eb->io_pages);
 	if (test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags))
-		btree_readahead_hook(eb->fs_info, eb, -EIO);
+		btree_readahead_hook(eb, -EIO);
 	return -EIO;	/* we fixed nothing */
 }
 
diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 4c5a9b241cab..5edf7328f67d 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -209,9 +209,9 @@ static void __readahead_hook(struct btrfs_fs_info *fs_info,
 	return;
 }
 
-int btree_readahead_hook(struct btrfs_fs_info *fs_info,
-			 struct extent_buffer *eb, int err)
+int btree_readahead_hook(struct extent_buffer *eb, int err)
 {
+	struct btrfs_fs_info *fs_info = eb->fs_info;
 	int ret = 0;
 	struct reada_extent *re;
 
-- 
2.12.0

