Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25979 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754031AbbAIHKI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Jan 2015 02:10:08 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0979CkE024926
	for <linux-btrfs@vger.kernel.org>; Fri, 9 Jan 2015 15:09:12 +0800
From: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: fix some format errors in doc
Date: Fri, 9 Jan 2015 15:08:56 +0800
Message-ID: <1420787336-7783-1-git-send-email-fancn.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
---
 Documentation/btrfs-mount.txt    |  2 +-
 Documentation/btrfs-property.txt | 14 +++++++-------
 Documentation/btrfs-replace.txt  |  3 +--
 Documentation/btrfs-scrub.txt    |  4 +---
 4 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/Documentation/btrfs-mount.txt b/Documentation/btrfs-mount.txt
index 4fb7137..8cf7a0b 100644
--- a/Documentation/btrfs-mount.txt
+++ b/Documentation/btrfs-mount.txt
@@ -91,7 +91,7 @@ MOUNT OPTIONS
 	operations).  This was previously the behavior only when a snapshot is
 	created.
 
-*inode_cache*:
+*inode_cache*::
 	Enable free inode number caching.   Defaults to off due to an overflow
 	problem when the free space crcs don't fit inside a single page.
 
diff --git a/Documentation/btrfs-property.txt b/Documentation/btrfs-property.txt
index 28ede4b..8b9b7f0 100644
--- a/Documentation/btrfs-property.txt
+++ b/Documentation/btrfs-property.txt
@@ -28,10 +28,16 @@ A btrfs object, which is set by <object>, can be a btrfs filesystem
 itself, a btrfs subvolume, an inode(file or directory) inside btrfs,
 or a device on which a btrfs exists.
 +
+The '-t <type>' option can be used to explicitly
+specify what type of object you meant. This is only needed when a
+property could be set for more then one object type.
++
+Possible types are 's[ubvol]', 'f[ilesystem]', 'i[node]' and 'd[evice]'.
++
 Set the name of property by '<name>'. If no '<name>' is specified,
 all properties for the given object are printed. '<name>' is one of
 the followings.
-+
+
 ro::::
 read-only flag of subvolume: true or false
 label::::
@@ -39,12 +45,6 @@ label of device
 compression::::
 compression setting for an inode: lzo, zlib, or "" (empty string)
 
-The '-t <type>' option can be used to explicitly
-specify what type of object you meant. This is only needed when a
-property could be set for more then one object type.
-+
-Possible types are 's[ubvol]', 'f[ilesystem]', 'i[node]' and 'd[evice]'.
-
 *list* [-t <type>] <object>::
 Lists available properties with their descriptions for the given object.
 +
diff --git a/Documentation/btrfs-replace.txt b/Documentation/btrfs-replace.txt
index 7402484..b2a21b9 100644
--- a/Documentation/btrfs-replace.txt
+++ b/Documentation/btrfs-replace.txt
@@ -13,9 +13,8 @@ DESCRIPTION
 -----------
 *btrfs replace* is used to replace btrfs managed devices with other device.
 
-Note: this is not currently supported for RAID5/6 profiles and must use the
+NOTE: this is not currently supported for RAID5/6 profiles and must use the
 device add/delete workaround.
-
 It is recommended to see `btrfs-device`(8) for more details about btrfs device
 management.
 
diff --git a/Documentation/btrfs-scrub.txt b/Documentation/btrfs-scrub.txt
index c0fafca..6ebce60 100644
--- a/Documentation/btrfs-scrub.txt
+++ b/Documentation/btrfs-scrub.txt
@@ -59,9 +59,7 @@ Read only mode. Do not attempt to correct anything.
 -R::::
 Raw print mode. Print full data instead of summary.
 -c <ioprio_class>::::
-Set IO priority class (see
- ionice (1)
-manpage).
+Set IO priority class (see `ionice`(1) manpage).
 -n <ioprio_classdata>::::
 Set IO priority classdata (see `ionice`(1) manpage).
 -f::::
-- 
1.9.1

