Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:35418 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922AbcBAMF7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Feb 2016 07:05:59 -0500
Received: by mail-io0-f181.google.com with SMTP id d63so137254604ioj.2
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Feb 2016 04:05:58 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20160201115350.GA9678@googlemail.com>
References: <20160201115350.GA9678@googlemail.com>
Date: Mon, 1 Feb 2016 12:05:58 +0000
Message-ID: <CAL3q7H4geSgrD21TFci6Z3BsVmCyFYXXiXq0eTqJVi4iFkwVkQ@mail.gmail.com>
Subject: Re: [PATCH] fs: btrfs: fixes a pass by reference issue in send.c
From: Filipe Manana <fdmanana@gmail.com>
To: Ben Marsh <bmarsh94@gmail.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 1, 2016 at 11:53 AM, Ben Marsh <bmarsh94@gmail.com> wrote:
> This patch fixes a pointer issue from passing a struct as a parameter
> to the function btrfs_root_dec_send_in_progress.
>
> Signed-off-by: Ben Marsh <bmarsh94@gmail.com>
> ---
>  fs/btrfs/send.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 63a6152..47ee63e 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -5911,7 +5911,7 @@ commit_trans:
>         return btrfs_commit_transaction(trans, sctx->send_root);
>  }
>
> -static void btrfs_root_dec_send_in_progress(struct btrfs_root* root)
> +static void btrfs_root_dec_send_in_progress(struct btrfs_root *root)

It's a white space change. Both forms are equivalent and pass the root
by reference.
IOW, you aren't fixing any problem.

>  {
>         spin_lock(&root->root_item_lock);
>         root->send_in_progress--;
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
