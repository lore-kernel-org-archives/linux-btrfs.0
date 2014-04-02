Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:65370 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752190AbaDBI2x (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Apr 2014 04:28:53 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s328SaR9014918
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Apr 2014 16:28:36 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 04/27] btrfs-progs: Convert man page for btrfs-balance.
Date: Wed, 2 Apr 2014 16:29:15 +0800
Message-ID: <1396427378-10487-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Convert man page for btrfs-balance.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/Makefile          |  2 +-
 Documentation/btrfs-balance.txt | 77 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/btrfs-balance.txt

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 1fa2b35..4839b6d 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -18,7 +18,7 @@ MAN8_TXT += btrfs.txt
 # Sub commands for btrfs
 MAN8_TXT += btrfs-subvolume.txt
 MAN8_TXT += btrfs-filesystem.txt
-#MAN8_TXT += btrfs-balance.txt
+MAN8_TXT += btrfs-balance.txt
 #MAN8_TXT += btrfs-device.txt
 #MAN8_TXT += btrfs-scrub.txt
 #MAN8_TXT += btrfs-check.txt
diff --git a/Documentation/btrfs-balance.txt b/Documentation/btrfs-balance.txt
new file mode 100644
index 0000000..2289fdf
--- /dev/null
+++ b/Documentation/btrfs-balance.txt
@@ -0,0 +1,77 @@
+btrfs-balance(8)
+================
+
+NAME
+----
+btrfs-balance - balance btrfs filesystem
+
+SYNOPSIS
+--------
+'btrfs [filesystem] balance' <subcommand>|<args>
+
+DESCRIPTION
+-----------
+'btrfs balance' is used to balance chunks in a btrfs filesystem across
+multiple or even single device.
+
+SUBCOMMAND
+----------
+<path>::
+Balance chunks across the devices *online*.
++
+'btrfs balance <path>' is deprecated,
+please use 'btrfs balance start' command instead.
+
+'start' [options] <path>::
+Balance chunks across the devices *online*.
++
+Balance and/or convert (change allocation profile of) chunks that
+passed all filters in a comma-separated list of filters for a
+particular chunk type.
+If filter list is not given balance all chunks of that type.
+In case none of the -d, -m or -s options is
+given balance all chunks in a filesystem.
++
+`Options`
++
+-d[filters]::::
+act on data chunks
+-m[filters]::::
+act on metadata chunks
+-s[filters]::::
+act on system chunks (only under -f)
+-v::::
+be verbose
+-f::::
+force reducing of metadata integrity
+
+'pause' <path>::
+Pause running balance.
+
+'cancel' <path>::
+Cancel running or paused balance.
+
+'resume' <path>::
+Resume interrupted balance.
+
+'status' [-v] <path>::
+Show status of running or paused balance.
++
+If '-v' option is given, output will be verbose.
+
+EXIT STATUS
+-----------
+'btrfs balance' returns a zero exist status if it succeeds. Non zero is
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

