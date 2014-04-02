Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11878 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758184AbaDBI26 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Apr 2014 04:28:58 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s328SeEj014935
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Apr 2014 16:28:40 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 08/27] btrfs-progs: Convert man page for btrfs-rescue
Date: Wed, 2 Apr 2014 16:29:19 +0800
Message-ID: <1396427378-10487-9-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Convert man page for btrfs-rescue.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/Makefile         |  2 +-
 Documentation/btrfs-rescue.txt | 60 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/btrfs-rescue.txt

diff --git a/Documentation/Makefile b/Documentation/Makefile
index a838ca1..ebe0455 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -22,7 +22,7 @@ MAN8_TXT += btrfs-balance.txt
 MAN8_TXT += btrfs-device.txt
 MAN8_TXT += btrfs-scrub.txt
 MAN8_TXT += btrfs-check.txt
-#MAN8_TXT += btrfs-rescue.txt
+MAN8_TXT += btrfs-rescue.txt
 #MAN8_TXT += btrfs-inspect-internal.txt
 #MAN8_TXT += btrfs-send.txt
 #MAN8_TXT += btrfs-receive.txt
diff --git a/Documentation/btrfs-rescue.txt b/Documentation/btrfs-rescue.txt
new file mode 100644
index 0000000..f66ca85
--- /dev/null
+++ b/Documentation/btrfs-rescue.txt
@@ -0,0 +1,60 @@
+btrfs-check(8)
+==============
+
+NAME
+----
+btrfs-rescue - Recover a damaged btrfs filesystem
+
+SYNOPSIS
+--------
+'btrfs rescue' <subcommand> <args>
+
+DESCRIPTION
+-----------
+'btrfs rescue' is used to try to recover a damaged btrfs filesystem.
+
+SUBCOMMAND
+----------
+'chunk-recover' [options] <device>::
+Recover the chunk tree by scanning the devices
++
+`Options`
++
+-y::::
+assume an answer of 'yes' to all questions.
+-v::::
+verbose mode.
+-h::::
+help.
+
+NOTE: Since 'chunk-recover' will scan the whole device, it will be *VERY* slow
+especially executed on a large device.
+
+'super-recover' [options] <device>::
+Recover bad superblocks from good copies.
++
+`Options`
++
+-y::::
+assume an answer of 'yes' to all questions.
+-v::::
+verbose mode.
+
+EXIT STATUS
+-----------
+'btrfs rescue' returns a zero exist status if it succeeds. Non zero is
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
+`btrfs-scrub`(8),
+`btrfs-check`(8)
-- 
1.9.1

