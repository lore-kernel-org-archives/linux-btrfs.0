Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E37A3126A0
	for <linux-btrfs@vger.kernel.org>; Sat,  1 Aug 2026 01:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785546826; cv=none; b=WVXBQ9eKj9alIvdj56nQ6JIE/TtANiDjAAPJ6Rr3Y14vfaLEfDepf2oPZO9jz2r3k5cble4AT1U30BYEIbjStlxPVu3aTWOLx5BmdKr0hJcexH4B+fFcktTu9JOjFnUigbXsPuMyWEAtWRDyhJhZEuiaz5QJ4U35zAxRiql9nnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785546826; c=relaxed/simple;
	bh=eYszNDE/D9kJNHJgU60rv4ttlNSFE8SdA8knXjw9xX4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cekshs5oB8dRP/vaSZJ370exdPfis01RGT/xEqvEoGqbEmdJPhp+g4kWZC846MSeMrh8XZvrLFV++sUfMLx+owVAndUzQcBwulLcZU5YBg1vbbJhMvI7cwwDuXmoAJ8E6HaZfON74Zb5afQp84rQ0zluE/EM0qSROBE5Mlp4XZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=hTDurNvP; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="hTDurNvP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1785546816; x=1786151616; i=quwenruo.btrfs@gmx.com;
	bh=mtaJ3GuWcu6TQBen5pwJyzIk5UHCrSpZLeogGWQoo/g=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=hTDurNvPu3QvACGa+BHoR10FTzMIgexbPK2/BPUXiCmmEL2Th6bcDNWhMVDqM0mi
	 oCd97c4BMsF7fCSdoJoTkacA0MKNj8PP9HNehW76zqLzJoZYx0vgIT3tfv3h0An0S
	 9U96BmYWBV1ADbkba9uYdrlucrn/EnXwwpAaN0TeCVErSwQGw2h4NY+jWjjp6vELC
	 BNWD7WbUeIOf2sa8SD8VwPgGNJX6YZxsl2/T8D35RpqofJ3jqM9EdzxhHD4EFZJiq
	 HiQnHx+3VSXSmhNNgPUMtkWLChKCC4inbSj5fBqQnyTJgGVv6p6//Xs+VxAeGpY8W
	 s0TVEgz7RLxyrOKd7Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N2V0B-1wvqgS0qTP-011Cey; Sat, 01
 Aug 2026 03:13:35 +0200
Message-ID: <bdab57d2-e7cd-418f-91f4-b54121fcf5c7@gmx.com>
Date: Sat, 1 Aug 2026 10:43:30 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] fs: btrfs: fix zstd decompression of compressed inline
 extents
To: Cole Munz <Munzzyy1@proton.me>, kabel@kernel.org, trini@konsulko.com
Cc: sjg@chromium.org, u-boot@lists.denx.de, linux-btrfs@vger.kernel.org
References: <9acf406b5e73fa83001e1951e883143e2afb8b2d.1785528314.git.Munzzyy1@proton.me>
 <f6ac2bbdb9b559041cb0c82efccf89ea7262cb43.1785545440.git.Munzzyy1@proton.me>
Content-Language: en-US
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Autocrypt: addr=quwenruo.btrfs@gmx.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1YAUJEP5a
 sQAKCRDCPZHzoSX+qF+mB/9gXu9C3BV0omDZBDWevJHxpWpOwQ8DxZEbk9b9LcrQlWdhFhyn
 xi+l5lRziV9ZGyYXp7N35a9t7GQJndMCFUWYoEa+1NCuxDs6bslfrCaGEGG/+wd6oIPb85xo
 naxnQ+SQtYLUFbU77WkUPaaIU8hH2BAfn9ZSDX9lIxheQE8ZYGGmo4wYpnN7/hSXALD7+oun
 tZljjGNT1o+/B8WVZtw/YZuCuHgZeaFdhcV2jsz7+iGb+LsqzHuznrXqbyUQgQT9kn8ZYFNW
 7tf+LNxXuwedzRag4fxtR+5GVvJ41Oh/eygp8VqiMAtnFYaSlb9sjia1Mh+m+OBFeuXjgGlG
 VvQFzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYCGwwWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCZxF1gQUJEP5a0gAK
 CRDCPZHzoSX+qHGpB/kB8A7M7KGL5qzat+jBRoLwB0Y3Zax0QWuANVdZM3eJDlKJKJ4HKzjo
 B2Pcn4JXL2apSan2uJftaMbNQbwotvabLXkE7cPpnppnBq7iovmBw++/d8zQjLQLWInQ5kNq
 Vmi36kmq8o5c0f97QVjMryHlmSlEZ2Wwc1kURAe4lsRG2dNeAd4CAqmTw0cMIrR6R/Dpt3ma
 +8oGXJOmwWuDFKNV4G2XLKcghqrtcRf2zAGNogg3KulCykHHripG3kPKsb7fYVcSQtlt5R6v
 HZStaZBzw4PcDiaAF3pPDBd+0fIKS6BlpeNRSFG94RYrt84Qw77JWDOAZsyNfEIEE0J6LSR/
