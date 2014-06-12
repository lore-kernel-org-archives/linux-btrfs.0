Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbaFLFO5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jun 2014 01:14:57 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s5C5Eva4022942
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Jun 2014 01:14:57 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s5C5EusA020798
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Jun 2014 01:14:56 -0400
Message-ID: <53993753.6010301@redhat.com>
Date: Thu, 12 Jun 2014 00:14:59 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: free ulist in qgroup_shared_accounting() error path
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If tmp = ulist_alloc(GFP_NOFS) fails, we return without
freeing the previously allocated qgroups = ulist_alloc(GFP_NOFS)
and cause a memory leak.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index cf5aead..98cb6b2 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1798,8 +1798,10 @@ static int qgroup_shared_accounting(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 
 	tmp = ulist_alloc(GFP_NOFS);
-	if (!tmp)
+	if (!tmp) {
+		ulist_free(qgroups);
 		return -ENOMEM;
+	}
 
 	btrfs_get_tree_mod_seq(fs_info, &elem);
 	ret = btrfs_find_all_roots(trans, fs_info, oper->bytenr, elem.seq,

