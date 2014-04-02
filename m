Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11878 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758188AbaDBI27 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Apr 2014 04:28:59 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s328SgT3014944
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Apr 2014 16:28:42 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 11/27] btrfs-progs: Convert man page for btrfs-receive.
Date: Wed, 2 Apr 2014 16:29:22 +0800
Message-ID: <1396427378-10487-12-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Convert man page for btrfs-receive.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/Makefile          |  2 +-
 Documentation/btrfs-receive.txt | 58 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/btrfs-receive.txt

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 081ec42..2af4d40 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -25,7 +25,7 @@ MAN8_TXT += btrfs-check.txt
 MAN8_TXT += btrfs-rescue.txt
 MAN8_TXT += btrfs-inspect-internal.txt
 MAN8_TXT += btrfs-send.txt
-#MAN8_TXT += btrfs-receive.txt
+MAN8_TXT += btrfs-receive.txt
 #MAN8_TXT += btrfs-quota.txt
 #MAN8_TXT += btrfs-replace.txt
 #MAN8_TXT += btrfs-dedup.txt
diff --git a/Documentation/btrfs-receive.txt b/Documentation/btrfs-receive.txt
new file mode 100644
index 0000000..a67bc66
--- /dev/null
+++ b/Documentation/btrfs-receive.txt
@@ -0,0 +1,58 @@
+btrfs-receive(8)
+================
+
+NAME
+----
+btrfs-receive - receive subvolumes from stdin/file.
+
+SYNOPSIS
+--------
+'btrfs receive' [-ve] [-f <infile>] <mount>
+
+DESCRIPTION
+-----------
+Receives one or more subvolumes that were previously
+sent with 'btrfs send'. The received subvolumes are stored
+into <mount>.
+
+'btrfs receive' will fail with the following case:
+
+1. a receiving subvolume already exists.
+
+2. a previously received subvolume was changed after it was received.
+
+3. default subvolume is changed or you don't mount btrfs filesystem with
+fs tree.
+
+After receiving a subvolume, it is immediately set to read only.
+
+`Options`
+
+-v::
+Enable verbose debug output. Each occurrence of this option increases the
+verbose level more.
+-f <infile>::
+By default, btrfs receive uses stdin to receive the subvolumes.
+Use this option to specify a file to use instead.
+-e::
+Terminate after receiving an <end cmd> in the data stream.
+Without this option, the receiver terminates only if an error is recognized
+or on EOF.
+
+EXIT STATUS
+-----------
+'btrfs receive' returns a zero exist status if it succeeds. Non zero is
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
+`btrfs-send`(8)
-- 
1.9.1

