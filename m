Return-Path: <SRS0=2FmH=P5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2C6AC31680
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Jan 2019 19:07:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A128220989
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Jan 2019 19:07:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zadara-com.20150623.gappssmtp.com header.i=@zadara-com.20150623.gappssmtp.com header.b="vTxaA5dq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbfAUTHN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 21 Jan 2019 14:07:13 -0500
Received: from mail-it1-f195.google.com ([209.85.166.195]:53102 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727152AbfAUTHN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Jan 2019 14:07:13 -0500
Received: by mail-it1-f195.google.com with SMTP id g76so17910728itg.2
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Jan 2019 11:07:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zadara-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sIYKIp7oez3lLWstyqGbnftAp1BQRKplQ/N4g+C/bB8=;
        b=vTxaA5dqx3SIZw83rIfCcBDpvrxdEXOuLt26q+l+b660Nz4vrkJ/zCH1x7GrxOsMsY
         Fy95meMsd5qutkh4zcCZHPRFe5x8e6Z25kgSNQQZoSwBjFDj4eiCWAfHzm36Z/CxYvjc
         5oc2t015UhM+dXgJeUqaziJDTQWx9heLtJQ8+Vrjpo3smcRLkQqNx4SpjO6O9KcsZosw
         u+q+QHkrZc0jatz1xI3qUoDf9H0fl+J5E/B9nXirlRq+ecy2RMUNoD7KBhL05a6qnUO1
         lWGcXwpCCHdwlfTlRE8A+gjHjhRIjqAY7Mnnla3sb1GlRZ3DTMZIRQiSc6jgibJTfqyb
         YIxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sIYKIp7oez3lLWstyqGbnftAp1BQRKplQ/N4g+C/bB8=;
        b=aEUeyGnNI8i0zIKNjedrhtC6d8q2M5e6srVJ5ptk+kz9oo1lwCEK994wHOf2O9SvZq
         +5xhmzq95OawC/Y5QzKvBMMfHIwUTijxw4CBg4JIuzPR1RJnO5t3tQicSZwrX4ILsWhE
         Rf00nulsPgzlmIcqojG3F1aVXOAhxLvv8TTM/fX4EfM+89YO4k+QbYjWvwwvogZsVMjr
         PdRGrbjDgguUWzeduMhfQMyxnhOvC2gq4NUSfhsq7fUUx+zHeNYWcCtXjjitcHMgmNCh
         RBhOeXCRhznK1Su7Z4Sc2RZWjLbiCOCGcmrkOxJlnjizfJXksctpbCotr70DmR3oj0Rw
         f62g==
X-Gm-Message-State: AJcUukcpsEtmmDdJO5WX+vTDnzVP06AfC85JovZ05EnZ9nKu3bDF8x36
        NBK0TFfE8YNQlTR5IMxHcvevDxKmUvBp4HyUxDoZuQ==
X-Google-Smtp-Source: AHgI3Ib6bUVvpcGoVUcwmUVfiLu1VIjaX6GkBh9rCW4d+UMMHKPpDHuJfrnGT1hCpAK/7uejR+LgHN5AW5sEXLJ3wz0=
X-Received: by 2002:a24:5a11:: with SMTP id v17mr437883ita.114.1548097632265;
 Mon, 21 Jan 2019 11:07:12 -0800 (PST)
MIME-Version: 1.0
References: <1417543669-22685-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1417543669-22685-1-git-send-email-fdmanana@suse.com>
From:   Alex Lyakas <alex@zadara.com>
Date:   Mon, 21 Jan 2019 21:07:02 +0200
Message-ID: <CAOcd+r3U9x20gAsrOtDC1pd1qO-Zy_QiWrmQysvKjbLJOUDH_A@mail.gmail.com>
Subject: Re: [PATCH 2/2] Btrfs: fix unprotected deletion from pending_chunks list
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Filipe,

On Tue, Dec 2, 2014 at 8:08 PM Filipe Manana <fdmanana@suse.com> wrote:
>
> On block group remove if the corresponding extent map was on the
> transaction->pending_chunks list, we were deleting the extent map
> from that list, through remove_extent_mapping(), without any
> synchronization with chunk allocation (which iterates that list
> and adds new elements to it). Fix this by ensure that this is done
> while the chunk mutex is held, since that's the mutex that protects
> the list in the chunk allocation code path.
>
> This applies on top (depends on) of my previous patch titled:
> "Btrfs: fix race between fs trimming and block group remove/allocation"
>
> But the issue in fact was already present before that change, it only
> became easier to hit after Josef's 3.18 patch that added automatic
> removal of empty block groups.
>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 17d429d..a7b81b4 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -9524,19 +9524,25 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
>                 list_move_tail(&em->list, &root->fs_info->pinned_chunks);
>         }
>         spin_unlock(&block_group->lock);
> -       unlock_chunks(root);
>
>         if (remove_em) {
>                 struct extent_map_tree *em_tree;
>
>                 em_tree = &root->fs_info->mapping_tree.map_tree;
>                 write_lock(&em_tree->lock);
> +               /*
> +                * The em might be in the pending_chunks list, so make sure the
> +                * chunk mutex is locked, since remove_extent_mapping() will
> +                * delete us from that list.
> +                */
>                 remove_extent_mapping(em_tree, em);
>                 write_unlock(&em_tree->lock);
If the "em" was in pending_chunks, it will be deleted from that list
by "remove_extent_mapping". But it looks like in this case we also
need to drop the extra ref on "em", which was held by pending_chunks
list. I don't see it being done anywhere else. So we should check
before the remove_extent_mapping() call whether "em" was in
pending_chunks, and, if yes, drop the extra ref?

Thanks,
Alex.


>                 /* once for the tree */
>                 free_extent_map(em);
>         }
>
> +       unlock_chunks(root);
> +
>         btrfs_put_block_group(block_group);
>         btrfs_put_block_group(block_group);
>
> --
> 2.1.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
