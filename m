From: Joel Becker <joel.becker@oracle.com>
Subject: [PATCH 2/2] btrfs: Fix a trivial warning using max() of u64 vs ULL.
Date: Tue, 21 Apr 2009 12:38:30 -0700
Message-ID: <1240342710-19009-3-git-send-email-joel.becker@oracle.com>
References: <1240342710-19009-1-git-send-email-joel.becker@oracle.com>
Cc: chris.mason@oracle.com, lmb@suse.de
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1240342710-19009-1-git-send-email-joel.becker@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

A small warning popped up on ia64 because inode-map.c was comparing a
u64 object id with the ULL FIRST_FREE_OBJECTID.  My first thought was
that all the OBJECTID constants should contain the u64 cast because
btrfs code deals entirely in u64s.  But then I saw how large that was,
and figured I'd just fix the max() call.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
---
 fs/btrfs/inode-map.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index cc7334d..9abbced 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -79,7 +79,7 @@ int btrfs_find_free_objectid(struct btrfs_trans_handle *trans,
 	}
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
-	search_start = max(search_start, BTRFS_FIRST_FREE_OBJECTID);
+	search_start = max(search_start, (u64)BTRFS_FIRST_FREE_OBJECTID);
 	search_key.objectid = search_start;
 	search_key.type = 0;
 	search_key.offset = 0;
-- 
1.5.6.5

