Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:36154 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110AbbGHRpA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jul 2015 13:45:00 -0400
Received: from /spool/local
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <grimshaw@linux.vnet.ibm.com>;
	Wed, 8 Jul 2015 13:45:00 -0400
From: Daniel Grimshaw <grimshaw@linux.vnet.ibm.com>
Message-Id: <201507081744.t68HipCa005698@oc0285321175.ibm.com>
Date: Wed, 08 Jul 2015 10:44:51 -0700
To: corbet@lwn.net, dsterba@suse.cz, jbacik@fb.com, clm@fb.com
Subject: [PATCH] Documentation: filesystems: btrfs: Fixed typos and
 whitespace
Cc: linux-btrfs@vger.kernel.org, linux-doc@vger.kenrel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am a high school student trying to become familiar with
Linux kernel development. The btrfs documentation in
Documentation/filesystems had a few typos and errors in
whitespace. This patch corrects both of these.

This is a resend of an earlier patch with corrected patchfile.

Signed-off-by: Daniel Grimshaw <grimshaw@linux.vnet.ibm.com>
---
 Documentation/filesystems/btrfs.txt |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
index d11cc2f..c772b47 100644
--- a/Documentation/filesystems/btrfs.txt
+++ b/Documentation/filesystems/btrfs.txt
@@ -61,7 +61,7 @@ Options with (*) are default options and will not show in the mount options.
 
 	check_int enables the integrity checker module, which examines all
 	block write requests to ensure on-disk consistency, at a large
-	memory and CPU cost.  
+	memory and CPU cost.
 
 	check_int_data includes extent data in the integrity checks, and
 	implies the check_int option.
@@ -113,7 +113,7 @@ Options with (*) are default options and will not show in the mount options.
 	Disable/enable debugging option to be more verbose in some ENOSPC conditions.
 
   fatal_errors=<action>
-	Action to take when encountering a fatal error: 
+	Action to take when encountering a fatal error:
 	  "bug" - BUG() on a fatal error.  This is the default.
 	  "panic" - panic() on a fatal error.
 
@@ -132,10 +132,10 @@ Options with (*) are default options and will not show in the mount options.
 
   max_inline=<bytes>
 	Specify the maximum amount of space, in bytes, that can be inlined in
-	a metadata B-tree leaf.  The value is specified in bytes, optionally 
+	a metadata B-tree leaf.  The value is specified in bytes, optionally
 	with a K, M, or G suffix, case insensitive.  In practice, this value
 	is limited by the root sector size, with some space unavailable due
-	to leaf headers.  For a 4k sectorsize, max inline data is ~3900 bytes.
+	to leaf headers.  For a 4k sector size, max inline data is ~3900 bytes.
 
   metadata_ratio=<value>
 	Specify that 1 metadata chunk should be allocated after every <value>
@@ -170,7 +170,7 @@ Options with (*) are default options and will not show in the mount options.
 
   recovery
 	Enable autorecovery attempts if a bad tree root is found at mount time.
-	Currently this scans a list of several previous tree roots and tries to 
+	Currently this scans a list of several previous tree roots and tries to
 	use the first readable.
 
   rescan_uuid_tree
@@ -194,7 +194,7 @@ Options with (*) are default options and will not show in the mount options.
   ssd_spread
 	Options to control ssd allocation schemes.  By default, BTRFS will
 	enable or disable ssd allocation heuristics depending on whether a
-	rotational or nonrotational disk is in use.  The ssd and nossd options
+	rotational or non-rotational disk is in use.  The ssd and nossd options
 	can override this autodetection.
 
 	The ssd_spread mount option attempts to allocate into big chunks
@@ -216,13 +216,13 @@ Options with (*) are default options and will not show in the mount options.
 	This allows mounting of subvolumes which are not in the root of the mounted
 	filesystem.
 	You can use "btrfs subvolume show " to see the object ID for a subvolume.
-	
+
   thread_pool=<number>
 	The number of worker threads to allocate.  The default number is equal
 	to the number of CPUs + 2, or 8, whichever is smaller.
 
   user_subvol_rm_allowed
-	Allow subvolumes to be deleted by a non-root user. Use with caution. 
+	Allow subvolumes to be deleted by a non-root user. Use with caution.
 
 MAILING LIST
 ============
-- 
1.7.1

