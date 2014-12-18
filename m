Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42840 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaLRHjs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Dec 2014 02:39:48 -0500
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 81F203EE188
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Dec 2014 16:39:47 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 80576AC0655
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Dec 2014 16:39:46 +0900 (JST)
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 252721DB804B
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Dec 2014 16:39:46 +0900 (JST)
Message-ID: <549284AE.9020201@jp.fujitsu.com>
Date: Thu, 18 Dec 2014 16:39:26 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: naota <naota@elisp.net>, Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH v2] Fix wrong memory free on check_is_root
Content-Type: text/plain; charset="iso-2022-jp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

When "/" is Btrfs, "btrfs property <subcommand> /" regards it
as non-root by mistake.

check_is_root() regards @object as a file system root if
the following two conditions are satisfied.

 a) Both @object and its parent directory are Btrfs object
    (file system root, subvolume, inode, and device
    used for Btrfs).
 b) fsid of the above mentioned two objects are different.

It doesn't work if @object is "/" because, in this case,
fsid of "/" and its parent (it's also "/"), are the same.

* Test environment

Two Btrfs file system (not subvolume) "/" and "/home/sat/mnt".

* How to reproduce

Submit "btrfs prop get" against the above mentioned file systems.

* Test Result

** Actual result (without my patch)

==========================
# btrfs prop get /home/sat/mnt/
ro=false
label=                 # label is displayed because it's a file system root
# btrfs prop get /
ro=false               # label is not displayed even if it's a file system root
==========================
** Expected result (with my patch)

==========================
# ./btrfs-new prop get btrfs-auto-test/
# ./btrfs-new prop get /home/sat/mnt/
ro=false
label=
# ./btrfs-new prop get /             
ro=false
label=foo            # label is displayed
===========================

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Reported-by: Naohiro Aota <naota@elisp.net>

---
changelog
v2: Return a correct error code when realpath() fails.
    Thank you Gui Hecheng for pointing my mistake out.
    https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg40204.html
---
 cmds-property.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/cmds-property.c b/cmds-property.c
index a764293..6501338 100644
--- a/cmds-property.c
+++ b/cmds-property.c
@@ -124,7 +124,18 @@ static int check_is_root(const char *object)
 	int ret;
 	u8 fsid[BTRFS_FSID_SIZE];
 	u8 fsid2[BTRFS_FSID_SIZE];
-	char *tmp;
+	char *tmp = NULL;
+	char *rp;
+
+	rp = realpath(object, NULL);
+	if (!rp) {
+		ret = -errno;
+		goto out;
+	}
+	if (!strcmp(rp, "/")) {
+		ret = 0;
+		goto out;
+	}
 
 	tmp = malloc(strlen(object) + 5);
 	if (!tmp) {
@@ -165,6 +176,7 @@ static int check_is_root(const char *object)
 
 out:
 	free(tmp);
+	free(rp);
 	return ret;
 }
 
-- 
1.9.3

