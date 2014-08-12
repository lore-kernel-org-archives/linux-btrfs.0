Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41353 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbaHLHZi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Aug 2014 03:25:38 -0400
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id DCD173EE0BD
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 16:25:36 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id EC85AAC0457
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 16:25:35 +0900 (JST)
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 61D88E08005
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Aug 2014 16:25:35 +0900 (JST)
Message-ID: <53E9C165.6060500@jp.fujitsu.com>
Date: Tue, 12 Aug 2014 16:25:25 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Eric Sandeen <esandeen@redhat.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/3 v2] btrfs-progs: random fixes of btrfs-filesystem documentation
References: <53E888C3.70807@jp.fujitsu.com> <53E8F7F0.3060300@redhat.com> <53E95703.9050705@jp.fujitsu.com> <6DC8BDFA-32FF-4EB4-87D4-AB09F7A5A9FE@redhat.com>
In-Reply-To: <6DC8BDFA-32FF-4EB4-87D4-AB09F7A5A9FE@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

  - Simplify the description of both man and usage.
  - Add the description about short options for '--all-devices
    and '--mounted', '-d' and '-m' respectively.
  - Fix to show -d and -m is not exclusive
    with '<path>|<uuid>|<device>|<label>'.
  - Move the descriptions of options to "Options" section in manpage.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>

---
changelog:
  - v2: Fix the description based on Eric's comment
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
index 38011e5..3e9f33b 100644
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
+	"",
+	"By default, the show command scans all devices found in /proc/partitions.",
+	"If [-d|--all-devices] is specified, all devices found under /dev are scanned.",
+	"If [-m|--mounted] is specified, only mounted btrfs devices are scanned.",
+	"",
+	"By default, the structure of all discovered filesystems is shown.",
+	"If any one of [<path>|<uuid>|<device>|<label>] is specified, only filesystems",
+	"matching that identifier are shown.",
  	NULL
  };
  
-- 
1.9.3

