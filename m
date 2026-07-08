Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85C21A9F82
	for <linux-btrfs@vger.kernel.org>; Wed,  8 Jul 2026 05:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783486865; cv=pass; b=o0QltDZBncfjVah8GHFF+0VWzzYJm11TWl2bx7v1bCfrPT0hyAS1vkC3llSlqFTbWJ+1cpum9Awya/+aEfLFFj+JC/OJPg0vjx0D0ETwDoAXJV9ENSl6/KAIl/qpQ0mxtEg6xK7tywf9ohu1wyPA0dqybeb+/xCfS/V+EQIM0Uo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783486865; c=relaxed/simple;
	bh=Yq9AY+SNDRIVA05sdWC8oX8eKkAjkemflouZuU3HZjE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dFzC7rT4XL079rnqkhE8zIdI+ZZ20EIyDRSNwncca1QtadO0OyHUbBqLQNhiHiyYNjJzyrOCZxWSWg/uZCQX33Jo7ptXj2ndRK1CAsUpaKyUVwGmAFVPl3Rc0kI1KSyP4BC/bWOW4A6ZAVT4C/BXIgB3v6gXoXHlBgl2dMbyASw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=A3L2wzBp; arc=pass smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="A3L2wzBp"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-47362928f65so194036f8f.2
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Jul 2026 22:01:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783486862; cv=none;
        d=google.com; s=arc-20260327;
        b=FEuu9wEWgGhZ9uLDSZbGog51r6RACucbQgmeR3P0peuEjIODEeX983V7lNb9eB4B/l
         PGUOCFEUdtajzHRp1MVAiyPsslO0lDL/2ZscMgMuv9+c5GE7YbjKDY/bz7tOUdIkM58Y
         dPhki7LqROmsfIhXBDqlGTuWws4WXe4ACF+DXDKX/NNZs6yITO24fJ7rEu92kabxz5K7
         kZYszT3PThcNC1bdm1OLJYVs8rPafA+4Bf8ch/hEBK2Wao8QFfXg1Eaej4dNMOke2aGI
         hhCR6036z5Ns77dG4VFH+B3vgXB9XddavCpOzuSKhOSa/WAYuZcDWYOD/cegS/4wDPzH
         MZPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HkVUzOAvhw89eY0zqz36cWIho0t+4/dbG0H4cZjvMo0=;
        fh=wO1H6uVVHcTGY0GQFP0+ZzuVt/BIExorVz2MJR6dqAI=;
        b=UW+r6nJps0bIV581yUJFEUxqb1xxeBnc0mGG3uRge+T3TTp4jFO5bl2i3yCfm5w7OH
         NSIX096Y2OtaGU16K7/1YNH9BIiZUkkn2ooEZ0UxkiTcZsUTBIcwL5iPAUw0tPEGoV5L
         MRyPsWYtOy4/kjiCcKm2GlI61oj51UrAtxRGTRSCAFKBVz88CiY8hLUAqDbkQFKG6Dhb
         wAIy9Igd+em6HUrk7uij5bI6dFyuVSwp14Ov3bhHbVJHdnJ+6oSPbE8WdakKQggmfNCG
         GzqAdNT8HCPIthC1eJK82nS0o4j7QFrcFZYQviQOaqLtM3WdTiICbGMyQLIVD3BPEFqa
         4rug==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783486862; x=1784091662; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HkVUzOAvhw89eY0zqz36cWIho0t+4/dbG0H4cZjvMo0=;
        b=A3L2wzBpE5DB0z1DRCIdyzwO+XzrhX5GQLA/50q+407a9uw5Qz+meCKiEqj78T+JjS
         ggSGcgv/Ozwx2AUpCtcyOynMVaCxPUQua3sMOFB8ro63Gg3zvFLRLpI/M9Zgk+OWNj7U
         6A++Z9ABP52mvooUL+8kUAxiI1rZhvp3E1Jx7O8kPJG5ZPf0xvaxzqB4dtXIpVKNEFst
         bxuNFi3XT8WYZ6CEbEzUch0hrgvAJyLCuYXNiRed60g9FShEUFfSRgQNOMg36/vEjyRe
         Bsx/IXPDEuYfA1/kCTH99P/0AT18eVJ4FcMu/B8vsExe29Qg4mNp81Fm4yxGxyWRWFUC
         YeYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783486862; x=1784091662;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HkVUzOAvhw89eY0zqz36cWIho0t+4/dbG0H4cZjvMo0=;
        b=k7rzCujPguItQm20dqHDe6B98i2A/nM3V2KFW13OntqSpc34FxKxg+WK5wOpIax3Bs
         yl99Pfz0v+SghtFIXsIywoCcCeH5NIxH4594uSaN5rb0OviVPOnqYhBX9MBGRdNXBAU0
         Ur5Uy/42xTiTSlyrQ2XDCWynIMFwAHlSql9P+7iJadXXznteLqyamvaVbMGPpC3fjPk2
         HeXrr/TkAZiGj53P591+kfVrXm3HxJX6XfU8QgvpbnmZe2DEDAL4M8ahwMyaVWJO8YGq
         aP6gcrr/DvlSdAFvRPfkzrZkrABIIeT28cBzqgsJxH2gmyJhsEM8kkx3q+gEFPNj8uNU
         u/uA==
