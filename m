Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A324539D6F6
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2026 07:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788162393; cv=pass; b=MPeU/I1KyyBtnpAncVafk97v9pNYHKZNJMQMh+wvAcDazLzZLyG0MW2MQ72f0QtM/0hGt52MHNt5BzLK1ykKZcQ3/qDcyVBHQI/PemitTdQM6XwMeOrHmsUU37FUeC5A+LyT86caWXFv779B9qKe753jws9dd5VETZuGQO03AlE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788162393; c=relaxed/simple;
	bh=ZqpelwAK2bwkyptyMkCrJRg0IS5AJkjU8pOZFLTBK9Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FVWDxrzjycOxcaE6ChksTOwj+0ef/rl/ScRcCryZ8fVJCGK/he+pTykrntzKazgjqOOBK8sQQQC1jM21bxOFr2lwdfTIjUGC0io2DZPUyrUD0M2v8+R7UxuCIm+8/CzGBADUFIEghmPRRHVcOQyuXbz+4oIqzByZCd6vF9j4REA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Y85AdJYO; arc=pass smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Y85AdJYO"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4998b5a63e2so29390255e9.1
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2026 00:46:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788162390; cv=none;
        d=google.com; s=arc-20260327;
        b=JZjv/JU0V4X7z3gaKdpW4N/7HrQmaiVZIfyKzdERK64qpnsai2lJTnuhLC8DEmYA1C
         Z/3UY9UDi5K8vAUPJMMAKYS6nEvH4H91oh3YpKY3ZD1IaWq8NX+f2yKPT+Cphl1cDfPs
         a9VRrmgyIhnYVxWj1WoJY+3dyN6bZPnL3F1VKW8J6Tdn6fqJvp6bs0SkHOnir+dTa8+w
         pWw3ewYShKA51DsVZezlWZxl/QVYibj0UTIhL81m/cbp+yDxUzIlBSAA6jTY/xZ/gCQr
         naS0Awmg2zg14Tof2Je68nUpOGKFM7zCAMjxN1WW9S96io7bapi4RGpRDSKdYNpPbPOf
         796A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=hZQy/Yk684q3YWpKvie/KSb3LUNk/eNp21MfBXSicbs=;
        fh=gccavu6KskZuhdxKZGGZqKbRpE8AZv+Jw1v9OVMw784=;
        b=CU8JZe/qKnQs/9KXkd1r9Uv3/xBf+qdI8wDEkgivdIFgnWY2jIhsUJC8OK4epUT+YC
         /g5UcDIDUoZMsPqsI59OIjLm6KZysPABmiqBVNUCOhlhy2TPujj/X3NNLtag0L+PDtT2
         cgMDuPoPCkG1yHBYaoFqDdqWfMnCibhAT/m1kt52ZveRasFgwSZBBpbC8M3bugpD4L0q
         pmQBx2ki2cFi4BML7rqiDp2fC0fsqJrzU1EkH1aREQBuGaVLsHCyskAp5EQNHD4Chq9S
         2DMAwWSL15BTaVvZMHzCYrQyEMH8Kp13phLNSv60JcICyR03qgzfU5+ZURh5eqth/Yyv
         qepw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788162390; x=1788767190; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hZQy/Yk684q3YWpKvie/KSb3LUNk/eNp21MfBXSicbs=;
        b=Y85AdJYOMKHgicD4nFTpHGr49Cm5acPsvfONPy2IgZRbwVl5mw1EG0LdsICBOQKKsy
         ysR54o7QPPw46mV9oJ2jeR/P3RNNB6h2iEbu2VV0Tm5+19BHuMVIeC4VksP03YpwBDdA
         omWi7hymKrw8HtPV0FIkc2zly7ZBOdvykFCNaYd/FIja30boLvlI3zNJxWyZX6R7zzHb
         kiBtPwl19hJMyzqv+RqDee5QSek+ZHojGxKr9Ai2fbEiC5FAsId4VmbWwiNyRXol8qb4
         IwHqnQc7UCMAR9s9chp19KWrSggbdOD1GWsNbYDsctWIePJiYDKsI4hJIs102HoyKbmO
         WAXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788162390; x=1788767190;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=hZQy/Yk684q3YWpKvie/KSb3LUNk/eNp21MfBXSicbs=;
        b=F93768Sq59+5zBgWkc7u2tv+eKIribZIs6iwq4BUTBPj/o07t8gcuxDrGumI++dftt
         YwcZOjl8JUHwImwlLiQQt1ZgK4u4YfThBq2eT0NsPr9VAoGlxeji+lGI9pwHQHQHoRbz
         fxILsv6CMGI51gDd15FBkV2SDOBobWvGmKk90Iiszk3S8FLNNpeGUGRi3JMkewmzOkC8
         qfe6eO1KgoHRV9J7tL+jfWgnQrZko9aSh0itKX4VGPjD03q0hYPfBuUhTNGkn7MnpEWJ
         Uli5cxTApqJDc8Es9jFSjykZGeOww5TlZtx0cudkNwqtGradt7DiNSeCCstx4hR8bI2L
         1g6Q==
