Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A5333B6EF
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jul 2026 05:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782970484; cv=pass; b=B4vrpiHC+3BW8Fxw3RITrwPq2ETFLICJjzQThhA+G/u4z9vgNHtUVOXJdoURRQDc8nPfmvHVFkUBIB9fBwsirmMjNcckg9sLdJSedl0Z9VRmaQN0Pcl7f1u+fLTVW8A9nYaImHP+L49VDQ1C06POEE5USZTWps/KxjK/hh6g/LM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782970484; c=relaxed/simple;
	bh=ItnPtemJpDXlGtts7MlHqHToeHX5qB8k3Tzsfi3ttJE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hxIa8a5p2Kn9MRCXYhddmVKLiPd7zxTYyXy2UHatYNSRyJcr+ytITGZRAmZkHiyMCmtiWkgRcsmZR6T7Gj6sEJ8bbuM1caR/I+F8Ge0FLAsGgFf5iQo7Wcxz5jz1G59lHy0VSbAR7b54ArRrokDBp5tLirMPAyBVtUzqbehHYtY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QKNWFPDB; arc=pass smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QKNWFPDB"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4629051c9d1so903532f8f.2
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Jul 2026 22:34:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782970480; cv=none;
        d=google.com; s=arc-20260327;
        b=obqHayOiBJS4ujY5/amrcSNtzZ1eEHzJMrbC1HQQRb2orUj9ZhS1HQRHLFbj2fnhpt
         EoMTyBOUHAe78EocRfrDdzPpvZLGOUsNmPiUCT0CZg/mEjnX/tWvgDKJoJBE+/qQXrxq
         Ad3AtgZ5vg/qWU7OfvdRhJvexc+WkmheX2UCxh4nUwdzrnluRkN+kvjDXdBys9xYYww/
         ezcmEyQJCHl79+r3wqItiXy3em0up+W9WFk2jFsK288JHs6CZs7AqnK5GWq4PlVk2Ekz
         YMrNK8iNg7XqML9BngAbW1hdy+9R0KD6GN8i/XgtIffcCXSvIJVxjXQSgaYi0G72D1aD
         gNGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BYsyg1w1FxKnl5Rmpm2QTYiGYkStq4XPapOVCuKQhzY=;
        fh=Bl5PXF93ZP0Et3SfKwkVjyTTyQopoN4XmTpjF5UU4hE=;
        b=lQewr0oa2abXU1neMHB+4HtgIUrns19vcgszf2MJpOKpwOhIFYfnOMolM0Z4y9pYN7
         q8gPT/TPYhKzZ5IY9lNyGwkxWILcaoQ+fujukr6knff+u62g0Ouildcn1VwmFLCAF9rP
         2RvtU/zBKXvsgQPJLmWZqZD6r/cOmJrGp5a3LeTzfvm8qcFU4qx9+gJWo1zlUmEQdBZ8
         VRyCVxMZ+3MHMnuiDpZWCWAf7OJJDpjlDWAMQBkWIf8bdcLpt8+r+HfjtSJZf5HH4+3p
         VaR9O5QbeR7A7anbrWDebvE2kgaD3jTa+CFfBBLQaoGDmnaSVUcbksie79VGTKCfwBOo
         EA6Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782970480; x=1783575280; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BYsyg1w1FxKnl5Rmpm2QTYiGYkStq4XPapOVCuKQhzY=;
        b=QKNWFPDBSn1Cy5ieD1DhuE6LxCJmwLGvvxkGZCwnxJ3p+joOgef1o9Z9WjfD38qgEd
         lPxFyHl3M3uFXYcmeBJiLDlmek5vij7ORn721xRdORRp2Fu5r9RA5+SUHfECIxgmvcez
         DIA9TbKM9/kNkA1dtsTBnTCdtW/Sz5GFFlwcT348pF/MyEU0nmR97tGLGU9da5buNdyd
         nq9evbx6+2mlDrKsg9vCkvo8m/cUoTrjn+6fpNbiG2rvd6iggqU1dJzTyjG2KTG8hTgF
         OIKU26oK77EvDSXIuEmMBIESDal/wbtx4AIZaQ9mngifJqPo3dcWiN95pvbbaUFDjIH+
         2WMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782970480; x=1783575280;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BYsyg1w1FxKnl5Rmpm2QTYiGYkStq4XPapOVCuKQhzY=;
        b=E/CclvT4uIKBeRTXQaeZGtM9JwEqHp9a8U1Y0IsSjXP4BLbZc7Yr7OAe80T/UWQQk1
         p81DVs942cPamRpU0d2b26+z0wBUbRM7ABt3xwcjNFyVGUhA+PZYYlVrUXLZ3jCjPwCG
         /VpbVM0IE1YfGUcqESeHk5v/aWcau9BWaK/1QCFWBSDMHUxVTH8qbMYpvsQA3GvjEES2
         4kF/msMaF9C9yUPEENZqjJTIBe5qirqm5o4xvyHGewuc/JcQJMAtzaOo97yVga6IuiZa
         qurRTUXnbBwMLJ6F91JvBC568xkRJH4bTtXNb7ENF+bxCs6Y+LMMpebWUE8yZ0sEcYRa
         GC7w==
