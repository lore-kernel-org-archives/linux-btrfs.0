Return-Path: <SRS0=DuSC=DH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41400C4727C
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Sep 2020 01:57:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC16C2145D
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Sep 2020 01:57:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Gz8tKRY7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729957AbgI3B5G (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Sep 2020 21:57:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:50868 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729767AbgI3B5F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Sep 2020 21:57:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1601431023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NiJeh8dbrKT2BY0wSXL7NHSBFI06q2uR9GdxgHUXOWA=;
        b=Gz8tKRY7e8f2NXUTAVQ7mcXXaquevGiXy168W1PhmAq7BBCT69zzMT5mmHkmr3JYDPp+al
        Gp4HFsD9JgqDk/GWLdoi+ugzwfo62k5uBphvDQx2g3P/m5fNto7vVaifvCOKVlQeTKidSH
        BVaN1vqiY9acw3Ytj6K5gYlpZHm0OQ4=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A9339AE07
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2020 01:57:03 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3 38/49] btrfs: allow RO mount of 4K sector size fs on 64K page system
Date:   Wed, 30 Sep 2020 09:55:28 +0800
Message-Id: <20200930015539.48867-39-wqu@suse.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200930015539.48867-1-wqu@suse.com>
References: <20200930015539.48867-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This adds the basic RO mount ability for 4K sector size on 64K page
system.

Currently we only plan to support 4K and 64K page system.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 24 +++++++++++++++++++++---
 fs/btrfs/super.c   |  7 +++++++
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 97c44f518a49..e0dc7b92411e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2565,13 +2565,21 @@ static int validate_super(struct btrfs_fs_info *fs_info,
 		btrfs_err(fs_info, "invalid sectorsize %llu", sectorsize);
 		ret = -EINVAL;
 	}
-	/* Only PAGE SIZE is supported yet */
-	if (sectorsize != PAGE_SIZE) {
+
+	/*
+	 * For 4K page size, we only support 4K sector size.
+	 * For 64K page size, we support RW for 64K sector size, and RO for
+	 * 4K sector size.
+	 */
+	if ((PAGE_SIZE == SZ_4K && sectorsize != PAGE_SIZE) ||
+	    (PAGE_SIZE == SZ_64K && (sectorsize != SZ_4K &&
+				     sectorsize != SZ_64K))) {
 		btrfs_err(fs_info,
-			"sectorsize %llu not supported yet, only support %lu",
+			"sectorsize %llu not supported yet for page size %lu",
 			sectorsize, PAGE_SIZE);
 		ret = -EINVAL;
 	}
+
 	if (!is_power_of_2(nodesize) || nodesize < sectorsize ||
 	    nodesize > BTRFS_MAX_METADATA_BLOCKSIZE) {
 		btrfs_err(fs_info, "invalid nodesize %llu", nodesize);
@@ -3219,6 +3227,16 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 		goto fail_alloc;
 	}
 
+	/* For 4K sector size support, it's only read-only yet */
+	if (PAGE_SIZE == SZ_64K && sectorsize == SZ_4K) {
+		if (!sb_rdonly(sb) || btrfs_super_log_root(disk_super)) {
+			btrfs_err(fs_info,
+				"subpage sector size only support RO yet");
+			err = -EINVAL;
+			goto fail_alloc;
+		}
+	}
+
 	ret = btrfs_init_workqueues(fs_info, fs_devices);
 	if (ret) {
 		err = ret;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 25967ecaaf0a..743a2fadf4ee 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1922,6 +1922,13 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 			ret = -EINVAL;
 			goto restore;
 		}
+		if (btrfs_is_subpage(fs_info)) {
+			btrfs_warn(fs_info,
+	"read-write mount is not yet allowed for sector size %u page size %lu",
+				   fs_info->sectorsize, PAGE_SIZE);
+			ret = -EINVAL;
+			goto restore;
+		}
 
 		ret = btrfs_cleanup_fs_roots(fs_info);
 		if (ret)
-- 
2.28.0

