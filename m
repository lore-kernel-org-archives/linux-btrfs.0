Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44372 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab2IMJdJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Sep 2012 05:33:09 -0400
Received: from m4.gw.fujitsu.co.jp (unknown [10.0.50.74])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id B32953EE0BB
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2012 18:33:07 +0900 (JST)
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 9C48C45DE51
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2012 18:33:07 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 8196D45DE4F
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2012 18:33:07 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 725071DB803E
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2012 18:33:07 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.240.81.134])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 295361DB802F
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2012 18:33:07 +0900 (JST)
Received: from ml14.css.fujitsu.com (ml14 [127.0.0.1])
	by ml14.s.css.fujitsu.com (Postfix) with ESMTP id F380B9F78E4
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2012 18:33:06 +0900 (JST)
Received: from FM-323941448.jp.fujitsu.com (unknown [10.124.101.87])
	by ml14.s.css.fujitsu.com (Postfix) with SMTP id 61E129F78E5
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2012 18:33:06 +0900 (JST)
Message-Id: <201209130932.AA00011@FM-323941448.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Thu, 13 Sep 2012 18:32:54 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/2] Btrfs: remove unnecessary code in btree_get_extent()
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Unnecessary lookup_extent_mapping() is removed because an error is
returned to the caller.
This patch was made based on the advice from Stefan Behrens, thanks.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/disk-io.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 27d0ebe..8b7dce9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -217,16 +217,10 @@ static struct extent_map *btree_get_extent(struct inode *inode,
 	write_lock(&em_tree->lock);
 	ret = add_extent_mapping(em_tree, em);
 	if (ret == -EEXIST) {
-		u64 failed_start = em->start;
-		u64 failed_len = em->len;
-
 		free_extent_map(em);
 		em = lookup_extent_mapping(em_tree, start, len);
-		if (!em) {
-			lookup_extent_mapping(em_tree, failed_start,
-					      failed_len);
+		if (!em)
 			em = ERR_PTR(-EIO);
-		}
 	} else if (ret) {
 		free_extent_map(em);
 		em = ERR_PTR(ret);
-- 
1.7.6

