Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38493 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbaHKJNL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 05:13:11 -0400
Received: from kw-mxoi1.gw.nic.fujitsu.com (unknown [10.0.237.133])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 2446B3EE1D8
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 18:13:10 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 2C4ADAC046E
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 18:13:09 +0900 (JST)
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id D9E141DB802C
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 18:13:08 +0900 (JST)
Received: from G01JPEXCHKW14.g01.fujitsu.local (G01JPEXCHKW14.g01.fujitsu.local [10.0.194.53])
	by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 3181FBD648E
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 18:13:08 +0900 (JST)
Message-ID: <53E8891F.3010607@jp.fujitsu.com>
Date: Mon, 11 Aug 2014 18:13:03 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/3] btrfs-progs: Show error message if btrfs filesystem show
 failed to find any btrfs filesystem
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Current btrfs doesn't display any error message if this command
failed to find any btrfs filesystem corresponding to
<path>|<uuid>|<device>|<label> which user specified.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

---
 cmds-filesystem.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 7633f1f..2f78e24 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -695,6 +695,7 @@ static int cmd_show(int argc, char **argv)
 		ret = btrfs_scan_kernel(search);
 	if (search && !ret) {
 		/* since search is found we are done */
+		found = 1;
 		goto out;
 	}
 
@@ -729,6 +730,15 @@ devs_only:
 		btrfs_close_devices(fs_devices);
 	}
 out:
+	if (search && !found) {
+		fprintf(stderr,
+			"ERROR: Couldn't find any btrfs filesystem "
+			"matches with '%s'.\n", search);
+		fprintf(stderr,
+			"Please check if both '%s' and the range of scanning "
+			"are correct.\n", search);
+	}
+
 	printf("%s\n", BTRFS_BUILD_VERSION);
 	free_seen_fsid();
 	return ret;
-- 
1.9.3

