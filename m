Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:57762 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751241AbeAYTIq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Jan 2018 14:08:46 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w0PJ7QMg021852
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jan 2018 19:08:46 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2130.oracle.com with ESMTP id 2fqkb38hwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jan 2018 19:08:45 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w0PJ8iX5010737
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jan 2018 19:08:45 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w0PJ8ifJ030641
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jan 2018 19:08:44 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix extent state leak from tree log
Date: Thu, 25 Jan 2018 11:02:52 -0700
Message-Id: <20180125180256.10844-5-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's possible that btrfs_sync_log() bails out after one of the two
btrfs_write_marked_extents() which convert extent state's state bit into
EXTENT_NEED_WAIT from EXTENT_DIRTY/EXTENT_NEW, however only EXTENT_DIRTY
and EXTENT_NEW are searched by free_log_tree() so that those extent states
with EXTENT_NEED_WAIT lead to memory leak.

cc: <stable@vger.kernel.org>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/tree-log.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 22046ed..a7e6235 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3049,13 +3049,14 @@ static void free_log_tree(struct btrfs_trans_handle *trans,
 
 	while (1) {
 		ret = find_first_extent_bit(&log->dirty_log_pages,
-				0, &start, &end, EXTENT_DIRTY | EXTENT_NEW,
+				0, &start, &end,
+				EXTENT_DIRTY | EXTENT_NEW | EXTENT_NEED_WAIT,
 				NULL);
 		if (ret)
 			break;
 
 		clear_extent_bits(&log->dirty_log_pages, start, end,
-				  EXTENT_DIRTY | EXTENT_NEW);
+				  EXTENT_DIRTY | EXTENT_NEW | EXTENT_NEED_WAIT);
 	}
 
 	/*
-- 
2.9.4

