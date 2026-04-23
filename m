Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6C13A168C
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2026 06:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776926752; cv=pass; b=D/w/YfMqCvrYTdQSCy8sJFGFmAr4Ida3aKgP0NIqf5osHtoGb16GzM1pa2mXQtRW1hwvG/xDOTjvSqyaAJfhpuhkQH3jNyrh03ScWCcugDPz5T57UXBGC/6Y/ul82aGLu6YyNN9CONWzxsYKiWncjgIEvlBC8iItOYebSaFX5l8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776926752; c=relaxed/simple;
	bh=VoW/jBNfb743v0Rg9HRnbEDd8rmyiFM2HQb/i/qQDkw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jMr5GJa4W9+4qisf+9jdfp0Y/clxAattgzsbwGIc9wUDG+f0LsaLDf/7i2yl++utwUNpb4hnaJ8NjM5+D5aGj8YNcAxTd8Ssby6SlDwezf5j+SOon/gpIFTG/XjWR+dMcLtpJIxJL/2r52XBZxA1tHL6zTiUCR+2NDtv2nLtOtA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SzKTEfuc; arc=pass smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SzKTEfuc"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-48a3e9862f0so27386195e9.1
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2026 23:45:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776926749; cv=none;
        d=google.com; s=arc-20240605;
        b=c13b1JiMM5sHYfMvwbI7Rtdru7rgS+4Ifz4o5rEu6ee5x3TLblR5JsG6hUYJ2Mql3b
         UUoKe+1pWFsBW6CxppB+lrF7JYPTAuJ39Ct3mRghu2pM8Fg/YbNQbAXKfZYDp3P03xNV
         fft4QUQfLswRZRGFZtI6FoMY44wd6QHTnsaUfL0al3h7GnVhb06yF1dS5RoUpiZTf8kN
         yVhdUzvY8pAMhFFoEYNRnWyeRk77SZ+WdV6lVGfS2L++m+iGXCmH6kZ/zGs/+LTK+Lxa
         yYwMetedKH78i/mX79xyHS044r0jnhD5dE3SzhcGBVPA/eE614F6PlGnf2lJU2xe501e
         f7Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=VFx+EzwA27+TMrhv+NVPiNfgiU3/L9VD2VlgqAAxpWA=;
        fh=dYACLB9BCsDftDZHr3AFhT5/hvkLxCk3mE6yMuOWBrk=;
        b=eyRms6yBhJgcyIqnlPh7nHMNg8hC47b3hqWKdiMkATyfWBJUnxYd3nYTi4mNbxMEwS
         8ZE7R37+clck+41jgmSAmyb/VODFG5mH2fveu4oIKF3NJBMGM4k8BFQ67RXEik/+Yn94
         JL38egO/KvB0BjmGi4bLohsK4YxPVSRzU4BRMTIZkhnhsg2PUyM59i13cgn1E0ccjJYm
         12oM4ZUBdUWxaxLoqQJy9rvuZURPvUNVFklb1FCEt3mx83m54vClCRkpi6chMYAHecEk
         4gnhQLkbFN0dsDJ1F5rTNkud9wqbLlxV/OmDbO207RH+B1cwlYelEi4KXyc2N0oAs7r5
         eWng==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776926749; x=1777531549; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VFx+EzwA27+TMrhv+NVPiNfgiU3/L9VD2VlgqAAxpWA=;
        b=SzKTEfuc5t7Yfm0cnYEKYxlnYEfVvHxu5qKAkZ3DPCnVsknAYgW4TurCBPDZzvXu/N
         XQvs5+VPDq1orOE5HecPECrpLY2//2RsDtvckuql3sjOyT3Ma5B/tkxf81dVrOap733M
         Jdr2Ec4qQH+wpEAn7/ZXnRfXAugH87Yi40LV94YgI/cWIu7GKZodhrodWh8ZmG/VaInS
         1ArSpjSaIJ0u1Z6hr4OlTOKLmqUCb7GQ1LHjXYp4F0hux8fvM9rBYaWzA/HkLmyTyYM1
         gKxpTtI5YBmL9qXkOyXbrGDBV/JUwHNscB/hKFgf37tnjy87zYLRWKehlIE+5HfA9FiX
         D1mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776926749; x=1777531549;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VFx+EzwA27+TMrhv+NVPiNfgiU3/L9VD2VlgqAAxpWA=;
        b=kaUBNJkgiYYbKKyW8yABNNa/I/5oHwFum4ZnyGg84dBPsrw2AP+5Mz6sIH993ms23b
         5WWPRwDTRzhY9Kij93tfxddxgJccg1GuLHztP1wqlLV22aKiXDlG2tkAYfdC2TkCPQlA
         Dlt2f2i6mxJ04omC9J0lVQpZIl3dE/DAaAGlTFa8N5xXEzOutUZJjjpXvh4ghEIb1WMs
         Fa89R1EZfNzLd5U+9KcXUEXyfppKB4eoFUGqrXFRsK77Uu7YLqxKr6MDUhsNwdcrqE9L
         ON48NgsK7xaEMeEOVPPDtLHAJpTaKDEUJb81wFCkQkZsAl5nq+0kgr9CbtJYpV9o2ZTx
         qbdA==
