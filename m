Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:45811 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752900AbaLARGP (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Mon, 1 Dec 2014 12:06:15 -0500
From: Filipe Manana <fdmanana@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] Btrfs: fix extent map leak on chunk allocation failure
Date: Mon,  1 Dec 2014 17:05:45 +0000
Message-Id: <1417453545-31555-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On error, after adding the extent map to the tree and to the pending
chunks list, we would leave decrementing the extent map's refcount
by 2 instead of 3 (our allocation + tree reference + list reference).

Detected by 'rmmod btrfs':

[20770.105881] kmem_cache_destroy btrfs_extent_map: Slab cache still has objects
[20770.106127] CPU: 2 PID: 11093 Comm: rmmod Tainted: G        W    L 3.17.0-rc5-btrfs-next-1+ #1
[20770.106128] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
[20770.106130]  0000000000000000 ffff8800ba867eb8 ffffffff813e7a13 ffff8800a2e11040
[20770.106132]  ffff8800ba867ed0 ffffffff81105d0c 0000000000000000 ffff8800ba867ee0
[20770.106134]  ffffffffa035d65e ffff8800ba867ef0 ffffffffa03b0654 ffff8800ba867f78
[20770.106136] Call Trace:
[20770.106142]  [<ffffffff813e7a13>] dump_stack+0x45/0x56
[20770.106145]  [<ffffffff81105d0c>] kmem_cache_destroy+0x4b/0x90
[20770.106164]  [<ffffffffa035d65e>] extent_map_exit+0x1a/0x1c [btrfs]
[20770.106176]  [<ffffffffa03b0654>] exit_btrfs_fs+0x27/0x9d3 [btrfs]
[20770.106179]  [<ffffffff8109dc97>] SyS_delete_module+0x153/0x1c4
[20770.106182]  [<ffffffff8121261b>] ? trace_hardirqs_on_thunk+0x3a/0x3c
[20770.106184]  [<ffffffff813ebf52>] system_call_fastpath+0x16/0x1b

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/volumes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 66a5a1e..e936fe3 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4496,6 +4496,8 @@ error_del_extent:
 	free_extent_map(em);
 	/* One for the tree reference */
 	free_extent_map(em);
+	/* One for the pending_chunks list reference */
+	free_extent_map(em);
 error:
 	kfree(devices_info);
 	return ret;
-- 
2.1.3

