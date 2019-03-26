Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63908C10F0A
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 19:03:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43A5520823
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 19:03:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732738AbfCZTDt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 15:03:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:37174 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732730AbfCZTDr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 15:03:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 829A0AEE6;
        Tue, 26 Mar 2019 19:03:46 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 14/15] btrfs: Disable dax-based defrag and send
Date:   Tue, 26 Mar 2019 14:03:00 -0500
Message-Id: <20190326190301.32365-15-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190326190301.32365-1-rgoldwyn@suse.de>
References: <20190326190301.32365-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

This is temporary, and a TODO.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/ioctl.c | 13 +++++++++++++
 fs/btrfs/send.c  |  4 ++++
 2 files changed, 17 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2e5137b01561..f532a8df2026 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2980,6 +2980,12 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
 			goto out;
 		}
 
+		if (IS_DAX(inode)) {
+			btrfs_warn(root->fs_info, "File defrag is not supported with DAX");
+			ret = -EOPNOTSUPP;
+			goto out;
+		}
+
 		if (argp) {
 			if (copy_from_user(range, argp,
 					   sizeof(*range))) {
@@ -4647,6 +4653,10 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	/* send can be on a directory, so check super block instead */
+	if (btrfs_test_opt(fs_info, DAX))
+		return -EOPNOTSUPP;
+
 	ret = mnt_want_write_file(file);
 	if (ret)
 		return ret;
@@ -5499,6 +5509,9 @@ static int _btrfs_ioctl_send(struct file *file, void __user *argp, bool compat)
 	struct btrfs_ioctl_send_args *arg;
 	int ret;
 
+	if (IS_DAX(file_inode(file)))
+		return -EOPNOTSUPP;
+
 	if (compat) {
 #if defined(CONFIG_64BIT) && defined(CONFIG_COMPAT)
 		struct btrfs_ioctl_send_args_32 args32;
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 7ea2d6b1f170..9679fd54db86 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6609,6 +6609,10 @@ long btrfs_ioctl_send(struct file *mnt_file, struct btrfs_ioctl_send_args *arg)
 	int sort_clone_roots = 0;
 	int index;
 
+	/* send can be on a directory, so check super block instead */
+	if (btrfs_test_opt(fs_info, DAX))
+		return -EOPNOTSUPP;
+
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-- 
2.16.4

