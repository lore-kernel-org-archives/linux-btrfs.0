Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=80.241.56.151
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795466981;
	b=YdDmwrZH3AnBJUrEt1Ih7l7K4CAhbfmwGMYNbDaZmNcFawu1z9mjRWI8TiclBkBOnGH5
	 SvthRayeUeq5b6vJqVXOVRCep/z12xBsAA7yQtGN0SfaL4/qGGybomoYhblJ3eFcILx4j
	 tR4gt5ndK2JVVUgf4RzMSza0ptfxMwHNOZy6ChEnmqDWgsTGVjqPuUHzEHDpTJvHXW78J
	 Fxcn966DvhlKkRn6GIrwLl2rN3vHEbaGnOofK/QaTnL8x97ctWWaZhd4njNW804ISqjvv
	 SLyr5RMLWjn3cuOWrFFsoY0EgtwG/tC2O6lP++DUnKV3PtXOKzRSP4kA/K9HK9U61VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795466981;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:In-Reply-To:
	 References:User-Agent:Date:Message-ID:MIME-Version:Content-Type:
	 X-Rspamd-Queue-Id;
	bh=euUDazhT1Prsr7YemPrm1JJfEELoYWpt3Xcy4QaxNuE=;
	b=nX7yx18XjJC2ran1YJKFMNb0nms35Ofb5/ID2IvdXD/g3S6ZgUg+MK4EhH3sR64MqZSF
	 4K89iRcQiieueg6PU7Wx6C/Ou+pn3Whwxi2pcgxIMnkHiYunTuNHhBtEOuaB8WeLZo1ts
	 eYprUR5L/ZGKodQ5B2cCBXIORLfvgY2oCUYqGn2JF8xwzQswjHxHvnvg9URS0I7wrdOrk
	 nt8p6YscoVJPj0rVVAT6mfP1IM+4LU/7bWCXFdEQyxhQ/b9v85aYlTrairl2OZCViCIYd
	 HqSuIR/aoPXaaeD+h5uq3dlpmAZzNd3XqL2Zj6q4bY6kyF3PtH4Vobwm4PK+cZaYF6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mssola.com;
	spf=fail smtp.mailfrom=mssola.com;
	dkim=pass header.d=mssola.com header.i=@mssola.com header.a=rsa-sha256 header.s=MBO0001 header.b=HcxrHlTt;
	arc=none smtp.remote-ip=80.241.56.151
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48948606A31E
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 20:49:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48948606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mssola.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=mssola.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mssola.com header.i=@mssola.com header.a=rsa-sha256 header.s=MBO0001 header.b=HcxrHlTt
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4jYJ340zglz8vQC;
	Mon, 23 Nov 2026 21:49:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mssola.com; s=MBO0001;
	t=1795466976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=euUDazhT1Prsr7YemPrm1JJfEELoYWpt3Xcy4QaxNuE=;
	b=HcxrHlTtUMJnsoZvcdWhdG92EFWd9Its0HQ/AzPRTfJ1ZquhoiLB1tT1b3JvPW4VUCEnwB
	5ACx0yy7X+2csOhya1o7wqCyUmUxUSU/tJrsfg3qZ8lTdlUDFiW0ayN797sEYa9jt2t467
	b7RsZfhN2AK/Z5RI4xggmLDKHHZAPCW70gIphD0UhVC22YYwXISQYb+pGrExbrBUKXvTqA
	7BLzkeFMhoUPeLwsXSomdOjZeLTWQ+l6K3X88U21Pi78G2VrclfSlcYTX1yx4tNsD7O7yQ
	9nQGCbq5v5+KacybAGfmFbchOKRCnjB58UXgjsg+2QWqGSQTKN64j5Xb8tUXdQ==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=softfail (outgoing_mbo_mout: 2001:67c:2050:b231:465::1 is neither permitted nor denied by domain of mssola@mssola.com) smtp.mailfrom=mssola@mssola.com
