Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:6701 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbcCICNZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Mar 2016 21:13:25 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 7E60E4056401
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Mar 2016 10:13:01 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: util: Fix a wrong unit of pretty_size
Date: Wed,  9 Mar 2016 10:10:55 +0800
Message-Id: <1457489455-9685-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If parameter for pretty_size is smaller than default base(1024),
pretty_size() will output wrong unit.
For example, pretty_size(1008) will output '0.98B' not '1008B' or
'0.98KiB'.

The cause is, for default base and auto-detect unit, base will be 1024
but num_divs is still 0, last result will still be divided by base,
causing the bug.

Fix it by checking num_divs in default case, and if num_divs is 0,
change base to 1.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 utils.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/utils.c b/utils.c
index f814017..52237db 100644
--- a/utils.c
+++ b/utils.c
@@ -1695,6 +1695,13 @@ int pretty_size_snprintf(u64 size, char *str, size_t str_size, unsigned unit_mod
 			size /= mult;
 			num_divs++;
 		}
+		/*
+		 * If the value is smaller than base, we didn't do any
+		 * division, in that case, base should be 1, not original
+		 * base, or the unit will be wrong
+		 */
+		if (num_divs == 0)
+			base = 1;
 	}
 
 	if (num_divs >= ARRAY_SIZE(unit_suffix_binary)) {
-- 
2.7.2