X-Forwarded-Encrypted: i=1; AHgh+RrKNHrA8EWEOKifZ3LVPtOOX+507eSKr6bd5tYze9bAOjixkR3nV8l6CSIkc5h5ypmpE7iyNZREjNa6oA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyUIcfrZ3d8jTIpa0xEbJVBmeyFWiq2EOD8/yZV1Yk+I07Oo5kf
	/0eS1MxWrIEJC7+EUN1XuvDCParuqwQUVR0qGWonK3lNu6hI0ix7EtZK+mMNAfio/SmdSDxPEtl
	N0e4R8EJ/uRDiTeDeReidmRefclhrVqpWylf4c2R0Lw==
X-Gm-Gg: AfdE7ckMQxkrY96lbXaKodOGbN6b7RnoudzHaKqdaLOa7BBSLqyVeZTvEA8ifypjuxB
	mB1ViP76J9MZ8efXCS2EOvKLYx5nGBi7OVtFiB3W2KaMoWA9qGdxrFRPRiA7oeMWXryLs+L5dtH
	hb7x+mAT8YPgtsB4EsCbAYh1HpFst07e4Ir40Ermb32/4q8m33yP8e4bqy07tDEYZmWQW0jbgCa
	9tu2YKy3yKcXCHm1vJ4EMOrV3BYPrVNMqw5JgP4KlJo9DVkUVaTmwjAx6u9kTEQ64DNhZNSvxky
	SufQn4xM1XXkCQbbfj6QFwjL2A8RdPJPhPa9IfGOjaViHUwY9GSqpuo6dypxRkuKSrT/Mw==
X-Received: by 2002:a05:6000:468a:b0:475:f0f0:9ec9 with SMTP id
 ffacd0b85a97d-477b5a526f4mr3430690f8f.52.1782970480175; Wed, 01 Jul 2026
 22:34:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260624165144.556908-1-neelx@suse.com> <20260624165144.556908-2-neelx@suse.com>
 <7d4ab06d-6cd0-4eb6-a355-d2b51d132713@suse.com> <CAPjX3FdE8REFdGT06k2RehJMfETgrxPzHZ3+V7FPaM_c1UwfcQ@mail.gmail.com>
 <2da4b215-165f-4bd6-a2da-07c9012586b7@gmx.com>