X-Forwarded-Encrypted: i=1; AFNElJ9WgG6ZztGaqLPTWAO445DUG0/2AkYnzMfTh6lemCpVQzTOZgLhpVpqREmVUbE3XTaMj/AUVhKNXji6vQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0qIJeSoTgKwsHrWAbuWoinbK0tT6weny95zUiOEQXJJtWhvV3
	DxBANaegb8/U9sVKxKZ9a+XqFPNq4S8IlQ9ihSjW7K1Q8LVVPNVnHgOZNiY/OhhRTeUWGJ/cMq/
	DxVoglrQaMdLOh2wUTfSZdF7x5JcmMKi5HzIPEcgQug==
X-Gm-Gg: AeBDietjh1VF0y9f4vu3mPpLxYDJqNDY8Igrr8HQlbogoOw4MB+oP+Gwt6LA41x5/b6
	B/QvNZuATZv+PR0AY2f/xgaTuP36yw8GoQkIQcs+ee6Ma1LU6tAFWYflhIiGrplCRh1YgSyCfTV
	/B5gPMVBbzLH5CVbMTO/beXWkGgBEbxUz/CebUFQvAKfRK/CCUnkdcvouq6B3PMuK8lgjkRcKB2
	Rfbi2OOL0RCOhEXQzkV77QGmqgJmo4RyNBFk5BN3EPQbRvWw0WYbw9qTujY8ERUFQQ5nIJDDsPH
	4ChTwGkQPVdt2yuBSxYRtBi88i9tA/ajLwmT48Srit3qRgbHBSMA2fy1sOvYH81I5pped7MP7Kz
	xnvf8mtFHW1i0BUp9rEGYUGia3w==
X-Received: by 2002:a05:600c:2256:b0:489:1927:5c0 with SMTP id
 5b1f17b1804b1-48919270787mr172142805e9.0.1776926749488; Wed, 22 Apr 2026
 23:45:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206182336.1397715-1-neelx@suse.com> <20260206182336.1397715-2-neelx@suse.com>
 <20260221221153.GA2123@quark> <CAPjX3FficsLf2QXFU70sR6PN7h8rj5opz_wntLm+Acd3YLvu+A@mail.gmail.com>
 <20260422225310.GB2226@sol>
