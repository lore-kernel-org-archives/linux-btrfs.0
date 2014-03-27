Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:44187 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681AbaC0URX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Mar 2014 16:17:23 -0400
Received: by mail-wi0-f171.google.com with SMTP id q5so431633wiv.4
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Mar 2014 13:17:22 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: send, don't crash if we attempt to build a too long path
Date: Thu, 27 Mar 2014 20:17:12 +0000
Message-Id: <1395951432-14230-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There were recently fixed issues where an incremental send would enter
an infinite loop when building a path string, which made it krealloc the
path buffer over and over. This eventually lead to a kernel crash because
we track the buffer's size in a 15 bits unsigned integer and eventually we
ended up assigning it 32768 (returned by ksize) which made
it get a value of 0. We then use this size to compute an offset into our
buffer which falls outside its range (by 1 byte to the left) when the size
is 0, which would make the memmove operation crash with the following trace:

[ 8541.781613] BUG: unable to handle kernel paging request at ffff88009069c000
[ 8541.781618] IP: [<ffffffff8136cf91>] memmove+0x81/0x1a0
[ 8541.781623] PGD 2a2b067 PUD 21fb01067 PMD 21fa7d067 PTE 800000009069c060
[ 8541.781626] Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
[ 8541.781628] Modules linked in: btrfs raid6_pq xor bnep rfcomm bluetooth binfmt_misc nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc parport_pc psmouse serio_raw parport i2c_piix4 pcspkr evbug e1000 floppy [last unloaded: btrfs]
[ 8541.781641] CPU: 3 PID: 28970 Comm: btrfs Not tainted 3.13.0-fdm-btrfs-next-24+ #1
[ 8541.781642] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 8541.781643] task: ffff88020967c920 ti: ffff880091246000 task.ti: ffff880091246000
[ 8541.781644] RIP: 0010:[<ffffffff8136cf91>]  [<ffffffff8136cf91>] memmove+0x81/0x1a0
[ 8541.781647] RSP: 0018:ffff8800912477c0  EFLAGS: 00010206
[ 8541.781647] RAX: ffff88009069c000 RBX: ffff8800caed46d8 RCX: 0000000000000800
[ 8541.781648] RDX: 0000000000004000 RSI: ffff8800906a0000 RDI: ffff88009069c000
[ 8541.781649] RBP: ffff8800912477e8 R08: 0000000000000001 R09: 0000000000000000
[ 8541.781650] R10: ffff88009069fff8 R11: 6b6b6b6b6b6b6b6b R12: 0000000000000000
[ 8541.781651] R13: 0000000000004000 R14: 0000000000000113 R15: 0000000000000000
[ 8541.781652] FS:  00007fb6c960e800(0000) GS:ffff880216400000(0000) knlGS:0000000000000000
[ 8541.781653] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 8541.781656] CR2: ffff88009069c000 CR3: 00000000cce87000 CR4: 00000000000006e0
[ 8541.781660] Stack:
[ 8541.781660]  ffffffffa02dbfd3 ffffea0007a54300 ffff8800caed46d8 ffff880091247830
[ 8541.781663]  0000000000000003 ffff880091247818 ffffffffa02dc316 000c000000000000
[ 8541.781665]  ffff8800caed5918 ffff8800caed5918 0000000000000003 ffff880091247848
[ 8541.781667] Call Trace:
[ 8541.781679]  [<ffffffffa02dbfd3>] ? fs_path_ensure_buf+0xf3/0x110 [btrfs]
[ 8541.781687]  [<ffffffffa02dc316>] fs_path_prepare_for_add+0x46/0xc0 [btrfs]
[ 8541.781694]  [<ffffffffa02dc418>] fs_path_add_path+0x28/0x50 [btrfs]
[ 8541.781701]  [<ffffffffa02de5a3>] get_cur_path+0x1f3/0x5a0 [btrfs]
(...)

Since we can't have path strings larger than PATH_MAX, just return with an
ENAMETOOLONG error, which is likely caused by infinite path build loops due
to changes in directory hierarchy. This is better then crashing the kernel
and requiring a system reboot.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/send.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index e2e422c..41a4a45 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -349,6 +349,9 @@ static int fs_path_ensure_buf(struct fs_path *p, int len)
 	if (p->buf_len >= len)
 		return 0;
 
+	if (unlikely(len > PATH_MAX))
+		return -ENAMETOOLONG;
+
 	path_len = p->end - p->start;
 	old_buf_len = p->buf_len;
 
@@ -2140,6 +2143,7 @@ static int get_cur_path(struct send_ctx *sctx, u64 ino, u64 gen,
 	u64 parent_inode = 0;
 	u64 parent_gen = 0;
 	int stop = 0;
+	u64 start_ino = ino;
 
 	name = fs_path_alloc();
 	if (!name) {
@@ -2187,6 +2191,12 @@ out:
 	fs_path_free(name);
 	if (!ret)
 		fs_path_unreverse(dest);
+	else if (unlikely(ret == -ENAMETOOLONG))
+		btrfs_warn(sctx->send_root->fs_info,
+			   "Possible path build loop in send operation, inode %llu, send root %llu, parent root %llu",
+			   start_ino, sctx->send_root->root_key.objectid,
+			   sctx->parent_root ?
+			   sctx->parent_root->root_key.objectid : 0);
 	return ret;
 }
 
-- 
1.7.10.4

