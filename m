Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11878 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758192AbaDBI3C (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Apr 2014 04:29:02 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s328Sj4b014953
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Apr 2014 16:28:45 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 14/27] btrfs-progs: Convert man page for btrfs-replace.
Date: Wed, 2 Apr 2014 16:29:25 +0800
Message-ID: <1396427378-10487-15-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Convert man page for btrfs-replace.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/Makefile          |  2 +-
 Documentation/btrfs-replace.txt | 76 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/btrfs-replace.txt

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 84a4859..a4f7ef0 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -28,7 +28,7 @@ MAN8_TXT += btrfs-send.txt
 MAN8_TXT += btrfs-receive.txt
 MAN8_TXT += btrfs-quota.txt
 MAN8_TXT += btrfs-qgroup.txt
-#MAN8_TXT += btrfs-replace.txt
+MAN8_TXT += btrfs-replace.txt
 #MAN8_TXT += btrfs-dedup.txt
 
 MAN_TXT = $(MAN8_TXT)
diff --git a/Documentation/btrfs-replace.txt b/Documentation/btrfs-replace.txt
new file mode 100644
index 0000000..8c5dcc4
--- /dev/null
+++ b/Documentation/btrfs-replace.txt
@@ -0,0 +1,76 @@
+btrfs-replace(8)
+===============
+
+NAME
+----
+btrfs-replace - replace devices managed by btrfs with other device.
+
+SYNOPSIS
+--------
+'btrfs replace' <subcommand> <args>
+
+DESCRIPTION
+-----------
+'btrfs replace' is used to replace btrfs managed devices with other device.
+
+SUBCOMMAND
+----------
+'start' [-Bfr] <srcdev>|<devid> <targetdev> <path>::
+Replace device of a btrfs filesystem.
++
+On a live filesystem, duplicate the data to the target device which
+is currently stored on the source device.
+If the source device is not available anymore, or if the -r option is set,
+the data is built only using the RAID redundancy mechanisms.
+After completion of the operation, the source device is removed from the
+filesystem.
+If the <srcdev> is a numerical value, it is assumed to be the device id
+of the filesystem which is mounted at <path>, otherwise is is
+the path to the source device. If the source device is disconnected,
+from the system, you have to use the devid parameter format.
+The <targetdev> needs to be same size or larger than the <srcdev>.
++
+`Options`
++
+-r::::
+only read from <srcdev> if no other zero-defect mirror exists.
+(enable this if your drive has lots of read errors, the access would be very
+slow)
+-f::::
+force using and overwriting <targetdev> even if it looks like
+containing a valid btrfs filesystem.
++
+A valid filesystem is assumed if a btrfs superblock is found which contains a
+correct checksum. Devices which are currently mounted are
+never allowed to be used as the <targetdev>.
+-B::::
+no background replace.
+
+'status' [-1] <mount_point>::
+Print status and progress information of a running device replace operation.
++
+`Options`
++
+-1::::
+print once instead of print continuously until the replace
+operation finishes (or is canceled)
+
+'cancel' <mount_point>::
+Cancel a running device replace operation.
+
+EXIT STATUS
+-----------
+'btrfs replace' returns a zero exist status if it succeeds. Non zero is
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