X-Gm-Message-State: AFuF++n5nSxv+1cNqBKxaGKLcZrUIRcfLeycqOKNXNo+OaW8WNCsQdMs
	yS5gpC6M3MQufgds0cbo4bkoJ2CODb99V4arf0fdtEHeFCszpJjcO7ZaGXwc8FdGbz9kCnW1sEC
	2I3VVrieGrbj2miHKxJzTHuZCxqT1GZNMLl0SEQW+AQ==
X-Gm-Gg: AR+sD13EOgQ8bvVJ0Y33LcQIluHD5uzz3Ms1w/p8lBTPZea07kj/saefFhUeAux7J+S
	sJVrcmHn8xydYlOpeDwcpkUR9l11UY8qyOXfx9BtzX/QFjBNzoB/Yir+7LBspyFsWXygS/xRZ+9
	ZAiUz9t2zN5+Z0CJ/NFIuLoJ1mFf9ZnVTjx355uL9XjIZLGQab/39iExe/bs2szypUjhDjyKonu
	9SsOXkQ9iicn6G9nT+BfU06J3KdZzDSmhAk7apg6BejNSTB4qCGbwkWrLZo9RbrfpYX+lMb0CZ5
	ZTyIAqzPsXSteR0e96E6ebvYQ+WgORSfq6nbAPqt3dAkvpiPHGoxlHna9xEtG19yQcFp6JNqbrQ
	MJLnzYsDgECDQLs4QPJbKvC4fkHS+cHCFRx4uNusUeA==
X-Received: by 2002:a05:600c:34d2:b0:49c:cbad:1c44 with SMTP id
 5b1f17b1804b1-49ccbad1cf1mr256027415e9.6.1788162389774; Mon, 31 Aug 2026
 00:46:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6576913842ae66ca1aa4f24cb60c544abe3ca43e.1785996696.git.wqu@suse.com>
