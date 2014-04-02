Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:65370 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758210AbaDBI3K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Apr 2014 04:29:10 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s328SwlJ015001
	for <linux-btrfs@vger.kernel.org>; Wed, 2 Apr 2014 16:28:58 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 25/27] btrfs-progs: Convert man page for fsck.btrfs.
Date: Wed, 2 Apr 2014 16:29:36 +0800
Message-ID: <1396427378-10487-26-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Convert man page for fsck.btrfs.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/Makefile       |  2 +-
 Documentation/fsck.btrfs.txt | 51 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/fsck.btrfs.txt

diff --git a/Documentation/Makefile b/Documentation/Makefile
index de06629..4100ddd 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -12,7 +12,7 @@ MAN8_TXT += btrfs-map-logical.txt
 MAN8_TXT += btrfs-show-super.txt
 MAN8_TXT += btrfstune.txt
 MAN8_TXT += btrfs-zero-log.txt
-#MAN8_TXT += fsck.btrfs.txt
+MAN8_TXT += fsck.btrfs.txt
 #MAN8_TXT += mkfs.btrfs.txt
 
 # Sub commands for btrfs
diff --git a/Documentation/fsck.btrfs.txt b/Documentation/fsck.btrfs.txt
new file mode 100644
index 0000000..52e8e4d
--- /dev/null
+++ b/Documentation/fsck.btrfs.txt
@@ -0,0 +1,51 @@
+fsck.btrfs(8)
+=============
+
+NAME
+----
+fsck.btrfs - do nothing, successfully
+
+SYNOPSIS
+--------
+'fsck.btrfs' [-aApy] [device...]
+
+DESCRIPTION
+-----------
+'fsck.btrfs' is a type of utility that should exist for any filesystem and is
+called during system setup when the corresponding `/etc/fstab` entries
+contain non-zero value for `fs_passno` , see `fstab`(5) for more.
+
+Traditional filesystems need to run their respective fsck utility in case the
+filesystem was not unmounted cleanly and the log needs to be replayed before
+mount. This is not needed for BTRFS. You should set fs_passno to 0.
+
+If you wish to check the consistency of a BTRFS filesystem or repair a damaged
+filesystem, see `btrfs-check`(8). By default the filesystem
+consistency is checked, the repair mode is enabled via '--repair' option (use
+with care!).
+
+OPTIONS
+-------
+The options are all the same and detect if 'fsck.btrfs' is executed in
+non-interactive mode and exits with success,
+otherwise prints a message about btrfs check.
+
+EXIT STATUS
+-----------
+There are two possible exit code returned:
+
+0::
+No error
+
+8::
+Operational error, eg. device does not exist
+
+FILES
+-----
+`/etc/fstab`
+
+SEE ALSO
+--------
+`btrfs`(8),
+`fsck`(8),
+`fstab`(5),
-- 
1.9.1

