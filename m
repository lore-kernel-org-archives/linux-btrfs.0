Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8764C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 13:17:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 644E02087A
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 13:17:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ti/bG7UV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 644E02087A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732976AbeKNXUZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 18:20:25 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56864 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732902AbeKNXUZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 18:20:25 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAED8m0k117174
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 13:17:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=sjWTs1VBcRYGfcZiOUwT8kuOdKO0wv9tZTJPxlsJIKE=;
 b=ti/bG7UVr4FBruJKKm4cT4qBdissqTG+D15MWOBGgS2NyTg2H8tDQJYz50JWvJlKsHg5
 kFQGiz2hkdhEKrIl82JESAvbCXjm56BVBEvVJCb5Ln+jeRTCC4oHh0+e6IMHNI2DX6dP
 dQLd/344MDnLkEZEKYFFz4IcAwUV89zW+wuRR7iOSNinhe73Cf3y0vJ+MpwSiFgCKUv+
 N+gCBglZGHupJ1aX+MMRxrDo+8CixTAVkBVb/Ff8xj/yPGgNSgM6eB9pYFNVW78YwoSa
 BzTjXlCupELGehaVuahECNzeJETHFX/nUgGuPIMVEsK4U7gEazmLVuQtaDx2oKJQMduf jA== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2nr7cs3b5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 13:17:10 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wAEDH9WP025410
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 13:17:09 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wAEDH9kr031792
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2018 13:17:09 GMT
Received: from tpasj.localdomain (/202.156.138.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 14 Nov 2018 05:17:09 -0800
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v5 2/3] btrfs: balance: add args info during start and resume
Date:   Wed, 14 Nov 2018 21:17:11 +0800
Message-Id: <1542201432-8617-3-git-send-email-anand.jain@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1542201432-8617-1-git-send-email-anand.jain@oracle.com>
References: <1542201432-8617-1-git-send-email-anand.jain@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9076 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811140120
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Balance arg info is an important information to be reviewed for the
system audit. So this patch adds them to the kernel log.

Example:
->btrfs bal start -f -mprofiles=raid1,convert=single,soft -dlimit=10..20,usage=50 /btrfs

kernel: BTRFS info (device sdb): balance: start -f -dusage=50,limit=10..20 -msoft,profiles=raid1,convert=single -ssoft,profiles=raid1,convert=single

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v4.1->v5: Per David review comment the code..
           bp += snprintf(bp, buf - bp + size_buf, "soft,");
	  is not safe if 'buf - bp + size_buf' becomes accidentally
	  negative, so fix this by using following snprintf.

 #define CHECK_UPDATE_BP_1(a) \
       do { \
               ret = snprintf(bp, size_bp, a); \
               if (ret < 0 || ret >= size_bp) \
                       goto out; \
               size_bp -= ret; \
               bp += ret; \
       } while (0)

	And initialize the tmp_buf to null.

v4->v4.1: Rename last missed sz to size_buf.

v3->v4: Change log updated with new example.
	Log format is changed to almost match with the cli.
	snprintf drop %s for inline string.
	Print range as =%u..%u instead of min=%umax=%u.
	soft is under the args now.
	force is printed as -f.

v2->v3: Change log updated.
        Make use of describe_block_group() added in 1/4
        Drop using strcat instead use snprintf.
        Logs string format updated as shown in the example above.

v1->v2: Change log update.
        Move adding the logs for balance complete and end to a new patch

 fs/btrfs/volumes.c | 172 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 169 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 12b3d0625c6a..8397f72bdac7 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3754,6 +3754,173 @@ static inline int validate_convert_profile(struct btrfs_balance_args *bctl_arg,
 		 (bctl_arg->target & ~allowed)));
 }
 
