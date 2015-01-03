Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f45.google.com ([209.85.213.45]:49427 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbbACCJ2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Jan 2015 21:09:28 -0500
Received: by mail-yh0-f45.google.com with SMTP id f10so9311401yha.32
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Jan 2015 18:09:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1420156114-10849-1-git-send-email-khaled.gnu@gmail.com>
References: <1420156114-10849-1-git-send-email-khaled.gnu@gmail.com>
Date: Sat, 3 Jan 2015 10:09:28 +0800
Message-ID: <CA+qeAOqzm14gGx4R5Bc-+hZkyRmTPq_jST+Ke0AyszSD0inHZg@mail.gmail.com>
Subject: Re: [PATCH] Fixing quota error when removing files from a limit
 exceeded subvols
From: Dongsheng Yang <dongsheng081251@gmail.com>
To: Khaled Ahmed <khaled.gnu@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Khaled,

Could you give use more description about the problem this patch
is trying to solve? Maybe an example will help a lot to understand it.

Thanx

On Fri, Jan 2, 2015 at 7:48 AM, Khaled Ahmed <khaled.gnu@gmail.com> wrote:
> Signed-off-by: Khaled Ahmed <khaled.gnu@gmail.com>
> ---
>  fs/btrfs/qgroup.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 48b60db..b85200d 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2408,14 +2408,14 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
>
>                 if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
>                     qg->reserved + (s64)qg->rfer + num_bytes >
> -                   qg->max_rfer) {
> +                   qg->max_rfer - 1 ) {
>                         ret = -EDQUOT;
>                         goto out;
>                 }
>
>                 if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL) &&
>                     qg->reserved + (s64)qg->excl + num_bytes >
> -                   qg->max_excl) {
> +                   qg->max_excl - 1) {
>                         ret = -EDQUOT;
>                         goto out;
>                 }
> --
> 2.1.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
