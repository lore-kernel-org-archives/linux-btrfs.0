Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FD3AC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 15:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E22B20823
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 15:37:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E22B20823
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729711AbeKTCBp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Nov 2018 21:01:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:47352 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729696AbeKTCBp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 21:01:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B5D82AE69
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Nov 2018 15:37:47 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     dsterba@suse.com, jeffm@suse.com,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Add sysfs support for metadata_uuid feature
Date:   Mon, 19 Nov 2018 17:37:45 +0200
Message-Id: <20181119153745.7248-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Since the metadata_uuid is a new incompat feature it requires the
respective sysfs hooks. This patch adds the 'metdata_uuid' feature to
be shown if it supported by the kernel. Additionally it adds
/sys/fs/btrfs/UUID/metadata_uuid attribute which allows one to read
the current metadata_uuid.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

I completely forgot sysfs also needs to be hooked so here it is. 

 fs/btrfs/sysfs.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 3717c864ba23..5a5930e3d32b 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -191,6 +191,7 @@ BTRFS_FEAT_ATTR_INCOMPAT(extended_iref, EXTENDED_IREF);
 BTRFS_FEAT_ATTR_INCOMPAT(raid56, RAID56);
 BTRFS_FEAT_ATTR_INCOMPAT(skinny_metadata, SKINNY_METADATA);
 BTRFS_FEAT_ATTR_INCOMPAT(no_holes, NO_HOLES);
+BTRFS_FEAT_ATTR_INCOMPAT(metadata_uuid, METADATA_UUID);
 BTRFS_FEAT_ATTR_COMPAT_RO(free_space_tree, FREE_SPACE_TREE);
 
 static struct attribute *btrfs_supported_feature_attrs[] = {
@@ -204,6 +205,7 @@ static struct attribute *btrfs_supported_feature_attrs[] = {
 	BTRFS_FEAT_ATTR_PTR(raid56),
 	BTRFS_FEAT_ATTR_PTR(skinny_metadata),
 	BTRFS_FEAT_ATTR_PTR(no_holes),
+	BTRFS_FEAT_ATTR_PTR(metadata_uuid),
 	BTRFS_FEAT_ATTR_PTR(free_space_tree),
 	NULL
 };
@@ -505,12 +507,24 @@ static ssize_t quota_override_store(struct kobject *kobj,
 
 BTRFS_ATTR_RW(, quota_override, quota_override_show, quota_override_store);
 
+static ssize_t btrfs_metadata_uuid_show(struct kobject *kobj,
+				struct kobj_attribute *a, char *buf)
+{
+	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
+
+	return snprintf(buf, PAGE_SIZE, "%pU\n",
+			fs_info->fs_devices->metadata_uuid);
+}
+
+BTRFS_ATTR(, metadata_uuid, btrfs_metadata_uuid_show);
+
 static const struct attribute *btrfs_attrs[] = {
 	BTRFS_ATTR_PTR(, label),
 	BTRFS_ATTR_PTR(, nodesize),
 	BTRFS_ATTR_PTR(, sectorsize),
 	BTRFS_ATTR_PTR(, clone_alignment),
 	BTRFS_ATTR_PTR(, quota_override),
+	BTRFS_ATTR_PTR(, metadata_uuid),
 	NULL,
 };
 
-- 
2.17.1

