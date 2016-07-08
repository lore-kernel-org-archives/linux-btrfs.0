Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:55164 "EHLO
	mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbcGHGMH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jul 2016 02:12:07 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 3F8C6AC02DF
	for <linux-btrfs@vger.kernel.org>; Fri,  8 Jul 2016 15:12:01 +0900 (JST)
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: dedupe-inband enable/reconfigure: force option
 does not take argument
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <3042cdcf-7a4a-4524-2b4f-af24f5a8b42f@jp.fujitsu.com>
Date: Fri, 8 Jul 2016 15:11:42 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

---
This patch can be applied to integration-20160704(2355a7e5dcdf122d1924)
---
 cmds-dedupe-ib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-dedupe-ib.c b/cmds-dedupe-ib.c
index 342784c..dbb30ab 100644
--- a/cmds-dedupe-ib.c
+++ b/cmds-dedupe-ib.c
@@ -132,7 +132,7 @@ static int enable_reconfig_dedupe(int argc, char **argv, int reconf)
 			{ "hash-algorithm", required_argument, NULL, 'a'},
 			{ "limit-hash", required_argument, NULL, 'l'},
 			{ "limit-memory", required_argument, NULL, 'm'},
-			{ "force", required_argument, NULL, 'f'},
+			{ "force", no_argument, NULL, 'f'},
 			{ NULL, 0, NULL, 0}
 		};

-- 
2.5.5
