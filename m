Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC11839CD10
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2026 21:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788211381; cv=none; b=tQhGxFZ0wljWBFn2zxGZXpdLQ5OKSyVuszd8amLC796tJTSyp9hcb8kcxBHHuWeNHGUjawqDRfKzrUirRXEzoHXJ8oZR0TQN8zRrbEgBmgQpTKG2pRbdide/OrEZrOknplsZOnG+Fofei8NRHx4ETmJpAZjsiOztcdzhmC2k4Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788211381; c=relaxed/simple;
	bh=c5Pc1niqy0l0ozMGvinFk94tHO+nEk58qHio1x4tLHs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gs2WDFtZ+4OorvXb9JNOK68sCXnYROewmZh+0nUpOjgUQcctqqDy4KVSP71GuxjmWwYW05ZJboAxzfuNf+gVWc0/TVdN3yYkX9ibunQmCovNWEghGD6j/4a3zrVr14C3BQo87n63gXpKfBBcl9V+G19I/aCkKmMABn8Vi2a6lqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=I70pfn/l; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Y2/UEkLf; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="I70pfn/l";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Y2/UEkLf"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 093471400101;
	Mon, 31 Aug 2026 17:22:58 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Mon, 31 Aug 2026 17:22:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1788211378; x=1788297778; bh=tdq4hPAQHY
	S8XgrIIXVA1fSRZ0BdSsjBO9U+v+6MZVs=; b=I70pfn/lFRqbczBwdh0y/2tmEg
	ZGmXWflJYkx12w1l7bvjmIFQK9r2iB2gWhnHSKfeXoUkuHGB6brAyFhSN5UMHCny
	1dm/e2i5NVazR/vetsWNJEpTqXnugKOk8ojdEFwZN6yLjWBxkrRQjIVuZL1gRO2I
	buPWTzDafu8IEAgJIboUMzDBeCMh445dKKx7Euck0AppSFf+RmEPYzgOAlT4p1NQ
	yu6xuh5e0inGKFs7zXJyd76tZUJ5F/cA7jeVFK4jFrHCk/y5bNBQwK6iGXQGm/SQ
	Edejav4Td8pUQrA3G4SMb/HmI0W5sL1JqKfsFYk0kwq7607t5uw3sY11J1PA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1788211378; x=1788297778; bh=tdq4hPAQHYS8XgrIIXVA1fSRZ0BdSsjBO9U
	+v+6MZVs=; b=Y2/UEkLftM7F5WeEL/SIgWrZz1Hvot3ixZ+qinwS3eHgcTuQZif
	vRntJYzbXgNX6QnnXyU8bVi0H02RWul3t3S10zc5F6n7f9mNd9x3BYZAxkVUXMc+
	htoc075XuNxGwNdt8NVnKExSbsnE1WBswjZgGAdtHGJmjy3uMooPN18EbS800Uxq
	7Q52yuU9C5Ken7qIi/4dgsIfPQfyn2n5EQ+0kT7QcoXVaN+iiPo5Lv6mxkYZ7EH/
	YdajiS+d4txWcgzg5oHa7XkK18n+/yVd+WeEmu3x78b5BVMUa/97L9lemVNBhyXl
	mPucsmkxrLCY3NsPSUmUHJp6r0wUyMsZYHw==
X-ME-Sender: <xms:sfCVavgs0Av27cPfkBMB_UfG14jUswcxxZv7SS_6ulaAoX8GsuMDuQ>
    <xme:sfCVajfte0a657k32ldEtz_FAG1tH59P1TSh67R0NArRtpqeiOouO7EkxZROjw3bD
    -yzG_1E2zoLQCjoSjuVvkJKb0ript5pcvwFFlIxhJ-1Mc2MAHt7DVmP>
