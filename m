Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386B3337B81
	for <linux-btrfs@vger.kernel.org>; Sat, 11 Jul 2026 06:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783750810; cv=none; b=dWI0gbqWzVUyqfami3XwgJ8sNnkZuAH96E5BEjsR050MEmUgfC08h+h3j2T1LwFvD64pUNM0gP4GofoiPs7ytc/TCVxUcrISI1Ae1k1b2kJ7sGutWnH29BT/i9AQKNdR7RKLK5yZ5z4XfUXqhAPYH0V9gXiUTTn4xPZmZ4G5LQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783750810; c=relaxed/simple;
	bh=/SsF5TAIeAWWEnlMPRWRIQwRo23Et+C2XY2FRHi02Lk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hWcS+pVqEPheR7ECvtlzTE3GcHtzWwKyezmrv9H/yDoLhDYsP8B3/t6CSW19Yv3nP63+r7TgeCfXKwR9XzKRmOvNWwAwWD9koFtrdJJmvVQLkGglnJ3DFKL/rrDT1wIh8f3EykHnNfO2sX7L0SsE30oAWsDnD5iIj60Eg18AuuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=TGKg+MBo; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="TGKg+MBo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1783750806; x=1784355606; i=quwenruo.btrfs@gmx.com;
	bh=2dEZEiq+aSuXFghY+QykyU+1DXhHhdUymXVgo3NbGCE=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=TGKg+MBous+5p1XS2UabJsRxn97zEW7hCUKwp1W1cMEXfy6mXNleSY8KwL+3jhjg
	 m+WBiUDcffyOA/ZGwke18NzkOlnhqeORo/3KurVDJeJALe5YT3dMMQQEpT+keBGUK
	 jmcaHaZF1NnRVnwrri5++A3VIuJKRJy37t0zu++ogZDBv7GsN5XKObRVz82Jjdhit
	 8bDHoT1S85bH11x8JRoqlJwxDZ7kE+H5SXnb335WfcLKRUItEL0vrui8N7BxNrlQY
	 UNBb2rNTNQjU898um33JxBLTqwaXWVIyVkDrCjFg8w6/LSbPR3MSU7ab28inYXmiK
	 CuWmR2RaAak7sB9RXw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Md6Mt-1xHm1G28h9-00hyJ0; Sat, 11
 Jul 2026 08:20:06 +0200
Message-ID: <2fc07620-861f-4bb8-ad36-71128ec1ab09@gmx.com>
Date: Sat, 11 Jul 2026 15:50:02 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] btrfs: avoid NULL pointer dereference when block
 group tree root is missing
To: Dongjiang Zhu <zhudongjiang@fnnas.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com
References: <20260711051909.1313584-1-zhudongjiang@fnnas.com>
 <20260711051909.1313584-2-zhudongjiang@fnnas.com>
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
In-Reply-To: <20260711051909.1313584-2-zhudongjiang@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Md9CbLVLjwe+dXZFkiEkuok7gCZqpEszfvtdRyWXA6lCzmtyZUd
 p9nXCthcd5XySD63m57sZGCL8SehYxDIuy94elOY6psEZwf8ktRDO8ElakeQUkA77msq0XI
 4O2dftiU0X8ShU8c6liY+pVvqeCR0hJrjSXw3OGbT2FxCS2E3VYDnSs9SIaZZeZ+UuZVgWx
 qdTuToSPFf6Ymjrk9RuTQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:b0jcptO7trQ=;yY2DcnzDQkGKesEa3/xVtPbR9Y1
 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
 p4hzbMkcOTnuN8+Rl/6gR



