Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2433 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751196AbbHYGMr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 02:12:47 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7P6CdvZ015252
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2015 14:12:39 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: add missing free operation of raid_map for raid56
Date: Tue, 25 Aug 2015 14:11:07 +0800
Message-ID: <8cbfc51dba83890b0e7e22ef2f9985674294c41f.1440483058.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We forgot free raid_map for raid56's map_bio.
This patch add it.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 disk-io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/disk-io.c b/disk-io.c
index fdcfd6d..46a5a46 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -428,6 +428,7 @@ int write_and_map_eb(struct btrfs_trans_handle *trans,
 		ret = write_extent_to_disk(eb);
 		BUG_ON(ret);
 	}
+	kfree(raid_map);
 	kfree(multi);
 	return 0;
 }
-- 
1.8.5.1

