Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2DB36165E
	for <linux-btrfs@vger.kernel.org>; Fri, 29 May 2026 15:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780069436; cv=pass; b=iQdGIFFfODAlRQ/hkBMR65y5hZ6ELRlBIzthdl/gvqkKr7H61oRsXORNzVATwhNKgPiSbm1V71qcE2edePoMyhG6il6HJvUFvKJIQ1yDsTdcKOPLj3dSQ3w5pUIy3Nru48d5mPYoBtEtEpYPV/I78os/l7ru9gmwQtJ2A8m3Zxc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780069436; c=relaxed/simple;
	bh=6BGZKHWpW1Dl8PoL8+e7WbTrHofucG0I+sMBcDZ/tfg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KOK/OmG7qqxxvrHMwCVho158DIF0Lr1iu1Lozqzy+HR4xTny8nbqlpUBoabLrs+aSR6JX59MR9ouCVmNBRXgRsl0DCOwS+YzwrnFMX6d8j/4nuDpBwWLbV/2IiQ3+Zim9tm2rRInHjfJavUddv3FJ9/kjRGHR2bEhrX66WzUces=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QLZZHhOm; arc=pass smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QLZZHhOm"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4891c00e7aeso95506925e9.2
        for <linux-btrfs@vger.kernel.org>; Fri, 29 May 2026 08:43:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780069433; cv=none;
        d=google.com; s=arc-20240605;
        b=M75WkxKXzI77B9+6dHHLcSviCQSeeB5ZNBu3T0ddpYE3lwyIjVRqvLa/e0sa/gH8Kv
         tB1HzP6pIAD/yQsCwKvRwa2STVvNdsSWCQf7Axwm0Ox95iQ/lOpw6Pkxj1DxfEg4uABV
         LsVRGQCfNtUSiwWSy0L+5+PV8cTjpxCsKxWbol4Ep6BwHPQaKNFEZlxny8IuL8xXLrYF
         3k6IAqOUCFmDteiSIqM9TxSmYImK3y0UE/D0EyGPv/TT92+icf641/+pVngnGCGZwpHj
         nlcfQUFkgeDoSaJCLuheiOxK1J93XfI4sw3NzRH+IxJpSsDG5+WT9OYSUVrbHkzvXJse
         e7/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Mjd/RFuQoN4x/HaSDJPAuZODD9TAFUVApiD1tH4zt9k=;
        fh=uQOW7zhY7Tg7Wtl8pNbJ/2MFkkgOveYuDqMaag2G6pI=;
        b=Rhg/oiBOXoXhJq3xwjBIUKGIQZ4m23rrSUTJKj+eeD3OW2VVwTT84EcKE3IfAEhPQh
         e+Iqw9C/dvJXtqeOYcqZbnnDRrMROGonbDB2kKYmTL5AeMp1HqsmAA/ZNUyBKvI0C8pZ
         ArS6/VBSrOZj5PW9P+RKj+lWNL3J+nzRwYsDlwOQMoOwLwrxPMclNfvmZ/PQNtksLEVL
         JpRvJsw2TiNzC/bQ88N2v9z/JKQAGf/GxqPWEdQG4LwfOg2H+xA11OrqGiO2VBRktAGP
         fwBmEJlASbaHBvqREm+JQnWNlZ+4w2FJ4M4YGgqxZc8TouAvLXPInN1SKJEFsRe3MHzm
         KYPg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780069433; x=1780674233; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Mjd/RFuQoN4x/HaSDJPAuZODD9TAFUVApiD1tH4zt9k=;
        b=QLZZHhOmpwlCP4LowYEmzfEe4SBEyZsMKXBANxNaaOJ+Hg0GJCAv/fifFswndd3Srv
         shyKwxFL2E4QUxLY7faSYCNZhSonaTSBz5I7rKfay3+i672u/9lnnQroQV+o3jWCk9Tp
         4htAYkHDdqipNHUbh/zpnktVLYeUIk2JR+VrViZbw0QnXcGO7tZOMH+WHF32/ocu+gW6
         DNQrpK1eYLqV8pbDazR6qFxrgKNXy7wfIc9kuK6YhUucrNbdfOdVjyziEUSjnyo6TQa7
         2JkdgkDAZDJ8osymbnbbBaSF953hBFeDhiEhzCASEL1kpYIczHC1IbKNZjdu1oUITylR
         9eZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780069433; x=1780674233;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mjd/RFuQoN4x/HaSDJPAuZODD9TAFUVApiD1tH4zt9k=;
        b=it4hRx6adxyOZteT+Kh2YmbZI/5+89De7l3lM8hTenbCbXg53LuvM21ueB8ig6zb14
         sj3Fl1FWlX+pv2/x4knf/1TJCqnoeiTlNpv2ysQ5kTQCMLdx9P1Ggap/+1k0sr1L2pFL
         EIcNPQpEJ+jDk5qbixDjrr/WuBi+2/mcara9IQoRThiUxMhclKt7gcNyopzP+J+qc3U1
         2okjJS5DyC5FDPN+sq89IyMZYDR5CGs5TSXUhfotggdOgi9mcEaYyj3rVftVnp3Ghm0q
         CXWFaNvW6qx/nU7GZ8fIs706pVBx7s7bUin5HSQN5r6ArlUQBzzJcB9jpQaG0YKq+P5n
         JyHw==
