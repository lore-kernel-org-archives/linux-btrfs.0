Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35231 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab2IFGSr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Sep 2012 02:18:47 -0400
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id BAEE03EE0C1
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Sep 2012 15:18:45 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id A127645DEBC
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Sep 2012 15:18:45 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 89D9245DEB6
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Sep 2012 15:18:45 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 73F9A1DB8041
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Sep 2012 15:18:45 +0900 (JST)
Received: from m1000.s.css.fujitsu.com (m1000.s.css.fujitsu.com [10.240.81.136])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 2B1761DB803B
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Sep 2012 15:18:45 +0900 (JST)
Message-Id: <201209060618.AA00004@FM-323941448.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Thu, 06 Sep 2012 15:18:10 +0900
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: check return value of ulist_alloc() properly
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

ulist_alloc() has the possibility of returning NULL.
So, it is necessary to check the return value.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/qgroup.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 38b42e7..7aee652 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1473,6 +1473,10 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
 	 * be exceeded
 	 */
 	ulist = ulist_alloc(GFP_ATOMIC);
+	if (!ulist) {
+		ret = -ENOMEM;
+		goto out;
+	}
 	ulist_add(ulist, qgroup->qgroupid, (unsigned long)qgroup, GFP_ATOMIC);
 	ULIST_ITER_INIT(&uiter);
 	while ((unode = ulist_next(ulist, &uiter))) {
@@ -1545,6 +1549,10 @@ void btrfs_qgroup_free(struct btrfs_root *root, u64 num_bytes)
 		goto out;
 
 	ulist = ulist_alloc(GFP_ATOMIC);
+	if (!ulist) {
+		btrfs_std_error(fs_info, -ENOMEM);
+		goto out;
+	}
 	ulist_add(ulist, qgroup->qgroupid, (unsigned long)qgroup, GFP_ATOMIC);
 	ULIST_ITER_INIT(&uiter);
 	while ((unode = ulist_next(ulist, &uiter))) {

