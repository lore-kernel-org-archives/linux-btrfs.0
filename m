Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:63835 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593Ab3GDPzW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jul 2013 11:55:22 -0400
Received: by mail-bk0-f42.google.com with SMTP id jk13so727498bkc.15
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Jul 2013 08:55:21 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1372952919-21010-1-git-send-email-fdmanana@gmail.com>
References: <1372869173-15043-1-git-send-email-fdmanana@gmail.com>
	<1372952919-21010-1-git-send-email-fdmanana@gmail.com>
Date: Thu, 4 Jul 2013 16:55:21 +0100
Message-ID: <CAL3q7H5p9VgK5Qw60=q_sF-zzKYLj7MM3aUR8ea0gxg424h9Cg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs-progs: fix optimization in btrfs_lookup_extent_info
From: Filipe David Manana <fdmanana@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: Filipe David Borba Manana <fdmanana@gmail.com>, jbacik@fusionio.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 4, 2013 at 4:48 PM, Filipe David Borba Manana
<fdmanana@gmail.com> wrote:
> If we did a tree search with the goal to find a metadata item
> but the search failed with return value 1, we attempt to see
> if in the same leaf there's a corresponding extent item, and if
> there's one, just use it instead of doing another tree search
> for this extent item. The check in the leaf was wrong because
> it was seeking for a metadata item instead of an extent item.
>
> This optimization was also being triggered incorrectly, as it
> was evaluating path->slots which always evaluates to true. The
> goal was to see if the leaf level slot was greater than zero
> (i.e. not the first item in the leaf).
>
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>  extent-tree.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/extent-tree.c b/extent-tree.c
> index b0cfe0a..22e6247 100644
> --- a/extent-tree.c
> +++ b/extent-tree.c
> @@ -1515,12 +1515,13 @@ again:
>          * to make sure.
>          */
>         if (ret > 0 && metadata) {
> -               if (path->slots) {
> +               if (path->slots[0]) {
>                         path->slots[0]--;
>                         btrfs_item_key_to_cpu(path->nodes[0], &key,
>                                               path->slots[0]);
>                         if (key.objectid == bytenr &&
> -                           key.type == BTRFS_METADATA_ITEM_KEY)
> +                           key.type == BTRFS_EXTENT_ITEM_KEY &&
> +                           key.offset == root->leafsize)
>                                 ret = 0;
>                 }
>
> --
> 1.7.9.5
>

Josef, since git suggests you are the author of this code piece, can
you please review this and comment?
Thanks.




--
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
