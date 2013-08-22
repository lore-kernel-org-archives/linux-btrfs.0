Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:46423 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab3HVVFD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Aug 2013 17:05:03 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 740367C034A
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Aug 2013 15:05:02 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx1.fusionio.com with ESMTP id zyUyVA5mk4CHcxTU (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 22 Aug 2013 15:05:01 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: remove ourselves from the cluster list under lock
Date: Thu, 22 Aug 2013 17:04:59 -0400
Message-ID: <1377205499-14790-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A user was reporting weird warnings from btrfs_put_delayed_ref() and I noticed
that we were doing this list_del_init() on our head ref outside of
delayed_refs->lock.  This is a problem if we have people still on the list, we
could end up modifying old pointers and such.  Fix this by removing us from the
list before we do our run_delayed_ref on our head ref.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4c89566..95c6539 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2440,6 +2440,8 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 			default:
 				WARN_ON(1);
 			}
+		} else {
+			list_del_init(&locked_ref->cluster);
 		}
 		spin_unlock(&delayed_refs->lock);
 
@@ -2462,7 +2464,6 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 		 * list before we release it.
 		 */
 		if (btrfs_delayed_ref_is_head(ref)) {
-			list_del_init(&locked_ref->cluster);
 			btrfs_delayed_ref_unlock(locked_ref);
 			locked_ref = NULL;
 		}
-- 
1.7.7.6

