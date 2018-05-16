Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52635 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751013AbeEPVjD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 17:39:03 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C7A48ADA7
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 21:39:01 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 02/18] btrfs-progs: qgroups: fix misleading index check
Date: Wed, 16 May 2018 17:38:35 -0400
Message-Id: <20180516213851.10196-3-jeffm@suse.com>
In-Reply-To: <20180516213851.10196-1-jeffm@suse.com>
References: <20180516213851.10196-1-jeffm@suse.com>
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
index 267cd7f1..3269feb2 100644
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

