Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17747 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751945AbbFCHCY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jun 2015 03:02:24 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t5370p5N010773
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Jun 2015 15:00:51 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 1/2] btrfs-progs: qgroup: show 'none' when we did not limit it on this qgroup
Date: Wed, 3 Jun 2015 14:57:31 +0800
Message-ID: <1433314653-548-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are two understanding of the '0' value in btrfs qgroup show.
(1) is no-limitation on this qgroup. (2) is the max-limitation is 0.

This patch make it showing in different way.

(1). max-limitation for 0 is still showing '0'.
(2). no-limitation will show 'none'.

qgroupid         rfer         excl     max_rfer     max_excl parent
--------         ----         ----     --------     -------- ------
0/5           2.19GiB      2.19GiB         none         none ---
0/257       100.02MiB    100.02MiB         none         none ---

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 qgroup.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/qgroup.c b/qgroup.c
index 53815b5..dc04b03 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -237,10 +237,16 @@ static void print_qgroup_column(struct btrfs_qgroup *qgroup,
 		print_qgroup_column_add_blank(BTRFS_QGROUP_PARENT, len);
 		break;
 	case BTRFS_QGROUP_MAX_RFER:
-		len = printf("%*s", max_len, pretty_size_mode(qgroup->max_rfer, unit_mode));
+		if (qgroup->flags & BTRFS_QGROUP_LIMIT_MAX_RFER)
+			len = printf("%*s", max_len, pretty_size_mode(qgroup->max_rfer, unit_mode));
+		else
+			len = printf("%*s", max_len, "none");
 		break;
 	case BTRFS_QGROUP_MAX_EXCL:
-		len = printf("%*s", max_len, pretty_size_mode(qgroup->max_excl, unit_mode));
+		if (qgroup->flags & BTRFS_QGROUP_LIMIT_MAX_EXCL)
+			len = printf("%*s", max_len, pretty_size_mode(qgroup->max_excl, unit_mode));
+		else
+			len = printf("%*s", max_len, "none");
 		break;
 	case BTRFS_QGROUP_CHILD:
 		len = print_child_column(qgroup);
-- 
1.8.4.2

