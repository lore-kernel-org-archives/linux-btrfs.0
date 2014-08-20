Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875AbaHTWXR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Aug 2014 18:23:17 -0400
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s7KMNGFh029824
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 20 Aug 2014 18:23:16 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s7KMNFeI025649
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 20 Aug 2014 18:23:16 -0400
Message-ID: <53F51FD8.4020800@redhat.com>
Date: Wed, 20 Aug 2014 17:23:20 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/3] btrfs-progs: don't fall back to recursive /dev scan
References: <53F51F4D.2090203@redhat.com>
In-Reply-To: <53F51F4D.2090203@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we didn't find what we are looking for in /proc/partitions,
we're not going to find it by scanning every node under /dev, either.

But that's just what btrfs_scan_for_fsid() does.

Remove that fallback; at that point btrfs_scan_for_fsid() just calls
scan_for_btrfs(), so remove the wrapper & call it directly.

Side note: so, these paths always use /proc/partitions, not libblkid.
Userspace-intiated scans default to libblkid.  I presume this is
part of the design, and intentional?  Anyway, not changing it now!

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/disk-io.c b/disk-io.c
index d10d647..077eb7e 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -1018,7 +1018,7 @@ int btrfs_scan_fs_devices(int fd, const char *path,
 	}
 
 	if (total_devs != 1) {
-		ret = btrfs_scan_for_fsid(run_ioctl);
+		ret = scan_for_btrfs(BTRFS_SCAN_PROC, run_ioctl);
 		if (ret)
 			return ret;
 	}
diff --git a/utils.c b/utils.c
index d61cbec..12ed7a2 100644
--- a/utils.c
+++ b/utils.c
@@ -1151,7 +1151,7 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 
 	/* scan other devices */
 	if (is_btrfs && total_devs > 1) {
-		if ((ret = btrfs_scan_for_fsid(!BTRFS_UPDATE_KERNEL)))
+		if ((ret = scan_for_btrfs(BTRFS_SCAN_PROC, !BTRFS_UPDATE_KERNEL)))
 			return ret;
 	}
 
@@ -1339,16 +1339,6 @@ fail:
 	return ret;
 }
 
-int btrfs_scan_for_fsid(int run_ioctls)
-{
-	int ret;
-
-	ret = scan_for_btrfs(BTRFS_SCAN_PROC, run_ioctls);
-	if (ret)
-		ret = scan_for_btrfs(BTRFS_SCAN_DEV, run_ioctls);
-	return ret;
-}
-
 int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 				 int super_offset)
 {

