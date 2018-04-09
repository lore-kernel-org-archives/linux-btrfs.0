Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:58372 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751737AbeDIFrS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Apr 2018 01:47:18 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 7E0F54D0EFE7
        for <linux-btrfs@vger.kernel.org>; Mon,  9 Apr 2018 13:47:14 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: remove unused function path_cat and path_cat3
Date: Mon, 9 Apr 2018 13:43:30 +0800
Message-ID: <1523252610-4843-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since function path_cat and path_cat3 are not used anymore, remove them.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 send-utils.c | 25 -------------------------
 send-utils.h |  9 ---------
 2 files changed, 34 deletions(-)

diff --git a/send-utils.c b/send-utils.c
index b5289e76..3ecbdea6 100644
--- a/send-utils.c
+++ b/send-utils.c
@@ -757,18 +757,6 @@ int path_cat_out(char *out, const char *p1, const char *p2)
 	return 0;
 }
 
-__attribute__((deprecated))
-char *path_cat(const char *p1, const char *p2)
-{
-	int p1_len = strlen(p1);
-	int p2_len = strlen(p2);
-	char *new = malloc(p1_len + p2_len + 2);
-
-	path_cat_out(new, p1, p2);
-
-	return new;
-}
-
 int path_cat3_out(char *out, const char *p1, const char *p2, const char *p3)
 {
 	int p1_len = strlen(p1);
@@ -788,16 +776,3 @@ int path_cat3_out(char *out, const char *p1, const char *p2, const char *p3)
 
 	return 0;
 }
-
-__attribute__((deprecated))
-char *path_cat3(const char *p1, const char *p2, const char *p3)
-{
-	int p1_len = strlen(p1);
-	int p2_len = strlen(p2);
-	int p3_len = strlen(p3);
-	char *new = malloc(p1_len + p2_len + p3_len + 3);
-
-	path_cat3_out(new, p1, p2, p3);
-
-	return new;
-}
diff --git a/send-utils.h b/send-utils.h
index e8f86912..5f5e096f 100644
--- a/send-utils.h
+++ b/send-utils.h
@@ -104,15 +104,6 @@ void subvol_uuid_search_add(struct subvol_uuid_search *s,
 
 int btrfs_subvolid_resolve(int fd, char *path, size_t path_len, u64 subvol_id);
 
-/*
- * DEPRECATED: the functions path_cat and path_cat3 are unsafe and should not
- * be used, use the _out variants and always check the return code.
- */
-__attribute__((deprecated))
-char *path_cat(const char *p1, const char *p2);
-__attribute__((deprecated))
-char *path_cat3(const char *p1, const char *p2, const char *p3);
-
 int path_cat_out(char *out, const char *p1, const char *p2);
 int path_cat3_out(char *out, const char *p1, const char *p2, const char *p3);
 
-- 
2.14.3



