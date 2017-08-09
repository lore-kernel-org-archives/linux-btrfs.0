Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:35115 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751443AbdHIRfs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Aug 2017 13:35:48 -0400
Received: by mail-it0-f67.google.com with SMTP id 76so167214ith.2
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Aug 2017 10:35:47 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20170809163114.19539-1-bo.li.liu@oracle.com>
References: <20170807193903.9093-1-bo.li.liu@oracle.com> <20170809163114.19539-1-bo.li.liu@oracle.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Wed, 9 Aug 2017 18:35:46 +0100
Message-ID: <CAL3q7H7bNGQOz5eF_T=A+omSgWOe3ZHRJm3xPkN_oyCCuBduqw@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: fix out of bounds array access while reading
 extent buffer
To: Liu Bo <bo.li.liu@oracle.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 9, 2017 at 5:31 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> There is a cornel case that slip through the checkers in functions
> reading extent buffer, ie.
>
> if (start < eb->len) and (start + len > eb->len),
> then
>
> a) map_private_extent_buffer() returns immediately because
> it's thinking the range spans across two pages,
>
> b) and the checkers in read_extent_buffer(), WARN_ON(start > eb->len)
> and WARN_ON(start + len > eb->start + eb->len), both are OK in this
> corner case, but it'd actually try to access the eb->pages out of
> bounds because of (start + len > eb->len).
>
> The case is found by switching extent inline ref type from shared data
> ref to non-shared data ref, which is a kind of metadata corruption.
>
> It'd use the wrong helper to access the eb,
> eg. btrfs_extent_data_ref_root(eb, ref) is used but the %ref passing
> here is "struct btrfs_shared_data_ref".  And if the extent item
> happens to be the first item in the eb, then offset/length will get
> over eb->len which ends up an invalid memory access.
>
> This is adding proper checks in order to avoid invalid memory access,
> ie. 'general protection fault', before it's too late.
>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>

> ---
>
> v2: Improve the commit log to clarify that this can only happen if
> metadata is corrupted.

Thanks for adding the clarification!

>
>  fs/btrfs/extent_io.c | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
>
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 0aff9b2..d198e87 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -5416,13 +5416,19 @@ void read_extent_buffer(struct extent_buffer *eb, void *dstv,
>         char *dst = (char *)dstv;
>         size_t start_offset = eb->start & ((u64)PAGE_SIZE - 1);
>         unsigned long i = (start_offset + start) >> PAGE_SHIFT;
> +       unsigned long num_pages = num_extent_pages(eb->start, eb->len);
>
> -       WARN_ON(start > eb->len);
> -       WARN_ON(start + len > eb->start + eb->len);
> +       if (start + len > eb->len) {
> +               WARN(1, KERN_ERR "btrfs bad mapping eb start %llu len %lu, wanted %lu %lu\n",
> +                    eb->start, eb->len, start, len);
> +               memset(dst, 0, len);
> +               return;
> +       }
>
>         offset = (start_offset + start) & (PAGE_SIZE - 1);
>
>         while (len > 0) {
> +               ASSERT(i < num_pages);
>                 page = eb->pages[i];
>
>                 cur = min(len, (PAGE_SIZE - offset));
> @@ -5491,6 +5497,12 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long start,
>         unsigned long end_i = (start_offset + start + min_len - 1) >>
>                 PAGE_SHIFT;
>
> +       if (start + min_len > eb->len) {
> +               WARN(1, KERN_ERR "btrfs bad mapping eb start %llu len %lu, wanted %lu %lu\n",
> +                      eb->start, eb->len, start, min_len);
> +               return -EINVAL;
> +       }
> +
>         if (i != end_i)
>                 return 1;
>
> @@ -5502,12 +5514,6 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long start,
>                 *map_start = ((u64)i << PAGE_SHIFT) - start_offset;
>         }
>
> -       if (start + min_len > eb->len) {
> -               WARN(1, KERN_ERR "btrfs bad mapping eb start %llu len %lu, wanted %lu %lu\n",
> -                      eb->start, eb->len, start, min_len);
> -               return -EINVAL;
> -       }
> -
>         p = eb->pages[i];
>         kaddr = page_address(p);
>         *map = kaddr + offset;
> --
> 2.9.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

“Whether you think you can, or you think you can't — you're right.”
