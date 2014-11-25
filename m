Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:47071 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbaKYP5o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 10:57:44 -0500
Received: by mail-wg0-f51.google.com with SMTP id k14so1236004wgh.24
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Nov 2014 07:57:43 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 4/4] Add man page for the 'btrfs chunk' family commands.
Date: Tue, 25 Nov 2014 16:57:25 +0100
Message-Id: <1416931045-24259-5-git-send-email-kreijack@inwind.it>
In-Reply-To: <1416931045-24259-1-git-send-email-kreijack@inwind.it>
References: <1416931045-24259-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add btrfs-chunk(8) man page, and update btrfs(8) man page.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 Documentation/Makefile        |  1 +
 Documentation/btrfs-chunk.txt | 58 +++++++++++++++++++++++++++++++++++++++++++
 Documentation/btrfs.txt       |  5 ++++
 3 files changed, 64 insertions(+)
 create mode 100644 Documentation/btrfs-chunk.txt

diff --git a/Documentation/Makefile b/Documentation/Makefile
index ef4f1bd..f47f62b 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -18,6 +18,7 @@ MAN8_TXT += mkfs.btrfs.txt
 MAN8_TXT += btrfs-subvolume.txt
 MAN8_TXT += btrfs-filesystem.txt
 MAN8_TXT += btrfs-balance.txt
+MAN8_TXT += btrfs-chunk.txt
 MAN8_TXT += btrfs-device.txt
 MAN8_TXT += btrfs-scrub.txt
 MAN8_TXT += btrfs-check.txt
diff --git a/Documentation/btrfs-chunk.txt b/Documentation/btrfs-chunk.txt
new file mode 100644
index 0000000..85d1ea6
--- /dev/null
+++ b/Documentation/btrfs-chunk.txt
@@ -0,0 +1,58 @@
+btrfs-chunk(8)
+===============
+
+NAME
+----
+btrfs-chunk - control btrfs chunks
+
+SYNOPSIS
+--------
+*btrfs chunk* <subcommand> <args>
+
+DESCRIPTION
+-----------
+*btrfs chunk* is used to control the btrfs chunks.
+
+CHUNK DESCRIPTION
+-----------------
+Block devices are divided into chunks. Chunks may be
+mirrored or striped across multiple devices. The mirroring/striping
+arrangement is transparent to the rest of the filesystem, which simply
+sees the single, logical address space that chunks are mapped into.
+
+There are three main types of chunks: Data, Metadata and System. Sometime
+(when the device is small) Data and Metadata can be grouped togheter; in
+this case the chunk is called 'Data+Metadata'. Usually the Data chunks
+are used to store the file content; but if the data is small enough, this
+may be stored in the Metadata chunk togheter with the filesystem data
+structures.
+
+The striping/mirroring levels (called profiles) may be different
+among the chunk types. The chunk profiles are assigned during the filesystem
+creation and these can be changed by the 'btrfs balance' commands.
+
+See `mkfs.btrfs`(8) and `btrfs-balance`(8) for more details.
+
+SUBCOMMAND
+----------
+*list*  <path>::
+Shows the chunks grouped by type and profile; after each group
+the command lists the devices which host the chunks.
+If a device is not present (i.e. the filesystem is mounted in 'degraded' mode),
+it is marked as 'Missing:'.
+
+EXIT STATUS
+-----------
+*btrf chunk* returns a zero exit status if it succeeds. Non zero is
+returned in case of failure.
+
+AVAILABILITY
+------------
+*btrfs* is part of btrfs-progs.
+Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
+further details.
+
+SEE ALSO
+--------
+`mkfs.btrfs`(8),
+`btrfs-balance`(8)
diff --git a/Documentation/btrfs.txt b/Documentation/btrfs.txt
index 3bdc6b4..fc02004 100644
--- a/Documentation/btrfs.txt
+++ b/Documentation/btrfs.txt
@@ -41,6 +41,10 @@ COMMANDS
 	Balance btrfs filesystem chunks across single or several devices. +
 	See `btrfs-balance`(8) for details.
 
+*chunk*::
+	Manage filesystem chunk; currently only listing is suported. +
+	See `btrfs-chunk`(8) for details.
+
 *device*::
 	Manage devices managed by btrfs, including add/delete/scan and so
 	on. +
@@ -102,6 +106,7 @@ SEE ALSO
 `btrfs-subvolume`(8),
 `btrfs-filesystem`(8),
 `btrfs-balance`(8),
+`btrfs-chunk`(8),
 `btrfs-device`(8),
 `btrfs-scrub`(8),
 `btrfs-check`(8),
-- 
2.1.3

