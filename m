Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24217 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754827AbbBJK0t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 05:26:49 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1AAQ3Cx000873
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 18:26:03 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 7/9] Btrfs: qgroup: make the btree for qgroup increase from left to right.
Date: Tue, 10 Feb 2015 18:23:21 +0800
Message-ID: <1423563803-8996-10-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1423563803-8996-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1423563803-8996-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's not a big deal, but I would rather make the btree follow the
convention to increase from left to right.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 34717ed..d3c261b 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -117,9 +117,9 @@ static struct btrfs_qgroup *find_qgroup_rb(struct btrfs_fs_info *fs_info,
 	while (n) {
 		qgroup = rb_entry(n, struct btrfs_qgroup, node);
 		if (qgroup->qgroupid < qgroupid)
-			n = n->rb_left;
-		else if (qgroup->qgroupid > qgroupid)
 			n = n->rb_right;
+		else if (qgroup->qgroupid > qgroupid)
+			n = n->rb_left;
 		else
 			return qgroup;
 	}
@@ -139,9 +139,9 @@ static struct btrfs_qgroup *add_qgroup_rb(struct btrfs_fs_info *fs_info,
 		qgroup = rb_entry(parent, struct btrfs_qgroup, node);
 
 		if (qgroup->qgroupid < qgroupid)
-			p = &(*p)->rb_left;
-		else if (qgroup->qgroupid > qgroupid)
 			p = &(*p)->rb_right;
+		else if (qgroup->qgroupid > qgroupid)
+			p = &(*p)->rb_left;
 		else
 			return qgroup;
 	}
-- 
1.8.4.2

