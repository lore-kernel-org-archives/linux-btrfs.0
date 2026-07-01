Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBF14949FD
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Jul 2026 15:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782921567; cv=pass; b=G7MbVyA7IoiSaIOn7DJdzJV00Dk5G7gwcP9Vsj6cb2t9N1/slAlkT4HVd4CCGhKvEE/5QFS9KL7Xk7jw9bAIWyWuyFCRtYZ3iSgld9G77ObctHlEP3zOBNMI+i7CkV1RaqHvyYsHaNin7au8wHcvilK34Mu27jNNCaugCDa/VEk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782921567; c=relaxed/simple;
	bh=3gfXHnjws9axdf6nCz5nV3PmyOopoA4D+Kf9VBGW8vE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b3kDGTs8lbEXh+BaZzxn6AH3VTfVxW+jWgfIVPU/2fqmJbrfZ6oe+5RH7uHh78KrzBtjCQCFd5DP8yGpCiqAmM20gVVNcCh8JJw4VpbiwD/qs86ZUrCERqIkqxXy1qAJNMMXOtID4sHQT6a39gR4fn7SmjH6SmzS2/jS1gp8dX4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bUy2m3y2; arc=pass smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bUy2m3y2"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-4745492ed3aso519421f8f.1
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Jul 2026 08:59:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782921564; cv=none;
        d=google.com; s=arc-20260327;
        b=oPv5rBhnC96eFO2MG9pFV4WItfABsfLeKt5bTvIuVnjOgBqHOYY7eVa4vDIhHtBNqm
         9W+CVBIq/NDgb/E5mSMhQ1hn0MZe8Ua6r64I6xwqKbpLcujLoYHsgfhZq+vZIq9fyqhO
         c2ipwatdB75475LQthmpk7cqxaGZjMRZYOSS/YuNRRhCXjEUVKEbKtpbKgeDnrCNhs1j
         deu2xHIq5+x21skhtrhbXljEsx97hXfn+CxMVz093r8r6djvthn7Oj+tec9ys8fn/kkm
         6WoFOWxLH/WjipMqCMRnk0Jmg3MNXBdObCNYHMsukLegtRAfln0dPRsBHhT6/S8fF5U7
         x7Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FAu91ufrWzbA8DtqFzBYsE7r4WO9/NSePfiQ3R0SF88=;
        fh=rzOiS06LUB/OkCrzIYiImNEKCepTpqsHcjabxn/WwqE=;
        b=ioBeImhYtD5DvwX8ZOwJgYVBoVgycHWtLEnAJjDKeQDN8BwKolKYwD3Dq8qEd6VxME
         fu9I04F+oGU2L8SqfhhbhtLQq/JVEQmN48BSP6T+/Bfa7e4nS49wu7vYjDGLk0VhMT5z
         vGqOa8uBcJZ4PXyWg8tRxHjvLBvgedfDp2qDqkeQZZepUZalzZ80pUjyZc6dtUQf/vnM
         aj/C51XovdezOsS9tNv1uRifzucLl0sgWb/rskNEMDnGtzTe9flFZd6Z4FT4RYb85hOR
         4B1nJt656RZ8HUepDwvwrHLlyR9c/PM7dq4dGo0kkGP6Ne6UeVR92KJkJxv/rRCbkLkI
         kpYA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782921564; x=1783526364; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FAu91ufrWzbA8DtqFzBYsE7r4WO9/NSePfiQ3R0SF88=;
        b=bUy2m3y2WvL4oT828J2EuoqTp9n9kiFRbP9K/cFq1I6gbkfiXum1VWy2f7xFMdHTj1
         s20wT9fld+BOn9LjLkyth2WQpUrbIxsns9Vc+8/3LmQUvdKT1kGyS9RzfS2cLFwiPcYY
         qpNoThinH5iyCDmOyszgAK5evHRtlPX1eNO0IipQcNOIs0BNIxIwmbC04BKbFuVXDT9I
         czMkoZucp1uGwv4VqYkAUgjR8xKsd+9dS+x+wpBjRhjvK4nlZ/iulQAyxfh1twlfi0X2
         5po+MM/29DGzBlydm9YM4Ou2RILNcqVuCcRccFhpcjzqF4daqJcYwCNTfNxOoN0tCjvd
         ekAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782921564; x=1783526364;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FAu91ufrWzbA8DtqFzBYsE7r4WO9/NSePfiQ3R0SF88=;
        b=igztP3Ia/YwmyPKNPO7hms7sR+CNLcM0rDUOOXhyTql/whDYAFkzUKADZAyP/+l1V8
         wUY8LlRzJe0ioVYc6Q/zDbq9JueO3ueAp+wrmZCdz/CihZjwrhCLpZnnLufouZxgjl+g
         7KHUhxUDxW4rmDJa2Z3NZWR4ZxLyHlOqHIVcZMI+x3uAqVfS7MaVgDfgynLCt+lVUIKu
         sFT0bNAYLJeOh2T5O50tDhGXMjAdZxFqCG2stWXQq/khOqXMagq6r70c6AUCE8ny2w4b
         LnXxWS6MrXgm8jh3ydbwgLD+ycAC9VhGSEs2K0jk/Kg3N/hhvA2S3MxbxCbGVRBOMtY5
         49Gw==
