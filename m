Received: from mail-24418.protonmail.ch (mail-24418.protonmail.ch [109.224.244.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698F4314B8C
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 22:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785536782; cv=none; b=mIMmUJsj/ZpoJt3ZCIO2JcWsz1omRAAOmr6w2rr4v5hohsj3aKV9mswbSqtDPc8QOcrLwnlMPqRqmUH8OdoLRKZsE44hAWgWkMSBltPiVlvh2GmhqY7k0rH4UT63KnbkbDa7rbQ4Mc6lCVa1XohSbtH11yrAEjcZVs3QS+GIyiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785536782; c=relaxed/simple;
	bh=zAZD6nKl29kIR6bROoj6yW6POPonZT0qrD7SmUwYif8=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sfnTOclpC0OURM8D3N/uWcHCGJ73MQB0kNky6JxbcTt/dkzCjxTUlig7L+1RNWvIu+fTsMcQVYNkRDKzGtmsTaKQuC3JgARHrzApeH56auzkEhC2+RgSlTcbaxn0PZuNsncMjuI8M8sFVTGuTFGZ15Y0UIN5vwcUBg+qvve1RQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=dYO2bMwg; arc=none smtp.client-ip=109.224.244.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="dYO2bMwg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1785536774; x=1785795974;
	bh=eq+db2Zwmc4KnZuPcPVApX+FMCVlDyt8KVTso/aPnk0=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=dYO2bMwgjmtNHsEnSFMJK6a1BTFSgh5dQA2ndjjhv/gMh71piUMNpYXBMSykto/oA
	 E0dGOXiOq6hPxEWomCD6xVwQjr+JOaXfBkMkuIdivkbNFM3VyMDuCHzFAq2PPAuOyP
	 BtdiIh3vIuhzHjVJuX7GVsiFCCqEMmDEN/X6yYkT/bG2Q6ZjjGXUK0sgSAT0pgoMfz
	 jdD1cGgjLXB9L8basjGbhQ4hvu53nSpm1i3vJ6DRsXUw/ZmCQQRbTupU7i7/DSrgn+
	 yp+HuQqDJ7x42Mldc+NA+ez/Qylw+q2wNxRxxuNKcot2DXEgpyEMx1j3kJhjNoBPaV
	 5Ey1YskBfJNbw==
Date: Fri, 31 Jul 2026 22:26:11 +0000
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
From: Cole Munz <Munzzyy1@proton.me>
Cc: =?utf-8?Q?Marek_Beh=C3=BAn?= <kabel@kernel.org>, Tom Rini <trini@konsulko.com>, Simon Glass <sjg@chromium.org>, u-boot@lists.denx.de, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fs: btrfs: fix zstd decompression of sector-padded extents
Message-ID: <-pmHXWS0jQjmnEICAo6l7i5Q5tFivBJ1Mm162qdIm_69a1gcfU0tBo4C-bfELAT1lCrGHRKlYr3_EcKwLFRX18SHErryHV_TCdz93esbQ30=@proton.me>
In-Reply-To: <3659c07e-7f73-460c-8391-e2b8508e2bd4@gmx.com>
References: <9acf406b5e73fa83001e1951e883143e2afb8b2d.1785528314.git.Munzzyy1@proton.me> <3659c07e-7f73-460c-8391-e2b8508e2bd4@gmx.com>
Feedback-ID: 209578162:user:proton
X-Pm-Message-ID: 89e3bc73d3d641e170826cb58333f5d3a006a382
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Qu,

> The ram_bytes described the decompressed size of a compressed extent,
> except inlined extents, the ram_bytes should always be fs block aligned.
>
> I didn't see how things can go "larger than the extent's ram_bytes".

You're right, and the commit message overstates it. For regular extents
ram_bytes is block aligned and matches the frame's content size, exactly as
you describe. The case that actually fails is the one you carved out:
compressed inline extents.

For the inline path, current mainline compresses the whole first block:

  run_delalloc_inline():
    cb =3D btrfs_compress_bio(inode, 0, blocksize, compress_type, ...);

so the page is zero-padded past EOF and the resulting zstd frame declares
frameContentSize =3D blocksize. But the extent item gets the unaligned size=
:

  __cow_file_range_inline(inode, i_size, compressed_size, ...) ->
    insert_inline_extent() -> btrfs_set_file_extent_ram_bytes(leaf, ei, siz=
e);

So a 1900-byte file stored as a compressed inline extent has ram_bytes 1900
while the frame decodes to 4096. The kernel side never notices because
fs/btrfs/zstd.c zstd_decompress() streams into out_buf and copies out at mo=
st
destlen. U-Boot's decompress_zstd() is the one-shot zstd_decompress_dctx(),
and btrfs_read_extent_inline() sizes the destination with
dsize =3D btrfs_file_extent_ram_bytes(), so the frame fails the whole-frame
capacity check with dstSize_tooSmall - error code 70, which matches the
"failed to decompress: 70" in the Armbian reports.

One data point from testing while chasing this: an image built with
mkfs.btrfs --rootdir --compress zstd (btrfs-progs 7.1) does NOT reproduce.
For a 1900-byte file, progs writes an inline extent with ram_bytes 1900 who=
se
frame also decodes to exactly 1900:

  item 8 key (257 EXTENT_DATA 0) itemoff 15316 itemsize 423
      generation 6 type 0 (inline)
      inline extent data size 402 ram_bytes 1900 compression 3 (zstd)

so mkfs-built images boot fine, and the failure only shows up on files
(re)written at runtime through the kernel - which fits the Armbian pattern =
of
/boot scripts and overlays breaking after a package update touched them.

I'll send a v2 with the commit message rewritten to name compressed inline
extents as the failing case instead of the hand-wave about sector padding. =
If
you'd like the on-disk evidence too, I can loop-mount a scratch fs with
compress=3Dzstd, write an unaligned file, and include the dump-tree output =
plus
the frame header read from the leaf in the v2 cover.

The fix itself stays in btrfs's decompress_zstd() rather than lib/zstd
because for FIT/ximg/ubifs an undersized destination really does mean corru=
pt
input; only btrfs hands the decompressor a destination smaller than the fra=
me
on purpose. If you'd rather see it shaped differently - say, only engaging
the bounce path for inline extents - happy to do that in v2 as well.

Thanks,
Cole

