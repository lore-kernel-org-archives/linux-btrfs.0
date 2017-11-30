Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:63658 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750783AbdK3Hww (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 02:52:52 -0500
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 55071AC00B6
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Nov 2017 16:52:48 +0900 (JST)
Received: from g01jpexchkw35.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id 7468E6926EF
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Nov 2017 16:52:47 +0900 (JST)
Subject: [PATCH 2/3] btrfs-progs: fi usage: change to output more info without
 root privilege
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <12571738-34cb-412c-a512-3b117d4726e9@jp.fujitsu.com>
Message-ID: <dbdf04aa-3969-8249-a507-d7d16f3d1e5d@jp.fujitsu.com>
Date: Thu, 30 Nov 2017 16:52:44 +0900
MIME-Version: 1.0
In-Reply-To: <12571738-34cb-412c-a512-3b117d4726e9@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although per device usage cannot be shown without root privilege,
per profile usage can be shown.

To achieve this, we just basically need to remove the check of nullness
of chunkinfo in print_filesystem_usage_by_chunk(), because other
functions except print_unused() properly handles chunkinfo by
chunkcount, which is 0 if chunkinfo is null.

As a result, "fi usage" always includes the infomation of "fi df".

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 cmds-fi-usage.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
index 299c2dae..7bbc9896 100644
--- a/cmds-fi-usage.c
+++ b/cmds-fi-usage.c
@@ -885,9 +885,11 @@ static void _cmd_filesystem_usage_linear(unsigned unit_mode,
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
@@ -898,9 +900,6 @@ static int print_filesystem_usage_by_chunk(int fd,
 	struct btrfs_ioctl_space_args *sargs;
 	int ret = 0;
 
-	if (!chunkinfo)
-		return 0;
-
 	sargs = load_space_info(fd, path);
 	if (!sargs) {
 		ret = 1;
-- 
2.13.6

