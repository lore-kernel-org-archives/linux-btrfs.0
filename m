Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C5738736F
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jul 2026 07:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782975951; cv=pass; b=n+m2RT2swM8r3NQG2VC5On+1U78lzgLRREMqL/iDAzmEJFSEoF8AVyMRReTTyZtoM8E6TAyIJ0WSOw0U0yWKffonlhq/LBpcHXch4Lb3zx1EDWD2LJX4RgBhm4N51ct4qRGh+NKHEhxaq3Yh434mEiMwuOPL8TcaFOV+k7mspE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782975951; c=relaxed/simple;
	bh=5Rdgd0oa19t4IWPA978XuKzOlbIgUoOIcrjdEGt9x2Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JLY2duMGGk+L0Xonqxn1AESYL03lxkssSbbECq678i/tdeElIfWSFBDV4UQjYvOhiXCv1Thvk+NKe5XBUcmksNgwj9VfZYbSFlhPRXX35x32N3IBlAPlNOxrn0YDQpegxNiSpwpUUrSb87/hDLF93MOU3o+FQbGEPvTDz02iXsY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Hde8pGFA; arc=pass smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Hde8pGFA"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-472055b0efaso984642f8f.2
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Jul 2026 00:05:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782975947; cv=none;
        d=google.com; s=arc-20260327;
        b=snEP7RZ578QBSqV/sje9sHac3PIL+9eaT5F9bGjiJ29zDUZhPsV+igfmKgDpQpmSaL
         C8EfGI76tWcnqeYMT0yPHKyWW2mWl0MyCE6RkUTNNlUg8umM7SwH4FZeekv2sScS7WiX
         EQPUIM9M5R7TYuG0DuWuAaeV7aoEoxX2lGukFzwK2pZF/XxCG/nBnkZzYtoaxFyBZLSf
         4GDSil90mNk3eBb6ci+ZncN6DgcPaksSuH/6G/VJOkoMQTgSB/VTHpy8IcFsDU2qSbBE
         RsJWAX0iRTnNkM9SRZ9enHmGkIrVlZcId8xGXndfO8HLUDWWluchKa8n/nAjTkbansxj
         v9qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2gaGwHfqQxRPCSBc97tIJJuTdiSLm3zGrPcQFtIQ95E=;
        fh=zC9iO8FRQsUSpsO2q4VyJHPrsw45QjprMGQeJ3L7808=;
        b=cDOO8sxwFnE1Upd6MnOWwLcF8V6aLroidH+R/xtQIMNuv8yBaTd95ffKtQ5q/cqo2h
         yJ+KMqNqAsjdie1UDwgaYBuP+qOYgELc+85WdcCexlcYccMmrQtVe8+fWRVGex+z66Rk
         Zjc1tbkymJAAsrpCk2xJEm3ewMfw1J4xuhbwLdVsTFstRE1aDrnIeEFP4FcaVLGHqgrP
         ibXvycfRU19/k1KtW+OixEldZDinixCHDuuU9v8SnVZ7aac3XEmPtsEcYiJtzYxDDjzv
         rzufy3Wpe0QV7Zr1w4f+vYeOoCtEveYoVtkN+z9hMLLYRRAf+7mHiN0Tq6/AgixcyifT
         ubKw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782975947; x=1783580747; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2gaGwHfqQxRPCSBc97tIJJuTdiSLm3zGrPcQFtIQ95E=;
        b=Hde8pGFAWeDmF45A1gLD1fxbLvui97NjReaet6dSVTphzxJc8MEirOAoZitlEWfE3G
         tCbW59hM/3zetdZARn4+UHUD2hUv3ilScwPLrcVUcwlg7nsEqSYagyl+c+bDz8gwqKha
         zuYJQxqo+5OtPvV1RNy/fRmiEZ3+z4z+ItmjM/gPWVCrMemhnbJBJjwDRc9svcJPsU/v
         lhQQaWOWmumJqXhZJFJ+cCvAht4Cj65IfLSyvUMaEICdT7w54EIeH72VQYUlhIy8vi+d
         ks0dC158vs0ErFcQgs0zzLNKkiuL2LFEmEvo52zZXHQEKsVey65uKiUazJkqTJGB8mok
         loQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782975947; x=1783580747;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2gaGwHfqQxRPCSBc97tIJJuTdiSLm3zGrPcQFtIQ95E=;
        b=LDmH8L9qT7cek3r2CnFbOd+BkrdtwKFjCurq8pAQi/U7gRX20qLSYwLPWZ5LUS9nD+
         CBrb2lzz9JRci4o+XxfOiDofsO6X5KJmZoKR8MneDjeSyQgLtINsqLXF8zU9JJ9i3mDo
         U/vBiQ6zlWl4myfkbz/VXAdmfWz9eL7yebqL11n+Hx1GS0pYwtz/GewDVHwGgLQeLvlk
         Ql3oS0b8rTf5/UPGMRMEynrxFHUJNIkkv6YtMQdQHygrNlzyRBq0wfVUhUdOHcx2GOWx
         5otZA2RP6Hu4mrdNzGFlewkuqJT1yktmTnQouORUp5yVD5mzSfeo6+e8nvA9XISSzE2f
         czUA==
