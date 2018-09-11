Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:59576 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726601AbeIKQdZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 12:33:25 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 4E8FE4B66B9F
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 19:34:25 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [RFC PATCH v2 1/2] btrfs-progs: ioctl: add BTRFS_IOC_SUBVOL_UNDELETE to ioctl.h
Date: Tue, 11 Sep 2018 19:34:16 +0800
Message-ID: <20180911113417.26466-1-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180911112903.25985-1-lufq.fnst@cn.fujitsu.com>
References: <20180911112903.25985-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Copied from uapi/linux/btrfs.h.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 ioctl.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/ioctl.h b/ioctl.h
index 709e996f401c..75978a4e8265 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -670,6 +670,11 @@ struct btrfs_ioctl_send_args_64 {
 } __attribute__((packed));
 BUILD_ASSERT(sizeof(struct btrfs_ioctl_send_args_64) == 72);
 
+struct btrfs_ioctl_subvol_undelete_args {
+	__u64 subvol_id;
+	char name[BTRFS_PATH_NAME_MAX + 1];
+};
+
 #define BTRFS_IOC_SEND_64_COMPAT_DEFINED 1
 
 /* Error codes as returned by the kernel */
@@ -828,6 +833,8 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
                                   struct btrfs_ioctl_feature_flags[3])
 #define BTRFS_IOC_RM_DEV_V2	_IOW(BTRFS_IOCTL_MAGIC, 58, \
 				   struct btrfs_ioctl_vol_args_v2)
+#define BTRFS_IOC_SUBVOL_UNDELETE _IOWR(BTRFS_IOCTL_MAGIC, 63, \
+				struct btrfs_ioctl_subvol_undelete_args)
 #ifdef __cplusplus
 }
 #endif
-- 
2.18.0
