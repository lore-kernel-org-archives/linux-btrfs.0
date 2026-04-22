Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2B2372ED0
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2026 08:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776845875; cv=pass; b=IsoHN4jefAt7HUqN6nR8awQYpb6Fd6O65gWHvFIQd/ChMHDTQFe0w8HS5mz9Z7Xjtz4rsReF/uzc4RKxc/5c7Pz504g2lUKZA2B8Zgj3A+njtgCjuNgO+MFZwbnBSwuAWbhG3ZeGGPJTntgRwa0qBmvjTdyJrgfxRVtQYjUm/24=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776845875; c=relaxed/simple;
	bh=KaBz9kmz24MLjxuuycGABAaLrcm88HhScI6crUPgnTY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ipdd5oKsaBKVcMxsU4PjufgPOR2VxjIpAVXYrEE75aplx/j0YVpxr/Xl2rJhtGQectokOZhXl7xLbNd50pW2dcs/uOIpfrE9gyL2ni9ArEsfgfaFGLMSoWl47g/NQQm24NqlQasm/ftY2xbIpDC/lyI6L7yARREtwoWM4xz0Pb0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dla6Nbl2; arc=pass smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dla6Nbl2"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-43fe3e22e33so3417081f8f.0
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2026 01:17:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776845871; cv=none;
        d=google.com; s=arc-20240605;
        b=XKRtIj4D6SLtiJ5TzRMYIGymuez916vDksSQOljUe6niZu4lsLcsb6hoHx2mvTHAFf
         6tIDOkenF+Bd3LYGXy+1EtUI1x+XYO/WguO2B/HDSwUF0xSrw/NHnI2TyPB4hRYoiBla
         GF2MMfSdG40zcK9649vvpKabZtv/VbRb2gDcYI9+noUQfohW2itzRKABbu/5qZOIbhW2
         2dCD82NxeUkjMnqZ1G0XRIsATSRgUUHCW+kgTuwBwCLfjRru6syFFp6rIdBKDRi4WmOB
         oBI1BDCAwKiA3kOaNInOHvtJQa7nVQ4cUbRRyh8SJ1oSp/SZkp/qzxVQNSjIfAXFbpjb
         8eeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Ed8qgQLZgWWqPjz4Cxq94KupWeY98Dp7kKiY+uA66so=;
        fh=02oU7p++LyJoRe4kUjW/GCI1DR1xmY9+aD3+xSCP6bQ=;
        b=YaJVScy1HPUuK2t+YrOgsZVY5rU70AtoKHSpSgRHSeZk3mtEPRwmPZSBTfPOC8p9zj
         A91WTl1JR2S6vkHPdw2rVJAXU8NdKG+OLeXhdCS5xmHBIX0qDfDqmQZkY0+Mzjsa0TT3
         uKuIknfH2XohEbVAC5rh+G7H56qpFa6vxU9eOEpqJuR6h+LJSEQOOWqZF31dt7WsM5+O
         WB+/9i6W/zZLBZrSNTTWWNwsjvMLENWKlBNeAS2+ExW7drXaIYR/Xrmi7L515SqAdi45
         Ln6mkxO0OMW4TbEr+0SqNn+K2jvquiYVQhbHHXxrP5K1kMIysMwhi4p5wsawkyxVvqo7
         gNjQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776845871; x=1777450671; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ed8qgQLZgWWqPjz4Cxq94KupWeY98Dp7kKiY+uA66so=;
        b=dla6Nbl2Wn0rRM66GMlaM5HW8Bp/LTpnrbyzhiyJ193cB7rOv/DMyuyY2rx8x6rVOE
         EsAjAFCTm94vYmOES1Ak2SfHRrx2N0ERHBKg5siy4EaLByq/IeF0AbeipmEAllHYiJ31
         De5G3tY/t0lImy1Vdv7hmH7rNk6kixyckduYLNhWPYtnVbUqE96ePINcpKfmvMERb2SO
         A3oIhdfIJiOQ6A7/CKMsmzcVnYaxfs20zuzTKg7y1OVDHP0c9nc0W0jP3qGhbrcuqJcx
         xnpEt9lIDXat8p7mb/r5BBHoCz7xIe1OpY3hIraW6OhbVV4Vf8NIXk/Fbkmm969wx9kb
         GhxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776845871; x=1777450671;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ed8qgQLZgWWqPjz4Cxq94KupWeY98Dp7kKiY+uA66so=;
        b=lC2FYyaZ/HibyP6Nv3i8Osv1n29PvYkUIx0zxJj6kWVP5jKcNCAQMUuUX6prCoVUXS
         mWv7e7o5LxYfcSgSoY8Z828WLs/FZ1hRkXcPiwLh4n9qT1g7++Qusk/DAVfMEUKjAht4
         cbg+tY3BBC74hAr9b4pelqvGvJe5lfuy7X2NZngkOVlAt3/jwyPdynmzIRWC71gJZTeS
         8lH4II+Kh97qVEoVyUSwZlfqO7Ml0q0Q5SE6NJCRtGKHWtEBtMs3xOR5zvoNM+qC46j+
         k0WCCUDeymaGdG5P1PY+yOM8vJJjvb5fX928uhqdszHK+WbwEvitutRwJ+njE7bEgUdg
         t4dw==
