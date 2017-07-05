Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:33193 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752212AbdGEAoo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Jul 2017 20:44:44 -0400
MIME-Version: 1.0
In-Reply-To: <20170705000209.11391-1-rgoldwyn@suse.de>
References: <20170705000209.11391-1-rgoldwyn@suse.de>
From: Marc Dionne <marc.c.dionne@gmail.com>
Date: Tue, 4 Jul 2017 21:44:42 -0300
Message-ID: <CAB9dFdvCasRcYCFYQ+RDz59fAG_mQdC+4Z-zhp5q7eMqe9=uCQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: Correct assignment of pos
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
        markus@trippelsdorf.de,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        axboe@kernel.dk, dsterba@suse.com,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 4, 2017 at 9:02 PM, Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>
> Assigning pos for usage early messes up in append mode, where
> the pos is re-assigned in generic_write_checks(). Re-assign
> pos to get the correct position to write from iocb->ki_pos.
>
> Fixes: edf064e7c6fe ("btrfs: nowait aio support")
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Tested-by: Markus Trippelsdorf <markus@trippelsdorf.de>
> ---
>  fs/btrfs/file.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 59e2dccdf75b..7947781229e5 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1931,6 +1931,7 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
>          */
>         update_time_for_write(inode);
>
> +       pos = iocb->ki_pos;
>         start_pos = round_down(pos, fs_info->sectorsize);
>         oldsize = i_size_read(inode);
>         if (start_pos > oldsize) {
> --
> 2.12.0

For an append, shouldn't you also be using this updated pos from
generic_write_checks when calling check_can_nocow at the top of the
function?

Marc
