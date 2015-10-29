Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5639 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751478AbbJ2Jdi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Oct 2015 05:33:38 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9T9X2n6015816
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2015 17:33:02 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 1/6] btrfs-progs: fix floating point exception for btrfs-calc-size
Date: Thu, 29 Oct 2015 17:31:43 +0800
Message-ID: <e9288021adac2924ce1fdb637f61b9b924eff954.1446111097.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current code exit with floating point exception on a blank fs:
 # btrfs-calc-size -b /dev/sda6
 Calculating size of root tree
         Total size: 16384
                 Inline data: 0
         Total seeks: 0
                 Forward seeks: 0
                 Backward seeks: 0
 Floating point exception

This patch add a condition check for above case.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 btrfs-calc-size.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/btrfs-calc-size.c b/btrfs-calc-size.c
index b756693..17d44ae 100644
--- a/btrfs-calc-size.c
+++ b/btrfs-calc-size.c
@@ -372,8 +372,8 @@ out_print:
 		printf("\tTotal seeks: %Lu\n", stat.total_seeks);
 		printf("\t\tForward seeks: %Lu\n", stat.forward_seeks);
 		printf("\t\tBackward seeks: %Lu\n", stat.backward_seeks);
-		printf("\t\tAvg seek len: %Lu\n", stat.total_seek_len /
-		       stat.total_seeks);
+		printf("\t\tAvg seek len: %llu\n", stat.total_seeks ?
+			stat.total_seek_len / stat.total_seeks : 0);
 		print_seek_histogram(&stat);
 		printf("\tTotal clusters: %Lu\n", stat.total_clusters);
 		printf("\t\tAvg cluster size: %Lu\n", stat.total_cluster_size /
-- 
1.8.5.1

