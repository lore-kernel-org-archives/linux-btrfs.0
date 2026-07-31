Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8007931E85B
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 21:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785533919; cv=none; b=Qky3H1wr7g7/i34Lgp//rpy6AhHCybaBDCRT3PIzgO7WKtDgstgXn05i9KpuYkkUIyMud4wu40ncMxq9whMT1AEVQcSAb5A71UaiK4uBMQ688gxg7iJjeDI/Zcv2zlMs5KwFagoRlxDzwMv5Xo4TmsNZ7x5ISGcZ5AFFGoMuuhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785533919; c=relaxed/simple;
	bh=e4ZlHPIhWDTfCIIS3hTcJz3kAX1mK+YWN3tJ65jJaxE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gBCU+iTH1pz1FGgmfo6ITD2/qkhC6eAKYvl+Dolpx4H3IA3oLzcOxY6/kCx768ucBO9Ku6qQjOpErhQSj5bPpig58d6gBqTR3fR540En4lOl0UNPCVvhmeYj978N8sBbLIQXrIsKClZi5MiGq02p5TtTnKq50fsI1k4efis2qEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=qSqc1ECz; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="qSqc1ECz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1785533914; x=1786138714; i=quwenruo.btrfs@gmx.com;
	bh=46Ch5DCnW+k8cFa30L/SzITzlNDG0w5eAdN3tX3sPXU=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=qSqc1ECzt1AG9H6sKUCaeQMdrkNjh6HZu07jXMT9jxCm5pyWIO8D7zygw9htttdu
	 10STf6NCsYWL4iil0yyz9X6YplguGf+QOoQCmQTt9vmZVB3FjEbWoyFq9Smao6tMw
	 pifbmMLmyJgAnPkpZHzXJDMExHAm1lRheMW0S9GV9WbHVEquAfyVEOZHGXjB5vQD/
	 AKWmPYvro9aPkqamGSGPgJsX8ii50obWFoT+cc5d8qpSqDJwon3qDQK6jTJTZwQkp
	 oZQz97Uzg36vvzThcspO/mrgcXZg5ur5n8MdIAFoKBrM4bDNoGxme7HZD/N/X5Vz2
	 Ruo4dnPcS6gVyhwaVA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N9Mtg-1x2Ed34AKK-01842X; Fri, 31
 Jul 2026 23:38:34 +0200
Message-ID: <3659c07e-7f73-460c-8391-e2b8508e2bd4@gmx.com>
Date: Sat, 1 Aug 2026 07:08:29 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs: btrfs: fix zstd decompression of sector-padded
 extents
To: Cole Munz <Munzzyy1@proton.me>, =?UTF-8?Q?Marek_Beh=C3=BAn?=
 <kabel@kernel.org>, Tom Rini <trini@konsulko.com>
Cc: Qu Wenruo <wqu@suse.com>, Simon Glass <sjg@chromium.org>,
 u-boot@lists.denx.de, linux-btrfs@vger.kernel.org
References: <9acf406b5e73fa83001e1951e883143e2afb8b2d.1785528314.git.Munzzyy1@proton.me>
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
In-Reply-To: <9acf406b5e73fa83001e1951e883143e2afb8b2d.1785528314.git.Munzzyy1@proton.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:8r7Ov7VJu7pmDKCj6NB90YqVGBKonikncpTHdvsJNh8G+jDykfZ
 WQSk9ZktfQo1MPdnYmV9DKX47bftAqHBzCt0n9nhuDnZBvN4mwNIZBEkE3T4i0zqPMcodTD
 XZDZ6OfxoYkTNXezFiGYPHRlWLTA8eZyrWgkEBJbC+HK4Ez+FgYk/aG0lNh07uct2jwmgs2
 hlR9nNEtfH47J3Jb4XZdA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:cIuFLUIVs9c=;eCXV7OYvAtvjq1hVDz8+Bl+ZtUC
 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
 PtS+2yXr1Nq4Z18myCk736wH4VKpZgFHwdR28=



=E5=9C=A8 2026/8/1 05:37, Cole Munz =E5=86=99=E9=81=93:
> Btrfs pads compressed extents up to a sector boundary, so a file whose
> size isn't sector-aligned still gets compressed as a frame whose
> declared content size is the sector-rounded length, larger than the
> extent's ram_bytes.

The padding at plain text level is completely common, since btrfs like=20
all other major fses are block device based, all IO including=20
compression is done at fs block level, so is the compressed data, which=20
still needs to be block aligned.

But your "larger than the extent's ram_bytes" is where I do not get.

The ram_bytes described the decompressed size of a compressed extent,=20
except inlined extents, the ram_bytes should always be fs block aligned.

I didn't see how things can go "larger than the extent's ram_bytes".

Can you provide more info about this, or better, provide the dump-tree=20
output for the involved files?

Thanks,
Qu