X-Forwarded-Encrypted: i=1; AFNElJ+vDMOdcAWT08zf3YFGft4I0/8Vc3Ch8BuX2DiwvirP/ezgfkJYUQA/LJ+R2kU4DwNBvJWfBI6LSiNqcA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzday5CetX3mzyiT96S3OKBkGHH6OSEKUNTKDW1ihRi6mnL0lRu
	5tOlczfp9lK8BddIqhWQSQZSXmcWxP/CoCIN4TZKX1Js3CSdx2gTyxEAcahdrTM8OSZc6fZpYKJ
	PTZDIXZ8yRJ5kCuSifq9pIXgX+GcM64U3dStGVX6USg==
X-Gm-Gg: AeBDiesPTOpg8C9picNDd9BxQhrE7EirtN04uQXsDjymQllz6fHcPrO7ls2ZhkRB+dY
	+OLccScZlKidrmUHE/pxQ38rLq5ngrJZs/SlwcS1i2415+mGDMLJVwC/e5DNenp/TLuqRzoajop
	Y5l751Z12CMknBpRkHz7vdoNU5HzOOuKRUlbdlpjC0XVBllIZm2mkr4yECWtLM2ESbrbFGVLVaw
	pCE4t1KXYxcmiZPXRhPj0+XqmmR1EkYCmc2InxdS3AMDgoUYFmAYZfs4J7ArjkAoxTRKTvzM6ar
	S7kOqc7ijYiYqL2cCQTg9W3GFkGEeW57LrU4P+uzwGPKyMK1VCvwpZDyWNPwCabfKgyAaMcMRsh
	bGGqJQRaj2Hje8WU=
X-Received: by 2002:a05:6000:2909:b0:43d:7403:4b65 with SMTP id
 ffacd0b85a97d-43fe3dbee20mr32442989f8f.6.1776845871298; Wed, 22 Apr 2026
 01:17:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206182336.1397715-1-neelx@suse.com> <20260206182336.1397715-2-neelx@suse.com>
 <20260221221153.GA2123@quark>
In-Reply-To: <20260221221153.GA2123@quark>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 22 Apr 2026 10:17:40 +0200
X-Gm-Features: AQROBzDRf6dW9hhOiPElzRm0HdywL3iGKud30yy3mnFfjH0N645a-533K3fMPn0
Message-ID: <CAPjX3FficsLf2QXFU70sR6PN7h8rj5opz_wntLm+Acd3YLvu+A@mail.gmail.com>
Subject: Re: [PATCH v6 01/43] fscrypt: add per-extent encryption support
To: Eric Biggers <ebiggers@kernel.org>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>, 
	linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 21 Feb 2026 at 23:11, Eric Biggers <ebiggers@kernel.org> wrote:
