Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16608 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758195AbaDBI3D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Apr 2014 04:29:03 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s328SkdO014958
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Apr 2014 16:28:46 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 15/27] btrfs-progs: Convert man page for btrfs-dedup.
Date: Wed, 2 Apr 2014 16:29:26 +0800
Message-ID: <1396427378-10487-16-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Although the btrfs-dedup function is not available in mainline kernel,
add the man page any way and add a warning into it.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/Makefile        |  2 +-
 Documentation/btrfs-dedup.txt | 51 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/btrfs-dedup.txt

diff --git a/Documentation/Makefile b/Documentation/Makefile
index a4f7ef0..4040951 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -29,7 +29,7 @@ MAN8_TXT += btrfs-receive.txt
 MAN8_TXT += btrfs-quota.txt
 MAN8_TXT += btrfs-qgroup.txt
 MAN8_TXT += btrfs-replace.txt
-#MAN8_TXT += btrfs-dedup.txt
+MAN8_TXT += btrfs-dedup.txt
 
 MAN_TXT = $(MAN8_TXT)
 MAN_XML = $(patsubst %.txt,%.xml,$(MAN_TXT))
diff --git a/Documentation/btrfs-dedup.txt b/Documentation/btrfs-dedup.txt
new file mode 100644
index 0000000..d42cee6
--- /dev/null
+++ b/Documentation/btrfs-dedup.txt
@@ -0,0 +1,51 @@
+btrfs-dedup(8)
+==============
+
+NAME
+----
+btrfs-dedup - control the deduplication in a btrfs filesystem
+
+SYNOPSIS
+--------
+'btrfs dedup' <subcommand> <args>
+
+DESCRIPTION
+-----------
+WARNING: Deduplication function is not implemented in mainline kernel(v3.14
+yet). So most user may find this function not usable.
+
+'btrfs dedup' is used to control deduplication in a bttrfs filesystem.
+
+SUBCOMMAND
+----------
+'enable' <path>::
+Enable data deduplication support for a filesystem.
+
+
+'disable' <path>::
+Disable data deduplication support for a filesystem.
+
+
+'on' [-b|--bs size] <path>::
+Switch on data deduplication or change the dedup blocksize.
+
+
+'off' <path>::
+Switch off data deduplication.
+
+EXIT STATUS
+-----------
+'btrfs dedup' returns a zero exist status if it succeeds. Non zero is
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

