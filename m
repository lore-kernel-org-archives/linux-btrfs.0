Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:45585 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751928AbeEKUOD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 16:14:03 -0400
Received: by mail-pg0-f66.google.com with SMTP id w3-v6so2862155pgv.12
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 13:14:03 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>, David Sterba <dsterba@suse.com>
Subject: [PATCH v4 11/12] Btrfs: renumber BTRFS_INODE_ runtime flags
Date: Fri, 11 May 2018 13:13:39 -0700
Message-Id: <c69fd5cb94b60d6b0d9e422c2340f70b3e3d3914.1526069051.git.osandov@fb.com>
In-Reply-To: <cover.1526069051.git.osandov@fb.com>
References: <cover.1526069051.git.osandov@fb.com>
In-Reply-To: <cover.1526069051.git.osandov@fb.com>
References: <cover.1526069051.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

We got rid of BTRFS_INODE_HAS_ORPHAN_ITEM and
BTRFS_INODE_ORPHAN_META_RESERVED, so we can renumber the flags to make
them consecutive again.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/btrfs_inode.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 4807cde0313d..bbbe7f308d68 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -20,14 +20,14 @@
  * new data the application may have written before commit.
  */
 #define BTRFS_INODE_ORDERED_DATA_CLOSE		0
-#define BTRFS_INODE_DUMMY			2
-#define BTRFS_INODE_IN_DEFRAG			3
-#define BTRFS_INODE_HAS_ASYNC_EXTENT		5
-#define BTRFS_INODE_NEEDS_FULL_SYNC		6
-#define BTRFS_INODE_COPY_EVERYTHING		7
-#define BTRFS_INODE_IN_DELALLOC_LIST		8
-#define BTRFS_INODE_READDIO_NEED_LOCK		9
-#define BTRFS_INODE_HAS_PROPS		        10
+#define BTRFS_INODE_DUMMY			1
+#define BTRFS_INODE_IN_DEFRAG			2
+#define BTRFS_INODE_HAS_ASYNC_EXTENT		3
+#define BTRFS_INODE_NEEDS_FULL_SYNC		4
+#define BTRFS_INODE_COPY_EVERYTHING		5
+#define BTRFS_INODE_IN_DELALLOC_LIST		6
+#define BTRFS_INODE_READDIO_NEED_LOCK		7
+#define BTRFS_INODE_HAS_PROPS		        8
 
 /* in memory btrfs inode */
 struct btrfs_inode {
-- 
2.17.0

