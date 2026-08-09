Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5567E0FF
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Aug 2026 00:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786235764; cv=none; b=HdmUtzYXCFrMhNXAmBp5mmImFc+NGanfrVFupBuDJDz4s7l81WW9gDMdXV7H53S53BRn6c2YMytkWy8GQ9kgefcmBW7DCASgI0ATo9rq8y73mAhctV4fzJLdthLJqVDIrCOKxD0f7+7yYsMia4u/lYJq8rJV+W4V87kEHNl4e/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786235764; c=relaxed/simple;
	bh=OyWG0OOPeHcNz5QMYDsypgeuqdfk8IcyIHlrmSsd/T4=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=ilmjtuKODJ3s921cMJ/kt9qt72YAKGRdbmnJB8jLZ52+T9Wt20y4NsAlyIOTfjg/RV4BMu3UrbwvQVaUVGi487gzFVhnRHaIrGYzza4xP1j2j/a201E4eDBx0F90li9M/XB/kn3m3TzIJ2oKz2K3Wnr3rbsoEwP7FMxI/4SCoqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c50L02/G; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c50L02/G"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-47de008b020so406395f8f.1
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Aug 2026 17:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786235762; x=1786840562; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=qAEzwokH4x2FKIYGJZGPxybGV/4bivWitA6nfiINZl8=;
        b=c50L02/GfrhMiFYnDlgyoU420CAbjiqOFvE0M2n4SnN8jVAU286nlzEzJUTIYhHmhO
         qNJfj7d+GWlZ5CJNwBJD6JrTxOLsrwGgb+KmGhGqjyh8ihGGZD+/VCG8neEgbLbWRzxH
         OzuxrG9mql/OGVAi0b1aNckaEtbzbWSsYgCfydafpWB8gsSkE1hNzIyk7qK2mlnWcVsz
         scVekIat/jEDN845u08kCuiGBDQCXoGqfJz6gqeLMQuzMq5YR+VUXusTTgl9P5HbMeAf
         xMOFN0UFps00ny8uQiWv/2hCbGaFBqCgGywvs1km5m/+Uh08VrQ75DSTL6OaXAM1XRmM
         x4og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786235762; x=1786840562;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=qAEzwokH4x2FKIYGJZGPxybGV/4bivWitA6nfiINZl8=;
        b=JdTwIey6BgXNahD4pUfvz3/ydEL2e/AYA3os3a8vOu5KvozR88zKDozzrpLrEJONSf
         GZXxUdnqA7Cg89jH3Q0Kjj6Vs01CtvJhcVyiXMR6ze2/nUkMiVHpPMCAYD9QQprGnPhr
         S5zx7EQe6Cvv/mckjrGFvCGYqCKc8Jaeuxzer5XYb4a6gTbQtK4kDPriqo9uZAt+DZ0U
         18jFQQQ/D7dBda7wCTNnofGzyNctrfRzQdEzztHesOjcub8w8x5DWNzWEKcZsBo8bSOl
         xntObShm8zylQJR5N2PQ8k6lSeNz1GvtHzJubRl9iOTxzZKGB0O8xZx3jWF5YNQ9S2sE
         i56w==
X-Gm-Message-State: AOJu0YxpD7erHMcXBOHb4G/jQq8PTVDp5T8bTQfPZv5VZ8Tjk9I3S5Sf
	Li0xVXOR98ZVFb5YwhbTE98TFi5eTBRHLrC4pUJEXhssk1P+NhpuULp9
