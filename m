Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29942 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751484AbaJPByt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 21:54:49 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s9G1sjpi001316
	for <linux-btrfs@vger.kernel.org>; Thu, 16 Oct 2014 09:54:45 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: prevent silent damage when add dev to an invalid mntpnt
Date: Thu, 16 Oct 2014 09:53:39 +0800
Message-ID: <1413424419-15237-3-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1413424419-15237-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1413424419-15237-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Problem:
	# mkfs.btrfs -f /dev/sda1
	# btrfs dev add /dev/sda1 /dir -f   <== dir is not a mntpnt

btrfs dev add just report invalid ioctl but it has already made
changes to /dev/sda1 with @btrfs_prepare_device(), so the fs on
/dev/sda1 is damaged.

We could check whether /dev/sda1 is a valid mntpnt by calling
@find_mount_root() to prevent this silent damage.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-device.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/cmds-device.c b/cmds-device.c
index a728f21..65815c3 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -53,6 +53,7 @@ static int cmd_add_dev(int argc, char **argv)
 	int discard = 1;
 	int force = 0;
 	char estr[100];
+	char rmntpnt[PATH_MAX];
 
 	while (1) {
 		int long_index;
@@ -84,6 +85,22 @@ static int cmd_add_dev(int argc, char **argv)
 
 	mntpnt = argv[optind + argc - 1];
 
+	if (!realpath(mntpnt, rmntpnt)) {
+		fprintf(stderr, "ERROR: %s\n", strerror(errno));
+		return 1;
+	}
+
+	ret = find_mount_root(rmntpnt, &mntpnt);
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: find_mount_root failed on '%s': %s\n",
+				rmntpnt, strerror(-ret));
+		return 1;
+	} else if (ret > 0) {
+		fprintf(stderr, "ERROR: '%s' doesn't belong to btrfs mount point\n",
+			rmntpnt);
+		return 1;
+	}
+
 	fdmnt = open_file_or_dir(mntpnt, &dirstream);
 	if (fdmnt < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", mntpnt);
-- 
1.8.1.4

