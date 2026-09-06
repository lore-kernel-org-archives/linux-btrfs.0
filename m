Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0EC27B343;
	Sun,  6 Sep 2026 23:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788736352; cv=none; b=XFQR6j5mIto5AZzeWM+UXzQ6gyVIiCZqbWFkCEoAl9iEc65Q9guSi5uXWxwBkVM2/Nih7E6PnEnjp0+laHbezd6gqjPF8PKdiTcxjgk3yJ468h69cXN9oDMk3SGJgyWwVxGE+Ybdcavmw764pVXVwa4IRYEToexrsWHrAHs0dSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788736352; c=relaxed/simple;
	bh=XwBDvPu/iQmePam9R2L/kbyDIeTfVEiWg38z3zF448c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bDURBRR8kUZJGOTcBTyV1UlVJOCm0VEoXFKShmHJMUS/xrAf+dNDfhhBapJFeHgilpl/tKnZyYpaC46rXFn7na/YOz6/ozJJMB09eruguc1CozUvSBwOIG8xLRbYkywAAIVMfW9X4+HvQBzWzAhFIzty3qET5fF0MvRFsgaXzlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=rEkdlFaR; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="rEkdlFaR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1788736344; x=1789341144; i=quwenruo.btrfs@gmx.com;
	bh=AuAg+K5sxi6OgFa61tU/zawgeVruI08svpRd8vBUZ34=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=rEkdlFaRweRdjlAkt8TVqXsKSD/ueq+gRwxTHlC6Tr1SPK8vaXveCuvD9vSXuLiC
	 2n1s6g1YdsbnPW1BrB97QyQ6yfhXGMcF6gBzOvoaKxq3oo9B/sot7loGixyvSAuLO
	 qv/sYUg/nbG/iVQtmH9iLAtAaY4TyJQuVyBWhr5LWbeJvBt7ujPeARmLBdxiKZx8u
	 jqZgvix5uNxr5OPj7ucr6HzVirpNxzUY060AmNy5IDh868H5H3JG87vVmBUS488Lo
	 kD5qejXXDpAaTnuXjQGjz2o4M6Z+jIJggKR7MJusCj84++cmsCZ4gq5rO/SFU3UjV
	 Oj5uDpZOZo/7SrBxTw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MnJlW-1wbgnL0wFQ-00lZJt; Mon, 07
 Sep 2026 01:12:24 +0200
Message-ID: <3f82fc56-b621-4d94-9079-b4984dc3823b@gmx.com>
Date: Mon, 7 Sep 2026 08:42:17 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/10] btrfs: rename io_ctl page helpers to folio helpers
To: Tal Zussman <tz2294@columbia.edu>, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260906-btrfs-folio-conversions-v1-0-834b9d7b06f5@columbia.edu>
 <20260906-btrfs-folio-conversions-v1-10-834b9d7b06f5@columbia.edu>
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
In-Reply-To: <20260906-btrfs-folio-conversions-v1-10-834b9d7b06f5@columbia.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:9eS1oFjWoBbl5Cn0YFBbixk6P9Unbs5Nahw2LSjp0jExuckm8VS
 eeY5IhGvOtoA0XV6GJUS4+jQSFvS15V+K/n7eFJBpnPR+s289pZnry+jzv8yR+O5e6lflP9
 Ge+UEhll/XJ9WLUz7i6Udi7luR1aYUx+T7i7gaz9J2ER6ItVfcRZkoCD1mqox9UsYMhHBSr
 vfx5m8dt3bGrOdU654ZYg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:dGeNV9wIxjc=;JUIfRxLyPpBIRTRIFKjMjiEZUtF
 +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
 KcdRtqE2gjt3v



=E5=9C=A8 2026/9/7 07:59, Tal Zussman =E5=86=99=E9=81=93:
> These functions now operate on folios. Rename them and update comments
> accordingly.

Again, v1 space cache is fully disabled since commit 545e560a5b0f=20
("btrfs: disable v1 space cache"), it would make more sense to remove=20
those functions other than doing a rename for codes that we're going to=20
remove anyway.

