Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f193.google.com ([209.85.214.193]:35964 "EHLO
	mail-ob0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537AbcECXO2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 May 2016 19:14:28 -0400
Received: by mail-ob0-f193.google.com with SMTP id ds10so1484122obb.3
        for <linux-btrfs@vger.kernel.org>; Tue, 03 May 2016 16:14:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1462230062-8053-1-git-send-email-bo.li.liu@oracle.com>
References: <1462230062-8053-1-git-send-email-bo.li.liu@oracle.com>
Date: Wed, 4 May 2016 01:14:27 +0200
Message-ID: <CAHji150s7Ha05biMeNyMSuBRh7eMxj5SR7ezck2D2-PfJTL=WQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix unexpected balance crash due to BUG_ON
From: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?=
	<holger.hoffstaette@googlemail.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, master.b.at.raven@chefmail.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 3, 2016 at 1:01 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> Mounting a btrfs can resume previous balance operations asynchronously.
> An user got a crash when one drive has some corrupt sectors.
>
> Since balance can cancel itself in case of any error, we can gracefully
> return errors to upper layers and let balance do the cancel job.
>
> Reported-by: sash <master.b.at.raven@chefmail.de>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/volumes.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index bd0f45f..5aed2e2 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3418,13 +3418,25 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
>                 ret = btrfs_shrink_device(device, old_size - size_to_free);
>                 if (ret == -ENOSPC)
>                         break;
> -               BUG_ON(ret);
> +               if (ret) {
> +                       /* btrfs_shrink_device never returns ret > 0 */
> +                       WARN_ON_ONCE(ret > 0);
> +                       goto error;
> +               }
>
>                 trans = btrfs_start_transaction(dev_root, 0);
> -               BUG_ON(IS_ERR(trans));
> +               if (IS_ERR(trans)) {
> +                       ret = PTR_ERR(trans);
> +                       goto error;
> +               }
>
>                 ret = btrfs_grow_device(trans, device, old_size);
> -               BUG_ON(ret);
> +               if (ret) {
> +                       btrfs_end_transaction(trans, dev_root);
> +                       /* btrfs_grow_device never returns ret > 0 */
> +                       WARN_ON_ONCE(ret > 0);
> +                       goto error;
> +               }
>
>                 btrfs_end_transaction(trans, dev_root);
>         }

Just a heads up that this seems to introduce a valid warning, since it now
can goto error before the first initializing use of path:

fs/btrfs/volumes.c: In function 'btrfs_balance':
fs/btrfs/volumes.c:3601:2: warning: 'path' may be used uninitialized
in this function [-Wmaybe-uninitialized]
  btrfs_free_path(path);
  ^
fs/btrfs/volumes.c:3385:21: note: 'path' was declared here
  struct btrfs_path *path;
                     ^
(it's really in __btrfs_balance which got inlined, so gcc thinks it's
at the call site).

Simply setting path = NULL at the beginning of __btrfs_balance fixes it, since
btrfs_free_path allows NULL values.

cheers
Holger
