Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:38344 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbbJTO4u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Oct 2015 10:56:50 -0400
Received: by igbdj2 with SMTP id dj2so16131842igb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2015 07:56:50 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CAGqmi76ZKv3ezguTyxGL_Jv_xtq5w_SGPvjwTy90Z=oNY73Vmw@mail.gmail.com>
References: <CAGqmi76ZKv3ezguTyxGL_Jv_xtq5w_SGPvjwTy90Z=oNY73Vmw@mail.gmail.com>
Date: Tue, 20 Oct 2015 15:56:49 +0100
Message-ID: <CAL3q7H5_FRKOaYwKA7rqCzU3ee_QaUJJ88X+FOhDp9do_zCiHA@mail.gmail.com>
Subject: Re: [RFC PATCH] btrfs/ioctl.c: Prefer inode with lowest offset as
 source for clone
From: Filipe Manana <fdmanana@gmail.com>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 20, 2015 at 2:29 PM, Timofey Titovets <nefelim4ag@gmail.com> wrote:
> For performance reason, leave data at the start of disk, is preferable
> while deduping

Have you made any performance tests to verify that?

> It's might sense for the reasons:
> 1. Spinning rust - start of the disk is much faster
> 2. Btrfs can deallocate empty data chunk from the end of fs - ie it's compact fs

I don't see why that makes sense. First the clone/extent_same ioctls
don't copy data, they just update metadata of the destination inode to
point to the same extents as the source inode, secondly, just because
an offset of a file is lower the offset of the other file, it doesn't
mean the physical (on disk) offset of the first file is lower than
that of the other file...

>
> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> ---
>  fs/btrfs/ioctl.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 3e3e613..3eb77c0 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3074,8 +3074,13 @@ static int btrfs_extent_same(struct inode *src,
> u64 loff, u64 olen,
>
>   /* pass original length for comparison so we stay within i_size */
>   ret = btrfs_cmp_data(src, loff, dst, dst_loff, olen, &cmp);
> - if (ret == 0)
> -     ret = btrfs_clone(src, dst, loff, olen, len, dst_loff, 1);
> + if (ret == 0) {
> +     /* prefer inode with lowest offset as source for clone*/
> +     if (loff > dest_loff)
> +         ret = btrfs_clone(dst, src, dst_loff, olen, len, loff, 1);
> +     else
> +         ret = btrfs_clone(src, dst, loff, olen, len, dst_loff, 1);
> + }
>
>   if (same_inode)
>   unlock_extent(&BTRFS_I(src)->io_tree, same_lock_start,
> --
> 2.6.1



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
