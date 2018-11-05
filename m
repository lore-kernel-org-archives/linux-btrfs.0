Return-Path: <SRS0=ibH9=NQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C179C0044C
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 19:07:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07E6F20896
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 19:07:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DKJWmtCu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 07E6F20896
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387832AbeKFE1y (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Nov 2018 23:27:54 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43447 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387460AbeKFE1y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Nov 2018 23:27:54 -0500
Received: by mail-pl1-f193.google.com with SMTP id g59-v6so4901147plb.10
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Nov 2018 11:06:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=/LLAzwDdf029f9ZYZFA/k+FXhQvuzZNd6afJSDCwhKM=;
        b=DKJWmtCuA+wHaZfnDGdBf6HztdBXZ4DJaTMtE3ke51y5VQH+cEPBqJXsN/oDra8xy8
         3D0YuXGxEdBLTsfsLvmg5E7kNky14HCClOX1AaVRRck77So4uiXK3IP5wSjBeynKiw9d
         mMA7se5eSrVdM5gVIGnKL7XesBMHyPtFsVt9jdkcI8F04VnT/4+2L7UdSyRtudr8uq4W
         wuUYu9YxZ13LIepsJLp3GX9+/Q0WzA+swmyx8vQeIOVR+tSew/KsXbbJrfGmdG3gq0kE
         UyWPWOqV++IvNYxLpQx79VDIsW/cMCd46VilvugCtveFwjCeAhGpkkf2QH6ng72IRh6L
         GF0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/LLAzwDdf029f9ZYZFA/k+FXhQvuzZNd6afJSDCwhKM=;
        b=iAzJjh3p6E+GZzy0q5TTl6w5uBFNgB9CSVZKu1J3GDSMJ4dxJB8yRSUa6fynqujA2B
         gHzf7hqSjIM9mw+9bZBaO/Uk4aqri6maTo3W6Yl80eppAd3/UmS2nbUNOgRvOVGBabCt
         y45qRB0QBvQRag8LpcKCAEDZfYy4Uc8emq0IjD72VZSdNsrwaKLKmzCJPUFuwE06lN9g
         PRsXVzWFTa+LZTAgIUoFd+GXX0VUXYRnxqq9qGsHLPXEnWaqEcjvVQ2FspuWehw9iRd5
         NFUMhvzYygu9rHgw/nJJo3EsxMtFjtI3m+ukEKaEqjBc4+pMNv7VGvtwTl3xHpakTgiF
         OTxg==
X-Gm-Message-State: AGRZ1gLImJuZTdQ09cE7XGHKQjmBchXfHzmLiCqCeVlQHUuAlP28tnZM
        khqh1gm0HKv5ft0GgQB/ZIoBzfkg
X-Google-Smtp-Source: AJdET5dSKH961RGUJmpsySKvgGzV1ttqDPRw0Uu9Cc2ooiY5YlQZQp/RlSpVywgq6GfWhocHH48Xvg==
X-Received: by 2002:a17:902:bf0c:: with SMTP id bi12-v6mr23825809plb.330.1541444808774;
        Mon, 05 Nov 2018 11:06:48 -0800 (PST)
Received: from desktop.lan (astound-69-42-16-32.ca.astound.net. [69.42.16.32])
        by smtp.gmail.com with ESMTPSA id l129-v6sm55872516pfc.155.2018.11.05.11.06.47
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Nov 2018 11:06:47 -0800 (PST)
From:   Rosen Penev <rosenp@gmail.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] treewide: Fix missing declarations
Date:   Mon,  5 Nov 2018 11:06:43 -0800
Message-Id: <20181105190643.13578-3-rosenp@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181105190643.13578-1-rosenp@gmail.com>
References: <20181105190643.13578-1-rosenp@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Found using -Wmissing-prototypes in GCC.

This should improve LTO behavior.

Note that set_free_space_tree_thresholds is an unused function. Adding
inline seems to remove the unused function warning.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 btrfs.c              |  2 +-
 check/mode-lowmem.c  |  2 +-
 extent-tree.c        |  2 +-
 free-space-tree.c    | 12 ++++++------
 libbtrfsutil/stubs.c |  1 +
 utils-lib.c          |  2 ++
 utils.h              |  1 +
 7 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/btrfs.c b/btrfs.c
index 2d39f2c..78c468d 100644
--- a/btrfs.c
+++ b/btrfs.c
@@ -210,7 +210,7 @@ static int handle_global_options(int argc, char **argv)
 	return shift;
 }
 
