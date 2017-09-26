Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:63595 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S967750AbdIZJ26 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 05:28:58 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 1FBF7482CFED
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Sep 2017 17:28:53 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: Resolve memory-leak in btrfs qgroup show when quota disabled
Date: Tue, 26 Sep 2017 17:28:31 +0800
Message-ID: <1506418111-26620-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When quota disabled, btrfs qgroup show exit with a error message,
but the allocated memory is not freed.

By the way, this bug marked as issue#20 in github.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 cmds-qgroup.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 38382ea9..5fbfaa17 100644
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
@@ -406,6 +405,10 @@ static int cmd_qgroup_show(int argc, char **argv)
 	close_file_or_dir(fd, dirstream);
 
 out:
+	if (filter_set)
+		free(filter_set);
+	if (comparer_set)
+		free(comparer_set);
 	return !!ret;
 }
 
-- 
2.14.1



