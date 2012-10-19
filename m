Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:30929 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757458Ab2JSJv6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Oct 2012 05:51:58 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: list.btrfs@jan-o-sch.net
Subject: [PATCH 4/4] Btrfs: cleanup unused arguments
Date: Fri, 19 Oct 2012 17:50:55 +0800
Message-Id: <1350640255-3760-4-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1350640255-3760-1-git-send-email-bo.li.liu@oracle.com>
References: <1350640255-3760-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

'disk_key' is not used at all.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 235831f..7f649d2 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -772,8 +772,7 @@ tree_mod_log_eb_move(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
 
 static noinline void
 tree_mod_log_set_node_key(struct btrfs_fs_info *fs_info,
-			  struct extent_buffer *eb,
-			  struct btrfs_disk_key *disk_key, int slot, int atomic)
+			  struct extent_buffer *eb, int slot, int atomic)
 {
 	int ret;
 
-- 
1.7.7.6

