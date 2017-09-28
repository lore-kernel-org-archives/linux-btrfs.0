Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:23768 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750914AbdI1GVA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Sep 2017 02:21:00 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id C775646BA7D9
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Sep 2017 14:20:53 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gu JinXiang <gujx@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: Resolve memory-leak in btrfs qgroup show when quota disabled
Date: Thu, 28 Sep 2017 14:20:48 +0800
Message-ID: <1506579648-60414-1-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1506418111-26620-1-git-send-email-gujx@cn.fujitsu.com>
References: <1506418111-26620-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Gu JinXiang <gujx@cn.fujitsu.com>

When quota disabled, btrfs qgroup show exit with a error message,
but the allocated memory is not freed.
By the way, this bug marked as issue#20 in github.

Signed-off-by: Gu JinXiang <gujx@cn.fujitsu.com>
---
 cmds-qgroup.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 38382ea9..51d4f3a1 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -369,9 +369,8 @@ static int cmd_qgroup_show(int argc, char **argv)
 	path = argv[optind];
 	fd = btrfs_open_dir(path, &dirstream, 1);
 	if (fd < 0) {
-		free(filter_set);
-		free(comparer_set);
-		return 1;
+		ret = 1;
+		goto out;
 	}
 
 	if (sync) {
@@ -399,13 +398,21 @@ static int cmd_qgroup_show(int argc, char **argv)
 					qgroupid);
 	}
 	ret = btrfs_show_qgroups(fd, filter_set, comparer_set);
-	if (ret == -ENOENT)
+	if (ret == -ENOENT) {
 		error("can't list qgroups: quotas not enabled");
-	else if (ret < 0)
+		goto out;
+	} else if (ret < 0) {
 		error("can't list qgroups: %s", strerror(-ret));
+		goto out;
+	}
 	close_file_or_dir(fd, dirstream);
 
+	return !!ret;
+
 out:
+	close_file_or_dir(fd, dirstream);
+	free(filter_set);
+	free(comparer_set);
 	return !!ret;
 }
 
-- 
2.14.1



