Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D2D3E63AC
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 06:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788417028; cv=pass; b=X61FuSjmxAiorAqDHyhJIWfaoPF8GUwmzDYJwgn/hEWKieyJS+AqwdhHbv+2HAS2K/ZFM7KQLANL0h4RQ95REMTD7oUzHA3W2kdDfMYaO4IpwYJ6VjeaxgPDWnIrocR47KXSksxzUFqlibMEvcAxTqywh733zLfUbfKsNyx4HeU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788417028; c=relaxed/simple;
	bh=L9YgzqImgQ2fykCLgCALgMOmQZUccvtdJFWoTXEoZ1Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o9X5OeQTA//sEVmGz3iMs7xC84CRSvqeXRCn8AYCijzI/2yFgjYZ0Mee9hlUUCMou30FT/J17SXAmG9tRyTVWlyskATww/jmiLNH3Ibya/9HrkW4RxCvPOjy6p1VY2YZgrLD1sdf7SSbI5KxKrrvAFnZp5QcmGlED/6raY9joIo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FGFCisSN; arc=pass smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FGFCisSN"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-482f2ee53e7so1193280f8f.1
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Sep 2026 23:30:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788417022; cv=none;
        d=google.com; s=arc-20260327;
        b=Mqh7G+CFNuJz2Q8S0UkoGS+IqwoQQPUpV1QgHc41tniQRb3X1r7Rdxx0QYFWRvL6ui
         q6KmiShW5ZH4qqq0+ozftFiWhzcrr63iCByRKlQbt4OursPGtt+e/FP6aTUo69v5bw5h
         FUKtZ5j/5EahEmyQ+KwMHso/qaBt61yTmlrJ1a+LYaBrX937vAkAwEBAIEQx9t2wmGnK
         zuoVZ2u54UTnjmxNmrVUVxt+kVJUk1SsXaOqS5bPPiG9OfF4XzXatB+DBJ4onf8k0kYT
         0UneDOt9XbmJnEEJ1nr7MDD/IGgdbJ88u/mKeLDdAYFKt0VADRLiHH6V713KqzjJsCZa
         0Rcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WKRkbKkaEYv3dMPNaQzFCGDU7wkRpO5gV3nKp7QfhWY=;
        fh=L7Tfyh8dKFrUYAZeRm/mRrqo68tPzulHlQ0WBhjkoGA=;
        b=AyAgywodyDonSLsljcUK95hANv4IlsAkJJyo6F8OIJmTbxTtaxFV8s8AZ8PsAEwGHA
         eUeFuwoZu5L8ewkjkUs2S45tjKRCeYt2ClcFvDknl/l/iFbzhdKRXZ04REIhFfBQvEOO
         2enAmtzjxfQoZhg9+oJ8NEt/ITMrgntzo31D5PcWY6zJNfqKBYkfqJ+6XwNhH18rlU+E
         0izokgOmTQ2vd+kTGSQHCvRP43YzeLYgMuaByBSXcek779ED2KcDUpVwftolKAgrygvE
         5//CdOPvf5skHhK0pJ3yTG3khBMlIT9H3hz2kVe1hwNwQw5fT0a/j+f0d7RzhtmDxfmL
         Q2Ng==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788417022; x=1789021822; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WKRkbKkaEYv3dMPNaQzFCGDU7wkRpO5gV3nKp7QfhWY=;
        b=FGFCisSN0l0c9VUIKb3TMDHwXpJx8mogtHAeA+oEG+pV8WRe+l5eaPwRN6wQilDsTm
         2LCKn8lrVf4Q5V/4YgNv9eeJoxZVc0m+DJs4rigJ47nTRArzPjPYiqeIB+dfN3FmbLi8
         8bfWuyks3mfgJFCJ/mBlWY2w/W4PXKbMkDT8it6vtvkLW8k8PMAsc4qbtKymWnS6AINg
         jh66KPusCX7HHKcVBBHQHfUxDfZmbha856c+Bs0yk9pTPuOiglzYN9EMjMA7Cv+pIaON
         55yJhGJathZbAGeqLR4ygGMlYd+6gjPYyLNljYyukwi9QizV64BNzVH7HDVrIj3VFq6o
         tRGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788417022; x=1789021822;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WKRkbKkaEYv3dMPNaQzFCGDU7wkRpO5gV3nKp7QfhWY=;
        b=G+j1McZVE2qv+saQXkJcBQNEoWhy88UdA8NL6G3qCL3yRAlcPz5DdCLkTioL1UtUIw
         AbUzLvRGV1XxErTRrSGaP2/k4xHp45XE56QJeUyOdRthVhiXznNG3ZWiNWg0cvFQYzyS
         8OEoGp6TPigwrOKyomLyIYBFg2CZx2D0zgMCrMxK798lGmLGyK9YuLm/dva9vn6Ufkei
         fwmpg7MvK29l3sVaBLfa/Q1Ch+nhUrWFsN+y5YDrOgqvdGVoY51BDno1zbbPkEqzaO7b
         zjX8Avr0NJ2JhgP3CX8byRJtqvj85BJc0XuJ7gliRDgNHLvNu792EJmH04OIqoZe8hRd
         H8zg==
