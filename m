Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33972 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935525Ab3FUH2X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Jun 2013 03:28:23 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r5L7M46c030194
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 07:22:05 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5L7SLq5015213
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 07:28:22 GMT
Received: from abhmt113.oracle.com (abhmt113.oracle.com [141.146.116.65])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5L7SL1V029771
	for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 07:28:21 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2 v3] btrfs: obtain used_bytes in BTRFS_IOC_FS_INFO ioctl
Date: Fri, 21 Jun 2013 15:32:28 +0800
Message-Id: <1371799948-14176-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1370876355-16584-3-git-send-email-anand.jain@oracle.com>
References: <1370876355-16584-3-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs-progs has to read fs info from the kernel to
read the latest info instead of reading it from the disks,
which generally is a stale info after certain critical
operation.

getting used_bytes parameter will help to fix
	btrfs filesystem show --kernel
to show the current info of the fs

v2->v3:
	everything is changed dropped the plan to introduce
	the new ioctl, as of now filesystem show could 
	manage if we add the used_bytes parameter to the
	BTRFS_IOC_FS_INFO and
	Update the title from
	 add framework to read fs info and dev info from the kernel

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ioctl.c           | 16 ++++++++++++++--
 include/uapi/linux/btrfs.h |  3 ++-
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0e7bcc5..082c9fc 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2384,7 +2384,10 @@ static long btrfs_ioctl_fs_info(struct btrfs_root *root, void __user *arg)
 	struct btrfs_ioctl_fs_info_args *fi_args;
 	struct btrfs_device *device;
 	struct btrfs_device *next;
-	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
+	struct btrfs_fs_info *info = root->fs_info;
+	struct btrfs_fs_devices *fs_devices = info->fs_devices;
+	struct btrfs_space_info *si;
+	u64 used_bytes = 0;
 	int ret = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -2394,8 +2397,17 @@ static long btrfs_ioctl_fs_info(struct btrfs_root *root, void __user *arg)
 	if (!fi_args)
 		return -ENOMEM;
 
+	rcu_read_lock();
+	list_for_each_entry_rcu(si, &info->space_info, list) {
+		used_bytes += si->bytes_used + si->bytes_reserved
+				+ si->bytes_pinned + si->bytes_readonly
+				+ si->bytes_may_use;
+	}
+	rcu_read_unlock();
+	fi_args->used_bytes = used_bytes;
+
 	fi_args->num_devices = fs_devices->num_devices;
-	memcpy(&fi_args->fsid, root->fs_info->fsid, sizeof(fi_args->fsid));
+	memcpy(&fi_args->fsid, info->fsid, sizeof(fi_args->fsid));
 
 	mutex_lock(&fs_devices->device_list_mutex);
 	list_for_each_entry_safe(device, next, &fs_devices->devices, dev_list) {
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index de3ec34..44bac0c 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -181,7 +181,8 @@ struct btrfs_ioctl_fs_info_args {
 	__u64 max_id;				/* out */
 	__u64 num_devices;			/* out */
 	__u8 fsid[BTRFS_FSID_SIZE];		/* out */
-	__u64 reserved[124];			/* pad to 1k */
+	__u64 used_bytes;                       /* out */
+	__u64 reserved[123];			/* pad to 1k */
 };
 
 /* balance control ioctl modes */
-- 
1.8.1.227.g44fe835

