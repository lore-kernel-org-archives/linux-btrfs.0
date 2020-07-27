Return-Path: <SRS0=3GY2=BG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3646C433DF
	for <linux-btrfs@archiver.kernel.org>; Mon, 27 Jul 2020 22:08:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CD722072E
	for <linux-btrfs@archiver.kernel.org>; Mon, 27 Jul 2020 22:08:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgG0WIb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 27 Jul 2020 18:08:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:58592 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgG0WIb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Jul 2020 18:08:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E6122AB7A;
        Mon, 27 Jul 2020 22:08:40 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 1/4] btrfs-progs: get_fsid_fd() for getting fsid using fd
Date:   Mon, 27 Jul 2020 17:08:09 -0500
Message-Id: <20200727220812.2187-1-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200727220451.30680-1-rgoldwyn@suse.de>
References: <20200727220451.30680-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Add a function get_fsid_fd() to use an open file fd to get the
fsid of the mounted filesystem.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 common/utils.c | 31 +++++++++++++++++--------------
 common/utils.h |  1 +
 2 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/common/utils.c b/common/utils.c
index 9742c2e1..8a691846 100644
--- a/common/utils.c
+++ b/common/utils.c
@@ -1097,35 +1097,38 @@ out:
 	return ret;
 }
 
+int get_fsid_fd(int fd, u8 *fsid)
+{
+	int ret;
+	struct btrfs_ioctl_fs_info_args args;
+
+	ret = ioctl(fd, BTRFS_IOC_FS_INFO, &args);
+	if (ret < 0)
+		return -errno;
+
+	memcpy(fsid, args.fsid, BTRFS_FSID_SIZE);
+	return 0;
+}
+
 int get_fsid(const char *path, u8 *fsid, int silent)
 {
 	int ret;
 	int fd;
-	struct btrfs_ioctl_fs_info_args args;
 
 	fd = open(path, O_RDONLY);
 	if (fd < 0) {
-		ret = -errno;
 		if (!silent)
 			error("failed to open %s: %m", path);
-		goto out;
-	}
-
-	ret = ioctl(fd, BTRFS_IOC_FS_INFO, &args);
-	if (ret < 0) {
-		ret = -errno;
-		goto out;
+		return -errno;
 	}
 
-	memcpy(fsid, args.fsid, BTRFS_FSID_SIZE);
-	ret = 0;
+	ret = get_fsid_fd(fd, fsid);
+	close(fd);
 
-out:
-	if (fd != -1)
-		close(fd);
 	return ret;
 }
 
+
 static int group_profile_devs_min(u64 flag)
 {
 	switch (flag & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
diff --git a/common/utils.h b/common/utils.h
index 43e7f471..e34bb5a4 100644
--- a/common/utils.h
+++ b/common/utils.h
@@ -75,6 +75,7 @@ void close_file_or_dir(int fd, DIR *dirstream);
 int get_fs_info(const char *path, struct btrfs_ioctl_fs_info_args *fi_args,
 		struct btrfs_ioctl_dev_info_args **di_ret);
 int get_fsid(const char *path, u8 *fsid, int silent);
+int get_fsid_fd(int fd, u8 *fsid);
 
 int get_label(const char *btrfs_dev, char *label);
 int set_label(const char *btrfs_dev, const char *label);
-- 
2.26.2

