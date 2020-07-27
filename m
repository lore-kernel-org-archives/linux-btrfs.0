Return-Path: <SRS0=3GY2=BG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92988C433E3
	for <linux-btrfs@archiver.kernel.org>; Mon, 27 Jul 2020 22:08:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CF4F2072E
	for <linux-btrfs@archiver.kernel.org>; Mon, 27 Jul 2020 22:08:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgG0WIh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 27 Jul 2020 18:08:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:58616 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgG0WIh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Jul 2020 18:08:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7D80BAB7A;
        Mon, 27 Jul 2020 22:08:46 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 3/4] btrfs-progs: Check for exclusive operation before issuing ioctl
Date:   Mon, 27 Jul 2020 17:08:11 -0500
Message-Id: <20200727220812.2187-3-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200727220812.2187-1-rgoldwyn@suse.de>
References: <20200727220451.30680-1-rgoldwyn@suse.de>
 <20200727220812.2187-1-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Check if an exclusive operation is running and if it is, err with the
name of the exclusive operation running.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 cmds/device.c     | 14 ++++++++++++++
 cmds/filesystem.c |  7 +++++++
 2 files changed, 21 insertions(+)

diff --git a/cmds/device.c b/cmds/device.c
index 99ceed93..6acd4ae6 100644
--- a/cmds/device.c
+++ b/cmds/device.c
@@ -61,6 +61,7 @@ static int cmd_device_add(const struct cmd_struct *cmd,
 	int discard = 1;
 	int force = 0;
 	int last_dev;
+	char exop[BTRFS_SYSFS_EXOP_SIZE];
 
 	optind = 0;
 	while (1) {
@@ -96,6 +97,12 @@ static int cmd_device_add(const struct cmd_struct *cmd,
 	if (fdmnt < 0)
 		return 1;
 
+	if (get_exclusive_operation(fdmnt, exop) > 0 && strcmp(exop, "none")) {
+		error("unable to add device: %s in progress", exop);
+		close_file_or_dir(fdmnt, dirstream);
+		return 1;
+	}
+
 	for (i = optind; i < last_dev; i++){
 		struct btrfs_ioctl_vol_args ioctl_args;
 		int	devfd, res;
@@ -155,6 +162,7 @@ static int _cmd_device_remove(const struct cmd_struct *cmd,
 	char	*mntpnt;
 	int i, fdmnt, ret = 0;
 	DIR	*dirstream = NULL;
+	char exop[BTRFS_SYSFS_EXOP_SIZE];
 
 	clean_args_no_options(cmd, argc, argv);
 
@@ -167,6 +175,12 @@ static int _cmd_device_remove(const struct cmd_struct *cmd,
 	if (fdmnt < 0)
 		return 1;
 
+	if (get_exclusive_operation(fdmnt, exop) > 0 && strcmp(exop, "none")) {
+		error("unable to remove device: %s in progress", exop);
+		close_file_or_dir(fdmnt, dirstream);
+		return 1;
+	}
+
 	for(i = optind; i < argc - 1; i++) {
 		struct	btrfs_ioctl_vol_args arg;
 		struct btrfs_ioctl_vol_args_v2 argv2 = {0};
diff --git a/cmds/filesystem.c b/cmds/filesystem.c
index 6c1b6908..c3efb405 100644
--- a/cmds/filesystem.c
+++ b/cmds/filesystem.c
@@ -1079,6 +1079,7 @@ static int cmd_filesystem_resize(const struct cmd_struct *cmd,
 	char	*amount, *path;
 	DIR	*dirstream = NULL;
 	struct stat st;
+	char exop[BTRFS_SYSFS_EXOP_SIZE];
 
 	clean_args_no_options_relaxed(cmd, argc, argv);
 
@@ -1110,6 +1111,12 @@ static int cmd_filesystem_resize(const struct cmd_struct *cmd,
 	if (fd < 0)
 		return 1;
 
+	if (get_exclusive_operation(fd, exop) > 0 && strcmp(exop, "none")) {
+		error("unable to resize: %s in progress", exop);
+		close_file_or_dir(fd, dirstream);
+		return 1;
+	}
+
 	printf("Resize '%s' of '%s'\n", path, amount);
 	memset(&args, 0, sizeof(args));
 	strncpy_null(args.name, amount);
-- 
2.26.2

