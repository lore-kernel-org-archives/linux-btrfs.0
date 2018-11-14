Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AB3AC4161B
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 13:35:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24E7E208E7
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 13:35:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 24E7E208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732837AbeKNXis (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 18:38:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:52902 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728391AbeKNXiq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 18:38:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5A16AB0C6
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 13:35:28 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH 3/6] btrfs: remove unused function btrfs_sysfs_feature_update()
Date:   Wed, 14 Nov 2018 14:35:17 +0100
Message-Id: <20181114133520.16069-4-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20181114133520.16069-1-jthumshirn@suse.de>
References: <20181114133520.16069-1-jthumshirn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

btrfs_sysfs_feature_update() was introduced with commit 444e75169872 (btrfs:
sysfs: introduce helper for syncing bits with sysfs files) to provide a helper
which was used in 14e46e04958d (btrfs: synchronize incompat feature bits with
sysfs files).

But commit e410e34fad91 (Revert "btrfs: synchronize incompat feature bits with
sysfs files") reverted 14e46e04958d so btrfs_sysfs_feature_update() ended up
as an unused function.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 fs/btrfs/sysfs.c | 33 ---------------------------------
 fs/btrfs/sysfs.h |  2 --
 2 files changed, 35 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 3717c864ba23..a22a7c5f75eb 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -858,39 +858,6 @@ int btrfs_sysfs_add_mounted(struct btrfs_fs_info *fs_info)
 	return error;
 }
 
-
-/*
- * Change per-fs features in /sys/fs/btrfs/UUID/features to match current
- * values in superblock. Call after any changes to incompat/compat_ro flags
- */
-void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info,
-		u64 bit, enum btrfs_feature_set set)
-{
-	struct btrfs_fs_devices *fs_devs;
-	struct kobject *fsid_kobj;
-	u64 features;
-	int ret;
-
-	if (!fs_info)
-		return;
-
-	features = get_features(fs_info, set);
-	ASSERT(bit & supported_feature_masks[set]);
-
-	fs_devs = fs_info->fs_devices;
-	fsid_kobj = &fs_devs->fsid_kobj;
-
-	if (!fsid_kobj->state_initialized)
-		return;
-
-	/*
-	 * FIXME: this is too heavy to update just one value, ideally we'd like
-	 * to use sysfs_update_group but some refactoring is needed first.
-	 */
-	sysfs_remove_group(fsid_kobj, &btrfs_feature_attr_group);
-	ret = sysfs_create_group(fsid_kobj, &btrfs_feature_attr_group);
-}
-
 static int btrfs_init_debugfs(void)
 {
 #ifdef CONFIG_DEBUG_FS
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index c6ee600aff89..93feedde8485 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -88,7 +88,5 @@ int btrfs_sysfs_add_fsid(struct btrfs_fs_devices *fs_devs,
 				struct kobject *parent);
 int btrfs_sysfs_add_device(struct btrfs_fs_devices *fs_devs);
 void btrfs_sysfs_remove_fsid(struct btrfs_fs_devices *fs_devs);
-void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info,
-		u64 bit, enum btrfs_feature_set set);
 
 #endif
-- 
2.16.4

