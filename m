Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:33234 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbbDWGHb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 02:07:31 -0400
Received: by layy10 with SMTP id y10so5464499lay.0
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2015 23:07:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1429758045-27027-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1429758045-27027-1-git-send-email-quwenruo@cn.fujitsu.com>
From: Lukas Lueg <lukas.lueg@gmail.com>
Date: Thu, 23 Apr 2015 08:07:09 +0200
Message-ID: <CAJF-kYnhho8RA3WyVfC6oQZXfdcNJ+7Wud6LJBBeKrEovsVfdQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: Add extra check for sub_stripes to avoid hostile 0
 division attack.
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I didn't check but "repair" should be made able to fix this situation
on an existing fs fairly easily by zeroing the BLOCK_GROUP_RAID10-bit
in case sub_stripes is zero or some unreasonable number and set the
bit in case sub_stripes has a reasonable, small value.

2015-04-23 5:00 GMT+02:00 Qu Wenruo <quwenruo@cn.fujitsu.com>:
> Although only RAID10 use sub_stripes, a hostile attack can modify chunk
> tree and just add RAID10 bit to a single chunk.
> Then btrfs_map_block will trigger a 0 division in kernel and destroy
> everything.
>
> Just add extra check when reading chunk from disk.
>
> Reported-by: Lukas Lueg <lukas.lueg@gmail.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  fs/btrfs/volumes.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 8222f6f..a764726 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -6061,6 +6061,14 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
>         map->stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
>         map->type = btrfs_chunk_type(leaf, chunk);
>         map->sub_stripes = btrfs_chunk_sub_stripes(leaf, chunk);
> +
> +       /* Add extra check to avoid hostile 0 division attack */
> +       if (map->type & BTRFS_BLOCK_GROUP_RAID10 &&
> +           map->sub_stripes == 0) {
> +               free_extent_map(em);
> +               return -EINVAL;
> +       }
> +
>         for (i = 0; i < num_stripes; i++) {
>                 map->stripes[i].physical =
>                         btrfs_stripe_offset_nr(leaf, chunk, i);
> --
> 2.3.5
>
