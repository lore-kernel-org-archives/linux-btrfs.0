From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] Btrfs: fix bitwise vs logical condition
Date: Fri, 20 Jan 2012 10:54:55 +0300
Message-ID: <20120120075454.GA2295@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>,
	Ilya Dryomov <idryomov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The intent here was to do a logical && instead of a bitwise &.  The
original condition tests whether they have the some of same bits set.
I have fixed that and rewritten it to be more clear.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Warning:  This is a static analysis bug and I'm not very familiar with
the code.  Please review carefully.

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0b4e2af..0c54027 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2376,8 +2376,8 @@ static int should_balance_chunk(struct btrfs_root *root,
 	u64 chunk_type = btrfs_chunk_type(leaf, chunk);
 
 	/* type filter */
-	if (!((chunk_type & BTRFS_BLOCK_GROUP_TYPE_MASK) &
-	      (bctl->flags & BTRFS_BALANCE_TYPE_MASK))) {
+	if (!(chunk_type & BTRFS_BLOCK_GROUP_TYPE_MASK) ||
+	    !(bctl->flags & BTRFS_BALANCE_TYPE_MASK)) {
 		return 0;
 	}
 