X-Forwarded-Encrypted: i=1; AFNElJ9VKFSw6wyvXwGuYSan17lsEwFggYgI/sa0EnAfzgKEZ+CP+H9hGCagthSa8etvvNwuT8DYcDDkhB8/BA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwWb4hU90QewNUTOzrX64T5GRMqskiqLxP1c/urwf5E7PVu1QMK
	ZUqIFDWU9MhEgG7iYht5rADiViH/bruhGlyJgVCzzyvOdYy2o3ygbQvhp5OeBdmpmhrA+YakDi6
	WhOMqmIB+uKAFX2p8rHpBYje849zsXuKTaIeSCSRR3w==
X-Gm-Gg: Acq92OEMqOCVN/zKS2jjSK5S8mtmANK0K4L328vptcs1svx41fZcYjoyzX3tvnIYU60
	MGzbMLX2ZvhjBgdp/6WHYSaIjpnKKKy8Siis2RmgtrFrPHR+kjla5JguXDQdLOjHc2GvWbppKZ/
	0UXlaQpoc486RBPdwMZ2FIX8Sw4RMCRiAeQQeK14hd0+pd7poH/gvv/kT1wLQN6PNQM7+V/282Y
	qeKeQicsJDPTX7bYDSC348Suhps9ECTQp7k4uGFexmNuQOYCXRX/69swYLeJCCp7pTPX40JfjBi
	7m/3oiQFxA4PfCLFa3jt9kJdp4Ci78GzYcM0O4mXhlYgLpMrdB59zUjBAOfIlE8E104/yQ4d1oq
	+TyPBYxkH6l25cGc=
X-Received: by 2002:a05:600c:1d86:b0:48e:60a3:220a with SMTP id
 5b1f17b1804b1-490a28aa789mr4847005e9.0.1780069433114; Fri, 29 May 2026
 08:43:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513085340.3673127-1-neelx@suse.com> <20260513085340.3673127-33-neelx@suse.com>
 <ahAfo4DzvH_ob1hv@infradead.org>
