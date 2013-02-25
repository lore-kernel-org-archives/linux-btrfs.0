Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:2731 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759578Ab3BYVzR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 16:55:17 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 14/17] btrfs-progs: fix mem leak in resolve_root
Date: Mon, 25 Feb 2013 16:54:47 -0600
Message-Id: <1361832890-40921-15-git-send-email-sandeen@redhat.com>
In-Reply-To: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we exit with error we must free the allocated memory
to avoid a leak.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 btrfs-list.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 851c059..8c3f84d 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -568,8 +568,10 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri,
 		* ref_tree = 0 indicates the subvolumes
 		* has been deleted.
 		*/
-		if (!found->ref_tree)
+		if (!found->ref_tree) {
+			free(full_path);
 			return -ENOENT;
+		}
 		int add_len = strlen(found->path);
 
 		/* room for / and for null */
@@ -612,8 +614,10 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri,
 		* subvolume was deleted.
 		*/
 		found = root_tree_search(rl, next);
-		if (!found)
+		if (!found) {
+			free(full_path);
 			return -ENOENT;
+		}
 	}
 
 	ri->full_path = full_path;
-- 
1.7.1

