Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C3036404D;
	Mon, 30 Mar 2026 21:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774905757; cv=none; b=audC43BU/1kzHHMlzNiEFZ0vtWR+QDWEtB/Brj2nsklg/vq0sHuZmY6D3ng7VPO/7AvCn70Zx+h8TzoPJ1ZzI92tRk5RMlpRIRItrtA7lLsLPXeIpQ5xaHKiHgj/7EAvorGgsTViOHbnwqsMy6cC9OsabieJ4BDtFGRMJb8YPvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774905757; c=relaxed/simple;
	bh=9jPjcvkin1+8l+oP2Ff2kW7Y7V9Q4Vb8UrCKkSwHwuo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PWNySRZeVR+CivYerTT2lKg+g3Ex8PZi374+2KWb848+6z9xjsbuQj0CoOUyrjoEMbwBE79lQOB0dP4YdRbSw7dKRYUrMXXeuBKpDG5+vqdzd5WR4GrMSPpABluHMb8JdVmcdTGqVL0+ObfsIQNGKMvmsihR2LpFnwypy7JA4HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com; spf=pass smtp.mailfrom=gmx.com; dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b=NVNwrUMP; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.com header.i=quwenruo.btrfs@gmx.com header.b="NVNwrUMP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.com;
	s=s31663417; t=1774905746; x=1775510546; i=quwenruo.btrfs@gmx.com;
	bh=LyqTvIlhcYoWhhHis9MXJdW4MzKLIpVouPp9+9NIH5k=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=NVNwrUMPeVNUC71cLK3ooR7yCD1PpPgmVbkwq7jfU8OeBBh1qd9bT26+EHnvNecZ
	 ohflJ4ITTtUuTF251QgIdaorexscGmVYQUlU1b675OW52M9asNfYD8rRYv6TbEkSO
	 XJDBZasL8ax0vGPteEsN2EK1AComf6qLxa4zL92jOj9PjjD7MWQ5ay8Zc69U72Gm+
	 9AsBgRfom9jvmKMePvuhVUkHjIkYVaES0+XRM3VTlBgjanB3SryQ8zGHux4bRKXV0
	 Mywfzi9MdQsweZkv8wlN2H7iogwQclofusTZl+m+pLLnDPeotowWhUBm5JIjXWbvV
	 j7P3QarqCD3qBVHiig==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1N7QxL-1vSfgF0KB3-0115p8; Mon, 30
 Mar 2026 23:22:26 +0200
Message-ID: <9fd974c2-00aa-4906-8cab-ec0d85750c4b@gmx.com>
Date: Tue, 31 Mar 2026 07:52:19 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND PATCH v2] btrfs: prevent direct reclaim during compressed
 readahead
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>, mark@harmstone.com,
 boris@bur.io, wqu@suse.com, dsterba@suse.com, clm@fb.com,
 linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-team@meta.com
References: <20260328214619.114790-1-jp.kobryn@linux.dev>
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
In-Reply-To: <20260328214619.114790-1-jp.kobryn@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:JDJm3HjM4VwUeUw2ZINJDaKAP2nfctM1yUZINAwYAeOcqnlABcY
 htbCRe2ouWIA88pFTSu1J217ctAwKLEAo7seKF2f1oYmp3oBrEJDtnYvYYlfrihQUODHtJ9
 xsDZpno/RQ1Cniemd9zhBgyQpv/YCEarjBgBY0He/VJE2nef8xQJM3Z40+Cyf44hZ2Z8bVh
 6sjKfOMv87nDbCYsM0PUg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:g2VX/NgRfos=;9ek79ptGhkCiCoCh7I/RLLqiOcw
 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



