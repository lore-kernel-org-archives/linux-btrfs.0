From: Hugo Mills <hugo@carfax.org.uk>
Subject: [PATCH] btrfs: Ensure the tree search ioctl returns the right number of records
Date: Sat, 14 May 2011 18:43:41 +0100
Message-ID: <1305395021-8862-1-git-send-email-hugo@carfax.org.uk>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs's tree search ioctl has a field to indicate that no more than a
given number of records should be returned. The ioctl doesn't honour
this, as the tested value is not incremented until the end of the
copy_to_sk function. This patch removes an unnecessary local variable,
and updates the num_found counter as each key is found in the tree.

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 fs/btrfs/ioctl.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f580a3a..4bc0b79 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1273,7 +1273,6 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 	int nritems;
 	int i;
 	int slot;
-	int found = 0;
 	int ret = 0;
 
 	leaf = path->nodes[0];
@@ -1320,7 +1319,7 @@ static noinline int copy_to_sk(struct btrfs_root *root,
 					   item_off, item_len);
 			*sk_offset += item_len;
 		}
-		found++;
+		(*num_found)++;
 
 		if (*num_found >= sk->nr_items)
 			break;
@@ -1339,7 +1338,6 @@ advance_key:
 	} else
 		ret = 1;
 overflow:
-	*num_found += found;
 	return ret;
 }
 
-- 
1.7.2.5

