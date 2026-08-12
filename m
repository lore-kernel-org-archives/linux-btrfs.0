Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1342F8E8F
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2026 12:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786538071; cv=pass; b=XIGfTe6VGsBwmOdMZ68N8q8xp+og3mSwTbWCflr54fCQaobl9DqbDSucDTsDMPQmsm76uH82qGeUha8y6tiPJmZbI07z6l2QMhgWfdDMNtpZizfS0XP2sa6UNkaXLUrgFZjNhA76c1TBRYkocThfyGyKf20ec8zZRBtUC5h5NBs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786538071; c=relaxed/simple;
	bh=mrOZn5cMBgBkTmxJvPXerAODjZxJShf/148YuJ6IEXg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E2Ig2KubTUt9nco2VAVS5CYJhrUNgicLqAArIlxbUdrEuhgM+pO3y7ljkLFUr32+qNYR7OwHS/3VgqP1YHpvV8Vd4ZQvnIMJZWA5ZZ9FGA3Y7BsIu2rxQc4epXwwqh6MFrBoGjqwYPfXWmgPCzHkfA3723f6+7sN0Kro0x0jxz0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dwVIh00t; arc=pass smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dwVIh00t"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-47f703a9e5dso426156f8f.0
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2026 05:34:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786538067; cv=none;
        d=google.com; s=arc-20260327;
        b=aZAZZP+sQvHRUbOFFr0nyym2Ccsf70GnmssgllyM8yGGHu/KHfts8P+yyoMMm1OAt8
         iKQGS+5OwOv+y2KkkBtPjPc5nDt3dem7ji1KahRH8zLQk5vQJ5/iXlRWcBdp0qh5bomL
         5p2t12gpXYf/Mymo1PCtf9r+OAbzgygHTSO+AHlsqqKIk9T98ur9N8jZGQEhE33lIJ6W
         ZDXOZRF65OVO1l/51Wheyq/gasYy13fIDpAFIM2DJIqkqLfTe7cUuzpApYLaWm9Ttrdp
         RWPn2rPyD9n2sDRMTmm8uYgNRzw+3nHVx0t7bv8YLpUFf+NtYBOJ5jFJBXgPVmuV5hhH
         H3Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=TBNKU7ZE2LSdhYyJUE7G5IOGyqcEFX6KHdz6ddJ3YBI=;
        fh=GKjAlugHpfRSmLK7+3aeFbiZeSb4KEYjtCnIbsTdDhQ=;
        b=fjSDpy/0YcF7PlA5sTJBHym8ZmMeWO/rZztfksMmhHemWvoamPAr++ofueWknZ3zAW
         hOMuqYKEUZ9RvLCFIuuDHlCAyYljwRY8vo0GsGdjtUFz1w2YMvq1yn10ktMsreXTYhez
         nbn4Ng3JZcHMVyHIk1IF/jOXf4Wu9bDe56vuE9Vj36Se/OqkGr1nuHXu+b+HI70e+Qr6
         6nXbz8b5g1Un+TtNYUWgZhGuhvzpJbYQQ7ztPXCavllPSMhEkM/DwydKpPOH+Eoc1qYp
         zwOB5UUavkOwaIOea1xoZuYBhg45tobKqUL7AxjJ+1rHnWn1fFoG66dIhgCLdDAR4pt3
         GqFA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786538067; x=1787142867; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TBNKU7ZE2LSdhYyJUE7G5IOGyqcEFX6KHdz6ddJ3YBI=;
        b=dwVIh00td1tPqV6rgJAND1gavykKruH33Fsw5njZ0pvUNFqOCfxZFKu2TN5wsoaiNl
         0wwcO6s9jArADkfj9bxiJ7WiF9SsAu5Ic0jZ6Mc7hcs7pRyOaGjpaCgO3tkTS/jxlFbW
         JknEwzj7sAsPujsielpSlB/exgoqJnkpSWy9T3PcmjyRH7wo5ZiHhBhrYBZN1odyzmeE
         ktsHp4KmUFrJ8Ul9s7GXWKjYYWs+hOrpxDgdqFu+XGsUBK8KenEi4mqPchjL/KpDlZXx
         P3PFEjFm/+/lqh5gdZ2aKmymEi3caqbayLRie2Pk8zd+SSMPyxy1zw/fXE0n9gHiD9IR
         xSVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786538067; x=1787142867;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=TBNKU7ZE2LSdhYyJUE7G5IOGyqcEFX6KHdz6ddJ3YBI=;
        b=N4YdFTBTCBelaTMFImFGRhwoiAbUXm0zPN+qAsplsY+RW+0dQ8i2tK7FOFF2lD8j9B
         8tOAufaHc2X7VMKkQW+HoqDhvYiTEtyhB0a40LI3PHJfp0gOs0DQZm9HwU1bxemAwSQT
         jKjB5t0EwFZ3CiIW95q9TDa4nssKnvoyjAaTyKJqWPBqR3ivtThoj2nj5ahmxpOt3/c6
         NNf2iY8g/bpisRd8pEOotgs0SAMjOpEeKjUoWAkBEkzVZTr2B/Sn2LIbZ9fNCehYb8jk
         uUTLZAnmTgLXXtvsjWf9S2XH7dKLlmUDXpJacK0RVRB7oi6x5iyT4r/ztSBJojiwKddd
         hc1Q==
