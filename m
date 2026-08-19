Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2196231AA92
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Aug 2026 14:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787149357; cv=pass; b=CdsqSzTYLXU7PG68nVlTrVWyLR1hENgxlmSioEcXXHZYZ5PYWWw3d4oIVBpNLE6w5nLe56QZkAq4N9Btrbkv3M84lqQ+3/XctGWXTnT9iaUHk4NrsRMG9NB5W90v2Fge8JCsdbZ+a9MuLR0h+kpgnQuCc05oLB6rqAKnylZuLJg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787149357; c=relaxed/simple;
	bh=WL0CzJuCKxnFNyuks1xwgxS4AVbpYe5kVLC/zCyuP48=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VSp85MnT9UxsLBNHMa2ZNqiY046ijdfd3jI1YpqDbXtR8pMeVwVziKCzoX8r5cgwhdnd8JUol9RI51/CM3e3UpoHxDLGdZzscrisB6uJUIxB0bB1QBJLkvqYb8zn3kQmVuaFYKwhsHgsYFZCu2D1CoqAtAFfcUw2t/vnyAckcQk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=X55aiLUn; arc=pass smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="X55aiLUn"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-495757ccbc1so10954425e9.2
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Aug 2026 07:22:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787149354; cv=none;
        d=google.com; s=arc-20260327;
        b=OVPxqdW6fZtHxZdXyDLC11fGJQyM/EP/wqwOJfjG8ihXZ0K1t4j57YMOWIUdnwVaKZ
         /htjVpxrdM7UMO6A/7k7Ik1F7GzKS6eSb9tby/nVcWE8sNl3GCSFEPS8AZmvfdn6pmeK
         YAidWIj9r0gxCFpHQOz5FT8FgQuaxhDM0Ije5v7N8V20qg1BXnR48qjaLhfNzkP90kKy
         r4SS6wiDZCNJ5XjpUmcy/QVMqdbI8O8pPlWvwYpfGMws9WYqofuFUcginQ+CuR7ausBS
         TcP8S8CwJLjKfhQ25nn92PekYbQRnVn9fnFWobpsz5PSrA5/OzYmK049g3Y4/YW7RHZS
         QyhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=cQvDWR+gFuMyKUr3DP+1B7x5IuCKckvrgbg8XFRCHiM=;
        fh=kDlkXJGOFfSGwV9DbPCnAKtY8dTxK/tKUl+9WcFJO/E=;
        b=iXKeS5LoRldBr/EgNCoj6hh+9jC7sFu8ufmV1c0t5LGrs2tt4uzoQ5Yhyy/LOhc86y
         MSkOHEgi1H0inTDfHUdyrK1Iavpb6qkMzF3xRHFbs+CTWsMFjZPHNEOEvnb0bCJ3szZI
         Qed5pPtVzXhpBhqCj7UPFJulRO/o2lgW0lrMbRgOyzV+YlvSmhGipE43+ogNyp6A9DwB
         LmUK3hKf8ATZASVqSwBC8yIV6KrSeRyxO7Stks1rZenuQ7PZEav1WxJyopVjVg4i1bhx
         49PAXNlMNcye8oL+bS/mQmgdra3FpV9QLqU4LmUQdc84NKOG9d6Bd2kGtQSLL7cZDmx5
         Yn4g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787149354; x=1787754154; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cQvDWR+gFuMyKUr3DP+1B7x5IuCKckvrgbg8XFRCHiM=;
        b=X55aiLUnSO9BWT0vC/lXMnlXZNsGts0j+QV/FUoakYVLv53le8mps12TvXy7doKZjp
         +fNMDkmKY1T59u8G4gwbzoaVg8avuroLpRcS4cLvC+ymUKF98RtytMbZat4iqvLp9vHD
         dEwsy0uHUjGzuR+Kwa4OCDeP53+Lcx7jH815GBFUqgZLBuAyg/f75zC1/1u4dSbtc0AR
         H4kUoQNQoInUBKBYo4vy1xKhHNHtGUgiLTq3SdahS5ftFsYL3FTeHE6Aqx/XDFib2A++
         fMlGZLXIa4Lruw8j+nFupztiBGR+ALRima4Y2j5SPLHnXA6IhrhNg7WqFD6fgAeeNBJu
         qsgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787149354; x=1787754154;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=cQvDWR+gFuMyKUr3DP+1B7x5IuCKckvrgbg8XFRCHiM=;
        b=fpS2igxQADaHfZyGzGbLIv96v8R9yB0sB6GpNZl/JYWKPhPw3uk+r5/lWhvOmP6n7F
         g57CfVwPUbL/asyfr/P3/aQBkTNGqvXqUcI/LfgKwZnxJYeUI6kjg/gwDZDshx9F+s+1
         gxFfKHaz1gwSs88TjPJ6uoEhhH+poXRwpHZT8h25Hshh38TXTgo5lECTtERhfWZpybaw
         SUgPYVqlg4/XGB2crNB7Y+SAxh2Ypd3eFAWd/uzgu1TXcBgyL6+yJ2nsyCP31MRqLvcZ
         LeJczlYu7yjMo1oVHiz560mIx1AzB5zJNHE562A19xA9lBJvRsHoZZFMjBGc5qV26tLn
         PDhw==
