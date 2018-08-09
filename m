Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41401 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727537AbeHIUhk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Aug 2018 16:37:40 -0400
From: Naohiro Aota <naota@elisp.net>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Matias Bjorling <mb@lightnvm.io>, Naohiro Aota <naota@elisp.net>
Subject: [RFC PATCH 11/12] btrfs-progs: replace: disable in HMZONED device
Date: Fri, 10 Aug 2018 03:11:04 +0900
Message-Id: <20180809181105.12856-11-naota@elisp.net>
In-Reply-To: <20180809181105.12856-1-naota@elisp.net>
References: <20180809180450.5091-1-naota@elisp.net>
 <20180809181105.12856-1-naota@elisp.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As show in the kernel patches, device replace feature needs more works to
complete. Disable the feature for now.

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 cmds-replace.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/cmds-replace.c b/cmds-replace.c
index 1fa80284..642fbd4b 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -116,6 +116,7 @@ static const char *const cmd_replace_start_usage[] = {
 
 static int cmd_replace_start(int argc, char **argv)
 {
+	struct btrfs_ioctl_feature_flags feature_flags;
 	struct btrfs_ioctl_dev_replace_args start_args = {0};
 	struct btrfs_ioctl_dev_replace_args status_args = {0};
 	int ret;
@@ -123,6 +124,7 @@ static int cmd_replace_start(int argc, char **argv)
 	int c;
 	int fdmnt = -1;
 	int fddstdev = -1;
+	int hmzoned;
 	char *path;
 	char *srcdev;
 	char *dstdev = NULL;
@@ -200,6 +202,13 @@ static int cmd_replace_start(int argc, char **argv)
 		goto leave_with_error;
 	}
 
+	ret = ioctl(fdmnt, BTRFS_IOC_GET_FEATURES, &feature_flags);
+	if (ret) {
+		error("error getting feature flags '%s': %m", path);
+		return 1;
+	}
+	hmzoned = feature_flags.incompat_flags & BTRFS_FEATURE_INCOMPAT_HMZONED;
+
 	if (string_is_numerical(srcdev)) {
 		struct btrfs_ioctl_fs_info_args fi_args;
 		struct btrfs_ioctl_dev_info_args *di_args = NULL;
@@ -238,6 +247,12 @@ static int cmd_replace_start(int argc, char **argv)
 		goto leave_with_error;
 	}
 
+	if (hmzoned) {
+		error("cannot replace device on HMZONED file system '%s'",
+		      dstdev);
+		goto leave_with_error;
+	}
+
 	ret = test_dev_for_mkfs(dstdev, force_using_targetdev);
 	if (ret)
 		goto leave_with_error;
-- 
2.18.0