> I lost all my original comments on this patch due to a computer crash,
> so apologies if this sounds a bit rushed.  (I should know better than to
> run the latest mainline kernel.  Would be nice if kernel developers
> focused on quality over new features...)

Oh, and I somehow missed this email in my mailbox :-/
I'm sorry about the late reply.

> > +/*
> > + * fscrypt_extent_context - the encryption context of an extent
> > + *
> > + * This is the on-disk information stored for an extent.  The nonce is used as a
> > + * KDF input in conjuction with the inode context to derive a per-extent key for
> > + * encryption.
> > + *
> > + * With the current implementation, master_key_identifier and encryption mode
> > + * must match the inode context.  These are here for future expansion where we
> > + * may want the option of mixing different keys and encryption modes for the
> > + * same file.
> > + */
>
> Above comment should document that this is used only when the filesystem
> uses per-extent encryption

Good point. I'll amend that.

> > +/**
> > + * fscrypt_set_bio_crypt_ctx_from_extent() - prepare a file contents bio for
> > + *                                        inline crypto with extent
> > + *                                        encryption
> > + * @bio: a bio which will eventually be submitted to the file
> > + * @ei: the extent's crypto info
> > + * @first_lblk: the first file logical block number in the I/O
>
> first_lblk probably should be 'pos' to match Christoph's pending patches
> (https://lore.kernel.org/linux-fscrypt/20260218061531.3318130-1-hch@lst.de).
> Either way, it also needs to be correctly documented to be an offset
> into the extent, not the file.

Noted, I'll clean it up for the next version.

> > + * If the contents of the file should be encrypted (or decrypted) with inline
> > + * encryption, then assign the appropriate encryption context to the bio.
>
> Above comment was copy-pasted and is misleading in its new context.
> This function assigns the encryption context unconditionally.

With the above cleanup I rather ended up fixing this in the code. For
some reason, the condition was added later in the series in the
btrfs-specific helper code which I removed and I put the condition
right here.

> > + * Normally the bio should be newly allocated (i.e. no pages added yet), as
> > + * otherwise fscrypt_mergeable_bio() won't work as intended.
>
> Likewise, copy-pasted comment that is misleading in the new context.
> It should refer to fscrypt_mergeable_extent_bio().

Yeah, I also noticed. Agreed and fixed.

> > +void fscrypt_set_bio_crypt_ctx_from_extent(struct bio *bio,
> > +                                        const struct fscrypt_extent_info *ei,
> > +                                        u64 first_lblk, gfp_t gfp_mask)
> > +{
> > +     u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE] = { first_lblk };
>
> Above needs to calculate the DUN correctly when the data unit size is
> less than the file logical block size, or else the combination of
> sub-block data units and per-extent encryption needs to be explicitly
> not supported.  Probably just the latter for now (it can be enforced by
> fscrypt_supported_v2_policy()).

With the above cleanup I replaced `first_lblk` with `pos >>
key->data_unit_size_bits`.
Though this still doesn't look endian-safe to me.

Note, per-extent encryption is only supported with the v2 policy.

> > +/**
> > + * fscrypt_mergeable_extent_bio() - test whether data can be added to a bio
> > + * @bio: the bio being built up
> > + * @ei: the fscrypt_extent_info for this extent
> > + * @next_lblk: the next file logical block number in the I/O
> > + *
> > + * When building a bio which may contain data which should undergo inline
> > + * encryption (or decryption) via fscrypt, filesystems should call this function
> > + * to ensure that the resulting bio contains only contiguous data unit numbers.
> > + * This will return false if the next part of the I/O cannot be merged with the
> > + * bio because either the encryption key would be different or the encryption
> > + * data unit numbers would be discontiguous.
> > + *
> > + * fscrypt_set_bio_crypt_ctx_from_extent() must have already been called on the
> > + * bio.
> > + *
> > + * This function isn't required in cases where crypto-mergeability is ensured in
> > + * another way, such as I/O targeting only a single file (and thus a single key)
> > + * combined with fscrypt_limit_io_blocks() to ensure DUN contiguity.
> > + *
> > + * Return: true iff the I/O is mergeable
> > + */
> > +bool fscrypt_mergeable_extent_bio(struct bio *bio,
> > +                               const struct fscrypt_extent_info *ei,
> > +                               u64 next_lblk)
> > +{
> > +     const struct bio_crypt_ctx *bc = bio->bi_crypt_context;
> > +     u64 next_dun[BLK_CRYPTO_DUN_ARRAY_SIZE] = { next_lblk };
> > +
> > +     if (!ei)
> > +             return true;
> > +     if (!bc)
> > +             return true;
> > +
> > +     /*
> > +      * Comparing the key pointers is good enough, as all I/O for each key
> > +      * uses the same pointer.  I.e., there's currently no need to support
> > +      * merging requests where the keys are the same but the pointers differ.
> > +      */
> > +     if (bc->bc_key != ei->prep_key.blk_key)
> > +             return false;
> > +
> > +     return bio_crypt_dun_is_contiguous(bc, bio->bi_iter.bi_size, next_dun);
> > +}
> > +EXPORT_SYMBOL_GPL(fscrypt_mergeable_extent_bio);
>
> Similar to fscrypt_set_bio_crypt_ctx_from_extent().  The copy-pasted
> comment needs to be updated to remove no-longer-relevant information
> specific to per-file encryption and correctly reflect per-extent
> encryption.  The DUN needs to be calculated correctly for sub-block data
> units or else the combination of the two needs to be unsupported.

