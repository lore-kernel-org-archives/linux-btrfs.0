Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64899353A91
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2026 02:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786416942; cv=none; b=A1pd0543NTanSYkXBuah6a4c6QFZ4FZk5pG9Sst4x52qDn316xM78imzWhw11pOgPVCS1yGz2GObMiR0V6tghJorewu5nY8XTfOI07JNpcODwd7qQpVxB6izJL/I/yOIPnGZ2IgDNu/G5QYCzFgZ2z6RDUeuyT90xnerxP81KME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786416942; c=relaxed/simple;
	bh=wXFpf9Iczop0+wGHe5CgbmZj9L4FcxmooS24MXg5RYs=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=dTYXoAu3AccLo4z60ljucbIPnZdJRVR9AUpckpIQv3HMYe3msOWEMdkIpK6AdoFsVg16CIBJkMN2DbtU9Myu49CTUzqoOibOph2frXvRDoId4F1SZjNXAGalTtFBYfr5v5TFFNTvCHD6Blf7CuJJr7nAxC6nIVoOx5Z8EmFOCqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pjDcQAKp; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pjDcQAKp"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-496b7622a83so24315265e9.2
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2026 19:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786416940; x=1787021740; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ODl5FLyS4hai04hZuOAA/+JK72WmUclkGCFzJm1wbug=;
        b=pjDcQAKpJqIGaHJm0M/cwH4q2hAAVF7kgnZQMgAMpBeDlvee2Y3IN/Mv2U22TNVFZV
         +LNlS7xm40a6r47g7jg3I8huZ+4I/3IoGQ7mFI29moZ5sHziVRlGzFuUoObH6vxg6sPQ
         dSq18FzUdgTnIGzSf8ibTGj4VphSDICk+bqlRf04MbfxpNGWH41AQJYoSkYb8UBd5kFu
         1q5rClDP9k6Zsyn3ZMijQQU6tCLmmfVmVbjI1d0lOA8xrH4UP0d5ymEJwJD1Ji/XP/6I
         iZ1NNTboUu/nmvZjoYu4iQhb2NxZ1WIMuSAUSF7jBCT/v8uif+DZSFWTotWBFZg9may/
         IwBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786416940; x=1787021740;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ODl5FLyS4hai04hZuOAA/+JK72WmUclkGCFzJm1wbug=;
        b=aBc6y1viuTl6qcRaQ9Qg3UJAMbm6624/xC/9ZlsF3ZLGZ+IVxA7Fe/PPgEb1qx+Uff
         qIkHJKv78DEDxeJwI1QlkU2iuRFGbgvSs9IJ5EJn6Gy8xW2abzyXBmf55h4doG5rulNY
         64EvOJ9Whuo5RS2PA6oCLfftf9lzH84i/rvusqMqt7oXlQXcCsiLdT4dzsq+DB9BO5yP
         sEBTZCVKy7X5UGC2/jqdRQ9/99kRmZPaKbVUflsZobGpKlnWwXLQqt7w3E3J6tyE17sG
         +ykPlzjIkMXn/2F1a3BnX0oDNjdBtt47wFmNDF6Tw8L1P9IjvaYx80VapOX8Sz/nRxp9
         u8Kw==
X-Forwarded-Encrypted: i=1; AHgh+Rqw8MBtQ1O9aQkJQkNXyCV1xYO4Vhy7a5FbtQ7UamC8e4tSex8hHSWb/Ap5smM/4OGegSKL4OWdjYGHQg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzMGOiwEuFfCKzJZBJUB8BnGTV23Wf+y12iKrpqOs6RuFqa95Zh
	OIqZSj/HuHlp77eJ7pz3mtrNatVzuTPkUi9FJ9MMTZsO6XFZV5NNFoj/
X-Gm-Gg: AR+sD12fw654RpKCaWL8g4ofSzxIGMrNqkVvqETfHcr6RYusRDUCsk6iQ6Q8slbpLj6
	oRHRjwEDjdjpzqbIzZbjP/jvP79BfdrXujqvjNg3k6ZLHmyXtOY1ELUWxRhgzDRhGA2tPBAkODF
	uGSu1vUoik8hNtt6Zbr2C3A6xCc6gWrHyrSiAkmSeb3KfLQYDcK3OPnMcgVPuQKWJm94WTZvd8L
	u848gEbJIambMHlXoFFr4T/Avi3AyhJkXwyswTvVymKHay2mxP7hB8Lf+++Q6qM73DZuUmPGTxZ
	SKeSHiUoOktAw7dZEHhY7GWTEUsdhj9OuQ/ROrpFFN/k8XUtk45yj4hvfK1O3igGIt9zLYdoaoT
	Nn7iW4pAJb6QQrpWfHNoCql8HngFRWrioFPonAmDUzCx997vY/R2AAPx8pyzxvcsgDp6WbItbzG
	HcKTyNGUDPiOk48NDHMycAPZFz+Y2IAuBVOvnsVMqcvaW3PFPyrcgaKVhf
