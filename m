Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.161.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621885;
	b=jTaexrbdCgGlinqPfwc8KNNas0pEMvOHpf2OKqZYBaoiWiEFT6Y4W8aeQOLI+IelIps6
	 03a/jgUcD2o1G7w+Nj5BL61kYMM1tfh2InNI4rInflQaOMGUKbQawI6suJw7iLJQsefFa
	 2qXd3IC1eEzGeMhWvEJFvM1yVEIN1JB/v0lLTU/dVP2H2kBS3yoKvaRkimbIkfVCU3f5F
	 xP4Tss5EbJY1/QhhHann/TRIPxUxC06sjNDnOATYdh4C63Uxad6M1Hr8izCMjw3jTpU6B
	 C/DDCQJvmG4ACkdVWB9eqzGSrAQwMzjIxYd0EcDY1hW3kVEYALx9twOqEvEDmt7EKWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621885;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To:X-Clacks-Overhead;
	bh=zt6XfyO9ZBxEJkNd0cOYo5OsTXwhDkzYh9+XuI5lifM=;
	b=TIKLjPgbhndAn5xmri2ZG0ut4i6DsTs/AmJwPsFGZad8l/nNk102tFFhVvQ5vH627J46
	 iF4PXJVaXgXuBj7mZEOFqvcigF51t99e4EluBK36xGkSBTw1iFw1hNoTu4b+XYi913Pcq
	 tq+9FvVhzPZR+NMdJhituVBYHJ1Hp9EC3Kluv3r6xoqaGsaB8SXsn844e3R7FEQzD+cgm
	 E87rC9wCWf0xu504KFaR9P/8ETDZJuD4BZ/GTP1tBW37HfDfunxVYJHkzgcn9EYa1MWYm
	 WOZ2gfcMpQUvBslN78q7J3SWEW5JaMiyfdxSlOsEJof57O61zySGJDOMzrFQOtexhRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=konsulko.com;
	spf=pass smtp.mailfrom=konsulko.com;
	dkim=pass header.d=konsulko.com header.i=@konsulko.com header.a=rsa-sha256 header.s=google header.b=mr8xh0NW;
	arc=none smtp.remote-ip=209.85.161.46
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D701606A332
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 15:51:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D701606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=konsulko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=konsulko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=konsulko.com header.i=@konsulko.com header.a=rsa-sha256 header.s=google header.b=mr8xh0NW
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-71aed54d4c5so3471360eaf.0
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 07:51:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google; t=1795621884; x=1796226684; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zt6XfyO9ZBxEJkNd0cOYo5OsTXwhDkzYh9+XuI5lifM=;
        b=mr8xh0NWzcq8dGF7EXug6tlW5KMDS4s8ZCgH4mVvMEAxGFE0592SfOpD75lZQRRc+q
         fk61XcAnASHZix8TvUBoMWy8Lxfik1eW/R07JvTP8ppuVI5+xm8IoamS8I/hIzVuRIy8
         pNgvZjO5B06yUH0yXnl5vIHuibWuO6/hxJ4X4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795621884; x=1796226684;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zt6XfyO9ZBxEJkNd0cOYo5OsTXwhDkzYh9+XuI5lifM=;
        b=2HuzXtTaNl27AajG6LzkQGWAkv+9joWtJJOns1Wx2qpmp1bS9uZByOlDsE3wh8clVu
         UwCf1gi83pOEIqkbkB6QUS3zPB3xTijwb5ud11kmH0WADy8/XOo2eoqv7gmAHF7oM0g4
         G6428934t6+LqKUpuFb9k56UPv5QMUtx87TBtKd2HfL7ZZ7qny/vUZj9WDcsU0wxi07F
         CXFDhd0cEYGHILAskKAT1L5gbbJ3rfYmyKktcJLT/Lc45q4oEJTFP8YWWFglukGsViGH
         JqKg5mxLJA93UcwVnOeZMGq38kx3+zSJk+P1/ODJ3IxR4SDlHXB3B+N5BKDwpyXF8IBa
         oTAg==
X-Forwarded-Encrypted: i=1; AL+hErHDMnoF3Zf8eKgyF4aRvb8bBENnKWPGrGvhKkaQOKNPR9EnvXh3bs1kfButtKHFCADJQmrs8HR9XqQG7w==@vger.kernel.org
X-Gm-Message-State: APuU4Z/ee8X2Ih6+hsscn811nbr6dh7aboqX1FEL0pVA+EWsitNx/SOA
	HQmP43J55fzUp9HBPFWvNSlbZZheV+moXwd2Y6G8qiyuktvOOQ0aJlHm4Dgk0d4WmgY=
