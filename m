Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:20348 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759609Ab3BYVzS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 16:55:18 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 15/17] btrfs-progs: Tidy up resolve_root
Date: Mon, 25 Feb 2013 16:54:48 -0600
Message-Id: <1361832890-40921-16-git-send-email-sandeen@redhat.com>
In-Reply-To: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Whitespace fixes and fix a variable declaration after
code.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 btrfs-list.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 8c3f84d..a748d5e 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -564,15 +564,18 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri,
 	while (1) {
 		char *tmp;
 		u64 next;
+		int add_len;
+
 		/*
-		* ref_tree = 0 indicates the subvolumes
-		* has been deleted.
-		*/
+		 * ref_tree = 0 indicates the subvolumes
+		 * has been deleted.
+		 */
 		if (!found->ref_tree) {
 			free(full_path);
 			return -ENOENT;
 		}
-		int add_len = strlen(found->path);
+
+		add_len = strlen(found->path);
 
 		/* room for / and for null */
 		tmp = malloc(add_len + 2 + len);
@@ -595,7 +598,7 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri,
 
 		next = found->ref_tree;
 
-		if (next ==  top_id) {
+		if (next == top_id) {
 			ri->top_id = top_id;
 			break;
 		}
-- 
1.7.1

