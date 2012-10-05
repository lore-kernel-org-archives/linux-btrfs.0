Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35230 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068Ab2JEJfh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2012 05:35:37 -0400
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id B9C5B3EE0C1
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Oct 2012 18:35:35 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 9BEBE45DEB5
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Oct 2012 18:35:35 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 852D545DEB2
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Oct 2012 18:35:35 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 765541DB803C
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Oct 2012 18:35:35 +0900 (JST)
Received: from m1000.s.css.fujitsu.com (m1000.s.css.fujitsu.com [10.240.81.136])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 2D3501DB8038
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Oct 2012 18:35:35 +0900 (JST)
Message-Id: <201210050935.AA00014@FM-323941448.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Fri, 05 Oct 2012 18:35:07 +0900
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com
Subject: [PATCH] Btrfs: fix error processing in btrfs_set_acl()
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The error is only returned when kmalloc() fails.
Therefore, to return the error to the caller directly here, I changed the code.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/acl.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 761e2cd..74ee421 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -136,10 +136,8 @@ static int btrfs_set_acl(struct btrfs_trans_handle *trans,
 	if (acl) {
 		size = posix_acl_xattr_size(acl->a_count);
 		value = kmalloc(size, GFP_NOFS);
-		if (!value) {
-			ret = -ENOMEM;
-			goto out;
-		}
+		if (!value)
+			return -ENOMEM;
 
 		ret = posix_acl_to_xattr(acl, value, size);
 		if (ret < 0)
-- 
1.7.12.2

