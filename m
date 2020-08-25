Return-Path: <SRS0=8sAC=CD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A8ECC433E3
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Aug 2020 15:04:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E87262075F
	for <linux-btrfs@archiver.kernel.org>; Tue, 25 Aug 2020 15:04:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgHYPEC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 11:04:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:52810 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726570AbgHYPDx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Aug 2020 11:03:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B9F41AEAA;
        Tue, 25 Aug 2020 15:04:22 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 1/4] btrfs-progs: get_fsid_fd() for getting fsid using fd
Date:   Tue, 25 Aug 2020 10:03:35 -0500
Message-Id: <20200825150338.32610-1-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200825150233.30294-1-rgoldwyn@suse.de>
References: <20200825150233.30294-1-rgoldwyn@suse.de>
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
 common/utils.c | 30 ++++++++++++++++--------------
 common/utils.h |  1 +
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/common/utils.c b/common/utils.c
index 9742c2e1..dbe1e806 100644
--- a/common/utils.c
+++ b/common/utils.c
@@ -1097,32 +1097,34 @@ out:
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

