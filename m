Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60451 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932827AbaICNev (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Sep 2014 09:34:51 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s83DYl4G006734
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Sep 2014 21:34:47 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/5] block: export disk_class and disk_type for btrfs
Date: Wed, 3 Sep 2014 21:36:29 +0800
Message-ID: <1409751393-5403-2-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1409751393-5403-1-git-send-email-miaox@cn.fujitsu.com>
References: <1409751393-5403-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs can make filesystem cross several disks/partitions, in order to
load all the disks/partitions which belong to the same filesystem, we
need scan the system and find all the devices, and then register them
into the kernel. Currently, we do it by user tool. But if we forget to
do it, we can not mount the filesystem. So I want btrfs scan the system
and find all the devices by itself in the kernel. In order to implement
it, we need disk_class and disk_type, so export them.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 block/genhd.c         | 7 +++++--
 include/linux/genhd.h | 1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 791f419..8371c09 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -34,7 +34,7 @@ struct kobject *block_depr;
 static DEFINE_MUTEX(ext_devt_mutex);
 static DEFINE_IDR(ext_devt_idr);
 
-static struct device_type disk_type;
+struct device_type disk_type;
 
 static void disk_check_events(struct disk_events *ev,
 			      unsigned int *clearing_ptr);
@@ -1107,9 +1107,11 @@ static void disk_release(struct device *dev)
 		blk_put_queue(disk->queue);
 	kfree(disk);
 }
+
 struct class block_class = {
 	.name		= "block",
 };
+EXPORT_SYMBOL(block_class);
 
 static char *block_devnode(struct device *dev, umode_t *mode,
 			   kuid_t *uid, kgid_t *gid)
@@ -1121,12 +1123,13 @@ static char *block_devnode(struct device *dev, umode_t *mode,
 	return NULL;
 }
 
-static struct device_type disk_type = {
+struct device_type disk_type = {
 	.name		= "disk",
 	.groups		= disk_attr_groups,
 	.release	= disk_release,
 	.devnode	= block_devnode,
 };
+EXPORT_SYMBOL(disk_type);
 
 #ifdef CONFIG_PROC_FS
 /*
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index ec274e0..a701ace 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -22,6 +22,7 @@
 #define part_to_dev(part)	(&((part)->__dev))
 
 extern struct device_type part_type;
+extern struct device_type disk_type;
 extern struct kobject *block_depr;
 extern struct class block_class;
 
-- 
1.9.3

