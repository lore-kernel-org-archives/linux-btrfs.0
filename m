Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:33838 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933065AbdCJQGg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Mar 2017 11:06:36 -0500
Received: by mail-io0-f195.google.com with SMTP id n76so7328999ioe.1
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Mar 2017 08:06:35 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20170219133059.20939-1-rgoldwyn@suse.de>
References: <20170219133059.20939-1-rgoldwyn@suse.de>
From: Filipe Manana <fdmanana@gmail.com>
Date: Fri, 10 Mar 2017 16:06:34 +0000
Message-ID: <CAL3q7H7U6xsL0_MN=is9P0A97fT+SzEq1tz-ei5r12tm2ztQmQ@mail.gmail.com>
Subject: Re: [PATCH] qgroup: Retry after commit on getting EDQUOT
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 19, 2017 at 1:30 PM, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
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
> I combined the conditions of rfer and excl to reduce code lines, though
> the condition looks uglier.
>
> Here is a sample script which shows this issue.
>
> DEVICE=/dev/vdb
> MOUNTPOINT=/mnt
> TESTVOL=$MOUNTPOINT/tmp
> QUOTA=5
> PROG=btrfs
> DD_BS="4k"
> DD_COUNT="256"
> RUN_TIMES=5000
>
> mkfs.btrfs -f $DEVICE
> mount -o commit=240 $DEVICE $MOUNTPOINT
> $PROG subvolume create $TESTVOL
> $PROG quota enable $TESTVOL
> $PROG qgroup limit ${QUOTA}G $TESTVOL
>
> typeset -i DD_RUN_GOOD
> typeset -i QUOTA
>
> function _check_cmd() {
>         if [[ ${?} > 0 ]]; then
>                 echo -n "$(date) E: Running previous command"
>                 echo ${*}
>                 echo "Without sync"
>                 $PROG qgroup show -pcreFf ${TESTVOL}
>                 echo "With sync"
>                 $PROG qgroup show -pcreFf --sync ${TESTVOL}
>                 exit 1
>         fi
> }
>
> while true; do
> DD_RUN_GOOD=$RUN_TIMES
>
> while (( ${DD_RUN_GOOD} != 0 )); do
>         dd if=/dev/zero of=${TESTVOL}/quotatest${DD_RUN_GOOD} bs=${DD_BS} count=${DD_COUNT}
>         _check_cmd "dd if=/dev/zero of=${TESTVOL}/quotatest${DD_RUN_GOOD} bs=${DD_BS} count=${DD_COUNT}"
>         DD_RUN_GOOD=(${DD_RUN_GOOD}-1)
> done
>
> $PROG qgroup show -pcref $TESTVOL
> echo "----------- Cleanup ---------- "
> rm $TESTVOL/quotatest*
>
> done
>
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/btrfs/qgroup.c | 28 +++++++++++++++++-----------
>  1 file changed, 17 insertions(+), 11 deletions(-)
>
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 4700cac..9ace407 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2093,6 +2093,7 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
>         struct btrfs_fs_info *fs_info = root->fs_info;
>         u64 ref_root = root->root_key.objectid;
>         int ret = 0;
> +       int retried = 0;
>         struct ulist_node *unode;
>         struct ulist_iterator uiter;
>
> @@ -2101,7 +2102,7 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
>
>         if (num_bytes == 0)
>                 return 0;
> -
> +retry:
>         spin_lock(&fs_info->qgroup_lock);
>         quota_root = fs_info->quota_root;
>         if (!quota_root)
> @@ -2127,16 +2128,21 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
>
>                 qg = u64_to_ptr(unode->aux);
>
> -               if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
> -                   qg->reserved + (s64)qg->rfer + num_bytes >
> -                   qg->max_rfer) {
> -                       ret = -EDQUOT;
> -                       goto out;
> -               }
> -
> -               if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL) &&
> -                   qg->reserved + (s64)qg->excl + num_bytes >
> -                   qg->max_excl) {
> +               if (((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
> +                     qg->reserved + (s64)qg->rfer + num_bytes > qg->max_rfer) ||
> +                   ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL) &&
> +                   qg->reserved + (s64)qg->excl + num_bytes > qg->max_excl)) {
> +                       if (!retried && qg->reserved > 0) {
> +                               struct btrfs_trans_handle *trans;
> +                               spin_unlock(&fs_info->qgroup_lock);
> +                               btrfs_start_delalloc_roots(fs_info, 0, -1);

Only seeing this now, because the thread was bumped.

But do you really need to flush delayed writes for all subvolumes?
Why isn't it enough to do it just for the subvolume we are attempting
to write to?
Just flushing the data for that subvolume (root) should be enough, as
we do when creating snapshots for example (ioctl.c:create_snapshot()).

thanks

> +                               trans = btrfs_join_transaction(root);
> +                               if (IS_ERR(trans))
> +                                       return PTR_ERR(trans);
> +                               btrfs_commit_transaction(trans, root);
> +                               retried++;
> +                               goto retry;
> +                       }
>                         ret = -EDQUOT;
>                         goto out;
>                 }
> --
> 2.10.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"People will forget what you said,
 people will forget what you did,
 but people will never forget how you made them feel."
