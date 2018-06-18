Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:56184 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968192AbeFRIiN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jun 2018 04:38:13 -0400
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 65812AC0248
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 17:38:09 +0900 (JST)
Received: from g01jpexchkw33.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id 7CA3C69240C
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jun 2018 17:38:08 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 05/20] btrfs-progs: libbtrfsuitl: Factor out btrfs_util_subvolume_iterator_next()
Date: Mon, 18 Jun 2018 17:40:53 +0900
Message-ID: <83104ddacbf4d6dbfd6adaa88930c4029a9282f3.1529310485.git.misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
References: <cover.1529310485.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Factor out the main logic of btrfs_util_subvolume_iterator_next().
This is a preparation work to relax the root privilege of this function.

No functional change happens.

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 libbtrfsutil/subvolume.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/libbtrfsutil/subvolume.c b/libbtrfsutil/subvolume.c
index e94c7079..73471d4f 100644
--- a/libbtrfsutil/subvolume.c
+++ b/libbtrfsutil/subvolume.c
@@ -1255,9 +1255,9 @@ static enum btrfs_util_error build_subvol_path(struct btrfs_util_subvolume_itera
 	return BTRFS_UTIL_OK;
 }
 
-PUBLIC enum btrfs_util_error btrfs_util_subvolume_iterator_next(struct btrfs_util_subvolume_iterator *iter,
-								char **path_ret,
-								uint64_t *id_ret)
+static enum btrfs_util_error subvolume_iterator_next_root(struct btrfs_util_subvolume_iterator *iter,
+							  char **path_ret,
+							  uint64_t *id_ret)
 {
 	struct search_stack_entry *top;
 	const struct btrfs_ioctl_search_header *header;
@@ -1331,6 +1331,13 @@ out:
 	return BTRFS_UTIL_OK;
 }
 
+PUBLIC enum btrfs_util_error btrfs_util_subvolume_iterator_next(struct btrfs_util_subvolume_iterator *iter,
+								char **path_ret,
+								uint64_t *id_ret)
+{
+	return subvolume_iterator_next_root(iter, path_ret, id_ret);
+}
+
 PUBLIC enum btrfs_util_error btrfs_util_subvolume_iterator_next_info(struct btrfs_util_subvolume_iterator *iter,
 								     char **path_ret,
 								     struct btrfs_util_subvolume_info *subvol)
-- 
2.14.4


