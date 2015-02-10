Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62764 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754770AbbBJK0o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 05:26:44 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1AAPuoh000837
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Feb 2015 18:25:56 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
Subject: [PATCH 1/2] btrfs-progs:correct the return value
Date: Tue, 10 Feb 2015 18:23:13 +0800
Message-ID: <1423563803-8996-2-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1423563803-8996-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1423563803-8996-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Fan Chengniang <fancn.fnst@cn.fujitsu.com>

the return values 12 and 13 are not used spectially except as
return value. No description and definition about them. so I
change them to generic errno

Signed-off-by: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
---
 qgroup.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/qgroup.c b/qgroup.c
index d59f4bb..5a4e393 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -21,6 +21,7 @@
 #include "ctree.h"
 #include "ioctl.h"
 #include "utils.h"
+#include <errno.h>
 
 #define BTRFS_QGROUP_NFILTERS_INCREASE (2 * BTRFS_QGROUP_FILTER_MAX)
 #define BTRFS_QGROUP_NCOMPS_INCREASE (2 * BTRFS_QGROUP_COMP_MAX)
@@ -1294,7 +1295,7 @@ qgroup_inherit_realloc(struct btrfs_qgroup_inherit **inherit, int n, int pos)
 	out = calloc(sizeof(*out) + sizeof(out->qgroups[0]) * (nitems + n), 1);
 	if (out == NULL) {
 		fprintf(stderr, "ERROR: Not enough memory\n");
-		return 13;
+		return -ENOMEM;
 	}
 
 	if (*inherit) {
@@ -1322,7 +1323,7 @@ int qgroup_inherit_add_group(struct btrfs_qgroup_inherit **inherit, char *arg)
 
 	if (qgroupid == 0) {
 		fprintf(stderr, "ERROR: bad qgroup specification\n");
-		return 12;
+		return -EINVAL;
 	}
 
 	if (*inherit)
@@ -1349,7 +1350,7 @@ int qgroup_inherit_add_copy(struct btrfs_qgroup_inherit **inherit, char *arg,
 	if (!p) {
 bad:
 		fprintf(stderr, "ERROR: bad copy specification\n");
-		return 12;
+		return -EINVAL;
 	}
 	*p = 0;
 	qgroup_src = parse_qgroupid(arg);
-- 
1.8.4.2