=E5=9C=A8 2026/3/29 08:16, JP Kobryn (Meta) =E5=86=99=E9=81=93:
> Under memory pressure, direct reclaim can kick in during compressed
> readahead. This puts the associated task into D-state. Then shrink_lruve=
c()
> disables interrupts when acquiring the LRU lock. Under heavy pressure,
> we've observed reclaim can run long enough that the CPU becomes prone to
> CSD lock stalls since it cannot service incoming IPIs. Although the CSD
> lock stalls are the worst case scenario, we have found many more subtle
> occurrences of this latency on the order of seconds, over a minute in so=
me
> cases.
>=20
> Prevent direct reclaim during compressed readahead. This is achieved by
> using different GFP flags at key points when the bio is marked for
> readahead.
>=20
> There are two functions that allocate during compressed readahead:
> btrfs_alloc_compr_folio() and add_ra_bio_pages(). Both currently use
> GFP_NOFS which includes __GFP_DIRECT_RECLAIM.
>=20
> For the internal API call btrfs_alloc_compr_folio(), the signature chang=
es
> to accept an additional gfp_t parameter. At the readahead call site, it
> gets flags similar to GFP_NOFS but stripped of __GFP_DIRECT_RECLAIM.
> __GFP_NOWARN is added since these allocations are allowed to fail. Deman=
d
> reads still use full GFP_NOFS and will enter reclaim if needed. All othe=
r
> existing call sites of btrfs_alloc_compr_folio() now explicitly pass
> GFP_NOFS to retain their current behavior.
>=20
> add_ra_bio_pages() gains a bool parameter which allows callers to specif=
y
> if they want to allow direct reclaim or not. In either case, the
> __GFP_NOWARN flag was added unconditionally since the allocations are
> speculative.
>=20
> There has been some previous work done on calling add_ra_bio_pages() [0]=
.
> This patch is complementary: where that patch reduces call frequency, th=
is
> patch reduces the latency associated with those calls.
>=20
> [0] https://lore.kernel.org/linux-btrfs/656838ec1232314a2657716e59f4f15a=
8eadba64.1751492111.git.boris@bur.io/
>=20
> Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
> Reviewed-by: Mark Harmstone <mark@harmstone.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> v2:
>   - dropped patch 1/2, squashed into single patch based on David's feedb=
ack
>   - changed btrfs_alloc_compr_folio() signature instead of new _gfp vari=
ant
>   - update other existing callers to pass GFP_NOFS explicitly
>=20
> v1: https://lore.kernel.org/linux-btrfs/20260320073445.80218-1-jp.kobryn=
@linux.dev/
>=20
>   fs/btrfs/compression.c | 42 +++++++++++++++++++++++++++++++++++-------
>   fs/btrfs/compression.h |  2 +-
>   fs/btrfs/inode.c       |  2 +-
>   fs/btrfs/lzo.c         |  6 +++---
>   fs/btrfs/zlib.c        |  6 +++---
>   fs/btrfs/zstd.c        |  6 +++---
>   6 files changed, 46 insertions(+), 18 deletions(-)
>=20
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index e897342bece1f..8f33ef48b501e 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -180,7 +180,7 @@ static unsigned long btrfs_compr_pool_scan(struct sh=
rinker *sh, struct shrink_co
>   /*
>    * Common wrappers for page allocation from compression wrappers
>    */
> -struct folio *btrfs_alloc_compr_folio(struct btrfs_fs_info *fs_info)
> +struct folio *btrfs_alloc_compr_folio(struct btrfs_fs_info *fs_info, gf=
p_t gfp)
>   {
>   	struct folio *folio =3D NULL;
>  =20
> @@ -200,7 +200,7 @@ struct folio *btrfs_alloc_compr_folio(struct btrfs_f=
s_info *fs_info)
>   		return folio;
>  =20
>   alloc:
> -	return folio_alloc(GFP_NOFS, fs_info->block_min_order);
> +	return folio_alloc(gfp, fs_info->block_min_order);
>   }
>  =20
>   void btrfs_free_compr_folio(struct folio *folio)
> @@ -368,7 +368,8 @@ struct compressed_bio *btrfs_alloc_compressed_write(=
struct btrfs_inode *inode,
>   static noinline int add_ra_bio_pages(struct inode *inode,
>   				     u64 compressed_end,
>   				     struct compressed_bio *cb,
> -				     int *memstall, unsigned long *pflags)
> +				     int *memstall, unsigned long *pflags,
> +				     bool direct_reclaim)
>   {
>   	struct btrfs_fs_info *fs_info =3D inode_to_fs_info(inode);
>   	pgoff_t end_index;
> @@ -376,6 +377,7 @@ static noinline int add_ra_bio_pages(struct inode *i=
node,
>   	u64 cur =3D cb->orig_bbio->file_offset + orig_bio->bi_iter.bi_size;
>   	u64 isize =3D i_size_read(inode);
>   	int ret;
> +	gfp_t constraint_gfp, cache_gfp;
>   	struct folio *folio;
>   	struct extent_map *em;
>   	struct address_space *mapping =3D inode->i_mapping;
> @@ -405,6 +407,19 @@ static noinline int add_ra_bio_pages(struct inode *=
inode,
>  =20
>   	end_index =3D (i_size_read(inode) - 1) >> PAGE_SHIFT;
>  =20
> +	/*
> +	 * Avoid direct reclaim when the caller does not allow it.
> +	 * Since add_ra_bio_pages is always speculative, suppress
> +	 * allocation warnings in either case.
> +	 */
> +	if (!direct_reclaim) {
> +		constraint_gfp =3D ~(__GFP_FS | __GFP_DIRECT_RECLAIM);
> +		cache_gfp =3D (GFP_NOFS & ~__GFP_DIRECT_RECLAIM) | __GFP_NOWARN;
> +	} else {
> +		constraint_gfp =3D ~__GFP_FS;
> +		cache_gfp =3D GFP_NOFS | __GFP_NOWARN;
> +	}
> +
>   	while (cur < compressed_end) {
>   		pgoff_t page_end;
>   		pgoff_t pg_index =3D cur >> PAGE_SHIFT;
> @@ -434,12 +449,13 @@ static noinline int add_ra_bio_pages(struct inode =
*inode,
>   			continue;
>   		}
>  =20
> -		folio =3D filemap_alloc_folio(mapping_gfp_constraint(mapping, ~__GFP_=
FS),
> +		folio =3D filemap_alloc_folio(mapping_gfp_constraint(mapping,
> +					    constraint_gfp) | __GFP_NOWARN,
>   					    0, NULL);
>   		if (!folio)
>   			break;
>  =20
> -		if (filemap_add_folio(mapping, folio, pg_index, GFP_NOFS)) {
> +		if (filemap_add_folio(mapping, folio, pg_index, cache_gfp)) {
>   			/* There is already a page, skip to page end */
>   			cur +=3D folio_size(folio);
>   			folio_put(folio);
> @@ -532,6 +548,7 @@ void btrfs_submit_compressed_read(struct btrfs_bio *=
bbio)
>   	unsigned int compressed_len;
>   	const u32 min_folio_size =3D btrfs_min_folio_size(fs_info);
>   	u64 file_offset =3D bbio->file_offset;
> +	gfp_t gfp;
>   	u64 em_len;
>   	u64 em_start;
>   	struct extent_map *em;
> @@ -539,6 +556,17 @@ void btrfs_submit_compressed_read(struct btrfs_bio =
*bbio)
>   	int memstall =3D 0;
>   	int ret;
>  =20
> +	/*
> +	 * If this is a readahead bio, prevent direct reclaim. This is done to
> +	 * avoid stalling on speculative allocations when memory pressure is
> +	 * high. The demand fault will retry with GFP_NOFS and enter direct
> +	 * reclaim if needed.
> +	 */
> +	if (bbio->bio.bi_opf & REQ_RAHEAD)
> +		gfp =3D (GFP_NOFS & ~__GFP_DIRECT_RECLAIM) | __GFP_NOWARN;
> +	else
> +		gfp =3D GFP_NOFS;
> +
>   	/* we need the actual starting offset of this extent in the file */
>   	read_lock(&em_tree->lock);
>   	em =3D btrfs_lookup_extent_mapping(em_tree, file_offset, fs_info->sec=
torsize);
> @@ -569,7 +597,7 @@ void btrfs_submit_compressed_read(struct btrfs_bio *=
bbio)
>   		struct folio *folio;
>   		u32 cur_len =3D min(compressed_len - i * min_folio_size, min_folio_s=
ize);
>  =20
> -		folio =3D btrfs_alloc_compr_folio(fs_info);
> +		folio =3D btrfs_alloc_compr_folio(fs_info, gfp);
>   		if (!folio) {
>   			ret =3D -ENOMEM;
>   			goto out_free_bio;
> @@ -585,7 +613,7 @@ void btrfs_submit_compressed_read(struct btrfs_bio *=
bbio)
>   	ASSERT(cb->bbio.bio.bi_iter.bi_size =3D=3D compressed_len);
>  =20
>   	add_ra_bio_pages(&inode->vfs_inode, em_start + em_len, cb, &memstall,
> -			 &pflags);
> +			 &pflags, !(bbio->bio.bi_opf & REQ_RAHEAD));
>  =20
>   	cb->len =3D bbio->bio.bi_iter.bi_size;
>   	cb->bbio.bio.bi_iter.bi_sector =3D bbio->bio.bi_iter.bi_sector;
> diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
> index 973530e9ce6c2..1022dc53ec51e 100644
> --- a/fs/btrfs/compression.h
> +++ b/fs/btrfs/compression.h
> @@ -98,7 +98,7 @@ void btrfs_submit_compressed_read(struct btrfs_bio *bb=
io);
>  =20
>   int btrfs_compress_str2level(unsigned int type, const char *str, int *=
level_ret);
>  =20
> -struct folio *btrfs_alloc_compr_folio(struct btrfs_fs_info *fs_info);
> +struct folio *btrfs_alloc_compr_folio(struct btrfs_fs_info *fs_info, gf=
p_t gfp);
>   void btrfs_free_compr_folio(struct folio *folio);
>  =20
>   struct workspace_manager {
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 8d97a8ad3858b..2d2fce77aec21 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -9980,7 +9980,7 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb,=
 struct iov_iter *from,
>   		size_t bytes =3D min(min_folio_size, iov_iter_count(from));
>   		char *kaddr;
>  =20
> -		folio =3D btrfs_alloc_compr_folio(fs_info);
> +		folio =3D btrfs_alloc_compr_folio(fs_info, GFP_NOFS);
>   		if (!folio) {
>   			ret =3D -ENOMEM;
>   			goto out_cb;
> diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
> index 0c90937707395..4662c5c06eae9 100644
> --- a/fs/btrfs/lzo.c
> +++ b/fs/btrfs/lzo.c
> @@ -218,7 +218,7 @@ static int copy_compressed_data_to_bio(struct btrfs_=
fs_info *fs_info,
>   	ASSERT((old_size >> sectorsize_bits) =3D=3D (old_size + LZO_LEN - 1) =
>> sectorsize_bits);
>  =20
>   	if (!*out_folio) {
> -		*out_folio =3D btrfs_alloc_compr_folio(fs_info);
> +		*out_folio =3D btrfs_alloc_compr_folio(fs_info, GFP_NOFS);
>   		if (!*out_folio)
>   			return -ENOMEM;
>   	}
> @@ -245,7 +245,7 @@ static int copy_compressed_data_to_bio(struct btrfs_=
fs_info *fs_info,
>   			return -E2BIG;
>  =20
>   		if (!*out_folio) {
> -			*out_folio =3D btrfs_alloc_compr_folio(fs_info);
> +			*out_folio =3D btrfs_alloc_compr_folio(fs_info, GFP_NOFS);
>   			if (!*out_folio)
>   				return -ENOMEM;
>   		}
> @@ -296,7 +296,7 @@ int lzo_compress_bio(struct list_head *ws, struct co=
mpressed_bio *cb)
>   	ASSERT(bio->bi_iter.bi_size =3D=3D 0);
>   	ASSERT(len);
>  =20
> -	folio_out =3D btrfs_alloc_compr_folio(fs_info);
> +	folio_out =3D btrfs_alloc_compr_folio(fs_info, GFP_NOFS);
>   	if (!folio_out)
>   		return -ENOMEM;
>  =20
> diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
> index 147c92a4dd04c..145ead5be1c06 100644
> --- a/fs/btrfs/zlib.c
> +++ b/fs/btrfs/zlib.c
> @@ -175,7 +175,7 @@ int zlib_compress_bio(struct list_head *ws, struct c=
ompressed_bio *cb)
>   	workspace->strm.total_in =3D 0;
>   	workspace->strm.total_out =3D 0;
>  =20
> -	out_folio =3D btrfs_alloc_compr_folio(fs_info);
> +	out_folio =3D btrfs_alloc_compr_folio(fs_info, GFP_NOFS);
>   	if (out_folio =3D=3D NULL) {
>   		ret =3D -ENOMEM;
>   		goto out;
> @@ -258,7 +258,7 @@ int zlib_compress_bio(struct list_head *ws, struct c=
ompressed_bio *cb)
>   				goto out;
>   			}
>  =20
> -			out_folio =3D btrfs_alloc_compr_folio(fs_info);
> +			out_folio =3D btrfs_alloc_compr_folio(fs_info, GFP_NOFS);
>   			if (out_folio =3D=3D NULL) {
>   				ret =3D -ENOMEM;
>   				goto out;
> @@ -296,7 +296,7 @@ int zlib_compress_bio(struct list_head *ws, struct c=
ompressed_bio *cb)
>   				goto out;
>   			}
>   			/* Get another folio for the stream end. */
> -			out_folio =3D btrfs_alloc_compr_folio(fs_info);
> +			out_folio =3D btrfs_alloc_compr_folio(fs_info, GFP_NOFS);
>   			if (out_folio =3D=3D NULL) {
>   				ret =3D -ENOMEM;
>   				goto out;
> diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
> index 41547ff187f65..080b29fe515c6 100644
> --- a/fs/btrfs/zstd.c
> +++ b/fs/btrfs/zstd.c
> @@ -439,7 +439,7 @@ int zstd_compress_bio(struct list_head *ws, struct c=
ompressed_bio *cb)
>   	workspace->in_buf.size =3D btrfs_calc_input_length(in_folio, end, sta=
rt);
>  =20
>   	/* Allocate and map in the output buffer. */
> -	out_folio =3D btrfs_alloc_compr_folio(fs_info);
> +	out_folio =3D btrfs_alloc_compr_folio(fs_info, GFP_NOFS);
>   	if (out_folio =3D=3D NULL) {
>   		ret =3D -ENOMEM;
>   		goto out;
> @@ -482,7 +482,7 @@ int zstd_compress_bio(struct list_head *ws, struct c=
ompressed_bio *cb)
>   				goto out;
>   			}
>  =20
> -			out_folio =3D btrfs_alloc_compr_folio(fs_info);
> +			out_folio =3D btrfs_alloc_compr_folio(fs_info, GFP_NOFS);
>   			if (out_folio =3D=3D NULL) {
>   				ret =3D -ENOMEM;
>   				goto out;
> @@ -555,7 +555,7 @@ int zstd_compress_bio(struct list_head *ws, struct c=
ompressed_bio *cb)
>   			ret =3D -E2BIG;
>   			goto out;
>   		}
> -		out_folio =3D btrfs_alloc_compr_folio(fs_info);
> +		out_folio =3D btrfs_alloc_compr_folio(fs_info, GFP_NOFS);
>   		if (out_folio =3D=3D NULL) {
>   			ret =3D -ENOMEM;
>   			goto out;