X-Received: by 2002:a05:600c:1390:b0:495:7888:281c with SMTP id 5b1f17b1804b1-499783b2f8cmr4403285e9.0.1786416939528;
        Mon, 10 Aug 2026 19:55:39 -0700 (PDT)
Received: from localhost ([2001:b07:5d26:7a6a:a8a:5bfa:f87a:3c1a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499788a6cdfsm1043705e9.6.2026.08.10.19.55.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2026 19:55:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=d75849c250aa9f2107e113a1f8c507abc5df9766d5b08dff3bc1af586e05;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Tue, 11 Aug 2026 04:55:33 +0200
Message-Id: <DKLRY9Q5SEI3.VUDASVYPW9MY@gmail.com>
Cc: "Zygo Blaxell" <ce3g8jdj@umail.furryterror.org>,
 <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] btrfs: add per-inode compression levels in
 xattrs
From: "koraynilay" <koray.fra@gmail.com>
To: "Qu Wenruo" <wqu@suse.com>, "koraynilay" <koray.fra@gmail.com>, "Chris
 Mason" <clm@fb.com>, "David Sterba" <dsterba@suse.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260809015054.779137-1-koray.fra@gmail.com>
 <20260809015054.779137-4-koray.fra@gmail.com>
 <870d7e1f-3e87-4eac-86fe-107af7336101@suse.com>
In-Reply-To: <870d7e1f-3e87-4eac-86fe-107af7336101@suse.com>

--d75849c250aa9f2107e113a1f8c507abc5df9766d5b08dff3bc1af586e05
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

> I'd prefer to have a dedicated patch to set compress_level to the=20
> default value 0, as a proper bug fix as the first patch of the series.
>
> As you mentioned in the cover-letter, this is in fact fixing a bug in=20
> the old behavior (mismatched algo and level).
>
> So it's definitely worth a dedicated fix, so that we can backport the=20
> fix without pulling in the full series for older kernels.

Ok so, after thinking about it more and bouncing ideas around (with Zygo
too) I realized one thing, that while it *is* technically a bug, I don't
think it's a bug worth backporting.

My reasoning is simply that there is no use-case where the current
"buggy" behaviour would be damaging, as the levels get clamped to the
supported range anyway, while arguably there are (albeit very rare and
probably not very smart in the first place) use-cases where fixing it
could be somewhat (limitedly) damaging.

More importantly IMO, doing this would allow us to explicitly explain
the currently undocumented behaviour in the btrfs-property(8) manpage as
"just so you know, for kernel versions < 7.x cross-algo level leakage
from -o compress was happening".



As for how to handle it after having support for levels in the XATTR,
option 2, aka leaking the compress level only if the algo matches, would
be the best imo:

Example use-case:

- /fs has various types of files, from media to git repos, that would
  benefit from the normal compress mount option;
- /fs also has big virtual machine disks, that have very compressible
  parts but also very uncompressible parts;

using only `mount -o compress=3Dzstd:7 /fs` may mark the vm disks with
NOCOMPRESS as soon as an incompressible extent gets found, but setting
btrfs.compression=3Dzstd won't, as it will try to compress every extent
anyway[1].
This way if the user intends to change the compress level for the whole
fs, they can just change the mount option, knowing that the new level
will apply to the (new) vm extents too, like it will for all other files.

In this example "btrfs.compression=3Dzstd" and "btrfs.compression=3Dzstd:0"
would behave the same, which means the file's extent will get compressed
with zstd:7, but when the user remounts with e.g. zstd:15, they will use
this new level (only for the extents written from that point afterwards,
of course).

(I'm ignoring the case where the user wants to change the algorithm and
let the vms inherit it, as for this specific use-case that would likely
require a whole new feature/property to say "try to compress anyway but
not as much as compress-force" and probably most people use zstd anyway
nowadays).



After coming to this conclusion, I'm personally pretty satisfied with
this solution, while I wasn't as much with the other ones.

Thanks again.

Best,
koraynilay

[1]: https://github.com/kdave/btrfs-progs/pull/1152/commits/7ae9e2aa7a35af5=
e7b656424957a558a9d0dd676

--d75849c250aa9f2107e113a1f8c507abc5df9766d5b08dff3bc1af586e05
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCanqPJgAKCRDmj22qf5IG
XGAGAQDK9MALMsFMCaeWGG+tGAh7eRCVK+46JTKYnM5cW5/b1wEAmkVj9jyvzPke
c+g+nrU0PvTmQg9H16CdkWK/ItNWaAU=
=RKCc
-----END PGP SIGNATURE-----

--d75849c250aa9f2107e113a1f8c507abc5df9766d5b08dff3bc1af586e05--
