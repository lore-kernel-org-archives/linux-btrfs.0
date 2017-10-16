Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm02.jp.fujitsu.com ([202.219.69.169]:15432 "EHLO
        mgwkm02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751126AbdJPE5B (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 00:57:01 -0400
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id EC798AC010D
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Oct 2017 13:56:57 +0900 (JST)
Received: from G01JPEXCHKW14.g01.fujitsu.local (G01JPEXCHKW14.g01.fujitsu.local [10.0.194.53])
        by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id 257136923B9
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Oct 2017 13:56:57 +0900 (JST)
Subject: [PATCH v3 2/2] btrfs-progs: doc: add description of missing and
 example of device remove
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <7dcb7f01-ce39-18a6-9a16-9230b76baf77@jp.fujitsu.com>
Message-ID: <d5e0465d-9606-1881-84a7-86c0d43e0033@jp.fujitsu.com>
Date: Mon, 16 Oct 2017 13:56:54 +0900
MIME-Version: 1.0
In-Reply-To: <7dcb7f01-ce39-18a6-9a16-9230b76baf77@jp.fujitsu.com>
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
 Documentation/btrfs-device.asciidoc | 19 ++++++++++++++++++-
 cmds-device.c                       |  8 ++++++++
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-device.asciidoc b/Documentation/btrfs-device.asciidoc
index 88822ec..dd60415 100644
--- a/Documentation/btrfs-device.asciidoc
+++ b/Documentation/btrfs-device.asciidoc
@@ -68,13 +68,17 @@ Remove device(s) from a filesystem identified by <path>
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
+If device is mounted as degraded mode (-o degraded), special term "missing"
+can be used for <device>. In that case, the first device that is described by
+the filesystem metadata, but not preseted at the mount time will be removed.
 
 *delete* <device>|<devid> [<device>|<devid>...] <path>::
 Alias of remove kept for backward compatibility
@@ -206,6 +210,19 @@ data or the block groups occupy the whole first device.
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
index 3b6b985..d28ed0f 100644
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
 
@@ -238,6 +245,7 @@ static int cmd_device_remove(int argc, char **argv)
 static const char * const cmd_device_delete_usage[] = {
 	"btrfs device delete <device>|<devid> [<device>|<devid>...] <path>",
 	"Remove a device from a filesystem (alias of \"btrfs device remove\")",
+	COMMON_USAGE_REMOVE_DELETE,
 	NULL
 };
 
-- 
2.9.5

