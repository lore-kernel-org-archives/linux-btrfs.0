Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58920 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415Ab3KARYa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Nov 2013 13:24:30 -0400
Message-Id: <20131101172241.838631078@suse.com>
Date: Fri, 01 Nov 2013 13:07:07 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH 13/13] btrfs: add tracing for failed reservations
References: <20131101170654.164867629@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When debugging ENOSPC issues, it's nice to be able to see which
reservations failed as well as the ones which succeeded.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/btrfs/extent-tree.c	2013-10-21 16:10:02.751981911 -0400
+++ b/fs/btrfs/extent-tree.c	2013-10-21 16:10:04.027953867 -0400
@@ -3699,6 +3699,9 @@ commit_trans:
 			goto again;
 		}
 
+		trace_btrfs_space_reservation(root->fs_info,
+					      "space_info:enospc",
+					      data_sinfo->flags, bytes, 1);
 		return -ENOSPC;
 	}
 	data_sinfo->bytes_may_use += bytes;
@@ -4350,6 +4353,10 @@ out:
 		    !block_rsv_use_bytes(global_rsv, orig_bytes))
 			ret = 0;
 	}
+	if (ret == -ENOSPC)
+		trace_btrfs_space_reservation(root->fs_info,
+					      "space_info:enospc",
+					      space_info->flags, orig_bytes, 1);
 	if (flushing) {
 		spin_lock(&space_info->lock);
 		space_info->flush = 0;



