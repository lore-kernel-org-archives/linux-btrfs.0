Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11999 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756339AbbJ2Jdl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Oct 2015 05:33:41 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9T9X6Ec015833
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2015 17:33:06 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 5/6] btrfs-progs: free comparer_set in cmd_qgroup_show
Date: Thu, 29 Oct 2015 17:31:47 +0800
Message-ID: <2a8343f402a43c5332c7dcdbf8efa5aee9e49ae9.1446111097.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <e9288021adac2924ce1fdb637f61b9b924eff954.1446111097.git.zhaolei@cn.fujitsu.com>
References: <e9288021adac2924ce1fdb637f61b9b924eff954.1446111097.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

comparer_set, which was allocated by malloc(), should be free before
function return.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-qgroup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index a64b716..f069d32 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -290,7 +290,7 @@ static int cmd_qgroup_show(int argc, char **argv)
 	int filter_flag = 0;
 	unsigned unit_mode;
 
-	struct btrfs_qgroup_comparer_set *comparer_set;
+	struct btrfs_qgroup_comparer_set *comparer_set = NULL;
 	struct btrfs_qgroup_filter_set *filter_set;
 	filter_set = btrfs_qgroup_alloc_filter_set();
 	comparer_set = btrfs_qgroup_alloc_comparer_set();
@@ -372,6 +372,8 @@ static int cmd_qgroup_show(int argc, char **argv)
 		fprintf(stderr, "ERROR: can't list qgroups: %s\n",
 				strerror(e));
 
+	free(comparer_set);
+
 	return !!ret;
 }
 
-- 
1.8.5.1