In-Reply-To: <6576913842ae66ca1aa4f24cb60c544abe3ca43e.1785996696.git.wqu@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Mon, 31 Aug 2026 09:46:18 +0200
X-Gm-Features: AcwNN1VVIok9UFGzLo8MhKmZMhkUordccbCMNhDgX5TGiT1dNsSRk97j293S9uY
Message-ID: <CAPjX3FeYx6tKrbPy-b9W8eN3QKwLzG9Tt8=d85XSs-LfPpxMpg@mail.gmail.com>
Subject: Re: [PATCH v2] btrfs: use ordered extent to grab the logical address
 for submission
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 6 Aug 2026 at 08:16, Qu Wenruo <wqu@suse.com> wrote:
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
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> Changelog:
> v2:
> - Extract a helper to determine if the @filepos is in the bbio OE range
>   Which reduces several "bio_ctrl->bbio->ordered" duplication, and use
>   in_range() to make is easier to read.
> ---
>  fs/btrfs/extent_io.c | 63 +++++++++++++++++++++++++++-----------------
>  1 file changed, 39 insertions(+), 24 deletions(-)
>
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index d7600e5fa3d9..50cee1b13b6d 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -1808,6 +1808,18 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
>         return 0;
>  }
>
> +static bool block_in_bbio_oe_range(const struct btrfs_bio_ctrl *bio_ctrl,
> +                                  u64 filepos)
> +{
> +       struct btrfs_ordered_extent *oe;
> +
> +       if (!bio_ctrl->bbio || !bio_ctrl->bbio->ordered)
> +               return false;
> +
> +       oe = bio_ctrl->bbio->ordered;
> +       return in_range(filepos, oe->file_offset, oe->num_bytes);
> +}
> +
>  /*
>   * Return 0 if we have submitted or queued the sector for submission.
>   * Return <0 for critical errors, and the involved sector will be cleaned up.
> @@ -1820,11 +1832,10 @@ static int submit_one_sector(struct btrfs_inode *inode,
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
> @@ -1833,8 +1844,14 @@ static int submit_one_sector(struct btrfs_inode *inode,
>         /* @filepos >= i_size case should be handled by the caller. */
>         ASSERT(filepos < i_size);
>
> -       em = btrfs_get_extent(inode, NULL, filepos, sectorsize);
> -       if (IS_ERR(em)) {
> +       /* Try to reuse the existing OE from bbio first. */
> +       if (block_in_bbio_oe_range(bio_ctrl, filepos)) {
> +               oe = bio_ctrl->bbio->ordered;
> +               refcount_inc(&oe->refs);
> +       } else {
> +               oe = btrfs_lookup_ordered_extent(inode, filepos);
> +       }
> +       if (unlikely(!oe)) {
>                 /*
>                  * bio_ctrl may contain a bio crossing several folios.
>                  * Submit it immediately so that the bio has a chance

How about this small cleanup?:

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1691,6 +1691,22 @@ static noinline_for_stack int
writepage_delalloc(struct btrfs_inode *inode,
     return 0;
 }

+static struct btrfs_ordered_extent *get_oe_from_bbio(const struct
btrfs_bio *bbio,
+                             u64 filepos)
+{
+    struct btrfs_ordered_extent *oe;
+
+    if (!bbio || !bbio->ordered)
+        return NULL;
+
+    oe = bbio->ordered;
+    if (!in_range(filepos, oe->file_offset, oe->num_bytes))
+        return NULL;
+
+    refcount_inc(&oe->refs);
+    return oe;
+}
+
 /*
  * Return 0 if we have submitted or queued the sector for submission.
  * Return <0 for critical errors, and the involved sector will be cleaned up.
@@ -1715,8 +1731,11 @@ static int submit_one_sector(struct btrfs_inode *inode,
     /* @filepos >= i_size case should be handled by the caller. */
     ASSERT(filepos < i_size);

-    em = btrfs_get_extent(inode, NULL, filepos, sectorsize);
-    if (IS_ERR(em)) {
+    /* Try to reuse the existing OE from bbio first. */
+    oe = get_oe_from_bbio(bio_ctrl->bbio, filepos);
+    if (!oe)
+        oe = btrfs_lookup_ordered_extent(inode, filepos);
+    if (unlikely(!oe)) {
         /*
          * bio_ctrl may contain a bio crossing several folios.
          * Submit it immediately so that the bio has a chance

--nX

> @@ -1857,31 +1874,25 @@ static int submit_one_sector(struct btrfs_inode *inode,
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
> @@ -1898,6 +1909,10 @@ static int submit_one_sector(struct btrfs_inode *inode,
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
> 2.54.0
>
>
