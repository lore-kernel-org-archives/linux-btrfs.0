Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gabe.freedesktop.org ([131.252.210.177]:39429 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbcE1HNU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 May 2016 03:13:20 -0400
From: Vinson Lee <vlee@freedesktop.org>
To: David Sterba <dsterba@suse.com>, Josef Bacik <jbacik@fb.com>,
        Liu Bo <bo.li.liu@oracle.com>, Jeff Mahoney <jeffm@suse.com>,
        Chris Mason <clm@fb.com>,
        =?UTF-8?q?Gabr=C3=ADel=20Arth=C3=BAr=20P=C3=A9tursson?=
	<gabriel@system.is>,
        Anand Jain <anand.jain@oracle.com>
Cc: Vinson Lee <vlee@freedesktop.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: Use __u64 in exported linux/btrfs.h.
Date: Sat, 28 May 2016 07:04:38 +0000
Message-Id: <1464419078-19855-1-git-send-email-vlee@freedesktop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch fixes this build error.

/usr/include/linux/btrfs.h:121:3: error: unknown type name ‘u64’
   u64 devid;
   ^~~

Fixes: 6b526ed70cf1 ("btrfs: introduce device delete by devid")
Signed-off-by: Vinson Lee <vlee@freedesktop.org>
---
 include/uapi/linux/btrfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 23c6960e94a4..2bdd1e3e7007 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -118,7 +118,7 @@ struct btrfs_ioctl_vol_args_v2 {
 	};
 	union {
 		char name[BTRFS_SUBVOL_NAME_MAX + 1];
-		u64 devid;
+		__u64 devid;
 	};
 };
 
-- 
2.8.3

