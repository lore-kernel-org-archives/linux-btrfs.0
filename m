Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22287 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754801AbaCND2h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Mar 2014 23:28:37 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s2E3SBNi013854
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Mar 2014 11:28:11 +0800
From: "quwenruo@cn.fujitsu.com" <quwenruo@cn.fujitsu.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] btrfs-progs: Fix a memleak in btrfs_scan_lblkid().
Date: Fri, 14 Mar 2014 03:28:11 +0000
Message-ID: <1394767760-19929-2-git-send-email-quwenruo@cn.fujitsu.com>
References: <1394767760-19929-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1394767760-19929-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="iso-2022-jp"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs_scan_lblkid(), blkid_get_cache() is called but cache not freed.
This patch adds blkid_put_cache() to free it.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 utils.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/utils.c b/utils.c
index 93cf9ac..b809bc5 100644
--- a/utils.c
+++ b/utils.c
@@ -2067,6 +2067,7 @@ int btrfs_scan_lblkid(int update_kernel)
 			btrfs_register_one_device(path);
 	}
 	blkid_dev_iterate_end(iter);
+	blkid_put_cache(cache);
 	return 0;
 }
 
-- 
1.9.0
