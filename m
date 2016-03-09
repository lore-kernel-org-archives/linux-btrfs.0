Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:56758 "EHLO
	mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbcCIXIm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Mar 2016 18:08:42 -0500
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id CACF7AC0170
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Mar 2016 08:08:37 +0900 (JST)
Subject: [PATCH 2/2] btrfs-progs: Describe device scan -d is a deprecated
 option in manpage
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <56E0AC1B.3020405@jp.fujitsu.com>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <56E0ACEF.5050701@jp.fujitsu.com>
Date: Thu, 10 Mar 2016 08:08:31 +0900
MIME-Version: 1.0
In-Reply-To: <56E0AC1B.3020405@jp.fujitsu.com>
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's already marked as deprecated in cmd_device_scan_usage().

commit 5444864e5605 ("btrfs-progs: remove BTRFS_SCAN_PROC scan method")

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
 Documentation/btrfs-device.asciidoc | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/btrfs-device.asciidoc b/Documentation/btrfs-device.asciidoc
index bd878f4..bf16a94 100644
--- a/Documentation/btrfs-device.asciidoc
+++ b/Documentation/btrfs-device.asciidoc
@@ -89,8 +89,8 @@ Scan devices for a btrfs filesystem.
 If one or more devices are passed, these are scanned for a btrfs filesystem.
 If no devices are passed, btrfs uses block devices containing btrfs
 filesystem as listed by blkid.
-Finally, if '--all-devices' or '-d' is passed, all the devices under /dev are
-scanned.
+Finally, '--all-devices' or '-d' is the deprecated option. If it is passed,
+its behavior is the same as if no devices are passed.

 *stats* [-z] <path>|<device>::
 Read and print the device IO stats for all mounted devices of the filesystem
-- 
2.7.0