X-Forwarded-Encrypted: i=1; AHgh+RqNYSwQx/z3ba1B1u3MJS7gcyJliQ/NAlz5gXHRQP0VfLPznUyJ56uLXkefoyNLvuimYg8Yu0dbxGP+GQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2hKwOQcWus9VIT0U/vnG1pWaR9SEIl+Np5QymcmqnW5qgJpmF
	gczcmyHRqNTNlwayud/nVHoxgNDv2lYGV4c5CEpPJUyqYJqywv8mSKpQKYZXf8xFi/+8x8NM0hE
	SzFTTJcAsOvRxbP3akq4bGq2+jcMMvghW6q6mvTUDV6wRmdP6q2KYMRQ=
X-Gm-Gg: AfdE7cnN734QA0PDJE8CDJWVrPy397gLDByCDahEsG2CdukZ17aGa0PPxa3Kff6h+0m
	zVD+3pw4Hz0flNOgLkmrsWaPUDy6GrXRDdUFe2rG3jLqDaBw3mIrwM1UoXf7TUSQEdYarmmoxY3
	ufbbPOpMxgBu1Iet0UNIZg4ZQHUbzkoQN5hfsdOKVxpSVjW/aEcFqa/xsGPsn49N6G/z19RkO/f
	JXTllgjrPI+68YuMPHkzFxvdv88b3km2P+z5mKucdvvEJRIYfJfdtY8UQclYdL4qzdxijdTVNeb
	HymVgJXEJO4S3sjP0Vsslowmgo2mWSMJkxMAQJSFp1qzE4KKDMJXmEwtKHtt3tov/ylbMdoZEHI
	VUPGP
X-Received: by 2002:a05:6000:27c9:20b0:460:70ff:fe14 with SMTP id
 ffacd0b85a97d-47759754d50mr5044463f8f.42.1782975947019; Thu, 02 Jul 2026
 00:05:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260624165144.556908-1-neelx@suse.com> <20260624165144.556908-6-neelx@suse.com>
 <867a944d-3a26-4248-b0aa-f10247196502@suse.com> <CAPjX3Fc2tyPw6Fe-SEg+OsMhGiK+A+Y9qRTRfegcKwdK1WqfJw@mail.gmail.com>
 <589e24f3-e3a3-4a41-86a6-5f99ad5487f8@gmx.com> <CAPjX3Fe0xAYM16yrUyPEWChBrS0ow0HCr_u8S2jR+XCnZzxC2Q@mail.gmail.com>
 <5a8f027b-420e-41be-b852-a27fb084c32f@suse.com> <CAPjX3Ff_iG5B=uJp9uJZPVGGbAhp9fErVkHxdOLr5EZNGPMZXg@mail.gmail.com>
 <628d90f5-f2d5-4b67-929f-ad7835e7fd89@gmx.com>
