Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21862 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752179AbbJZGN0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Oct 2015 02:13:26 -0400
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9Q6ClQ5006256
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Oct 2015 14:12:51 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs: qgroup: Fix a rebase bug which will cause qgroup double free
Date: Mon, 26 Oct 2015 14:11:19 +0800
Message-Id: <1445839879-17716-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1445839879-17716-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1445839879-17716-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When rebasing my patchset, I forgot to pick up a cleanup patch to remove
old hotfix in 4.2 release.

Witouth the cleanup, it will screw up new qgroup reserve framework and
always cause minus reserved number.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 158633c..7664a63 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1652,10 +1652,6 @@ static int qgroup_update_counters(struct btrfs_fs_info *fs_info,
 			}
 		}
 
-		/* For exclusive extent, free its reserved bytes too */
-		if (nr_old_roots == 0 && nr_new_roots == 1 &&
-		    cur_new_count == nr_new_roots)
-			qg->reserved -= num_bytes;
 		if (dirty)
 			qgroup_dirty(fs_info, qg);
 	}
-- 
2.6.2