In-Reply-To: <2da4b215-165f-4bd6-a2da-07c9012586b7@gmx.com>
From: Daniel Vacek <neelx@suse.com>
Date: Thu, 2 Jul 2026 07:34:28 +0200
X-Gm-Features: AVVi8CcG5zLelgQO4v3GpjE5Ypjk5fHhbLOCXs6uMnb_UaodAS4nCGHym-UkL70
Message-ID: <CAPjX3Fe_S2oJeEo_qpXv5VgWYq-DNe_Lj5JU0M7m1p-MN8jVdQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/8] btrfs-progs: check: fix max inline extent size
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Josef Bacik <josef@toxicpanda.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2 Jul 2026 at 00:22, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> =E5=9C=A8 2026/7/2 01:17, Daniel Vacek =E5=86=99=E9=81=93:
> > On Fri, 26 Jun 2026 at 01:41, Qu Wenruo <wqu@suse.com> wrote:
> >> =E5=9C=A8 2026/6/25 02:21, Daniel Vacek =E5=86=99=E9=81=93:
> >>> From: Josef Bacik <josef@toxicpanda.com>
> >>>
> >>> Fscrypt will use our entire inline extent range for symlinks, which
> >>> uncovered a bug in btrfs check where we set the maximum inline extent
> >>> size to
> >>>
> >>> min(sectorsize - 1, BTRFS_MAX_INLINE_DATA_SIZE)
> >>>
> >>> which isn't correct, we have always allowed sectorsize sized inline
> >>> extents, so fix check to use the correct maximum inline extent size.
> >>
> >> No, we only allow sector sized inline extent when it is compressed.
> >> The de-compressed size can be sector sized, but the compressed size
> >> still can not reach sector size.
> >>
> >> So this doesn't seems correct to me.
> >
> > With encryption it's the other way around. Even shorter data (symlink
> > path) is always padded to multiple of the cipher block size (16 bytes
> > with AES). Inlining a full sector size is perfectly valid. The dump
> > from my test looks like this:
> >
> > ~~~
> >      item 45 key (290 DIR_ITEM 3363472967) itemoff 11425 itemsize 62
> >          location key (300 INODE_ITEM 0) type SYMLINK
> >          transid 14 data_len 0 name_len 32
> >          name: \243\365@;\312\321\240\367\377\234_{\245\vW\
> > \035\rS\222ryN\323\031g\243\nt3\321+
> >
> >      item 58 key (290 DIR_INDEX 11) itemoff 10077 itemsize 62
> >          location key (300 INODE_ITEM 0) type SYMLINK
> >          transid 14 data_len 0 name_len 32
> >          name: \243\365@;\312\321\240\367\377\234_{\245\vW\
> > \035\rS\222ryN\323\031g\243\nt3\321+
> >
> >      item 86 key (300 INODE_ITEM 0) itemoff 7197 itemsize 160
> >          generation 14 transid 14 size 4096 nbytes 4096
> >          block group 0 mode 120777 links 1 uid 0 gid 0 rdev 0
> >          sequence 1829 flags 0x1000(ENCRYPT)
> >          atime 1782916271.8000000 (2026-07-01 16:31:11)
> >          ctime 1782916271.8000000 (2026-07-01 16:31:11)
> >          mtime 1782916271.8000000 (2026-07-01 16:31:11)
> >          otime 1782916271.8000000 (2026-07-01 16:31:11)
> >      item 87 key (300 INODE_REF 290) itemoff 7155 itemsize 42
> >          index 11 namelen 32 name:
> > \243\365@;\312\321\240\367\377\234_{\245\vW\
> > \035\rS\222ryN\323\031g\243\nt3\321+
> >      item 88 key (300 FSCRYPT_INODE_CTX 0) itemoff 7115 itemsize 40
> >          value: 02010403000000005f0642cd89f66ce3ed930fe3ac518b7381bcd76=
00f7ae1f08195bda44461ed5d
> >      item 89 key (300 EXTENT_DATA 0) itemoff 2998 itemsize 4117
> >          generation 14 type 0 (inline)
> >          inline extent data size 4096 ram_bytes 4096 compression 0 (non=
e)
> > ~~~
> >
> > Perhaps this would better be folded into patch 7?
> >
> > Or do you rather mean special-casing for compression (with the limits
> > as you mentioned) and encryption (with full sector size allowed)?
>
> In that case, I'd prefer the limit to be only loosen for encryption.
>
> So we won't have unexpected non-encrypted inlined extents to reach the
> limit.
>
> BTW, it would be great if the progs dump-tree also prints encryption
> value for the inlined extent.

Makes sense. I'll drop this one and rework patch 7 then. Thanks.

--nX

> Thanks,
> Qu
>
> >
> > --nX
> >
> >>> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> >>> Signed-off-by: Daniel Vacek <neelx@suse.com>
> >>> ---
> >>>    check/main.c | 2 +-
> >>>    1 file changed, 1 insertion(+), 1 deletion(-)
> >>>
> >>> diff --git a/check/main.c b/check/main.c
> >>> index 5e29e2c5..dedb4db4 100644
> >>> --- a/check/main.c
> >>> +++ b/check/main.c
> >>> @@ -1720,7 +1720,7 @@ static int process_file_extent(struct btrfs_roo=
t *root,
> >>>        u64 disk_bytenr =3D 0;
> >>>        u64 extent_offset =3D 0;
> >>>        u64 mask =3D gfs_info->sectorsize - 1;
> >>> -     u32 max_inline_size =3D min_t(u32, mask,
> >>> +     u32 max_inline_size =3D min_t(u32, gfs_info->sectorsize,
> >>>                                BTRFS_MAX_INLINE_DATA_SIZE(gfs_info));
> >>>        u8 compression;
> >>>        int extent_type;
> >>
> >
>
