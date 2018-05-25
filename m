Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:35864 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751299AbeEYDDN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 May 2018 23:03:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4P31RZd191554
        for <linux-btrfs@vger.kernel.org>; Fri, 25 May 2018 03:03:13 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2j62swhffv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 25 May 2018 03:03:13 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w4P33C6o021268
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 25 May 2018 03:03:12 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w4P33CQn014288
        for <linux-btrfs@vger.kernel.org>; Fri, 25 May 2018 03:03:12 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4.1b 2/3] btrfs: balance: add args info during start and resume
Date: Fri, 25 May 2018 11:05:47 +0800
Message-Id: <20180525030547.23367-1-anand.jain@oracle.com>
In-Reply-To: <20180523063508.18695-3-anand.jain@oracle.com>
References: <20180523063508.18695-3-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Balance arg info is an important information to be reviewed for the
system audit. So this patch adds them to the kernel log.

Example:
->btrfs bal start -f -mprofiles=raid1,convert=single,soft -dlimit=10..20,usage=50 /btrfs

kernel: BTRFS info (device sdb): balance: start -f -dusage=50,limit=10..20 -msoft,profiles=raid1,convert=single -ssoft,profiles=raid1,convert=single

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v4->v4.1b: Rename last missed sz to size_buf.
	   Allocate at least (64*3) 192 bytes for tmp_buf.
	   Log format change: No space after group type,
	    as in the above Example.
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

 fs/btrfs/volumes.c | 107 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 104 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e858882a98eb..c02a4fb8ae7e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3809,6 +3809,108 @@ static inline int validate_convert_profile(struct btrfs_balance_args *bctl_arg,
 		 (bctl_arg->target & ~allowed)));
 }
 
+static u32 describe_balance_args(struct btrfs_balance_args *bargs, char *buf,
+				 u32 size_buf)
+{
+	char *bp = buf;
+	u64 flags = bargs->flags;
+	char tmp_buf[128];
+
+	if (!flags)
+		return 0;
+
+	if (flags & BTRFS_BALANCE_ARGS_SOFT)
+		bp += snprintf(bp, buf - bp + size_buf, "soft,");
+
+	if (flags & BTRFS_BALANCE_ARGS_PROFILES) {
+		btrfs_describe_block_groups(bargs->profiles, tmp_buf,
+					    sizeof(tmp_buf));
+		bp += snprintf(bp, buf - bp + size_buf, "profiles=%s,",
+			       tmp_buf);
+	}
+
+	if (flags & BTRFS_BALANCE_ARGS_USAGE)
+		bp += snprintf(bp, buf - bp + size_buf, "usage=%llu,",
+			       bargs->usage);
+
+	if (flags & BTRFS_BALANCE_ARGS_USAGE_RANGE)
+		bp += snprintf(bp, buf - bp + size_buf, "usage=%u..%u,",
+			       bargs->usage_min, bargs->usage_max);
+
+	if (flags & BTRFS_BALANCE_ARGS_DEVID)
+		bp += snprintf(bp, buf - bp + size_buf, "devid=%llu,",
+			       bargs->devid);
+
+	if (flags & BTRFS_BALANCE_ARGS_DRANGE)
+		bp += snprintf(bp, buf - bp + size_buf, "drange=%llu..%llu,",
+			       bargs->pstart, bargs->pend);
+
+	if (flags & BTRFS_BALANCE_ARGS_VRANGE)
+		bp += snprintf(bp, buf - bp + size_buf, "vrange%llu..%llu,",
+			       bargs->vstart, bargs->vend);
+
+	if (flags & BTRFS_BALANCE_ARGS_LIMIT)
+		bp += snprintf(bp, buf - bp + size_buf, "limit=%llu,",
+			       bargs->limit);
+
+	if (flags & BTRFS_BALANCE_ARGS_LIMIT_RANGE)
+		bp += snprintf(bp, buf - bp + size_buf, "limit=%u..%u,",
+			       bargs->limit_min, bargs->limit_max);
+
+	if (flags & BTRFS_BALANCE_ARGS_STRIPES_RANGE)
+		bp += snprintf(bp, buf - bp + size_buf, "stripes=%u..%u,",
+			       bargs->stripes_min, bargs->stripes_max);
+
+	if (flags & BTRFS_BALANCE_ARGS_CONVERT) {
+		int index = btrfs_bg_flags_to_raid_index(bargs->target);
+
+		bp += snprintf(bp, buf - bp + size_buf, "convert=%s,",
+			       get_raid_name(index));
+	}
+
+	buf[bp - buf - 1] = '\0'; /* remove last , */
+	return bp - buf - 1;
+}
+
+static void describe_balance_start_or_resume(struct btrfs_fs_info *fs_info)
+{
+	u32 size_buf = 1024;
+	char tmp_buf[192];
+	char *buf;
+	char *bp;
+	struct btrfs_balance_control *bctl = fs_info->balance_ctl;
+
+	buf = kzalloc(size_buf, GFP_KERNEL);
+	if (!buf)
+		return;
+
+	bp = buf;
+	if (bctl->flags & BTRFS_BALANCE_FORCE)
+		bp += snprintf(bp, buf - bp + size_buf, "-f ");
+
+	if (bctl->flags & BTRFS_BALANCE_DATA) {
+		describe_balance_args(&bctl->data, tmp_buf, sizeof(tmp_buf));
+		bp += snprintf(bp, buf - bp + size_buf, "-d%s ", tmp_buf);
+	}
+
+	if (bctl->flags & BTRFS_BALANCE_METADATA) {
+		describe_balance_args(&bctl->meta, tmp_buf, sizeof(tmp_buf));
+		bp += snprintf(bp, buf - bp + size_buf, "-m%s ", tmp_buf);
+	}
+
+	if (bctl->flags & BTRFS_BALANCE_SYSTEM) {
+		describe_balance_args(&bctl->sys, tmp_buf, sizeof(tmp_buf));
+		bp += snprintf(bp, buf - bp + size_buf, "-s%s ", tmp_buf);
+	}
+
+	buf[bp - buf - 1] = '\0'; /* remove last " "*/
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
@@ -3953,6 +4055,7 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
 
 	ASSERT(!test_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags));
 	set_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags);
+	describe_balance_start_or_resume(fs_info);
 	mutex_unlock(&fs_info->balance_mutex);
 
 	ret = __btrfs_balance(fs_info);
@@ -3990,10 +4093,8 @@ static int balance_kthread(void *data)
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
2.7.0