-void handle_special_globals(int shift, int argc, char **argv)
+static void handle_special_globals(int shift, int argc, char **argv)
 {
 	int has_help = 0;
 	int has_full = 0;
diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 14bbc9e..94123c1 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -953,7 +953,7 @@ out:
  * returns 0 means success.
  * returns not 0 means on error;
  */
-int repair_ternary_lowmem(struct btrfs_root *root, u64 dir_ino, u64 ino,
+static int repair_ternary_lowmem(struct btrfs_root *root, u64 dir_ino, u64 ino,
 			  u64 index, char *name, int name_len, u8 filetype,
 			  int err)
 {
diff --git a/extent-tree.c b/extent-tree.c
index cd98633..8c9cdef 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -3749,7 +3749,7 @@ static void __get_extent_size(struct btrfs_root *root, struct btrfs_path *path,
  * Return >0 for not found.
  * Return <0 for err
  */
-int btrfs_search_overlap_extent(struct btrfs_root *root,
+static int btrfs_search_overlap_extent(struct btrfs_root *root,
 				struct btrfs_path *path, u64 bytenr, u64 len)
 {
 	struct btrfs_key key;
diff --git a/free-space-tree.c b/free-space-tree.c
index 6641cdf..6ef5792 100644
--- a/free-space-tree.c
+++ b/free-space-tree.c
@@ -24,7 +24,7 @@
 #include "bitops.h"
 #include "internal.h"
 
-void set_free_space_tree_thresholds(struct btrfs_block_group_cache *cache,
+static inline void set_free_space_tree_thresholds(struct btrfs_block_group_cache *cache,
 				    u64 sectorsize)
 {
 	u32 bitmap_range;
@@ -202,7 +202,7 @@ static void le_bitmap_set(unsigned long *map, unsigned int start, int len)
 	}
 }
 
-int convert_free_space_to_bitmaps(struct btrfs_trans_handle *trans,
+static int convert_free_space_to_bitmaps(struct btrfs_trans_handle *trans,
 				  struct btrfs_block_group_cache *block_group,
 				  struct btrfs_path *path)
 {
@@ -341,7 +341,7 @@ out:
 	return ret;
 }
 
-int convert_free_space_to_extents(struct btrfs_trans_handle *trans,
+static int convert_free_space_to_extents(struct btrfs_trans_handle *trans,
 				  struct btrfs_block_group_cache *block_group,
 				  struct btrfs_path *path)
 {
@@ -780,7 +780,7 @@ out:
 	return ret;
 }
 
-int __remove_from_free_space_tree(struct btrfs_trans_handle *trans,
+static int __remove_from_free_space_tree(struct btrfs_trans_handle *trans,
 				  struct btrfs_block_group_cache *block_group,
 				  struct btrfs_path *path, u64 start, u64 size)
 {
@@ -960,7 +960,7 @@ out:
 	return ret;
 }
 
-int __add_to_free_space_tree(struct btrfs_trans_handle *trans,
+static int __add_to_free_space_tree(struct btrfs_trans_handle *trans,
 			     struct btrfs_block_group_cache *block_group,
 			     struct btrfs_path *path, u64 start, u64 size)
 {
@@ -1420,7 +1420,7 @@ out:
 	return ret;
 }
 
-struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
+static struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
 				     struct btrfs_fs_info *fs_info,
 				     u64 objectid)
 {
diff --git a/libbtrfsutil/stubs.c b/libbtrfsutil/stubs.c
index 9b9e037..c530e40 100644
--- a/libbtrfsutil/stubs.c
+++ b/libbtrfsutil/stubs.c
@@ -19,6 +19,7 @@
 
 #include <stdlib.h>
 #include <errno.h>
+#include "stubs.h"
 
 void *reallocarray(void *ptr, size_t nmemb, size_t size)
 {
diff --git a/utils-lib.c b/utils-lib.c
index 044f93f..2ac421b 100644
--- a/utils-lib.c
+++ b/utils-lib.c
@@ -5,6 +5,8 @@
 #include <sys/ioctl.h>
 #include <ioctl.h>
 
+#include "utils.h"
+
 #if BTRFS_FLAT_INCLUDES
 #include "ctree.h"
 #else
diff --git a/utils.h b/utils.h
index b6c00cf..7c5eb79 100644
--- a/utils.h
+++ b/utils.h
@@ -29,6 +29,7 @@
 #include "sizes.h"
 #include "messages.h"
 #include "ioctl.h"
+#include "fsfeatures.h"
 
 #define BTRFS_SCAN_MOUNTED	(1ULL << 0)
 #define BTRFS_SCAN_LBLKID	(1ULL << 1)
-- 
2.19.1