X-Forwarded-Encrypted: i=1; AHgh+Rpkon/8hFIAU0o0y90RoUYrL/hS6IJomzkMTKKy2Y2h9oq37/kQg/KyvS6GXZLNuHXF2BG9eTJv5ny5Xg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7G8KJY81sFWPtC4AF4pEe6QCZumwG6s/0mm3tLLKBYoXtO41Z
	ukDRZkSmZveBQGQHsL/VyIdVO8FgnIpT/9riUibNGrGCn9i4C4ijn7HqSeYlprUw/Bfb5tk7alL
	f/xUO3csbGd3/VPOeVCJjF+NzD2E6IDQrLxQUuO1r+6USrX1Wc7fDBj4=
X-Gm-Gg: AR+sD12IBsPTHRlqS9cwVcSLkcYVnUn9eGeiiv1r9k36hH2FO10hJC85Iwi5a9nATn2
	ENJzkSNJJoO8MRAOZMqQB0JzSB6+cdeWqYzbQphe2ozbDOrnhA11IldhJ15KzxJ9ORgT0fakb+H
	Y2J5adYRrCZURr1Mj8jnOs4ESUmf0UPjNcGGz/efL2qXJU1C4Nk+c8jTeKZPfMptSsGYJmOlyLP
	D1f0u7bDUamuFZkxeDRHg4VLzTQfrB5onB1ditQNIn2DKYbCAg3VgU6aGbO63b2Vju4l38dNYw5
	L0PL4tvOTpC0ai8tof6q/vriUXLJJdM3ckMyXdbk9KWebVji2AsZNAhMRZlcV7U1sxbsBAweEMk
	fW9HTaAPZ9JxLwmlEZy218Rq/wn+ATF+4vYYuReBhBA==
X-Received: by 2002:a05:6000:982:b0:47e:9f16:c0bf with SMTP id
 ffacd0b85a97d-48152c892c8mr6794932f8f.30.1786538067366; Wed, 12 Aug 2026
 05:34:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513085340.3673127-1-neelx@suse.com> <20260513085340.3673127-2-neelx@suse.com>
 <20260601224431.GA25574@quark> <CAPjX3Fe4yfrOWjZa-pW2AhBNG=6sfcrt82a8C9_cBzA5BkUbEg@mail.gmail.com>
