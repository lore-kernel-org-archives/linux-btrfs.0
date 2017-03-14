Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751160AbdCNNht (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 09:37:49 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 3D8A020429
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Mar 2017 13:37:47 +0000 (UTC)
Received: from mail-it0-f44.google.com (mail-it0-f44.google.com [209.85.214.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D593203C1
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Mar 2017 13:37:43 +0000 (UTC)
Received: by mail-it0-f44.google.com with SMTP id m27so11209494iti.1
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Mar 2017 06:37:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170314102350.10565-1-rgoldwyn@suse.de>
References: <20170314102350.10565-1-rgoldwyn@suse.de>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 14 Mar 2017 13:37:42 +0000
Message-ID: <CAL3q7H6Yw51w3W=iqVjpmeAq9N6+cy36aedDSTTZO=8uhYE1LA@mail.gmail.com>
Subject: Re: [PATCH v3] qgroup: Retry after commit on getting EDQUOT
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 14, 2017 at 10:23 AM, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>
> We are facing the same problem with EDQUOT which was experienced with
> ENOSPC. Not sure if we require a full ticketing system such as ENOSPC, but
> here is a fix. Let me know if it is too big a hammer.
>
> Quotas are reserved during the start of an operation, incrementing
> qg->reserved. However, it is written to disk in a commit_transaction
> which could take as long as commit_interval. In the meantime there
> could be deletions which are not accounted for because deletions are
> accounted for only while committed (free_refroot). So, when we get
> a EDQUOT flush the data to disk and try again.
>
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>
> Changes since v1:
>  - Changed start_delalloc_roots() to start_delalloc_inode() to target
>     the root in question only to reduce the amount of flush to be done.
>  - Added wait_ordered_extents().
>
> Changes since v2:
>  - Revised patch header
>    - removed comment on combining conditions
>    - removed test case, to be done in fstests

Why do you need to remove the test case?
Looking at the changelog of the fstests patch you sent, it doesn't
mention which btrfs patches fix the problem. So if anyone wants to
find what fixes what, it has to do a bit of a guessing game. If you
look at most examples of btrfs and fstests patches, you'll see that at
least either the fstests patch mentions which btrfs patches fix the
problem or the changelog of btrfs patches contain a reproducer (which
is normally the same or very similar to the fstests test case).

>
>  fs/btrfs/qgroup.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index a5da750..6215264 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2367,6 +2367,7 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce)
>         struct btrfs_fs_info *fs_info = root->fs_info;
>         u64 ref_root = root->root_key.objectid;
>         int ret = 0;
> +       int retried = 0;
>         struct ulist_node *unode;
>         struct ulist_iterator uiter;
>
> @@ -2376,6 +2377,7 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce)
>         if (num_bytes == 0)
>                 return 0;
>
> +retry:
>         spin_lock(&fs_info->qgroup_lock);
>         quota_root = fs_info->quota_root;
>         if (!quota_root)
> @@ -2402,6 +2404,19 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce)
>                 qg = unode_aux_to_qgroup(unode);
>
>                 if (enforce && !qgroup_check_limits(qg, num_bytes)) {
> +                       if (!retried && qg->reserved > 0) {
> +                               struct btrfs_trans_handle *trans;
> +                               spin_unlock(&fs_info->qgroup_lock);
> +                               btrfs_start_delalloc_inodes(root, 0);
> +                               btrfs_wait_ordered_extents(root, -1, 0,
> +                                               (u64)-1);
> +                               trans = btrfs_join_transaction(root);
> +                               if (IS_ERR(trans))
> +                                       return PTR_ERR(trans);
> +                               btrfs_commit_transaction(trans);
> +                               retried++;
> +                               goto retry;
> +                       }
>                         ret = -EDQUOT;
>                         goto out;
>                 }
> --
> 2.10.2
>
