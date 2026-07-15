Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52B44302E6;
	Wed, 15 Jul 2026 09:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784107900; cv=none; b=nhJSMD4UGDghtDLIeoPhWn/uyQnB/E3R+myceZo+oQlzX0KRKcZlsucAoxdjoUMVM6hqgJVDVJujwlfXGwYsc3dXr8ktjurUlRERXT2p1Trwin5xE8ZwpzubcCqeJuJUg5JygP6Pxzb2G95RawyR5ocuFCattlDXvTdfOGkrI3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784107900; c=relaxed/simple;
	bh=EzZOPU7BvmPLylCffOGSzepVGHhKspdMC4MoRA52GWU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hxwdd/NkpYfP4s9HR2Gxp6P4B4ayChtJr5CA/qoB6TBmQ9TzQD9K2o78WbrxYAst44XOWc0uQzl4zTN/R0U4gxM8/6Ud+hNtN011rUBF8jZNeH3V2MzG6MHeq7MLFzx+BvPcR3JJMP6ls1H6549jOHm7NaUCnMO4EH7NRv0lVko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=HmwWegdt; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="HmwWegdt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1784107888; x=1784712688; i=quwenruo.btrfs@gmx.com;
	bh=OY6sQ/uHohsimCIaqhnerV9H1iJUTIBGfbv2RN9DB+s=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=HmwWegdtAPYmWkizY3fEzSeoq1qlSdPFT5DLKpYf4BmKN7umlxJJPW83av/djURo
	 DPcDiCAgJh7o+mJEFjo8bMJgtnLwXFGksQysV0FNyDfJ91yDAl19FqtmxPDY/AqC2
	 QRWISVbyoVFif5LWzfnpZM6lnLyU7iFK3NHxesA86Wn397m+b1x0AntBVs6AbnHvA
	 vLN9J2zlhptHKK5kyJDULHLh8bQpFqQuM8K3FlKHSyiMAZDv7+uf7Iy5xaUtyY2Je
	 J/pcUWQHaZIk7cgkzm2EvL8/YGwow1OApWnHy+ZtOkyYQgSa+PBWxZAQTY5jJdRJw
	 u7s8n3q33y6ma3rPVw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MpUUm-1xOnc41GEW-00mYmL; Wed, 15
 Jul 2026 11:31:28 +0200
Message-ID: <f02329c8-6e59-404f-944b-9c029ae61258@gmx.com>
Date: Wed, 15 Jul 2026 19:01:23 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: lzo: reject inline extents without compressed
 data
To: David Lee <david.lee@trailofbits.com>, Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.com>,
 Dominik 'Disconnect3d' Czarnota <dominik.czarnota@trailofbits.com>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260715090516.512417-1-david.lee@trailofbits.com>
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
In-Reply-To: <20260715090516.512417-1-david.lee@trailofbits.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:QTiQK+SBdD37L3AHewEpdErJjP5rb7gS6Jb/B5FqRLxUhadanGE
 THJIkJ3FZKcvlch7Hi0fxOOJzgtY2yRolSvgzmXvNeJ1G/Mf9M2gT6wDcACSu/pO/N3P0J4
 JHq6KK0K4agLf6/oirsBEH14aO/+QvLMLvo2LASvgxAbiTKxC/lf0kOT8Z5emLWhDvXV5Bx
 zTpBwRwSPLGrzhlBlsbCA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:fIMbbl/cSDo=;Gv/xdcTer6qs1QjO69YWZjIPyA7
 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
 WfeKvivvCc5r7ynQsx2mn

The new subject line is a little confusing.

The patch is not just rejecting empty payload, but also cases where=20
there is not even enough space for needed headers.

Something like "reject invalid sized inline extents" would be better.

=E5=9C=A8 2026/7/15 18:35, David Lee =E5=86=99=E9=81=93:
> inline Btrfs LZO payload shorter than two LZO headers.

This is not even a sentence, sorry I didn't point this out in the=20
initial patch.

> Fix the validation or lifetime rule

So what the "lifetime rule" is?

> at the vulnerable boundary so malformed
> or racing input cannot reach the faulting path.