The DUN is fixed as per above. Regarding the comment, it looks quite
valid to me. What exactly would you like to change?

> > +static struct fscrypt_extent_info *
> > +setup_extent_info(struct inode *inode, const u8 nonce[FSCRYPT_FILE_NONCE_SIZE])
> > +{
> > +     struct fscrypt_extent_info *ei;
> > +     struct fscrypt_inode_info *ci;
> > +     struct fscrypt_master_key *mk;
> > +     u8 derived_key[FSCRYPT_MAX_RAW_KEY_SIZE];
> > +     int err;
> > +
> > +     ci = *fscrypt_inode_info_addr(inode);
> > +     mk = ci->ci_master_key;
> > +     if (WARN_ON_ONCE(!mk))
> > +             return ERR_PTR(-ENOKEY);
> > +
> > +     ei = kmem_cache_zalloc(fscrypt_extent_info_cachep, GFP_KERNEL);
> > +     if (!ei)
> > +             return ERR_PTR(-ENOMEM);
> > +
> > +     refcount_set(&ei->refs, 1);
> > +     memcpy(ei->nonce, nonce, FSCRYPT_FILE_NONCE_SIZE);
> > +     ei->sb = inode->i_sb;
> > +
> > +     down_read(&mk->mk_sem);
> > +     /*
> > +      * We specifically don't check ->mk_present here because if the inode is
> > +      * open and has a reference on the master key then it should be
> > +      * available for us to use.
> > +      */
>
> Above comment should be reworded to clarify that it is expected for
> ->mk_present to be either true or false here.  As-is, it can be
> interpreted as meaning that checking ->mk_present is unnecessary because
> it is guaranteed to be true.

OK, I'll state that explicitly.

> The comment above struct fscrypt_master_key (which documents the
> different states the master key can be in) also needs to be updated to
> document that with filesystems that use per-extent encryption,
> ->mk_secret isn't wiped when the key is in the incompletely-removed
> state (and why that needs to be the case).

Right. I'll amend this in the respective patch.

> > +/**
> > + * fscrypt_prepare_new_extent() - prepare to create a new extent for a file
> > + * @inode: the possibly-encrypted inode
> > + *
> > + * If the inode is encrypted, setup the fscrypt_extent_info for a new extent.
> > + * This will include the nonce and the derived key necessary for the extent to
> > + * be encrypted.  This is only meant to be used with inline crypto and on inodes
> > + * that need their contents encrypted.
> > + *
> > + * This doesn't persist the new extents encryption context, this is done later
> > + * by calling fscrypt_set_extent_context().
> > + *
> > + * Return: The newly allocated fscrypt_extent_info on success, -EOPNOTSUPP if
> > + *      we're not encrypted, or another -errno code
> > + */
> > +struct fscrypt_extent_info *fscrypt_prepare_new_extent(struct inode *inode)
> > +{
> > +     u8 nonce[FSCRYPT_FILE_NONCE_SIZE];
> > +
> > +     if (WARN_ON_ONCE(!*fscrypt_inode_info_addr(inode)))
> > +             return ERR_PTR(-EOPNOTSUPP);
> > +     if (WARN_ON_ONCE(!fscrypt_inode_uses_inline_crypto(inode)))
> > +             return ERR_PTR(-EOPNOTSUPP);
> > +
> > +     get_random_bytes(nonce, FSCRYPT_FILE_NONCE_SIZE);
> > +     return setup_extent_info(inode, nonce);
> > +}
> > +EXPORT_SYMBOL_GPL(fscrypt_prepare_new_extent);
>
> Similarly, there seems to have been a lot of incorrect copy+pasting in
> the function comment.  This new function requires that the caller *must*
> provide an encrypted inode, otherwise it WARNs.  It can't be
> "possibly-encrypted".

That is indeed true.

> > +/**
> > + * fscrypt_load_extent_info() - create an fscrypt_extent_info from the context
> > + * @inode: the inode
> > + * @ctx: the context buffer
> > + * @ctx_size: the size of the context buffer
> > + *
> > + * Create the fscrypt_extent_info and derive the key based on the
> > + * fscrypt_extent_context buffer that is provided.
> > + *
> > + * Return: The newly allocated fscrypt_extent_info on success, -EOPNOTSUPP if
> > + *      we're not encrypted, or another -errno code
> > + */
> > +struct fscrypt_extent_info *fscrypt_load_extent_info(struct inode *inode,
> > +                                                  u8 *ctx, size_t ctx_size)
>
> ctx should have type 'const u8 *'

Agreed.

> > +/**
> > + * fscrypt_set_extent_context() - Set the fscrypt extent context of a new extent
> > + * @inode: the inode this extent belongs to
> > + * @ei: the fscrypt_extent_info for the given extent
> > + * @buf: the buffer to copy the fscrypt extent context into
> > + *
> > + * This should be called after fscrypt_prepare_new_extent(), using the
> > + * fscrypt_extent_info that was created at that point.
> > + *
> > + * buf must be at most FSCRYPT_SET_CONTEXT_MAX_SIZE.
> > + *
> > + * Return: the size of the fscrypt_extent_context, errno if the inode has the
> > + *      wrong policy version.
> > + */
> > +ssize_t fscrypt_context_for_new_extent(struct inode *inode,
> > +                                    struct fscrypt_extent_info *ei, u8 *buf)
> > +{
> > +     struct fscrypt_extent_context *ctx = (struct fscrypt_extent_context *)buf;
> > +     const struct fscrypt_inode_info *ci = *fscrypt_inode_info_addr(inode);
> > +
> > +     BUILD_BUG_ON(sizeof(struct fscrypt_extent_context) >
> > +                  FSCRYPT_SET_CONTEXT_MAX_SIZE);
> > +
> > +     if (WARN_ON_ONCE(ci->ci_policy.version != 2))
> > +             return -EINVAL;
> > +
> > +     ctx->version = FSCRYPT_EXTENT_CONTEXT_V1;
> > +     ctx->encryption_mode = ci->ci_policy.v2.contents_encryption_mode;
> > +     memcpy(ctx->master_key_identifier,
> > +            ci->ci_policy.v2.master_key_identifier,
> > +            sizeof(ctx->master_key_identifier));
> > +     memcpy(ctx->nonce, ei->nonce, FSCRYPT_FILE_NONCE_SIZE);
> > +     return sizeof(struct fscrypt_extent_context);
> > +}
> > +EXPORT_SYMBOL_GPL(fscrypt_context_for_new_extent);
>
> The documentation "buf must be at most FSCRYPT_SET_CONTEXT_MAX_SIZE" is
> incorrect.  It must actually be *at least* the size of
> 'struct fscrypt_extent_context'.

I see. While this looks like a typo, I understand it was meant to say
that it should never need to be more than that.
Perhaps something like this can be better worded:

@@ -812,7 +812,7 @@ EXPORT_SYMBOL_GPL(fscrypt_set_context);
  * This should be called after fscrypt_prepare_new_extent(), using the
  * fscrypt_extent_info that was created at that point.
  *
- * buf must be at most FSCRYPT_SET_CONTEXT_MAX_SIZE.
+ * buf should be able to fit up to FSCRYPT_SET_CONTEXT_MAX_SIZE bytes.
  *
  * Return: the size of the fscrypt_extent_context, errno if the inode has the
  *        wrong policy version.

> Given that it's a fixed size, it probably would make sense to make the
> ouptut parameter reflect that: 'u8 out[FSCRYPT_EXTENT_CONTEXT_SIZE]'.
> Or even just use the struct itself.

Yeah, this looks like more of a future-proof feature. While the size
is fixed now, if we ever need to define a FSCRYPT_EXTENT_CONTEXT_V2
with different on-disk format (and size) we can still keep this very
same API.

> > +     /*
> > +      * If set then extent based encryption will be used for this file
> > +      * system, and fs/crypto/ will enforce limits on the policies that are
> > +      * allowed to be chosen.  Currently this means only plain v2 policies
> > +      * are supported.
> > +      */
> > +     unsigned int has_per_extent_encryption : 1;
>
> Needs clarification about what is meant by "plain".  Some flags are
> supported (specifically the filename padding ones), some flags are not.
> All encryption modes still seem to be supported.

Maybe this?:

@@ -144,8 +144,8 @@ struct fscrypt_operations {
     /*
      * If set then extent based encryption will be used for this file
      * system, and fs/crypto/ will enforce limits on the policies that are
-     * allowed to be chosen.  Currently this means only plain v2 policies
-     * are supported.
+     * allowed to be chosen.  Currently this means only v2 policies and a
+     * limited flags are supported.
      */
     unsigned int has_per_extent_encryption : 1;


>
> > +     if (count > 0 && inode->i_sb->s_cop->has_per_extent_encryption) {
> > +             fscrypt_warn(inode,
> > +                          "Encryption flags aren't supported on file systems that use extent encryption");
> > +             return false;
> > +     }
>
> Similarly, this error message needs clarification.  Some encryption
> flags are supported, some aren't.

Right. This should sound better:

@@ -248,7 +248,7 @@ static bool fscrypt_supported_v2_policy(const
struct fscrypt_policy_v2 *policy,
     count += !!(policy->flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32);
     if (count > 0 && inode->i_sb->s_cop->has_per_extent_encryption) {
         fscrypt_warn(inode,
-                 "Encryption flags aren't supported on file systems
that use extent encryption");
+                 "DIRECT_KEY and IV_INO_LBLK_* encryption flags
aren't supported on file systems that use extent encryption");
         return false;
     }
     if (count > 1) {

Thanks for looking into it.

--nX

> - Eric