In-Reply-To: <628d90f5-f2d5-4b67-929f-ad7835e7fd89@gmx.com>
From: Daniel Vacek <neelx@suse.com>
Date: Thu, 2 Jul 2026 09:05:36 +0200
X-Gm-Features: AVVi8CdmQJ1si16nsSG-71wzJzip3TI8_lACH6aKFmJbH2cStZ_5YfsOBnxj31U
Message-ID: <CAPjX3FdzjXTR7q8RjOUdu_8h6V5wkBjsUKM+=_9VV=rcg+3FdA@mail.gmail.com>
Subject: Re: [PATCH v2 5/8] btrfs-progs: print encryptin type field of file extents
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2 Jul 2026 at 08:56, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> =E5=9C=A8 2026/7/2 16:18, Daniel Vacek =E5=86=99=E9=81=93:
> > On Thu, 2 Jul 2026 at 08:19, Qu Wenruo <wqu@suse.com> wrote:
> >> =E5=9C=A8 2026/7/2 15:10, Daniel Vacek =E5=86=99=E9=81=93:
> >>> On Thu, 2 Jul 2026 at 00:26, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote=
:
> >>>> =E5=9C=A8 2026/7/2 01:29, Daniel Vacek =E5=86=99=E9=81=93:
> >>>>> On Fri, 26 Jun 2026 at 01:50, Qu Wenruo <wqu@suse.com> wrote:
> >>>>>> =E5=9C=A8 2026/6/25 02:21, Daniel Vacek =E5=86=99=E9=81=93:
> >>>>>>> From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> >>>>>>>
> >>>>>>> Encrypted file extents now have the 'encryption' field set to an
> >>>>>>> encryption type.  Let's print it.
> >>>>>>>
> >>>>>>> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> >>>>>>> Signed-off-by: Daniel Vacek <neelx@suse.com>
> >>>>>>> ---
> >>>>>>>      check/main.c               | 1 -
> >>>>>>>      kernel-shared/print-tree.c | 2 ++
> >>>>>>>      2 files changed, 2 insertions(+), 1 deletion(-)
> >>>>>>>
> >>>>>>> diff --git a/check/main.c b/check/main.c
> >>>>>>> index dedb4db4..a32247b3 100644
> >>>>>>> --- a/check/main.c
> >>>>>>> +++ b/check/main.c
> >>>>>>> @@ -1778,7 +1778,6 @@ static int process_file_extent(struct btrfs=
_root *root,
> >>>>>>>                          rec->errors |=3D I_ERR_BAD_FILE_EXTENT;
> >>>>>>>                  if (extent_type =3D=3D BTRFS_FILE_EXTENT_PREALLO=
C &&
> >>>>>>>                      (btrfs_file_extent_compression(eb, fi) ||
> >>>>>>> -                  btrfs_file_extent_encryption(eb, fi) ||
> >>>>>>
> >>>>>> May I ask why preallocated file extent would have encryption value=
 set?
> >>>>>>
> >>>>>> My common sense says that encryption policy should only be set for
> >>>>>> regular file extents.
> >>>>>
> >>>>> There's nothing wrong with pre-allocating encrypted files. Unlike
> >>>>> compression, the exact size is known beforehand.
> >>>>
> >>>> IN that case, does it mean even a hole will have encryption value se=
t?
> >>>>
> >>>> This looks weird. Is there any special reason for setting encryption
> >>>> value for hole/preallocated range?
> >>>>
> >>>> Can't we only set the encryption value only for regular,
> >>>> non-preallocated extents?
> >>>
> >>> What's so weird about it? Since the inode is encrypted, related parts=
 are too.
> >>
> >> Inodes can have PREALLOC flags, but the file extents are not all
> >> preallocated.
> >>
> >> Inode can also have COMPRESS flag, but the file extents are not all
> >> compressed either.
> >>
> >> Inode flags are independent from file extent flags from the very begin=
ning.
> >
> > Encryption is not compression. I'm not sure it makes sense to compare
> > them this way.
> > We don't want to have some parts of a file encrypted and some plain.
> > A file is either fully encrypted or not at all.
>
> Then you're only cheating yourself.
>
> A simple tree dump can always show which range is hole and which is
> preallocated.

Yeah, that's true. I'm curious how other FSes handle this. Let me see.
Or do you know from the top of your head?

--nX

> > In that sense we are being a bit more strict than what you may be used =
to. See?
> >
> > --nX
> >
> >>>
> >>> --nX
> >>>
> >>>> Thanks,
> >>>> Qu
> >>>>
> >>>>>
> >>>>> Simillar to NOCOW, the encrypted data will be stored with the next =
write.
> >>>>>
> >>>>> --nX
> >>>>>
> >>>>>> Thanks,
> >>>>>> Qu
> >>>>>>
> >>>>>>>                       btrfs_file_extent_other_encoding(eb, fi)))
> >>>>>>>                          rec->errors |=3D I_ERR_BAD_FILE_EXTENT;
> >>>>>>>                  if (compression && rec->nodatasum)
> >>>>>>> diff --git a/kernel-shared/print-tree.c b/kernel-shared/print-tre=
e.c
> >>>>>>> index 0afa3696..159f0825 100644
> >>>>>>> --- a/kernel-shared/print-tree.c
> >>>>>>> +++ b/kernel-shared/print-tree.c
> >>>>>>> @@ -471,6 +471,8 @@ static void print_file_extent_item(struct ext=
ent_buffer *eb,
> >>>>>>>          printf("\t\textent compression %hhu (%s)\n",
> >>>>>>>                          btrfs_file_extent_compression(eb, fi),
> >>>>>>>                          compress_str);
> >>>>>>> +     printf("\t\textent encryption %hhu\n",
> >>>>>>> +                     btrfs_file_extent_encryption(eb, fi));
> >>>>>>>      }
> >>>>>>>
> >>>>>>>      /* Caller should ensure sizeof(*ret) >=3D 16("DATA|TREE_BLOC=
K") */
> >>>>>>
> >>>>>
> >>>>
> >>
> >
>
>
