Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27616 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757686Ab3BRKIZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Feb 2013 05:08:25 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r1IA8OiX002057
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2013 10:08:24 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r1IA8NtW009080
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2013 10:08:23 GMT
Received: from abhmt116.oracle.com (abhmt116.oracle.com [141.146.116.68])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r1IA8N7Q027748
	for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2013 04:08:23 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: fix segmentation fault of 'btrfs-debug-tree -e'
Date: Mon, 18 Feb 2013 18:05:17 +0800
Message-Id: <1361181917-8774-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Due to some historical reasons, we remove 'printing leaf' part, which'd
lead to 'Segmentation fault' of btrfs-debug-tree -e, this patch adds it
back.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 debug-tree.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/debug-tree.c b/debug-tree.c
index f6bd5d8..02b0389 100644
--- a/debug-tree.c
+++ b/debug-tree.c
@@ -52,6 +52,11 @@ static void print_extents(struct btrfs_root *root, struct extent_buffer *eb)
 	if (!eb)
 		return;
 
+	if (btrfs_is_leaf(eb)) {
+		btrfs_print_leaf(root, eb);
+		return;
+	}
+
 	size = btrfs_level_size(root, btrfs_header_level(eb) - 1);
 	nr = btrfs_header_nritems(eb);
 	for (i = 0; i < nr; i++) {
-- 
1.7.7.6

