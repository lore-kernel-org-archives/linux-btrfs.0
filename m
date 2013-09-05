Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:60753 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559Ab3IEFvp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Sep 2013 01:51:45 -0400
Received: from /spool/local
	by e23smtp08.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 5 Sep 2013 15:48:22 +1000
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [9.190.235.21])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id E3D3D3578054
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Sep 2013 15:51:39 +1000 (EST)
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r855pSpH9175544
	for <linux-btrfs@vger.kernel.org>; Thu, 5 Sep 2013 15:51:28 +1000
Received: from d23av02.au.ibm.com (localhost [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id r855pdsu003677
	for <linux-btrfs@vger.kernel.org>; Thu, 5 Sep 2013 15:51:39 +1000
From: chandan <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: chandra.seetharaman@us.ibm.com
Subject: [PATCH] btrfs-progs: btrfs_setup_chunk_tree_and_device_map: Return -EIO on error.
Date: Thu, 05 Sep 2013 11:21:30 +0530
Message-ID: <1748503.OfecYaovVX@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As a result of a successful call to btrfs_read_sys_array(), the 'ret'
variable is already set to 0. Hence the function would return 0 even
if the call to read_tree_block() fails.

Signed-off-by: chandan <chandan@linux.vnet.ibm.com>
---
 disk-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/disk-io.c b/disk-io.c
index fec7700..0f69f0f 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -966,7 +966,7 @@ int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info)
 	if (!fs_info->chunk_root->node ||
 	    !extent_buffer_uptodate(fs_info->chunk_root->node)) {
 		fprintf(stderr, "Couldn't read chunk root\n");
-		return ret;
+		return -EIO;
 	}
 
 	if (!(btrfs_super_flags(sb) & BTRFS_SUPER_FLAG_METADUMP)) {
-- 
1.8.3.1