> zstd_decompress_dctx()'s one-shot API requires the
> destination buffer to cover the whole frame and fails with
> ZSTD_error_dstSize_tooSmall otherwise, even though
> btrfs_read_extent_reg() and btrfs_read_extent_inline() already
> zero-fill any short tail. The file then reads back truncated or the
> read fails outright, which is what breaks fdt apply on zstd-compressed
> overlays.
>=20
> Decompress into a bounce buffer sized to the frame when the declared
> content size exceeds ram_bytes, and copy out only what the caller
> asked for. Also trim the input with zstd_find_frame_compressed_size()
> first, since the on-disk extent may carry trailing sector padding
> after the frame.
>=20
> The fix lives here rather than in the shared lib/zstd/zstd.c wrapper
> on purpose: for FIT images, ximg and ubifs an undersized destination
> really does mean a corrupt input and should keep failing hard. Armbian
> carries the same caller-side fix for this exact failure on RK3399 and
> ODROID-N2 boards (armbian/build#9651, #10208), where it showed up as
> "zstd_decompress: failed to decompress: 70".
>=20
> Fixes: 918adf8e0733 ("btrfs: Use U-Boot API for decompression")
> Signed-off-by: Cole Munz <Munzzyy1@proton.me>
> ---
>   fs/btrfs/compression.c | 76 +++++++++++++++++++++++++++++++++++++++---
>   1 file changed, 71 insertions(+), 5 deletions(-)
>=20
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index c69524d38ecc..017e61242a68 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -6,7 +6,7 @@
>    */
>  =20
>   #include "btrfs.h"
> -#include <abuf.h>
> +#include <limits.h>
>   #include <log.h>
>   #include <malloc.h>
>   #include <linux/lzo.h>
> @@ -137,12 +137,78 @@ static u32 decompress_zlib(const u8 *_cbuf, u32 cl=
en, u8 *dbuf, u32 dlen)
>  =20
>   static u32 decompress_zstd(const u8 *cbuf, u32 clen, u8 *dbuf, u32 dle=
n)
>   {
> -	struct abuf in, out;
> +	zstd_dctx *ctx;
> +	zstd_frame_header fh;
> +	size_t wsize, len, dst_capacity =3D dlen;
> +	void *workspace;
> +	u8 *dst =3D dbuf, *bounce =3D NULL;
> +	u32 ret;
> +
> +	wsize =3D zstd_dctx_workspace_bound();
> +	workspace =3D malloc(wsize);
> +	if (!workspace)
> +		return -1;
> +
> +	ctx =3D zstd_init_dctx(workspace, wsize);
> +	if (!ctx) {
> +		ret =3D -1;
> +		goto out;
> +	}
>  =20
> -	abuf_init_set(&in, (u8 *)cbuf, clen);
> -	abuf_init_set(&out, dbuf, dlen);
> +	/*
> +	 * Compressed extents are padded up to a sector boundary, so clen may
> +	 * include trailing junk after the actual zstd frame.
> +	 */
> +	len =3D zstd_find_frame_compressed_size(cbuf, clen);
> +	if (zstd_is_error(len)) {
> +		ret =3D -1;
> +		goto out;
> +	}
>  =20
> -	return zstd_decompress(&in, &out);
> +	/*
> +	 * Btrfs compresses whole sectors, so a file whose size is not a
> +	 * multiple of the sector size still yields a frame whose content
> +	 * size is the sector-rounded length, which can be larger than dlen
> +	 * (ram_bytes from the extent item). zstd_decompress_dctx() requires
> +	 * its output buffer to cover the whole frame and would otherwise
> +	 * fail with ZSTD_error_dstSize_tooSmall, even though the extra bytes
> +	 * are just padding the caller is going to discard: both
> +	 * btrfs_read_extent_reg() and btrfs_read_extent_inline() already
> +	 * zero-fill any tail beyond what we return here. Decompress into a
> +	 * bounce buffer sized to the frame when that happens.
> +	 */
> +	if (!zstd_get_frame_header(&fh, cbuf, len) &&
> +	    fh.frameContentSize !=3D ZSTD_CONTENTSIZE_UNKNOWN &&
> +	    fh.frameContentSize > dlen) {
> +		if (fh.frameContentSize > SIZE_MAX) {
> +			ret =3D -1;
> +			goto out;
> +		}
> +		bounce =3D malloc(fh.frameContentSize);
> +		if (!bounce) {
> +			ret =3D -1;
> +			goto out;
> +		}
> +		dst =3D bounce;
> +		dst_capacity =3D fh.frameContentSize;
> +	}
> +
> +	len =3D zstd_decompress_dctx(ctx, dst, dst_capacity, cbuf, len);
> +	if (zstd_is_error(len)) {
> +		ret =3D -1;
> +		goto out;
> +	}
> +
> +	if (bounce) {
> +		memcpy(dbuf, bounce, dlen);
> +		ret =3D dlen;
> +	} else {
> +		ret =3D len;
> +	}
> +out:
> +	free(bounce);
> +	free(workspace);
> +	return ret;
>   }
>  =20
>   u32 btrfs_decompress(u8 type, const char *c, u32 clen, char *d, u32 dl=
en)

