Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14210 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752661AbbDAHyQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Apr 2015 03:54:16 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t317r6wI010161
	for <linux-btrfs@vger.kernel.org>; Wed, 1 Apr 2015 15:53:06 +0800
From: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs doc: emphasis that only mounted device works for btrfs device stats
Date: Wed, 1 Apr 2015 03:52:57 -0400
Message-ID: <1427874777-11871-1-git-send-email-chenhanxiao@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We provided format <path>|<device> in command line.
But btrfs device stats doesn't work if device is not mounted.

Also fix some tailing whitespace.

Signed-off-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
---
 Documentation/btrfs-device.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/btrfs-device.txt b/Documentation/btrfs-device.txt
index 66be6b3..3868fd4 100644
--- a/Documentation/btrfs-device.txt
+++ b/Documentation/btrfs-device.txt
@@ -83,14 +83,14 @@ Check device to see if it has all of it's devices in cache for mounting.
 *scan* [(--all-devices|-d)|<device> [<device>...]]::
 Scan devices for a btrfs filesystem.
 +
-If one or more devices are passed, these are scanned for a btrfs filesystem. 
+If one or more devices are passed, these are scanned for a btrfs filesystem.
 If no devices are passed, btrfs uses block devices containing btrfs
 filesystem as listed by blkid.
-Finally, if '--all-devices' or '-d' is passed, all the devices under /dev are 
+Finally, if '--all-devices' or '-d' is passed, all the devices under /dev are
 scanned.
 
 *stats* [-z] <path>|<device>::
-Read and print the device IO stats for all devices of the filesystem
+Read and print the device IO stats for all mounted devices of the filesystem
 identified by <path> or for a single <device>.
 +
 `Options`
-- 
2.1.0

