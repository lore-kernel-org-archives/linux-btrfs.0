Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50875 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab2JAJHo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Oct 2012 05:07:44 -0400
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 404C43EE0BD
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Oct 2012 18:07:43 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 26C8045DEBC
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Oct 2012 18:07:43 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 0218245DEB6
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Oct 2012 18:07:43 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id EA5F81DB803E
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Oct 2012 18:07:42 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.240.81.134])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 9B9B11DB803C
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Oct 2012 18:07:42 +0900 (JST)
Message-Id: <201210010907.AA00012@FM-323941448.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Mon, 01 Oct 2012 18:07:15 +0900
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com
Subject: [PATCH] Btrfs: remove unnecessary IS_ERR in bio_readpage_error()
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Because the value of extent_map is only a correct value or NULL,
so IS_ERR is unnecessary.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/extent_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 979fa0d..576ed9f 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2071,7 +2071,7 @@ static int bio_readpage_error(struct bio *failed_bio, struct page *page,
 		}
 		read_unlock(&em_tree->lock);
 
-		if (!em || IS_ERR(em)) {
+		if (!em) {
 			kfree(failrec);
 			return -EIO;
 		}
-- 
1.7.11.4

