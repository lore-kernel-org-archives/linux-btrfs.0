From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 1/3] Btrfs: fix check_path_shared so it returns the right value
Date: Mon, 24 Jan 2011 16:43:18 -0500
Message-ID: <1295905400-1417-2-git-send-email-josef@redhat.com>
References: <1295905400-1417-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1295905400-1417-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

When running xfstests 224 I kept getting ENOSPC when trying to remove the files,
and this is because we were returning ret from check_path_shared while it was
uninitalized, which isn't right.  Fix this to return 0 properly, and now
xfstests 224 doesn't freak out when it tries to clean itself up.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 160b55b..e353da5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2714,9 +2714,10 @@ static int check_path_shared(struct btrfs_root *root,
 	struct extent_buffer *eb;
 	int level;
 	u64 refs = 1;
-	int uninitialized_var(ret);
 
 	for (level = 0; level < BTRFS_MAX_LEVEL; level++) {
+		int ret;
+
 		if (!path->nodes[level])
 			break;
 		eb = path->nodes[level];
@@ -2727,7 +2728,7 @@ static int check_path_shared(struct btrfs_root *root,
 		if (refs > 1)
 			return 1;
 	}
-	return ret; /* XXX callers? */
+	return 0;
 }
 
 /*
-- 
1.6.6.1