From: =?utf-8?Q?Miquel_Sabat=C3=A9_Sol=C3=A0?= <mssola@mssola.com>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] btrfs: reject too high tree level during backref
 walk
In-Reply-To: <220d8ed1b3a8d502c4260d01e4ac4ece942873f4.1795466145.git.wqu@suse.com>
References: <cover.1795466145.git.wqu@suse.com>
	<220d8ed1b3a8d502c4260d01e4ac4ece942873f4.1795466145.git.wqu@suse.com>
User-Agent: mu4e 1.14.4; emacs 31.1
Date: Mon, 23 Nov 2026 21:49:32 +0100
Message-ID: <87ik1n1der.fsf@>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
X-Rspamd-Queue-Id: 4jYJ340zglz8vQC

--=-=-=
Content-Type: text/plain

Qu Wenruo @ 2026-11-24 07:07 +1030:

> In handle_indirect_tree_backref(), if we got @cur->level set to 7
> (the max level valid), @level will be 8, then later path->slots[level]
> and path->nodes[level] will all go beyond the array boundary.
>
> Fix it by rejecting such high level before calling btrfs_search_slot().
>
> Link: https://sashiko.dev/#/bug/linux-8a4f92b4-daf7-4f57-8369-8e6ef323652f
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/backref.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
> index a0fb90b7a9ed..e9434e033372 100644
> --- a/fs/btrfs/backref.c
> +++ b/fs/btrfs/backref.c
> @@ -3316,6 +3316,11 @@ static int handle_indirect_tree_backref(struct btrfs_trans_handle *trans,
>  	}
>
>  	level = cur->level + 1;
> +	if (unlikely(level >= BTRFS_MAX_LEVEL)) {
> +		btrfs_put_root(root);
> +		btrfs_err(fs_info, "invalid searcch level %d", level);

Very minor, mind the typo in "search".

> +		return -EUCLEAN;
> +	}
>
>  	/* Search the tree to find parent blocks referring to the block */
>  	path->search_commit_root = true;

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJiBAEBCgBMFiEEG6U8esk9yirP39qXlr6Mb9idZWUFAmsEptwbFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyEhxtc3NvbGFAbXNzb2xhLmNvbQAKCRCWvoxv2J1l
ZTcnD/403NTnVUy6U6ITY7rKhxP9BjK1/q5aOkVR4I86ho8IZ4btkPvM2l5iYMQq
+VmWyl5SFs9MVD1iFWjNKNljIs5OwYK/YDg0zOoR092frHf2ZiPOVOSi/IYL/G+5
kuE7b81RML9br5D+kP40UxszEbQgjwhfhJhlQHL0RAl/gERDUwB+Ew8GRdhMOc0J
cShqglnjSZC3x2sTj/I0xnsUN1unq0/+vBXoW9s0pRz9fH12+3BV96BGEgY2BPfZ
eSCFZU2na67aT6HgjJ+LvCuqumBUIGGrO7djIiOg++6K5ce+x/Kyi53mTF/VPIDB
nboa8w/AG1T2mozi37LgIiNrs6ZHpwyXUoj9QH1U9baF/8Mrg2WuDkIgKEFVWC8W
PWGGweTXnk4VAEk89sugh/HTbopWOoCUgq4darJdprxYD+yQ6D5F2MTg2tHVFTVb
IZqY7tBZjdEfZcvplhRHN+Jj9TkF6LPvvl/SlCD00+iOg7zT1JWLH6qraqync30K
NXcb0JhexavUOFdH4HmoyBYfaB+PURjpER9yxVmDzQGapN559W6cRy4K0+5tKsUs
9auskKplV93YvQ3Dhlp0Miwdj0AIVJVA7iluwb8YaqCpxuVNfjWzW0FOkopKVD68
FtxLPBpAwESrzV4Ni/p70j+GlQBrgSX8s5CsC833bCz33v+WVw==
=SWLn
-----END PGP SIGNATURE-----
--=-=-=--
