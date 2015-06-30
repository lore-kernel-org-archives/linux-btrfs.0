Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:33467 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbbF3IV2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jun 2015 04:21:28 -0400
Received: by igcur8 with SMTP id ur8so57517745igc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2015 01:21:27 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1434531598-8607-2-git-send-email-bo.li.liu@oracle.com>
References: <1434531598-8607-1-git-send-email-bo.li.liu@oracle.com>
	<1434531598-8607-2-git-send-email-bo.li.liu@oracle.com>
Date: Tue, 30 Jun 2015 09:21:27 +0100
Message-ID: <CAL3q7H5V3v-9AMMwafW7HOdHsMmoRaJcACjXt1J4RjVMxMt2+w@mail.gmail.com>
Subject: Re: [PATCH 2/2] Btrfs: fix warning of bytes_may_use
From: Filipe David Manana <fdmanana@gmail.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 17, 2015 at 9:59 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> While running generic/019, dmesg got several warnings from
> btrfs_free_reserved_data_space().
>
> Test generic/019 produces some disk failures so sumbit dio will get errors,
> in which case, btrfs_direct_IO() goes to the error handling and free
> bytes_may_use, but the problem is that bytes_may_use has been free'd
> during get_block().
>
> This adds a runtime flag to show if we've gone through get_block(), if so,
> don't do the cleanup work.
>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Tested-by: Filipe Manana <fdmanana@suse.com>

> ---
>  fs/btrfs/btrfs_inode.h |  2 ++
>  fs/btrfs/inode.c       | 16 +++++++++++++---
>  2 files changed, 15 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 0ef5cc1..81220b2 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -44,6 +44,8 @@
>  #define BTRFS_INODE_IN_DELALLOC_LIST           9
>  #define BTRFS_INODE_READDIO_NEED_LOCK          10
>  #define BTRFS_INODE_HAS_PROPS                  11
> +/* DIO is ready to submit */
> +#define BTRFS_INODE_DIO_READY                  12
>  /*
>   * The following 3 bits are meant only for the btree inode.
>   * When any of them is set, it means an error happened while writing an
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 7bf150a..438b56f 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7530,6 +7530,7 @@ unlock:
>
>                 current->journal_info = outstanding_extents;
>                 btrfs_free_reserved_data_space(inode, len);
> +               set_bit(BTRFS_INODE_DIO_READY, &BTRFS_I(inode)->runtime_flags);
>         }
>
>         /*
> @@ -8311,9 +8312,18 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
>                                    btrfs_submit_direct, flags);
>         if (iov_iter_rw(iter) == WRITE) {
>                 current->journal_info = NULL;
> -               if (ret < 0 && ret != -EIOCBQUEUED)
> -                       btrfs_delalloc_release_space(inode, count);
> -               else if (ret >= 0 && (size_t)ret < count)
> +               if (ret < 0 && ret != -EIOCBQUEUED) {
> +                       /*
> +                        * If the error comes from submitting stage,
> +                        * btrfs_get_blocsk_direct() has free'd data space,
> +                        * and metadata space will be handled by
> +                        * finish_ordered_fn, don't do that again to make
> +                        * sure bytes_may_use is correct.
> +                        */
> +                       if (!test_and_clear_bit(BTRFS_INODE_DIO_READY,
> +                                    &BTRFS_I(inode)->runtime_flags))
> +                               btrfs_delalloc_release_space(inode, count);
> +               } else if (ret >= 0 && (size_t)ret < count)
>                         btrfs_delalloc_release_space(inode,
>                                                      count - (size_t)ret);
>         }
> --
> 2.1.0
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