X-Forwarded-Encrypted: i=1; AHgh+RqfKtI980SSCnD3BxLS7wvbHPi4DAnAcuNMPd8eP8g/dFzsWtEAsWNGIvtutk17OuSmdZ9aoBQUdpV8tg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxySGv2modrVuBUP5e0Q7J0I0KkQ7mSGP68zVqzMGT9l4jwUi6K
	e2Hi5XvUlEJZZCZxUQAUPFwzmjOZZuSROewP9nxgvYFvxF546QNU/aXTETjAHDkgsGjUH+9dM0F
	fgBsvubVlQrRPFbFC9WFHy3vuIn91eZ9xAjdi/3iqxA==
X-Gm-Gg: AfdE7cl0RXBh+BPRTG7hKt73QpnNJp0DUDoBGPcg1RbjkLHGtJu51YD3nyA2s0qVP/F
	BsqSTSMpLmmHBgm92haSjNHq6pxpdz8e6ZBt+Kos1JGvnVG9YqANVpAImtt5JUcZ+EVpIY/vaty
	MhdtohgX0Q0fnjMzVYlob2pinxfbv1sSoeg17F5mSy4HzfaaGCi873IgwSa8FhD+41cvujYAvLh
	iNXdYqGo1d3j2BkqZcOYLTrNtNdwDd973qQEDZW5BaEUhKhI5VlUzQEk9vNdoOfKfbC66KcwC92
	x/BMXq6I53zNujRmuG8v8u8L0BJMLhY2R673RP675VcDfNsiJrVbZ6gI87ozECZTImaZDw==
X-Received: by 2002:a5d:6f1a:0:b0:472:326c:a4a1 with SMTP id
 ffacd0b85a97d-47df07642f5mr642502f8f.22.1783486862187; Tue, 07 Jul 2026
 22:01:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260707142736.2330146-1-neelx@suse.com> <20260707142736.2330146-7-neelx@suse.com>
 <12ca4ad2-0b35-41ef-8527-7a047549986d@suse.com>