X-Forwarded-Encrypted: i=1; AHgh+Rq/nRzp/ES0ZTUJ81+/IjTRm1aRWvm3FbYhhdSA4xyiQFsRGT3EUMdKSHFOW92Bfw8y4cgLV3KFw8kpQA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyfmjXAT4I15S9o5LjTISruAaqNJj21/DdG12riairC4kSXG1ad
	UjG+rFadqTlZEUu6bFX1QVBJgyvtGTnMiInwXXvbXMV6g5c9vPZQjwo+MbD93jQ4MR5pFeiz4e+
	TZ3AWP3ktOwl0Ljl57LE6Pmtq9pqVTt4oe5vtrdleZw==
X-Gm-Gg: AR+sD11ISaMve5uHDa1QAzPRAjmXX0Q7gquIDpnVBMroUjjWjwdy+boLYCe0nPWHx3q
	stdrmMZyc3wxNW90FeGyv96xsS2FYRImLryDBN3u9TdeuVCc0GADgCrsKVvtqlwFePko/jZ28FO
	LF66YbXg+/wIyNoi99+P92zkpcqQr78UrNZYEbLEefi5PqUsyXbk/zVOoev6WKfi6of90h2RIg1
	De3jM89M+8U2Qabn2TuJUe4yHd4gyBVfwKNqw9v6c+qQwpyixFBcG0GmwQRhvrSdhhvXGsHS7j5
	jXn4BTY8H4PhWnNkXsZcyynF9Q8Loth7QkDO9I4u0mXZQHBBwwCjJkRbgcJpJTzZg0DysOsZWMe
	lxAQZ/m7blQnEElkZ4irUyoM3+xsdQEyYsAyY/XHZ187ia0Y4ZLZC
X-Received: by 2002:a05:600c:a012:b0:499:52dd:c1f0 with SMTP id
 5b1f17b1804b1-499aa180132mr108268535e9.1.1787149354463; Wed, 19 Aug 2026
 07:22:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513085340.3673127-1-neelx@suse.com> <20260513085340.3673127-5-neelx@suse.com>
 <20260601230406.GC25574@quark>
In-Reply-To: <20260601230406.GC25574@quark>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 19 Aug 2026 16:22:23 +0200
X-Gm-Features: AcwNN1WuVLXRwMTVjG6424GkTTp3P9BzGVQP00nzsthmGhd0KVAoGe8C-GfV4As
Message-ID: <CAPjX3FdMBAbz9T5yW=0ytRJD8s6zYHpo+TcYY-9-+egBHL=TFw@mail.gmail.com>
Subject: Re: [PATCH v7 04/43] fscrypt: conditionally don't wipe mk secret
 until the last active user is done
