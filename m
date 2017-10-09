Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38138 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753740AbdJIDIH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Oct 2017 23:08:07 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v99386nm028206
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 9 Oct 2017 03:08:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v99385a0022056
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 9 Oct 2017 03:08:06 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v99385G0018414
        for <linux-btrfs@vger.kernel.org>; Mon, 9 Oct 2017 03:08:05 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/4] btrfs: declare btrfs_report_missing_device() static
Date: Mon,  9 Oct 2017 11:07:45 +0800
Message-Id: <20171009030746.16680-3-anand.jain@oracle.com>
In-Reply-To: <20171009030746.16680-1-anand.jain@oracle.com>
References: <20171009030746.16680-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: This patch is a split from
    [PATCH 2/2] btrfs: clean up btrfs_report_missing_device() usage

 fs/btrfs/volumes.c | 12 ++++++------
 fs/btrfs/volumes.h |  2 --
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 844ae25cff9e..6a041bef112c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6377,6 +6377,12 @@ static int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+static void btrfs_report_missing_device(struct btrfs_fs_info *fs_info,
+						u64 devid, u8 *uuid)
+{
+	btrfs_warn_rl(fs_info, "devid %llu uuid %pU is missing", devid, uuid);
+}
+
 static int read_one_chunk(struct btrfs_fs_info *fs_info, struct btrfs_key *key,
 			  struct extent_buffer *leaf,
 			  struct btrfs_chunk *chunk)
@@ -6759,12 +6765,6 @@ int btrfs_read_sys_array(struct btrfs_fs_info *fs_info)
 	return -EIO;
 }
 
-void btrfs_report_missing_device(struct btrfs_fs_info *fs_info, u64 devid,
-				 u8 *uuid)
-{
-	btrfs_warn_rl(fs_info, "devid %llu uuid %pU is missing", devid, uuid);
-}
-
 /*
  * Check if all chunks in the fs are OK for read-write degraded mount
  *
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 6108fdfec67f..ff15208344a7 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -542,7 +542,5 @@ void btrfs_set_fs_info_ptr(struct btrfs_fs_info *fs_info);
 void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info);
 
 bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info);
-void btrfs_report_missing_device(struct btrfs_fs_info *fs_info, u64 devid,
-				 u8 *uuid);
 
 #endif
-- 
2.7.0

