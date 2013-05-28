Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.136]:22032 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934500Ab3E1Prq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 May 2013 11:47:46 -0400
Received: from pizpot.store ([192.168.43.236])
	by jored.store (jored xp2) (RZmta 31.27 OK)
	with ESMTP id g03fe4p4S3rldT for <linux-btrfs@vger.kernel.org>;
	Tue, 28 May 2013 17:47:44 +0200 (CEST)
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] Btrfs: fix memory patcher through fs_info->qgroup_ulist
Date: Tue, 28 May 2013 17:47:22 +0200
Message-Id: <1369756044-17194-2-git-send-email-list.btrfs@jan-o-sch.net>
In-Reply-To: <1369756044-17194-1-git-send-email-list.btrfs@jan-o-sch.net>
References: <1369756044-17194-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 5b7c665e introduced fs_info->qgroup_ulist, that is allocated during
btrfs_read_qgroup_config and meant to be used later by the qgroup accounting
code. However, it is always freed before btrfs_read_qgroup_config returns,
becuase the commit mentioned above adds a check for (ret), where a check
for (ret < 0) would have been the right choice. This commit fixes the check.

Cc: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
---
 fs/btrfs/qgroup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index d059d86..74b432d 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -430,7 +430,7 @@ out:
 	}
 	btrfs_free_path(path);
 
-	if (ret)
+	if (ret < 0)
 		ulist_free(fs_info->qgroup_ulist);
 
 	return ret < 0 ? ret : 0;
-- 
1.7.1

