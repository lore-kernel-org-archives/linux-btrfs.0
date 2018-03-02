Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60086 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1947444AbeCBSrP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Mar 2018 13:47:15 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D94C9AE88
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Mar 2018 18:47:13 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 2/8] btrfs-progs: qgroups: fix misleading index check
Date: Fri,  2 Mar 2018 13:46:58 -0500
Message-Id: <20180302184704.22399-3-jeffm@suse.com>
In-Reply-To: <20180302184704.22399-1-jeffm@suse.com>
References: <20180302184704.22399-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

In print_single_qgroup_table we check the loop index against
BTRFS_QGROUP_CHILD, but what we really mean is "last column."  Since
we have an enum value to indicate the last value, use that instead
of assuming that BTRFS_QGROUP_CHILD is always last.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 qgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/qgroup.c b/qgroup.c
index 11659e83..67bc0738 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -267,7 +267,7 @@ static void print_single_qgroup_table(struct btrfs_qgroup *qgroup)
 			continue;
 		print_qgroup_column(qgroup, i);
 
-		if (i != BTRFS_QGROUP_CHILD)
+		if (i != BTRFS_QGROUP_ALL - 1)
 			printf(" ");
 	}
 	printf("\n");
-- 
2.15.1

