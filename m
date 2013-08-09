Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030942Ab3HIUhX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Aug 2013 16:37:23 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r79KbN9D020346
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 9 Aug 2013 16:37:23 -0400
Received: from lenny.home.zabbo.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r79KbNvj001231
	for <linux-btrfs@vger.kernel.org>; Fri, 9 Aug 2013 16:37:23 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: brelse in error path in open_ctree
Date: Fri,  9 Aug 2013 13:37:13 -0700
Message-Id: <1376080634-1714-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Commit 1104a8855 added an error branch that forgot to release the super
bh.  I found this while looking for an unrelated double brelse.

Signed-off-by: Zach Brown <zab@redhat.com>
---
 fs/btrfs/disk-io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 254cdc8..ca1e25f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2329,6 +2329,7 @@ int open_ctree(struct super_block *sb,
 	if (btrfs_check_super_csum(bh->b_data)) {
 		printk(KERN_ERR "btrfs: superblock checksum mismatch\n");
 		err = -EINVAL;
+		brelse(bh);
 		goto fail_alloc;
 	}
 
-- 
1.7.11.7