To: Eric Biggers <ebiggers@kernel.org>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>, 
	linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 2 Jun 2026 at 01:04, Eric Biggers <ebiggers@kernel.org> wrote:
> On Wed, May 13, 2026 at 10:52:38AM +0200, Daniel Vacek wrote:
> > From: Josef Bacik <josef@toxicpanda.com>
> >
> > Previously we were wiping the master key secret when we do
> > FS_IOC_REMOVE_ENCRYPTION_KEY, and then using the fact that it was
> > cleared as the mechanism from keeping new users from being setup.
>
> This seems to be describing the state prior to commit 15baf55481de, not
> the current tip of tree.  We do still wipe on
> FS_IOC_REMOVE_ENCRYPTION_KEY, but there's a separate boolean that
> maintains the status and everyone looks at that now.

I see, I'll clear that out.

> >   * FSCRYPT_KEY_STATUS_INCOMPLETELY_REMOVED
> >   *   Removal of this key has been initiated, but some inodes that were
> > - *   unlocked with it are still in-use.  Like ABSENT, ->mk_secret is wiped,
> > - *   and the key can no longer be used to unlock inodes.  Unlike ABSENT, the
> > - *   key is still in the keyring; ->mk_decrypted_inodes is nonempty; and
> > + *   unlocked with it are still in-use.
> > + *   For filesystems using per-extent encryption ->mk_secret is still
> > + *   being kept as the per-extent keys are derived at writeout time.
> > + *   Otherwise, like ABSENT, ->mk_secret is wiped, and the key can
> > + *   no longer be used to unlock inodes.  Unlike ABSENT, the key is
> > + *   still in the keyring; ->mk_decrypted_inodes is nonempty; and
> >   *   ->mk_active_refs > 0, being equal to the size of ->mk_decrypted_inodes.
>
> This is saying that a bunch of things don't apply to extent-based
> encryption, due to being after the "Otherwise," when in fact they
> actually still do.  So the wording here needs improvement.  How about:
>
>     ->mk_secret exists only if the filesystem uses extent-based
>     encryption, to support key derivation during file data writeback;
>     otherwise it is wiped.  Either way, the key can no longer be used to
>     unlock inodes.  Unlike ABSENT, the key is still in the keyring;
>     ->mk_decrypted_inodes is nonempty; and ->mk_active_refs
>     > 0, being equal to the size of ->mk_decrypted_inodes.

Agreed, this sounds better. I'll use that.

> >   *
> >   *   This state transitions to ABSENT if ->mk_decrypted_inodes becomes empty,
> > diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
> > index be8e6e8011f2..796e02a0db25 100644
> > --- a/fs/crypto/keyring.c
> > +++ b/fs/crypto/keyring.c
> > @@ -110,6 +110,14 @@ void fscrypt_put_master_key_activeref(struct super_block *sb,
> >       WARN_ON_ONCE(mk->mk_present);
> >       WARN_ON_ONCE(!list_empty(&mk->mk_decrypted_inodes));
> >
> > +     /* We can't wipe the master key secret until the last activeref is
> > +      * dropped on the master key with per-extent encryption since the key
> > +      * derivation continues to happen as long as there are active refs.
> > +      * Wipe it here now that we're done using it.
> > +      */
> > +     if (sb->s_cop->has_per_extent_encryption)
> > +             wipe_master_key_secret(&mk->mk_secret);
>
> wipe_master_key_secret() is idempotent, so we might as well just do it
> unconditionally here.

While this is true, it also (kind of) documents that the secret should
already be wiped out by now in case of !extent encryption.

But I can wipe the secret unconditionally here if you insist.

--nX

> - Eric
