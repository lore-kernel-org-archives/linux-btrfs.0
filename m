Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:32823 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750773AbeBBLps (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Feb 2018 06:45:48 -0500
Received: by mail-ua0-f196.google.com with SMTP id p12so13992896uad.0
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Feb 2018 03:45:47 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20171219074454.2874-1-wqu@suse.com>
References: <20171219074454.2874-1-wqu@suse.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Fri, 2 Feb 2018 11:45:46 +0000
Message-ID: <CAL3q7H5F36cvDh63PaedAXcarE8EftUj6-QAMqoARh-p2DikHA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: qgroup: Fix root item corruption when multiple
 same source snapshiots are created with quota enabled
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 19, 2017 at 7:44 AM, Qu Wenruo <wqu@suse.com> wrote:
> When multiple pending snapshots referring the same source subvolume are
> executed, enabled quota will cause root item corruption, where root
> items are using old bytenr (no backref in extent tree).
>
> This can be triggered by fstests btrfs/152.
>
> The cause is when source subvolume is still dirty, extra commit
> (simplied transaction commit) of qgroup_account_snapshot() can skip
> dirty roots not recorded in current transaction, making root item of
> source subvolume not updated.
>
> Fix it by forcing recording source subvolume in current transaction
> before qgroup sub-transaction commit.
>
> Reported-by: Justin Maggard <jmaggard@netgear.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good.

> ---
>  fs/btrfs/transaction.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index ddae813c01dd..f645e5de5fa5 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -319,7 +319,7 @@ static int record_root_in_trans(struct btrfs_trans_handle *trans,
>         if ((test_bit(BTRFS_ROOT_REF_COWS, &root->state) &&
>             root->last_trans < trans->transid) || force) {
>                 WARN_ON(root == fs_info->extent_root);
> -               WARN_ON(root->commit_root != root->node);
> +               WARN_ON(!force && root->commit_root != root->node);
>
>                 /*
>                  * see below for IN_TRANS_SETUP usage rules
> @@ -1366,6 +1366,14 @@ static int qgroup_account_snapshot(struct btrfs_trans_handle *trans,
>         if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
>                 return 0;
>
> +       /*
> +        * Ensure dirty @src will be commited.
> +        * Or after comming commit_fs_roots() and switch_commit_roots(),
> +        * any dirty but not recorded root will never be updated again.
> +        * Causing outdated root item.
> +        */
> +       record_root_in_trans(trans, src, 1);
> +
>         /*
>          * We are going to commit transaction, see btrfs_commit_transaction()
>          * comment for reason locking tree_log_mutex
> --
> 2.15.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

“Whether you think you can, or you think you can't — you're right.”
