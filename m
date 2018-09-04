Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:13677 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726087AbeIDRHO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Sep 2018 13:07:14 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 2CE5F4B5CBE6
        for <linux-btrfs@vger.kernel.org>; Tue,  4 Sep 2018 20:42:08 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: calibrate extent_end when found a gap
Date: Tue, 4 Sep 2018 20:42:01 +0800
Message-ID: <20180904124201.3287-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The extent_end will be used to check whether there is gap between this
extent and next extent. If it is not calibrated, check_file_extent will
mistake that there are gaps between the remaining extents.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 check/mode-lowmem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 1bce44f5658a..0f14a4968e84 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -1972,6 +1972,7 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_path *path,
 				root->objectid, fkey.objectid, fkey.offset,
 				fkey.objectid, *end);
 		}
+		*end = fkey.offset;
 	}
 
 	*end += extent_num_bytes;
-- 
2.18.0