In-Reply-To: <12ca4ad2-0b35-41ef-8527-7a047549986d@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 8 Jul 2026 07:00:51 +0200
X-Gm-Features: AVVi8CfQEofeX37aIKCi9YTeycJWpcevUfQhSGfD3fO0im6r8VhzmfSih0bLW3Y
Message-ID: <CAPjX3FfsH7tG3jy3nezrr0371EWsYx1hJEkT+b8CQF2iaMrMoQ@mail.gmail.com>
Subject: Re: [PATCH v3 6/7] btrfs-progs: check: update inline extent length checking
To: Qu Wenruo <wqu@suse.com>
Cc: David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 8 Jul 2026 at 00:43, Qu Wenruo <wqu@suse.com> wrote:
> =E5=9C=A8 2026/7/7 23:57, Daniel Vacek =E5=86=99=E9=81=93:
> > From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> >
> > As part of the encryption changes, encrypted inline file extents record
> > their actual data length in ram_bytes, like compressed inline file
> > extents, while the item's length records the actual size. As such,
> > encrypted inline extents must be treated like compressed ones for
> > inode length consistency checking.
> >
> > Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> > Signed-off-by: Daniel Vacek <neelx@suse.com>
> > ---
> >   check/main.c | 31 +++++++++++++++++--------------
> >   1 file changed, 17 insertions(+), 14 deletions(-)
> >
> > diff --git a/check/main.c b/check/main.c
> > index 9447b01e..cadcfef0 100644
> > --- a/check/main.c
> > +++ b/check/main.c
> > @@ -1720,9 +1720,7 @@ static int process_file_extent(struct btrfs_root =
*root,
> >       u64 disk_bytenr =3D 0;
> >       u64 extent_offset =3D 0;
> >       u64 mask =3D gfs_info->sectorsize - 1;
> > -     u32 max_inline_size =3D min_t(u32, mask,
> > -                             BTRFS_MAX_INLINE_DATA_SIZE(gfs_info));
> > -     u8 compression;
> > +     u8 compression, encryption;
> >       int extent_type;
> >       int ret;
> >
> > @@ -1747,25 +1745,30 @@ static int process_file_extent(struct btrfs_roo=
t *root,
> >       fi =3D btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
> >       extent_type =3D btrfs_file_extent_type(eb, fi);
> >       compression =3D btrfs_file_extent_compression(eb, fi);
> > +     encryption  =3D btrfs_file_extent_encryption(eb, fi);
> >
> >       if (extent_type =3D=3D BTRFS_FILE_EXTENT_INLINE) {
> > -             num_bytes =3D btrfs_file_extent_ram_bytes(eb, fi);
> > -             if (num_bytes =3D=3D 0)
> > +             u32 max_inline_size =3D min_t(u32, mask,
> > +                                     BTRFS_MAX_INLINE_DATA_SIZE(gfs_in=
fo));
> > +             u64 num_disk_bytes =3D btrfs_file_extent_inline_item_len(=
eb, slot);
> > +             u64 num_decoded_bytes =3D btrfs_file_extent_ram_bytes(eb,=
 fi);
> > +             if (num_decoded_bytes =3D=3D 0)
> >                       rec->errors |=3D I_ERR_BAD_FILE_EXTENT;
> > -             if (compression) {
> > -                     if (btrfs_file_extent_inline_item_len(eb, slot) >
> > -                         max_inline_size ||
> > -                         num_bytes > gfs_info->sectorsize)
> > +             if (compression || encryption) {
> > +                     if (encryption)
> > +                             max_inline_size =3D min_t(u32, gfs_info->=
sectorsize,
> > +                                     BTRFS_MAX_INLINE_DATA_SIZE(gfs_in=
fo));
>
> The change looks good to me now.
>
> However I'm just curious, is it possible to limit the encrypted data
> size to sectorsize-1?
>
> Or it is some fscrypt limit internal requiring a power-of-2 size or just
> lack of interface?

The encrypted data has the granularity of the cipher block size. With
AES, it's 16 bytes. Hence why.
Eventually the best we could do would be sectorsize-16. But then, if
the cipher changed in the future...

--nX

> Anyway I won't object this new change.
>
> Thanks,
> Qu
>
> > +                     if (num_disk_bytes > max_inline_size ||
> > +                         num_decoded_bytes > gfs_info->sectorsize)
> >                               rec->errors |=3D I_ERR_FILE_EXTENT_TOO_LA=
RGE;
> >               } else {
> > -                     if (num_bytes > max_inline_size)
> > +                     if (num_decoded_bytes > max_inline_size)
> >                               rec->errors |=3D I_ERR_FILE_EXTENT_TOO_LA=
RGE;
> > -                     if (btrfs_file_extent_inline_item_len(eb, slot) !=
=3D
> > -                         num_bytes)
> > +                     if (num_disk_bytes !=3D num_decoded_bytes)
> >                               rec->errors |=3D I_ERR_INLINE_RAM_BYTES_W=
RONG;
> >               }
> > -             rec->found_size +=3D num_bytes;
> > -             num_bytes =3D (num_bytes + mask) & ~mask;
> > +             rec->found_size +=3D num_decoded_bytes;
> > +             num_bytes =3D (num_decoded_bytes + mask) & ~mask;
> >       } else if (extent_type =3D=3D BTRFS_FILE_EXTENT_REG ||
> >                  extent_type =3D=3D BTRFS_FILE_EXTENT_PREALLOC) {
> >               num_bytes =3D btrfs_file_extent_num_bytes(eb, fi);
>
