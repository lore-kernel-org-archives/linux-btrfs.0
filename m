Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34240 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753799AbdHUNHZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 09:07:25 -0400
Received: by mail-oi0-f66.google.com with SMTP id v11so15738051oif.1
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Aug 2017 06:07:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1503308630-6652-4-git-send-email-nborisov@suse.com>
References: <1503308630-6652-1-git-send-email-nborisov@suse.com> <1503308630-6652-4-git-send-email-nborisov@suse.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Mon, 21 Aug 2017 16:06:44 +0300
Message-ID: <CAGqmi77X2h1jzaU8cKdb_19dEssMBiBwNR+Jr53ivddq=-15NQ@mail.gmail.com>
Subject: Re: [PATCH 03/10] btrfs: Remove unused variable
To: Nikolay Borisov <nborisov@suse.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Reviewed-by: Timofey Titovets <nefelim4ag@gmail.com>

2017-08-21 12:43 GMT+03:00 Nikolay Borisov <nborisov@suse.com>:
> Src was initially part of 31ff1cd25d37 ("Btrfs: Copy into the log tree in
> big batches"), however 16e7549f045d ("Btrfs: incompatible format change to remove hole extents") changed parameters passed to copy_items which made the src
> variable redundant.
>
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/tree-log.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index ad7f4bab640b..cb29528a8bba 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -2740,7 +2740,7 @@ static inline void btrfs_remove_log_ctx(struct btrfs_root *root,
>         mutex_unlock(&root->log_mutex);
>  }
>
> -/*
> +/*
>   * Invoked in log mutex context, or be sure there is no other task which
>   * can access the list.
>   */
> @@ -4637,7 +4637,6 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
>         struct btrfs_key min_key;
>         struct btrfs_key max_key;
>         struct btrfs_root *log = root->log_root;
> -       struct extent_buffer *src = NULL;
>         LIST_HEAD(logged_list);
>         u64 last_extent = 0;
>         int err = 0;
> @@ -4880,7 +4879,6 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
>                         goto next_slot;
>                 }
>
> -               src = path->nodes[0];
>                 if (ins_nr && ins_start_slot + ins_nr == path->slots[0]) {
>                         ins_nr++;
>                         goto next_slot;
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Have a nice day,
Timofey.
