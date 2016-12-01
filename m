Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:33031 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753431AbcLAUBb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Dec 2016 15:01:31 -0500
Received: by mail-io0-f193.google.com with SMTP id j92so3186529ioi.0
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Dec 2016 12:01:30 -0800 (PST)
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: [PATCH] btrfs-progs: doc: Update docs about RAID profiles
Date: Thu,  1 Dec 2016 15:01:17 -0500
Message-Id: <20161201200117.6743-1-ahferroin7@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds some more info about chunk profiles in the mkfs manpage,
specifically providing better info about raid1 and raid10 profiles and
the fact that they can't survive more than one device failing.

This should hopefully make it less likely that people hit unexpected
behavior when using these profiles.

Signed-off-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
---
This should work to cover most of the issues brought up on the mailing
list recently regarding this particular aspect of documentation.

 Documentation/mkfs.btrfs.asciidoc | 44 ++++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 8 deletions(-)

diff --git a/Documentation/mkfs.btrfs.asciidoc b/Documentation/mkfs.btrfs.asciidoc
index 9b1d45a..a5a8dc1 100644
--- a/Documentation/mkfs.btrfs.asciidoc
+++ b/Documentation/mkfs.btrfs.asciidoc
@@ -247,10 +247,10 @@ There are the following block group types available:
 | single  | 1            |                |            | 1/any
 | DUP     | 2 / 1 device |                |            | 1/any ^(see note 1)^
 | RAID0   |              |                | 1 to N     | 2/any
-| RAID1   | 2            |                |            | 2/any
-| RAID10  | 2            |                | 1 to N     | 4/any
-| RAID5   | 1            | 1              | 2 to N - 1 | 2/any ^(see note 2)^
-| RAID6   | 1            | 2              | 3 to N - 2 | 3/any ^(see note 3)^
+| RAID1   | 2            |                |            | 2/any ^(see note 2)^
+| RAID10  | 2            |                | 1 to N     | 4/any ^(see note 2)^
+| RAID5   | 1            | 1              | 2 to N - 1 | 2/any ^(see note 3)^
+| RAID6   | 1            | 2              | 3 to N - 2 | 3/any ^(see note 4)^
 |=============================================================
 
 WARNING: It's not recommended to build btrfs with RAID0/1/10/5/6 prfiles on
@@ -261,13 +261,17 @@ improved.
 another one is added. Since version 4.5.1, *mkfs.btrfs* will let you create DUP
 on multiple devices.
 
-'Note 2:' It's not recommended to use 2 devices with RAID5. In that case,
+'Note 2:' BTRFS implementattions of RAID1 and RAID10 can only sustain
+a *single* device failure before the filesystem is irreperably damaged,
+no matter how many actual devices are in the aray.  See 'KNOWN ISSUES'
+below for more on this.
+
+'Note 3:' It's not recommended to use 2 devices with RAID5. In that case,
 parity stripe will contain the same data as the data stripe, making RAID5
-degraded to RAID1 with more overhead.
+equivalent to RAID1 with more overhead.
 
-'Note 3:' It's also not recommended to use 3 devices with RAID6, unless you
+'Note 4:' It's also not recommended to use 3 devices with RAID6, unless you
 want to get effectively 3 copies in a RAID1-like manner (but not exactly that).
-N-copies RAID1 is not implemented.
 
 DUP PROFILES ON A SINGLE DEVICE
 -------------------------------
@@ -345,6 +349,30 @@ The ENOSPC occurs during the creation of the UUID tree. This is caused
 by large metadata blocks and space reservation strategy that allocates more
 than can fit into the filesystem.
 
+***MULTI-DEVICE BTRFS FILESYSTEMS AND PROFILE NAMING***
+
+BTRFS supports multiple devices being used in one filesystem.
+The terminology used for the different chunk profiles is somewhat
+misleading because it just copies the closest term from traditional
+storage amnagement technologies.  In particular, RAID1 and RAID10 do
+not function the same as an LVM or MD RAID1 or RAID10 volume.
+
+In BTRFS, RAID1 currently means exactly 2 copies are stored on separate
+devices in the array.  Support for higher levels of replication is
+planned, but currently has no known ETA for inclusion.  This means
+that a BTRFS RAID1 filesystem actually functions more like an MD RAID10
+volume (2 copies of a block, rotating which disks are used), is only
+guraanteed to survive a single device failure.
+
+The situation with RAID10 is a bit different.  It actually does function
+like most typical RAID10 implementations (2 copies striped across an
+arbitrary number of disks).  The big difference here is that in a
+traditional RAID10 configuration, the mapping of mirrors to devices is
+static (ie, part 1 of copy 1 of a block is always on device 1, part 2
+oc copy 1 on device 2, etc), while on BTRFS this mapping is pseudo-random.
+The net result of this is that while it is theoretically possible for
+a BTRFS RAID10 filesystem to survive multiple disk failures in certain
+combinations, in practice it never happens.
 
 AVAILABILITY
 ------------
-- 
2.11.0

