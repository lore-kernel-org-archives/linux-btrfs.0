Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:44835 "EHLO
        mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752277AbeEKH1e (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 03:27:34 -0400
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 6D632AC0209
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 16:27:31 +0900 (JST)
Received: from g01jpexchkw35.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id 9F2246926ED
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 16:27:30 +0900 (JST)
From: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 04/11] btrfs-progs: libbtrfsuitl: Factor out btrfs_util_subvolume_iterator_next()
Date: Fri, 11 May 2018 16:29:42 +0900
Message-ID: <20180511072949.15269-5-misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <20180511072949.15269-1-misono.tomohiro@jp.fujitsu.com>
References: <20180511072949.15269-1-misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Factor out the main logic of btrfs_util_subvolume_iterator_next().
This is a prepareation work to update the behavior of this function
and relax the required root privilege.

No functional change happens.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 libbtrfsutil/subvolume.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/libbtrfsutil/subvolume.c b/libbtrfsutil/subvolume.c
index 3ce6e0a6..08bbeca2 100644
--- a/libbtrfsutil/subvolume.c
+++ b/libbtrfsutil/subvolume.c
@@ -1255,7 +1255,7 @@ static enum btrfs_util_error build_subvol_path(struct btrfs_util_subvolume_itera
 	return BTRFS_UTIL_OK;
 }
 
-PUBLIC enum btrfs_util_error btrfs_util_subvolume_iterator_next(struct btrfs_util_subvolume_iterator *iter,
+static enum btrfs_util_error subvolume_iterator_next_root(struct btrfs_util_subvolume_iterator *iter,
 								char **path_ret,
 								uint64_t *id_ret)
 {
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
2.14.3


