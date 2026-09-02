Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8484539CCE6
	for <linux-btrfs@vger.kernel.org>; Wed,  2 Sep 2026 18:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788373406; cv=pass; b=I5JZH8KmSPDXIWpcPXpQFVxjbIpNLAmQ+idDMUuFbJh6kIX88eQpaB4dollHqm96e1X/pdkJZ29rqLq/AmG6HcymF3Jp7Da2trzVKZpJZLvK4r3/vbROrlAO0p1ptq4g5UOcw17LWRvUcWMHHHn00A8NLrDdioRGb77vTB0TTjs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788373406; c=relaxed/simple;
	bh=AOictddvOL1GFaKiv3tjx2dBdlkJEFnBC9JytfITlF4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ozM2k7L+lDkR9PrZ+SorMbhAL+Q10nZpffh9R5Id90F/NBhU7X6mOPt0ynFdAjq8/KZMHvKVs1oOUmMBk/1pLIqPtkLkjlbc1UlvFu+LPoRPrJSTwT1uXtI2BOhZRNpFA05sV1DP6tCE83F12UoBZUvMaEAila+u9CKTjcVqUKk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TY59YE3C; arc=pass smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TY59YE3C"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-482e4998d28so1080340f8f.2
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Sep 2026 11:23:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788373403; cv=none;
        d=google.com; s=arc-20260327;
        b=o0oEXK+Jm2TV/rzPMC96W8iTFs6g3Yu6kVwHY+c9FSVUZwENgMxtVlVdIYbpGS5qzk
         DStv2uoKvdIR7Vw1QrqXR3N+n2HIAQFTCXHvUGJ16oxiq0LGkgC0t9qQ+6UfDr/V8+ML
         N4YpfTETaueKSM6Fr1lyljIf9sa6OahtfoKDp5eCFlW9XeA8k/9p9Bsn4nGEJFmB/PtQ
         AbcQscS/suaCNVzBHidfxbeFJemgJ45SBlvAPgIAZdz8/Rk0STXYO/5m0nyN2BqgFEJL
         zbMn5yCt1zAjZemtdtHexF/O/EQ53JZWhEbVj+qyMveCrE4Y9DvW1TOYsVqEBoZBFmWm
         JEhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=LcIuf55MBI9t/aygSKYjYJIo2TvAFD6ihh2iJnlRz0w=;
        fh=eLtfRUGDa+jQBIOfYkfhUJCCXw+FL82IgOpjeMMHyRM=;
        b=fjFLvRkO0h+KQWlqqFavcJ9FU0dwDAx/NzQfdd/Bgj2xROSqVjhF5STl1otolphd1N
         D4r76U9d8UT08kdnRydBrNHlbsPvDqiog/SzGBGKR2eb3aSREM7IY4m7rmWsDEEE4XYi
         fRYJIoPUfppDhsZDcLchDp7iaE7yaYlG2luC9S4csaC1nFv9mmiwpdieCAVnLAwLtWeV
         j+CLOXCxk0CPhNS91vx9jMZdW28C+VC0KVMlCDi6Pwjwxb8d60gwd2URVTaaImpqzYpN
         09fNVEDnMZu9RbvUTgIMLTx5fOXEJ/w/mCxLGWA8szh/zc+34U78lYZYpNIctZ/jxJlJ
         isXA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788373403; x=1788978203; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LcIuf55MBI9t/aygSKYjYJIo2TvAFD6ihh2iJnlRz0w=;
        b=TY59YE3Cao7K+OR0YbNvMR54nSyrOvEJvyfNyvEBxyUmi0iqC7uVrcUN2CTb8KW9Gs
         nzLGqsbvtaJ0wPqLGIzVJZbwD9SjTzguGSn/2kzX/zmCRdeGrVQtfOHBB8DSqgZSfvMo
         73hO0HzF9oUBUM9SteUU9+WTLZtKQWvKOUlxK3mFYbODBcu66Slo/W9zSBW0AzpsnaEp
         EiO1kekEpsvxol8JCS027miiwCxpeClaFCPDzhQBanAAuQcO6NEX5edbBKq0nFIRPxt8
         x0eHsRAanJT/g1nCgLZ8O52r2+R9uwJ0JTgoWlLo4GSsBBm6h3qdBbisCWMSNIwGiOEH
         7/8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788373403; x=1788978203;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LcIuf55MBI9t/aygSKYjYJIo2TvAFD6ihh2iJnlRz0w=;
        b=XAcH5QzWRqpkm13zxycMCLdCLgybOmSABJXXrLkBoH31EWaw6Y2POgCuvnBEEyDH/9
         zCGMLXAGTJoRiznKZXNc6JMC4YhC6zomj6224Sv98qp34noxo76Zu88r2VZ6SsLXCuUV
         A905Mz2rQS5PbCoiHRQrZWTF299JS8lLR+JREWn2SfwajATDsucqadXWFLNdsPbY8urL
         hxlYr4VIDLz7vuGc3t3GWSK13SjUft88RPvAHpyv1QzviWyqD1HbL0eupCgl63Yrg7bg
         Sr388tBlUKx+iM/2w6VD3Jd/ClUACgI5hIV7d0EcCQWZbkJun5iiZlak3hgBVW0if8mv
         Kt4g==
