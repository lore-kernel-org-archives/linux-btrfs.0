Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:36186 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751707AbdJTBnR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Oct 2017 21:43:17 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id D562CAC00DB
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Oct 2017 10:43:09 +0900 (JST)
Received: from g01jpexchkw35.g01.fujitsu.local (unknown [10.0.193.4])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 16B1BBD6860
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Oct 2017 10:43:09 +0900 (JST)
Subject: [PATCH v4 2/2] btrfs-progs: doc: add description of missing and
 example, of device remove
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <89bcb689-586e-f69b-2f4f-ac5f99765924@jp.fujitsu.com>
Message-ID: <ebff8747-74d3-dcc6-d36c-051c9f332a64@jp.fujitsu.com>
Date: Fri, 20 Oct 2017 10:43:05 +0900
MIME-Version: 1.0
In-Reply-To: <89bcb689-586e-f69b-2f4f-ac5f99765924@jp.fujitsu.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch updates help/document of "btrfs device remove" in two points:

1. Add explanation of 'missing' for 'device remove'. This is only
written in wikipage currently.
(https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices)

2. Add example of device removal in the man document. This is because
that explanation of "remove" says "See the example section below", but
there is no example of removal currently.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
Reviewed-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>
---
 Documentation/btrfs-device.asciidoc | 24 +++++++++++++++++++++++-
 cmds-device.c                       |  8 ++++++++
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-device.asciidoc b/Documentation/btrfs-device.asciidoc
index 88822ec..2ed1e61 100644
--- a/Documentation/btrfs-device.asciidoc
+++ b/Documentation/btrfs-device.asciidoc
@@ -68,13 +68,22 @@ Remove device(s) from a filesystem identified by <path>
 Device removal must satisfy the profile constraints, otherwise the command
 fails. The filesystem must be converted to profile(s) that would allow the
 removal. This can typically happen when going down from 2 devices to 1 and
-using the RAID1 profile. See the example section below.
+using the RAID1 profile. See the *TYPICAL USECASES* section below.
 +
 The operation can take long as it needs to move all data from the device.
 +
 It is possible to delete the device that was used to mount the filesystem. The
 device entry in mount table will be replaced by another device name with the
 lowest device id.
++
+If filesystem is mounted in degraded mode (-o degraded), special term "missing"
+can be used for <device>. In that case, the first device that is described by
+the filesystem metadata, but not present at the mount time will be removed.
++
+NOTE: In most cases, there is only one missing device in degraded mode,
+otherwise mount fails. If there are two or more devices missing (e.g. possible
+in RAID 6), you need specify "missing" as many times as the number of missing
+devices to remove all of them.
 
 *delete* <device>|<devid> [<device>|<devid>...] <path>::
 Alias of remove kept for backward compatibility
@@ -206,6 +215,19 @@ data or the block groups occupy the whole first device.
 The device size of '/dev/sdb' as seen by the filesystem remains unchanged, but
 the logical space from 50-100GiB will be unused.
 
+==== REMOVE DEVICE ====
+
+Device removal must satisfy the profile constraints, otherwise the command
+fails. For example:
+
+ $ btrfs device remove /dev/sda /mnt
+ ERROR: error removing device '/dev/sda': unable to go below two devices on raid1
+
+In order to remove a device, you need to convert the profile in this case:
+
+ $ btrfs balance start -mconvert=dup -dconvert=single /mnt
+ $ btrfs device remove /dev/sda /mnt
+
 DEVICE STATS
 ------------
 
diff --git a/cmds-device.c b/cmds-device.c
index 3b6b985..e7e9ed5 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -224,9 +224,16 @@ static int _cmd_device_remove(int argc, char **argv,
 	return !!ret;
 }
 
+#define COMMON_USAGE_REMOVE_DELETE \
+	"", \
+	"If 'missing' is specified for <device>, the first device that is", \
+	"described by the filesystem metadata, but not present at the mount", \
+	"time will be removed. (only in degraded mode)"
+
 static const char * const cmd_device_remove_usage[] = {
 	"btrfs device remove <device>|<devid> [<device>|<devid>...] <path>",
 	"Remove a device from a filesystem",
+	COMMON_USAGE_REMOVE_DELETE,
 	NULL
 };
 
@@ -238,6 +245,7 @@ static int cmd_device_remove(int argc, char **argv)
 static const char * const cmd_device_delete_usage[] = {
 	"btrfs device delete <device>|<devid> [<device>|<devid>...] <path>",
 	"Remove a device from a filesystem (alias of \"btrfs device remove\")",
+	COMMON_USAGE_REMOVE_DELETE,
 	NULL
 };
 
-- 
2.9.5

