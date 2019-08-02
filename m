Return-Path: <SRS0=4fXr=V6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 724A4C32750
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Aug 2019 13:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B09F20679
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Aug 2019 13:39:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436506AbfHBNjm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 2 Aug 2019 09:39:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:60064 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391798AbfHBNjm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Aug 2019 09:39:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2825CB62C
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Aug 2019 13:39:41 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 0AEAFDADC0; Fri,  2 Aug 2019 15:40:15 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 06/13] btrfs: sysfs: unexport space_info_ktype
Date:   Fri,  2 Aug 2019 15:40:14 +0200
Message-Id: <0e11d8c3c9391951f88e2d05ab2da83fe674ff99.1564752900.git.dsterba@suse.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <cover.1564752900.git.dsterba@suse.com>
References: <cover.1564752900.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The last non-sysfs usage of space_info_ktype has been moved to a private
helper in previous patch so the variable can be made static.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/sysfs.c | 2 +-
 fs/btrfs/sysfs.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 24aaac281580..90822cdbf59e 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -375,7 +375,7 @@ static void space_info_release(struct kobject *kobj)
 	kfree(sinfo);
 }
 
-struct kobj_type space_info_ktype = {
+static struct kobj_type space_info_ktype = {
 	.sysfs_ops = &kobj_sysfs_ops,
 	.release = space_info_release,
 	.default_groups = space_info_groups,
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index 928c8ab37fd9..0550358eb24e 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -85,7 +85,6 @@ attr_to_btrfs_feature_attr(struct attribute *attr)
 
 char *btrfs_printable_features(enum btrfs_feature_set set, u64 flags);
 extern const char * const btrfs_feature_set_names[FEAT_MAX];
-extern struct kobj_type space_info_ktype;
 int btrfs_sysfs_add_device_link(struct btrfs_fs_devices *fs_devices,
 		struct btrfs_device *one_device);
 int btrfs_sysfs_rm_device_link(struct btrfs_fs_devices *fs_devices,
-- 
2.22.0

