Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59006 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607Ab2IMJct (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Sep 2012 05:32:49 -0400
Received: from m2.gw.fujitsu.co.jp (unknown [10.0.50.72])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 320803EE0AE
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2012 18:32:47 +0900 (JST)
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 1AE8F45DE4E
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2012 18:32:47 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 0447245DE4D
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2012 18:32:47 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id EC2511DB8038
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2012 18:32:46 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.240.81.134])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id A6EA41DB802C
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2012 18:32:46 +0900 (JST)
Received: from ml14.css.fujitsu.com (ml14 [127.0.0.1])
	by ml14.s.css.fujitsu.com (Postfix) with ESMTP id 68A709F78EF
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2012 18:32:46 +0900 (JST)
Received: from FM-323941448.jp.fujitsu.com (unknown [10.124.101.87])
	by ml14.s.css.fujitsu.com (Postfix) with SMTP id EC6999F78E5
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2012 18:32:45 +0900 (JST)
Message-Id: <201209130932.AA00010@FM-323941448.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Thu, 13 Sep 2012 18:32:32 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/2] Btrfs: cleanup of error processing in btree_get_extent()
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch simplifies a little complex error processing in
btree_get_extent().

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/disk-io.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 29c69e6..27d0ebe 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -222,21 +222,17 @@ static struct extent_map *btree_get_extent(struct inode *inode,
 
 		free_extent_map(em);
 		em = lookup_extent_mapping(em_tree, start, len);
-		if (em) {
-			ret = 0;
-		} else {
-			em = lookup_extent_mapping(em_tree, failed_start,
-						   failed_len);
-			ret = -EIO;
+		if (!em) {
+			lookup_extent_mapping(em_tree, failed_start,
+					      failed_len);
+			em = ERR_PTR(-EIO);
 		}
 	} else if (ret) {
 		free_extent_map(em);
-		em = NULL;
+		em = ERR_PTR(ret);
 	}
 	write_unlock(&em_tree->lock);
 
-	if (ret)
-		em = ERR_PTR(ret);
 out:
 	return em;
 }
-- 
1.7.6