X-Forwarded-Encrypted: i=1; AKwUvBxMJhpHPc7toENkEOWXT8TRI/qZWvpNiYChiWlBfFYvQOtqCAzoDo6HwgjOwAnnfxrvAK6GzIQu+lD8qg==@vger.kernel.org
X-Gm-Message-State: AFuF++kfuB30tuAXY6OMTR5PHk05xgMEZU3H0pFbto1kG0V+ilD+gZYo
	Rm9vJaeqrQvwbuPYWjGadWAqDWilv+faWgxUx2wI1G4I6TMqMof+VWCq8qAn+MoFs4WarUz3+fn
	/7Z6kAB0JEr3aq9dunPUtRi3jH22lZkU9QiavyebV/Q==
X-Gm-Gg: AYBFou2vUPYza61JHjgXelrdC40gD3Ip140yZfQTqheis4wzZbcfkOYv/197a+gwcBw
	pVgs0NyYrLN2s2ZH0dNsm1AKbX8kcQ4pkysQAS5WkxCVDVNeX//WwWLvRa9MhSXdSW7sKw487ib
	eM8rXCCrrPWCQhmJtZ7hMExTvEP4lZ0zDaqtX2+eqkA09YO6hOeDGXVLgrDVY/4IQ/8wWZBCzxL
	TvjvekCYhmyNl1T6Q9vBW2I7FQnkbwkHBSuezsUg99Z9ZZCO466R+sC/6ar2HIO7QlmzVSFGxRq
	EM3doKGAePmrV77RTqJZwKHUhMq3B1+Pb0cFQTjcLeHfQh+FrCP0evVeNO9Wr5UGoUmd7c9mtIj
	zQdGIZXtVWdzbUQX6FSG0f2FpiBCX7Ky20g4SaEVr9g==
X-Received: by 2002:a05:6000:491d:b0:47f:80d1:be0a with SMTP id
 ffacd0b85a97d-484913b985fmr18395121f8f.14.1788417021740; Wed, 02 Sep 2026
 23:30:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ba5fc3c9b2de187169552786c1fde4e2ebcef0f6.1788220853.git.wqu@suse.com>
 <CAPjX3Ffo1jF0=u3atBr+mdco=aYFGU5GWQ6FNtuzgFUQEMvHdQ@mail.gmail.com> <ea64c701-f488-4cca-ab2d-59c45a2b3604@gmx.com>
In-Reply-To: <ea64c701-f488-4cca-ab2d-59c45a2b3604@gmx.com>
From: Daniel Vacek <neelx@suse.com>
Date: Thu, 3 Sep 2026 08:30:10 +0200
X-Gm-Features: AcwNN1XG2g5YWKxNHSgy7g_B7-PqR0QDzUk5-JT8ZWhOgCNBOsEc6NBtPaSoaeA
Message-ID: <CAPjX3FdcCyuBPAzv5pAWSmrwQZn7rwRky5ze0w5qpLJN9eKLjg@mail.gmail.com>
Subject: Re: [PATCH v3] btrfs: use ordered extent to grab the logical address
 for submission
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, Boris Burkov <boris@bur.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2 Sept 2026 at 23:44, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> =E5=9C=A8 2026/9/3 03:53, Daniel Vacek =E5=86=99=E9=81=93:
> > On Tue, 1 Sept 2026 at 02:02, Qu Wenruo <wqu@suse.com> wrote:
> >> +       if (!in_range(filepos, oe->file_offset, oe->num_bytes))
> >> +               return NULL;
> >> +
> >> +       refcount_inc(&oe->refs);
> >
> > Thinking about it again, do we even need to raise the refcount?
>
> That is to co-operate with that btrfs_put_ordered_extent().
>
> > One reference is already held by the bbio itself, so the lifetime is gu=
aranteed.
> >
> >> +       return oe;
> >> +}
> >> +
> >>   /*
> >>    * Return 0 if we have submitted or queued the sector for submission=
.
> >>    * Return <0 for critical errors, and the involved sector will be cl=
eaned up.
> >> @@ -1833,8 +1848,11 @@ static int submit_one_sector(struct btrfs_inode=
 *inode,
> >>          /* @filepos >=3D i_size case should be handled by the caller.=
 */
> >>          ASSERT(filepos < i_size);
> >>
> >> -       em =3D btrfs_get_extent(inode, NULL, filepos, sectorsize);
> >> -       if (IS_ERR(em)) {
> >> +       /* Try to reuse the existing OE from bbio first. */
> >> +       oe =3D get_oe_from_bbio(bio_ctrl->bbio, filepos);
> >> +       if (!oe)
> >          {
> >> +               oe =3D btrfs_lookup_ordered_extent(inode, filepos);
> >                  put =3D true; // or !!oe
>
> I prefer not to introduce an extra if check just for a single case.
>
> So the existing unconditional put and refcount inc for the OE from bbio
> looks fine to me.

Fair enough.

--nX

> Thanks,
> Qu
>
> >> -       ASSERT(!btrfs_extent_map_is_compressed(em));
> >> -       ASSERT(block_start !=3D EXTENT_MAP_HOLE);
> >> -       ASSERT(block_start !=3D EXTENT_MAP_INLINE);
> >
> >          if (put)
> >
> >> +       btrfs_put_ordered_extent(oe);
