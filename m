Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38316 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaHKJL7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 05:11:59 -0400
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 3147A3EE1B1
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 18:11:58 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 3DA0EAC01D3
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 18:11:57 +0900 (JST)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id DDFEF1DB803B
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 18:11:56 +0900 (JST)
Received: from G01JPEXCHKW18.g01.fujitsu.local (G01JPEXCHKW18.g01.fujitsu.local [10.0.194.57])
	by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id 38E3A692270
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 18:11:56 +0900 (JST)
Message-ID: <53E888C3.70807@jp.fujitsu.com>
Date: Mon, 11 Aug 2014 18:11:31 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/3] btrfs-progs: random fixes of btrfs-filesystem documentation
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

 - Simplify and unify the description of both man and usage.
 - Fix to show -m and -d is not exclusive
   with "<path>|<uuid>|<device>|<label>".
 - Add the description about short options for "--mounted" and
   "--all-devices", "-m" and "-d" respectively.
 - Move the descriptions of options to "Options" section.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

---
 Documentation/btrfs-filesystem.txt | 22 ++++++++++++++--------
 cmds-filesystem.c                  | 15 ++++++++++-----
 2 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/Documentation/btrfs-filesystem.txt b/Documentation/btrfs-filesystem.txt
index c9c0b00..fe68496 100644
--- a/Documentation/btrfs-filesystem.txt
+++ b/Documentation/btrfs-filesystem.txt
@@ -20,15 +20,21 @@ SUBCOMMAND
 *df* <path> [<path>...]::
 Show space usage information for a mount point.
 
-*show* [--mounted|--all-devices|<path>|<uuid>|<device>|<label>]::
-Show the btrfs filesystem with some additional info.
+*show* [-d|-m] [<path>|<uuid>|<device>|<label>]::
+Show the structure of btrfs filesystem(s).
 +
-If no option nor <path>|<uuid>|<device>|<label> is passed, btrfs shows
-information of all the btrfs filesystem both mounted and unmounted.
-If '--mounted' is passed, it would probe btrfs kernel to list mounted btrfs
-filesystem(s);
-If '--all-devices' is passed, all the devices under /dev are scanned;
-otherwise the devices list is extracted from the /proc/partitions file.
+If none of '<path>|<uuid>|<device>|<label>' is passed, btrfs shows
+information of all the btrfs filesystems both mounted and unmounted.
++
+The show command finds btrfs filesystems by scanning all the devices
+in /proc/partitions by default.
++
+`Options`
++
+-d|--alldevices::::
+scan all the devices under /dev
+-m|--mounted:::: 
+scan only mounted filesystems
 
 *sync* <path>::
 Force a sync for the filesystem identified by <path>.
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 38011e5..5a80a98 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -578,11 +578,16 @@ out:
 }
 
 static const char * const cmd_show_usage[] = {
-	"btrfs filesystem show [options] [<path>|<uuid>|<device>|label]",
-	"Show the structure of a filesystem",
-	"-d|--all-devices   show only disks under /dev containing btrfs filesystem",
-	"-m|--mounted       show only mounted btrfs",
-	"If no argument is given, structure of all present filesystems is shown.",
+	"btrfs filesystem show [-d|-m] [<path>|<uuid>|<device>|<label>]",
+	"Show the structure of btrfs filesystem(s).",
+	"If none of '<path>|<uuid>|<device>|<label>' is passed, btrfs shows",
+	"information of all the btrfs filesystems both mounted and unmounted.",
+	"",
+	"The show command finds btrfs filesystems by scanning all the devices",
+	"in /proc/partitions by default.",
+	"",
+	"-d|--all-devices   scan all the devices under /dev",
+	"-m|--mounted       scan only mounted filesystems",
 	NULL
 };
 
-- 
1.9.3

