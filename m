Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32864 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbbKIK7v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Nov 2015 05:59:51 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id tA9Axmcu017233
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:59:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by userv0021.oracle.com (8.13.8/8.13.8) with ESMTP id tA9AxmdS003334
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:59:48 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id tA9AxmK9021203
	for <linux-btrfs@vger.kernel.org>; Mon, 9 Nov 2015 10:59:48 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/4] btrfs-progs: add global spare device list to filesystem show
Date: Mon,  9 Nov 2015 18:58:39 +0800
Message-Id: <1447066719-3880-5-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1447066719-3880-1-git-send-email-anand.jain@oracle.com>
References: <1447066589-3835-1-git-send-email-anand.jain@oracle.com>
 <1447066719-3880-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch will add list of spare devices to the filesystem show
output, as show in the example below.

btrfs fi show
Label: none  uuid: 17f7d403-17d7-4f0a-b8ba-de673fdd3f56
	Total devices 2 FS bytes used 15.88MiB
	devid    1 size 2.00GiB used 417.50MiB path /dev/sdc
	devid    2 size 2.00GiB used 417.50MiB path /dev/sdd

Global spare
	device size 3.00GiB path /dev/sde

btrfs-progs v4.2.3-12-gb5f4b68

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c | 5 +++++
 utils.h           | 1 +
 2 files changed, 6 insertions(+)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 11d0406..651ffe4 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -920,6 +920,11 @@ devs_only:
 					struct btrfs_fs_devices, list);
 		free_fs_devices(fs_devices);
 	}
+
+	if (where == -1 && search == NULL) {
+		ret = print_spare_device(unit_mode);
+		printf("\n");
+	}
 out:
 	printf("%s\n", PACKAGE_STRING);
 	free_seen_fsid();
diff --git a/utils.h b/utils.h
index a84cf2d..b833390 100644
--- a/utils.h
+++ b/utils.h
@@ -271,5 +271,6 @@ const char *get_argv0_buf(void);
 
 unsigned int get_unit_mode_from_arg(int *argc, char *argv[], int df_mode);
 int is_numerical(const char *str);
+int print_spare_device(unsigned unit_mode);
 
 #endif
-- 
2.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
