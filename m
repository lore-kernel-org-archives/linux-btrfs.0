Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8833B71C1
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 09:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788772548; cv=pass; b=ExFVZzEll4I2LNuhkYlY7XqTQ+X6M0D460Z4Ui7527z5KCxjZb7Fo+VV+KiwnxEY5xXU20/0hmbn/yZ1Hun/ifZ1QgrlVJhl6z+KTQD93qTqnwCx0qtrk4X/JdJLsdxfoRiWVsuIuWVYipvM43voJhaackI10jqZCaX4uSr520s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788772548; c=relaxed/simple;
	bh=/MFAR0BJv6ArlHZpPXeSNyeaqeMeT7jTuH2BnlBnyXk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sruXyEeQtmuD62SzusdJrztpOvT5C8+iUfdU+siLe8AJx2SDwQCFatqgueNKu+a1WAn986Nf60LTlYRx703ADGC5cDJybxVqtVHal4sKe/xFYjZ/ISRXwHAYxWf82UHjhWCfDDgRjUxwFSPrTt1S3ii/M12WUG6YvJrf2kCdm/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TH7jGVMB; arc=pass smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TH7jGVMB"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-49b0eab380eso30057945e9.0
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 02:15:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788772545; cv=none;
        d=google.com; s=arc-20260327;
        b=csX0JP7qWr3NVnJtcZuZ8HUZnkvtAiI8v7pxHg143RGr/9WMVtnAsUIu85wOqwjIhn
         bkZHJgSFanJH1CLOKDLQSZ8CEH1YHK1+MQc+q7Mdbti6yXuifvc35Ki7inmtoFAksh6p
         UC/rMwi2HRELWp1vhSbxiSlaHaCZUTndQ7mHCeSIBBEvL3CeP+od7HgeEdY5NbB04l3i
         RfXHStIjNTv5qqKwcK+aDYN4JXpIKuanADsNytJuNaDtgKw/1gFWGD31WkAZsrZm+j95
         Q/43vpyNlKIiywLL3Tf8Jr8NEY2iPlNp3+j+l5tkj1KR/wKzd+3PhtGWLI9/beAixzVS
         VGsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=SA0y0CQLIYLkfiY5R3TFU63deex74/QQ9+749Dn8ny0=;
        fh=A9GqkW4IeQf778vC2aVcWQ2BCNvVajAlVYf4UFnReSg=;
        b=n/7b0mDxwyi7Sy9GAs8onf3E2J+4psP7DhEthyB0N7KBaTmnNKq0FFohjRDbsiOj2U
         aUSIe8vj9RqKyWxA2VToWOJFgh15+San6o6RyjmqR4Aiq05bTTjLcBmGcb4hiBj+mZc2
         YeLXrzE8CuaWqG7gwQzMZvgEnwIm739/28FEs59MmIOBwN9v1ktMdhOnVkZvNBc4gTtr
         Ov6IfocS80IJB4+eJZ+vRmpVGr5Knl07ssK/sp3M6TFz9DBR0zyikz7EApczjTFmYocG
         nNu5ZXN44s8rwiEktnSUCjPTXIznwsB4PZohONsD6xQA60xqTydLiRd6z/JM+frKHNR1
         RfRg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788772545; x=1789377345; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SA0y0CQLIYLkfiY5R3TFU63deex74/QQ9+749Dn8ny0=;
        b=TH7jGVMBfVEBqqmD96sLxgcZtmUJAaBWW8o2vCGuCPQ/NNpbOo2vn6VOFbvWwY5zGc
         TkSILWRxmONb2eJu9QWoAEko03PB9hlAmV3acyoulUjwZRW1w+/Q7PCDmZrsIxA6JbY3
         xsZYZobypMX4OM+eTNNoAwdhqjCQDye8OCr+2ZLIM47yJTXnleAQAiHWO11VvKqr5LxW
         Sf1Hv0tU68lHfAJOOyy8p9+Uno9cDIXL+VFb4LQxWIPc8SUBOIe552L4rQ6c2h9QOdaH
         ON+c2CEUZf6Szsf+15K+PkUZVa1+9kfPpwHVMg1Dx5jO0it9gWtQ8BQM0DF1TLelEWAO
         4SZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788772545; x=1789377345;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=SA0y0CQLIYLkfiY5R3TFU63deex74/QQ9+749Dn8ny0=;
        b=mgi975R7jtzWpQw8LA1yOnwz54jZaIvmQWnwBsnCJHTEARBWtPbYESxvZHI7kQJOnX
         cdG4xU+g6o+1RzhC5hpDVU5g1qYFZKSasyVZbmajxhpUT/xt9hk2uwLpHiGuHHEwj85r
         AhhdRWWwwvKUxAvbL6nbY3fEctQUNvvipIYHNw4yG+CFZ9KFXGfqEIyraUaPpbSGmySp
         SbdoLXkCT0nUEqRuP9pCNJMkIq6/oNlySvGDflCWbPWR348WRJC1TwyYpOAxmFJVPVW8
         h3O6qd+kE/UQU6Z9PTUh/iXVjtRA5IO/X2ihGY6b0kz3IzcH8zs3aTQmQU1gAPbrGZ48
         fnxQ==
