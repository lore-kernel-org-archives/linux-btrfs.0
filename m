Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f170.google.com ([209.85.210.170]:58724 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab3BZAgL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 19:36:11 -0500
Received: by mail-ia0-f170.google.com with SMTP id k20so3062780iak.29
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2013 16:36:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1361832890-40921-15-git-send-email-sandeen@redhat.com>
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
	<1361832890-40921-15-git-send-email-sandeen@redhat.com>
Date: Tue, 26 Feb 2013 08:36:11 +0800
Message-ID: <CAP9B-QkUP7ZftFkWw-_W-K2YKT8KdymabTf2mEK8Z_mgiKaJnA@mail.gmail.com>
Subject: Re: [PATCH 14/17] btrfs-progs: fix mem leak in resolve_root
From: Shilong Wang <wangshilong1991@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, Eric

2013/2/26 Eric Sandeen <sandeen@redhat.com>:
> If we exit with error we must free the allocated memory
> to avoid a leak.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  btrfs-list.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/btrfs-list.c b/btrfs-list.c
> index 851c059..8c3f84d 100644
> --- a/btrfs-list.c
> +++ b/btrfs-list.c
> @@ -568,8 +568,10 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri,
>                 * ref_tree = 0 indicates the subvolumes
>                 * has been deleted.
>                 */
> -               if (!found->ref_tree)
> +               if (!found->ref_tree) {
> +                       free(full_path);
>                         return -ENOENT;
> +               }
>                 int add_len = strlen(found->path);
>
>                 /* room for / and for null */
> @@ -612,8 +614,10 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri,
>                 * subvolume was deleted.
>                 */
>                 found = root_tree_search(rl, next);
> -               if (!found)
> +               if (!found) {
> +                       free(full_path);
>                         return -ENOENT;
> +               }
>         }
>
>         ri->full_path = full_path;
> --
> 1.7.1

I think the patch is wrong;
Here we return ENOENT, it means a subvolume/snapshot deletion happens.
We just filter them in the filter_root, But the free work is done by
the function all_subvolume_free..
so your modification will cause a double free..

Thanks,
Wang

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
