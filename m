Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46546 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab2L0JDq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 04:03:46 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qBR93jcT012904
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2012 09:03:46 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qBR93j2F019280
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2012 09:03:45 GMT
Received: from abhmt114.oracle.com (abhmt114.oracle.com [141.146.116.66])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qBR93jpt026238
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2012 03:03:45 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/8] Btrfs: kill unused argument of btrfs_pin_extent_for_log_replay
Date: Thu, 27 Dec 2012 17:01:20 +0800
Message-Id: <1356598884-22952-4-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1356598884-22952-1-git-send-email-bo.li.liu@oracle.com>
References: <1356598884-22952-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Argument 'trans' is not used any more.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/ctree.h       |    3 +--
 fs/btrfs/extent-tree.c |    3 +--
 fs/btrfs/tree-log.c    |    3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 547b7b0..d709c4d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2936,8 +2936,7 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 			     u64 num_bytes, u64 *refs, u64 *flags);
 int btrfs_pin_extent(struct btrfs_root *root,
 		     u64 bytenr, u64 num, int reserved);
-int btrfs_pin_extent_for_log_replay(struct btrfs_trans_handle *trans,
-				    struct btrfs_root *root,
+int btrfs_pin_extent_for_log_replay(struct btrfs_root *root,
 				    u64 bytenr, u64 num_bytes);
 int btrfs_cross_ref_exist(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6f71a7a..7a87e19 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4865,8 +4865,7 @@ int btrfs_pin_extent(struct btrfs_root *root,
 /*
  * this function must be called within transaction
  */
-int btrfs_pin_extent_for_log_replay(struct btrfs_trans_handle *trans,
-				    struct btrfs_root *root,
+int btrfs_pin_extent_for_log_replay(struct btrfs_root *root,
 				    u64 bytenr, u64 num_bytes)
 {
 	struct btrfs_block_group_cache *cache;
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 83186c7..bb5d9eb 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -278,8 +278,7 @@ static int process_one_buffer(struct btrfs_root *log,
 			      struct walk_control *wc, u64 gen)
 {
 	if (wc->pin)
-		btrfs_pin_extent_for_log_replay(wc->trans,
-						log->fs_info->extent_root,
+		btrfs_pin_extent_for_log_replay(log->fs_info->extent_root,
 						eb->start, eb->len);
 
 	if (btrfs_buffer_uptodate(eb, gen, 0)) {
-- 
1.7.7.6