X-Gm-Message-State: AFuF++msdurix8hP5tzTgf+lcLWaHE51dZ/toiV36KpogMNHsloU/ndl
	I0fCSDH9GZIqTKNKtWSh11H2f/a14HFL4Kcse6xSPz5ijR+cxH51WA+Mitmxkin+1O5hxbnmihN
	9npn9thIWAvJnHXu7QEJx1+gQ1XrnR6eSdWRQNw+jYQ==
X-Gm-Gg: AYBFou3TKOow8/34H/OG8E+bXemJMMQAGgqNUI8HBY+hW+Wj1BlEpaAm5P3U2XEyZQH
	MiL6NF7JhCk5TNqNw8mkvKiPcLihQY4/ChjNgt4hwljUjFg7iPHRi1ojLOilv/mpq9n/aHt8GCO
	uf9BmN12LQDVawfXb/DVT7LxCl/fv0PmysXaY8p2KtBLr+vciPfQKu5NPkXqD/jA8oE+qp9Ge4s
	WHwmPT6Iw3FAMulolvPQ48HQibM7itVSjQrutw+timkvINL1IUyHvRyeOD8YaUN0u3mNIpHxSYz
	unWRWgoh8bvzLpq6mSV13MJ9NrzP5xJhMAMeGRIs0gdkDkhS7xyEASDkGzyf+z9+vwyZ6vLi9RN
	nWCBvl4yxCaM+1I8tezlwVNaBzFMXOje916H0bVA7Yw==
X-Received: by 2002:a05:600c:3485:b0:49b:96a0:5c00 with SMTP id
 5b1f17b1804b1-49ce5842b7bmr161644925e9.13.1788373402573; Wed, 02 Sep 2026
 11:23:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ba5fc3c9b2de187169552786c1fde4e2ebcef0f6.1788220853.git.wqu@suse.com>
In-Reply-To: <ba5fc3c9b2de187169552786c1fde4e2ebcef0f6.1788220853.git.wqu@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 2 Sep 2026 20:23:11 +0200
X-Gm-Features: AcwNN1WwbJvidaLboBdH4D-5uVbxEQmsBs0pD0YjSYjloaXqfjSXZlyw8Fd9gUI
Message-ID: <CAPjX3Ffo1jF0=u3atBr+mdco=aYFGU5GWQ6FNtuzgFUQEMvHdQ@mail.gmail.com>
Subject: Re: [PATCH v3] btrfs: use ordered extent to grab the logical address
 for submission
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, Boris Burkov <boris@bur.io>
Content-Type: text/plain; charset="UTF-8"

