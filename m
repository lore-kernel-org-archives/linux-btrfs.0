Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:44099 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbaASO7D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Jan 2014 09:59:03 -0500
Received: by mail-wi0-f179.google.com with SMTP id hr1so2347225wib.6
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Jan 2014 06:59:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1375716312-26899-1-git-send-email-fdmanana@gmail.com>
References: <1375716312-26899-1-git-send-email-fdmanana@gmail.com>
Date: Sun, 19 Jan 2014 16:59:01 +0200
Message-ID: <CAOcd+r1F4uOteE=K8aLSrgC2f8VQaH2jC_vC8-gt0zx62hGmMg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: return ENOSPC when target space is full
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Filipe,
I think in the context of do_chunk_alloc(), 0 doesn't mean "success".
0 means "allocation was not attempted". While 1 means "allocation was
attempted and succeeded". -ENOSPC means "allocation was attempted but
failed". Any other errno deserves transaction abort.
Anyways, the callers are ok with "0" and -ENOSPC and re-search for a
free extent in these cases.

Alex.


On Mon, Aug 5, 2013 at 5:25 PM, Filipe David Borba Manana
<fdmanana@gmail.com> wrote:
> In extent-tree.c:do_chunk_alloc(), early on we returned 0 (success)
> when the target space was full and when chunk allocation is needed.
> However, later on in that same function we return ENOSPC if
> btrfs_alloc_chunk() fails (and chunk allocation was needed) and
> set the space's full flag.
>
> This was inconsistent, as -ENOSPC should be returned if the space
> is full and a chunk allocation needs to performed. If the space is
> full but no chunk allocation is needed, just return 0 (success).
>
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>  fs/btrfs/extent-tree.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index e868c35..ef89a66 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3829,8 +3829,12 @@ again:
>         if (force < space_info->force_alloc)
>                 force = space_info->force_alloc;
>         if (space_info->full) {
> +               if (should_alloc_chunk(extent_root, space_info, force))
> +                       ret = -ENOSPC;
> +               else
> +                       ret = 0;
>                 spin_unlock(&space_info->lock);
> -               return 0;
> +               return ret;
>         }
>
>         if (!should_alloc_chunk(extent_root, space_info, force)) {
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