X-Forwarded-Encrypted: i=1; AKwUvBz8ukkOfbx4ReSaVolCTjXYIe4SlRJQOrGTL1g8z4buKLC7K+74YoJ0/SOGqLH6p88AkIJDQQWV/Oh5BA==@vger.kernel.org
X-Gm-Message-State: AFuF++l1pOnx71ehjdkICIPVkppCyWapl5Q8kOjX6F8Xj/QraDLd/Uk8
	3elGxxUOm4Gxc8tXhnb2N1K2cpofLedANsGgsIJADl/9abwzdjGiufZiuSjU9cfeHP8SuP0aVrq
	uTV6TQRO474DSge4q6AxBO0mKnzVzZi0zMBnRcAJGqA==
X-Gm-Gg: AYBFou0UyGEoIBHVVC7jUC+TO6f4/XfztByRWwm255Ny77ePx2HSEE5HiCkmbiaULsS
	ok9N1JfnUef0Lp0A2vMVDMe4I+8f0Enbrewc4s6SPqk97kIpkFP0G9YzI8sa27ZngZJEhiwMhN9
	9376hYEXfBMpDR4w8F2BjP6+ttuxf8eSRMCngxkg8b7sxVXtQx1uc8mh+fVgtSpv15Dy+6hLPPs
	YTJkzivriArdINbuR9vySrIXsyK9qCgrQByS9CmRHFRF3mLV0LUEMzGS3JT3RVflYty8VV0D9kw
	fMc0AIUL2XBLkZ07LUZ7VzaINgaG8u0q1aOQ9YgSBNWBligswktCqqtdnZVSaE+NgEcxeUB/lA8
	5I0KjrUJNL/OgDzgwvwQorrzhpAdj9H7sGaVxUZ9RHg==
X-Received: by 2002:a05:600c:4684:b0:49c:f13e:e4e with SMTP id
 5b1f17b1804b1-49cf8906323mr208303745e9.11.1788772544807; Mon, 07 Sep 2026
 02:15:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260907044801.9088-1-hemanth.selam@gmail.com>
