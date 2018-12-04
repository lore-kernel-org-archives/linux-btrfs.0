Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3516DC04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 15:12:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01F69206B7
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 15:12:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 01F69206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbeLDPM0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 10:12:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:59520 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726042AbeLDPMZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Dec 2018 10:12:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4B2DCAF4A
        for <linux-btrfs@vger.kernel.org>; Tue,  4 Dec 2018 15:12:21 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id DC324DAC39; Tue,  4 Dec 2018 16:12:02 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     fdmanana@suse.com, David Sterba <dsterba@suse.com>
Subject: [PATCH 2/2] btrfs: scrub: move scrub_setup_ctx allocation out of device_list_mutex
Date:   Tue,  4 Dec 2018 16:11:56 +0100
Message-Id: <cfd97a36f22e60f29878598673be01f69208fea9.1543935982.git.dsterba@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1543935982.git.dsterba@suse.com>
References: <cover.1543935982.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The scrub context is allocated with GFP_KERNEL and called from
btrfs_scrub_dev under the fs_info::device_list_mutex. This is not safe
regarding reclaim that could try to flush filesystem data in order to
get the memory. And the device_list_mutex is held during superblock
commit, so this would cause a lockup.

Move the alocation and initialization before any changes that require
the mutex.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/scrub.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index ffcab263e057..051d14c9f013 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3834,13 +3834,18 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		return -EINVAL;
 	}
 
+	/* Allocate outside of device_list_mutex */
+	sctx = scrub_setup_ctx(fs_info, is_dev_replace);
+	if (IS_ERR(sctx))
+		return PTR_ERR(sctx);
 
 	mutex_lock(&fs_info->fs_devices->device_list_mutex);
 	dev = btrfs_find_device(fs_info, devid, NULL, NULL);
 	if (!dev || (test_bit(BTRFS_DEV_STATE_MISSING, &dev->dev_state) &&
 		     !is_dev_replace)) {
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out_free_ctx;
 	}
 
 	if (!is_dev_replace && !readonly &&
@@ -3848,7 +3853,8 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 		btrfs_err_in_rcu(fs_info, "scrub: device %s is not writable",
 				rcu_str_deref(dev->name));
-		return -EROFS;
+		ret = -EROFS;
+		goto out_free_ctx;
 	}
 
 	mutex_lock(&fs_info->scrub_lock);
@@ -3856,7 +3862,8 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	    test_bit(BTRFS_DEV_STATE_REPLACE_TGT, &dev->dev_state)) {
 		mutex_unlock(&fs_info->scrub_lock);
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
-		return -EIO;
+		ret = -EIO;
+		goto out_free_ctx;
 	}
 
 	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
@@ -3866,7 +3873,8 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
 		mutex_unlock(&fs_info->scrub_lock);
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
-		return -EINPROGRESS;
+		ret = -EINPROGRESS;
+		goto out_free_ctx;
 	}
 	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
 
@@ -3874,16 +3882,9 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	if (ret) {
 		mutex_unlock(&fs_info->scrub_lock);
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
-		return ret;
+		goto out_free_ctx;
 	}
 
-	sctx = scrub_setup_ctx(fs_info, is_dev_replace);
-	if (IS_ERR(sctx)) {
-		mutex_unlock(&fs_info->scrub_lock);
-		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
-		scrub_workers_put(fs_info);
-		return PTR_ERR(sctx);
-	}
 	sctx->readonly = readonly;
 	dev->scrub_ctx = sctx;
 	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
@@ -3936,6 +3937,11 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 
 	scrub_put_ctx(sctx);
 
+	return ret;
+
+out_free_ctx:
+	scrub_free_ctx(sctx);
+
 	return ret;
 }
 
-- 
2.19.1