In-Reply-To: <20260422225310.GB2226@sol>
From: Daniel Vacek <neelx@suse.com>
Date: Thu, 23 Apr 2026 08:45:38 +0200
X-Gm-Features: AQROBzBwq5ZRAPxV2aicYDXhz8eGzSNuCy0WrJTFESLNDvoGYhORBKakn6zpBls
Message-ID: <CAPjX3Fdg=4gMYZQcfmG00ucrtheUW-UKqR0yGwfJ=cA3BzrRWg@mail.gmail.com>
Subject: Re: [PATCH v6 01/43] fscrypt: add per-extent encryption support
To: Eric Biggers <ebiggers@kernel.org>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>, 
	linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 23 Apr 2026 at 00:54, Eric Biggers <ebiggers@kernel.org> wrote:
> On Wed, Apr 22, 2026 at 10:17:40AM +0200, Daniel Vacek wrote:
> > > > +/**
> > > > + * fscrypt_mergeable_extent_bio() - test whether data can be added to a bio
> > > > + * @bio: the bio being built up
> > > > + * @ei: the fscrypt_extent_info for this extent
> > > > + * @next_lblk: the next file logical block number in the I/O
> > > > + *
> > > > + * When building a bio which may contain data which should undergo inline
> > > > + * encryption (or decryption) via fscrypt, filesystems should call this function
> > > > + * to ensure that the resulting bio contains only contiguous data unit numbers.
> > > > + * This will return false if the next part of the I/O cannot be merged with the
> > > > + * bio because either the encryption key would be different or the encryption
> > > > + * data unit numbers would be discontiguous.
> > > > + *
> > > > + * fscrypt_set_bio_crypt_ctx_from_extent() must have already been called on the
> > > > + * bio.
> > > > + *
> > > > + * This function isn't required in cases where crypto-mergeability is ensured in
> > > > + * another way, such as I/O targeting only a single file (and thus a single key)
> > > > + * combined with fscrypt_limit_io_blocks() to ensure DUN contiguity.
> > > > + *
> > > > + * Return: true iff the I/O is mergeable
> > > > + */
> > > > +bool fscrypt_mergeable_extent_bio(struct bio *bio,
> > > > +                               const struct fscrypt_extent_info *ei,
> > > > +                               u64 next_lblk)
> > > > +{
> > > > +     const struct bio_crypt_ctx *bc = bio->bi_crypt_context;
> > > > +     u64 next_dun[BLK_CRYPTO_DUN_ARRAY_SIZE] = { next_lblk };
> > > > +
> > > > +     if (!ei)
> > > > +             return true;
> > > > +     if (!bc)
> > > > +             return true;
> > > > +
> > > > +     /*
> > > > +      * Comparing the key pointers is good enough, as all I/O for each key
> > > > +      * uses the same pointer.  I.e., there's currently no need to support
> > > > +      * merging requests where the keys are the same but the pointers differ.
> > > > +      */
> > > > +     if (bc->bc_key != ei->prep_key.blk_key)
> > > > +             return false;
> > > > +
> > > > +     return bio_crypt_dun_is_contiguous(bc, bio->bi_iter.bi_size, next_dun);
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(fscrypt_mergeable_extent_bio);
> > >
> > > Similar to fscrypt_set_bio_crypt_ctx_from_extent().  The copy-pasted
> > > comment needs to be updated to remove no-longer-relevant information
> > > specific to per-file encryption and correctly reflect per-extent
> > > encryption.  The DUN needs to be calculated correctly for sub-block data
> > > units or else the combination of the two needs to be unsupported.
> >
> > The DUN is fixed as per above. Regarding the comment, it looks quite
> > valid to me. What exactly would you like to change?
>
> It's now been a while since I was looking at this, but looking at it
> again now, at least the following parts are incorrect:
>
>     "the next file logical block number in the I/O"
>
>     "I/O targeting only a single file (and thus a single key)"
>
> It's actually the block number in the *extent*.  And it's a single key
> only when the I/O targets a single *extent*.

Yeah, I fixed the block number comment with the change to the `pos`
offset. That one is clear.
I'll amend the rest.

Thank you very much, Eric.

--nX

> - Eric
