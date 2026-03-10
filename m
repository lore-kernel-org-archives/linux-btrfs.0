Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E85021FF30;
	Tue, 10 Mar 2026 22:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773180122; cv=none; b=QoL4f96z3IkVEdDFdmxmlbGIj4XdN0Z142sQ8c8ZMTlJPwYAysvR/x3R81v8C925NueMe1BTXLIIJm27pScVeE1YWnX95dNuYYJYWQz0pn5pVNRyglHUtBvJnX9FoePY/qwWX1vmmCY8tnW4Ds+MPZ+ODX5En8vtL8oB4bCchu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773180122; c=relaxed/simple;
	bh=NtpG3sdn0XGRRwBFnG/jlcZv8zLloDrp02sYgddeNJw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i0nTuZjcb+FOoyw6Q94omhG7/U9hxb0Bl1T4ZeIoE5HbJRQkn+Q3xG1G10sko4cy4i+577KDxVEF/vgI+ukpVNKJ0pWJoP62vZMJMUl3EMNSHU9favT30oToy1JavpocslCw/i6i5v6LAQOKzJjxGQL4HYAeZvzC5pnFjFMCyEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=cLp34O5T; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="cLp34O5T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1773180114; x=1773784914; i=quwenruo.btrfs@gmx.com;
	bh=ShvtRcJy6JCYieuVE28N17iordfDhEOmZJQnAVk5K0U=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=cLp34O5TY8MEqMTl9a79eXOLngXERdoa/OzrfWsw3Em4YnJT4clZt9m/4TMfX8GJ
	 RBKeu4kelNzpMk+5EJE1vBs0RAugl8TASTQ6QMFVAD7rjXuZXyMf+si1S9VcRa/f/
	 HzCcxUCv1Jqv1hHiPsr2TT0/Hz72QLi0v69/OMWZGKtkgbv+JFNe/hab4TbgSwVce
	 clCQAVuDj7w6DlYDb/HP27DJc+aCS104Nik7IMMPwUzqWiRXG5xoprxD2LGN53M7f
	 uE/rCctHp2+PgyVRo5HeFwSlnoXl53LDJ/qOZ3y9YfcURyub3jipd7H/YTB74ujEG
	 MU3chTMw34N0SSckEQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MTzfG-1w9XKV3mNe-00OYQT; Tue, 10
 Mar 2026 23:01:54 +0100
Message-ID: <fe79b67e-79fa-43fa-8466-72d7d9bd0b80@gmx.com>
Date: Wed, 11 Mar 2026 08:31:48 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: tree-checker: introduce checks for
 FREE_SPACE_BITMAP
To: ZhengYuan Huang <gality369@gmail.com>, dsterba@suse.com, clm@fb.com
Cc: wqu@suse.com, osandov@fb.com, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, baijiaju1990@gmail.com, r33s3n6@gmail.com,
 zzzccc427@gmail.com
References: <20260310105606.2134142-1-gality369@gmail.com>
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
In-Reply-To: <20260310105606.2134142-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:D4k+FdhV7fSUPiSXNCaLaQzX6PQsseeLDP7cO2LYy3nowfOtJ+W
 ksn+SLmMCGGQndC1ICIXTpF/jaErskzHJVjNylOxNFZsJOKS4XYQD4oiRNcMXM5oro+1ME2
 cbpgBqEmZZJAg5fBtKwPNxvsLipbRbwodHQG+XEWn3OaSDOKblh02BJmCd33ID2qPYyBkCA
 wc6Rd8epdnVAwYZf/L3rg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:mu6UjMYOJCo=;qK7/x7XSXvc2gVjzwwsAm/zC+FX
 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
 CUs4kUwgm2xWBIugyPLyOK1BZnrIT



