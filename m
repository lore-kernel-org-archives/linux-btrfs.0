Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:64842 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaHKAKH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Aug 2014 20:10:07 -0400
Received: by mail-la0-f48.google.com with SMTP id gl10so6229274lab.35
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Aug 2014 17:10:06 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <8uvx1msa7pjsyoq758f3sw4x.1407714728203@email.android.com>
References: <1407716706-5115-1-git-send-email-fdmanana@suse.com>
	<8uvx1msa7pjsyoq758f3sw4x.1407714728203@email.android.com>
Date: Mon, 11 Aug 2014 01:10:05 +0100
Message-ID: <CAL3q7H5qqznNN3TPPY1rnYrxPp2NVVvRnb8YamugA6RqeD_qig@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: send, lower mem requirements for processing xattrs
From: Filipe David Manana <fdmanana@gmail.com>
To: Josef Bacik <jbacik@fb.com>
Cc: Filipe Manana <fdmanana@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "lists@colorremedies.com" <lists@colorremedies.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 11, 2014 at 12:52 AM, Josef Bacik <jbacik@fb.com> wrote:
> Sigh I can only top post from my phone.  Instead of using contig_bug just use is_vmalloc_addr.  Thanks,

Thanks Josef, I wasn't aware of that helper function.

>
> Josef
>
> Filipe Manana <fdmanana@suse.com> wrote:
>
>
> Maximum xattr size can be up to nearly the leaf size. For an fs with a
> leaf size larger than the page size, using kmalloc requires allocating
> multiple pages that are contiguous, which might not be possible if
> there's heavy memory fragmentation. Therefore fallback to vmalloc if
> we fail to allocate with kmalloc. Also start with a smaller buffer size,
> since xattr values typically are smaller than a page.
>
> Reported-by: Chris Murphy <lists@colorremedies.com>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/send.c | 41 +++++++++++++++++++++++++++++++++--------
>  1 file changed, 33 insertions(+), 8 deletions(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 3c63b29..215064d 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -997,6 +997,7 @@ static int iterate_dir_item(struct btrfs_root *root, struct btrfs_path *path,
>         struct btrfs_key di_key;
>         char *buf = NULL;
>         int buf_len;
> +       bool contig_buf;
>         u32 name_len;
>         u32 data_len;
>         u32 cur;
> @@ -1006,11 +1007,13 @@ static int iterate_dir_item(struct btrfs_root *root, struct btrfs_path *path,
>         int num;
>         u8 type;
>
> -       if (found_key->type == BTRFS_XATTR_ITEM_KEY)
> -               buf_len = BTRFS_MAX_XATTR_SIZE(root);
> -       else
> -               buf_len = PATH_MAX;
> -
> +       /*
> +        * Start with a small buffer (1 page). If later we end up needing more
> +        * space, which can happen for xattrs on a fs with a leaf size > 4Kb,
> +        * attempt to increase the buffer. Typically xattr values are small.
> +        */
> +       buf_len = PATH_MAX;
> +       contig_buf = true;
>         buf = kmalloc(buf_len, GFP_NOFS);
>         if (!buf) {
>                 ret = -ENOMEM;
> @@ -1037,7 +1040,7 @@ static int iterate_dir_item(struct btrfs_root *root, struct btrfs_path *path,
>                                 ret = -ENAMETOOLONG;
>                                 goto out;
>                         }
> -                       if (name_len + data_len > buf_len) {
> +                       if (name_len + data_len > BTRFS_MAX_XATTR_SIZE(root)) {
>                                 ret = -E2BIG;
>                                 goto out;
>                         }
> @@ -1045,12 +1048,31 @@ static int iterate_dir_item(struct btrfs_root *root, struct btrfs_path *path,
>                         /*
>                          * Path too long
>                          */
> -                       if (name_len + data_len > buf_len) {
> +                       if (name_len + data_len > PATH_MAX) {
>                                 ret = -ENAMETOOLONG;
>                                 goto out;
>                         }
>                 }
>
> +               if (name_len + data_len > buf_len) {
> +                       if (contig_buf)
> +                               kfree(buf);
> +                       else
> +                               vfree(buf);
> +                       buf = NULL;
> +                       buf_len = name_len + data_len;
> +                       if (contig_buf)
> +                               buf = kmalloc(buf_len, GFP_NOFS);
> +                       if (!buf) {
> +                               buf = vmalloc(buf_len);
> +                               if (!buf) {
> +                                       ret = -ENOMEM;
> +                                       goto out;
> +                               }
> +                               contig_buf = false;
> +                       }
> +               }
> +
>                 read_extent_buffer(eb, buf, (unsigned long)(di + 1),
>                                 name_len + data_len);
>
> @@ -1071,7 +1093,10 @@ static int iterate_dir_item(struct btrfs_root *root, struct btrfs_path *path,
>         }
>
>  out:
> -       kfree(buf);
> +       if (contig_buf)
> +               kfree(buf);
> +       else
> +               vfree(buf);
>         return ret;
>  }
>
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v1/url?u=http://vger.kernel.org/majordomo-info.html&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=0g6WGYzRdvDGTNBGE%2B9Cc6zaQIOCx8CwbRFIJFgZcAM%3D%0A&s=cd46d14d0b643be3734a57e10521a9ccd5b5ec3732bb96b6f83da18df6a44c98
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
