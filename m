Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCC63890F1;
	Mon,  7 Sep 2026 06:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788763890; cv=none; b=SZE50m7kLts4wYrJXysxfED55Q2uwk/UJsH4J/SwsDRgOM6i6hoNnu95MtbcWf90ePxwylT201qL20jwoAcCDfrnqEB2w5h5AyQ/OKg81Lq0EJWTQCXLwHgL4UEakOcRhpFkJUNPvqjypg3eli1aZ/mtmD7hkTIMGIEXYOD3eNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788763890; c=relaxed/simple;
	bh=Q7+O6jefsc9lE+7aFQMA6nuEEPZMfu6m38l7K9N6CD0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YqXwHjL0StALTNA5KRwEw9kf227JtbQU8tb60WqGGbVn0Z5YkaNDg0bdhdE6avR3xjhvRNPZo9QnBCKracc6RwT2EQ9JR+h6/REsXIkKW8tqbjJCdPdUzqejGMW76s3LTwYBKYevom4o8t5GOFRsCk9XV6UorHyNGGVinktQbKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=EpZERO1E; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="EpZERO1E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1788763873; x=1789368673; i=quwenruo.btrfs@gmx.com;
	bh=mCcv9iftHX5N1CGRR4w5qCXxgN3mvewjWwb5K4oyhfw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=EpZERO1EQtsXcMKWE/QKHwTHNB82PZoBEamh8sd4ry8tJ6VgLXa2avGOjI+nox6t
	 wUfbowBNucD+7enx/p8pDneLFdr5KfrykWZJB1/IsY4JCAb9oSYmo2Ple31+3YzY6
	 JUl9YTW/sGbkMDLh0UEu5kVzXxahfsZjgo3w8zPlcO8dFU8gWbsQuwSqbab1PGinG
	 aypPmnmfAGJZsqMHdPhbtZEPsDmH4lqj474RlWtPrA54+Si6Nr6hjpunTXdtKATwm
	 DNvvUvs6IFIVtahOf01N/WV0YqPdrQBJq195uQ68En1SGQlOYNmJOTJ9tGCQXr3gi
	 wMbKalZ3rwd23L3Nuw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MHG8g-1x7t2W3P3g-00EbjL; Mon, 07
 Sep 2026 08:51:13 +0200
Message-ID: <4e2f0f90-0dd1-490d-bbb4-2bcde430b2e0@gmx.com>
Date: Mon, 7 Sep 2026 16:21:08 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/10] btrfs: use folios for reading super blocks from the
 block device
To: Tal Zussman <tz2294@columbia.edu>, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260906-btrfs-folio-conversions-v1-0-834b9d7b06f5@columbia.edu>
 <20260906-btrfs-folio-conversions-v1-7-834b9d7b06f5@columbia.edu>
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
In-Reply-To: <20260906-btrfs-folio-conversions-v1-7-834b9d7b06f5@columbia.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:vqpLTqup102a2ZqTQulNxlBCyaUx9w7Lz5673z1Wr9JaAUwskW0
 FLJEmcJRTdXjb9CwFqA9gfd8ug9yR7u0TkBwqLvZmcS7sdZ/QCE+vAFMmv9LqtAlaCAngAC
 Z9tnGfVOdmxiH7/Bk8Pzl4AemWDBaLpmCJUsgOwKbKRthkaPxOCxyzyhTAqAba834dXIctz
 Mp44+uW8vj1oC6Xv9R19w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:LQvIH0Su/0w=;/1Azjx2lazdjKKzAmiF8wQggrnq
 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
 UaxAQTq0JGaGR



