Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44316 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727175AbeIAD1u (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Aug 2018 23:27:50 -0400
Received: by mail-pg1-f195.google.com with SMTP id r1-v6so6069038pgp.11
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2018 16:18:05 -0700 (PDT)
Date: Fri, 31 Aug 2018 16:18:03 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 06/35] btrfs: check if free bgs for commit
Message-ID: <20180831231803.GC17237@vader>
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-7-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180830174225.2200-7-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 30, 2018 at 01:41:56PM -0400, Josef Bacik wrote:
> may_commit_transaction will skip committing the transaction if we don't
> have enough pinned space or if we're trying to find space for a SYSTEM
> chunk.  However if we have pending free block groups in this transaction
> we still want to commit as we may be able to allocate a chunk to make
> our reservation.  So instead of just returning ENOSPC, check if we have
> free block groups pending, and if so commit the transaction to allow us
> to use that free space.

This makes sense.

> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/btrfs/extent-tree.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 6e7f350754d2..80615a579b18 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4804,6 +4804,7 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
>  	struct btrfs_trans_handle *trans;
>  	u64 bytes;
>  	u64 reclaim_bytes = 0;
> +	bool do_commit = true;

I find this naming a little mind bending when I read

	do_commit = false;
	goto commit;

Since the end result is that we always join the transaction if we make
it past the (!bytes) check anyways, can we do the pending bgs check
first? I find the following easier to follow, fwiw.

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index de6f75f5547b..dd7aeb5fb6bf 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4779,18 +4779,25 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 	if (!bytes)
 		return 0;
 
-	/* See if there is enough pinned space to make this reservation */
-	if (__percpu_counter_compare(&space_info->total_bytes_pinned,
-				   bytes,
-				   BTRFS_TOTAL_BYTES_PINNED_BATCH) >= 0)
-		goto commit;
+	trans = btrfs_join_transaction(fs_info->extent_root);
+	if (IS_ERR(trans))
+		return -ENOSPC;
+
+	/*
+	 * See if we have a pending bg or there is enough pinned space to make
+	 * this reservation.
+	 */
+	if (test_bit(BTRFS_TRANS_HAVE_FREE_BGS, &trans->transaction->flags) ||
+	    __percpu_counter_compare(&space_info->total_bytes_pinned, bytes,
+				     BTRFS_TOTAL_BYTES_PINNED_BATCH) >= 0)
+		return btrfs_commit_transaction(trans);
 
 	/*
 	 * See if there is some space in the delayed insertion reservation for
 	 * this reservation.
 	 */
 	if (space_info != delayed_rsv->space_info)
-		return -ENOSPC;
+		goto enospc;
 
 	spin_lock(&delayed_rsv->lock);
 	if (delayed_rsv->size > bytes)
@@ -4801,16 +4808,14 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 
 	if (__percpu_counter_compare(&space_info->total_bytes_pinned,
 				   bytes,
-				   BTRFS_TOTAL_BYTES_PINNED_BATCH) < 0) {
-		return -ENOSPC;
-	}
-
-commit:
-	trans = btrfs_join_transaction(fs_info->extent_root);
-	if (IS_ERR(trans))
-		return -ENOSPC;
+				   BTRFS_TOTAL_BYTES_PINNED_BATCH) < 0)
+		goto enospc;
 
 	return btrfs_commit_transaction(trans);
+
+enospc:
+	btrfs_end_transaction(trans);
+	return -ENOSPC;
 }
 
 /*
