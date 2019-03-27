Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06F82C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 12:24:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D43972087C
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 12:24:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729119AbfC0MY1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 08:24:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:55254 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728691AbfC0MYY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 08:24:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BDCE8AF79
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2019 12:24:23 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v4 08/15] btrfs: Stop using call_rcu for device freeing
Date:   Wed, 27 Mar 2019 14:24:11 +0200
Message-Id: <20190327122418.24027-9-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190327122418.24027-1-nborisov@suse.com>
References: <20190327122418.24027-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

btrfs_device structs are freed from RCU context since device iteration
is protected by RCU. Currently this is achieved by using call_rcu since
no blocking functions are called within btrfs_free_device. Future
refactoring of pending/pinned chunks will require calling sleeping
functions. This patch is in preparation for these changes by simply
switching from RCU callbacks to explicit calls of synchronize_rcu and
calling btrfs_free_device directly.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.c | 20 ++++++++------------
 fs/btrfs/volumes.h |  1 -
 2 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d2d37adbc6fd..90eff8452c31 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1230,14 +1230,6 @@ void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices, int step)
 	mutex_unlock(&uuid_mutex);
 }
 
-static void free_device_rcu(struct rcu_head *head)
-{
-	struct btrfs_device *device;
-
-	device = container_of(head, struct btrfs_device, rcu);
-	btrfs_free_device(device);
-}
-
 static void btrfs_close_bdev(struct btrfs_device *device)
 {
 	if (!device->bdev)
@@ -1285,7 +1277,8 @@ static void btrfs_close_one_device(struct btrfs_device *device)
 	list_replace_rcu(&device->dev_list, &new_device->dev_list);
 	new_device->fs_devices = device->fs_devices;
 
-	call_rcu(&device->rcu, free_device_rcu);
+	synchronize_rcu();
+	btrfs_free_device(device);
 }
 
 static int close_fs_devices(struct btrfs_fs_devices *fs_devices)
@@ -2242,7 +2235,8 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 		btrfs_scratch_superblocks(device->bdev, device->name->str);
 
 	btrfs_close_bdev(device);
-	call_rcu(&device->rcu, free_device_rcu);
+	synchronize_rcu();
+	btrfs_free_device(device);
 
 	if (cur_devices->open_devices == 0) {
 		while (fs_devices) {
@@ -2310,7 +2304,8 @@ void btrfs_rm_dev_replace_free_srcdev(struct btrfs_fs_info *fs_info,
 	}
 
 	btrfs_close_bdev(srcdev);
-	call_rcu(&srcdev->rcu, free_device_rcu);
+	synchronize_rcu();
+	btrfs_free_device(srcdev);
 
 	/* if this is no devs we rather delete the fs_devices */
 	if (!fs_devices->num_devices) {
@@ -2368,7 +2363,8 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_device *tgtdev)
 	btrfs_scratch_superblocks(tgtdev->bdev, tgtdev->name->str);
 
 	btrfs_close_bdev(tgtdev);
-	call_rcu(&tgtdev->rcu, free_device_rcu);
+	synchronize_rcu();
+	btrfs_free_device(tgtdev);
 }
 
 static struct btrfs_device *btrfs_find_device_by_path(
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index a0f09aad3770..81784b68ca12 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -118,7 +118,6 @@ struct btrfs_device {
 	struct scrub_ctx *scrub_ctx;
 
 	struct btrfs_work work;
-	struct rcu_head rcu;
 
 	/* readahead state */
 	atomic_t reada_in_flight;
-- 
2.17.1