In-Reply-To: <CAPjX3Fe4yfrOWjZa-pW2AhBNG=6sfcrt82a8C9_cBzA5BkUbEg@mail.gmail.com>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 12 Aug 2026 14:34:16 +0200
X-Gm-Features: AUfX_mz9_9I_V7Suqp4uWFJciR3Fb6lbIm7Ta-rdfcxGsoSYznyaiSoQLpIf-es
Message-ID: <CAPjX3Ff5_EaAVJv++_huk3Uw5sjJ5QfoZm0DzJx_UdObNChuiw@mail.gmail.com>
Subject: Re: [PATCH v7 01/43] fscrypt: add per-extent encryption support
To: Eric Biggers <ebiggers@kernel.org>, Josef Bacik <josef@toxicpanda.com>
Cc: Chris Mason <clm@fb.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 12 Aug 2026 at 12:34, Daniel Vacek <neelx@suse.com> wrote:
> On Tue, 2 Jun 2026 at 00:44, Eric Biggers <ebiggers@kernel.org> wrote:
> > On Wed, May 13, 2026 at 10:52:35AM +0200, Daniel Vacek wrote:
> > > From: Josef Bacik <josef@toxicpanda.com>
> > >
> > > This adds the code necessary for per-extent encryption.  We will store a
> > > nonce for every extent we create, and then use the inode's policy and
> > > the extents nonce to derive a per-extent key.
> > >
> > > This is meant to be flexible, if we choose to expand the on-disk extent
> > > information in the future we have a version number we can use to change
> > > what exists on disk.
> > >
> > > The file system indicates it wants to use per-extent encryption by
> > > setting s_cop->has_per_extent_encryption.  This also requires the use of
> > > inline block encryption.
> > >
> > > The support is relatively straightforward, the only "extra" bit is we're
> > > deriving a per-extent key to use for the encryption, the inode still
> > > controls the policy and access to the master key.
> > >
> > > Since extent based encryption uses a lot of keys, we're requiring the
> > > use of inline block crypto if you use extent-based encryption.  This
> > > enables us to take advantage of the built in pooling and reclamation of
> > > the crypto structures that underpin all of the encryption.
> >
> > The whole reason for extent-based encryption is that extents can be
> > shared between inodes.  So the repeated mentions of "the inode" are
> > really confusing.  This shows up in a lot of different places.
> >
> > What's actually implemented is that each extent stores its own
> > (encryption_mode, master_key_identifier, nonce), but for now the
> > invariant is maintained that all inodes that reference an extent share
> > the same (encryption_mode, master_key_identifier) as the extent.
> >
> > It would be helpful to document this stuff accordingly.
>
> Yeah, that makes sense. I believe this is what we want - any file is
> unlocked by one key. Not that you would need multiple keys for
> unlocking different parts of a file.
>
> > > +/*
> > > + * fscrypt_extent_context - the encryption context of an extent
> > > + *
> > > + * This is the on-disk information stored for an extent.  The nonce is used as a
> > > + * KDF input in conjuction with the inode context to derive a per-extent key for
> > > + * encryption.  This is used only when the filesystem uses per-extent encryption.
> > > + *
> >
> > Basically the same issue here.  The master_key_identifier is actually
> > stored in the extent.  Just the current implementation enforces that
> > when the filesystem accesses the extent through some inode, that inode
> > also has the same master_key_identifier.  How about replacing the second
> > sentence with something like: "The nonce and master_key_identifier are
> > used to derive the key which encrypts the extent."
>
> Right, this sounds better.
>
> > > + * With the current implementation, master_key_identifier and encryption mode
> > > + * must match the inode context.  These are here for future expansion where we
> > > + * may want the option of mixing different keys and encryption modes for the
> > > + * same file.
> > > + */
> >
> > Likewise.  Something like: With the current implementation,
> > master_key_identifier and encryption_mode always match the corresponding
> > values from the fscrypt_context in each inode that shares the extent.
>
> Do we actually want this freedom or should we drop the encryption_mode
> and master_key_identifier and consider them implicit from
> inode/fscrypt_context?
> That would mean storing only the nonce in the extent context. The
> version field still remains, preserving the flexibility to eventually
> add them back later if we decide to.
>
> > > +struct fscrypt_extent_context {
> > > +     u8 version; /* FSCRYPT_EXTENT_CONTEXT_V1 */
> > > +     u8 encryption_mode;
> > > +     u8 master_key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];
> > > +     u8 nonce[FSCRYPT_FILE_NONCE_SIZE];
> > > +};
> >
> > Well, it's an extent nonce, not a file nonce.  It seems it's handled
> > completely separately from the existing file nonce, so it probably
> > should get its own size constant FSCRYPT_EXTENT_NONCE_SIZE.
>
> This actually sounds more confusing to me. They are both the same
> thing. My understanding was that extent is "kind of file" on it's own.
> If anything I'd argue for FSCRYPT_NONCE_SIZE used in both places. But
> a FSCRYPT_FILE_NONCE_SIZE used in inode context as well as in extent
> context sounds fine to me.
>
> > > +/**
> > > + * fscrypt_set_bio_crypt_ctx_from_extent() - prepare a file contents bio for
> > > + *                                        inline crypto with extent
> > > + *                                        encryption
> > > + * @bio: a bio which will eventually be submitted to the file
> > > + * @ei: the extent's crypto info
> >
> > @ei: the extent's crypto info, or NULL if the extent is unencrypted
>
> True, the @ei is optional. I'll fix that.
>
> > > + * If the contents of the file should be encrypted (or decrypted) with inline
> > > + * encryption, then assign the appropriate encryption context to the bio.
> >
> > "If the contents of the file should be encrypted (or decrypted) with
> > inline encryption" => "If the extent should be encrypted (or decrypted)"
> >
> > There's no "file" here.  And inline encryption is the only option for
> > extents.
>
> OK.
>
> > > +/**
> > > + * fscrypt_mergeable_extent_bio() - test whether data can be added to a bio
> > > + * @bio: the bio being built up
> > > + * @ei: the fscrypt_extent_info for this extent
> >
> > @ei: the extent's crypto info, or NULL if the extent is unencrypted
>
> True.
>
> > > + * @pos: the next extent logical offset (in bytes) in the I/O
> > > + *
> > > + * When building a bio which may contain data which should undergo inline
> > > + * encryption (or decryption) via fscrypt,
> >
> > When building a bio which may contain data which should undergo extent
> > encryption (or decryption)
>
> Ack.
>
> > > +static struct fscrypt_extent_info *
> > > +setup_extent_info(struct inode *inode, const u8 nonce[FSCRYPT_FILE_NONCE_SIZE])
> > > +{
> > > +     struct fscrypt_extent_info *ei;
> > > +     struct fscrypt_inode_info *ci;
> > > +     struct fscrypt_master_key *mk;
> > > +     u8 derived_key[FSCRYPT_MAX_RAW_KEY_SIZE];
> > > +     int keysize;
> > > +     int err;
> > > +
> > > +     ci = *fscrypt_inode_info_addr(inode);
> >
> > fscrypt_get_inode_info_raw()
>
> That would add a useless VFS_WARN_ON_ONCE() which will never trigger;
> otherwise, the next line would crash.
> But I guess that's OK.
>
> > > +/**
> > > + * fscrypt_prepare_new_extent() - prepare to create a new extent for a file
> > > + * @inode: the encrypted inode
> > > + *
> > > + * If the inode is encrypted, setup the fscrypt_extent_info for a new extent.
> > > +
> > > + * This will include the nonce and the derived key necessary for the extent to
> > > + * be encrypted.  This is only meant to be used with inline crypto and on inodes
> > > + * that need their contents encrypted.
> >
> > This is ambiguous and contradictory about what type of @inode is
> > required.  It should be something like:
> >
> > * @inode: an encrypted regular file with its key already set up, on a
> > *        filesystem that uses per-extent encryption
> > *
> > * Prepare to encrypt a new extent by generating a new extent nonce,
> > * deriving an extent key, and allocating an fscrypt_extent_info.
>
> OK.
>
> > > * This doesn't persist the new extents encryption context, this is done later
> > > * by calling fscrypt_set_extent_context().
> >
> > There's no function with that name
>
> That should be fscrypt_context_for_new_extent(). I see it was renamed
> in v5 but this one (and the one below) was forgotten.
> Will fix.
>
> > > +     if (WARN_ON_ONCE(!*fscrypt_inode_info_addr(inode)))
> > > +             return ERR_PTR(-EOPNOTSUPP);
> > > +     if (WARN_ON_ONCE(!fscrypt_inode_uses_inline_crypto(inode)))
> > > +             return ERR_PTR(-EOPNOTSUPP);
> >
> > I'm confused what these checks are trying to do.  The first part checks
> > for the inode's encryption key, but setup_extent_info() does that
> > anyway.
>
> setup_extent_info() dereferences ci right away. Without this check it
> would crash if the inode was not encrypted.
>
> > ... The second part is maybe intended to check that the file uses
> > extent encryption, but it doesn't do it correctly.  That would require:
> > fscrypt_needs_contents_encryption(inode) &&
> > inode->i_sb->s_cop->has_per_extent_encryption.
>
> This may be better. The comment says this is only meant to be used
> with inline crypto but that actually looks fishy. We ensure this in
> btrfs but fscrypt itself does not need to.
>
> > It probably would make sense to check that directly in
> > setup_extent_info(), so that it's closer to the call to
> > fscrypt_hkdf_expand() which would has a *very* bad failure mode when
> > !has_per_extent_encryption.
>
> I think it makes sense to check before consuming entropy.
> setup_extent_info() can have a second check if needed, though perhaps
> it was not needed so far?
>
> > > +/**
> > > + * fscrypt_load_extent_info() - create an fscrypt_extent_info from the context
> > > + * @inode: the inode
> > > + * @ctx: the context buffer
> > > + * @ctx_size: the size of the context buffer
> > > + *
> > > + * Create the fscrypt_extent_info and derive the key based on the
> > > + * fscrypt_extent_context buffer that is provided.
> > > + *
> > > + * Return: The newly allocated fscrypt_extent_info on success, -EOPNOTSUPP if
> > > + *      we're not encrypted, or another -errno code
> > > + */
> >
> > What context is this expected to be called in?  I see the caller uses
> > memalloc_nofs_save().  This would require making ->mk_sem nofs-safe; is
> > there a plan to do that?  (Sashiko noticed this too, by the way.)
>
> Honestly, I have to admit I was puzzled by Sashiko's explanation and I
> did not trust it. It sounded rather off.
>
> Trying to dig up the origin of that memalloc_nofs_save() - it is there
> since the very beginning of Josef's [v1] posting. This was around the
> time of Linux v6.6 but the code is still similar.
> So far I don't see if it is really needed or why it was implemented
> this way in the first place. It is called from
> btrfs_do_readpage()->btrfs_get_extent() to set up the key context.
> IIUC, this should not be called from a reclaim path. Hence, I think
> that that memalloc_nofs_save() is redundant and it should be OK to
> simply remove it.

