Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11878 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758143AbaDBI2y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Apr 2014 04:28:54 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s328SbCw014922
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Apr 2014 16:28:37 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 05/27] btrfs-progs: Convert man page for btrfs-device subcommand.
Date: Wed, 2 Apr 2014 16:29:16 +0800
Message-ID: <1396427378-10487-6-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Convert man page for btrfs-device subcommand.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/Makefile         |  2 +-
 Documentation/btrfs-device.txt | 75 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/btrfs-device.txt

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 4839b6d..79ae9de 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -19,7 +19,7 @@ MAN8_TXT += btrfs.txt
 MAN8_TXT += btrfs-subvolume.txt
 MAN8_TXT += btrfs-filesystem.txt
 MAN8_TXT += btrfs-balance.txt
-#MAN8_TXT += btrfs-device.txt
+MAN8_TXT += btrfs-device.txt
 #MAN8_TXT += btrfs-scrub.txt
 #MAN8_TXT += btrfs-check.txt
 #MAN8_TXT += btrfs-rescue.txt
diff --git a/Documentation/btrfs-device.txt b/Documentation/btrfs-device.txt
new file mode 100644
index 0000000..20d7bcd
--- /dev/null
+++ b/Documentation/btrfs-device.txt
@@ -0,0 +1,75 @@
+btrfs-device(8)
+===============
+
+NAME
+----
+btrfs-device - control btrfs devices
+
+SYNOPSIS
+--------
+'btrfs device' <subcommand> <args>
+
+DESCRIPTION
+-----------
+'btrfs device' is used to control the btrfs devices, since btrfs can be used
+across several devices, 'btrfs device' is used for multiple device management.
+
+SUBCOMMAND
+----------
+'add' [-Kf] <dev> [<dev>...] <path>::
+Add device(s) to the filesystem identified by <path>.
++
+If applicable, a whole device discard (TRIM) operation is performed.
++
+`Options`
++
+-K|--nodiscard::::
+do not perform discard by default
+-f|--force::::
+force overwrite of existing filesystem on the given disk(s)
+
+'delete' <dev> [<dev>...] <path>::
+Remove device(s) from a filesystem identified by <path>.
+
+'scan' [(--all-devices|-d)|<device> [<device>...]]::
+Scan devices for a btrfs filesystem.
++
+If one or more devices are passed, these are scanned for a btrfs filesystem. 
+If no devices are passed, btrfs uses block devices containing btrfs
+filesystem as listed by blkid.
+Finally, if '--all-devices' or '-d' is passed, all the devices under /dev are 
+scanned.
+
+'disk-usage' [-b] <path> [<path>..]::
+Show which chunks are in a device.
++
+If '-b' is given, byte will be set as unit.
+
+'ready' <device>::
+Check device to see if it has all of it's devices in cache for mounting.
+
+'stats' [-z] <path>|<device>::
+Read and print the device IO stats for all devices of the filesystem
+identified by <path> or for a single <device>.
++
+`Options`
++
+-z::::
+Reset stats to zero after reading them.
+
+EXIT STATUS
+-----------
+'btrfs device' returns a zero exist status if it succeeds. Non zero is
+returned in case of failure.
+
+AVAILABILITY
+------------
+'btrfs' is part of btrfs-progs. Btrfs filesystem is currently under heavy
+development,
+and not suitable for any uses other than benchmarking and review.
+Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
+further details.
+
+SEE ALSO
+--------
+`mkfs.btrfs`(8),
-- 
1.9.1

