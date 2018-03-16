Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:33778 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932501AbeCPAjb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Mar 2018 20:39:31 -0400
Received: by mail-qk0-f196.google.com with SMTP id l25so2966278qkj.0
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Mar 2018 17:39:30 -0700 (PDT)
From: Nicholas D Steeves <nsteeves@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Nicholas D Steeves <nsteeves@gmail.com>
Subject: [PATCH 1/1] btrfs-progs: Fix typos in docs and user-facing strings
Date: Thu, 15 Mar 2018 20:39:09 -0400
Message-Id: <20180316003909.28800-2-nsteeves@gmail.com>
In-Reply-To: <20180316003909.28800-1-nsteeves@gmail.com>
References: <20180316003909.28800-1-nsteeves@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nicholas D Steeves <nsteeves@gmail.com>
---
 Documentation/btrfs-balance.asciidoc | 2 +-
 Documentation/btrfs-check.asciidoc   | 2 +-
 Documentation/btrfs-man5.asciidoc    | 8 ++++----
 cmds-subvolume.c                     | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/btrfs-balance.asciidoc b/Documentation/btrfs-balance.asciidoc
index 7017bed7..536243bc 100644
--- a/Documentation/btrfs-balance.asciidoc
+++ b/Documentation/btrfs-balance.asciidoc
@@ -204,7 +204,7 @@ The way balance operates, it usually needs to temporarily create a new block
 group and move the old data there, before the old block group can be removed.
 For that it needs the work space, otherwise it fails for ENOSPC reasons.
 This is not the same ENOSPC as if the free space is exhausted. This refers to
-the space on the level of block groups, which are bigger parts of the filesytem
+the space on the level of block groups, which are bigger parts of the filesystem
 that contain many file extents.
 
 The free work space can be calculated from the output of the *btrfs filesystem show*
diff --git a/Documentation/btrfs-check.asciidoc b/Documentation/btrfs-check.asciidoc
index cc76d846..b963eae5 100644
--- a/Documentation/btrfs-check.asciidoc
+++ b/Documentation/btrfs-check.asciidoc
@@ -122,7 +122,7 @@ NOTE: 'lowmem' mode does not work with '--repair' yet, and is still considered
 experimental.
 
 --force::
-allow to work on a mounted filesystem. Note that this should work fine on a
+allow work on a mounted filesystem. Note that this should work fine on a
 quiescent or read-only mounted filesystem but may crash if the device is
 changed externally, eg. by the kernel module.  Repair without mount checks is
 not supported right now.
diff --git a/Documentation/btrfs-man5.asciidoc b/Documentation/btrfs-man5.asciidoc
index b20abf05..0529496a 100644
--- a/Documentation/btrfs-man5.asciidoc
+++ b/Documentation/btrfs-man5.asciidoc
@@ -210,7 +210,7 @@ system at that point.
 Enable discarding of freed file blocks.  This is useful for SSD devices, thinly
 provisioned LUNs, or virtual machine images; however, every storage layer must
 support discard for it to work. if the backing device does not support
-asynchronous queued TRIM, then this operation can severly degrade performance,
+asynchronous queued TRIM, then this operation can severely degrade performance,
 because a synchronous TRIM operation will be attempted instead. Queued TRIM
 requires newer than SATA revision 3.1 chipsets and devices.
 
@@ -223,7 +223,7 @@ of actually discarding the blocks.
 
 If discarding is not necessary to be done at the block freeing time, there's
 `fstrim`(8) tool that lets the filesystem discard all free blocks in a batch,
-possibly not much interfering with other operations. Also, the the device may
+possibly not much interfering with other operations. Also, the device may
 ignore the TRIM command if the range is too small, so running the batch discard
 can actually discard the blocks.
 
@@ -289,7 +289,7 @@ checksums don't fit inside a single page.
 +
 Don't use this option unless you really need it. The inode number limit
 on 64bit system is 2^64^, which is practically enough for the whole filesystem
-lifetime. Due to implemention of linux VFS layer, the inode numbers on 32bit
+lifetime. Due to implementation of linux VFS layer, the inode numbers on 32bit
 systems are only 32 bits wide. This lowers the limit significantly and makes
 it possible to reach it. In such case, this mount option will help.
 Alternatively, files with high inode numbers can be copied to a new subvolume
@@ -415,7 +415,7 @@ will disable all SSD options.
 
 *subvol='path'*::
 Mount subvolume from 'path' rather than the toplevel subvolume. The
-'path' is always treated as relative to the the toplevel subvolume.
+'path' is always treated as relative to the toplevel subvolume.
 This mount option overrides the default subvolume set for the given filesystem.
 
 *subvolid='subvolid'*::
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index ba57eaa0..45363a5a 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -338,7 +338,7 @@ again:
 			error("unable to get fsid for '%s': %s",
 				path, strerror(-res));
 			error(
-			"delete suceeded but commit may not be done in the end");
+			"delete succeeded but commit may not be done in the end");
 			ret = 1;
 			goto out;
 		}
-- 
2.14.2

