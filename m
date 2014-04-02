Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16608 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758209AbaDBI3J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Apr 2014 04:29:09 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s328Svpp014997
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Apr 2014 16:28:57 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 24/27] btrfs-progs: Convert man page for btrfs-zero-log
Date: Wed, 2 Apr 2014 16:29:35 +0800
Message-ID: <1396427378-10487-25-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Convert man page for btrfs-zero-log

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/Makefile           |  2 +-
 Documentation/btrfs-zero-log.txt | 39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/btrfs-zero-log.txt

diff --git a/Documentation/Makefile b/Documentation/Makefile
index e002d53..de06629 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -11,7 +11,7 @@ MAN8_TXT += btrfs-image.txt
 MAN8_TXT += btrfs-map-logical.txt
 MAN8_TXT += btrfs-show-super.txt
 MAN8_TXT += btrfstune.txt
-#MAN8_TXT += btrfs-zero-log.txt
+MAN8_TXT += btrfs-zero-log.txt
 #MAN8_TXT += fsck.btrfs.txt
 #MAN8_TXT += mkfs.btrfs.txt
 
diff --git a/Documentation/btrfs-zero-log.txt b/Documentation/btrfs-zero-log.txt
new file mode 100644
index 0000000..e3041fa
--- /dev/null
+++ b/Documentation/btrfs-zero-log.txt
@@ -0,0 +1,39 @@
+btrfs-zero-log(8)
+=================
+
+NAME
+----
+btrfs-zero-log - clear out log tree
+
+SYNOPSIS
+--------
+'btrfs-zero-log' <dev>
+
+DESCRIPTION
+-----------
+'btrfs-zero-log' will remove the log tree if log tree is corrupt, which will
+allow you to mount the filesystem again.
+
+The common case where this happens has been fixed a long time ago,
+so it is unlikely that you will see this particular problem.
+
+EXIT STATUS
+-----------
+'btrfs-zero-log' will return 0 if no error happened.
+Other exit code means some problems happened.
+
+AUTHOR
+------
+Written by Shilong Wang and Wenruo Qu.
+
+COPYRIGHT
+---------
+Copyright (C) 2013 FUJITSU LIMITED.
+
+License GPLv2: GNU GPL version 2 <http://gnu.org/licenses/gpl.html>.
+
+This is free software: you are free  to  change  and  redistribute  it. There is NO WARRANTY, to the extent permitted by law.
+
+SEE ALSO
+--------
+`mkfs.btrfs`(8)
-- 
1.9.1

