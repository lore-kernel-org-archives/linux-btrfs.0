Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:19224 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750957AbdKMFeP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Nov 2017 00:34:15 -0500
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 1/2] btrfs-progs: qgroup: move btrfs_show_qgroups's error handler to __qgroup_search
Date: Mon, 13 Nov 2017 13:33:15 +0800
Message-ID: <20171113053316.14573-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have to process the return value of BTRFS_IOC_TREE_SEARCH ioctl in
advance, so that we can distinguish between the two case where quota
is not enabled (ioctl return -ENOENT) and either parent qgroup or child
qgroup does not exist (update_qgroup_relation return -ENOENT). Besides
this, any error in this routine has been reported, so we don't need to
report again in cmd_qgroup_show.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 cmds-qgroup.c |  4 ----
 qgroup.c      | 14 ++++++++++++--
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 38382ea9..d07bb0c0 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -399,10 +399,6 @@ static int cmd_qgroup_show(int argc, char **argv)
 					qgroupid);
 	}
 	ret = btrfs_show_qgroups(fd, filter_set, comparer_set);
-	if (ret == -ENOENT)
-		error("can't list qgroups: quotas not enabled");
-	else if (ret < 0)
-		error("can't list qgroups: %s", strerror(-ret));
 	close_file_or_dir(fd, dirstream);
 
 out:
diff --git a/qgroup.c b/qgroup.c
index 156825fd..23463d8a 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -1065,8 +1065,18 @@ static int __qgroups_search(int fd, struct qgroup_lookup *qgroup_lookup)
 
 	while (1) {
 		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
-		if (ret < 0)
-			return -errno;
+		if (ret < 0) {
+			if (errno == ENOENT) {
+				error("can't list qgroups: quotas not enabled");
+				ret = -ENOTTY;
+			} else {
+				error("can't list qgroups: %s",
+				       strerror(errno));
+				ret = -errno;
+			}
+
+			break;
+		}
 
 		/* the ioctl returns the number of item it found in nr_items */
 		if (sk->nr_items == 0)
-- 
2.15.0



