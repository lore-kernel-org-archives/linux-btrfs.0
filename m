Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31851 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751875AbdHGW4t (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Aug 2017 18:56:49 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v77MunPi019808
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 7 Aug 2017 22:56:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v77MumhZ002245
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 7 Aug 2017 22:56:48 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v77MumHF009718
        for <linux-btrfs@vger.kernel.org>; Mon, 7 Aug 2017 22:56:48 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 6/7] Btrfs: remove BUG_ON in __add_tree_block
Date: Mon,  7 Aug 2017 15:55:30 -0600
Message-Id: <20170807215531.12423-7-bo.li.liu@oracle.com>
In-Reply-To: <20170807215531.12423-1-bo.li.liu@oracle.com>
References: <20170807215531.12423-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The BUG_ON() can be triggered when the caller is processing an invalid
extent inline ref, e.g.

a shared data ref is offered instead of a extent data ref, such that
it tries to find a non-exist tree block and then btrfs_search_slot
returns 1 for no such item.

This replaces the BUG_ON() with a WARN() followed by calling
btrfs_print_leaf() to show more details about what's going on and
returning -EINVAL to upper callers.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/relocation.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 4806e78..cc6150e 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -32,6 +32,7 @@
 #include "free-space-cache.h"
 #include "inode-map.h"
 #include "qgroup.h"
+#include "print-tree.h"
 
 /*
  * backref_node, mapping_node and tree_block start with this
@@ -3485,7 +3486,15 @@ static int __add_tree_block(struct reloc_control *rc,
 			goto again;
 		}
 	}
-	BUG_ON(ret);
+	if (ret) {
+		ASSERT(ret == 1);
+		btrfs_print_leaf(rc->extent_root->fs_info, path->nodes[0]);
+		WARN(1,
+	     "tree block extent item (%llu) is not found in extent tree\n",
+		     bytenr);
+		ret = -EINVAL;
+		goto out;
+	}
 
 	ret = add_tree_block(rc, &key, path, blocks);
 out:
-- 
2.9.4

