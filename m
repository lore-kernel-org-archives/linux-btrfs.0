Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B483C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 13:17:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0B0E22419
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 13:17:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TqH2NtIz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D0B0E22419
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732963AbeKNXUX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 18:20:23 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56840 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732902AbeKNXUX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 18:20:23 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAEDA0s9117923
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 13:17:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=hi5nEbaIMQTpEdk/d2uTXSTLYh40k4atds7Rc1bJIOU=;
 b=TqH2NtIzPIAZf8G3gqertcJ3ufkMVsrunK6taQwR5B9zeZrvERlzRu7PRH9VbK3rOVmO
 sRXNeB6GourPNHMC0fevathdTJm7CXIwkpnWEACrAJlLKYgh1yVkwwlBgqWuQAphOMXW
 AXkeMO8xbvaxueorln0/dZbgmJ7oBMEUTvsCLZ9FH+gekahb9Ci+S3rYmso3A7YfGk+j
 6sJrY42GO6UL3p/MBUjQCnJpo/thxZuojyiuHqaN7byRZKx7lNYt4pYH3f/qhmIhgYZJ
 KVt/bRfvHB7XaQnm3zwZzKD9UWyFlInh1C27XsPSRWBDhcACi5gqLYcYMGMaW3pLE7Rd Mg== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2nr7cs3b5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 13:17:09 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wAEDH8Y7013367
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 13:17:08 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wAEDH8DX018574
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 13:17:08 GMT
Received: from tpasj.localdomain (/202.156.138.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 14 Nov 2018 05:17:08 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v5 1/3] btrfs: add helper function describe_block_group()
Date:   Wed, 14 Nov 2018 21:17:10 +0800
Message-Id: <1542201432-8617-2-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1542201432-8617-1-git-send-email-anand.jain@oracle.com>
References: <1542201432-8617-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9076 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=929
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811140120
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Improve on describe_relocation() add a common helper function to describe
the block groups.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
---
v4.1->v5: Initialize buf[128] to null.
v4->v4.1: Use strcpy(buf, "|NONE"); as in the original
v3->v4: Just pass full flag name in the define DESCRIBE_FLAG(flag,..),
	 so that it can be used at couple of more places.
	Rename describe_block_groups() to btrfs_describe_block_groups().
	Drop useless return u32.
v3:	Born.

 fs/btrfs/relocation.c | 30 +++---------------------------
 fs/btrfs/volumes.c    | 43 +++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h    |  1 +
 3 files changed, 47 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 924116f654a1..0373b3cc1d36 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4184,37 +4184,13 @@ static struct reloc_control *alloc_reloc_control(void)
 static void describe_relocation(struct btrfs_fs_info *fs_info,
 				struct btrfs_block_group_cache *block_group)
 {
-	char buf[128];		/* prefixed by a '|' that'll be dropped */
-	u64 flags = block_group->flags;
+	char buf[128] = {'\0'};
 
-	/* Shouldn't happen */
-	if (!flags) {
-		strcpy(buf, "|NONE");
-	} else {
-		char *bp = buf;
-
-#define DESCRIBE_FLAG(f, d) \
-		if (flags & BTRFS_BLOCK_GROUP_##f) { \
-			bp += snprintf(bp, buf - bp + sizeof(buf), "|%s", d); \
-			flags &= ~BTRFS_BLOCK_GROUP_##f; \
-		}
-		DESCRIBE_FLAG(DATA,     "data");
-		DESCRIBE_FLAG(SYSTEM,   "system");
-		DESCRIBE_FLAG(METADATA, "metadata");
-		DESCRIBE_FLAG(RAID0,    "raid0");
-		DESCRIBE_FLAG(RAID1,    "raid1");
-		DESCRIBE_FLAG(DUP,      "dup");
-		DESCRIBE_FLAG(RAID10,   "raid10");
-		DESCRIBE_FLAG(RAID5,    "raid5");
-		DESCRIBE_FLAG(RAID6,    "raid6");
-		if (flags)
-			snprintf(bp, buf - bp + sizeof(buf), "|0x%llx", flags);
-#undef DESCRIBE_FLAG
-	}
+	btrfs_describe_block_groups(block_group->flags, buf, sizeof(buf));
 
 	btrfs_info(fs_info,
 		   "relocating block group %llu flags %s",
-		   block_group->key.objectid, buf + 1);
+		   block_group->key.objectid, buf);
 }
 
 /*
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f435d397019e..12b3d0625c6a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -123,6 +123,49 @@ const char *get_raid_name(enum btrfs_raid_types type)
 	return btrfs_raid_array[type].raid_name;
 }
 
+void btrfs_describe_block_groups(u64 bg_flags, char *buf, u32 size_buf)
+{
+	int i;
+	int ret;
+	char *bp = buf;
+	u64 flags = bg_flags;
+	u32 size_bp = size_buf;
+
+	if (!flags) {
+		strcpy(bp, "NONE");
+		return;
+	}
+
+#define DESCRIBE_FLAG(f, d) \
+	do { \
+		if (flags & f) { \
+			ret = snprintf(bp, size_bp, "%s|", d); \
+			if (ret < 0 || ret >= size_bp) \
+				return; \
+			size_bp -= ret; \
+			bp += ret; \
+			flags &= ~f; \
+		} \
+	} while (0)
+
+	DESCRIBE_FLAG(BTRFS_BLOCK_GROUP_DATA, "data");
+	DESCRIBE_FLAG(BTRFS_BLOCK_GROUP_SYSTEM, "system");
+	DESCRIBE_FLAG(BTRFS_BLOCK_GROUP_METADATA, "metadata");
+	DESCRIBE_FLAG(BTRFS_AVAIL_ALLOC_BIT_SINGLE, "single");
+	for (i = 0; i < BTRFS_NR_RAID_TYPES; i++)
+		DESCRIBE_FLAG(btrfs_raid_array[i].bg_flag,
+			      btrfs_raid_array[i].raid_name);
+#undef DESCRIBE_FLAG
+
+	if (flags) {
+		ret = snprintf(bp, size_bp, "0x%llx|", flags);
+		size_bp -= ret;
+	}
+
+	if (size_bp < size_buf)
+		buf[size_buf - size_bp - 1] = '\0'; /* remove last | */
+}
+
 static int init_first_rw_device(struct btrfs_trans_handle *trans,
 				struct btrfs_fs_info *fs_info);
 static int btrfs_relocate_sys_chunks(struct btrfs_fs_info *fs_info);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index aefce895e994..3e914effcdf6 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -430,6 +430,7 @@ struct btrfs_device *btrfs_find_device(struct btrfs_fs_info *fs_info, u64 devid,
 int btrfs_balance(struct btrfs_fs_info *fs_info,
 		  struct btrfs_balance_control *bctl,
 		  struct btrfs_ioctl_balance_args *bargs);
+void btrfs_describe_block_groups(u64 flags, char *buf, u32 size_buf);
 int btrfs_resume_balance_async(struct btrfs_fs_info *fs_info);
 int btrfs_recover_balance(struct btrfs_fs_info *fs_info);
 int btrfs_pause_balance(struct btrfs_fs_info *fs_info);
-- 
1.8.3.1