On Tue, 1 Sept 2026 at 02:02, Qu Wenruo <wqu@suse.com> wrote:
> In submit_one_sector() we call btrfs_get_extent() to grab the IO extent
> map so that we know where the logical location to submit the block.
>
> However there is no guarantee that there is an IO extent map for the
> block, and if there is no IO extent map nor ordered extent,
> btrfs_get_extent() can grab the file extent from on-disk metadata.
>
> That's why we have ASSERT()s to reject holes and compressed file
> extents.
>
> On the other hand, for the write range we should have both an IO extent
> map and an ordered extent, so there is no reason not to grab the ordered
> extent instead.
>
> There is some minor advantages:
>
> - No hole ordered extent
>   So no need to rely on ASSERT()s to reject hole extents.
>
>   And the ASSERT()s are depending on the kernel config, without
>   CONFIG_BTRFS_ASSERT those ASSERT()s won't even trigger.
>
> - No IO errors
>   Unlike btrfs_get_extent() which can return IO error when doing the
>   metadata tree search, btrfs_lookup_ordered_extent() will either return
>   an OE or not found.
>
> - Cached OE in bio_ctrl->bbio
>   At bbio allocation we have already did an OE lookup, and we have a
>   high chance that the current block also belongs to that OE.
>   Use that cached OE can reduce the frequency to do an rb-tree search.
>
> - Smaller rb-tree
>   Unlike extent-map-tree, which can contain cached extent maps, the life
>   span of ordered extents are much shorter, they get removed from the
>   ordered tree after the file extent item is inserted into the subvolume
>   tree.
>
>   So doing ordered extent tree search can be a tiny faster.
>
> And since we're here, also address some minor points:
>
> - Add error message for every EUCLEAN error
>
> - Remove a dead comment on btrfs_folio_clear_dirty()
>   We no longer call folio_clear_dirty_for_io() since commit 095be159f3eb
>   ("btrfs: unify folio dirty flag clearing"), so the folio flag is
>   still dirty, and the folio dirty flag will be cleared by the last dirty
>   block.
>
> Reviewed-by: Boris Burkov <boris@bur.io>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
>
> ---
> Changelog:
> v3:
> - Refactor the helper to grab the OE and increase its refs in one go
>
> v2:
> - Extract a helper to determine if the @filepos is in the bbio OE range
>   Which reduces several "bio_ctrl->bbio->ordered" duplication, and use
>   in_range() to make is easier to read.
> ---
>  fs/btrfs/extent_io.c | 64 +++++++++++++++++++++++++++-----------------
>  1 file changed, 40 insertions(+), 24 deletions(-)
>
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index d7600e5fa3d9..a221b63bdb20 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -1808,6 +1808,22 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
>         return 0;
>  }
>
> +static struct btrfs_ordered_extent *get_oe_from_bbio(const struct btrfs_bio *bbio,
> +                                                    u64 filepos)
> +{
> +       struct btrfs_ordered_extent *oe;
> +
> +       if (!bbio || !bbio->ordered)
> +               return NULL;
> +
> +       oe = bbio->ordered;
> +       if (!in_range(filepos, oe->file_offset, oe->num_bytes))
> +               return NULL;
> +
> +       refcount_inc(&oe->refs);

Thinking about it again, do we even need to raise the refcount?

One reference is already held by the bbio itself, so the lifetime is guaranteed.

> +       return oe;
> +}
> +
>  /*
>   * Return 0 if we have submitted or queued the sector for submission.
>   * Return <0 for critical errors, and the involved sector will be cleaned up.
> @@ -1820,11 +1836,10 @@ static int submit_one_sector(struct btrfs_inode *inode,
>                              loff_t i_size)
>  {
>         struct btrfs_fs_info *fs_info = inode->root->fs_info;
> -       struct extent_map *em;
> +       struct btrfs_ordered_extent *oe;
>         u64 block_start;
>         u64 disk_bytenr;
>         u64 extent_offset;
> -       u64 em_end;
>         const u32 sectorsize = fs_info->sectorsize;
>         unsigned int queued;
>
> @@ -1833,8 +1848,11 @@ static int submit_one_sector(struct btrfs_inode *inode,
>         /* @filepos >= i_size case should be handled by the caller. */
>         ASSERT(filepos < i_size);
>
> -       em = btrfs_get_extent(inode, NULL, filepos, sectorsize);
> -       if (IS_ERR(em)) {
> +       /* Try to reuse the existing OE from bbio first. */
> +       oe = get_oe_from_bbio(bio_ctrl->bbio, filepos);
> +       if (!oe)
        {
> +               oe = btrfs_lookup_ordered_extent(inode, filepos);
                put = true; // or !!oe
        }
> +       if (unlikely(!oe)) {
>                 /*
>                  * bio_ctrl may contain a bio crossing several folios.
>                  * Submit it immediately so that the bio has a chance
> @@ -1857,31 +1875,25 @@ static int submit_one_sector(struct btrfs_inode *inode,
>                  */
>                 btrfs_mark_ordered_io_finished(inode, filepos, fs_info->sectorsize,
>                                                false);
> -               return PTR_ERR(em);
> +               btrfs_err_rl(fs_info,
> +               "no ordered extent for root %lld ino %llu filepos %llu",
> +                            btrfs_root_id(inode->root), btrfs_ino(inode),
> +                            filepos);
> +               return -EUCLEAN;
>         }
>
> -       extent_offset = filepos - em->start;
> -       em_end = btrfs_extent_map_end(em);
> -       ASSERT(filepos <= em_end);
> -       ASSERT(IS_ALIGNED(em->start, sectorsize));
> -       ASSERT(IS_ALIGNED(em->len, sectorsize));
> +       extent_offset = filepos - oe->file_offset;
> +       ASSERT(filepos < oe->file_offset + oe->num_bytes);
> +       ASSERT(IS_ALIGNED(oe->file_offset, sectorsize));
> +       ASSERT(IS_ALIGNED(oe->num_bytes, sectorsize));
> +       ASSERT(oe->compress_type == BTRFS_COMPRESS_NONE);
> +       ASSERT(!test_bit(BTRFS_ORDERED_COMPRESSED, &oe->flags));
>
> -       block_start = btrfs_extent_map_block_start(em);
> -       disk_bytenr = btrfs_extent_map_block_start(em) + extent_offset;
> +       block_start = oe->disk_bytenr + oe->offset;
> +       disk_bytenr = block_start + extent_offset;
>
> -       ASSERT(!btrfs_extent_map_is_compressed(em));
> -       ASSERT(block_start != EXTENT_MAP_HOLE);
> -       ASSERT(block_start != EXTENT_MAP_INLINE);

        if (put)

> +       btrfs_put_ordered_extent(oe);
>
> -       btrfs_free_extent_map(em);
> -       em = NULL;
> -
> -       /*
> -        * Although the PageDirty bit is cleared before entering this
> -        * function, subpage dirty bit is not cleared.
> -        * So clear subpage dirty bit here so next time we won't submit
> -        * a folio for a range already written to disk.
> -        */
>         btrfs_folio_clear_dirty(fs_info, folio, filepos, sectorsize);
>         btrfs_folio_set_writeback(fs_info, folio, filepos, sectorsize);
>         /*
> @@ -1898,6 +1910,10 @@ static int submit_one_sector(struct btrfs_inode *inode,
>                 btrfs_folio_clear_writeback(fs_info, folio, filepos, sectorsize);
>                 btrfs_mark_ordered_io_finished(inode, filepos, fs_info->sectorsize,
>                                                false);
> +               btrfs_err_rl(fs_info,
> +               "failed to queue sector for root %lld ino %llu filepos %llu",
> +                            btrfs_root_id(inode->root),
> +                            btrfs_ino(inode), filepos);
>                 return -EUCLEAN;
>         }
>         return 0;
> --
> 2.55.0
>
>
