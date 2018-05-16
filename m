Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:32956 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752274AbeEPKBh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 06:01:37 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w4G9umob034892
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 10:01:36 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2hx29w43bw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 10:01:36 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w4GA1ZDu024185
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 10:01:35 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w4GA1Znv007965
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 10:01:35 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/3] btrfs: add mount option read_mirror_policy
Date: Wed, 16 May 2018 18:03:57 +0800
Message-Id: <20180516100359.7752-2-anand.jain@oracle.com>
In-Reply-To: <20180516100359.7752-1-anand.jain@oracle.com>
References: <20180516100359.7752-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In case of RAID1 and RAID10 devices are mirror-ed, a read IO can
pick any device for reading. This choice of picking a device for
reading should be configurable. In short not one policy would
satisfy all types of workload and configs.

So before we add more policies, this patch-set makes existing
$pid policy configurable from the mount option.

For example..
  mount -o read_mirror_policy=pid (which is also default)

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ctree.h   |  2 ++
 fs/btrfs/super.c   | 10 ++++++++++
 fs/btrfs/volumes.c |  8 +++++++-
 fs/btrfs/volumes.h |  5 +++++
 4 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index bfa96697209a..0d997939cdae 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1121,6 +1121,8 @@ struct btrfs_fs_info {
 	spinlock_t ref_verify_lock;
 	struct rb_root block_tree;
 #endif
+	/* Policy to balance read across mirrored devices */
+	int read_mirror_policy;
 };
 
 static inline struct btrfs_fs_info *btrfs_sb(struct super_block *sb)
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index c67fafaa2fe7..21eff0ac1e4f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -345,6 +345,7 @@ enum {
 #ifdef CONFIG_BTRFS_FS_REF_VERIFY
 	Opt_ref_verify,
 #endif
+	Opt_read_mirror_policy,
 	Opt_err,
 };
 
@@ -414,6 +415,7 @@ static const match_table_t tokens = {
 #ifdef CONFIG_BTRFS_FS_REF_VERIFY
 	{Opt_ref_verify, "ref_verify"},
 #endif
+	{Opt_read_mirror_policy, "read_mirror_policy=%s"},
 	{Opt_err, NULL},
 };
 
@@ -844,6 +846,14 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
 			btrfs_set_opt(info->mount_opt, REF_VERIFY);
 			break;
 #endif
+		case Opt_read_mirror_policy:
+			if (strcmp(args[0].from, "pid") == 0) {
+				info->read_mirror_policy =
+					BTRFS_READ_MIRROR_BY_PID;
+				break;
+			}
+			ret = -EINVAL;
+			goto out;
 		case Opt_err:
 			btrfs_info(info, "unrecognized mount option '%s'", p);
 			ret = -EINVAL;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 81fb38884cac..64dba5c4cf33 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5219,7 +5219,13 @@ static int find_live_mirror(struct btrfs_fs_info *fs_info,
 	else
 		num_stripes = map->num_stripes;
 
-	preferred_mirror = first + current->pid % num_stripes;
+	switch(fs_info->read_mirror_policy) {
+	case BTRFS_READ_MIRROR_DEFAULT:
+	case BTRFS_READ_MIRROR_BY_PID:
+	default:
+		preferred_mirror = first + current->pid % num_stripes;
+		break;
+	}
 
 	if (dev_replace_is_ongoing &&
 	    fs_info->dev_replace.cont_reading_from_srcdev_mode ==
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 5139ec8daf4c..953df9925832 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -34,6 +34,11 @@ struct btrfs_pending_bios {
 #define btrfs_device_data_ordered_init(device) do { } while (0)
 #endif
 
+enum btrfs_read_mirror_type {
+	BTRFS_READ_MIRROR_DEFAULT,
+	BTRFS_READ_MIRROR_BY_PID,
+};
+
 #define BTRFS_DEV_STATE_WRITEABLE	(0)
 #define BTRFS_DEV_STATE_IN_FS_METADATA	(1)
 #define BTRFS_DEV_STATE_MISSING		(2)
-- 
2.7.0

