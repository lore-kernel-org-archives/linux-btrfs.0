Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.26
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051377;
	b=fMwVc6lm5TWpVHaxOqKmvCFKbf/Vce0Riq6tNLHJawyvI0tFJ+7ODquYzr0E+h/+3l7D
	 zd+73IMqZmylVwJVc9XZfDfoOgIOAyIXjQrqCWjfbSjuKXdaf9JNh7VyW9t6t4wjujTpf
	 3aLQtZFOjVQqkeZuhKF+BDgFxFD3PChSScxdsd3DX3rqgEnLab/bhGS29KhHg8EpDrC4B
	 u51dngtk2EJBr4Es4MjXar6z4ot8SkpkHdk0QF1zhct0gFmbf2XuI45UfhX7GOVmrRvM5
	 xwog8kerpApyAK36baoFFtW+HIp7hmw4EbHGet0lgE3vg2f+9rlgq8a2qJqnUv761tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051377;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=+Cq6/TZvYUJPcLv/eDsGxQlcil3uTjH+Y2oA6Zy7Fzs=;
	b=28Ay0NUtp77Uf7Uenm/X3uwnyjzg8wsgciYPI0Rex8deMI0avlP9d9DMZJRoKRY45RiX
	 Z35hS0hE0LytTcoIuOrPI/n1K1DvW8+IKB+azF/SggaQnpvP1s5Vp8H/dJ2/xDxPqq98/
	 fuF5vUG4i1rL3z/XvgjgzaBfJzLkSOwoQ5++CZga56LSNJyPBdnKjpy2KkHpSQwBsKNSl
	 SVeoXAhVKjh5Uz+zg8OJwgUifgppoz690FPTesFLEaR5cd1mefRHTiWWB1TG2YvJOon3H
	 7JACGUyhjCXiYRCloxwdTd9+j0U8ZLDVkJJjscem2MjseFqM6BWDKp7xcQDHU8CclYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=NXlXTKRo;
	arc=none smtp.remote-ip=79.135.106.26
Received: from mail-10626.protonmail.ch (mail-10626.protonmail.ch [79.135.106.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54218606A31C
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 01:22:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54218606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=NXlXTKRo
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795051374; x=1795310574;
	bh=+Cq6/TZvYUJPcLv/eDsGxQlcil3uTjH+Y2oA6Zy7Fzs=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=NXlXTKRoL+LRcCZPld70mWoxp7gZQz+uDhiEGZSzKUqmJy2op9ypt4NS+X5dqUndD
	 OlRLQVOYWa4R2XP0jX14gHy7arfzKQf7b0lpVcarGOmhGRlALdLQv+BTsCnuEiVNi2
	 s2gqhJxD3AjDZ3uxL0E7Bkuwr/oh4H2bPA8Q1Wb0i647Vt+sBPJ8cUW5Sxj+axz6Ia
	 9HEtMsl5IxFoy2uxGg981FQRkRc6uCeac9t6BalwyU935RrAtqLUf7XSYfnz8mHgRb
	 2UDHhOgRgyNaPDOy6p7mb8Az9wyzuMk94+v3h9iYfx+Wlf7Qe0CYWw3bpDpPAB2W+m
	 tbYXlkwbaBX5w==
Date: Thu, 19 Nov 2026 01:22:50 +0000
To: Qu Wenruo <wqu@suse.com>
From: Miroslav Cimerman <mc@raidlab.org>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <johannes.thumshirn@wdc.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: scrub: don't count zoned repairs as corrected on a degraded mount
Message-ID: <HLy1GbxoNDmZhdhuxdyatdLIiWG6jabGJiSOxke3u7mRd-njBgBiRytg1IKO1S2E6xNXQw75eH4SPWLLXC6TC0BNXXcz0SV3FsdSOQUQLdg=@raidlab.org>
In-Reply-To: <ee3cc2d0-6991-4d7a-bbd6-a84972d44b37@suse.com>
References: <20261118175637.60283-1-mc@raidlab.org> <ee3cc2d0-6991-4d7a-bbd6-a84972d44b37@suse.com>
Feedback-ID: 232820807:user:proton
X-Pm-Message-ID: 5fd6b1a495de21bb2e3cae2cab561fd6ea712cea
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Qu Wenruo <wqu@suse.com> wrote:

> =E5=9C=A8 2026/11/19 04:26, Miroslav Cimerman =E5=86=99=E9=81=93:

> > On a degraded mount btrfs_repair_one_zone() relocates nothing ("Do not
> > attempt to repair in degraded state"),
>=20
> I think this is a little weird, any special reason for this in the first
> place?

It was probably meant to check for a missing device (so that a mirror's
redundancy won't be downgraded by the relocation). But because it checks
with the mount flag, a -o degraded mount with no missing devices does
not get bad copies repaired by scrub.

I propose a v2 series, where 1/2 replaces the current mount flag check
with a missing devices check, and 2/2 is this patch modified to use the
same missing devices check as 1/2, so they are in sync. 2/2 is still
needed because for example RAID1C3 can have all: a good copy, bad copy,
and a missing device.

Are you okay with the proposal, Qu?

> > Fixes: 54765392a1b9 ("btrfs: scrub: introduce helper to queue a stripe =
for scrub")
>=20
> I do not think this is the correct fixes tag, that commit is just
> calling btrfs_repair_one_zone(), and btrfs is already calling that before=
.

You are right, the Fixes tag should be:

Fixes: f7ef5287a63d ("btrfs: zoned: relocate block group to repair IO failu=
re in zoned filesystems")

Thanks,
Miroslav
