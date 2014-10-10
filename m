Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3714 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754157AbaJJU5g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Oct 2014 16:57:36 -0400
Received: from pps.filterd (m0044012 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s9AKv1QR027780
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 13:57:36 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0a-00082601.pphosted.com with ESMTP id 1pxm4kgbv5-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 13:57:35 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 06/12] Btrfs-progs: reset chunk state if we restart check
Date: Fri, 10 Oct 2014 16:57:11 -0400
Message-ID: <1412974637-31334-7-git-send-email-jbacik@fb.com>
In-Reply-To: <1412974637-31334-1-git-send-email-jbacik@fb.com>
References: <1412974637-31334-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we hid a corrupt block that we fix and we restart the fsck loop you will get
lots of noise about duplicate block groups and such.  This is because we don't
clear the block group and chunk cache when we do this restart.  This patch fixes
that, which is a little tricky since the structs are linked together with
various linked lists, but this passed with a user who was hitting this problem.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 cmds-check.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 1deef77..e81a26c 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3270,6 +3270,8 @@ static void free_chunk_record(struct cache_extent *cache)
 	struct chunk_record *rec;
 
 	rec = container_of(cache, struct chunk_record, cache);
+	list_del_init(&rec->list);
+	list_del_init(&rec->dextents);
 	free(rec);
 }
 
@@ -3306,6 +3308,7 @@ static void free_block_group_record(struct cache_extent *cache)
 	struct block_group_record *rec;
 
 	rec = container_of(cache, struct block_group_record, cache);
+	list_del_init(&rec->list);
 	free(rec);
 }
 
@@ -3339,6 +3342,10 @@ static void free_device_extent_record(struct cache_extent *cache)
 	struct device_extent_record *rec;
 
 	rec = container_of(cache, struct device_extent_record, cache);
+	if (!list_empty(&rec->chunk_list))
+		list_del_init(&rec->chunk_list);
+	if (!list_empty(&rec->device_list))
+		list_del_init(&rec->device_list);
 	free(rec);
 }
 
@@ -6051,7 +6058,7 @@ static int check_device_used(struct device_record *dev_rec,
 		if (dev_extent_rec->objectid != dev_rec->devid)
 			break;
 
-		list_del(&dev_extent_rec->device_list);
+		list_del_init(&dev_extent_rec->device_list);
 		total_byte += dev_extent_rec->length;
 		cache = next_cache_extent(cache);
 	}
@@ -6280,6 +6287,10 @@ again:
 		free_extent_cache_tree(&pending);
 		free_extent_cache_tree(&reada);
 		free_extent_cache_tree(&nodes);
+		free_chunk_cache_tree(&chunk_cache);
+		free_block_group_tree(&block_group_cache);
+		free_device_cache_tree(&dev_cache);
+		free_device_extent_tree(&dev_extent_cache);
 		free_extent_record_cache(root->fs_info, &extent_cache);
 		goto again;
 	}
-- 
1.8.3.1

