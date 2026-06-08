Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836383B0ACB
	for <linux-btrfs@vger.kernel.org>; Mon,  8 Jun 2026 09:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780910401; cv=none; b=LHfGok6puWMgnXiNC6LDr/9qVKaCl833jS3WUcj/WgkHpdVuJuwXi6daXXAbUQyS/C/Yr5GurMPYXEwFDmjhkKAtPexM/lyNnGeY1/yDrc5WE9SbOTwf/YT+Sqw4X2Hs73oxKcjE6Q6JNs0tB9808NAHI3dbm3bEOq5Byeo8YBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780910401; c=relaxed/simple;
	bh=/N/h9m7NFt60NB2wN7XLg+YAxFMKWW9KbY2bHOwIg1s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tSTW/oSdCGBG8Z1NK4HgOm2nl+iwuUZSIDz4mTVSc28ksBGyB/GSLFjROQ9GnLESpskM8jQD2Fn14COyLXFmWAPZWUQnafatDAx97j+elONCLhWggdx947BBQ1FkxJr6hZeOH/w36PsW48xYGLJJ1y58zq6+sjORHXsNndK1UHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=orbYKxDu; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="orbYKxDu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1780910392; x=1781515192; i=quwenruo.btrfs@gmx.com;
	bh=2bKY4eBCkOaWktTc/Yw/1+RiypDwwSs8p06p4cvpFS4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=orbYKxDuX8OCCTxyZofvJjCLa3meZAGRPcz8HvXHb3eNeRVopi7PcZbefGyphYSU
	 Xt1tvKlHGOpuEemwLcvmbBoSundPeXLzsRMfBHvSuyCw59G9ryYy/lS0IUEN1Y3NB
	 OnRPwUrsYLOr3iRung3dB0692e0Ge4874p8oir/P1imXjJcqy15Ff77exUbedRo/n
	 irKIEltivNvgIzIn+N4UsNW/L1gB62s3HihBmkwQ/06U+LIS0ZR9MDvDXwawdx+qg
	 YLp93ONG8MtGLKc0o8nD4A2GFWMy6c88o+PYmGF5k4+GHZl48JsjKG1XUuJGsZRjK
	 lvMgjiSixdm2i0dYHQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MXXuB-1wkeu81yhj-00IpJx; Mon, 08
 Jun 2026 11:19:52 +0200
Message-ID: <382a7fec-8dda-4fd8-b126-a97e87949651@gmx.com>
Date: Mon, 8 Jun 2026 18:49:47 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: tree-checker: validate inode_ref and root_ref
 name lengths
To: Weiming Shi <bestswngs@gmail.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, josef@toxicpanda.com, clm@fb.com, xmei5@asu.edu
References: <20260608083509.3907960-2-bestswngs@gmail.com>
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
In-Reply-To: <20260608083509.3907960-2-bestswngs@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:tuutcMVYobb0DBPted+SOdLYKghT5xKqcqbopCd45cLdVYtQcVS
 c3nAHRmboum5jIEKjbHS7qHtkIPRF89MpIJZHmNf8m92QBdHovBWQE3xVsIKLuH1BzRtgKS
 RMkyPtzcXu+o+a3Lj8JwC0Ao458cYMcQKNsEMGkUkAYYve6yY4QXQy1ijAS+ufPn31+M51h
 q2m1Li9mx+eBHFHdYY56g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:gIqZrGfu/Sc=;FHZw7AUwxp93Tt+sN/utyGjZFdj
 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