And removing it and testing with stress-ng induced memory pressure
seems to confirm the memalloc_nofs_save() is not needed in this code
path.

@Josef: By any chance, do you recall why this was originally put in?

--nX

> [v1] https://lore.kernel.org/linux-btrfs/de7dec18d4dd440ebf3c538af5c765d747e1d3ef.1695750478.git.josef@toxicpanda.com/
>
> > > +     const struct fscrypt_inode_info *ci = *fscrypt_inode_info_addr(inode);
> >
> > fscrypt_get_inode_info_raw(inode)
>
> OK.
>
> > > +/**
> > > + * fscrypt_set_extent_context() - Set the fscrypt extent context of a new extent
> >
> > It seems the function name and semantics changed at some point, but the
> > kerneldoc wasn't updated.
>
> As mentioned above, I see V4 -> v5 rename. No semantics changes.
>
> > > + * @inode: the inode this extent belongs to
> >
> > The inode that the extent will initially belong to, I guess?
>
> Yes, at this point it's a new extent for this inode.
>
> > > +ssize_t fscrypt_context_for_new_extent(struct inode *inode,
> > > +                                    struct fscrypt_extent_info *ei, u8 *buf)
> > > +{
> > > +     struct fscrypt_extent_context *ctx = (struct fscrypt_extent_context *)buf;
> > > +     const struct fscrypt_inode_info *ci = *fscrypt_inode_info_addr(inode);
> >
> > fscrypt_get_inode_info_raw(inode)
>
> Again, adds an useless WARN_ON_ONCE, but won't hurt.
>
> Thanks!
>
> --nX
>
> > - Eric
