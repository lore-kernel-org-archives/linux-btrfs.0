Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:54815 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933312AbbGHPWZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jul 2015 11:22:25 -0400
Received: from /spool/local
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <grimshaw@linux.vnet.ibm.com>;
	Wed, 8 Jul 2015 11:22:24 -0400
Message-ID: <559D402C.2040205@linux.vnet.ibm.com>
Date: Wed, 08 Jul 2015 08:22:20 -0700
From: Daniel Grimshaw <grimshaw@linux.vnet.ibm.com>
MIME-Version: 1.0
To: clm@fb.com, jbacik@fb.com, dsterba@suse.cz, corbet@lwn.net
CC: linux-btrfs@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Documentation: filesystems: btrfs: Fixed typos and whitespace
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am a high school student trying to become familiar with Linux kernel development. The btrfs documentation in Documentation/filesystems had a few typos and errors in whitespace. This patch corrects both of these.

Signed-off-by: Daniel Grimshaw <grimshaw@linux.vnet.ibm.com>

---
diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
index d11cc2f..57d9d54 100644
--- a/Documentation/filesystems/btrfs.txt
+++ b/Documentation/filesystems/btrfs.txt
@@ -61,7 +61,7 @@ Options with (*) are default options and will not show in the mount options.
 
     check_int enables the integrity checker module, which examines all
     block write requests to ensure on-disk consistency, at a large
-    memory and CPU cost. 
+    memory and CPU cost.
 
     check_int_data includes extent data in the integrity checks, and
     implies the check_int option.
@@ -113,7 +113,7 @@ Options with (*) are default options and will not show in the mount options.
     Disable/enable debugging option to be more verbose in some ENOSPC conditions.
 
   fatal_errors=<action>
-    Action to take when encountering a fatal error:
+    Action to take when encountering a fatal error:
       "bug" - BUG() on a fatal error.  This is the default.
       "panic" - panic() on a fatal error.
 
@@ -132,10 +132,10 @@ Options with (*) are default options and will not show in the mount options.
 
   max_inline=<bytes>
     Specify the maximum amount of space, in bytes, that can be inlined in
-    a metadata B-tree leaf.  The value is specified in bytes, optionally
+    a metadata B-tree leaf.  The value is specified in bytes, optionally
     with a K, M, or G suffix, case insensitive.  In practice, this value
     is limited by the root sector size, with some space unavailable due
-    to leaf headers.  For a 4k sectorsize, max inline data is ~3900 bytes.
+    to leaf headers.  For a 4k sector size, max inline data is ~3900 bytes.
 
   metadata_ratio=<value>
     Specify that 1 metadata chunk should be allocated after every <value>
@@ -161,7 +161,7 @@ Options with (*) are default options and will not show in the mount options.
 
   datasum(*)
   nodatasum
-    Enable/disable data checksumming for newly created files.
+    Enable/disable data check-summing for newly created files.
     Datasum implies datacow.
 
   treelog(*)
@@ -170,7 +170,7 @@ Options with (*) are default options and will not show in the mount options.
 
   recovery
     Enable autorecovery attempts if a bad tree root is found at mount time.
-    Currently this scans a list of several previous tree roots and tries to
+    Currently this scans a list of several previous tree roots and tries to
     use the first readable.
 
   rescan_uuid_tree
@@ -194,7 +194,7 @@ Options with (*) are default options and will not show in the mount options.
   ssd_spread
     Options to control ssd allocation schemes.  By default, BTRFS will
     enable or disable ssd allocation heuristics depending on whether a
-    rotational or nonrotational disk is in use.  The ssd and nossd options
+    rotational or non-rotational disk is in use.  The ssd and nossd options
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
-    Allow subvolumes to be deleted by a non-root user. Use with caution.
+    Allow subvolumes to be deleted by a non-root user. Use with caution.
 
 MAILING LIST
 ============

