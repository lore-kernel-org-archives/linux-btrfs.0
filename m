Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:32960 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbbF3WZF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jun 2015 18:25:05 -0400
Received: by igcur8 with SMTP id ur8so76176835igc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2015 15:25:04 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <552A1228.4090700@gmail.com>
References: <552A1228.4090700@gmail.com>
Date: Tue, 30 Jun 2015 23:25:04 +0100
Message-ID: <CAL3q7H56kXw3KZ3bOkm71O1wGxxuWBsuZmM73XmSPGMAhp8haQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix wrong check for btrfs_force_chunk_alloc()
From: Filipe David Manana <fdmanana@gmail.com>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 12, 2015 at 7:35 AM, Wang Shilong <wangshilong1991@gmail.com> wrote:
> btrfs_force_chunk_alloc() return 1 for allocation chunk successfully.
> This problem exists since commit c87f08ca4.
>
> With this patch, we might fix some enospc problems for balances.
>
> Signed-off-by: Wang Shilong <wangshilong1991@gmail.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Tested-by: Filipe Manana <fdmanana@suse.com>

> ---
>  fs/btrfs/relocation.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index d830853..c453464 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -4037,7 +4037,7 @@ restart:
>         if (trans && progress && err == -ENOSPC) {
>                 ret = btrfs_force_chunk_alloc(trans, rc->extent_root,
>                                               rc->block_group->flags);
> -               if (ret == 0) {
> +               if (ret == 1) {
>                         err = 0;
>                         progress = 0;
>                         goto restart;
> --
> 1.7.12.4
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
