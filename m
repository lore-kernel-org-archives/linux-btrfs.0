Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:51008 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619AbaIWOgU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Sep 2014 10:36:20 -0400
Received: by mail-la0-f46.google.com with SMTP id q1so8367441lam.33
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Sep 2014 07:36:18 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1411482153-14416-1-git-send-email-bo.li.liu@oracle.com>
References: <1411482153-14416-1-git-send-email-bo.li.liu@oracle.com>
Date: Tue, 23 Sep 2014 15:36:18 +0100
Message-ID: <CAL3q7H6t3zA8xUzur7Qzqrk-NndVLUb58u8Ddd+hwSvJy7x0JA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix crash of btrfs_release_extent_buffer_page
From: Filipe David Manana <fdmanana@gmail.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 23, 2014 at 3:22 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> This is actually inspired by Filipe's patch.  When write_one_eb() fails on
> submit_extent_page(), it'll give up writing this eb and mark it with
> EXTENT_BUFFER_IOERR.  So if it's not the last page that encounter the failure,
> there are some left pages which remain DIRTY, and if a later COW on this eb
> happens, ie. eb is COWed and freed, it'd run into BUG_ON in
> btrfs_release_extent_buffer_page() for the DIRTY page, ie. BUG_ON(PageDirty(page));
>
> This adds the missing clear_page_dirty_for_io() for the rest pages of eb.
>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Looks good.
Thanks.

Reviewed-by: Filipe Manana <fdmanana@suse.com>

> ---
>  fs/btrfs/extent_io.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index af0359d..e68a1d9 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3597,6 +3597,7 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
>         if (unlikely(ret)) {
>                 for (; i < num_pages; i++) {
>                         struct page *p = extent_buffer_page(eb, i);
> +                       clear_page_dirty_for_io(p);
>                         unlock_page(p);
>                 }
>         }
> --
> 1.8.1.4
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
