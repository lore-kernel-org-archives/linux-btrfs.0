Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:28311 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752043AbcIBBly (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Sep 2016 21:41:54 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 3F9A44026B4F
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Sep 2016 09:41:49 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] btrfs-progs: Doc: Add warning for build RAID btrfs on partions from the same device
Date: Fri, 2 Sep 2016 09:41:45 +0800
Message-ID: <20160902014145.7817-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160902014145.7817-1-quwenruo@cn.fujitsu.com>
References: <20160902014145.7817-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quite a common sense for any RAID-like multi-device setup, just in case.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/mkfs.btrfs.asciidoc | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/mkfs.btrfs.asciidoc b/Documentation/mkfs.btrfs.asciidoc
index 846c08f..c291714 100644
--- a/Documentation/mkfs.btrfs.asciidoc
+++ b/Documentation/mkfs.btrfs.asciidoc
@@ -271,6 +271,10 @@ There are the following block group types available:
 | RAID6   | 1            | 2              | 3 to N - 2 | 3/any ^(see note3)^
 |=============================================================
 
+WARNING: It's not recommended to build btrfs with RAID0/1/10/5/6 prfiles on
+partitions from the same disk.
+Neither redundancy nor performance will be improved.
+
 'Note1:' DUP may exist on more than 1 device if it starts on a single device and
 another one is added. Since version 4.5.1, *mkfs.btrfs* will let you create DUP
 on multiple devices.
-- 
2.9.3



