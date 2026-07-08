Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8943002B3
	for <linux-btrfs@vger.kernel.org>; Wed,  8 Jul 2026 04:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783485516; cv=pass; b=iQ8M4WA8+7guGjds6Bcy8I108184XFtSWMtyItvNqT8sif6lxbMRRlQFvHFoA560VJHB75W36Kv9RiXQsYfN3qQy1YQDTAP0hZzssbxjvZqTQ5XWdtUYco/6lSlnsCI7pnQLTs/rqK0plQQxvmznPgssY/zFgx3fAzA7hJm2BMM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783485516; c=relaxed/simple;
	bh=4grEvqA8v78lMwC7X3s28Pu+9LYDK0ama6zo80Xg2rU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZE7/MISLGTUIBRl0PuUnSwxexl2KBbWR3PEgiSQMsRDSUpDckv3CBs+F9oMwt5EVfuQCGJfnr8TnxWUqtj8k9OeTBjIxrY6QkPO/sStJgmqVMupxCbRcsb9twgxfO05QMa3PGCeDHCx5/Ff8Xnr/sidLL+fgoJzkB+jptdARiIE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KH3XvfV3; arc=pass smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KH3XvfV3"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-474560436c3so187098f8f.0
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Jul 2026 21:38:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783485512; cv=none;
        d=google.com; s=arc-20260327;
        b=kyf79U10y7UFT7AUZ+yApO1ecaDdvcNTHoptgg0Okm1l55PKHfvXWic6jf5zWx8pbL
         ALs58FVXusRXEtnwIkEAlk+r/VY8zEu4yumav+GZFcF/vkkpHV4arwODDxZwfqCUg6Ps
         D5PP0QMICqtEo/EPHShxRGx5xStyrhNAaYleq1oli0Pt6WfHgmpKMa55isso2PBEsIF3
         5RHeDS0RfHbBTaqeKt0eWTTaXLTgAT3cgS7oC8oLZq02/tLRP4BM6tRI5Nb2/B1h2Z0A
         gCU4JagetOJZLdmKRYLUjnzDRRBNzWC7Jntf/Cecrud64z0oYibvgXjnEznsyGQ40k5m
         QEbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cpGKqEyelFTLpS18Regrq0L45LljXUVPN4qikMPr514=;
        fh=hr3xsQdRoecHsdeflUQVUhlaiOVPFfTGgkkVp4uThdU=;
        b=nxR45uTaUGGHfy8K2nXt+oBcT8Iysu2DJ0Es5OXeEDf/7Q2LpvA+AtErEFcPfzNYyK
         fjChzqXEwFL79j/OvZzieWePYwfZZbHix4h0REFrqxhG6/WvLYxK9T0+Vy/DLeOSi3W2
         1emXS8Dip+XyzgW0I58NBMSOVHr9unWtBzvptKrDn6KvJkXS3XC59V7OywZJFgMDoDgT
         /gQHO/t4P+ZvWLncUDnMmOX6NlWCfKJOAdH5P2EmQtf+o0RDnXoFlcf48/xLDGKi/gby
         5tfsSDQPrJFJeUmoCxDHAm3x1Fc7R8RlC5ya2GtiL2ipsFZpx49GMa4MJ4DPtTfgZdRs
         VwXg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783485512; x=1784090312; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cpGKqEyelFTLpS18Regrq0L45LljXUVPN4qikMPr514=;
        b=KH3XvfV3DiCE9z7QyzEx9gkKgrPwKtQIHf0sKau+pM3o+1+2BTESUmrzevxCALPq9A
         /r2fNshfA+TpsM8LBHGoKWUpaLXD+G6JLIo+NI16W0SzDk+sA2qzBQlehASD9KjLO+to
         tidQo/WoWXDNkbdeZmO4afK0tEM5Ex+9b+XMB+B5dLC/IL6AVK4xvv5WX6bDZAFB1ekj
         kRYlkX99R7WHtt+czsdNUY7ZE2pIF6ONhdYxJWV7ltr5i1MzFDR9YFTjBNHpcy6CK5Wt
         syRuye7NV+9mtC/WGLhb7iDBPgZ1UhJEpWe3j0tMDSkPhuMpdGBkiaWMtPE/rU1PrCtY
         woUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783485512; x=1784090312;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cpGKqEyelFTLpS18Regrq0L45LljXUVPN4qikMPr514=;
        b=tOSa0c19IC4d93ZKUnph3WCxMpGlPBoinDriEQnx/4hj0rAEAy0I8mhdlbZ15KPqOF
         7/yShFnbJ840UGw7SiyEXMjxugMVqhmNOhLAESCgtKooyvAW5IUvH/uzyChAKd2M58ZU
         fW/BwOdxk4KmsN1XNTAQltXL38Q22/Vh3uq8jNk6tJjbcoR6Nse1gBOo6tV60+E3JrUy
         c+VGncOeTAyeQBH9CngsnNV3WOc0ag24YLQIZRhGRzEjMF88+tLhE51+lrJUVfv+8aAw
         IFq/0dqkycwsMRunTgdeQkDEs6MFSbFBfAUx0z0SAt7A+2PKSvpgV63ZgC3kgPDqE1iQ
         axJQ==
