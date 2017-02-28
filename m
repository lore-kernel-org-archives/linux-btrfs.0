Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vmicros1.altlinux.org ([194.107.17.57]:46254 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751620AbdB1XNz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Feb 2017 18:13:55 -0500
Date: Wed, 1 Mar 2017 02:12:50 +0300
From: "Dmitry V. Levin" <ldv@altlinux.org>
To: Chris Mason <clm@fb.com>
Cc: Jeff Mahoney <jeffm@suse.com>, David Sterba <dsterba@suse.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] btrfs: remove btrfs_err_str function from uapi/linux/btrfs.h
Message-ID: <20170228231250.GA10156@altlinux.org>
References: <20170215200259.GA1028@altlinux.org> <e5736c5a-1cef-58cb-a171-055e139e26e7@suse.com> <20170215225503.GA2947@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170215225503.GA2947@altlinux.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_err_str function is not called from anywhere and is replicated
in the userspace headers for btrfs-progs.

It's removal also fixes the following linux/btrfs.h userspace
compilation error:

/usr/include/linux/btrfs.h: In function 'btrfs_err_str':
/usr/include/linux/btrfs.h:740:11: error: 'NULL' undeclared (first use in this function)
    return NULL;

Suggested-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
Reviewed-by: David Sterba <dsterba@suse.com>
---
v3: the patch seems to be lost, resending with updated list of addressees

v2: remove btrfs_err_str rather than fix it

 include/uapi/linux/btrfs.h | 27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index db4c253..dcfc3a5 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -713,33 +713,6 @@ enum btrfs_err_code {
 	BTRFS_ERROR_DEV_ONLY_WRITABLE,
 	BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS
 };
-/* An error code to error string mapping for the kernel
-*  error codes
-*/
-static inline char *btrfs_err_str(enum btrfs_err_code err_code)
-{
-	switch (err_code) {
-		case BTRFS_ERROR_DEV_RAID1_MIN_NOT_MET:
-			return "unable to go below two devices on raid1";
-		case BTRFS_ERROR_DEV_RAID10_MIN_NOT_MET:
-			return "unable to go below four devices on raid10";
-		case BTRFS_ERROR_DEV_RAID5_MIN_NOT_MET:
-			return "unable to go below two devices on raid5";
-		case BTRFS_ERROR_DEV_RAID6_MIN_NOT_MET:
-			return "unable to go below three devices on raid6";
-		case BTRFS_ERROR_DEV_TGT_REPLACE:
-			return "unable to remove the dev_replace target dev";
-		case BTRFS_ERROR_DEV_MISSING_NOT_FOUND:
-			return "no missing devices found to remove";
-		case BTRFS_ERROR_DEV_ONLY_WRITABLE:
-			return "unable to remove the only writeable device";
-		case BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS:
-			return "add/delete/balance/replace/resize operation "\
-				"in progress";
-		default:
-			return NULL;
-	}
-}
 
 #define BTRFS_IOC_SNAP_CREATE _IOW(BTRFS_IOCTL_MAGIC, 1, \
 				   struct btrfs_ioctl_vol_args)
-- 
ldv
