Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:61363 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbcG1I2e (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jul 2016 04:28:34 -0400
Received: from adam-work.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id D1A434056403
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Jul 2016 16:28:27 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: Doc: Fix format error in btrfs-send
Date: Thu, 28 Jul 2016 16:28:25 +0800
Message-Id: <20160728082825.21376-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Documentation/btrfs-send.asciidoc | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/btrfs-send.asciidoc b/Documentation/btrfs-send.asciidoc
index 47b0b04..96659ee 100644
--- a/Documentation/btrfs-send.asciidoc
+++ b/Documentation/btrfs-send.asciidoc
@@ -53,6 +53,7 @@ send in 'NO_FILE_DATA' mode
 The output stream does not contain any file
 data and thus cannot be used to transfer changes. This mode is faster and
 useful to show the differences in metadata.
+
 -v|--verbose::
 enable verbose output, print generated commands in a readable form, (each
 occurrence of this option increases the verbosity level)
-- 
2.9.0



