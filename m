Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60609 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966825Ab3DSBFJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Apr 2013 21:05:09 -0400
Received: from m1.gw.fujitsu.co.jp (unknown [10.0.50.71])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 9125D3EE0C1
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Apr 2013 10:05:06 +0900 (JST)
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 79D9845DE55
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Apr 2013 10:05:06 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 6197845DE58
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Apr 2013 10:05:06 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 52FEE1DB8032
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Apr 2013 10:05:06 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.240.81.134])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 0BD551DB8049
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Apr 2013 10:05:06 +0900 (JST)
Received: from ml14.css.fujitsu.com (ml14 [127.0.0.1])
	by ml14.s.css.fujitsu.com (Postfix) with ESMTP id D61059F7DA0
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Apr 2013 10:05:05 +0900 (JST)
Received: from FM-323941448.jp.fujitsu.com (unknown [10.124.101.132])
	by ml14.s.css.fujitsu.com (Postfix) with SMTP id 694399F7DC4
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Apr 2013 10:05:05 +0900 (JST)
Message-Id: <201304190104.AA00029@FM-323941448.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Fri, 19 Apr 2013 10:04:46 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix error handling in btrfs_ioctl_send()
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fget() returns NULL if error. So, we should check NULL or not.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/send.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 96a826a..f892e0e 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4610,8 +4610,8 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 	sctx->flags = arg->flags;
 
 	sctx->send_filp = fget(arg->send_fd);
-	if (IS_ERR(sctx->send_filp)) {
-		ret = PTR_ERR(sctx->send_filp);
+	if (!sctx->send_filp) {
+		ret = -EBADF;
 		goto out;
 	}
 