The same for "racing input". I see no racing behavior.

Malformed on-disk data is self-explaining, but "racing input" is not.

>=20
> A four-byte extent produced the following KASAN report on Linux 7.2-rc2:
>=20
>    BUG: KASAN: slab-out-of-bounds in lzo_decompress+0x57d/0x700
>    Read of size 4 at addr ffff888006f2e644 by task btrfs_lzo_inlin/77
>=20
>    Call Trace:
>     <TASK>
>     dump_stack_lvl+0x5b/0x70
>     print_report+0xd1/0x610
>     ? _raw_spin_lock_irqsave+0x78/0xc0

Please remove unrelated stacks which start with a question mark.

I have removed the remaining ones as an example.
>     kasan_report+0xe0/0x110
>     __asan_report_load_n_noabort+0x13/0x20
>     lzo_decompress+0x57d/0x700
>     btrfs_decompress+0x140/0x1c0
>     uncompress_inline+0x147/0x1b0
>     btrfs_get_extent+0xb23/0x10a0
>     btrfs_do_readpage.constprop.0+0x538/0x1ac0
>     btrfs_readahead+0x32f/0x5f0
>     read_pages+0x16f/0x850
>     page_cache_ra_unbounded+0x296/0x490
>     do_page_cache_ra+0xd9/0x130
>     page_cache_sync_ra+0x3ee/0x6f0
>     filemap_get_pages+0x306/0x15c0
>     filemap_read+0x329/0xd00
>     btrfs_file_read_iter+0x1f8/0x2b0
>     vfs_read+0x4ef/0x720
>     ksys_read+0xf8/0x1d0
>     __x64_sys_read+0x71/0xb0
>     x64_sys_call+0x1ab0/0x1b70
>     do_syscall_64+0x61/0x470
>     entry_SYSCALL_64_after_hwframe+0x4b/0x53
>     </TASK>
>=20

A very short explanation would help, something like:

   An inlined lzo compressed extent should have one lzo header (4 bytes),
   followed by one segment header (4 bytes) then payload.
   For the 4 bytes sized inline extent, there is no space for the segment
   header.

   Without proper validation, reading the segment header will be out the
   inlined extent.

Feel free to use LLM to fix whatever grammar errors in the above example.

> Link: https://lore.kernel.org/all/20260714071054.1715464-1-david.lee@tra=
ilofbits.com/

We do not use Link: just to point back to an older version.

We use it for the original bug report (not the patch).

> Fixes: a6fa6fae40ec ("btrfs: Add lzo compression support")
> Assisted-by: Codex:gpt-5.5
> Signed-off-by: David Lee <david.lee@trailofbits.com>
> ---
> Changes in v2:
> - Reject an eight-byte extent containing headers but no compressed data.
> - Rebase onto btrfs for-next and update the invalid-header diagnostic.
> - Include the complete KASAN call trace.
>=20
> Trail of Bits has a reproducer for this bug demonstrating Kernel Panic w=
hich can be shared further if needed.
>=20
>   fs/btrfs/lzo.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
> index 1531adb117d1..2f0996692da0 100644
> --- a/fs/btrfs/lzo.c
> +++ b/fs/btrfs/lzo.c
> @@ -552,9 +552,10 @@ int lzo_decompress(struct list_head *ws, const u8 *=
data_in,
>   	size_t max_segment_len =3D workspace_buf_length(fs_info);
>   	int ret;
>  =20
> -	if (unlikely(srclen < LZO_LEN || srclen > max_segment_len + LZO_LEN * =
2)) {
> +	if (unlikely(srclen <=3D LZO_LEN * 2 ||
> +		     srclen > max_segment_len + LZO_LEN * 2)) {
>   		btrfs_err(fs_info, "invalid lzo header length, has %zu expect (%u, %=
zu)",
> -			  srclen, LZO_LEN, max_segment_len + LZO_LEN * 2);
> +			  srclen, LZO_LEN * 2, max_segment_len + LZO_LEN * 2);
>   		return -EUCLEAN;
>   	}
>  =20
>=20