In-Reply-To: <ahAfo4DzvH_ob1hv@infradead.org>
From: Daniel Vacek <neelx@suse.com>
Date: Fri, 29 May 2026 17:43:41 +0200
X-Gm-Features: AVHnY4LNmQMXMJqOYo-u3g5g_FfS_GaIHTnMIQeq2jow0uPl_gbFF7i0-FQGaO8
Message-ID: <CAPjX3Ff1qSLGNP3979KzLoAJCJcT_1se0WJsBHmDWuvhkOwQxg@mail.gmail.com>
Subject: Re: [PATCH v7 32/43] btrfs: implement process_bio cb for fscrypt
To: Christoph Hellwig <hch@infradead.org>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, Eric Biggers <ebiggers@kernel.org>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 22 May 2026 at 11:19, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, May 13, 2026 at 10:53:06AM +0200, Daniel Vacek wrote:
> > From: Josef Bacik <josef@toxicpanda.com>
> >
> > We are going to be checksumming the encrypted data, so we have to
> > implement the ->process_bio fscrypt callback.  This will provide us with
> > the original bio and the encrypted bio to do work on.  For WRITE's this
> > will happen after the encrypted bio has been encrypted.  For READ's this
> > will happen after the read has completed and before the decryption step
> > is done.
> >
> > For write's this is straightforward, we can just pass in the encrypted
> > bio to btrfs_csum_one_bio and then the csums will be added to the bbio
> > as normal.
> >
> > For read's this is relatively straightforward, but requires some care.
> > We assume (because that's how it works currently) that the encrypted bio
> > match the original bio, this is important because we save the iter of
> > the bio before we submit.  If this changes in the future we'll need a
> > hook to give us the bi_iter of the decryption bio before it's submitted.
> > We check the csums before decryption.  If it doesn't match we simply
> > error out and we let the normal path handle the repair work.
> >
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > Signed-off-by: Daniel Vacek <neelx@suse.com>
> > ---
> >
> > v7 changes:
> >  * Fixed array overflow stack corruption for bios > max blocksize (>64KiB)
> >    as reported by Chris' AI review.
> > v6 changes:
> >  * Adapt to btrfs_data_csum_ok() changes for bs > ps.  Mostly follow
> >    what was done in 052fd7a5cace ("btrfs: make read verification
> >    handle bs > ps cases without large folios").
> >  * Rename bbio::csum_done to csum_ok due to name collision.
> >    With upstream, member name csum_done was used for async csums.
> > v5: https://lore.kernel.org/linux-btrfs/ca32684b01ff8c252be515509137e0a4a0e5db7a.1706116485.git.josef@toxicpanda.com/
> > ---
> >  fs/btrfs/bio.c       | 44 +++++++++++++++++++++++++++++++++++++++++++-
> >  fs/btrfs/bio.h       |  3 +++
> >  fs/btrfs/file-item.c | 14 ++++++++++++--
> >  fs/btrfs/fscrypt.c   | 29 +++++++++++++++++++++++++++++
> >  4 files changed, 87 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
> > index 3e2ee19aab50..729c5aff5c3d 100644
> > --- a/fs/btrfs/bio.c
> > +++ b/fs/btrfs/bio.c
> > @@ -301,6 +301,40 @@ static struct btrfs_failed_bio *repair_one_sector(struct btrfs_bio *failed_bbio,
> >       return fbio;
> >  }
> >
> > +blk_status_t btrfs_check_encrypted_read_bio(struct btrfs_bio *bbio, struct bio *enc_bio)
> > +{
> > +     struct btrfs_inode *inode = bbio->inode;
> > +     struct btrfs_fs_info *fs_info = inode->root->fs_info;
> > +     struct bvec_iter iter = bbio->saved_iter;
> > +     struct btrfs_device *dev = bbio->bio.bi_private;
> > +     const u32 blocksize = fs_info->sectorsize;
> > +     const u32 step = min(blocksize, PAGE_SIZE);
> > +     const u32 nr_steps = iter.bi_size / step;
> > +     phys_addr_t paddrs[BTRFS_MAX_BLOCKSIZE / PAGE_SIZE];
> > +     phys_addr_t paddr;
> > +     unsigned int slot = 0;
> > +     u32 offset = 0;
> > +
> > +     /*
> > +      * We have to use a copy of iter in case there's an error,
> > +      * btrfs_check_read_bio will handle submitting the repair bios.
> > +      */
> > +     btrfs_bio_for_each_block(paddr, enc_bio, &iter, step) {
> > +             ASSERT(slot < nr_steps);
> > +             paddrs[slot] = paddr;
> > +             slot++;
> > +             offset += step;
> > +             if (IS_ALIGNED(offset, blocksize)) {
> > +                     if (!btrfs_data_csum_ok(bbio, dev, offset - blocksize, paddrs))
> > +                             return BLK_STS_IOERR;
> > +                     slot = 0;
> > +             }
> > +     }
> > +
> > +     bbio->csum_ok = true;
> > +     return BLK_STS_OK;
> > +}
> > +
> >  static void btrfs_check_read_bio(struct btrfs_bio *bbio, struct btrfs_device *dev)
> >  {
> >       struct btrfs_inode *inode = bbio->inode;
> > @@ -330,6 +364,10 @@ static void btrfs_check_read_bio(struct btrfs_bio *bbio, struct btrfs_device *de
> >       /* Clear the I/O error. A failed repair will reset it. */
> >       bbio->bio.bi_status = BLK_STS_OK;
> >
> > +     /* This was an encrypted bio and we've already done the csum check. */
> > +     if (status == BLK_STS_OK && bbio->csum_ok)
> > +             goto out;
> > +
> >       btrfs_bio_for_each_block(paddr, &bbio->bio, iter, step) {
> >               paddrs[(offset / step) % nr_steps] = paddr;
> >               offset += step;
> > @@ -341,6 +379,7 @@ static void btrfs_check_read_bio(struct btrfs_bio *bbio, struct btrfs_device *de
> >                                                        paddrs, fbio);
> >               }
> >       }
> > +out:
> >       if (bbio->csum != bbio->csum_inline)
> >               kvfree(bbio->csum);
> >
> > @@ -859,10 +898,13 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
> >               /*
> >                * Csum items for reloc roots have already been cloned at this
> >                * point, so they are handled as part of the no-checksum case.
> > +              *
> > +              * Encrypted inodes are csum'ed via the ->process_bio callback.
> >                */
> >               if (!(inode->flags & BTRFS_INODE_NODATASUM) &&
> >                   !test_bit(BTRFS_FS_STATE_NO_DATA_CSUMS, &fs_info->fs_state) &&
> > -                 !btrfs_is_data_reloc_root(inode->root) && !bbio->is_remap) {
> > +                 !btrfs_is_data_reloc_root(inode->root) && !bbio->is_remap &&
> > +                 !IS_ENCRYPTED(&inode->vfs_inode)) {
> >                       if (should_async_write(bbio) &&
> >                           btrfs_wq_submit_bio(bbio, bioc, &smap, mirror_num))
> >                               goto done;
> > diff --git a/fs/btrfs/bio.h b/fs/btrfs/bio.h
> > index 43f7544029ac..456d32db9e9e 100644
> > --- a/fs/btrfs/bio.h
> > +++ b/fs/btrfs/bio.h
> > @@ -43,6 +43,7 @@ struct btrfs_bio {
> >               struct {
> >                       u8 *csum;
> >                       u8 csum_inline[BTRFS_BIO_INLINE_CSUM_SIZE];
> > +                     bool csum_ok;
> >                       struct bvec_iter saved_iter;
> >               };
> >
> > @@ -130,5 +131,7 @@ void btrfs_submit_repair_write(struct btrfs_bio *bbio, int mirror_num, bool dev_
> >  int btrfs_repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 fileoff,
> >                           u32 length, u64 logical, const phys_addr_t paddrs[],
> >                           unsigned int step, int mirror_num);
> > +blk_status_t btrfs_check_encrypted_read_bio(struct btrfs_bio *bbio,
> > +                                         struct bio *enc_bio);
> >
> >  #endif
> > diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> > index 986914078708..72d9d3243460 100644
> > --- a/fs/btrfs/file-item.c
> > +++ b/fs/btrfs/file-item.c
> > @@ -338,6 +338,14 @@ static int search_csum_tree(struct btrfs_fs_info *fs_info,
> >       return ret;
> >  }
> >
> > +static inline bool inode_skip_csum(struct btrfs_inode *inode)
> > +{
> > +     struct btrfs_fs_info *fs_info = inode->root->fs_info;
> > +
> > +     return (inode->flags & BTRFS_INODE_NODATASUM) ||
> > +             test_bit(BTRFS_FS_STATE_NO_DATA_CSUMS, &fs_info->fs_state);
> > +}
> > +
> >  /*
> >   * Lookup the checksum for the read bio in csum tree.
> >   *
> > @@ -357,8 +365,7 @@ int btrfs_lookup_bio_sums(struct btrfs_bio *bbio)
> >       int ret = 0;
> >       u32 bio_offset = 0;
> >
> > -     if ((inode->flags & BTRFS_INODE_NODATASUM) ||
> > -         test_bit(BTRFS_FS_STATE_NO_DATA_CSUMS, &fs_info->fs_state))
> > +     if (inode_skip_csum(inode))
> >               return 0;
> >
> >       /*
> > @@ -817,6 +824,9 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, struct bio *bio, bool async)
> >       struct btrfs_ordered_sum *sums;
> >       unsigned nofs_flag;
> >
> > +     if (inode_skip_csum(inode))
> > +             return 0;
> > +
> >       nofs_flag = memalloc_nofs_save();
> >       sums = kvzalloc(btrfs_ordered_sum_size(fs_info, bio->bi_iter.bi_size),
> >                      GFP_KERNEL);
> > diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
> > index 5d34a8b94da5..924ee3df7f32 100644
> > --- a/fs/btrfs/fscrypt.c
> > +++ b/fs/btrfs/fscrypt.c
> > @@ -16,6 +16,7 @@
> >  #include "transaction.h"
> >  #include "volumes.h"
> >  #include "xattr.h"
> > +#include "file-item.h"
> >
> >  /*
> >   * From a given location in a leaf, read a name into a qstr (usually a
> > @@ -212,6 +213,33 @@ static struct block_device **btrfs_fscrypt_get_devices(struct super_block *sb,
> >       return devs;
> >  }
> >
> > +static blk_status_t btrfs_process_encrypted_bio(struct bio *orig_bio,
> > +                                             struct bio *enc_bio)
> > +{
> > +     struct btrfs_bio *bbio;
> > +
> > +     /*
> > +      * If our bio is from the normal fs_bio_set then we know this is a
> > +      * mirror split and we can skip it, we'll get the real bio on the last
> > +      * mirror and we can process that one.
> > +      */
> > +     if (orig_bio->bi_pool == &fs_bio_set)
> > +             return BLK_STS_OK;
> > +
> > +     bbio = btrfs_bio(orig_bio);
> > +
> > +     if (bio_op(orig_bio) == REQ_OP_READ) {
> > +             /*
> > +              * We have ->saved_iter based on the orig_bio, so if the block
> > +              * layer changes we need to notice this asap so we can update
> > +              * our code to handle the new world order.
> > +              */
> > +             ASSERT(orig_bio == enc_bio);
> > +             return btrfs_check_encrypted_read_bio(bbio, enc_bio);
> > +     }
> > +     return btrfs_csum_one_bio(bbio, enc_bio, false);
>
> Honestly, all this shows that the architecture of the I/O path in this
> series is pretty broken.  It needs all this magic detection, and the
> passing of arguments that mixes the bbio for state and the lower
> encrypted bio without the btrfs context shows something doesn't work
> well.

Well, this is all limited within the scope of the filesystem. Since
btrfs needs to compute the data checksum and the bounce bio (with the
encrypted pages) is created by the lower fscrypt layer, how else could
we accomplish this?

As the blk-crypto is inlined, without the callback the filesystem
never sees the encrypted data at all and it won't be able to get
checksums.

> So let's take a step back, if we think of the I/O pipeline, it should do
> things in this order for writes:
>
>  - encrypt data
>  - generate checksums
>  - do mirroring/striping/parity
>
> and reverse for reads.
>
> All this suggest that the btrfs_bio needs to exist for the encrypted
> data.

My understanding was that fscrypt works differently. The bounce bio is
created inline in the lower layer, agnostic to any filesystem.

>  So I think you'll need to and refactor this, preferably with the
> really annoying two-level callbacks that this really hard to follow (or
> implement).  Your caller is in the file system, and it should be able to
> call fscrypt as helpers instead of going two layers down using direct
> calls and then two layers back up using indirect calls.  The recent
> refactoring that moves the fscrypt fallback above the block layer
> instead of calling it from the bottom should help a lot with that.

Yeah, I may look into that. What you're talking about is a pretty recent change.
This is an old patch [1] from 2023 rebased without many changes since
as there was not much feedback before. So it still follows the
original (former) design.

If fscrypt supported checksumming the encrypted data and returned the
value back to the filesystem, no callbacks would be needed. Though to
me that sounds more invasive than this callback.

[1] https://lore.kernel.org/linux-btrfs/a26514814b4d2a54ff2317369365dc2bf1c280dc.1695750478.git.josef@toxicpanda.com/

--nX
