Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31533 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882AbbHDOo1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Aug 2015 10:44:27 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t74EiQp3018197
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 4 Aug 2015 14:44:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
	by aserv0022.oracle.com (8.13.8/8.13.8) with ESMTP id t74EiPsJ026379
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Tue, 4 Aug 2015 14:44:26 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
	by userv0122.oracle.com (8.13.8/8.13.8) with ESMTP id t74EiFIq029449
	for <linux-btrfs@vger.kernel.org>; Tue, 4 Aug 2015 14:44:25 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 2/3] Btrfs: fix null pointer dereference when extent buffer is already freed
Date: Tue,  4 Aug 2015 22:43:52 +0800
Message-Id: <1438699433-1581-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1438699433-1581-1-git-send-email-anand.jain@oracle.com>
References: <1438699433-1581-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When, read_tree_block() returns error it has already freed the extent_buffer

read_tree_block(..)
{
::
        ret = btree_read_extent_buffer_pages(root, buf, 0, parent_transid); <== fails
        if (ret) {
                free_extent_buffer(buf); <=== its freed already
                return ERR_PTR(ret);
        }
::
}

open_ctree()
{
::
	chunk_root->node = read_tree_block(..);
::

BTRFS: failed to read chunk root on sdf
BUG: unable to handle kernel NULL pointer dereference at 000000000000001f
IP: [<ffffffffa04f930e>] free_extent_buffer+0x1e/0xb0 [btrfs]
::
[<ffffffffa04c7dae>] ? free_root_extent_buffers+0x1e/0x40 [btrfs]
[<ffffffffa04c7e26>] free_root_pointers+0x56/0x60 [btrfs]
[<ffffffffa04cebc0>] open_ctree+0x19e0/0x2360 [btrfs]
[<ffffffffa04a2676>] btrfs_mount+0x9e6/0xb10 [btrfs]
[<ffffffff81353cea>] ? find_next_zero_bit+0x1a/0x30
[<ffffffff81353cb5>] ? find_next_bit+0x15/0x30
[<ffffffff8119246a>] ? pcpu_alloc+0x35a/0x680
[<ffffffff811ec648>] mount_fs+0x38/0x190
[<ffffffff811927c5>] ? __alloc_percpu+0x15/0x20
[<ffffffff81207ecb>] vfs_kern_mount+0x6b/0x120
[<ffffffffa04a1e88>] btrfs_mount+0x1f8/0xb10 [btrfs]
[<ffffffff8119246a>] ? pcpu_alloc+0x35a/0x680
[<ffffffff811ec648>] mount_fs+0x38/0x190
[<ffffffff811927c5>] ? __alloc_percpu+0x15/0x20
[<ffffffff81207ecb>] vfs_kern_mount+0x6b/0x120
[<ffffffff8120af54>] do_mount+0x224/0xb80
[<ffffffff8120bbbe>] SyS_mount+0x7e/0xe0
[<ffffffff815d00ae>] system_call_fastpath+0x12/0x71

this patch avoids calling it again

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index da7b7bf..e8901ac 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2081,7 +2081,8 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 static void free_root_extent_buffers(struct btrfs_root *root)
 {
 	if (root) {
-		free_extent_buffer(root->node);
+		if (!IS_ERR(root->node))
+			free_extent_buffer(root->node);
 		free_extent_buffer(root->commit_root);
 		root->node = NULL;
 		root->commit_root = NULL;
-- 
2.4.1

