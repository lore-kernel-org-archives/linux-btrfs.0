Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23643 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751136AbaHDH26 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Aug 2014 03:28:58 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s747SsIR026432
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Aug 2014 15:28:55 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: Documentations: Fix a format error in btrfs-replace.txt
Date: Mon, 4 Aug 2014 15:28:54 +0800
Message-ID: <1407137334-6183-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Missing '+'s cause '-B' option not displayed correctly, add it to fix.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-replace.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/btrfs-replace.txt b/Documentation/btrfs-replace.txt
index eecf9b0..067b02d 100644
--- a/Documentation/btrfs-replace.txt
+++ b/Documentation/btrfs-replace.txt
@@ -42,6 +42,7 @@ The <targetdev> needs to be same size or larger than the <srcdev>.
 only read from <srcdev> if no other zero-defect mirror exists.
 (enable this if your drive has lots of read errors, the access would be very
 slow)
++
 -f::::
 force using and overwriting <targetdev> even if it looks like
 containing a valid btrfs filesystem.
@@ -49,6 +50,7 @@ containing a valid btrfs filesystem.
 A valid filesystem is assumed if a btrfs superblock is found which contains a
 correct checksum. Devices which are currently mounted are
 never allowed to be used as the <targetdev>.
++
 -B::::
 no background replace.
 
-- 
2.0.3

