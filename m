Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16730 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874AbcDEHgk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Apr 2016 03:36:40 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH] btrfs-progs: fix re-declared get_device_info()
Date: Tue,  5 Apr 2016 15:36:01 +0800
Message-Id: <1459841761-491-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The other get_device_info() is in the same file, 4 lines above.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 utils.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/utils.h b/utils.h
index ea54692aca86..e2ff41ad4ec1 100644
--- a/utils.h
+++ b/utils.h
@@ -187,8 +187,6 @@ int get_device_info(int fd, u64 devid,
 		struct btrfs_ioctl_dev_info_args *di_args);
 int test_uuid_unique(char *fs_uuid);
 u64 disk_size(const char *path);
-int get_device_info(int fd, u64 devid,
-		struct btrfs_ioctl_dev_info_args *di_args);
 u64 get_partition_size(const char *dev);
 
 int test_minimum_size(const char *file, u32 leafsize);
-- 
2.7.0

