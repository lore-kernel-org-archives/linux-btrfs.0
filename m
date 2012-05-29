Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755877Ab2E2U56 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 May 2012 16:57:58 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q4TKvvHJ029527
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2012 16:57:58 -0400
Received: from localhost.localdomain.com (vpn-10-107.rdu.redhat.com [10.11.10.107])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q4TKvvqS002847
	for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2012 16:57:57 -0400
From: Josef Bacik <josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix return code in drop_objectid_items
Date: Tue, 29 May 2012 16:57:56 -0400
Message-Id: <1338325076-9203-1-git-send-email-josef@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So dpkg fsync()'s the file and the directory containing the file whenever it
writes to a file which is really slow in btrfs.  This is partly because
fsync()'ing a directory _always_ committed the transaction instead of just
going to the tree log.  This is because drop_objectid_items() would return 1
since it does a btrfs_search_slot() which returns 1.  In tree-log jargon
this means that we have to commit the transaction to be safe.  So just check
if ret is greater than 0 and set it to 0 if it does.  With this patch we now
use the tree-log instead of committing the entire transaction, which is
twice as fast on my box.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/tree-log.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 425014b..2017d0f 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2667,6 +2667,8 @@ static int drop_objectid_items(struct btrfs_trans_handle *trans,
 		btrfs_release_path(path);
 	}
 	btrfs_release_path(path);
+	if (ret > 0)
+		ret = 0;
 	return ret;
 }
 
-- 
1.7.7.6

