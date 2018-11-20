Return-Path: <SRS0=yZnd=N7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A215C04EBB
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 08:13:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6449B21479
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 08:13:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JLSW74zf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6449B21479
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbeKTSlU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Nov 2018 13:41:20 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46622 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbeKTSlU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Nov 2018 13:41:20 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAK8458n029190
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 08:13:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=jwHWTYdMchIBPa913+KzVhvZWC3TMGBJcVdlAOZ7rvU=;
 b=JLSW74zfuBWASlWqyEFptNaju1udRL+ALzydOVfYvI0J3q82G2/EfM9+XAysG08HJgh5
 Ru9PQdh9xeiyNVIvq5hbcIzQw23fBRiPoPXR4ABpXm7C2SuNne/teuUn6rrQk9YLXiC8
 ENvu+YV0x9jBvTlNQ1k7SBM11ExEqVLx21eO9Z4gzBEDjzA3ZLZ7pDzGychQxRO/0UVg
 lHGypY+pV7PJHact68Jmfy3e2Q2WZpTQco46HL0gIrjMX77YhRD8d7Pc+lMkcN19Ye/x
 GGon4FRLpkwwy5tLbGSjbIqkSyQxRvdZMlbQBl770HYl+yuaM2k8tUK+nQ95Itr2LYM+ wA== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2ntaxq2cnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 08:13:28 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wAK8DN76008986
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 08:13:23 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wAK8DNTi026612
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2018 08:13:23 GMT
Received: from tpasj.localdomain (/202.156.138.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Nov 2018 00:13:22 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v6 1/3] btrfs: add helper function describe_block_group()
Date:   Tue, 20 Nov 2018 16:12:55 +0800
Message-Id: <1542701577-24586-2-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1542701577-24586-1-git-send-email-anand.jain@oracle.com>
References: <1542701577-24586-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9082 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=848
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811200074
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Improve on describe_relocation() add a common helper function to describe
the block groups.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
---
v5->v6: Use () in the body for the args sent in defines
	Use right indent to align '\'
	Use goto to out_overflow instead of return
v4.1->v5: Initialize buf[128] to null.
v4->v4.1: Use strcpy(buf, "|NONE"); as in the original
v3->v4: Just pass full flag name in the define DESCRIBE_FLAG(flag,..),
	 so that it can be used at couple of more places.
	Rename describe_block_groups() to btrfs_describe_block_groups().
	Drop useless return u32.
v3:	Born.

 fs/btrfs/relocation.c | 30 +++---------------------------
 fs/btrfs/volumes.c    | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h    |  1 +
 3 files changed, 50 insertions(+), 27 deletions(-)

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
index f435d397019e..3ab22e7e404e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -123,6 +123,52 @@ const char *get_raid_name(enum btrfs_raid_types type)
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
+#define DESCRIBE_FLAG(f, d)					\
+	do {							\
+		if (flags & (f)) {				\
+			ret = snprintf(bp, size_bp, "%s|", (d));\
+			if (ret < 0 || ret >= size_bp)		\
+				goto out_overflow;		\
+			size_bp -= ret;				\
+			bp += ret;				\
+			flags &= ~(f);				\
+		}						\
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
+
+out_overflow:
+	return;
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

