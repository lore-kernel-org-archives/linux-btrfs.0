Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57198 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754560AbaDKCm7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Apr 2014 22:42:59 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Marc MERLIN <marc@merlins.org>
Subject: [PATCH 1/2] btrfs-progs: Add device management related paragraph.
Date: Fri, 11 Apr 2014 10:43:52 +0800
Message-ID: <1397184233-18535-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add device management related paragraph to better explain btrfs device
management.

Cc: Marc MERLIN <marc@merlins.org>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-balance.txt |  3 +++
 Documentation/btrfs-device.txt  | 42 +++++++++++++++++++++++++++++++++++++++++
 Documentation/btrfs-replace.txt |  4 ++++
 3 files changed, 49 insertions(+)

diff --git a/Documentation/btrfs-balance.txt b/Documentation/btrfs-balance.txt
index 2289fdf..1b1861c 100644
--- a/Documentation/btrfs-balance.txt
+++ b/Documentation/btrfs-balance.txt
@@ -14,6 +14,8 @@ DESCRIPTION
 'btrfs balance' is used to balance chunks in a btrfs filesystem across
 multiple or even single device.
 
+See `btrfs-device`(8) for more details about the effect on device management.
+
 SUBCOMMAND
 ----------
 <path>::
@@ -75,3 +77,4 @@ further details.
 SEE ALSO
 --------
 `mkfs.btrfs`(8),
+`btrfs-device`(8)
diff --git a/Documentation/btrfs-device.txt b/Documentation/btrfs-device.txt
index 20d7bcd..474d411 100644
--- a/Documentation/btrfs-device.txt
+++ b/Documentation/btrfs-device.txt
@@ -14,6 +14,46 @@ DESCRIPTION
 'btrfs device' is used to control the btrfs devices, since btrfs can be used
 across several devices, 'btrfs device' is used for multiple device management.
 
+DEVICE MANAGEMENT
+-----------------
+Btrfs filesystem is capable to manage multiple devices.
+
+Btrfs filesystem use different profiles to manage different RAID level, and
+use balance to rebuild chunks, also devices can be added/removed/replace
+online.
+
+Profile::
+Btrfs filesystem use data/metadata profiles to manage allocation/duplication
+mechanism. Profiles like RAID level can be assigned to data and metadata separately.
++
+See `mkfs.btrfs`(8) for more details.
+
+RAID level::
+Btrfs filesystem supports most of the standard RAID level: 0/1/5/6/10.
+RAID levels can be assigned at mkfs time or online.
++
+See `mkfs.btrfs`(8) for mkfs time RAID level assign and `btrfs-balance`(8) for
+online RAID level assign.
+
+Balance::
+`btrfs-balance`(8) subcommand can be used to balance or rebuild chunks to the
+desired profile.
++
+Due to the fact that balance can rebuild/recovery chunks according to its RAID
+duplication if possible, so when using RAID1/5/6/10 with some devices failed
+and you just added a new device to btrfs using `btrfs-device`(8), you should
+run `btrfs-balance`(8) to rebuild the chunks.
++
+See `btrfs-balance`(8) for more details.
+
+Device add/remove/replace::
+Device can be added/removed using `btrfs-replace`(8) subcommand and replaced
+using `btrfs-replace`(8).
++
+When device is removed or replaced, btrfs will do the chunk rebuild if needed.
++
+See `btrfs-replace`(8) and this man page for more details.
+
 SUBCOMMAND
 ----------
 'add' [-Kf] <dev> [<dev>...] <path>::
@@ -73,3 +113,5 @@ further details.
 SEE ALSO
 --------
 `mkfs.btrfs`(8),
+`btrfs-replace`(8),
+`btrfs-balance`(8)
diff --git a/Documentation/btrfs-replace.txt b/Documentation/btrfs-replace.txt
index 8c5dcc4..15a46c2 100644
--- a/Documentation/btrfs-replace.txt
+++ b/Documentation/btrfs-replace.txt
@@ -13,6 +13,9 @@ DESCRIPTION
 -----------
 'btrfs replace' is used to replace btrfs managed devices with other device.
 
+It is recommended to see `btrfs-device`(8) for more details about btrfs device
+management.
+
 SUBCOMMAND
 ----------
 'start' [-Bfr] <srcdev>|<devid> <targetdev> <path>::
@@ -74,3 +77,4 @@ further details.
 SEE ALSO
 --------
 `mkfs.btrfs`(8),
+`btrfs-device`(8),
-- 
1.9.2

