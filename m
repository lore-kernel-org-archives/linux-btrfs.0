Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:47081 "EHLO
	mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbcCXH5z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Mar 2016 03:57:55 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 9CD23AC015E
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Mar 2016 16:47:42 +0900 (JST)
Received: from WIN-5MHF4RKU941.jp.fujitsu.com (unknown [10.124.102.163])
	by m3050.s.css.fujitsu.com (Postfix) with SMTP id 7D558EC
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Mar 2016 16:47:42 +0900 (JST)
Message-Id: <201603240747.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Thu, 24 Mar 2016 16:47:28 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: send: fix handling of multiple snapshots
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We cannot send multiple snapshots at once.

[before fix]
# btrfs send ./snap[12] > snap12.data
At subvol ./snap1
At subvol ./snap2
ERROR: parent determination failed for 0
#

[after fix]
# btrfs send ./snap[12] > snap12.data
At subvol ./snap1
At subvol ./snap2
#

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 cmds-send.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/cmds-send.c b/cmds-send.c
index 3e34d75..a220a49 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -683,15 +683,16 @@ int cmd_send(int argc, char **argv)
 		if (ret < 0)
 			goto out;
 
-		/* done with this subvol, so add it to the clone sources */
-		ret = add_clone_source(&send, root_id);
-		if (ret < 0) {
-			error("not enough memory");
-			goto out;
+		if (!full_send) {
+			/* done with this subvol, so add it to the clone sources */
+			ret = add_clone_source(&send, root_id);
+			if (ret < 0) {
+				error("not enough memory");
+				goto out;
+			}
 		}
 
 		parent_root_id = 0;
-		full_send = 0;
 	}
 
 	ret = 0;
-- 
2.6.4


