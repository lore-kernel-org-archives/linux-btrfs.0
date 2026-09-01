Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD6B37B413
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Sep 2026 05:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788239250; cv=pass; b=KMgVWSg3GG+LgLS+qPOi7OZRsBM7M56d9pPov+T4Az8VllydGI1C+m0mABttFvBmCr64Hg805umLleF/JldgQLzzXxNSC5xURnRfdJi16CFI52yZMqj0um103nveNO6jnCZWT87ydO+xKuXxlRv1txjDTF9TL/2PfWqy5vsdzgM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788239250; c=relaxed/simple;
	bh=jOmJoBNvHyTwnqNXSmTQFyPB46t7wnpwywxRpuy/sZk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nps7WU0a9JGik2JN1TAQmFLlIhqyYEoeugFxGJZ109Ri6/Ekzax3evmp0GY+tTmZlcjJDXVSVXG2lH4PGeewp1pKUw1FXgPDERNd3jrZEGkBnjwDQAv7tb8LEX+p/N9pWyST8sRnPMKj/catuELAjOWm51j14+iIUifOvkMgnzo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SBO+nCdz; arc=pass smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SBO+nCdz"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-47ddf7b09e5so439901f8f.1
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2026 22:07:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788239246; cv=none;
        d=google.com; s=arc-20260327;
        b=OhICBTXJeGDJ0GPcPk6ouhagBkSNwPbtYI2RFqN/jDhIJJAJmR3hZncwZf4ZgZlh1H
         VnJcfwoaWV7JmkGJbmjct6YDFYZxuvDmJ09Tu+tB1ZZ77T5jive3Ohhg0tqoAX/H0/m/
         Y6GTbNqdCHLMgesqtoeQc3aZ2BytEVlj3PKZ7kZ4x9IGHkzvQodLuITq0xqDOu+5F5AN
         zv0sm+FFMlP6iQGrOJ67RPBxgk4rl6iSBAG1TW0sp6n0Mgt+SmcJUVF0cEj/5J+xnnOb
         dm755ZNWWlvma8zz3RKWf0KARsOSD23Be2ONP5pjmER4BYNQ6AtI9xPVlMi0YRTYTfTE
         Ocag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=pkdptfRt9HRzpBR8pU2nWprjCveBL3fYS+TTSuUGUxU=;
        fh=eLtfRUGDa+jQBIOfYkfhUJCCXw+FL82IgOpjeMMHyRM=;
        b=Nc7WVQtwjvao/7rFUBJLKJN6JAtN9V6g7vnn0IMu0IcSnJVSUJLy+g+lY5XXA5nbkY
         33OsUcmViQ6VRV8gkQT0n/AC8dOQsqjWaCcK61Hi7AL7zY5TGmhZcdcLlLSapCYtEKhk
         dWhufkz+uBCyUzOxpdioFBKSk15a1BKCdps5gmDj+R9ilV5/1zS7k8gFLZBQEB5JmX0o
         iCZPd+YKVAHKQeoxIYLjJCbzx2FmcLz68ojuUA+w4YdR5BYwS/l3FbiPX+FSs7P2058C
         d7AXv9WFawXqRaN43U/XtJRrexWHEDpmt+Z+PZDVR3heR4ycFhl3XNp6xj4g9ojw9NqD
         Odcw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788239246; x=1788844046; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pkdptfRt9HRzpBR8pU2nWprjCveBL3fYS+TTSuUGUxU=;
        b=SBO+nCdzbPQZ3BR0Cs2MBNeVaCSsq6fSBrrWtYM/Quga142fTYPzKGAYeNj3hZIfhw
         vIod48HfLab4Tp2k+U8uGdCCigDyftPQxt43JtKtTea1df02RAOHj84xryLIJIVJdLvL
         av7ahUNiHrOnfO+T76tIsypzwf0vW4GVgvnzBcoOnoDJEeaDMp6+wcTV4BxtQW9q1oGC
         dAyjlZdldFoQjhm7fTbr2GqLjhXo6g/fSbbRoUzv2QidCBThiqJFzV3RAy2bfpnXYC2w
         WpEK0VNX1/FUyVyce//asP3PYnsXWBPMZy8XqqO9EdJ/QtQH1vXOHH6zjigvxjBIVSkW
         QxZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788239246; x=1788844046;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=pkdptfRt9HRzpBR8pU2nWprjCveBL3fYS+TTSuUGUxU=;
        b=U1/gdg9ffHkUuXNglNPMUd3V2jqSByotuTuRndQ3FGKGpt4rioVXarpRheiQT9rroy
         PxXxuK6T9qckyVDuW50Q+TsRIw5xh5s9/4+hixyVaK65squ+8JvJm6doPNk+lwahKzzI
         A7tDz3ozI9mg1Wb7nfs9brbC5cZ2mT7MRRlXQQkXWfmJDAni3ZzDmAR40D8FYVv8wZ3G
         gXh/YMylMi+Zg4ArvhtdqMXf5tjKSGMFNcCbbibBdur31hk3Dsuqdy9UVZjzZpOIdzSg
         KKZxHLanKfCrjFIRB5fnXXsXE7ufULuc6L4F9dwLb/LPP40LPuWFOhuRlxx4zdo+FVqy
         BpQA==
