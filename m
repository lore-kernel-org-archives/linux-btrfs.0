Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59551 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbbAIIiL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Jan 2015 03:38:11 -0500
Received: from kw-mxoi1.gw.nic.fujitsu.com (unknown [10.0.237.133])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 4C0533EE1E5
	for <linux-btrfs@vger.kernel.org>; Fri,  9 Jan 2015 17:38:09 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 3E5EEAC086D
	for <linux-btrfs@vger.kernel.org>; Fri,  9 Jan 2015 17:38:08 +0900 (JST)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id E5923E08006
	for <linux-btrfs@vger.kernel.org>; Fri,  9 Jan 2015 17:38:07 +0900 (JST)
Received: from WIN-R1VKH1IH438.jp.fujitsu.com (unknown [10.124.102.85])
	by m3051.s.css.fujitsu.com (Postfix) with SMTP id B8341D5
	for <linux-btrfs@vger.kernel.org>; Fri,  9 Jan 2015 17:38:07 +0900 (JST)
Message-Id: <201501090837.AA00007@WIN-R1VKH1IH438.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Fri, 09 Jan 2015 17:37:52 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix typo of variable in scrub_stripe
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The address that should be freed is not 'ppath' but 'path'.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com> 
---
 fs/btrfs/scrub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index f2bb13a..403fbdb 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3053,7 +3053,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 
 	ppath = btrfs_alloc_path();
 	if (!ppath) {
-		btrfs_free_path(ppath);
+		btrfs_free_path(path);
 		return -ENOMEM;
 	}
 
-- 
2.2.1