=E5=9C=A8 2026/7/11 14:49, Dongjiang Zhu =E5=86=99=E9=81=93:
> [BUG]
> For a filesystem using the block group tree feature, corrupting the bloc=
k
> group tree root and mounting with rescue=3Dibadroots triggers the follow=
ing
> NULL pointer dereference:
>=20
>    BTRFS warning (device loop0 state E): checksum verify failed on logic=
al 30654464 mirror 1 wanted 0x0f55b851 found 0xd7efdde7 level 0
>    BTRFS warning (device loop0 state E): checksum verify failed on logic=
al 30654464 mirror 2 wanted 0x0f55b851 found 0xd7efdde7 level 0
>    BUG: kernel NULL pointer dereference, address: 0000000000000100
>    #PF: supervisor read access in kernel mode
>    #PF: error_code(0x0000) - not-present page
>    Oops: Oops: 0000 [#1] SMP NOPTI
>    RIP: 0010:btrfs_update_global_block_rsv+0x9d/0x1c0 [btrfs]

The problem is why we need to use global block rsv in the first place?

The whole fs is never going to be mounted RW as long as "rescue=3D" mount=
=20
option is utilized.

In the case of a rescue mount, we should just fill in a dummy block rsv,=
=20
with block_rsv->full set.

This will also fix the next bug you're fixing.

>    Call Trace:
>     fill_dummy_bgs+0xd4/0x120 [btrfs]
>     open_ctree+0xc6e/0x1ca0 [btrfs]
>     btrfs_get_tree+0x50d/0xa40 [btrfs]
>=20
> [CAUSE]
> With rescue=3Dibadroots, btrfs_read_roots() ignores a failure to read th=
e
> block group tree root and leaves fs_info->block_group_root NULL.
>=20
> btrfs_read_block_groups() then falls back to fill_dummy_bgs(), which
> initializes the global block reserve.  btrfs_update_global_block_rsv()
> checks only the BLOCK_GROUP_TREE feature bit before dereferencing
> fs_info->block_group_root.
>=20
> [FIX]
> Check that the block group tree root was successfully loaded before
> accounting it in the global block reserve.  This does not affect regular
> mounts, which fail earlier if the root cannot be loaded.
>=20
> Also update the comment in btrfs_read_block_groups() to cover both the
> extent tree root and the block group tree root being missing.
>=20
> Fixes: 8dbfc14fc736 ("btrfs: account block group tree when calculating g=
lobal reserve size")
> Signed-off-by: Dongjiang Zhu <zhudongjiang@fnnas.com>
> ---
>   fs/btrfs/block-group.c | 7 ++++---
>   fs/btrfs/block-rsv.c   | 3 ++-
>   2 files changed, 6 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> index fe5de4928f6f..9d551372f37f 100644
> --- a/fs/btrfs/block-group.c
> +++ b/fs/btrfs/block-group.c
> @@ -2673,9 +2673,10 @@ int btrfs_read_block_groups(struct btrfs_fs_info =
*info)
>   	u64 cache_gen;
>  =20
>   	/*
> -	 * Either no extent root (with ibadroots rescue option) or we have
> -	 * unsupported RO options. The fs can never be mounted read-write, so =
no
> -	 * need to waste time searching block group items.
> +	 * Either the extent tree root or the block group tree root is missing
> +	 * (with the ibadroots rescue option), or we have unsupported RO optio=
ns.
> +	 * The fs can never be mounted read-write, so no need to waste time
> +	 * searching block group items.
>   	 *
>   	 * This also allows new extent tree related changes to be RO compat,
>   	 * no need for a full incompat flag.
> diff --git a/fs/btrfs/block-rsv.c b/fs/btrfs/block-rsv.c
> index 9efb3016ef11..647a065356f4 100644
> --- a/fs/btrfs/block-rsv.c
> +++ b/fs/btrfs/block-rsv.c
> @@ -347,7 +347,8 @@ void btrfs_update_global_block_rsv(struct btrfs_fs_i=
nfo *fs_info)
>   	}
>   	read_unlock(&fs_info->global_root_lock);
>  =20
> -	if (btrfs_fs_compat_ro(fs_info, BLOCK_GROUP_TREE)) {
> +	if (btrfs_fs_compat_ro(fs_info, BLOCK_GROUP_TREE) &&
> +	    fs_info->block_group_root) {
>   		num_bytes +=3D btrfs_root_used(&fs_info->block_group_root->root_item=
);
>   		min_items++;
>   	}