X-ME-Received: <xmr:sfCVasdyFe-4FL19xKiJk0FLRkBrbbVnPiorgT-aFE_kenpfg5RPw0DoU0VtPP2wLltKrqXZX7eIGO0u9ZGphGaBtfM>
X-ME-Proxy-Cause: dmFkZTFGNrWMZV3cIGagQejUbXSkxo3cHB3S7lHEb03l7NPeiVC0MSd6DEI+YU+iowr5yV
    gsbsfE2QrrBwEgUgxeNVRwU62doIiy1lhZYAGV0cEame7h+UWLL1qUONSL1GMjay8wx4so
    BPuvpmZhQezEBttsHPKPRJU9ohrsyx9p3Os6xwXGojbGj1+n3/8KV0GVCS9galRa8NU6wL
    tUQ0fFs2o6FcOtFY1TGokOxLsPSJC0T8FHi9CcfN6nkaSYd5l8Osbpg2yQdpj77SBvv2je
    KU3xKJGJcx2OI0fxK7O3eykkmOIgHjDZ5zrP4sMXQEAHm6I1U1cqKa1FfKVLfFmoU2IqNj
    rNlBrzNKT4fvltW+hCDeQvyYqdVsGs7CMMpxVGtbiY4qOlVKYF1tb/3GnsfLWofynFvR+e
    3dATV7wO3xfykxXT3Egqmm7usi7VTa4/lEptyTCtXRsmXOiwok+lYrV3qAwRkcp/dV5rTj
    Z5wI4sD04hN2QgKHfKVXHTmVv0KzehsuYuw7rp8nNufHOM+NWyike/I56p2yIpkVtYnMKC
    u4Yjgribm0LdbIq6r2xpYDVnMxKb+HBu+VDYXNfYXxreHKMuxOcJqrJOdKeTWWr2JpCOov
    i9ETw1KgFE7caolQo22VwYk50SzYFQAs+7T+bIntruRvY6lsCCQsGYmfXvkQ
X-ME-Proxy: <xmx:sfCVal8sf1sDi87LlJ7-JZWsah51mR72_tj6oJIWhK-xjqtxAhUEGQ>
    <xmx:sfCVagm6-OpACaAnLnRNAVVp9lGCRMgmrV5vfvjcCdnXl-IvnFvFJg>
    <xmx:sfCVav_M6NvfCMTUQn7MH4r0rOkkra-SEa3CIPxAGMu2rJpUEbpwvQ>
    <xmx:sfCVamlsM1X4_StMr91T8eK7kDOm-jJH4GKjszQ3ovB5fwKtOLv8oQ>
    <xmx:svCVallzBDWcJ0ONa_-6-1BfPidsGXDBzxfIYAZXOWhEA-iR9qcM-nRw>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 31 Aug 2026 17:22:57 -0400 (EDT)
Date: Mon, 31 Aug 2026 14:22:13 -0700
From: Boris Burkov <boris@bur.io>
To: Daniel Vacek <neelx@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: use ordered extent to grab the logical address
 for submission
Message-ID: <20260831212213.GA325502@zen.localdomain>
References: <6576913842ae66ca1aa4f24cb60c544abe3ca43e.1785996696.git.wqu@suse.com>
 <CAPjX3FeYx6tKrbPy-b9W8eN3QKwLzG9Tt8=d85XSs-LfPpxMpg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPjX3FeYx6tKrbPy-b9W8eN3QKwLzG9Tt8=d85XSs-LfPpxMpg@mail.gmail.com>

On Mon, Aug 31, 2026 at 09:46:18AM +0200, Daniel Vacek wrote:
> On Thu, 6 Aug 2026 at 08:16, Qu Wenruo <wqu@suse.com> wrote:
> > In submit_one_sector() we call btrfs_get_extent() to grab the IO extent
> > map so that we know where the logical location to submit the block.
> >
> > However there is no guarantee that there is an IO extent map for the
> > block, and if there is no IO extent map nor ordered extent,
> > btrfs_get_extent() can grab the file extent from on-disk metadata.
> >
> > That's why we have ASSERT()s to reject holes and compressed file
> > extents.
> >
> > On the other hand, for the write range we should have both an IO extent
> > map and an ordered extent, so there is no reason not to grab the ordered
> > extent instead.
> >
> > There is some minor advantages:
> >
> > - No hole ordered extent
> >   So no need to rely on ASSERT()s to reject hole extents.
> >
> >   And the ASSERT()s are depending on the kernel config, without
> >   CONFIG_BTRFS_ASSERT those ASSERT()s won't even trigger.
> >
> > - No IO errors
> >   Unlike btrfs_get_extent() which can return IO error when doing the
> >   metadata tree search, btrfs_lookup_ordered_extent() will either return
> >   an OE or not found.
> >
> > - Cached OE in bio_ctrl->bbio
> >   At bbio allocation we have already did an OE lookup, and we have a
> >   high chance that the current block also belongs to that OE.
> >   Use that cached OE can reduce the frequency to do an rb-tree search.
> >
> > - Smaller rb-tree
> >   Unlike extent-map-tree, which can contain cached extent maps, the life
> >   span of ordered extents are much shorter, they get removed from the
> >   ordered tree after the file extent item is inserted into the subvolume
> >   tree.
> >
> >   So doing ordered extent tree search can be a tiny faster.
> >
> > And since we're here, also address some minor points:
> >
> > - Add error message for every EUCLEAN error
> >
> > - Remove a dead comment on btrfs_folio_clear_dirty()
> >   We no longer call folio_clear_dirty_for_io() since commit 095be159f3eb
> >   ("btrfs: unify folio dirty flag clearing"), so the folio flag is
> >   still dirty, and the folio dirty flag will be cleared by the last dirty
> >   block.
> >

