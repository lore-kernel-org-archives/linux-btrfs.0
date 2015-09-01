Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:18709 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754300AbbIAHNs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Sep 2015 03:13:48 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t817DcHm020580
	for <linux-btrfs@vger.kernel.org>; Tue, 1 Sep 2015 15:13:38 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v3 2/2] btrfs-progs: Update manual for new unit arguments
Date: Tue, 1 Sep 2015 15:12:07 +0800
Message-ID: <630eb717ced2b912884ac55ecf76fe94ea3ef652.1441091348.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1441091348.git.zhaolei@cn.fujitsu.com>
References: <cover.1441091348.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We changed unit arguments for btrfs commands, this patch updated
relative documents for them.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 Documentation/btrfs-device.asciidoc     | 14 ++++++--------
 Documentation/btrfs-filesystem.asciidoc | 14 ++++++--------
 2 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/Documentation/btrfs-device.asciidoc b/Documentation/btrfs-device.asciidoc
index 2827598..04bfde1 100644
--- a/Documentation/btrfs-device.asciidoc
+++ b/Documentation/btrfs-device.asciidoc
@@ -106,23 +106,21 @@ Show detailed information about internal allocations in devices.
 +
 `Options`
 +
--b|--raw::::
+--raw::::
 raw numbers in bytes, without the 'B' suffix
--h|--human-readable::::
+--human-readable::::
 print human friendly numbers, base 1024, this is the default
--H::::
-print human friendly numbers, base 1000
 --iec::::
 select the 1024 base for the following options, according to the IEC standard
 --si::::
 select the 1000 base for the following options, according to the SI standard
--k|--kbytes::::
+--kbytes::::
 show sizes in KiB, or kB with --si
--m|--mbytes::::
+--mbytes::::
 show sizes in MiB, or MB with --si
--g|--gbytes::::
+--gbytes::::
 show sizes in GiB, or GB with --si
--t|--tbytes::::
+--tbytes::::
 show sizes in TiB, or TB with --si
 
 If conflicting options are passed, the last one takes precedence.
diff --git a/Documentation/btrfs-filesystem.asciidoc b/Documentation/btrfs-filesystem.asciidoc
index 31cd51b..5d555fa 100644
--- a/Documentation/btrfs-filesystem.asciidoc
+++ b/Documentation/btrfs-filesystem.asciidoc
@@ -160,23 +160,21 @@ Show detailed information about internal filesystem usage.
 +
 `Options`
 +
--b|--raw::::
+--raw::::
 raw numbers in bytes, without the 'B' suffix
--h|--human-readable::::
+--human-readable::::
 print human friendly numbers, base 1024, this is the default
--H::::
-print human friendly numbers, base 1000
 --iec::::
 select the 1024 base for the following options, according to the IEC standard
 --si::::
 select the 1000 base for the following options, according to the SI standard
--k|--kbytes::::
+--kbytes::::
 show sizes in KiB, or kB with --si
--m|--mbytes::::
+--mbytes::::
 show sizes in MiB, or MB with --si
--g|--gbytes::::
+--gbytes::::
 show sizes in GiB, or GB with --si
--t|--tbytes::::
+--tbytes::::
 show sizes in TiB, or TB with --si
 -T::::
 show data in tabular format
-- 
1.8.5.1

