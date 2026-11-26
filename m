Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795728357;
	b=H4LAJeNKj8BL/AbxA3SAAC+IMO6WbVyf4xaJEah52uUtHqjFKprAlN2ajeydOeYzW2+H
	 WCqqadmKq/XvvlrH7fzecRhw44FYVnQaB68hi27/eaN/LXzXww7gn151gGrkyK1T0Kzce
	 CJ0QPAALqdw3JuFG92MNpk8UgsGI5IvcByHvK5I5mNh78I7DyrBiplpqEe9gOu5pdeJF3
	 VLpVHtKF73rtiyP+gq9uHnM7mHHD7pglKLc+WcZoZehyG+yT7ZfoQqpkhbp/50b8RhocJ
	 WtLBwR18cCKC+l1cj9AgFZAsgxknDDNxUIh7IZzKfRk3abbJJI0c3vaNjHA0ea6Q1bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795728357;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Organization:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=HRDsEiEAnesJINkfs0nsw0PAkaBedzFdr2SHdMIRMfk=;
	b=GRW1sKjM+tkRJGz4ihUqJIA0o4HjEfxIyD+d9WB6ZDaAnYYRbRDsH3XffocHNGt35JYf
	 zy3xYQVOaFxx+hPQwon7C+ndn/JzfOHpntIdzZZ9AOLXd0QhFIzjs4HQRHTa17iRB8EVM
	 nq4GuMIADIJlombNOKmttEs+aTK9r+WR9fjpa8MUqoky2DMCaOa3xOA2SNRJTUBKaws05
	 YBnTYvKl79BFllGfzjUWx3AIkXKAGSnK6nnyIz6cxUIyzSAHgPE7bGMR5QUWLI3wYuXks
	 STp1C9g9n9/v5RQxCRvOCE0IxmQTZ3OFMGcK17UHZzLkuN/3rRX65elORO2W7N2nVuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jsL8rMUZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03E5606A31E
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 21:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jsL8rMUZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257B11F00893;
	Thu, 26 Nov 2026 21:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795728357;
	bh=HRDsEiEAnesJINkfs0nsw0PAkaBedzFdr2SHdMIRMfk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jsL8rMUZJOmGC4D1DFVgspkNxYCxePkcXfQpLrXDSzSE09C5YXZUc7CTZ6tsBlL/H
	 hH4NGHjj96YY43+QygWIbDoXlxZQYbDOqOlWd2waWI48kJm3APdBzK4jvf1n/iSakm
	 Ki0xNbEzKZH85Y4Pnk+7k6/TzlOwr/x9au/6ht22CknT8ajgyg6QGAqkHGo8bkL5rV
	 xEb5XE9jrqsliHNQzyP8Dnazfn3CjyKAgwvU9pKLZb5EquvN4xUMMqyA1yekoPh8Mx
	 mppoQ6A55bodQA7ek5ZvxpY5UDxl62KPHwBruG2IDuQ9ONm3ppFwJCID1BQFJWm4zz
	 4Hcmnab0L96og==
Message-ID: <27d2151f-7806-4bdd-9bfc-3107a04bf0d6@kernel.org>
Date: Fri, 27 Nov 2026 06:25:54 +0900
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] btrfs: zoned: try to fill hinted block-groups
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Hans Holmberg <Hans.Holmberg@wdc.com>,
 Naohiro Aota <naohiro.aota@wdc.com>, Josef Bacik <josef@toxicpanda.com>,
 Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
 Boris Burkov <boris@bur.io>, Qu Wenruo <wqu@suse.com>,
 Wilfred Mallawa <wilfred.opensource@gmail.com>
References: <20261126132820.570379-1-johannes.thumshirn@wdc.com>
 <20261126132820.570379-5-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20261126132820.570379-5-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/26/26 22:28, Johannes Thumshirn wrote:
> If the hinted block-group has less space left than the allocation, the
> allocation goes to a new block-group and the old one stays active with
> its leftover. With buffered writes this happens for nearly every
> block-group, the leftovers use up the active zones and new files fall
> back to round-robin.
> 
> Shrink the allocation to the space left in the hinted block-group
> instead, as long as it is not smaller than min_alloc_size. The
> block-group becomes full, gets finished and releases its active zone.
> 
> 5 parallel buffered writers on null_blk, 64M zones, max 12 active zones:
> files per zone 3.09 -> 1.46, extents per file 29.6 -> 5.8.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

One nit below. Otherwise looks good to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

> ---
>  fs/btrfs/extent-tree.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 7169f296a523..d8dc43655b16 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4526,8 +4526,23 @@ static int prepare_allocation_zoned(struct btrfs_fs_info *fs_info,
>  					&block_group->runtime_flags))
>  			continue;
>  
> -		if (avail < ffe_ctl->num_bytes)
> +		/*
> +		 * If we have less space available in the block-group but can
> +		 * fit the allocation into the hinted block-group if we shrink
> +		 * it, fill up the block-group.
> +		 */
> +		if (avail < ffe_ctl->num_bytes) {
> +			avail = round_down(avail, fs_info->sectorsize);
> +			if (avail >= ffe_ctl->min_alloc_size &&
> +			    in_range(ffe_ctl->hint_byte, block_group->start,
> +				     block_group->length)) {

This in_range() call is being repeated. It feels like an inline wrapper for it
would be nice. E.g. something like:

	bg_contains_byte(block_group, ffe_ctl->hint_byte)


> +				if (ffe_ctl->ram_bytes == ffe_ctl->num_bytes)
> +					ffe_ctl->ram_bytes = avail;
> +				ffe_ctl->num_bytes = avail;
> +				break;
> +			}
>  			continue;
> +		}
>  
>  		/*
>  		 * Remember the first block-group that fits the allocation. Then


-- 
Damien Le Moal
Western Digital Research
