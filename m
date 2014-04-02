Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16608 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758189AbaDBI3B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Apr 2014 04:29:01 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s328Shx3014947
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Apr 2014 16:28:43 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 12/27] btrfs-progs: Convert man page for btrfs-quota.
Date: Wed, 2 Apr 2014 16:29:23 +0800
Message-ID: <1396427378-10487-13-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Convert man page for btrfs-quota.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/Makefile        |  2 +-
 Documentation/btrfs-quota.txt | 59 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/btrfs-quota.txt

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 2af4d40..645a8e4 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -26,7 +26,7 @@ MAN8_TXT += btrfs-rescue.txt
 MAN8_TXT += btrfs-inspect-internal.txt
 MAN8_TXT += btrfs-send.txt
 MAN8_TXT += btrfs-receive.txt
-#MAN8_TXT += btrfs-quota.txt
+MAN8_TXT += btrfs-quota.txt
 #MAN8_TXT += btrfs-replace.txt
 #MAN8_TXT += btrfs-dedup.txt
 
diff --git a/Documentation/btrfs-quota.txt b/Documentation/btrfs-quota.txt
new file mode 100644
index 0000000..82f2f49
--- /dev/null
+++ b/Documentation/btrfs-quota.txt
@@ -0,0 +1,59 @@
+btrfs-quota(8)
+==============
+
+NAME
+----
+btrfs-quota - control the quota of a btrfs filesystem
+
+SYNOPSIS
+--------
+'btrfs quota' <subcommand> <args>
+
+DESCRIPTION
+-----------
+'btrfs quota' is used to enable/disable or rescan subvolume quota of a btrfs
+filesystem.
+
+For setting quota or other quota operations on a btrfs filesystem, please see
+`btrfs-qgroup`(8) for details.
+
+WARNING: Quota and qgroup in btrfs filesystem is not stable and impacts
+performance in mainline kernel yet(v3.14 so far).
+
+SUBCOMMAND
+----------
+'enable' <path>::
+Enable subvolume quota support for a filesystem.
+
+
+'disable' <path>::
+Disable subvolume quota support for a filesystem.
+
+'rescan' [-s] <path>::
+Trash all qgroup numbers and scan the metadata again with the current config.
++
+`Options`
++
+-s::::
+show status of a running rescan operation.
+-w::::
+wait for rescan operation to finish(can be already in progress).
+
+EXIT STATUS
+-----------
+'btrfs quota' returns a zero exist status if it succeeds. Non zero is
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
+`btrfs-subvolume`(8),
+`btrfs-qgroup`(8)
-- 
1.9.1