X-Gm-Gg: AZFdTZdEMQ5CAvngjExUAsGlprEwj2Lr1c91NoD2hbZ+efSYXVDZyfiwlSpNiBxHVVS
	u/hCqL4ppVz4Phj6/39nB1OjQ1tXjXqOVjuSqSlGQ5E2jX+x4v78tw/SNPfeepJyGF0i1aJvBiT
	UaR9J757fXubOXW7RWy2nhIwdrTb65m7LpJcIFYC5x5jm7NTE7mOVOugpqRq3HTrjT3BRRtHIIQ
	+iO599lgzqQsAbh2gfzoZs/JuhBAEr8oXmDfvrtnPoIvvp8jYUhTF9JxDZzhmqdpZIFZp1D8gep
	CNZnO4u0bS2L1MQ/Be36PBU0osatHLalw5RGsBlX0QnhaBuzvKAWqo2FHLtCMjrFfOREjvUeHQ1
	ravovuTTTKIijP3kz5C+BY2+srDqeck7V4LOLSeUdzwhYE6TThktuobvvfmrF+OGd1isV9QvH+p
	mC0oPZL9rEUwYDSuoHKJeXQ5s0q/0xIv55Cg+SUwXDV7O8BWfHLpkUEIlDvsFEJ1IzDZfyC6WnS
	sGIAISDa2Yc3cEWZvv7V3i16BN2KJY/BrDudbXX1VCqgR8sabeB8z6K2if0n7a845kS50dZekbe
	p15xvLYjtSKCjqd+8gR+D0w5/KSSDTG087OPqpHZVYmDhuWGbvoyDs1gndhFD6FYbWYag9ECciK
	DIgKV3gzdFnR6Fu/DQMVPNDhFv9rUyuMe47XFocdJKUnznsUZ9jf5ALYZ4I+Tk0jJXxfrRRwcFc
	8gLkDO4FUZvDirfpZTGYc7dWjFOike8BYZ
X-Received: by 2002:a05:6820:612:b0:71a:eb23:a7da with SMTP id 006d021491bc7-71b39521213mr15418841eaf.31.1795621883973;
        Wed, 25 Nov 2026 07:51:23 -0800 (PST)
Received: from bill-the-cat (fixed-189-203-100-56.totalplay.net. [189.203.100.56])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4bc5ebdc0bbsm15822050fac.6.2026.11.25.07.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 07:51:23 -0800 (PST)
Date: Wed, 25 Nov 2026 09:51:20 -0600
From: Tom Rini <trini@konsulko.com>
To: Bradley Morgan <bradley.morgan@linux.dev>
Cc: Josef Schlehofer <pepe.schlehofer@gmail.com>,
	u-boot@lists.u-boot-project.org,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	Joao Marcos Costa <joaomarcos.costa@bootlin.com>,
	Richard Genoud <richard.genoud@bootlin.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Peng Fan <peng.fan@nxp.com>, Jaehoon Chung <jh80.chung@samsung.com>,
	Tanmay Kathpalia <tanmay.kathpalia@altera.com>,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/6] Avoid 64-bit divisions that need __udivdi3() or
 __umoddi3()
Message-ID: <20261125155120.GG3176972@bill-the-cat>
References: <20261125124259.95636-1-pepe.schlehofer@gmail.com>
 <5D58F095-45B7-4BA0-A25E-2D65AF893947@linux.dev>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gO3bzhjyIoDqAEfy"
Content-Disposition: inline
In-Reply-To: <5D58F095-45B7-4BA0-A25E-2D65AF893947@linux.dev>
X-Clacks-Overhead: GNU Terry Pratchett


--gO3bzhjyIoDqAEfy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 25, 2026 at 03:45:12PM +0000, Bradley Morgan wrote:
> On 25 November 2026 12:42:53 GMT, Josef Schlehofer
> <pepe.schlehofer@gmail.com> wrote:
> >U-Boot's private libgcc does not provide __udivdi3() and __umoddi3().
> >v3 of the mpc85xx LTO series links mpc85xx LTO builds with it and added
> >both routines [1]. Christophe Leroy asked why the callers do not avoid
> >'/' and '%' on 64-bit operands instead, and Tom Rini asked to update
> >the common code [2].
> >
> >Patches 1-4 avoid the divisions that make the mpc85xx LTO builds call
> >__udivdi3() or __umoddi3(), in btrfs, squashfs, mmc_berase() and
> >get_win_cnt() of the mpc8xxx PAMU code. They do not depend on each
> >other. Patch 5 removes fs/btrfs/dev.c, which nothing uses and which
> >holds another 64-bit modulo. Patch 6 converts the remaining divisions
> >in btrfs. U-Boot never runs them, but builds without LTO still link the
> >ones in the RAID5/6 code. My reply in that thread announced these
> >conversions for v4 of the LTO series. They are sent on their own
> >instead.
> >
> >Patch 2 and my big-endian fix for squashfs [3] conflict in
> >sqfs_read_nest(). I will rebase whichever of them goes in second.
> >
> >Build tested with a buildman world build on a fork's CI, and sandbox
> >test.py gives the same results as before. Run tested on qemu-ppce500
> >(btrfs) and qemu_arm (btrfs, squashfs, mmc erase), and on a Turris 1.1
> >with the mpc85xx LTO patches on top, which boots from an SD card and
> >loads files from btrfs. The PAMU change is build tested only.
> >
> >[1]
> >https://lore.kernel.org/u-boot/20261119133310.22732-5-pepe.schlehofer@gm=
ail.com/
> >[2] https://lore.kernel.org/u-boot/20261119200924.GB3176972@bill-the-cat/
> >[3]
> >https://lore.kernel.org/u-boot/20261125095537.37979-1-pepe.schlehofer@gm=
ail.com/
>=20
>=20
> Thanks,  after review, who will merge? Me? Or anyone else up to?

I'll pick up the series, once there's been enough review on it.

--=20
Tom

--gO3bzhjyIoDqAEfy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTzzqh0PWDgGS+bTHor4qD1Cr/kCgUCawcD9AAKCRAr4qD1Cr/k
Co2ZAQCrLxPCi462jYPTwB46o2Pq0j8BKCXleLBRKmGh8onO3wEA55MQfuEdgQP6
E5H9kdE1mdNH/FuB1VrU0ma3lGDRhAc=
=XI22
-----END PGP SIGNATURE-----

--gO3bzhjyIoDqAEfy--
