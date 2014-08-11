Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33870 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbaHKJMY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 05:12:24 -0400
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 101AA3EE0B6
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 18:12:23 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 27CEEAC044B
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 18:12:22 +0900 (JST)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id D5BB51DB803C
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 18:12:21 +0900 (JST)
Received: from G01JPEXCHKW18.g01.fujitsu.local (G01JPEXCHKW18.g01.fujitsu.local [10.0.194.57])
	by g01jpfmpwkw02.exch.g01.fujitsu.local (Postfix) with ESMTP id 3452C328477
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 18:12:21 +0900 (JST)
Message-ID: <53E888F0.7010207@jp.fujitsu.com>
Date: Mon, 11 Aug 2014 18:12:16 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/3] btrfs-progs: avoid to use numeric literal for the size
 of uuid buffer
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Replace a numeric literal to more descriptive macro for
the size of uuid buffer.

Signed-of-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

---
 cmds-filesystem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 5a80a98..7633f1f 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -603,7 +603,7 @@ static int cmd_show(int argc, char **argv)
 	char mp[BTRFS_PATH_NAME_MAX + 1];
 	char path[PATH_MAX];
 	__u8 fsid[BTRFS_FSID_SIZE];
-	char uuid_buf[37];
+	char uuid_buf[BTRFS_UUID_UNPARSED_SIZE];
 	int found = 0;
 
 	while (1) {
-- 
1.9.3

