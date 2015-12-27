Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-01.dd24.net ([193.46.215.41]:52939 "EHLO
	mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256AbbL0DIm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Dec 2015 22:08:42 -0500
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.26])
	by mailgw-01.dd24.net (Postfix) with ESMTP id 74EE860746
	for <linux-btrfs@vger.kernel.org>; Sun, 27 Dec 2015 03:03:29 +0000 (UTC)
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: linux-btrfs@vger.kernel.org
Cc: calestyo@scientia.net
Subject: [PATCH] improve documentation of snapshot unaware defrag
Date: Sun, 27 Dec 2015 04:03:27 +0100
Message-Id: <1451185407-11422-1-git-send-email-mail@christoph.anton.mitterer.name>
In-Reply-To: <CAL3q7H6TGU2rz+zP8hcHxaDGx47nTrCndYvP9ArS+Z0HmZ86=A@mail.gmail.com>
References: <CAL3q7H6TGU2rz+zP8hcHxaDGx47nTrCndYvP9ArS+Z0HmZ86=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs-filesystem(8), improved the documentation of snapshot unaware
defragmentation and included the exact kernel version numbers being affected as
well as the possible effects.
No longer use th word "unlink" which is easily understood as "deleting a file".
Moved the warning more to the beginning of "defragment" subcommand's
documentation where it's more visible to readers.

Added the same warning to the "autodefrag" option of btrfs-mount(5).

Signed-off-by: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
---
 Documentation/btrfs-filesystem.asciidoc | 11 +++++++----
 Documentation/btrfs-mount.asciidoc      |  7 +++++++
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/Documentation/btrfs-filesystem.asciidoc b/Documentation/btrfs-filesystem.asciidoc
index 31cd51b..600bbac 100644
--- a/Documentation/btrfs-filesystem.asciidoc
+++ b/Documentation/btrfs-filesystem.asciidoc
@@ -55,6 +55,13 @@ if the free space is too fragmented.
 Use 0 to take the kernel default, which is 256kB but may change in the future.
 You can also turn on compression in defragment operations.
 +
+WARNING: Defragmenting with Linux kernel versions < 3.9 or ≥ 3.14-rc2 as well as
+with Linux stable kernel versions ≥ 3.10.31, ≥ 3.12.12 or ≥ 3.13.4 will break up
+the ref-links of CoW data (for example files copied with `cp --reflink`,
+snapshots or de-duplicated data).
+This may cause considerable increase of space usage depending on the broken up
+ref-links.
++
 `Options`
 +
 -v::::
@@ -79,10 +86,6 @@ target extent size, do not touch extents bigger than <size>
 For <start>, <len>, <size> it is possible to append
 units designator: \'K', \'M', \'G', \'T', \'P', or \'E', which represent
 KiB, MiB, GiB, TiB, PiB, or EiB, respectively. Case does not matter.
-+
-WARNING: defragmenting with kernels up to 2.6.37 will unlink COW-ed copies of data,
-don't use it if you use snapshots, have de-duplicated your data or made
-copies with `cp --reflink`.
 
 *label* [<dev>|<mountpoint>] [<newlabel>]::
 Show or update the label of a filesystem.
diff --git a/Documentation/btrfs-mount.asciidoc b/Documentation/btrfs-mount.asciidoc
index 39215a8..d364594 100644
--- a/Documentation/btrfs-mount.asciidoc
+++ b/Documentation/btrfs-mount.asciidoc
@@ -26,6 +26,13 @@ MOUNT OPTIONS
 	Auto defragmentation detects small random writes into files and queue
 	them up for the defrag process.  Works best for small files;
 	Not well suited for large database workloads.
+	+
+	WARNING: Defragmenting with Linux kernel versions < 3.9 or ≥ 3.14-rc2 as
+	well as with Linux stable kernel versions ≥ 3.10.31, ≥ 3.12.12 or
+	≥ 3.13.4 will break up the ref-links of CoW data (for example files
+	copied with `cp --reflink`, snapshots or de-duplicated data).
+	This may cause considerable increase of space usage depending on the
+	broken up ref-links.
 
 *check_int*::
 *check_int_data*::
-- 
2.6.4

