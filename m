Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751211AbdCMMOy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Mar 2017 08:14:54 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 95F572041A
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Mar 2017 12:14:51 +0000 (UTC)
Received: from mail-it0-f54.google.com (mail-it0-f54.google.com [209.85.214.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3029B203E6
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Mar 2017 12:14:50 +0000 (UTC)
Received: by mail-it0-f54.google.com with SMTP id w124so10824668itb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Mar 2017 05:14:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170311230257.12260-1-rgoldwyn@suse.de>
References: <20170311230257.12260-1-rgoldwyn@suse.de>
From: Filipe Manana <fdmanana@kernel.org>
Date: Mon, 13 Mar 2017 12:14:49 +0000
Message-ID: <CAL3q7H5fNs_gL2oh7HpRPCfuA=Omw0jUUCvyoXAs14OqvZOsrQ@mail.gmail.com>
Subject: Re: [PATCH v2] qgroup: Retry after commit on getting EDQUOT
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 11, 2017 at 11:02 PM, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
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

So this doesn't explain why the problem happens, taking into account
the reproducer below.
You mention that deletions are only accounted at transaction commit
time, but the reproducer does not do any deletions.
So why does the reproducer gets EDQUOT errors? The second sentence
"However, it is written to disk in a commit_transaction
which could take as long as commit_interval." also does not explain
why is that a problem, why it makes the reproducer get EDQUOT errors.

I would like to see a clear and complete explanation in the changelog.

>
> I combined the conditions of rfer and excl to reduce code lines, though
> the condition looks uglier.

This sentence is outdated, it's no longer valid for v2 as it now calls
qgroup_check_limits().

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

Please write a test case for fstests.

>
> Changes since v1:
>  - Changed start_delalloc_roots() to start_delalloc_inode() to target
>    the root in question only to reduce the amount of flush to be done.
>  - Added wait_ordered_extents().

Listing what changed between versions is not meant to appear in the
changelog. This should go after the --- below. You should also prefix
the patch subject with "btrfs:" (or "btrfs-progs:"). See the examples
from others or the wiki for intsructions
(https://btrfs.wiki.kernel.org/index.php/Writing_patch_for_btrfs#Updating_patches).

thanks

>
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
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