+static void describe_balance_args(struct btrfs_balance_args *bargs, char *buf,
+				 u32 size_buf)
+{
+	int ret;
+	u32 size_bp = size_buf;
+	char *bp = buf;
+	u64 flags = bargs->flags;
+	char tmp_buf[128] = {'\0'};
+
+	if (!flags)
+		return;
+
+#define CHECK_UPDATE_BP_1(a) \
+	do { \
+		ret = snprintf(bp, size_bp, a); \
+		if (ret < 0 || ret >= size_bp) \
+			goto out; \
+		size_bp -= ret; \
+		bp += ret; \
+	} while (0)
+
+#define CHECK_UPDATE_BP_2(a, v1) \
+	do { \
+		ret = snprintf(bp, size_bp, a, v1); \
+		if (ret < 0 || ret >= size_bp) \
+			goto out; \
+		size_bp -= ret; \
+		bp += ret; \
+	} while (0)
+
+#define CHECK_UPDATE_BP_3(a, v1, v2) \
+	do { \
+		ret = snprintf(bp, size_bp, a, v1, v2); \
+		if (ret < 0 || ret >= size_bp) \
+			goto out; \
+		size_bp -= ret; \
+		bp += ret; \
+	} while (0)
+
+	if (flags & BTRFS_BALANCE_ARGS_SOFT) {
+		CHECK_UPDATE_BP_1("soft,");
+	}
+
+	if (flags & BTRFS_BALANCE_ARGS_PROFILES) {
+		btrfs_describe_block_groups(bargs->profiles, tmp_buf,
+					    sizeof(tmp_buf));
+		CHECK_UPDATE_BP_2("profiles=%s,", tmp_buf);
+	}
+
+	if (flags & BTRFS_BALANCE_ARGS_USAGE) {
+		CHECK_UPDATE_BP_2("usage=%llu,", bargs->usage);
+	}
+
+	if (flags & BTRFS_BALANCE_ARGS_USAGE_RANGE) {
+		CHECK_UPDATE_BP_3("usage=%u..%u,",
+				  bargs->usage_min, bargs->usage_max);
+	}
+
+	if (flags & BTRFS_BALANCE_ARGS_DEVID) {
+		CHECK_UPDATE_BP_2("devid=%llu,", bargs->devid);
+	}
+
+	if (flags & BTRFS_BALANCE_ARGS_DRANGE) {
+		CHECK_UPDATE_BP_3("drange=%llu..%llu,",
+				  bargs->pstart, bargs->pend);
+	}
+
+	if (flags & BTRFS_BALANCE_ARGS_VRANGE) {
+		CHECK_UPDATE_BP_3("vrange%llu..%llu,",
+				  bargs->vstart, bargs->vend);
+	}
+
+	if (flags & BTRFS_BALANCE_ARGS_LIMIT) {
+		CHECK_UPDATE_BP_2("limit=%llu,", bargs->limit);
+	}
+
+	if (flags & BTRFS_BALANCE_ARGS_LIMIT_RANGE) {
+		CHECK_UPDATE_BP_3("limit=%u..%u,",
+				bargs->limit_min, bargs->limit_max);
+	}
+
+	if (flags & BTRFS_BALANCE_ARGS_STRIPES_RANGE) {
+		CHECK_UPDATE_BP_3("stripes=%u..%u,",
+				  bargs->stripes_min, bargs->stripes_max);
+	}
+
+	if (flags & BTRFS_BALANCE_ARGS_CONVERT) {
+		int index = btrfs_bg_flags_to_raid_index(bargs->target);
+
+		CHECK_UPDATE_BP_2("convert=%s,", get_raid_name(index));
+	}
+
+out:
+#undef CHECK_UPDATE_BP_3
+#undef CHECK_UPDATE_BP_2
+#undef CHECK_UPDATE_BP_1
+
+	if (size_bp < size_buf)
+		buf[size_buf - size_bp - 1] = '\0'; /* remove last , */
+	else
+		buf[0] = '\0';
+}
+
+static void describe_balance_start_or_resume(struct btrfs_fs_info *fs_info)
+{
+	u32 size_buf = 1024;
+	char tmp_buf[192] = {'\0'};
+	char *buf;
+	char *bp;
+	u32 size_bp = size_buf;
+	int ret;
+	struct btrfs_balance_control *bctl = fs_info->balance_ctl;
+
+	buf = kzalloc(size_buf, GFP_KERNEL);
+	if (!buf)
+		return;
+
+	bp = buf;
+#define CHECK_UPDATE_BP_1(a) \
+	do { \
+		ret = snprintf(bp, size_bp, a); \
+		if (ret < 0 || ret >= size_bp) \
+			return; \
+		size_bp -= ret; \
+		bp += ret; \
+	} while (0)
+
+#define CHECK_UPDATE_BP_2(a, v1) \
+	do { \
+		ret = snprintf(bp, size_bp, a, v1); \
+		if (ret < 0 || ret >= size_bp) \
+			return; \
+		size_bp -= ret; \
+		bp += ret; \
+	} while (0)
+
+	if (bctl->flags & BTRFS_BALANCE_FORCE) {
+		CHECK_UPDATE_BP_1("-f ");
+	}
+
+	if (bctl->flags & BTRFS_BALANCE_DATA) {
+		describe_balance_args(&bctl->data, tmp_buf, sizeof(tmp_buf));
+		CHECK_UPDATE_BP_2("-d%s ", tmp_buf);
+	}
+
+	if (bctl->flags & BTRFS_BALANCE_METADATA) {
+		describe_balance_args(&bctl->meta, tmp_buf, sizeof(tmp_buf));
+		CHECK_UPDATE_BP_2("-m%s ", tmp_buf);
+	}
+
+	if (bctl->flags & BTRFS_BALANCE_SYSTEM) {
+		describe_balance_args(&bctl->sys, tmp_buf, sizeof(tmp_buf));
+		CHECK_UPDATE_BP_2("-s%s ", tmp_buf);
+	}
+
+#undef CHECK_UPDATE_BP_2
+#undef CHECK_UPDATE_BP_1
+
+	if (size_bp < size_buf)
+		buf[size_buf - size_bp - 1] = '\0'; /* remove last " "*/
+	btrfs_info(fs_info, "%s %s",
+		   bctl->flags & BTRFS_BALANCE_RESUME ?
+		   "balance: resume":"balance: start", buf);
+
+	kfree(buf);
+}
+
 /*
  * Should be called with balance mutexe held
  */
@@ -3893,6 +4060,7 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
 
 	ASSERT(!test_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags));
 	set_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags);
+	describe_balance_start_or_resume(fs_info);
 	mutex_unlock(&fs_info->balance_mutex);
 
 	ret = __btrfs_balance(fs_info);
@@ -3930,10 +4098,8 @@ static int balance_kthread(void *data)
 	int ret = 0;
 
 	mutex_lock(&fs_info->balance_mutex);
-	if (fs_info->balance_ctl) {
-		btrfs_info(fs_info, "balance: resuming");
+	if (fs_info->balance_ctl)
 		ret = btrfs_balance(fs_info, fs_info->balance_ctl, NULL);
-	}
 	mutex_unlock(&fs_info->balance_mutex);
 
 	return ret;
-- 
1.8.3.1

