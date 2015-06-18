Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:1738 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752322AbbFRGqQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jun 2015 02:46:16 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t5I6ideT009957
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Jun 2015 14:44:39 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] btrfs-progs: Modify document and help message of "fi show" for units options
Date: Thu, 18 Jun 2015 14:46:12 +0800
Message-ID: <1434609972-8513-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1434609972-8513-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1434609972-8513-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-filesystem.asciidoc | 28 +++++++++++++++++++++++-----
 cmds-filesystem.c                       |  8 ++++++++
 2 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/Documentation/btrfs-filesystem.asciidoc b/Documentation/btrfs-filesystem.asciidoc
index f1c35b6..033d3aa 100644
--- a/Documentation/btrfs-filesystem.asciidoc
+++ b/Documentation/btrfs-filesystem.asciidoc
@@ -117,15 +117,33 @@ partition after reducing the size of the filesystem.  This can done using
 it with the new desired size.  When recreating the partition make sure to use
 the same starting disk cylinder as before.
 
-*show* [--mounted|--all-devices|<path>|<uuid>|<device>|<label>]::
+*show* [options] [<path>|<uuid>|<device>|<label>]::
 Show the btrfs filesystem with some additional info.
 +
 If no option nor <path>|<uuid>|<device>|<label> is passed, btrfs shows
 information of all the btrfs filesystem both mounted and unmounted.
-If '--mounted' is passed, it would probe btrfs kernel to list mounted btrfs
-filesystem(s);
-If '--all-devices' is passed, all the devices under /dev are scanned;
-otherwise the devices list is extracted from the /proc/partitions file.
++
+`Options`
++
+--mounted::::
+probe btrfs kernel to list mounted btrfs filesystems(s)
+--all-devices::::
+scan all devices under /dev, otherwise the devices list is extracted from the
+/proc/partitions file.
+--human-readable::::
+print human friendly numbers, base 1024, this is the default
+--iec::::
+select the 1024 base for the following options, according to the IEC standard
+--si::::
+select the 1000 base for the following options, according to the SI standard
+--kbytes::::
+show sizes in KiB, or kB with --si
+--mbytes::::
+show sizes in MiB, or MB with --si
+--gbytes::::
+show sizes in GiB, or GB with --si
+--tbytes::::
+show sizes in TiB, or TB with --si
 
 *sync* <path>::
 Force a sync for the filesystem identified by <path>.
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index a9dbcfe..688fdb3 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -820,6 +820,14 @@ static const char * const cmd_show_usage[] = {
 	"Show the structure of a filesystem",
 	"-d|--all-devices   show only disks under /dev containing btrfs filesystem",
 	"-m|--mounted       show only mounted btrfs",
+	"--raw              raw numbers in bytes",
+	"-human-readable    human friendly numbers, base 1024(default)",
+	"--iec              use 1024 as a base (KiB, MiB, GiB, TiB)",
+	"--si               use 1000 as a base (kB, MB, GB, TB)",
+	"--kbytes           show sizes in KiB, or kB with --si",
+	"--mbytes           show sizes in MiB, or MB with --si",
+	"--gbytes           show sizes in GiB, or GB with --si",
+	"--tbytes           show sizes in TiB, or TB with --si",
 	"If no argument is given, structure of all present filesystems is shown.",
 	NULL
 };
-- 
2.4.3

