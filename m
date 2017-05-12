Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:35467 "EHLO
        mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751282AbdELMM2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 May 2017 08:12:28 -0400
Received: by mail-qk0-f177.google.com with SMTP id a72so45612613qkj.2
        for <linux-btrfs@vger.kernel.org>; Fri, 12 May 2017 05:12:28 -0700 (PDT)
Message-ID: <1494591145.2787.5.camel@redhat.com>
Subject: Re: btrfs list corruption and soft lockups while testing writeback
 error handling
From: Jeff Layton <jlayton@redhat.com>
To: Chris Mason <clm@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: Liu Bo <bo.li.liu@oracle.com>
Date: Fri, 12 May 2017 08:12:25 -0400
In-Reply-To: <30759db2-127f-a9e6-2c77-5734137ce52c@fb.com>
References: <1494501232.2625.3.camel@redhat.com>
         <1494532377.2771.3.camel@redhat.com>
         <30759db2-127f-a9e6-2c77-5734137ce52c@fb.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2017-05-11 at 15:56 -0400, Chris Mason wrote:
> On 05/11/2017 03:52 PM, Jeff Layton wrote:
> > On Thu, 2017-05-11 at 07:13 -0400, Jeff Layton wrote:
> > > I finally got my writeback error handling test to work on btrfs (thanks,
> > > Chris!), by making the filesystem stripe the data and mirror the
> > > metadata across two devices. The test passes now, but on one run, I got
> > > the following list corruption warning and then a soft lockup (which is
> > > probably fallout from the list corruption).
> > > 
> > > I ran the test several times before and since then without this failure,
> > > so I don't have a clear reproducer. The kernel in this instance is
> > > basically a v4.11 kernel with my pile of writeback error handling
> > > patches on top:
> > > 
> > >     https://urldefense.proofpoint.com/v2/url?u=https-3A__git.samba.org_-3Fp-3Djlayton_linux.git-3Ba-3Dshortlog-3Bh-3Drefs_heads_wberr&d=DwICaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=9QPtTAxcitoznaWRKKHoEQ&m=BXXwaUFQNFNaGGFYHEVlvNBwkrXiIoH7K5iOdR_PvxM&s=xE6pIXeQ1rlaxAV8aTYBSiI06pb3WZoiRJW8Vo1L3NQ&e=
> > > 
> > > It may be that they are a contributing factor, but this smells more like
> > > a bug down in btrfs. Let me know if you need other info:
> 
> [ btrfs inode logging ]
> 
> > (cc'ing Liu Bo since we were discussing this earlier this week)
> > 
> > I can't reproduce this on stock v4.11, so I think this is a bug in my
> > series.
> > 
> > I think this is due to the differences in how errors are being reported
> > from filemap_fdatawait_range now causing some transactions to end up
> > being freed while they're still on the log_ctxs list. I'm working on
> > hunting down the problem now.
> > 
> > Sorry for the noise!
> > 
> 
> There's a list in the inode logging code that we consistently seem to 
> find list debugging assertions with.  We've fixed up all the known 
> issues, but I wouldn't be surprised if we've got a goto fail in there.
> 
> I'll take a look ;)
> 

Thanks. I'm running test 999 here in a loop to reproduce it on a kernel
with my patch series applied:

https://git.samba.org/?p=jlayton/xfstests.git;a=shortlog;h=refs/heads/wberr

The patch below seems to prevent it from crashing, but I'm not at all
sure that this is a correct fix. Still, I think that the way errors are
tracked within btrfs might need some rework around errseq_t's. In
principle, it could make things even simpler now that we don't need to
worry about resetting errors that have been cleared, etc...

--------------------8<--------------------------

[PATCH] btrfs: make btrfs_log_ctx->io_err an errseq_t

The btrfs_log_ctx has an io_err field in it that gets an error stored
in it when there is an I/O error. The way this is done now requires a
lot of extra machinery. Instead, convert it over to using errseq_t
to tell whether there was an error since the context was initialized.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/btrfs/file.c     |  7 ++++---
 fs/btrfs/tree-log.c | 19 -------------------
 fs/btrfs/tree-log.h |  2 ++
 3 files changed, 6 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e15faf240b51..c4afbf556e3a 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1959,7 +1959,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_trans_handle *trans;
 	struct btrfs_log_ctx ctx;
-	int ret = 0;
+	int ret = 0, wb_ret;
 	bool full_sync = 0;
 	u64 len;
 	errseq_t wb_since = READ_ONCE(file->f_wb_err);
@@ -2143,9 +2143,10 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	 * therefore we need to check for errors in the ordered operations,
 	 * which are indicated by ctx.io_err.
 	 */
-	if (ctx.io_err) {
+	wb_ret = filemap_check_wb_error(inode->i_mapping, ctx.io_err);
+	if (wb_ret) {
+		ret = wb_ret;
 		btrfs_end_transaction(trans);
-		ret = ctx.io_err;
 		goto out;
 	}
 
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index d0a123dbb199..da414e488c4b 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4079,11 +4079,6 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	if (ret)
 		return ret;
 
-	if (ordered_io_err) {
-		ctx->io_err = -EIO;
-		return 0;
-	}
-
 	btrfs_init_map_token(&token);
 
 	ret = __btrfs_drop_extents(trans, log, &inode->vfs_inode, path, em->start,
@@ -4165,7 +4160,6 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 	u64 test_gen;
 	int ret = 0;
 	int num = 0;
-	errseq_t since = filemap_sample_wb_error(inode->vfs_inode.i_mapping);
 
 	INIT_LIST_HEAD(&extents);
 
@@ -4199,19 +4193,6 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 
 	list_sort(NULL, &extents, extent_cmp);
 	btrfs_get_logged_extents(inode, logged_list, start, end);
-	/*
-	 * Some ordered extents started by fsync might have completed
-	 * before we could collect them into the list logged_list, which
-	 * means they're gone, not in our logged_list nor in the inode's
-	 * ordered tree. We want the application/user space to know an
-	 * error happened while attempting to persist file data so that
-	 * it can take proper action. If such error happened, we leave
-	 * without writing to the log tree and the fsync must report the
-	 * file data write error and not commit the current transaction.
-	 */
-	ret = filemap_check_wb_error(inode->vfs_inode.i_mapping, since);
-	if (ret)
-		ctx->io_err = ret;
 process:
 	while (!list_empty(&extents)) {
 		em = list_entry(extents.next, struct extent_map, list);
diff --git a/fs/btrfs/tree-log.h b/fs/btrfs/tree-log.h
index 483027f9a7f4..97a6143842a4 100644
--- a/fs/btrfs/tree-log.h
+++ b/fs/btrfs/tree-log.h
@@ -42,6 +42,8 @@ static inline void btrfs_init_log_ctx(struct btrfs_log_ctx *ctx,
 	ctx->io_err = 0;
 	ctx->log_new_dentries = false;
 	ctx->inode = inode;
+	if (inode)
+		ctx->io_err = filemap_sample_wb_error(inode->i_mapping);
 	INIT_LIST_HEAD(&ctx->list);
 }
 
-- 
2.9.3

