Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:10017 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751070AbeC2IXV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Mar 2018 04:23:21 -0400
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 892BAAC00CB
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Mar 2018 17:23:17 +0900 (JST)
Received: from g01jpexchyt37.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt03.exch.g01.fujitsu.local (Postfix) with ESMTP id AC33B46E8E2
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Mar 2018 17:23:16 +0900 (JST)
Subject: [PATCH v2 2/3] btrfs-progs: fi usage: change to output more info
 without root privilege
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <99d3f3bf-ecc3-b6f5-c38c-8fba83db48d0@jp.fujitsu.com>
Message-ID: <f55c0802-0ba3-9175-0d4e-1346533fa2f7@jp.fujitsu.com>
Date: Thu, 29 Mar 2018 17:23:12 +0900
MIME-Version: 1.0
In-Reply-To: <99d3f3bf-ecc3-b6f5-c38c-8fba83db48d0@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although per device usage cannot be shown without root privilege,
per profile usage can be shown.

To achieve this, we just basically need to remove the check of nullness
of chunkinfo in print_filesystem_usage_by_chunk(), because other
functions except print_unused() properly handles chunkinfo by
chunkcount, which is 0 if chunkinfo is null.

As a result, "fi usage" always includes the information of "fi df".

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 cmds-fi-usage.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
index f2307fe0..2d45b3bb 100644
--- a/cmds-fi-usage.c
+++ b/cmds-fi-usage.c
@@ -923,9 +923,11 @@ static void _cmd_filesystem_usage_linear(unsigned unit_mode,
 		printf("\n");
 	}
 
-	printf("Unallocated:\n");
-	print_unused(info_ptr, info_count, device_info_ptr, device_info_count,
-			unit_mode | UNITS_NEGATIVE);
+	if (info_count) {
+		printf("Unallocated:\n");
+		print_unused(info_ptr, info_count, device_info_ptr,
+				device_info_count, unit_mode | UNITS_NEGATIVE);
+	}
 }
 
 static int print_filesystem_usage_by_chunk(int fd,
@@ -936,9 +938,6 @@ static int print_filesystem_usage_by_chunk(int fd,
 	struct btrfs_ioctl_space_args *sargs;
 	int ret = 0;
 
-	if (!chunkinfo)
-		return 0;
-
 	sargs = load_space_info(fd, path);
 	if (!sargs) {
 		ret = 1;
-- 
2.14.3

