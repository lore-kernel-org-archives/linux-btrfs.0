Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:57586 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932080AbbLOThB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Dec 2015 14:37:01 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0982720382
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Dec 2015 19:37:00 +0000 (UTC)
Received: from mail-ig0-f179.google.com (mail-ig0-f179.google.com [209.85.213.179])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 87F37203C2
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Dec 2015 19:36:58 +0000 (UTC)
Received: by mail-ig0-f179.google.com with SMTP id to18so21821171igc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Dec 2015 11:36:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151215000324.GD3570@ret.masoncoding.com>
References: <20151209042528.GA2413@codemonkey.org.uk>
	<20151215000324.GD3570@ret.masoncoding.com>
Date: Tue, 15 Dec 2015 19:36:57 +0000
Message-ID: <CAL3q7H5g-T-B-CahkFwYY+=H2eEySGbajfbuoxcBJxVJceOv4g@mail.gmail.com>
Subject: Re: !PageLocked BUG_ON hit in clear_page_dirty_for_io
From: Filipe Manana <fdmanana@kernel.org>
To: Chris Mason <clm@fb.com>, Dave Jones <davej@codemonkey.org.uk>,
        Josef Bacik <jbacik@fb.com>, dsterba@suse.com,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 15, 2015 at 12:03 AM, Chris Mason <clm@fb.com> wrote:
> On Tue, Dec 08, 2015 at 11:25:28PM -0500, Dave Jones wrote:
>> Not sure if I've already reported this one, but I've been seeing this
>> a lot this last couple days.
>>
>> kernel BUG at mm/page-writeback.c:2654!
>> invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC KASAN
>
> We ended up discussing this in more detail on lkml, but I'll summarize
> here.
>
> There were two problems.  First lock_page() might not actually lock the
> page in v4.4-rc4, it can bail out if a signal is pending.  This got
> fixed just before v4.4-rc5, so if you were on rc4, upgrade asap.
>
> Second, prepare_pages had a bug for single page writes:
>
> From f0be89af049857bcc537a53fe2a2fae080e7a5bd Mon Sep 17 00:00:00 2001
> From: Chris Mason <clm@fb.com>
> Date: Mon, 14 Dec 2015 15:40:44 -0800
> Subject: [PATCH] Btrfs: check prepare_uptodate_page() error code earlier
>
> prepare_pages() may end up calling prepare_uptodate_page() twice if our
> write only spans a single page.  But if the first call returns an error,
> our page will be unlocked and its not safe to call it again.
>
> This bug goes all the way back to 2011, and it's not something commonly
> hit.
>
> While we're here, add a more explicit check for the page being truncated
> away.  The bare lock_page() alone is protected only by good thoughts and
> i_mutex, which we're sure to regret eventually.
>
> Reported-by: Dave Jones <dsj@fb.com>
> Signed-off-by: Chris Mason <clm@fb.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

> ---
>  fs/btrfs/file.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 72e7346..0f09526 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1291,7 +1291,8 @@ out:
>   * on error we return an unlocked page and the error value
>   * on success we return a locked page and 0
>   */
> -static int prepare_uptodate_page(struct page *page, u64 pos,
> +static int prepare_uptodate_page(struct inode *inode,
> +                                struct page *page, u64 pos,
>                                  bool force_uptodate)
>  {
>         int ret = 0;
> @@ -1306,6 +1307,10 @@ static int prepare_uptodate_page(struct page *page, u64 pos,
>                         unlock_page(page);
>                         return -EIO;
>                 }
> +               if (page->mapping != inode->i_mapping) {
> +                       unlock_page(page);
> +                       return -EAGAIN;
> +               }
>         }
>         return 0;
>  }
> @@ -1324,6 +1329,7 @@ static noinline int prepare_pages(struct inode *inode, struct page **pages,
>         int faili;
>
>         for (i = 0; i < num_pages; i++) {
> +again:
>                 pages[i] = find_or_create_page(inode->i_mapping, index + i,
>                                                mask | __GFP_WRITE);
>                 if (!pages[i]) {
> @@ -1333,13 +1339,17 @@ static noinline int prepare_pages(struct inode *inode, struct page **pages,
>                 }
>
>                 if (i == 0)
> -                       err = prepare_uptodate_page(pages[i], pos,
> +                       err = prepare_uptodate_page(inode, pages[i], pos,
>                                                     force_uptodate);
> -               if (i == num_pages - 1)
> -                       err = prepare_uptodate_page(pages[i],
> +               if (!err && i == num_pages - 1)
> +                       err = prepare_uptodate_page(inode, pages[i],
>                                                     pos + write_bytes, false);
>                 if (err) {
>                         page_cache_release(pages[i]);
> +                       if (err == -EAGAIN) {
> +                               err = 0;
> +                               goto again;
> +                       }
>                         faili = i - 1;
>                         goto fail;
>                 }
> --
> 2.4.6
>