X-Gm-Message-State: AFuF++l7fxKwmBqeP0nRR49jTMqN5rxKuIJJ9KOAmZmtVOgWm568IJJj
	D/Qvu10N/O86+neUjklEOaFbndh4CaoEpQr5djCR4CSfwajLcatKt6CR4C4pTHXSCCvD7tx4t28
	HIhvLSXPQ2PJ7gyRN5moLCU732fXFOg/dRmbq/JXjNoLpV9iIRXfdckk=
X-Gm-Gg: AYBFou3kK9TzjLnzpJy+b/8lbGyTskqbdqbJ1oQdE7KfFnSJ1mkWEkTGAUdHbHP6MET
	Skpg3b3pwEoB0rJjq4XTS4GGZeo89tIMcvcawXtcgNq7D3x5Xg1AU3hr8b7wlwP4i5wAvz38VMz
	ir4aWmAbBTciarEFfApSmFytCgPXOjE2E7bWE/Y4tgEY/MfIH0Z544WskIae2DQoHzfWk07wrdA
	pNXJcc7bM8Wl5wq5dCq1MWKtFrtE1OR+rajrGgYopAM3+WMnlvWDjo94kAwq75LXiUKsRc8FfYk
	iBwmvPlgVMA4skLcHeR7Lb/iWp6R68V+SaVUlAJ8/tzYFKsFXhLhOWCzrmC87CV5tzvBT4l508+
	L1RcqJug2uCzYWlQTAjMvY+81l4M3zxO28BT69gW/TQ==
X-Received: by 2002:a05:6000:656:b0:482:f0dc:e571 with SMTP id
 ffacd0b85a97d-482f79b1ec7mr49168415f8f.14.1788239246473; Mon, 31 Aug 2026
 22:07:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ba5fc3c9b2de187169552786c1fde4e2ebcef0f6.1788220853.git.wqu@suse.com>
In-Reply-To: <ba5fc3c9b2de187169552786c1fde4e2ebcef0f6.1788220853.git.wqu@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 1 Sep 2026 07:07:15 +0200
X-Gm-Features: AcwNN1VpDCS5MN9qMs0AnhUwz1gc5fuTj02pCLpC1nVUjPGO0I0hBXlzLAFvuTU
Message-ID: <CAPjX3FdoKWxYM+neZyTUU-z+mZUzg_7+1tWEyMKNhYhMO0t14Q@mail.gmail.com>
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

LGTM

Reviewed-by: Daniel Vacek <neelx@suse.com>

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
> +               oe = btrfs_lookup_ordered_extent(inode, filepos);
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
