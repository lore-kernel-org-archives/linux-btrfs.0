From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: [PATCH] print parent ID in btrfs suvolume list
Date: Mon, 13 Jun 2011 09:29:52 +0200
Message-ID: <1307950192-15691-1-git-send-email-philipp.andreas@gmail.com>
Cc: Andreas Philipp <philipp.andreas@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

There was some discussion on "where" subvolumes live in. Why do we not
simply print the parent ID for each subvolume in btrfs subvolume list.
This patch adds this functionality.

Signed-off-by: Andreas Philipp <philipp.andreas@gmail.com>
---
 btrfs-list.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index f804dfc..a57ec4c 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -203,6 +203,7 @@ static int add_root(struct root_lookup *root_lookup,
 static int resolve_root(struct root_lookup *rl, struct root_info *ri)
 {
 	u64 top_id;
+	u64 parent_id = 0;
 	char *full_path = NULL;
 	int len = 0;
 	struct root_info *found;
@@ -233,6 +234,11 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri)
 		}
 
 		next = found->ref_tree;
+		/* record the first parent */
+		if ( parent_id == 0 ) {
+			parent_id = next;
+		}
+
 		/* if the ref_tree refers to ourselves, we're at the top */
 		if (next == found->root_id) {
 			top_id = next;
@@ -249,8 +255,8 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri)
 			break;
 		}
 	}
-	printf("ID %llu top level %llu path %s\n",
-	       (unsigned long long)ri->root_id, (unsigned long long)top_id,
+	printf("ID %llu parent %llu top level %llu path %s\n",
+	       (unsigned long long)ri->root_id, (unsigned long long) parent_id, (unsigned long long)top_id,
 	       full_path);
 	free(full_path);
 	return 0;
-- 
1.7.3.4

