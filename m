Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.137]:24214 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934579Ab3E1Prq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 May 2013 11:47:46 -0400
Received: from pizpot.store ([192.168.43.236])
	by joses.store (joses xp3) (RZmta 31.27 OK)
	with ESMTP id p06cbep4S8RCKo for <linux-btrfs@vger.kernel.org>;
	Tue, 28 May 2013 17:47:44 +0200 (CEST)
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] Btrfs: avoid double free of fs_info->qgroup_ulist
Date: Tue, 28 May 2013 17:47:23 +0200
Message-Id: <1369756044-17194-3-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1369756044-17194-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <1369756044-17194-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When btrfs_read_qgroup_config or btrfs_quota_enable return non-zero, we've
already freed the fs_info->qgroup_ulist. The final btrfs_free_qgroup_config
called from quota_disable makes another ulist_free(fs_info->qgroup_ulist)
call.

We set fs_info->qgroup_ulist to NULL on the mentioned error paths, turning
the ulist_free in btrfs_free_qgroup_config into a noop.

Cc: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/qgroup.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 74b432d..c6ce642 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -430,8 +430,10 @@ out:
 	}
 	btrfs_free_path(path);
 
-	if (ret < 0)
+	if (ret < 0) {
 		ulist_free(fs_info->qgroup_ulist);
+		fs_info->qgroup_ulist = NULL;
+	}
 
 	return ret < 0 ? ret : 0;
 }
@@ -932,8 +934,10 @@ out_free_root:
 		kfree(quota_root);
 	}
 out:
-	if (ret)
+	if (ret) {
 		ulist_free(fs_info->qgroup_ulist);
+		fs_info->qgroup_ulist = NULL;
+	}
 	mutex_unlock(&fs_info->qgroup_ioctl_lock);
 	return ret;
 }
-- 
1.7.1

