Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:52981 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932845AbaLDSjs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Dec 2014 13:39:48 -0500
Received: by mail-wg0-f54.google.com with SMTP id l2so23404409wgh.13
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Dec 2014 10:39:47 -0800 (PST)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 3/5] Update 'btrfs device scan' man page.
Date: Thu,  4 Dec 2014 19:39:40 +0100
Message-Id: <1417718382-6753-4-git-send-email-kreijack@inwind.it>
In-Reply-To: <1417718382-6753-1-git-send-email-kreijack@inwind.it>
References: <1417718382-6753-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch documents the '-s' switch and the environment variable
BTRFS_SKIP_LVM_SNAPSHOT.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 Documentation/btrfs-device.txt | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-device.txt b/Documentation/btrfs-device.txt
index 46c54b9..ce5d69d 100644
--- a/Documentation/btrfs-device.txt
+++ b/Documentation/btrfs-device.txt
@@ -77,7 +77,7 @@ force overwrite of existing filesystem on the given disk(s)
 *delete* <dev> [<dev>...] <path>::
 Remove device(s) from a filesystem identified by <path>.
 
-*scan* [(--all-devices|-d)|<device> [<device>...]]::
+*scan* [-s][(--all-devices|-d)|<device> [<device>...]]::
 Scan devices for a btrfs filesystem.
 +
 If one or more devices are passed, these are scanned for a btrfs filesystem. 
@@ -85,6 +85,9 @@ If no devices are passed, btrfs uses block devices containing btrfs
 filesystem as listed by blkid.
 Finally, if '--all-devices' or '-d' is passed, all the devices under /dev are 
 scanned.
+By default, the lvm snapshots are skipped. If '-s' is passed, these aren't
+skipped anymore. See also BTRFS_SKIP_LVM_SNAPSHOT environmental variable
+in the main btrfs man page.
 
 *ready* <device>::
 Check device to see if it has all of it's devices in cache for mounting.
@@ -114,3 +117,4 @@ SEE ALSO
 `mkfs.btrfs`(8),
 `btrfs-replace`(8),
 `btrfs-balance`(8)
+`btrfs` (8)
-- 
2.1.3