X-Gm-Gg: AR+sD12lna69xsrMRbwX7cbjHnqt6SudF8gD4kj6gVyx2pdgHrW0qEWWmphbR1b+Y0U
	OW3GIUHWJnw5Ex/R/eB9Viea7UnlgisjkFBoRk2I0a1aBM9O2mPEG4E0xqvRvHvZGtEwraFdYFH
	F7hws4LBH/qw8Zd1oEkkhRQHuotGQxowvcBlrFMB0Q7ToUHNHyJKlLI70XagsPtu0E2RlFlzBSv
	Uzp5Q0H8GttCthn9rzn61JxYbIbQ7H9jd28BUptQ8yocuq+T5Z+buMtNUrdM2jSVlmkLYynjbG4
	pe85Emgi4REzHlIWzZ+Z0zgz5Dv6R3x3c7rEXFxu8Z9PhP/bh/TQwkCjzNTswFAv45mxRCXv056
	GgcsLUslkOscxKj2BLgUFBVlImCQcJgA8FgS5tWY13AsLfy0dQxDYcXpc1g5uxXVMNGsBoVBDFU
	j1tlPj9J97xQWDFy+4DYfI+soI/Y7F8U8xdxc4YDXOvCfZ+ZHZsbJ0qcL6
X-Received: by 2002:a5d:64e7:0:b0:47f:8abb:1fd2 with SMTP id ffacd0b85a97d-48131915e9fmr11571482f8f.3.1786235761695;
        Sat, 08 Aug 2026 17:36:01 -0700 (PDT)
Received: from localhost ([2001:b07:5d26:7a6a:a8a:5bfa:f87a:3c1a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48002145679sm18314987f8f.3.2026.08.08.17.35.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Aug 2026 17:36:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=7907688315566b39aafaa33023909ff835bc1e0902629a30239d56571071;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Sun, 09 Aug 2026 02:35:56 +0200
Message-Id: <DKJZQAFIRW7H.3KE8DKWO5E3TV@gmail.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/4] btrfs: add per-inode compression levels in xattrs
From: "koraynilay" <koray.fra@gmail.com>
To: "Qu Wenruo" <quwenruo.btrfs@gmx.com>, "koraynilay"
 <koray.fra@gmail.com>, <clm@fb.com>, <dsterba@suse.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260808023459.1494928-1-koray.fra@gmail.com>
 <52e06b50-b888-48f0-a574-91e1192eda73@gmx.com>
In-Reply-To: <52e06b50-b888-48f0-a574-91e1192eda73@gmx.com>

--7907688315566b39aafaa33023909ff835bc1e0902629a30239d56571071
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Sun Aug 9, 2026 at 2:17 AM CEST, Qu Wenruo wrote:
> I'm not sure if this is the correct behavior in the first place.
>
> As you already mentioned, zstd and zlib have very different compression=
=20
> level range, using the incorrect level makes no sense (and it's being=20
> clamped anyway).
>
> I think we should go the default level when not specified, which makes=20
> more sense, and that would definitely be something worth fixing.

Yes, I also think that would be best, but my main concern would be it
changing how chattr +c behaves (I'm less concerned about the btrfs prop
set file compression "zstd" case, since IMO that implies the user wants
the default level).

The options I considered were:
1) keep the "bug", like I did for now;
2) keep the "bug", but only if the compress=3D algo is the same
   as the btrfs.compression one, if they aren't, use the default for the
   btrfs.compression algo (e.g. compress=3Dzstd:15 and btrfs.compression=3D=
zlib
   would compress the extent at zlib:3 instead of clamp(zlib, 15) =3D 9)
   (suggested by Zygo);
3) fix the "bug" entirely, which is what I actually accidentally did at
   first, by just setting compress_level =3D inode->prop_compress_level
   without any check prior to that (which means that by default it would
   use algo:0).

Option 2) is probably the best compromise between breaking existing
scripts and the behaviour making sense, plus it shouldn't change the
chattr +c behaviour, since btrfs takes the algorithm from compress=3D.

Thanks.

Best,
koraynilay

--7907688315566b39aafaa33023909ff835bc1e0902629a30239d56571071
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCanfLbgAKCRDmj22qf5IG
XC1fAQCjDaoGlHK6wNF74nDwb0DXfkiQw308qUQNXltswcuqbgD9HsUbkHvHzVUu
pAkrDaEFxi74Y3/Uub0GDF8381vU2gE=
=d4sY
-----END PGP SIGNATURE-----

--7907688315566b39aafaa33023909ff835bc1e0902629a30239d56571071--