=E5=9C=A8 2026/3/10 21:26, ZhengYuan Huang =E5=86=99=E9=81=93:
> Introduce checks for FREE_SPACE_BITMAP item, which include:
>=20
> - Key alignment check
>    Same as FREE_SPACE_EXTENT, the objectid is the logical bytenr of the
>    free space, and offset is the length of the free space, so both
>    should be aligned to the fs block size.
>=20
> - Non-zero range check
>    A zero key->offset would describe an empty bitmap, which is invalid.
>=20
> - Item size check
>    The item must hold exactly DIV_ROUND_UP(key->offset >> sectorsize_bit=
s,
>    BITS_PER_BYTE) bytes.  A mismatch indicates a truncated or otherwise
>    corrupt bitmap item; without this check, the bitmap loading path woul=
d
>    walk past the end of the leaf and trigger a NULL dereference in
>    assert_eb_folio_uptodate().
>=20
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

And pushed to for-next branch with minor changes to resolve the=20
conflicts with my patches on FREE_SPACE_INFO and FREE_SPACE_EXTENT.

Finally to reflect the review from Johannes on my patches, split the=20
objectid and offset check into two, so that they will have a more=20
explicit message on exactly which member is not aligned.

Thanks,
Qu

> ---
> [CHANGELOG]
> v2:
> - Move the FREE_SPACE_BITMAP item size validation from
>    load_free_space_bitmaps() in free-space-tree.c into tree-checker, so
>    corrupt bitmap items are rejected when the leaf is read from disk.
> - Drop the extent_buffer_test_bit() range check added in v1.
> - Rework the fix to follow Qu Wenruo's suggested tree-checker based
>    validation.
> ---
>   fs/btrfs/tree-checker.c | 39 +++++++++++++++++++++++++++++++++++++++
>   1 file changed, 39 insertions(+)
>=20
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index c10b4c242acf..0f12fe462b6c 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -1901,6 +1901,42 @@ static int check_dev_extent_item(const struct ext=
ent_buffer *leaf,
>   	return 0;
>   }
>  =20
> +static int check_free_space_bitmap(struct extent_buffer *leaf,
> +				   struct btrfs_key *key, int slot)
> +{
> +	struct btrfs_fs_info *fs_info =3D leaf->fs_info;
> +	const u32 blocksize =3D fs_info->sectorsize;
> +	u32 expected_item_size;
> +
> +	if (unlikely(!IS_ALIGNED(key->objectid, blocksize) ||
> +		     !IS_ALIGNED(key->offset, blocksize))) {
> +		generic_err(leaf, slot,
> +			    "free space bitmap key range is not aligned to %u, has (%llu %u =
%llu)",
> +			    blocksize, key->objectid, key->type, key->offset);
> +		return -EUCLEAN;
> +	}
> +	if (unlikely(key->offset =3D=3D 0)) {
> +		generic_err(leaf, slot,
> +			    "free space bitmap range is 0");
> +		return -EUCLEAN;
> +	}
> +	/*
> +	 * The item must hold exactly the right number of bitmap bytes for the
> +	 * range described by key->offset.  A mismatch means the item was
> +	 * truncated or the key is corrupt; either way the bitmap data is not
> +	 * safe to access.
> +	 */
> +	expected_item_size =3D DIV_ROUND_UP(key->offset >> fs_info->sectorsize=
_bits,
> +					  BITS_PER_BYTE);
> +	if (unlikely(btrfs_item_size(leaf, slot) !=3D expected_item_size)) {
> +		generic_err(leaf, slot,
> +			    "invalid item size for free space bitmap, has %u expect %u",
> +			    btrfs_item_size(leaf, slot), expected_item_size);
> +		return -EUCLEAN;
> +	}
> +	return 0;
> +}
> +
>   /*
>    * Common point to switch the item-specific validation.
>    */
> @@ -1964,6 +2000,9 @@ static enum btrfs_tree_block_status check_leaf_ite=
m(struct extent_buffer *leaf,
>   	case BTRFS_RAID_STRIPE_KEY:
>   		ret =3D check_raid_stripe_extent(leaf, key, slot);
>   		break;
> +	case BTRFS_FREE_SPACE_BITMAP_KEY:
> +		ret =3D check_free_space_bitmap(leaf, key, slot);
> +		break;
>   	}
>  =20
>   	if (unlikely(ret))

