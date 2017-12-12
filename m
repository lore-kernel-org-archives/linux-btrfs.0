Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:53180 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751053AbdLLHHO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 02:07:14 -0500
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 45384AC00AF
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Dec 2017 16:07:10 +0900 (JST)
Received: from G01JPEXCHKW14.g01.fujitsu.local (G01JPEXCHKW14.g01.fujitsu.local [10.0.194.53])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 9EF1BBD66E3
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Dec 2017 16:07:09 +0900 (JST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH 1/2] btrfs-progs: prop: check FS_NOCOMP_FL flag in property
 get
Message-ID: <6dabbe1b-87a2-77cd-4fca-9835a1573961@jp.fujitsu.com>
Date: Tue, 12 Dec 2017 16:07:05 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If "property set ... compression no" is called, it sets FS_NOCOMP_FL flag
(which is equivalent to BTRFS_INODE_NO_COMPRESS in btrfs). This means
compression will not be done and is different from default status.

However, current "property get" won't check the status of FS_NOCOMP_FL and
the output (no output message) cannot be distinguished from the default
status when the flag is set. 

Fix this to call FS_IOC_GETFLAGS to check FS_NOCOMP_FL flag and print
"compression=no" if the flag is set.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 props.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/props.c b/props.c
index cddbd927..3af349af 100644
--- a/props.c
+++ b/props.c
@@ -14,6 +14,7 @@
  * Boston, MA 021110-1307, USA.
  */
 
+#include <linux/fs.h>
 #include <sys/stat.h>
 #include <sys/ioctl.h>
 #include <sys/types.h>
@@ -151,11 +152,19 @@ static int prop_compression(enum prop_object_type type,
 	}
 	if (sret < 0) {
 		ret = -errno;
-		if (ret != -ENOATTR)
+		if (ret != -ENOATTR) {
 			error("failed to %s compression for %s: %s",
 			      value ? "set" : "get", object, strerror(-ret));
-		else
-			ret = 0;
+		} else {
+			unsigned int flags = 0;
+
+			ret = ioctl(fd, FS_IOC_GETFLAGS, &flags);
+			if (ret)
+				error("failed to get FS_FLAGS for %s: %s",
+						object, strerror(ret));
+			else if (flags & FS_NOCOMP_FL)
+				fprintf(stdout, "compression=no\n");
+		}
 		goto out;
 	}
 	if (!value) {
-- 
2.13.6


