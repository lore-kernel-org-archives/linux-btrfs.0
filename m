Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA53E388E4E
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 02:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774320982; cv=pass; b=r5s+OHi4cVzcCQaFbG31yl1oYMw9ID/e8efnEqlpu1nGnCS+uT9/MNLcqeR2CglTjKbvX1R7wgp18ZjyXTtaHaDirrQ2FelpOlGXhALjE7Ukh9D05FLJB0YMlrJYLaOV5VBBhnYIaggt38wyGcNxJFdKuWCtv7m4GGS6175g43E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774320982; c=relaxed/simple;
	bh=o/skd7D95WNSbrYtC4xn5gfzVqcvn+A4lGocklhRyt4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U7Vskb0VEEs5QIalPD4+aLw1YtgOpXfWXuwF00Lqsv/2i3j43igLCChIQ7TfqJYzZHksgjF7Jit0ofxuOV5BIf19EgHdPC0cvqBkyk+hRuS1iXWdD+0PSKmNrRe7OW2iX3/JEeGKXNH8PCC6yy/j1CIGhh/Jmt6heeuGWwZUMFk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lTeLrk/J; arc=pass smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lTeLrk/J"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b976536806cso748515966b.0
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 19:56:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774320979; cv=none;
        d=google.com; s=arc-20240605;
        b=QFImfhQKAKyTkJ4G8UmaUwjj7suuMvoh5a8pqoZjOHo7b0ZsbcobMuiWThlSe8btM5
         lvrQrjILd0ZDCV0y/l+LfYgtvmm8TUSwsLZK6j+8D6yHNRhvIkDryPe95rvcDZuVlwQg
         gCwqK7oiBgSitK8tUN4tMPRm9cFBFyFoDpNk+g7C2PztgJvTJ3OEY6bgiK/Ri4EknuAK
         xDs5IUf8Hd0iPPU50TLIMuNkwzjjCRVog7RTVsfmogT8FUjnOsCZtRDV40JN+/jIYjLM
         QpGD43ha6E8yeblSfK9e8EOmldtlz/5/9g0esnVHSHT0DtVAfOqRKxicsMuIBYjjDcLA
         5rLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=m1Fy558thMEchxvffNmHIHu+yPWwhkymd/ZNOHH1urs=;
        fh=7ougG7k8Bkbs1X7RQYqYoqUJflogCu4zLmKKChmf3sY=;
        b=bZUfQI4HGRtiVRJHxsd310XDlqE8Tk0+JPNmVefcMg4QAWaenSHsF/hEByJ6hcJCUH
         6Py4FgtSP3pzJgKeNHf8R3ZroL/YRbsdIzG1+NP1Y4Lu3iz7j5oM5tUyQ9MIFPY5GP7p
         mPFgFv8LgeyHY3swNqzc47gpGscgMpeDovzEa0OtSCrTEUmhUC6bsmCs8KeA8YMpfgCT
         WNxyG7/lnSEPHO6K/ym7d5oMp2+ckEPoe8UNQTNZHlsaqjLzGShKpxHlV9D6RQ4X2S/r
         qXAoPHisFALV6iGszSyJ1Cky8n/H1paI4SAlxJ9LQ0IFu3SyWHMUPGNAyxIJmocFcSEu
         3g3g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774320979; x=1774925779; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m1Fy558thMEchxvffNmHIHu+yPWwhkymd/ZNOHH1urs=;
        b=lTeLrk/JTbzuZo2PCc58APDztdI4i8KsUz9ivIihFuU7W9OClOiGZ2JdITxbki5PIU
         Rl74zF4H40GzTX1U2dX+8s8fwq5A1wBBxnwOOb6hKwhtytHgJMUV3SQ5kNPVgdwK5vSN
         XThzSOe0qQBSHGMyhHTEmwcuuzxQdZ7bmMP3ic77/X4PAOBupR2P7p9LS4tvOS1qJwsc
         n3gQS5k2o0i+vSwn+bauoQjuRSss5XHJH3rPblMN5tKTl5O7Yv/QBs/geuBC+jKf/4gY
         OunB/etT//9XEZcSKEb7t8xU1Pv9q7Qu725iq6Zz6WUbpUNmq9Gq3zldghlLb6Utwrgm
         VbaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774320979; x=1774925779;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=m1Fy558thMEchxvffNmHIHu+yPWwhkymd/ZNOHH1urs=;
        b=lHzRllhcTk6oBkky5lrZ6pLw33QaLnRKDaduUKK/Jw49HvMbbX8GZiJwDvXmNWaqAg
         NqNrsuOQjUL90C5kxCSd2ieSc61AiCIajHOkun7d2EWgRhO/vkX6FGZX4faL4XHq9nOv
         CBg8Sq6xFgJcCVWakSyPig1ZQPqjVKLG9eNJ9U3ZNhtdWmBqcb+XPwsu/zZcvh3PLH2r
         yIuIrr1jGMKlVFPiNSZH7VDINJkD97eoeo9Mj0B6qohVyM4AxHSLYNk8eVRDCWti/AeJ
         ppZGDOJTnL9jg4xW/Z9rnf5Nnm7Nn5ysWrWpTm/DT8DH14J1ZuZW2VhNpbLuKVklseUY
         2kLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXHTFrrZn1AF5X4/2Kr9qQrOpSTC9+/W4aH68x3k+t25KtOv+j/Xb8bUt63K8JPaV6r+yo735tvXuMViw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxToAWRS0MzL0uXoX74oNmdrd7mpZGh+pr3j4vqHjUPeyGiiktu
	JAiqsQEQ9lOucoQJL5OPImH8TGgeQ3E9LUH0tGQzKrIj+LbWz+FP1h2qPlXJ8jbzgeBRn9Ky+wP
	cDll5boSMbUurfWfpfUdMgu2sWCHmYZE=
