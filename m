Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36488 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbbKIRQR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Nov 2015 12:16:17 -0500
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, David Sterba <dsterba@suse.com>, stable@vger.kernel.org
Subject: [PATCH] btrfs: properly set the termination value of ctx->pos in readdir
Date: Mon,  9 Nov 2015 18:14:33 +0100
Message-Id: <1447089273-27157-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The value of ctx->pos in the last readdir call is supposed to be set to
INT_MAX due to 32bit compatibility, unless 'pos' is intentially set to a
larger value, then it's LLONG_MAX.

There's a report from PaX SIZE_OVERFLOW plugin that "ctx->pos++"
overflows (https://forums.grsecurity.net/viewtopic.php?f=1&t=4284), on a
64bit arch, where the value is 0x7fffffffffffffff ie. LLONG_MAX before
the increment.

We can get to that situation like that:

* emit all regular readdir entries
* still in the same call to readdir, bump the last pos to INT_MAX
* next call to readdir will not emit any entries, but will reach the
  bump code again, finds pos to be INT_MAX and sets it to LLONG_MAX

Normally this is not a problem, but if we call readdir again, we'll find
'pos' set to LLONG_MAX and the unconditional increment will overflow.

The report from Victor at
(http://thread.gmane.org/gmane.comp.file-systems.btrfs/49500) with debugging
print shows that pattern:

 Overflow: e
 Overflow: 7fffffff
 Overflow: 7fffffffffffffff
 PAX: size overflow detected in function btrfs_real_readdir
   fs/btrfs/inode.c:5760 cicus.935_282 max, count: 9, decl: pos; num: 0;
   context: dir_context;
 CPU: 0 PID: 2630 Comm: polkitd Not tainted 4.2.3-grsec #1
 Hardware name: Gigabyte Technology Co., Ltd. H81ND2H/H81ND2H, BIOS F3 08/11/2015
  ffffffff81901608 0000000000000000 ffffffff819015e6 ffffc90004973d48
  ffffffff81742f0f 0000000000000007 ffffffff81901608 ffffc90004973d78
  ffffffff811cb706 0000000000000000 ffff8800d47359e0 ffffc90004973ed8
 Call Trace:
  [<ffffffff81742f0f>] dump_stack+0x4c/0x7f
  [<ffffffff811cb706>] report_size_overflow+0x36/0x40
  [<ffffffff812ef0bc>] btrfs_real_readdir+0x69c/0x6d0
  [<ffffffff811dafc8>] iterate_dir+0xa8/0x150
  [<ffffffff811e6d8d>] ? __fget_light+0x2d/0x70
  [<ffffffff811dba3a>] SyS_getdents+0xba/0x1c0
 Overflow: 1a
  [<ffffffff811db070>] ? iterate_dir+0x150/0x150
  [<ffffffff81749b69>] entry_SYSCALL_64_fastpath+0x12/0x83

I haven't reproduced that directly but it's obviously possible to hit.
After seting the 'index_cnt = 1 << 32' in btrfs_set_inode_index_count, the
overflow happens.

The fix avoids entering the "bump" section again once we've finished
emitting the entries.

References: https://forums.grsecurity.net/viewtopic.php?f=1&t=4284
Reported-by: Victor <services@swwu.com>
CC: stable@vger.kernel.org
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/inode.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 611b66d73e80..529bef2a9a01 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5665,6 +5665,7 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 	char *name_ptr;
 	int name_len;
 	int is_curr = 0;	/* ctx->pos points to the current index? */
+	bool emitted;
 
 	/* FIXME, use a real flag for deciding about the key type */
 	if (root->fs_info->tree_root == root)
@@ -5693,6 +5694,7 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 	if (ret < 0)
 		goto err;
 
+	emitted = false;
 	while (1) {
 		leaf = path->nodes[0];
 		slot = path->slots[0];
@@ -5772,6 +5774,7 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 
 			if (over)
 				goto nopos;
+			emitted = true;
 			di_len = btrfs_dir_name_len(leaf, di) +
 				 btrfs_dir_data_len(leaf, di) + sizeof(*di);
 			di_cur += di_len;
@@ -5789,6 +5792,15 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 			goto nopos;
 	}
 
+	/*
+	 * If we haven't emitted any dir entry, we must not touch ctx->pos as
+	 * it was was set to the termination value in previous call. We assume
+	 * that "." and ".." were emitted if we reach this point and set the
+	 * termination value as well for an empty directory.
+	 */
+	if (ctx->pos > 2 && !emitted)
+		goto nopos;
+
 	/* Reached end of directory/root. Bump pos past the last item. */
 	ctx->pos++;
 
-- 
2.6.2