=E5=9C=A8 2026/9/7 07:59, Tal Zussman =E5=86=99=E9=81=93:
> btrfs_read_disk_super() and the zoned super block log comparison go
> through read_cache_page_gfp() and page_address(), and
> btrfs_release_disk_super() recovers the page with virt_to_page(). Use
> mapping_read_folio_gfp(), folio_address(), and virt_to_folio() instead.
> This removes the last callers of read_cache_page_gfp() and put_page()
> in btrfs.
>=20
> Compute the super block address with offset_in_folio() as
> write_dev_supers() does, rather than assuming it is at the start of
> the page.
>=20
> Assisted-by: Claude:claude-fable-5-1
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/volumes.c | 16 +++++++---------
>   fs/btrfs/zoned.c   | 12 ++++++------
>   2 files changed, 13 insertions(+), 15 deletions(-)
>=20
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 949e40baff33..4ddabadc9188 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1327,16 +1327,14 @@ int btrfs_open_devices(struct btrfs_fs_devices *=
fs_devices,
>  =20
>   void btrfs_release_disk_super(struct btrfs_super_block *super)
>   {
> -	struct page *page =3D virt_to_page(super);
> -
> -	put_page(page);
> +	folio_put(virt_to_folio(super));
>   }
>  =20
>   struct btrfs_super_block *btrfs_read_disk_super(struct block_device *b=
dev,
>   						int copy_num, bool drop_cache)
>   {
>   	struct btrfs_super_block *super;
> -	struct page *page;
> +	struct folio *folio;
>   	u64 bytenr, bytenr_orig;
>   	struct address_space *mapping =3D bdev->bd_mapping;
>   	int ret;
> @@ -1357,7 +1355,7 @@ struct btrfs_super_block *btrfs_read_disk_super(st=
ruct block_device *bdev,
>   		ASSERT(copy_num =3D=3D 0);
>  =20
>   		/*
> -		 * Drop the page of the primary superblock, so later read will
> +		 * Drop the folio of the primary superblock, so later read will
>   		 * always read from the device.
>   		 */
>   		invalidate_inode_pages2_range(mapping, bytenr >> PAGE_SHIFT,
> @@ -1365,12 +1363,12 @@ struct btrfs_super_block *btrfs_read_disk_super(=
struct block_device *bdev,
>   	}
>  =20
>   	filemap_invalidate_lock_shared(mapping);
> -	page =3D read_cache_page_gfp(mapping, bytenr >> PAGE_SHIFT, GFP_NOFS);
> +	folio =3D mapping_read_folio_gfp(mapping, bytenr >> PAGE_SHIFT, GFP_NO=
FS);
>   	filemap_invalidate_unlock_shared(mapping);
> -	if (IS_ERR(page))
> -		return ERR_CAST(page);
> +	if (IS_ERR(folio))
> +		return ERR_CAST(folio);
>  =20
> -	super =3D page_address(page);
> +	super =3D folio_address(folio) + offset_in_folio(folio, bytenr);
>   	if (btrfs_super_magic(super) !=3D BTRFS_MAGIC ||
>   	    btrfs_super_bytenr(super) !=3D bytenr_orig) {
>   		btrfs_release_disk_super(super);
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 08a15465a087..a1ef8caaacda 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -123,24 +123,24 @@ static int sb_write_pointer(struct block_device *b=
dev, struct blk_zone *zones,
>   	} else if (full[0] && full[1]) {
>   		/* Compare two super blocks */
>   		struct address_space *mapping =3D bdev->bd_mapping;
> -		struct page *page[BTRFS_NR_SB_LOG_ZONES];
>   		struct btrfs_super_block *super[BTRFS_NR_SB_LOG_ZONES];
>  =20
>   		for (int i =3D 0; i < BTRFS_NR_SB_LOG_ZONES; i++) {
>   			u64 zone_end =3D (zones[i].start + zones[i].capacity) << SECTOR_SHI=
FT;
>   			u64 bytenr =3D ALIGN_DOWN(zone_end, BTRFS_SUPER_INFO_SIZE) -
>   						BTRFS_SUPER_INFO_SIZE;
> +			struct folio *folio;
>  =20
>   			filemap_invalidate_lock_shared(mapping);
> -			page[i] =3D read_cache_page_gfp(mapping,
> -					bytenr >> PAGE_SHIFT, GFP_NOFS);
> +			folio =3D mapping_read_folio_gfp(mapping, bytenr >> PAGE_SHIFT,
> +						       GFP_NOFS);
>   			filemap_invalidate_unlock_shared(mapping);
> -			if (IS_ERR(page[i])) {
> +			if (IS_ERR(folio)) {
>   				if (i =3D=3D 1)
>   					btrfs_release_disk_super(super[0]);
> -				return PTR_ERR(page[i]);
> +				return PTR_ERR(folio);
>   			}
> -			super[i] =3D page_address(page[i]);
> +			super[i] =3D folio_address(folio) + offset_in_folio(folio, bytenr);
>   		}
>  =20
>   		if (btrfs_super_generation(super[0]) >
>=20

