Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:60260 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbcFUDVd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jun 2016 23:21:33 -0400
Received: from localhost.localdomain (unknown [10.167.226.107])
	by cn.fujitsu.com (Postfix) with ESMTP id 4E43E4056403
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Jun 2016 11:14:45 +0800 (CST)
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: add missing bytes_readonly attribute file in sysfs
Date: Tue, 21 Jun 2016 11:12:56 +0800
Message-Id: <1466478776-26117-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/sysfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 4da84ca..7b0fcca 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -328,6 +328,7 @@ SPACE_INFO_ATTR(bytes_used);
 SPACE_INFO_ATTR(bytes_pinned);
 SPACE_INFO_ATTR(bytes_reserved);
 SPACE_INFO_ATTR(bytes_may_use);
+SPACE_INFO_ATTR(bytes_readonly);
 SPACE_INFO_ATTR(disk_used);
 SPACE_INFO_ATTR(disk_total);
 BTRFS_ATTR(total_bytes_pinned, btrfs_space_info_show_total_bytes_pinned);
@@ -339,6 +340,7 @@ static struct attribute *space_info_attrs[] = {
 	BTRFS_ATTR_PTR(bytes_pinned),
 	BTRFS_ATTR_PTR(bytes_reserved),
 	BTRFS_ATTR_PTR(bytes_may_use),
+	BTRFS_ATTR_PTR(bytes_readonly),
 	BTRFS_ATTR_PTR(disk_used),
 	BTRFS_ATTR_PTR(disk_total),
 	BTRFS_ATTR_PTR(total_bytes_pinned),
-- 
1.8.3.1



