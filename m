Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33495 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751814AbdHUKvI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Aug 2017 06:51:08 -0400
MIME-Version: 1.0
In-Reply-To: <31e6e888-586c-3480-7d57-dbf96989a26c@users.sourceforge.net>
References: <360126ba-e45b-0a8d-57b6-83764c4c2bce@users.sourceforge.net> <31e6e888-586c-3480-7d57-dbf96989a26c@users.sourceforge.net>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Mon, 21 Aug 2017 13:50:27 +0300
Message-ID: <CAGqmi75EiV4nX+QCv0GR9wRbjNS5d7UernMSBdHEVsA+ubGBaQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] btrfs: Delete an unnecessary variable initialisation
 in tree_mod_log_eb_copy()
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Don't needed, and you did miss several similar places (L573 & L895) in
that file with explicit initialisation.

Reviewed-by: Timofey Titovets <nefelim4ag@gmail.com>

2017-08-20 23:20 GMT+03:00 SF Markus Elfring <elfring@users.sourceforge.net>:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sun, 20 Aug 2017 22:02:54 +0200
>
> The variable "tm_list" will eventually be set to an appropriate pointer
> a bit later. Thus omit the explicit initialisation at the beginning.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  fs/btrfs/ctree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 3b49f39eaaf6..78387f5be0ce 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -801,7 +801,7 @@ tree_mod_log_eb_copy(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
>                      unsigned long src_offset, int nr_items)
>  {
>         int ret = 0;
> -       struct tree_mod_elem **tm_list = NULL;
> +       struct tree_mod_elem **tm_list;
>         struct tree_mod_elem **tm_list_add, **tm_list_rem;
>         int i;
>         int locked = 0;
> --
> 2.14.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Have a nice day,
Timofey.
