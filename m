Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16608 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758018AbaDBI25 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Apr 2014 04:28:57 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s328Scre014926
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Apr 2014 16:28:38 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 06/27] btrfs-progs: Convert man page for btrfs-scrub
Date: Wed, 2 Apr 2014 16:29:17 +0800
Message-ID: <1396427378-10487-7-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Convert man page for btrfs-scrub.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/Makefile        |  2 +-
 Documentation/btrfs-scrub.txt | 98 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 99 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/btrfs-scrub.txt

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 79ae9de..68b7e1f 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -20,7 +20,7 @@ MAN8_TXT += btrfs-subvolume.txt
 MAN8_TXT += btrfs-filesystem.txt
 MAN8_TXT += btrfs-balance.txt
 MAN8_TXT += btrfs-device.txt
-#MAN8_TXT += btrfs-scrub.txt
+MAN8_TXT += btrfs-scrub.txt
 #MAN8_TXT += btrfs-check.txt
 #MAN8_TXT += btrfs-rescue.txt
 #MAN8_TXT += btrfs-inspect-internal.txt
diff --git a/Documentation/btrfs-scrub.txt b/Documentation/btrfs-scrub.txt
new file mode 100644
index 0000000..3973f31
--- /dev/null
+++ b/Documentation/btrfs-scrub.txt
@@ -0,0 +1,98 @@
+btrfs-scrub(8)
+==============
+
+NAME
+----
+btrfs-scrub - scrub btrfs filesystem
+
+SYNOPSIS
+--------
+'btrfs scrub' <subcommand> <args>
+
+DESCRIPTION
+-----------
+'btrfs scrub' is used to scrub a btrfs filesystem, which will reading all data
+from all disks and verifying checksums.
+
+SUBCOMMAND
+----------
+'start' [-BdqrRf] [-c ioprio_class -n ioprio_classdata] <path>|<device>::
+Start a scrub on all devices of the filesystem identified by <path> or on
+a single <device>.
++
+Without options, scrub is started as a background process.
+Progress can be obtained with the 'scrub status' command. Scrubbing
+involves reading all data from all disks and verifying checksums. Errors are
+corrected along the way if possible.
++
+The default IO priority of scrub is the idle class. The priority can be
+configured similar to the `ionice`(1) syntax using '-c' and '-n' options.
++
+`Options`
++
+-B::::
+Do not background and print scrub statistics when finished.
+-d::::
+Print separate statistics for each device of the filesystem (-B only).
+-q::::
+Quiet. Omit error messages and statistics.
+-r::::
+Read only mode. Do not attempt to correct anything.
+-R::::
+Raw print mode. Print full data instead of summary.
+-c ioprio_class::::
+Set IO priority class (see
+ ionice (1)
+manpage).
+-n ioprio_classdata::::
+Set IO priority classdata (see `ionice`(1) manpage).
+-f::::
+force to check whether scrub has started or resumed in userspace.
+this is useful when scrub stat record file is damaged.
+
+'cancel' <path>|<device>::
+If a scrub is running on the filesystem identified by <path>, cancel it.
++
+Progress is saved in the scrub progress file and scrubbing can be resumed later
+using the scrub resume command.
+If a <device> is given, the corresponding filesystem is found and
+scrub cancel behaves as if it was called on that filesystem.
+
+'resume' [-BdqrR] [-c ioprio_class -n ioprio_classdata] <path>|<device>::
+Resume a canceled or interrupted scrub cycle on the filesystem identified by
+<path> or on a given <device>.
++
+Does not start a new scrub if the last scrub finished successfully.
++
+`Options`
++
+see 'scrub start'.
+
+'status' [-d] <path>|<device>::
+Show status of a running scrub for the filesystem identified by <path> or
+for the specified <device>.
++
+If no scrub is running, show statistics of the last finished or canceled scrub
+for that filesystem or device.
++
+`Options`
++
+-d::::
+Print separate statistics for each device of the filesystem.
+
+EXIT STATUS
+-----------
+'btrfs scrub' returns a zero exist status if it succeeds. Non zero is
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

