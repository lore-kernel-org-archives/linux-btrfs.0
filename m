Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:40707 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790Ab3GVQwj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jul 2013 12:52:39 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id CF75B7C04E9
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Jul 2013 10:52:38 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id V9OQaKb4X5rgiwkC (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 22 Jul 2013 10:52:38 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: reset ret in record_one_backref
Date: Mon, 22 Jul 2013 12:52:35 -0400
Message-ID: <1374511955-1830-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was getting warnings when running find ./ -type f -exec btrfs fi defrag -f {}
\; from record_one_backref because ret was set.  Turns out it was because it was
set to 1 because the search slot didn't come out exact and we never reset it.
So reset it to 0 right after the search so we don't leak this and get
uneccessary warnings.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/inode.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index dd05238..a3a6155 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2132,6 +2132,7 @@ static noinline int record_one_backref(u64 inum, u64 offset, u64 root_id,
 		WARN_ON(1);
 		return ret;
 	}
+	ret = 0;
 
 	while (1) {
 		cond_resched();
@@ -2181,8 +2182,6 @@ static noinline int record_one_backref(u64 inum, u64 offset, u64 root_id,
 		    old->len || extent_offset + num_bytes <=
 		    old->extent_offset + old->offset)
 			continue;
-
-		ret = 0;
 		break;
 	}
 
-- 
1.7.7.6

