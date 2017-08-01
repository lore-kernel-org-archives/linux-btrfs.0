Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33529 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751901AbdHARP5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 13:15:57 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v71HFu9P002212
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:57 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v71HFuqB021206
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:56 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v71HFueh022543
        for <linux-btrfs@vger.kernel.org>; Tue, 1 Aug 2017 17:15:56 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrfs-progs: introduce super_journal_tail to inspect-dump-super
Date: Tue,  1 Aug 2017 10:14:39 -0600
Message-Id: <20170801161439.13426-17-bo.li.liu@oracle.com>
In-Reply-To: <20170801161439.13426-1-bo.li.liu@oracle.com>
References: <20170801161439.13426-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We've record journal_tail of raid5/6 log in super_block so that recovery
of raid5/6 log can scan from this position.

This teaches inspect-dump-super to acknowledge %journal_tail.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 cmds-inspect-dump-super.c | 2 ++
 ctree.h                   | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index 98e0270..baa4d1a 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -389,6 +389,8 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	       (unsigned long long)btrfs_super_log_root_transid(sb));
 	printf("log_root_level\t\t%llu\n",
 	       (unsigned long long)btrfs_super_log_root_level(sb));
+	printf("journal_tail\t\t%llu\n",
+	       (unsigned long long)btrfs_super_journal_tail(sb));
 	printf("total_bytes\t\t%llu\n",
 	       (unsigned long long)btrfs_super_total_bytes(sb));
 	printf("bytes_used\t\t%llu\n",
diff --git a/ctree.h b/ctree.h
index 48ae890..d28d6f7 100644
--- a/ctree.h
+++ b/ctree.h
@@ -458,8 +458,10 @@ struct btrfs_super_block {
 	__le64 cache_generation;
 	__le64 uuid_tree_generation;
 
+	__le64 journal_tail;
+
 	/* future expansion */
-	__le64 reserved[30];
+	__le64 reserved[29];
 	u8 sys_chunk_array[BTRFS_SYSTEM_CHUNK_ARRAY_SIZE];
 	struct btrfs_root_backup super_roots[BTRFS_NUM_BACKUP_ROOTS];
 } __attribute__ ((__packed__));
@@ -2143,6 +2145,8 @@ BTRFS_SETGET_STACK_FUNCS(super_log_root_transid, struct btrfs_super_block,
 			 log_root_transid, 64);
 BTRFS_SETGET_STACK_FUNCS(super_log_root_level, struct btrfs_super_block,
 			 log_root_level, 8);
+BTRFS_SETGET_STACK_FUNCS(super_journal_tail, struct btrfs_super_block,
+			 journal_tail, 64);
 BTRFS_SETGET_STACK_FUNCS(super_total_bytes, struct btrfs_super_block,
 			 total_bytes, 64);
 BTRFS_SETGET_STACK_FUNCS(super_bytes_used, struct btrfs_super_block,
-- 
2.5.0

