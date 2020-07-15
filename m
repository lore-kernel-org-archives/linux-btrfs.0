Return-Path: <SRS0=psRg=A2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 178FEC433DF
	for <linux-btrfs@archiver.kernel.org>; Wed, 15 Jul 2020 10:48:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC91020656
	for <linux-btrfs@archiver.kernel.org>; Wed, 15 Jul 2020 10:48:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729404AbgGOKsy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 06:48:54 -0400
Received: from [195.135.220.15] ([195.135.220.15]:37930 "EHLO mx2.suse.de"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1729284AbgGOKsx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Jul 2020 06:48:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 421D8B0A5;
        Wed, 15 Jul 2020 10:48:55 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/5] btrfs: Factor out loop logic from btrfs_free_extra_devids
Date:   Wed, 15 Jul 2020 13:48:47 +0300
Message-Id: <20200715104850.19071-3-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200715104850.19071-1-nborisov@suse.com>
References: <20200715104850.19071-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This prepares the code to switching seeds devices to a proper list.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/volumes.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ce01e44f8134..db29fc4fbe89 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1024,28 +1024,24 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
 	return ERR_PTR(ret);
 }
 
-/*
- * After we have read the system tree and know devids belonging to
- * this filesystem, remove the device which does not belong there.
- */
-void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices, int step)
+
+
+void __btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices, int step,
+			       struct btrfs_device **latest_dev)
 {
 	struct btrfs_device *device, *next;
-	struct btrfs_device *latest_dev = NULL;
 
-	mutex_lock(&uuid_mutex);
-again:
 	/* This is the initialized path, it is safe to release the devices. */
 	list_for_each_entry_safe(device, next, &fs_devices->devices, dev_list) {
 		if (test_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
-							&device->dev_state)) {
+			     &device->dev_state)) {
 			if (!test_bit(BTRFS_DEV_STATE_REPLACE_TGT,
-			     &device->dev_state) &&
+				      &device->dev_state) &&
 			    !test_bit(BTRFS_DEV_STATE_MISSING,
 				      &device->dev_state) &&
-			     (!latest_dev ||
-			      device->generation > latest_dev->generation)) {
-				latest_dev = device;
+			    (!*latest_dev ||
+			     device->generation > (*latest_dev)->generation)) {
+				*latest_dev = device;
 			}
 			continue;
 		}
@@ -1083,6 +1079,18 @@ void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices, int step)
 		btrfs_free_device(device);
 	}
 
+}
+/*
+ * After we have read the system tree and know devids belonging to
+ * this filesystem, remove the device which does not belong there.
+ */
+void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices, int step)
+{
+	struct btrfs_device *latest_dev = NULL;
+
+	mutex_lock(&uuid_mutex);
+again:
+	__btrfs_free_extra_devids(fs_devices, step, &latest_dev);
 	if (fs_devices->seed) {
 		fs_devices = fs_devices->seed;
 		goto again;
-- 
2.17.1

