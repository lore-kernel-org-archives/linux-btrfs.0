Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53395 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932622AbcE0JvR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 May 2016 05:51:17 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CBF77203F7
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 09:51:15 +0000 (UTC)
Received: from mail-ig0-f177.google.com (mail-ig0-f177.google.com [209.85.213.177])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 86C5C203EC
	for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 09:51:13 +0000 (UTC)
Received: by mail-ig0-f177.google.com with SMTP id ct2so17370174igb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 02:51:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160526070608.10837-1-quwenruo@cn.fujitsu.com>
References: <20160526070608.10837-1-quwenruo@cn.fujitsu.com>
Date: Fri, 27 May 2016 10:51:12 +0100
Message-ID: <CAL3q7H7fkgx92gBp+q0uk=Ds_OQFt=P9D1zHy+W0i2sf43X0fg@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: Add debug warning for new block group reservations
From: Filipe Manana <fdmanana@kernel.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe David Borba Manana <fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 26, 2016 at 8:06 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> Since the we are using atomic and wait queue for block group
> reservations and it's not controlled by lockdep, we need pay much more
> attention to any modification to write path.
>
> Or it's very easy to under flow block group reservations and cause lock
> balance.

Ok, have you observed this happening in practice?

There's nothing wrong with adding this warning, but it makes me
curious why you do it only here, specially if you haven't experienced
a bug. That is, there are other places (some recent others not so
recent) where we use an atomic for waiting and waking up.

Also the patch subject "btrfs: Add debug warning for new block group
reservations" is very confusing. You meant to say something like "Add
warning when decrementing a block group's reservations counter".

thanks

>
> Add warning on for dec_block_group_reservations() if the reservations is
> already minus.
>
> Although such warning doesn't always catch the directly caller, but should
> provides good enough clue for later debug.
>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
> v2:
>    Fix compile error
>    Change to WARN_ON_ONCE(), as when it underflows, it will always under
>    flow
> ---
>  fs/btrfs/extent-tree.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 9424864..47ce96b 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -6243,6 +6243,7 @@ void btrfs_dec_block_group_reservations(struct btrfs_fs_info *fs_info,
>         ASSERT(bg);
>         if (atomic_dec_and_test(&bg->reservations))
>                 wake_up_atomic_t(&bg->reservations);
> +       WARN_ON_ONCE(atomic_read(&bg->reservations) < 0);
>         btrfs_put_block_group(bg);
>  }
>
> --
> 2.8.3
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
