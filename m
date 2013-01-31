Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:15606 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754270Ab3AaAGj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 19:06:39 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 05/11] btrfs: annotate intentional switch case fallthroughs
Date: Wed, 30 Jan 2013 18:54:56 -0600
Message-Id: <1359593702-53056-6-git-send-email-sandeen@redhat.com>
In-Reply-To: <1359593702-53056-1-git-send-email-sandeen@redhat.com>
References: <1359593702-53056-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This keeps static checkers happy.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/btrfs/ctree.c |    1 +
 fs/btrfs/super.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index eea5da7..ac4a424 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1138,6 +1138,7 @@ __tree_mod_log_rewind(struct extent_buffer *eb, u64 time_seq,
 		switch (tm->op) {
 		case MOD_LOG_KEY_REMOVE_WHILE_FREEING:
 			BUG_ON(tm->slot < n);
+			/* Fallthrough */
 		case MOD_LOG_KEY_REMOVE_WHILE_MOVING:
 		case MOD_LOG_KEY_REMOVE:
 			btrfs_set_node_key(eb, &tm->key, tm->slot);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index d5e7e18..1dd2d86 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -437,6 +437,7 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
 		case Opt_compress_force:
 		case Opt_compress_force_type:
 			compress_force = true;
+			/* Fallthrough */
 		case Opt_compress:
 		case Opt_compress_type:
 			if (token == Opt_compress ||
-- 
1.7.1

