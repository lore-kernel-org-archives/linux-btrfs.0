Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33222 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178Ab2ILI1G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Sep 2012 04:27:06 -0400
Received: from m2.gw.fujitsu.co.jp (unknown [10.0.50.72])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 10ED93EE0C0
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2012 17:27:05 +0900 (JST)
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id EE68345DE4E
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2012 17:27:04 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id D73F945DE4D
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2012 17:27:04 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id CA3B01DB803E
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2012 17:27:04 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.240.81.134])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 83CAF1DB802C
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2012 17:27:04 +0900 (JST)
Received: from ml14.css.fujitsu.com (ml14 [127.0.0.1])
	by ml14.s.css.fujitsu.com (Postfix) with ESMTP id 56DA79F7941
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2012 17:27:04 +0900 (JST)
Received: from FM-323941448.jp.fujitsu.com (unknown [10.124.101.87])
	by ml14.s.css.fujitsu.com (Postfix) with SMTP id EF4719F794C
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2012 17:27:03 +0900 (JST)
Message-Id: <201209120826.AA00007@FM-323941448.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Wed, 12 Sep 2012 17:26:43 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: cleanup of error processing in btree_get_extent()
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

