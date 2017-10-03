Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:29281 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751102AbdJCIMw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Oct 2017 04:12:52 -0400
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 3BE59AC00DC
        for <linux-btrfs@vger.kernel.org>; Tue,  3 Oct 2017 17:12:47 +0900 (JST)
Received: from G01JPEXCHYT13.g01.fujitsu.local (G01JPEXCHYT13.g01.fujitsu.local [10.128.194.52])
        by g01jpfmpwyt01.exch.g01.fujitsu.local (Postfix) with ESMTP id 85BBF6D6745
        for <linux-btrfs@vger.kernel.org>; Tue,  3 Oct 2017 17:12:46 +0900 (JST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: doc: update help/document of btrfs device remove
Message-ID: <ea8188b9-539c-cf62-3201-25521ea45386@jp.fujitsu.com>
Date: Tue, 3 Oct 2017 17:12:39 +0900
MIME-Version: 1.0
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
---
 Documentation/btrfs-device.asciidoc | 19 +++++++++++++++++++
 cmds-device.c                       | 10 +++++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-device.asciidoc b/Documentation/btrfs-device.asciidoc
index 88822ec..dc523a9 100644
--- a/Documentation/btrfs-device.asciidoc
+++ b/Documentation/btrfs-device.asciidoc
@@ -75,6 +75,10 @@ The operation can take long as it needs to move all data from the device.
 It is possible to delete the device that was used to mount the filesystem. The
 device entry in mount table will be replaced by another device name with the
 lowest device id.
++
+If device is mounted as degraded mode (-o degraded), special term "missing"
+can be used for <device>. In that case, the first device that is described by
+the filesystem metadata, but not presented at the mount time will be removed.
 
 *delete* <device>|<devid> [<device>|<devid>...] <path>::
 Alias of remove kept for backward compatibility
@@ -206,6 +210,21 @@ data or the block groups occupy the whole first device.
 The device size of '/dev/sdb' as seen by the filesystem remains unchanged, but
 the logical space from 50-100GiB will be unused.
 
+==== REMOVE DEVICE ====
+
+Device removal must satisfy the profile constraints, otherwise the command
+fails. For example:
+
+ $ btrfs device remove /dev/sda /mnt
+ $ ERROR: error removing device '/dev/sda': unable to go below two devices on raid1
+
+
+In order to remove a device, you need to convert profile in this case:
+
+ $ btrfs balance start -mconvert=dup /mnt
+ $ btrfs balance start -dconvert=single /mnt
+ $ btrfs device remove /dev/sda /mnt
+
 DEVICE STATS
 ------------
 
diff --git a/cmds-device.c b/cmds-device.c
index 4337eb2..6cb53ff 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -224,9 +224,16 @@ static int _cmd_device_remove(int argc, char **argv,
 	return !!ret;
 }
 
+#define COMMON_USAGE_REMOVE_DELETE \
+	"", \
+	"If 'missing' is specified for <device>, the first device that is", \
+	"described by the filesystem metadata, but not presented at the", \
+	"mount time will be removed."
+
 static const char * const cmd_device_remove_usage[] = {
 	"btrfs device remove <device>|<devid> [<device>|<devid>...] <path>",
 	"Remove a device from a filesystem",
+	COMMON_USAGE_REMOVE_DELETE,
 	NULL
 };
 
@@ -237,7 +244,8 @@ static int cmd_device_remove(int argc, char **argv)
 
 static const char * const cmd_device_delete_usage[] = {
 	"btrfs device delete <device>|<devid> [<device>|<devid>...] <path>",
-	"Remove a device from a filesystem",
+	"Remove a device from a filesystem (alias of \"btrfs device remove\")",
+	COMMON_USAGE_REMOVE_DELETE,
 	NULL
 };
 
-- 
2.9.5