=E5=9C=A8 2026/6/8 18:05, Weiming Shi =E5=86=99=E9=81=93:
> The on-disk name length of an INODE_REF and a ROOT_REF/ROOT_BACKREF is a
> __le16 and can be up to 65535, but a btrfs name is never longer than
> BTRFS_NAME_LEN (255). The tree-checker validated only that a ref's name
> stays within the item, not that name_len <=3D BTRFS_NAME_LEN, and it did
> not validate ROOT_REF/ROOT_BACKREF items at all. A reader that copies
> name_len bytes into a NAME_MAX-sized buffer therefore overflows it.
>=20
> For example btrfs_get_name(), used by the NFS/exportfs ->get_name op,
> copies the inode_ref/root_ref name into the caller's NAME_MAX + 1 byte
> stack buffer with no bound of its own, which a crafted leaf with
> name_len =3D 4096 overflows. It is reachable from a mounted untrusted
> btrfs image via open_by_handle_at(), and on btrfs exported over NFS:
>=20
>   BUG: KASAN: stack-out-of-bounds in read_extent_buffer (fs/btrfs/extent=
_io.c:3742)
>   Write of size 633 at addr ffffc90006c9fc40 by task exploit/5192
>    read_extent_buffer (fs/btrfs/extent_io.c:3742)
>    btrfs_get_name (fs/btrfs/export.c:289)
>    reconnect_path (fs/exportfs/expfs.c:222)
>    exportfs_decode_fh_raw (fs/exportfs/expfs.c:473)
>    do_handle_open (fs/fhandle.c:230)
>    do_syscall_64 (arch/x86/entry/syscall_64.c:94)
>   Kernel panic - not syncing: stack-protector: Kernel stack is corrupted
>=20
> Reject name_len > BTRFS_NAME_LEN for INODE_REF, and add a check_root_ref=
()
> that validates ROOT_REF/ROOT_BACKREF item size and name length. Bounding
> the length at read time protects every consumer instead of patching each
> copy site, so the corrupted leaf is refused when the tree block is read.
>=20
> Fixes: 2ede0daf0154 ("Btrfs: handle NFS lookups properly")
> Reported-by: Xiang Mei <xmei5@asu.edu>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> ---
>=20
> v2:
> - Check name_len in the tree-checker instead of btrfs_get_name().
> - Add check_root_ref() for ROOT_REF/ROOT_BACKREF items.
>=20
>   fs/btrfs/tree-checker.c | 40 ++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 40 insertions(+)
>=20
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index 60bba7fbe..fedb0bd55 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -1760,6 +1760,12 @@ static int check_inode_ref(struct extent_buffer *=
leaf,
>   				ptr, end, namelen);
>   			return -EUCLEAN;
>   		}
> +		if (unlikely(namelen > BTRFS_NAME_LEN)) {
> +			inode_ref_err(leaf, slot,
> +				"inode ref name too long, namelen %u max %u",
> +				namelen, BTRFS_NAME_LEN);
> +			return -EUCLEAN;
> +		}
>  =20
>   		/*
>   		 * NOTE: In theory we should record all found index numbers
> @@ -1804,6 +1810,36 @@ static int check_inode_extref(struct extent_buffe=
r *leaf,
>   	return 0;
>   }
>  =20
> +static int check_root_ref(struct extent_buffer *leaf, int slot)
> +{
> +	struct btrfs_root_ref *ref;
> +	u32 item_size =3D btrfs_item_size(leaf, slot);
> +	u16 namelen;
> +
> +	if (unlikely(item_size < sizeof(*ref))) {
> +		generic_err(leaf, slot,
> +			"invalid root ref item size, have %u expect >=3D %zu",
> +			item_size, sizeof(*ref));
> +		return -EUCLEAN;
> +	}
> +
> +	ref =3D btrfs_item_ptr(leaf, slot, struct btrfs_root_ref);
> +	namelen =3D btrfs_root_ref_name_len(leaf, ref);
> +	if (unlikely(sizeof(*ref) + namelen !=3D item_size)) {
> +		generic_err(leaf, slot,
> +			"invalid root ref name len, have %u expect %zu",
> +			namelen, item_size - sizeof(*ref));
> +		return -EUCLEAN;
> +	}
> +	if (unlikely(namelen > BTRFS_NAME_LEN)) {

Wrong branch, the for-next (*) branch already has a chekc_root_ref().

And it looks like Claude is just switching the the sequence of the two=20
checks.
Upstream is doing the max len check before item size check.
And the item size check is not as good as the upstream one.


Considering you're doing all your tests based older branches, I believe=20
you should also update the commit message, since it will not trigger the=
=20
access out of boundary due to the existing tree-check checks.

*: https://github.com/btrfs/linux/tree/for-next


> +		generic_err(leaf, slot,
> +			"root ref name too long, namelen %u max %u",
> +			namelen, BTRFS_NAME_LEN);
> +		return -EUCLEAN;
> +	}
> +	return 0;
> +}
> +
>   static int check_raid_stripe_extent(const struct extent_buffer *leaf,
>   				    const struct btrfs_key *key, int slot)
>   {
> @@ -1937,6 +1973,10 @@ static enum btrfs_tree_block_status check_leaf_it=
em(struct extent_buffer *leaf,
>   	case BTRFS_ROOT_ITEM_KEY:
>   		ret =3D check_root_item(leaf, key, slot);
>   		break;
> +	case BTRFS_ROOT_REF_KEY:
> +	case BTRFS_ROOT_BACKREF_KEY:
> +		ret =3D check_root_ref(leaf, slot);



> +		break;
>   	case BTRFS_EXTENT_ITEM_KEY:
>   	case BTRFS_METADATA_ITEM_KEY:
>   		ret =3D check_extent_item(leaf, key, slot, prev_key);