I like Daniel's suggested cleanup (though maybe the "get_oe_from_bbio"
name doesn't quite capture the file position passed in as part of the
conceptual name. I still like it overall for making the refcount_inc
more symmetrical with lookup, that was the aspect of your code that
stuck out the most to me.

Conceptually it looks good and you can add
Reviewed-by: Boris Burkov <boris@bur.io>
to this version or v3 if you do do the nice cleanup.

Thanks,
Boris

> > Signed-off-by: Qu Wenruo <wqu@suse.com>
> > ---
> > Changelog:
> > v2:
> > - Extract a helper to determine if the @filepos is in the bbio OE range
> >   Which reduces several "bio_ctrl->bbio->ordered" duplication, and use
> >   in_range() to make is easier to read.
> > ---
> >  fs/btrfs/extent_io.c | 63 +++++++++++++++++++++++++++-----------------
> >  1 file changed, 39 insertions(+), 24 deletions(-)
> >
> > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > index d7600e5fa3d9..50cee1b13b6d 100644
> > --- a/fs/btrfs/extent_io.c
> > +++ b/fs/btrfs/extent_io.c
> > @@ -1808,6 +1808,18 @@ static noinline_for_stack int writepage_delalloc(struct btrfs_inode *inode,
> >         return 0;
> >  }
> >
> > +static bool block_in_bbio_oe_range(const struct btrfs_bio_ctrl *bio_ctrl,
> > +                                  u64 filepos)
> > +{
> > +       struct btrfs_ordered_extent *oe;
> > +
> > +       if (!bio_ctrl->bbio || !bio_ctrl->bbio->ordered)
> > +               return false;
> > +
> > +       oe = bio_ctrl->bbio->ordered;
> > +       return in_range(filepos, oe->file_offset, oe->num_bytes);
> > +}
> > +
> >  /*
> >   * Return 0 if we have submitted or queued the sector for submission.
> >   * Return <0 for critical errors, and the involved sector will be cleaned up.
> > @@ -1820,11 +1832,10 @@ static int submit_one_sector(struct btrfs_inode *inode,
> >                              loff_t i_size)
> >  {
> >         struct btrfs_fs_info *fs_info = inode->root->fs_info;
> > -       struct extent_map *em;
> > +       struct btrfs_ordered_extent *oe;
> >         u64 block_start;
> >         u64 disk_bytenr;
> >         u64 extent_offset;
> > -       u64 em_end;
> >         const u32 sectorsize = fs_info->sectorsize;
> >         unsigned int queued;
> >
> > @@ -1833,8 +1844,14 @@ static int submit_one_sector(struct btrfs_inode *inode,
> >         /* @filepos >= i_size case should be handled by the caller. */
> >         ASSERT(filepos < i_size);
> >
> > -       em = btrfs_get_extent(inode, NULL, filepos, sectorsize);
> > -       if (IS_ERR(em)) {
> > +       /* Try to reuse the existing OE from bbio first. */
> > +       if (block_in_bbio_oe_range(bio_ctrl, filepos)) {
> > +               oe = bio_ctrl->bbio->ordered;
> > +               refcount_inc(&oe->refs);
> > +       } else {
> > +               oe = btrfs_lookup_ordered_extent(inode, filepos);
> > +       }
> > +       if (unlikely(!oe)) {
> >                 /*
> >                  * bio_ctrl may contain a bio crossing several folios.
> >                  * Submit it immediately so that the bio has a chance
> 
> How about this small cleanup?:
> 
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -1691,6 +1691,22 @@ static noinline_for_stack int
> writepage_delalloc(struct btrfs_inode *inode,
>      return 0;
>  }
> 
> +static struct btrfs_ordered_extent *get_oe_from_bbio(const struct
> btrfs_bio *bbio,
> +                             u64 filepos)
> +{
> +    struct btrfs_ordered_extent *oe;
> +
> +    if (!bbio || !bbio->ordered)
> +        return NULL;
> +
> +    oe = bbio->ordered;
> +    if (!in_range(filepos, oe->file_offset, oe->num_bytes))
> +        return NULL;
> +
> +    refcount_inc(&oe->refs);
> +    return oe;
> +}
> +
>  /*
>   * Return 0 if we have submitted or queued the sector for submission.
>   * Return <0 for critical errors, and the involved sector will be cleaned up.
> @@ -1715,8 +1731,11 @@ static int submit_one_sector(struct btrfs_inode *inode,
>      /* @filepos >= i_size case should be handled by the caller. */
>      ASSERT(filepos < i_size);
> 
> -    em = btrfs_get_extent(inode, NULL, filepos, sectorsize);
> -    if (IS_ERR(em)) {
> +    /* Try to reuse the existing OE from bbio first. */
> +    oe = get_oe_from_bbio(bio_ctrl->bbio, filepos);
> +    if (!oe)
> +        oe = btrfs_lookup_ordered_extent(inode, filepos);
> +    if (unlikely(!oe)) {
>          /*
>           * bio_ctrl may contain a bio crossing several folios.
>           * Submit it immediately so that the bio has a chance
> 
> --nX
> 
> > @@ -1857,31 +1874,25 @@ static int submit_one_sector(struct btrfs_inode *inode,
> >                  */
> >                 btrfs_mark_ordered_io_finished(inode, filepos, fs_info->sectorsize,
> >                                                false);
> > -               return PTR_ERR(em);
> > +               btrfs_err_rl(fs_info,
> > +               "no ordered extent for root %lld ino %llu filepos %llu",
> > +                            btrfs_root_id(inode->root), btrfs_ino(inode),
> > +                            filepos);
> > +               return -EUCLEAN;
> >         }
> >
> > -       extent_offset = filepos - em->start;
> > -       em_end = btrfs_extent_map_end(em);
> > -       ASSERT(filepos <= em_end);
> > -       ASSERT(IS_ALIGNED(em->start, sectorsize));
> > -       ASSERT(IS_ALIGNED(em->len, sectorsize));
> > +       extent_offset = filepos - oe->file_offset;
> > +       ASSERT(filepos < oe->file_offset + oe->num_bytes);
> > +       ASSERT(IS_ALIGNED(oe->file_offset, sectorsize));
> > +       ASSERT(IS_ALIGNED(oe->num_bytes, sectorsize));
> > +       ASSERT(oe->compress_type == BTRFS_COMPRESS_NONE);
> > +       ASSERT(!test_bit(BTRFS_ORDERED_COMPRESSED, &oe->flags));
> >
> > -       block_start = btrfs_extent_map_block_start(em);
> > -       disk_bytenr = btrfs_extent_map_block_start(em) + extent_offset;
> > +       block_start = oe->disk_bytenr + oe->offset;
> > +       disk_bytenr = block_start + extent_offset;
> >
> > -       ASSERT(!btrfs_extent_map_is_compressed(em));
> > -       ASSERT(block_start != EXTENT_MAP_HOLE);
> > -       ASSERT(block_start != EXTENT_MAP_INLINE);
> > +       btrfs_put_ordered_extent(oe);
> >
> > -       btrfs_free_extent_map(em);
> > -       em = NULL;
> > -
> > -       /*
> > -        * Although the PageDirty bit is cleared before entering this
> > -        * function, subpage dirty bit is not cleared.
> > -        * So clear subpage dirty bit here so next time we won't submit
> > -        * a folio for a range already written to disk.
> > -        */
> >         btrfs_folio_clear_dirty(fs_info, folio, filepos, sectorsize);
> >         btrfs_folio_set_writeback(fs_info, folio, filepos, sectorsize);
> >         /*
> > @@ -1898,6 +1909,10 @@ static int submit_one_sector(struct btrfs_inode *inode,
> >                 btrfs_folio_clear_writeback(fs_info, folio, filepos, sectorsize);
> >                 btrfs_mark_ordered_io_finished(inode, filepos, fs_info->sectorsize,
> >                                                false);
> > +               btrfs_err_rl(fs_info,
> > +               "failed to queue sector for root %lld ino %llu filepos %llu",
> > +                            btrfs_root_id(inode->root),
> > +                            btrfs_ino(inode), filepos);
> >                 return -EUCLEAN;
> >         }
> >         return 0;
> > --
> > 2.54.0
> >
> >
