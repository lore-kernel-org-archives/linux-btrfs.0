Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:28924 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752360AbaDOHDz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 03:03:55 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s3F73pAf001776
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Apr 2014 15:03:51 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/4] btrfs-progs: Add btrfs wiki reference to man pages.
Date: Tue, 15 Apr 2014 15:04:51 +0800
Message-ID: <1397545492-3054-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1397545492-3054-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1397545492-3054-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add btrfs wiki page reference to btrfs-check/btrfsck, btrfs-restore and
btrfs-device as supplement.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-check.txt   |  5 +++++
 Documentation/btrfs-device.txt  | 10 ++++++++--
 Documentation/btrfs-restore.txt |  4 ++++
 Documentation/btrfsck.txt       |  4 ++--
 4 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/Documentation/btrfs-check.txt b/Documentation/btrfs-check.txt
index accbed4..ddd7fe7 100644
--- a/Documentation/btrfs-check.txt
+++ b/Documentation/btrfs-check.txt
@@ -13,6 +13,11 @@ DESCRIPTION
 -----------
 'btrfs check' is used to check or repair a btrfs filesystem offline.
 
+NOTE: Since btrfs is under heavy development especially the 'btrfs check'
+command, it is *highly* recommended to read the following btrfs wiki before
+executing 'btrfs check' with '--repair' option: +
+https://btrfs.wiki.kernel.org/index.php/Btrfsck
+
 OPTIONS
 -------
 -s|--support <superblock>::
diff --git a/Documentation/btrfs-device.txt b/Documentation/btrfs-device.txt
index 523ae4d..7a6bce5 100644
--- a/Documentation/btrfs-device.txt
+++ b/Documentation/btrfs-device.txt
@@ -24,16 +24,22 @@ online.
 
 Profile::
 Btrfs filesystem uses data/metadata profiles to manage allocation/duplication
-mechanism. Profiles like RAID level can be assigned to data and metadata separately.
+mechanism. +
+Profiles like RAID level can be assigned to data and metadata separately.
 +
 See `mkfs.btrfs`(8) for more details.
 
 RAID level::
-Btrfs filesystem supports most of the standard RAID level: 0/1/5/6/10.
+Btrfs filesystem supports most of the standard RAID level: 0/1/5/6/10. +
 RAID levels can be assigned at mkfs time or online.
 +
 See `mkfs.btrfs`(8) for mkfs time RAID level assign and `btrfs-balance`(8) for
 online RAID level assign.
++
+NOTE: Since btrfs is under heavy development especially the RAID5/6 support,
+it is *highly* recommended to read the follow btrfs wiki page to get more
+updated details on RAID5/6: +
+https://btrfs.wiki.kernel.org/index.php/RAID56
 
 Balance::
 `btrfs-balance`(8) subcommand can be used to balance or rebuild chunks to the
diff --git a/Documentation/btrfs-restore.txt b/Documentation/btrfs-restore.txt
index ea18ebb..72aa084 100644
--- a/Documentation/btrfs-restore.txt
+++ b/Documentation/btrfs-restore.txt
@@ -17,6 +17,10 @@ restore them into <path> or just list the tree roots.
 Since current `btrfsck`(8) or `btrfs-rescue`(8) only has very limited usage,
 'btrfs restore' is normally a better choice.
 
+NOTE: It is recommended to read the following btrfs wiki page if your data is
+not salvaged with default option: +
+https://btrfs.wiki.kernel.org/index.php/Restore
+
 OPTIONS
 -------
 -s::
diff --git a/Documentation/btrfsck.txt b/Documentation/btrfsck.txt
index 751c4d0..defac80 100644
--- a/Documentation/btrfsck.txt
+++ b/Documentation/btrfsck.txt
@@ -20,8 +20,8 @@ Now, it can only be run on an unmounted FS.
 
 WARNING: Considering it is not well-tested in real-life situations yet.
 If you have a broken Btrfs filesystem, btrfsck may not repair but cause
-additional damages. 
-
+additional damages. See the wiki page for more: +
+https://btrfs.wiki.kernel.org/index.php/Btrfsck
 
 OPTIONS
 -------
-- 
1.9.2

