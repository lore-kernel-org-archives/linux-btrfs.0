Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:30650 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751130AbeBHDW6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Feb 2018 22:22:58 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 43A9248AE767
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Feb 2018 11:22:56 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v4 01/18] btrfs-progs: lowmem check: release path in repair_extent_data_item()
Date: Thu, 8 Feb 2018 11:27:20 +0800
Message-ID: <20180208032737.31561-2-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180208032737.31561-1-suy.fnst@cn.fujitsu.com>
References: <20180208032737.31561-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In repair_extent_data_item(), path is not be released if some
errors occurs which causes extent buffer leak.

So release path in end of the function.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 check/mode-lowmem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 62bcf3d2e126..d168a3ddd5e5 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -2537,6 +2537,7 @@ static int repair_extent_data_item(struct btrfs_trans_handle *trans,
 
 	err &= ~BACKREF_MISSING;
 out:
+	btrfs_release_path(&path);
 	if (ret)
 		error("can't repair root %llu extent data item[%llu %llu]",
 		      root->objectid, disk_bytenr, num_bytes);
-- 
2.16.1



