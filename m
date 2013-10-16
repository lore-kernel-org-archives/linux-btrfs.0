Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55206 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761410Ab3JPU1F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Oct 2013 16:27:05 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id E2409A57B3
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Oct 2013 22:27:04 +0200 (CEST)
Message-ID: <525EF695.9020307@suse.com>
Date: Wed, 16 Oct 2013 16:27:01 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: add tracing for failed reservations
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When debugging ENOSPC issues, it's nice to be able to see which
reservations failed as well as the ones which succeeded.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/btrfs/extent-tree.c	2013-10-13 18:41:28.000000000 -0400
+++ b/fs/btrfs/extent-tree.c	2013-10-16 16:23:27.986639216 -0400
@@ -3681,6 +3681,9 @@ commit_trans:
 			goto again;
 		}
 
+		trace_btrfs_space_reservation(root->fs_info,
+					      "space_info:enospc",
+					      data_sinfo->flags, bytes, 1);
 		return -ENOSPC;
 	}
 	data_sinfo->bytes_may_use += bytes;
@@ -4332,6 +4335,10 @@ out:
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

-- 
Jeff Mahoney
SUSE Labs
