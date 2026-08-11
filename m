Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CD3353A86
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2026 03:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786419644; cv=none; b=SZrlFw6GvDZZScyQxVGMrAAzLRFHPORMeUkvegIgT45I0sVpZSvFr889FJooWfQdStOkiyBYCCw/UdooOOpxLMImIGLbFZmTkMrAGHcUwD714MfhLohqMtsoE/7wvoD6pf2bgycwTdUsRRC6SUDlrzlsOO4zDL7iQo6OKa0vm68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786419644; c=relaxed/simple;
	bh=MhbD+EvikewLJgLFmJ3ls8uXPibQQEO/LpfIh8SoLcU=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=GI/gQamRtgmE1RnH6d3YJdVH23qEx1XbRgkxVkpKI7lDghDntVgiRkwFY9b0DPczej4UO8XIP5L6Ufm4GJqLvhjd5QwniNvdNc+H1JxUROa0WyUFmh8ccSV4Zw35hcwSLZ/YvqFATwNDm9O0wqu9wRZiZ/gEwOchAdynLUDboHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CXZ3cDTe; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CXZ3cDTe"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4996f1ee4a4so13027485e9.2
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2026 20:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786419641; x=1787024441; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=MhbD+EvikewLJgLFmJ3ls8uXPibQQEO/LpfIh8SoLcU=;
        b=CXZ3cDTecskIGIOAxuJvUMVGU2AmU5duwQ46dzzCRgIACmQzE9l77l/JvHYU1cWSo5
         1Uv6VAvzWMLuZhHkGAMlVBWYKdSq8bgqX93iDfeiAgnYK+T/0FMsxoCYo/vbP5zVNnST
         dRnVQ6jZwq+XifDbe/qg+oa2SEpR/QYlWx5U2i3QJlDF1BNFRx6scNu6f1XKvPhDuNWQ
         NDgvOHXh7zmJ2WijOMQO+5ryZlCbGegKEHrUhyojU2CSPv2w+qC7PCzophLFt99OuvrU
         +7R6y1t5sl78V5EBOC7HF2tGI9mCtpFKdsrNQHBQgzjMxft9lWFByeBWl2jGrNtCda8a
         Yaiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786419641; x=1787024441;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=MhbD+EvikewLJgLFmJ3ls8uXPibQQEO/LpfIh8SoLcU=;
        b=r6udGhzAu1Q8c/8SRqXoIrvAbrn+AQxokXw4Fx7hV7vqYnMi4hNuMrjsrSW03BwMZH
         5vAURLET7P3gWZmic7jf6Nx4694VXxsf0YgVEnu2/IG4n0LjS1CcLVeOyW8STUCcVed3
         Vcih4xU3udbaXQ/FYCHvtF4w5NKeRzdhd7hZFHBv1xTjQfaqJysW1pAG4gB0yX5WHY47
         /4S2ni75NDXmV7Ir+RN/71haXLJA5lGVJVeIIhJhUyvIe6Cp5D6LEJBuvHZ1n469r9iS
         BdfLC/V6gVUElC+p9rZsl7cYFfW+g1bAfseyogId7eDpsCyiDNUzQsbBJsuSwvn15NUU
         CSuA==
X-Forwarded-Encrypted: i=1; AHgh+RpjE/NNIOqZq314c5e/xWiOyrz55f0JTr8mik5NhyYSbkqAZbiik+Y5m/Rs9bGgBO9bq8mMvCe387g+ow==@vger.kernel.org
X-Gm-Message-State: AOJu0YxWnuXxKCjEzUC3D017GQuidOMHY/lHxtMrHYJA6rmqNsNT4M52
	owEEq9QfR31QrfFPeIIkGO5Fj9ePwblk47OLKST5HywCIa+iLEchDMUP
X-Gm-Gg: AR+sD10wsuEjbnsF3uJZqYzcPzazZafz2CMsiP/tEDR4/fbI6p0rSeB0AW7i0q6Tv5m
	BRZV2EjtsJn6iGHdfrlWziBZl4qe9SkDzZdq93hDQMLkB8Y29BlirjM+dKP0RyMoUkrmLS7grYp
	4SNk4C+wFXuwlWwhfzt1fjfUDTSF9U4NiNQ1jZQgai9l+iZ4imt9t3ui5f2ZUpUtoYeDumeEn02
	SUAWsMJLMm4LwbYgjdrOzeA6dirAObQL4R6e/UijTpP3/oUOKa962DYL2Cg5A5khk0B4F97PuPA
	0nvdKVhTi7MlEZzrO2DA3MSRXaL9DKVJsB0CHOfo0O0Xc+c4mv5QYBg6gJxRodUsQf9XebZIQG7
	glGFxdG58S5/zsamC0RfyGOqH41xDa3BK06GtTfHnoAwWI/pwsssf0VgAuff4di/ZRf7te1bcI8
	Pa1DVsgf/C3q/5ToQqZXrp/ova+s89Y4RpRDm878bGEgydou2gqqIHxIQD
X-Received: by 2002:a05:600c:4683:b0:499:491e:4b0d with SMTP id 5b1f17b1804b1-49978467a15mr4328255e9.19.1786419640544;
        Mon, 10 Aug 2026 20:40:40 -0700 (PDT)
Received: from localhost ([151.33.67.206])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499740a6f4esm30299255e9.2.2026.08.10.20.40.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2026 20:40:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=96e8fa2a3cb277ed5ba745feb30c33c87a03cfb7220a0b54298d4213c2a7;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Tue, 11 Aug 2026 05:40:34 +0200
Message-Id: <DKLSWQOTR39Z.7K2MBJSG5Q2V@gmail.com>
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
 <DKLRY9Q5SEI3.VUDASVYPW9MY@gmail.com>
 <a27ce424-d3a4-4a8f-bddc-40757b1d40a3@suse.com>
In-Reply-To: <a27ce424-d3a4-4a8f-bddc-40757b1d40a3@suse.com>

--96e8fa2a3cb277ed5ba745feb30c33c87a03cfb7220a0b54298d4213c2a7
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Tue Aug 11, 2026 at 5:21 AM CEST, Qu Wenruo wrote:
>>=20
>> More importantly IMO, doing this would allow us to explicitly explain
>> the currently undocumented behaviour in the btrfs-property(8) manpage as
>> "just so you know, for kernel versions < 7.x cross-algo level leakage
>> from -o compress was happening".
>
> Which also applies to option 3.

Option 3 would mean the behaviour can be different depending on the
kernel < 7.X having the backported patch or not tho, so we can't say
that with 100% certainty in the manpage, but it would need to also say
"this is true only if you don't have this specific bugfix patch, if your
kernel has it, then the behaviour is this other one".

(Sorry but I'll reply to the other points tomorrow, I'm too tired to
think about more difficult sentences right now :D)

Thanks.

Best,
koraynilay

--96e8fa2a3cb277ed5ba745feb30c33c87a03cfb7220a0b54298d4213c2a7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRJ2XvJtXGwULYEerQ0bnTtJTDoOAUCanqZswAKCRA0bnTtJTDo
OKvNAP0fw+rPl9+yqo7AenWOhxnz4z1hqjOnrbTo+ih0amrsoQEA18rrRz0eh2uD
JnkKkYQtFaBlYLj5atJxKb5ocOgYGwQ=
=BBmu
-----END PGP SIGNATURE-----

--96e8fa2a3cb277ed5ba745feb30c33c87a03cfb7220a0b54298d4213c2a7--