>=20
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>   fs/btrfs/free-space-cache.c | 78 ++++++++++++++++++++++---------------=
=2D-------
>   1 file changed, 39 insertions(+), 39 deletions(-)
>=20
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index ab933ee6f19c..73cfc1d1a5c1 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -406,7 +406,7 @@ static void io_ctl_free(struct btrfs_io_ctl *io_ctl)
>   	io_ctl->folios =3D NULL;
>   }
>  =20
> -static void io_ctl_unmap_page(struct btrfs_io_ctl *io_ctl)
> +static void io_ctl_unmap_folio(struct btrfs_io_ctl *io_ctl)
>   {
>   	if (io_ctl->cur) {
>   		io_ctl->cur =3D NULL;
> @@ -414,7 +414,7 @@ static void io_ctl_unmap_page(struct btrfs_io_ctl *i=
o_ctl)
>   	}
>   }
>  =20
> -static void io_ctl_map_page(struct btrfs_io_ctl *io_ctl, int clear)
> +static void io_ctl_map_folio(struct btrfs_io_ctl *io_ctl, int clear)
>   {
>   	ASSERT(io_ctl->index < io_ctl->num_folios);
>   	io_ctl->folio =3D io_ctl->folios[io_ctl->index++];
> @@ -425,11 +425,11 @@ static void io_ctl_map_page(struct btrfs_io_ctl *i=
o_ctl, int clear)
>   		clear_page(io_ctl->cur);
>   }
>  =20
> -static void io_ctl_drop_pages(struct btrfs_io_ctl *io_ctl)
> +static void io_ctl_drop_folios(struct btrfs_io_ctl *io_ctl)
>   {
>   	int i;
>  =20
> -	io_ctl_unmap_page(io_ctl);
> +	io_ctl_unmap_folio(io_ctl);
>  =20
>   	for (i =3D 0; i < io_ctl->num_folios; i++) {
>   		if (io_ctl->folios[i]) {
> @@ -439,7 +439,7 @@ static void io_ctl_drop_pages(struct btrfs_io_ctl *i=
o_ctl)
>   	}
>   }
>  =20
> -static int io_ctl_prepare_pages(struct btrfs_io_ctl *io_ctl, bool uptod=
ate)
> +static int io_ctl_prepare_folios(struct btrfs_io_ctl *io_ctl, bool upto=
date)
>   {
>   	struct folio *folio;
>   	struct inode *inode =3D io_ctl->inode;
> @@ -453,7 +453,7 @@ static int io_ctl_prepare_pages(struct btrfs_io_ctl =
*io_ctl, bool uptodate)
>   					    FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
>   					    mask);
>   		if (IS_ERR(folio)) {
> -			io_ctl_drop_pages(io_ctl);
> +			io_ctl_drop_folios(io_ctl);
>   			return PTR_ERR(folio);
>   		}
>  =20
> @@ -461,7 +461,7 @@ static int io_ctl_prepare_pages(struct btrfs_io_ctl =
*io_ctl, bool uptodate)
>   		if (ret < 0) {
>   			folio_unlock(folio);
>   			folio_put(folio);
> -			io_ctl_drop_pages(io_ctl);
> +			io_ctl_drop_folios(io_ctl);
>   			return ret;
>   		}
>  =20
> @@ -472,13 +472,13 @@ static int io_ctl_prepare_pages(struct btrfs_io_ct=
l *io_ctl, bool uptodate)
>   			if (folio->mapping !=3D inode->i_mapping) {
>   				btrfs_err(BTRFS_I(inode)->root->fs_info,
>   					  "free space cache page truncated");
> -				io_ctl_drop_pages(io_ctl);
> +				io_ctl_drop_folios(io_ctl);
>   				return -EIO;
>   			}
>   			if (!folio_test_uptodate(folio)) {
>   				btrfs_err(BTRFS_I(inode)->root->fs_info,
>   					   "error reading free space cache");
> -				io_ctl_drop_pages(io_ctl);
> +				io_ctl_drop_folios(io_ctl);
>   				return -EIO;
>   			}
>   		}
> @@ -492,7 +492,7 @@ static int io_ctl_prepare_pages(struct btrfs_io_ctl =
*io_ctl, bool uptodate)
>  =20
>   static void io_ctl_set_generation(struct btrfs_io_ctl *io_ctl, u64 gen=
eration)
>   {
> -	io_ctl_map_page(io_ctl, 1);
> +	io_ctl_map_folio(io_ctl, 1);
>  =20
>   	/*
>   	 * Skip the csum areas.  If we don't check crcs then we just have a
> @@ -521,7 +521,7 @@ static int io_ctl_check_generation(struct btrfs_io_c=
tl *io_ctl, u64 generation)
>   		btrfs_err_rl(io_ctl->fs_info,
>   			"space cache generation (%llu) does not match inode (%llu)",
>   				cache_gen, generation);
> -		io_ctl_unmap_page(io_ctl);
> +		io_ctl_unmap_folio(io_ctl);
>   		return -EIO;
>   	}
>   	io_ctl->cur +=3D sizeof(u64);
> @@ -539,7 +539,7 @@ static void io_ctl_set_crc(struct btrfs_io_ctl *io_c=
tl, int index)
>  =20
>   	crc =3D crc32c(crc, io_ctl->orig + offset, PAGE_SIZE - offset);
>   	btrfs_crc32c_final(crc, (u8 *)&crc);
> -	io_ctl_unmap_page(io_ctl);
> +	io_ctl_unmap_folio(io_ctl);
>   	tmp =3D folio_address(io_ctl->folios[0]);
>   	tmp +=3D index;
>   	*tmp =3D crc;
> @@ -561,13 +561,13 @@ static int io_ctl_check_crc(struct btrfs_io_ctl *i=
o_ctl, int index)
>   	tmp +=3D index;
>   	val =3D *tmp;
>  =20
> -	io_ctl_map_page(io_ctl, 0);
> +	io_ctl_map_folio(io_ctl, 0);
>   	crc =3D crc32c(crc, io_ctl->orig + offset, PAGE_SIZE - offset);
>   	btrfs_crc32c_final(crc, (u8 *)&crc);
>   	if (val !=3D crc) {
>   		btrfs_err_rl(io_ctl->fs_info,
>   			"csum mismatch on free space cache");
> -		io_ctl_unmap_page(io_ctl);
> +		io_ctl_unmap_folio(io_ctl);
>   		return -EIO;
>   	}
>  =20
> @@ -595,12 +595,12 @@ static int io_ctl_add_entry(struct btrfs_io_ctl *i=
o_ctl, u64 offset, u64 bytes,
>  =20
>   	io_ctl_set_crc(io_ctl, io_ctl->index - 1);
>  =20
> -	/* No more pages to map */
> +	/* No more folios to map */
>   	if (io_ctl->index >=3D io_ctl->num_folios)
>   		return 0;
>  =20
> -	/* map the next page */
> -	io_ctl_map_page(io_ctl, 1);
> +	/* map the next folio */
> +	io_ctl_map_folio(io_ctl, 1);
>   	return 0;
>   }
>  =20
> @@ -610,24 +610,24 @@ static int io_ctl_add_bitmap(struct btrfs_io_ctl *=
io_ctl, void *bitmap)
>   		return -ENOSPC;
>  =20
>   	/*
> -	 * If we aren't at the start of the current page, unmap this one and
> +	 * If we aren't at the start of the current folio, unmap this one and
>   	 * map the next one if there is any left.
>   	 */
>   	if (io_ctl->cur !=3D io_ctl->orig) {
>   		io_ctl_set_crc(io_ctl, io_ctl->index - 1);
>   		if (io_ctl->index >=3D io_ctl->num_folios)
>   			return -ENOSPC;
> -		io_ctl_map_page(io_ctl, 0);
> +		io_ctl_map_folio(io_ctl, 0);
>   	}
>  =20
>   	copy_page(io_ctl->cur, bitmap);
>   	io_ctl_set_crc(io_ctl, io_ctl->index - 1);
>   	if (io_ctl->index < io_ctl->num_folios)
> -		io_ctl_map_page(io_ctl, 0);
> +		io_ctl_map_folio(io_ctl, 0);
>   	return 0;
>   }
>  =20
> -static void io_ctl_zero_remaining_pages(struct btrfs_io_ctl *io_ctl)
> +static void io_ctl_zero_remaining_folios(struct btrfs_io_ctl *io_ctl)
>   {
>   	/*
>   	 * If we're not on the boundary we know we've modified the page and w=
e
> @@ -636,10 +636,10 @@ static void io_ctl_zero_remaining_pages(struct btr=
fs_io_ctl *io_ctl)
>   	if (io_ctl->cur !=3D io_ctl->orig)
>   		io_ctl_set_crc(io_ctl, io_ctl->index - 1);
>   	else
> -		io_ctl_unmap_page(io_ctl);
> +		io_ctl_unmap_folio(io_ctl);
>  =20
>   	while (io_ctl->index < io_ctl->num_folios) {
> -		io_ctl_map_page(io_ctl, 1);
> +		io_ctl_map_folio(io_ctl, 1);
>   		io_ctl_set_crc(io_ctl, io_ctl->index - 1);
>   	}
>   }
> @@ -666,7 +666,7 @@ static int io_ctl_read_entry(struct btrfs_io_ctl *io=
_ctl,
>   	if (io_ctl->size >=3D sizeof(struct btrfs_free_space_entry))
>   		return 0;
>  =20
> -	io_ctl_unmap_page(io_ctl);
> +	io_ctl_unmap_folio(io_ctl);
>  =20
>   	return 0;
>   }
> @@ -681,7 +681,7 @@ static int io_ctl_read_bitmap(struct btrfs_io_ctl *i=
o_ctl,
>   		return ret;
>  =20
>   	copy_page(entry->bitmap, io_ctl->cur);
> -	io_ctl_unmap_page(io_ctl);
> +	io_ctl_unmap_folio(io_ctl);
>  =20
>   	return 0;
>   }
> @@ -797,7 +797,7 @@ static int __load_free_space_cache(struct btrfs_root=
 *root, struct inode *inode,
>  =20
>   	readahead_cache(inode);
>  =20
> -	ret =3D io_ctl_prepare_pages(&io_ctl, true);
> +	ret =3D io_ctl_prepare_folios(&io_ctl, true);
>   	if (ret)
>   		goto out;
>  =20
> @@ -869,7 +869,7 @@ static int __load_free_space_cache(struct btrfs_root=
 *root, struct inode *inode,
>   		num_entries--;
>   	}
>  =20
> -	io_ctl_unmap_page(&io_ctl);
> +	io_ctl_unmap_folio(&io_ctl);
>  =20
>   	/*
>   	 * We add the bitmaps at the end of the entries in order that
> @@ -882,13 +882,13 @@ static int __load_free_space_cache(struct btrfs_ro=
ot *root, struct inode *inode,
>   			goto free_cache;
>   	}
>  =20
> -	io_ctl_drop_pages(&io_ctl);
> +	io_ctl_drop_folios(&io_ctl);
>   	ret =3D 1;
>   out:
>   	io_ctl_free(&io_ctl);
>   	return ret;
>   free_cache:
> -	io_ctl_drop_pages(&io_ctl);
> +	io_ctl_drop_folios(&io_ctl);
>  =20
>   	spin_lock(&ctl->tree_lock);
>   	__btrfs_remove_free_space_cache(ctl);
> @@ -1280,7 +1280,7 @@ cleanup_write_cache_enospc(struct inode *inode,
>   			   struct btrfs_io_ctl *io_ctl,
>   			   struct extent_state **cached_state)
>   {
> -	io_ctl_drop_pages(io_ctl);
> +	io_ctl_drop_folios(io_ctl);
>   	btrfs_unlock_extent(&BTRFS_I(inode)->io_tree, 0, i_size_read(inode) -=
 1,
>   			    cached_state);
>   }
> @@ -1297,7 +1297,7 @@ static int __btrfs_wait_cache_io(struct btrfs_root=
 *root,
>   	if (!inode)
>   		return 0;
>  =20
> -	/* Flush the dirty pages in the cache file. */
> +	/* Flush the dirty folios in the cache file. */
>   	ret =3D flush_dirty_cache(inode);
>   	if (ret)
>   		goto out;
> @@ -1402,8 +1402,8 @@ static int __btrfs_write_out_cache(struct inode *i=
node,
>   		spin_unlock(&block_group->lock);
>   	}
>  =20
> -	/* Lock all pages first so we can lock the extent safely. */
> -	ret =3D io_ctl_prepare_pages(io_ctl, false);
> +	/* Lock all folios first so we can lock the extent safely. */
> +	ret =3D io_ctl_prepare_folios(io_ctl, false);
>   	if (ret)
>   		goto out_unlock;
>  =20
> @@ -1443,10 +1443,10 @@ static int __btrfs_write_out_cache(struct inode =
*inode,
>   	if (ret)
>   		goto out_nospc;
>  =20
> -	/* Zero out the rest of the pages just to make sure */
> -	io_ctl_zero_remaining_pages(io_ctl);
> +	/* Zero out the rest of the folios just to make sure */
> +	io_ctl_zero_remaining_folios(io_ctl);
>  =20
> -	/* Everything is written out, now we dirty the pages in the file. */
> +	/* Everything is written out, now we dirty the folios in the file. */
>   	i_size =3D i_size_read(inode);
>   	for (int i =3D 0; i < round_up(i_size, PAGE_SIZE) / PAGE_SIZE; i++) {
>   		u64 dirty_start =3D i * PAGE_SIZE;
> @@ -1461,17 +1461,17 @@ static int __btrfs_write_out_cache(struct inode =
*inode,
>   	if (block_group->flags & BTRFS_BLOCK_GROUP_DATA)
>   		up_write(&block_group->data_rwsem);
>   	/*
> -	 * Release the pages and unlock the extent, we will flush
> +	 * Release the folios and unlock the extent, we will flush
>   	 * them out later
>   	 */
> -	io_ctl_drop_pages(io_ctl);
> +	io_ctl_drop_folios(io_ctl);
>   	io_ctl_free(io_ctl);
>  =20
>   	btrfs_unlock_extent(&BTRFS_I(inode)->io_tree, 0, i_size_read(inode) -=
 1,
>   			    &cached_state);
>  =20
>   	/*
> -	 * at this point the pages are under IO and we're happy,
> +	 * at this point the folios are under IO and we're happy,
>   	 * The caller is responsible for waiting on them and updating
>   	 * the cache and the inode
>   	 */
>=20

