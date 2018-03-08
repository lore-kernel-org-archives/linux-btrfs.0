Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60570 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935151AbeCHClB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 21:41:01 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9A21BAE5D
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 02:41:00 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 02/20] btrfs-progs: qgroups: fix misleading index check
Date: Wed,  7 Mar 2018 21:40:29 -0500
Message-Id: <20180308024047.10104-3-jeffm@suse.com>
In-Reply-To: <20180308024047.10104-1-jeffm@suse.com>
References: <20180308024047.10104-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

In print_single_qgroup_table we check the loop index against
BTRFS_QGROUP_CHILD, but what we really mean is "last column."  Since
we have an enum value to indicate the last value, use that instead
of assuming that BTRFS_QGROUP_CHILD is always last.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
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
2.12.3