In-Reply-To: <f6ac2bbdb9b559041cb0c82efccf89ea7262cb43.1785545440.git.Munzzyy1@proton.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Zr4a8f7PGUyNbNQO4KiRPM1nptNCKYUgunP6z/r/RyPJOziNoL1
 sON3fD014jJDlYMURacO76B5mQGwmxlWjrmYLWAw0avwxiZw4AcaoSun3tUpQbkPK06Pb4A
 8WqnjBmd/j4MhV5JHM+fcbka0EXoH0iO/ZFMRKE/LG7hLgis0miGFKvrq1m5CRLtfLBlfcd
 1Zv0F+gNc+BRj2OJ5l4tw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:mUi9cAmUJIw=;gN3ndnY6gWPBrfv+CjMUPz+rTlK
 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
 dD75Xpw==



=E5=9C=A8 2026/8/1 10:25, Cole Munz =E5=86=99=E9=81=93:
> The kernel compresses an inline extent as a whole block:
> run_delalloc_inline() calls btrfs_compress_bio(inode, 0, blocksize, ...)=
,
> so the data is zero-filled past EOF and the resulting zstd frame declare=
s
> a content size of one block. The extent item records the unaligned file
> size though - __cow_file_range_inline() passes i_size down to
> insert_inline_extent(), which stores it as ram_bytes.
>=20
> btrfs_read_extent_inline() sizes its decompression buffer from ram_bytes=
,
> so for a 1900-byte file the destination is 1900 bytes while the frame
> decodes to 4096. Since commit 918adf8e0733 ("btrfs: Use U-Boot API for
> decompression") btrfs decompresses through the common U-Boot helper,
> which uses the one-shot zstd_decompress_dctx(). That API requires the
> destination to cover the whole frame and fails with dstSize_tooSmall,
> error 70, otherwise. The streaming ZSTD_decompressStream() path it
> replaced stopped once the output buffer was full, so it never hit this.
>=20
> The kernel side does not notice because fs/btrfs/zstd.c streams into its
> own buffer and copies out at most destlen.
>=20
> Allocate a full block for the decompression buffer and copy only
> ram_bytes back to the caller. An inline extent never spans more than one
> block, which bounds the allocation.
>=20
> This shows up on RK3399 and ODROID-N2 as "zstd_decompress: failed to
> decompress: 70" (armbian/build#9651, #10208), where it breaks fdt apply
> on zstd-compressed overlays. Images built with mkfs.btrfs --rootdir
> --compress zstd do not reproduce it, since btrfs-progs writes a frame
> whose content size already equals ram_bytes. Only files written at
> runtime through the kernel trip it.
>=20
> Fixes: 918adf8e0733 ("btrfs: Use U-Boot API for decompression")
> Signed-off-by: Cole Munz <Munzzyy1@proton.me>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Now the fix looks much simpler.

Thanks,
Qu

> ---
> v2:
>   - Move the fix into btrfs_read_extent_inline() and size the decompress=
ion
>     buffer to a full block, as Qu suggested. decompress_zstd() is left a=
lone.
>   - Rewrite the commit message. The failing case is compressed inline
>     extents, not sector-padded regular extents: Qu pointed out that
>     ram_bytes is always block aligned for regular extents.
>   - Drop the zstd_find_frame_compressed_size() input trimming from v1. T=
he
>     inline item length is already exact, so it was doing nothing.
>=20
> v1: https://lore.kernel.org/u-boot/9acf406b5e73fa83001e1951e883143e2afb8=
b2d.1785528314.git.Munzzyy1@proton.me/
>=20
>   fs/btrfs/inode.c | 15 +++++++++++++--
>   1 file changed, 13 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 3998ffc2c819..53f1059e1ef8 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -362,9 +362,11 @@ int btrfs_read_extent_inline(struct btrfs_path *pat=
h,
>   			     struct btrfs_file_extent_item *fi, char *dest)
>   {
>   	struct extent_buffer *leaf =3D path->nodes[0];
> +	struct btrfs_fs_info *fs_info =3D leaf->fs_info;
>   	int slot =3D path->slots[0];
>   	char *cbuf =3D NULL;
>   	char *dbuf =3D NULL;
> +	u32 dbuf_size;
>   	u32 csize;
>   	u32 dsize;
>   	int ret;
> @@ -380,8 +382,17 @@ int btrfs_read_extent_inline(struct btrfs_path *pat=
h,
>  =20
>   	/* Compressed extent, prepare the compressed and data buffer */
>   	dsize =3D btrfs_file_extent_ram_bytes(leaf, fi);
> +	/*
> +	 * The kernel compresses an inline extent as a whole block, zero-filli=
ng
> +	 * the tail past EOF, so the stream can decompress to more than
> +	 * ram_bytes.  zstd's one-shot API rejects a destination that cannot
> +	 * hold the entire frame, so give the decompressor a full block and co=
py
> +	 * only ram_bytes back out.  An inline extent never spans more than on=
e
> +	 * block, which bounds the allocation.
> +	 */
> +	dbuf_size =3D max_t(u32, dsize, fs_info->sectorsize);
>   	cbuf =3D malloc(csize);
> -	dbuf =3D malloc(dsize);
> +	dbuf =3D malloc(dbuf_size);
>   	if (!cbuf || !dbuf) {
>   		ret =3D -ENOMEM;
>   		goto out;
> @@ -389,7 +400,7 @@ int btrfs_read_extent_inline(struct btrfs_path *path=
,
>   	read_extent_buffer(leaf, cbuf, btrfs_file_extent_inline_start(fi),
>   			   csize);
>   	ret =3D btrfs_decompress(btrfs_file_extent_compression(leaf, fi),
> -			       cbuf, csize, dbuf, dsize);
> +			       cbuf, csize, dbuf, dbuf_size);
>   	if (ret < 0) {
>   		ret =3D -EIO;
>   		goto out;