X-Gm-Gg: ATEYQzynQdQFTagzXqnTOj3bza1JIPnA39nDY7+JN91u4BjioHbg9dEpM7GlQhklLcY
	P3UKFpucg+wW4MiwV4tF7wTrDLll7Pli8KtdBR5W7+TObeW+fWVAeFAJZ80gVlZhb5GlP/XqTXM
	IGbvLyzmQoM5QiMxb2FLPpSl6DgInsj5fT5pGhFd2dsxFWsBm/ZuuEmkj2S+HKzHQj92YCRuxWK
	Mzdf9aGnHBtVUUtc0vzuluNFrS2aSYf4FWGKdWfnailapWlerEATjKwVk8cO7S8SB/QqYUlW212
	sxy8FCwet8ujDhDmiTq/t7n3ecRs6Oiz1dN+Y8BO1iYSSsnb45VutArPn66bf7SFaA==
X-Received: by 2002:a17:907:158a:b0:b98:2c44:6631 with SMTP id
 a640c23a62f3a-b982f21dc70mr733527866b.14.1774320978733; Mon, 23 Mar 2026
 19:56:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260314123741.1439792-1-gality369@gmail.com> <20260314123741.1439792-2-gality369@gmail.com>
 <20260323174027.GN5735@twin.jikos.cz>
In-Reply-To: <20260323174027.GN5735@twin.jikos.cz>
From: ZhengYuan Huang <gality369@gmail.com>
Date: Tue, 24 Mar 2026 10:56:07 +0800
X-Gm-Features: AQROBzDejusHmhqodxDfy9ApYb3p-75c3_u4nNYjkSfzM53rurgHUy-jBUQ4MT0
Message-ID: <CAOmEq9UCwf_NzNh3tbuYqWYWxdkM8-V4w38YeVWwaK=RmR9usw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] btrfs: balance: fix null-ptr-deref in chunk_usage_filter
To: dsterba@suse.cz
Cc: dsterba@suse.com, clm@fb.com, idryomov@gmail.com, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 24, 2026 at 1:40=E2=80=AFAM David Sterba <dsterba@suse.cz> wrot=
e:
> So, for example you let a filesystem create some structures, let it
> continue, damage/destroy the structures and then let it access again?
>
> If this is supposed to emulate a corruption, either on media or in the
> IO path then OK.

Yes, this is one of the fuzzing strategies we use, where metadata is
intentionally corrupted at runtime to emulate possible media corruption
or I/O errors.

> > diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> > index 2bec544d8ba3..7c21ac249383 100644
> > --- a/fs/btrfs/volumes.c
> > +++ b/fs/btrfs/volumes.c
> > @@ -3863,14 +3863,20 @@ static bool chunk_usage_range_filter(struct btr=
fs_fs_info *fs_info, u64 chunk_of
> >       return ret;
> >  }
> >
> > -static bool chunk_usage_filter(struct btrfs_fs_info *fs_info, u64 chun=
k_offset,
> > -                            struct btrfs_balance_args *bargs)
> > +static int chunk_usage_filter(struct btrfs_fs_info *fs_info, u64 chunk=
_offset,
> > +                           struct btrfs_balance_args *bargs)
> >  {
> >       struct btrfs_block_group *cache;
> >       u64 chunk_used, user_thresh;
> >       bool ret =3D true;
>
> As this is bool it does not match the changed return type anymore
>
> >
> >       cache =3D btrfs_lookup_block_group(fs_info, chunk_offset);
> > +     if (!cache) {
> > +             btrfs_err(fs_info,
> > +                       "balance: chunk at bytenr %llu has no correspon=
ding block group",
> > +                       chunk_offset);
> > +             return -EUCLEAN;
> > +     }
> >       chunk_used =3D cache->used;
> >
> >       if (bargs->usage_min =3D=3D 0)
> > @@ -3986,8 +3992,8 @@ static bool chunk_soft_convert_filter(u64 chunk_t=
ype, struct btrfs_balance_args
> >       return false;
> >  }
> >
> > -static bool should_balance_chunk(struct extent_buffer *leaf, struct bt=
rfs_chunk *chunk,
> > -                              u64 chunk_offset)
> > +static int should_balance_chunk(struct extent_buffer *leaf, struct btr=
fs_chunk *chunk,
> > +                             u64 chunk_offset)
> >  {
> >       struct btrfs_fs_info *fs_info =3D leaf->fs_info;
> >       struct btrfs_balance_control *bctl =3D fs_info->balance_ctl;
> > @@ -4014,9 +4020,13 @@ static bool should_balance_chunk(struct extent_b=
uffer *leaf, struct btrfs_chunk
> >       }
> >
> >       /* usage filter */
> > -     if ((bargs->flags & BTRFS_BALANCE_ARGS_USAGE) &&
> > -         chunk_usage_filter(fs_info, chunk_offset, bargs)) {
> > -             return false;
> > +     if (bargs->flags & BTRFS_BALANCE_ARGS_USAGE) {
> > +             int filter_ret =3D chunk_usage_filter(fs_info, chunk_offs=
et, bargs);
>
> Same problem here. Also please use ret2 for nested return values.

Thanks for the note, I=E2=80=99ll fix the return type issue and send a v3.

Thanks,
ZhengYuan Huang
