Return-Path: <SRS0=/gHX=5T=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2D7DC43331
	for <linux-btrfs@archiver.kernel.org>; Fri,  3 Apr 2020 01:39:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A07E6206A3
	for <linux-btrfs@archiver.kernel.org>; Fri,  3 Apr 2020 01:39:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390213AbgDCBjI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 2 Apr 2020 21:39:08 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12674 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390161AbgDCBjH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Apr 2020 21:39:07 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C7A9EFA304A5E28AE1CB;
        Fri,  3 Apr 2020 09:39:04 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Fri, 3 Apr 2020
 09:38:55 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>,
        <linux-btrfs@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] btrfs: remove set bu not used variable 'ret' and 'features'
Date:   Fri, 3 Apr 2020 09:37:31 +0800
Message-ID: <20200403013731.23229-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.17.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Fix the following gcc warning:

fs/btrfs/sysfs.c:1469:6: warning: variable 'ret' set but not used
[-Wunused-but-set-variable]
  int ret;
      ^~~
fs/btrfs/sysfs.c:1468:6: warning: variable 'features' set but not used
[-Wunused-but-set-variable]
  u64 features;
      ^~~~~~~~
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 fs/btrfs/sysfs.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index a39bff64ff24..eb1e0afa89d3 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -1465,13 +1465,10 @@ void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info,
 {
 	struct btrfs_fs_devices *fs_devs;
 	struct kobject *fsid_kobj;
-	u64 features;
-	int ret;
 
 	if (!fs_info)
 		return;
 
-	features = get_features(fs_info, set);
 	ASSERT(bit & supported_feature_masks[set]);
 
 	fs_devs = fs_info->fs_devices;
@@ -1485,7 +1482,7 @@ void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info,
 	 * to use sysfs_update_group but some refactoring is needed first.
 	 */
 	sysfs_remove_group(fsid_kobj, &btrfs_feature_attr_group);
-	ret = sysfs_create_group(fsid_kobj, &btrfs_feature_attr_group);
+	sysfs_create_group(fsid_kobj, &btrfs_feature_attr_group);
 }
 
 int __init btrfs_init_sysfs(void)
-- 
2.17.2