X-Forwarded-Encrypted: i=1; AHgh+RqvqMWFsCkm4p13feIxNF3cVXaMTGEU72WjXJ4MOMXauYRJPLjMz2S6J8gRYNwv+5UKB8rIGVqeOErXdg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyQrbBDn/5Su0nEgsajJnEEdUT6h4Q1U4VGd1j/x/yKRVWmq0LB
	tqNYsKaKrp4McQVTBRKG5mqyU3Shre8WPgxjqlTK9/2DBQAwyGDHdL3mHXtB1StgCDMEhEROpIk
	N8WlHeZ2VO9z0Ar6LQY2eajRX+ktXufi/2gYbqR+J7Q==
X-Gm-Gg: AfdE7cl/sRQPOGDnYwHD9DeHrQGffQv5Qooxw/ptaThd4kPhekbX+I+ZiIrDcovaWF3
	5O9w6ArpeOZtw5e9OtqzvKR/lHZA1l2WM61KyIROJyU9KDNuVXpyp2eofURkIzMGAv/dcZUECRy
	DsgxnKYdpWzd//KkEX0dW5lHYRwEBhAg7RQFavQuDfHZfvcbojrCD4M8kTGyO6IfCMpn40l1SNz
	g8wQQY/DRspsn24593LNhTz3kXi1o15KpVi9APdZ6TKWxXcyarbWEX6x0+Y3wSViZxJoPAZwOAt
	YHa3K5x/BY7zBuTYvRWGWUkscwMU7iCtuWcfC/qlEPE5vx0oLJoJHfdPuRiHF7fPQmKS9w==
X-Received: by 2002:a05:6000:25c8:b0:47a:d4d6:a21c with SMTP id
 ffacd0b85a97d-47df073b08bmr579527f8f.2.1783485512489; Tue, 07 Jul 2026
 21:38:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260707142736.2330146-1-neelx@suse.com> <20260707142736.2330146-5-neelx@suse.com>
 <8ef7b7fa-b3ef-4a7b-b882-d851e9c9eb09@suse.com>
In-Reply-To: <8ef7b7fa-b3ef-4a7b-b882-d851e9c9eb09@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 8 Jul 2026 06:38:21 +0200
X-Gm-Features: AVVi8Ce9Wze29QgTRYSDCuR6ZKAi7umkxbAcP53q_tjq4n9DG7Ko-vw9QXIE-aA
Message-ID: <CAPjX3FfYxEepvr=PeZ_tcpn96+=-TNm7L7pCyH0DX5X29-1sfQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/7] btrfs-progs: print encryptin type field of file extents
To: Qu Wenruo <wqu@suse.com>
Cc: David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 8 Jul 2026 at 00:40, Qu Wenruo <wqu@suse.com> wrote:
> =E5=9C=A8 2026/7/7 23:57, Daniel Vacek =E5=86=99=E9=81=93:
> > From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> >
> > Encrypted file extents now have the 'encryption' field set to an
> > encryption type.  Let's print it.
> >
> > Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> > Signed-off-by: Daniel Vacek <neelx@suse.com>
> > ---
> >   check/main.c               | 1 -
> >   kernel-shared/print-tree.c | 7 +++++--
> >   2 files changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/check/main.c b/check/main.c
> > index 5e29e2c5..7f438302 100644
> > --- a/check/main.c
> > +++ b/check/main.c
> > @@ -1778,7 +1778,6 @@ static int process_file_extent(struct btrfs_root =
*root,
> >                       rec->errors |=3D I_ERR_BAD_FILE_EXTENT;
> >               if (extent_type =3D=3D BTRFS_FILE_EXTENT_PREALLOC &&
> >                   (btrfs_file_extent_compression(eb, fi) ||
> > -                  btrfs_file_extent_encryption(eb, fi) ||
>
> I think this is a leaf-over change?

For now it is to match the kernel part to allow for wider testing in
the open. If we decide to change the kernel we can revert this later.

--nX

> Thanks,
> Qu
>
> >                    btrfs_file_extent_other_encoding(eb, fi)))
> >                       rec->errors |=3D I_ERR_BAD_FILE_EXTENT;
> >               if (compression && rec->nodatasum)
> > diff --git a/kernel-shared/print-tree.c b/kernel-shared/print-tree.c
> > index 0afa3696..2c0168b0 100644
> > --- a/kernel-shared/print-tree.c
> > +++ b/kernel-shared/print-tree.c
> > @@ -445,11 +445,12 @@ static void print_file_extent_item(struct extent_=
buffer *eb,
> >                       extent_type, file_extent_type_to_str(extent_type)=
);
> >
> >       if (extent_type =3D=3D BTRFS_FILE_EXTENT_INLINE) {
> > -             printf("\t\tinline extent data size %u ram_bytes %llu com=
pression %hhu (%s)\n",
> > +             printf("\t\tinline extent data size %u ram_bytes %llu com=
pression %hhu (%s) encryption %hhu\n",
> >                               btrfs_file_extent_inline_item_len(eb, slo=
t),
> >                               btrfs_file_extent_ram_bytes(eb, fi),
> >                               btrfs_file_extent_compression(eb, fi),
> > -                             compress_str);
> > +                             compress_str,
> > +                             btrfs_file_extent_encryption(eb, fi));
> >               return;
> >       }
> >       if (extent_type =3D=3D BTRFS_FILE_EXTENT_PREALLOC) {
> > @@ -471,6 +472,8 @@ static void print_file_extent_item(struct extent_bu=
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
