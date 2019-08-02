Return-Path: <SRS0=4fXr=V6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24635C32750
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Aug 2019 13:39:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED45220679
	for <linux-btrfs@archiver.kernel.org>; Fri,  2 Aug 2019 13:39:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391918AbfHBNji (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 2 Aug 2019 09:39:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:60010 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391798AbfHBNjh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Aug 2019 09:39:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7B24EAFA4
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Aug 2019 13:39:36 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 56D12DADC0; Fri,  2 Aug 2019 15:40:10 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 04/13] btrfs: sysfs: unexport btrfs_raid_ktype
Date:   Fri,  2 Aug 2019 15:40:10 +0200
Message-Id: <06215318c84e011fb46f7bb79e70d1b15cd701d4.1564752900.git.dsterba@suse.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <cover.1564752900.git.dsterba@suse.com>
References: <cover.1564752900.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The last non-sysfs usage of btrfs_raid_ktype has been moved to a private
helper in previous patch so the variable can be made static.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/sysfs.c | 2 +-
 fs/btrfs/sysfs.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 008d58f618cd..25097d6cf2ca 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -316,7 +316,7 @@ static void release_raid_kobj(struct kobject *kobj)
 	kfree(to_raid_kobj(kobj));
 }
 
-struct kobj_type btrfs_raid_ktype = {
+static struct kobj_type btrfs_raid_ktype = {
 	.sysfs_ops = &kobj_sysfs_ops,
 	.release = release_raid_kobj,
 	.default_groups = raid_groups,
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index fa1b9bb5d320..7f659ce7be84 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -86,7 +86,6 @@ attr_to_btrfs_feature_attr(struct attribute *attr)
 char *btrfs_printable_features(enum btrfs_feature_set set, u64 flags);
 extern const char * const btrfs_feature_set_names[FEAT_MAX];
 extern struct kobj_type space_info_ktype;
-extern struct kobj_type btrfs_raid_ktype;
 int btrfs_sysfs_add_device_link(struct btrfs_fs_devices *fs_devices,
 		struct btrfs_device *one_device);
 int btrfs_sysfs_rm_device_link(struct btrfs_fs_devices *fs_devices,
-- 
2.22.0

