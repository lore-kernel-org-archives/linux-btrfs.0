Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:39255 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933484Ab2GYPK5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jul 2012 11:10:57 -0400
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH 08/16] btrfs: nuke pdflush from comments
Date: Wed, 25 Jul 2012 18:12:06 +0300
Message-Id: <1343229134-29487-9-git-send-email-artem.bityutskiy@linux.intel.com>
In-Reply-To: <1343229134-29487-1-git-send-email-artem.bityutskiy@linux.intel.com>
References: <1343229134-29487-1-git-send-email-artem.bityutskiy@linux.intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

The pdflush thread is long gone, so this patch removes references to pdflush
from btrfs comments.

Cc: Chris Mason <chris.mason@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---

I expect this patch to be merged via Al Viro's VFS tree.

 fs/btrfs/inode.c        |    3 ++-
 fs/btrfs/ordered-data.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a7d1921..ca8b759 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -324,7 +324,8 @@ static noinline int add_async_extent(struct async_cow *cow,
  * If this code finds it can't get good compression, it puts an
  * entry onto the work queue to write the uncompressed bytes.  This
  * makes sure that both compressed inodes and uncompressed inodes
- * are written in the same order that pdflush sent them down.
+ * are written in the same order that the flusher thread sent them
+ * down.
  */
 static noinline int compress_file_range(struct inode *inode,
 					struct page *locked_page,
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 643335a..051c7fe 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -596,7 +596,7 @@ void btrfs_start_ordered_extent(struct inode *inode,
 	/*
 	 * pages in the range can be dirty, clean or writeback.  We
 	 * start IO on any dirty ones so the wait doesn't stall waiting
-	 * for pdflush to find them
+	 * for the flusher thread to find them
 	 */
 	if (!test_bit(BTRFS_ORDERED_DIRECT, &entry->flags))
 		filemap_fdatawrite_range(inode->i_mapping, start, end);
-- 
1.7.10

