Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:65370 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758186AbaDBI27 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Apr 2014 04:28:59 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s328SfKY014941
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Apr 2014 16:28:41 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 10/27] btrfs-progs: Convert man page for btrfs-send.
Date: Wed, 2 Apr 2014 16:29:21 +0800
Message-ID: <1396427378-10487-11-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Convert man page for btrfs-send.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/Makefile       |  2 +-
 Documentation/btrfs-send.txt | 60 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/btrfs-send.txt

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 6655f06..081ec42 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -24,7 +24,7 @@ MAN8_TXT += btrfs-scrub.txt
 MAN8_TXT += btrfs-check.txt
 MAN8_TXT += btrfs-rescue.txt
 MAN8_TXT += btrfs-inspect-internal.txt
-#MAN8_TXT += btrfs-send.txt
+MAN8_TXT += btrfs-send.txt
 #MAN8_TXT += btrfs-receive.txt
 #MAN8_TXT += btrfs-quota.txt
 #MAN8_TXT += btrfs-replace.txt
diff --git a/Documentation/btrfs-send.txt b/Documentation/btrfs-send.txt
new file mode 100644
index 0000000..18a98fa
--- /dev/null
+++ b/Documentation/btrfs-send.txt
@@ -0,0 +1,60 @@
+btrfs-send(8)
+=============
+
+NAME
+----
+btrfs-send - send data of subvolume(s) to stdout/file.
+
+SYNOPSIS
+--------
+'btrfs send' [-ve] [-p <parent>] [-c <clone-src>] [-f <outfile>] <subvol> [<subvol>...]
+
+DESCRIPTION
+-----------
+Sends the subvolume(s) specified by <subvol> to stdout.
+
+By default, this will send the whole subvolume. To do an incremental
+send, use '-p <parent>'.
+
+If you want to allow btrfs to clone from any additional local snapshots,
+use '-c <clone-src>' (multiple times where applicable). 
+
+You must not specify clone sources unless you guarantee that these snapshots
+are exactly in the same state on both sides, the sender and the receiver.
+
+It is allowed to omit the '-p <parent>' option when '-c <clone-src>' options
+are given, in which case 'btrfs send' will determine a suitable parent among the
+clone sources itself.
+
+`Options`
+
+-v::
+Enable verbose debug output. Each occurrence of this option increases the
+verbose level more.
+-e::
+If sending multiple subvols at once, use the new format and omit the <end cmd> between the subvols.
+-p <parent>::
+Send an incremental stream from <parent> to <subvol>.
+-c <clone-src>::
+Use this snapshot as a clone source for an incremental send (multiple allowed).
+-f <outfile>::
+Output is normally written to stdout. To write to a file, use this option.
+An alternative would be to use pipes.
+
+EXIT STATUS
+-----------
+'btrfs send' returns a zero exist status if it succeeds. Non zero is
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
+`btrfs-receive`(8)
-- 
1.9.1

