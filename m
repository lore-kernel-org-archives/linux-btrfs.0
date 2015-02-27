Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2668 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755262AbbB0I0p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Feb 2015 03:26:45 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1R8Pq7i019938
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2015 16:25:52 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 7/7] btrfs-progs: Schedule quota rescan if qgroup assign caused inconsistence.
Date: Fri, 27 Feb 2015 16:26:39 +0800
Message-ID: <1425025599-30048-8-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1425025599-30048-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1425025599-30048-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

NOTE: This patch needs to cooperate with kernel patches, which will fix
a kernel bug that never clear INCONSISTENT bit and return 1 if quota
assign makes qgroup data inconsistent.

Some qgroup assign will cause qgroup data inconsistent, like remove a
qgroup with shared extents from a parent qgroup. But some won't, like
assign a empty(OK, nodesize rfer and exel) to a qgroup.

Newer kernel will return 1 if qgroup data inconsistent and in that case
we should schedule a quota rescan.

This patch will do this in btrfs-progs.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-qgroup.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 2d6d84b..7d5f41f 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -64,13 +64,33 @@ static int qgroup_assign(int assign, int argc, char **argv)
 
 	ret = ioctl(fd, BTRFS_IOC_QGROUP_ASSIGN, &args);
 	e = errno;
-	close_file_or_dir(fd, dirstream);
 	if (ret < 0) {
 		fprintf(stderr, "ERROR: unable to assign quota group: %s\n",
 			strerror(e));
+		close_file_or_dir(fd, dirstream);
 		return 1;
 	}
-	return 0;
+
+	/*
+	 * If ret > 0, it means the assign caused qgroup data inconsistent.
+	 * Schedule a quota rescan.
+	 *
+	 * The return value change only happens in newer kernel. But will not
+	 * cause problem since old kernel has a bug that will never clear
+	 * INCONSISTENT bit.
+	 */
+	if (ret > 0) {
+		struct btrfs_ioctl_quota_rescan_args args;
+
+		printf("Quota data changed, quota rescan scheduled\n");
+		memset(&args, 0, sizeof(args));
+		ret = ioctl(fd, BTRFS_IOC_QUOTA_RESCAN, &args);
+		if (ret < 0)
+			fprintf(stderr, "ERROR: quota rescan failed: %s\n",
+				strerror(errno));
+	}
+	close_file_or_dir(fd, dirstream);
+	return ret;
 }
 
 static int qgroup_create(int create, int argc, char **argv)
-- 
2.3.0

