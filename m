Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A943B38889A
	for <linux-btrfs@vger.kernel.org>; Thu, 14 May 2026 05:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778737360; cv=none; b=KiYatf0T/E0/qcUORXHEqyURD1KwaLjvV9oHb2uQlZcXPPAD1qTT8SrO5KwFtgrWO7C8x+ByVzNY1fsVs13Ww+Dbj1fXrfpQYf3IFiIxS/uQ70Z/I192HGOJqJSJMgLjKCZSNaVe2gipvEYhVBmeyEBUUoh6bSuZNl6ePhkjW0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778737360; c=relaxed/simple;
	bh=EPgrEIywcaHnOz76I1TRttrLZqd/6p7y9qc3CHg43cI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WLbaO7AU2DqunIcMVlXHiYD7CblrXWV1XvajbCgDrNj7xH27lL/E3BDXWo3C30GciHvff7f6U+SsB4vIiw9YH+BLdt4XECofwCdIoXc4XO/XuPVztXngMIVhmHLZcQ16nLBKvRwgEVUppv8AJmecMbQMhLk4p7TrN4OGC0MVsuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oNpZ/2Qx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oNpZ/2Qx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73888C2BCB7;
	Thu, 14 May 2026 05:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778737360;
	bh=EPgrEIywcaHnOz76I1TRttrLZqd/6p7y9qc3CHg43cI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oNpZ/2Qxf1zpCZY+6dD5fYZ48Qw9g7//bzc4d4v1FVopxsSo67GP4A1XPMybEnS/n
	 rfpU7u02Jk46VWZtpO/Xm1nq8EHgLPvlrfVa8vBIl42fVCj5jg0PlRpE2UvLBLUsNQ
	 G4nHYyinf8+Ud1qGXX0jAUKzRyth7Dw4TzRwm5WzgRwK5DXp1sH60+bbcrpw7uqPW2
	 CltU7ehfQHHzaMKlBuOVZsed/ntPhnfIf1qxxJPNXZfms43P57IAnXug5wQaY2zih3
	 sUva2eiKzPjS7jdHRcHh8NK156HKCqkdfJJCdQHBmYDXLwjvnGQfbI4As1oGvfnp5h
	 iZ+Crg9TRaf0Q==
Message-ID: <9a2172a2-3ce8-4719-8795-bc1e02ff86ba@kernel.org>
Date: Thu, 14 May 2026 14:42:32 +0900
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] btrfs: zoned: always set data_relocation_bg
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
 Hans Holmberg <Hans.Holmberg@wdc.com>, Boris Burkov <boris@bur.io>,
 Naohiro Aota <naohiro.aota@wdc.com>, Christoph Hellwig <hch@lst.de>
References: <20260513123445.43197-1-johannes.thumshirn@wdc.com>
 <20260513123445.43197-4-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260513123445.43197-4-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/05/13 21:34, Johannes Thumshirn wrote:
> When searching for a data relocation block-group on mount,
> btrfs_zoned_reserve_data_reloc_bg() is looking for the first empty DATA
> block-group. But it first checks if the block-group is empty and if yes
> continues the search, and then checks if it is the first DATA block-group.
> 
> Reverse the order, first check if it is the first DATA block-group found
> and skip, then check if the block-group is empty. This enusres that there
> is always a DATA block-group set as data_relocation_bg in the filesystem.
> 
> Singed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Doesn't this need a Fixes tag ?

> ---
>  fs/btrfs/zoned.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 16dd87aa06f2..0b80b498fb85 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -2784,14 +2784,14 @@ void btrfs_zoned_reserve_data_reloc_bg(struct btrfs_fs_info *fs_info)
>  again:
>  	bg_list = &space_info->block_groups[index];
>  	list_for_each_entry(bg, bg_list, list) {
> -		if (bg->alloc_offset != 0)
> -			continue;
> -
>  		if (first) {
>  			first = false;
>  			continue;
>  		}
>  
> +		if (bg->alloc_offset != 0)
> +			continue;
> +
>  		if (space_info == data_sinfo) {
>  			/* Migrate the block group to the data relocation space_info. */
>  			struct btrfs_space_info *reloc_sinfo = data_sinfo->sub_group[0];


-- 
Damien Le Moal
Western Digital Research