In-Reply-To: <20260907044801.9088-1-hemanth.selam@gmail.com>
From: Daniel Vacek <neelx@suse.com>
Date: Mon, 7 Sep 2026 11:15:33 +0200
X-Gm-Features: AcwNN1VCQupOgh9v5Ck-I1vwV5juTsOZYec2g8PyYUOdbCxqp4AhMc_-LjRurbw
Message-ID: <CAPjX3FfQ4X4Bd-1-_Q3h4azLM98vnJLfZ8TvduPK6zf=y==Z2g@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: fix typos and repeated words in comments
To: Hemanth Selam <hemanth.selam@gmail.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 7 Sept 2026 at 06:54, Hemanth Selam <hemanth.selam@gmail.com> wrote:
> Fix misspellings and repeated words in comments, found with
> scripts/checkpatch.pl and codespell.  Only touches comments, no code
> changes.
>
> Changes since v1:
>  - the typo and repeated-word patches are folded into one, as they only
>    touch comments
>  - rebased onto btrfs for-next
>  - picked up the further typos codespell found, which David Sterba
>    listed: Temporarilly, Checksume, coresponding, caclulated, wheather
>    and cannnot ("commited" in block-group.h was already fixed by v1)
>
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
> ---
>  fs/btrfs/block-group.h          | 2 +-
>  fs/btrfs/extent-io-tree.c       | 2 +-
>  fs/btrfs/fs.c                   | 2 +-
>  fs/btrfs/raid56.c               | 8 ++++----
>  fs/btrfs/send.c                 | 2 +-
>  fs/btrfs/transaction.h          | 2 +-
>  fs/btrfs/tree-checker.c         | 2 +-
>  include/uapi/linux/btrfs_tree.h | 4 ++--
>  8 files changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
> index 69d56864d4ba..b349f94cf929 100644
> --- a/fs/btrfs/block-group.h
> +++ b/fs/btrfs/block-group.h
> @@ -135,7 +135,7 @@ struct btrfs_block_group {
>         u64 global_root_id;
>         u64 remap_bytes;
>         u32 identity_remap_count;
> -       /* The last commited identity_remap_count value of this block group. */
> +       /* The last committed identity_remap_count value of this block group. */
>         u32 last_identity_remap_count;
>         /*
>          * The last committed used bytes of this block group, if the above @used
> diff --git a/fs/btrfs/extent-io-tree.c b/fs/btrfs/extent-io-tree.c
> index d6df11f6088c..992b8b42bdb4 100644
> --- a/fs/btrfs/extent-io-tree.c
> +++ b/fs/btrfs/extent-io-tree.c
> @@ -751,7 +751,7 @@ int btrfs_clear_extent_bit_changeset(struct extent_io_tree *tree, u64 start, u64
>                                 btrfs_split_delalloc_extent(tree->inode, state, start);
>
>                         /*
> -                        * Temporarilly ajdust this state's range to match the
> +                        * Temporarily ajdust this state's range to match the
>                          * range for which we are clearing bits.
>                          */
>                         state->start = start;
> diff --git a/fs/btrfs/fs.c b/fs/btrfs/fs.c
> index de160d29dde8..75a1217727a7 100644
> --- a/fs/btrfs/fs.c
> +++ b/fs/btrfs/fs.c
> @@ -79,7 +79,7 @@ void btrfs_csum_init(struct btrfs_csum_ctx *ctx, u16 csum_type)
>                 blake2b_init(&ctx->blake2b, 32);
>                 break;
>         default:
> -               /* Checksume type is validated at mount time. */
> +               /* Checksum type is validated at mount time. */
>                 BUG();
>         }
>  }
> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index a5d0ef09d92a..4f702dbf581b 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -953,7 +953,7 @@ static void rbio_orig_end_io(struct btrfs_raid_bio *rbio, blk_status_t status)
>
>         /*
>          * Clear the data bitmap, as the rbio may be cached for later usage.
> -        * do this before before unlock_stripe() so there will be no new bio
> +        * do this before unlock_stripe() so there will be no new bio
>          * for this bio.

The sentence should start with a capital. Perhaps it would also fit
into two lines?

>          */
>         bitmap_clear(&rbio->dbitmap, 0, rbio->stripe_nsectors);
> @@ -988,7 +988,7 @@ static void rbio_orig_end_io(struct btrfs_raid_bio *rbio, blk_status_t status)
>   * as possible, and only use stripe_sectors as fallback.
>   *
>   * Return NULL if bio_list_only is set but the specified sector has no
> - * coresponding bio.
> + * corresponding bio.
>   */
>  static phys_addr_t *sector_paddrs_in_rbio(struct btrfs_raid_bio *rbio,
>                                           int stripe_nr, int sector_nr,
> @@ -1451,7 +1451,7 @@ static int rmw_assemble_write_bios(struct btrfs_raid_bio *rbio,
>         ASSERT(bitmap_weight(&rbio->dbitmap, rbio->stripe_nsectors));
>
>         /*
> -        * Reset errors, as we may have errors inherited from from degraded
> +        * Reset errors, as we may have errors inherited from degraded
>          * write.

This can fit on one line.

--nX

>          */
>         bitmap_clear(rbio->error_bitmap, 0, rbio->nr_sectors);
> @@ -2632,7 +2632,7 @@ static int alloc_rbio_essential_pages(struct btrfs_raid_bio *rbio)
>         return 0;
>  }
>
> -/* Return true if the content of the step matches the caclulated one. */
> +/* Return true if the content of the step matches the calculated one. */
>  static bool verify_one_parity_step(struct btrfs_raid_bio *rbio,
>                                    void *pointers[], unsigned int sector_nr,
>                                    unsigned int step_nr)
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 5c59b9abedcd..c523bf950c89 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -7023,7 +7023,7 @@ static int changed_extent(struct send_ctx *sctx,
>          * get modified or replaced with a new one). Note that deduplication
>          * updates the inode item, but it only changes the iversion (sequence
>          * field in the inode item) of the inode, so if a file is deduplicated
> -        * the same amount of times in both the parent and send snapshots, its
> +        * the same number of times in both the parent and send snapshots, its
>          * iversion becomes the same in both snapshots, whence the inode item is
>          * the same on both snapshots.
>          */
> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
> index 3a57f227b5ed..89153cd22596 100644
> --- a/fs/btrfs/transaction.h
> +++ b/fs/btrfs/transaction.h
> @@ -288,7 +288,7 @@ do {                                                                                \
>   * Call btrfs_abort_transaction() as early as possible when an error condition
>   * is detected, that way the exact stack trace is reported for some errors.
>   *
> - * Error number must be negative as it encodes wheather it's the first abort.
> + * Error number must be negative as it encodes whether it's the first abort.
>   */
>  #define btrfs_abort_transaction(trans, error)          \
>  do {                                                           \
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index 401fd40ec7b2..b8ca9980e1dd 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -228,7 +228,7 @@ static bool can_have_extent_data(struct extent_buffer *leaf,
>         }
>
>         /*
> -        * The rest are special files, e.g. block/FIFO files, which cannnot
> +        * The rest are special files, e.g. block/FIFO files, which cannot
>          * have any file extent.
>          */
>         return false;
> diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
> index b6ccaf848e4b..47ee52859b45 100644
> --- a/include/uapi/linux/btrfs_tree.h
> +++ b/include/uapi/linux/btrfs_tree.h
> @@ -230,7 +230,7 @@
>   *
>   * Stored as an inline ref rather to avoid wasting space on a separate item on
>   * top of the existing extent item. However, unlike the other inline refs,
> - * there is one one owner ref per extent rather than one per extent.
> + * there is one owner ref per extent rather than one per extent.
>   *
>   * Because of this, it goes at the front of the list of inline refs, and thus
>   * must have a lower type value than any other inline ref type (to satisfy the
> @@ -243,7 +243,7 @@
>  #define BTRFS_EXTENT_DATA_REF_KEY      178
>
>  /*
> - * Obsolete key. Defintion removed in 6.6, value may be reused in the future.
> + * Obsolete key. Definition removed in 6.6, value may be reused in the future.
>   *
>   * #define BTRFS_EXTENT_REF_V0_KEY     180
>   */
>