X-Forwarded-Encrypted: i=1; AHgh+Ro7/tlXm1jTbdx+8reuOwHBdlAwdJXv8LNc0n7QJ2mrTqxnP4ew4ih9sInBE5MA4PZYjJyBGRcrMZuFnQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywvumxt8oM824UrqkYCfcJy/2iHwBJ7oxNVUsk9dJvExb+jMzQw
	lRM0cqFAy+nDjlloHBQKvCwwva5F3zObo0QoniOb4SBvTQSVgfygB+atV6F/q5+vi3yWLkx7orW
	8KKw87bmfBRZCSZmYljwI4BfMG14jFNPN++wIxwBRtA==
X-Gm-Gg: AfdE7cnUW2Dj7hBjwkPVyzIFNWVpDVcvPKBdJ3y9rdmT8hcnpoVpMMGKNRRCB5/kc5U
	2MdnSpnbR4vufH+racFvCalqxGMEEqIvQlf5ieXXqtFT8w3jhVdiCWgcSMNI9LFXJX1qYfdqZ5n
	TEOjdBm12Sci5qb87jx0e+yQLmpbKanded+hf0Ui+dveHBkoImNAZIQGvrvB5Kx4zKZwboGriED
	zP1llah/4jwq9CDnZFfbRCaYYUnOI3HNbSM7SMRilZ0SfJoietkx+NKFEihXKrVqicqrAyZNGDy
	tYUiewlt4HuFNQzHDC2TdFgygjl3VCuCe898uzvwHltu033IiptEGpV9FJE3eSpyxPdUOA==
X-Received: by 2002:a05:6000:2f88:b0:466:6ed8:1e1b with SMTP id
 ffacd0b85a97d-4775798c679mr3930825f8f.21.1782921563954; Wed, 01 Jul 2026
 08:59:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260624165144.556908-1-neelx@suse.com> <20260624165144.556908-6-neelx@suse.com>
 <867a944d-3a26-4248-b0aa-f10247196502@suse.com>
In-Reply-To: <867a944d-3a26-4248-b0aa-f10247196502@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 1 Jul 2026 17:59:13 +0200
X-Gm-Features: AVVi8Cdo6n7AN_ocezQXRVlNNdLexrSHHboCqCKpvPgpBol1AWXQvwhVWZqS-Ns
Message-ID: <CAPjX3Fc2tyPw6Fe-SEg+OsMhGiK+A+Y9qRTRfegcKwdK1WqfJw@mail.gmail.com>
Subject: Re: [PATCH v2 5/8] btrfs-progs: print encryptin type field of file extents
To: Qu Wenruo <wqu@suse.com>
Cc: David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 26 Jun 2026 at 01:50, Qu Wenruo <wqu@suse.com> wrote:
> =E5=9C=A8 2026/6/25 02:21, Daniel Vacek =E5=86=99=E9=81=93:
> > From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> >
> > Encrypted file extents now have the 'encryption' field set to an
> > encryption type.  Let's print it.
> >
> > Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> > Signed-off-by: Daniel Vacek <neelx@suse.com>
> > ---
> >   check/main.c               | 1 -
> >   kernel-shared/print-tree.c | 2 ++
> >   2 files changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/check/main.c b/check/main.c
> > index dedb4db4..a32247b3 100644
> > --- a/check/main.c
> > +++ b/check/main.c
> > @@ -1778,7 +1778,6 @@ static int process_file_extent(struct btrfs_root =
*root,
> >                       rec->errors |=3D I_ERR_BAD_FILE_EXTENT;
> >               if (extent_type =3D=3D BTRFS_FILE_EXTENT_PREALLOC &&
> >                   (btrfs_file_extent_compression(eb, fi) ||
> > -                  btrfs_file_extent_encryption(eb, fi) ||
>
> May I ask why preallocated file extent would have encryption value set?
>
> My common sense says that encryption policy should only be set for
> regular file extents.

There's nothing wrong with pre-allocating encrypted files. Unlike
compression, the exact size is known beforehand.

Simillar to NOCOW, the encrypted data will be stored with the next write.

--nX

> Thanks,
> Qu
>
> >                    btrfs_file_extent_other_encoding(eb, fi)))
> >                       rec->errors |=3D I_ERR_BAD_FILE_EXTENT;
> >               if (compression && rec->nodatasum)
> > diff --git a/kernel-shared/print-tree.c b/kernel-shared/print-tree.c
> > index 0afa3696..159f0825 100644
> > --- a/kernel-shared/print-tree.c
> > +++ b/kernel-shared/print-tree.c
> > @@ -471,6 +471,8 @@ static void print_file_extent_item(struct extent_bu=
ffer *eb,
> >       printf("\t\textent compression %hhu (%s)\n",
> >                       btrfs_file_extent_compression(eb, fi),
> >                       compress_str);
> > +     printf("\t\textent encryption %hhu\n",
> > +                     btrfs_file_extent_encryption(eb, fi));
> >   }
> >
> >   /* Caller should ensure sizeof(*ret) >=3D 16("DATA|TREE_BLOCK") */
>
