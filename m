Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B33390229
	for <linux-btrfs@vger.kernel.org>; Thu, 14 May 2026 05:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778737385; cv=none; b=gVmiITfoOmmdc+r+06UWJNUAbZuGfuRPt08BOOgYxoigeFNlzhLMquWExKTOqm+4UVcljhoLvFHLjPF0udim+t+sZRDGNNfr2XIPamG8ZOXUTr0Gf5rbEOs2AGrdlKYqewgRGnWHBixOadkYTjPH6oNn4V1Obr0FAjZfrTQqYL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778737385; c=relaxed/simple;
	bh=sWG620i9qMrnr1EnBqFhfe3GA4VPV1arNM/TrNvc3KI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eoZKwiqCS38BN8i2Grn05fS+2MiWqQAUuFlfFZx6loylqtkAe1KQ/arJVNY1j/f09chrF5Yo2vnwyH9IWkhJTRJWjZuVx88CoCzlhs2ZHUMKsET4ZYvmO+2Taw2tvJxhb8ecEgqR4ewB7wgMV1E3tIn17oNs4Q3YxISW6cx+CgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WqrQ8CIC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WqrQ8CIC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C07C2BCB7;
	Thu, 14 May 2026 05:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778737384;
	bh=sWG620i9qMrnr1EnBqFhfe3GA4VPV1arNM/TrNvc3KI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WqrQ8CICY00LA+Q5LDNrv2cAs53140hhVjUNZj8ItYPoP1ZHCP1DENgj03RH3GOd/
	 IXqlZIv9A+B99G4ocXJfIJEHqK32W7+r0m+wePwDK6ajlnD5ksTOHWgLOW1JWXnmDr
	 r9i2V+8Uwoy+onAP4Oqcm7PNnl//fTqckGqSNJ60pLjldnn5FIHzM/PF0/9arcMdXF
	 +rq61Jm6X2fQlUPwOx1BTOSOapOCsr4RNYJ69ZD4Vhjhwjye5oTXpNWH4958uMQTEW
	 k79hVzVasY4zgDAVmLDW0lZ7fFjxVhd9Y+We5cMppNk5LPZGHR2hqZW9vOKfGqppzB
	 IGwMzfnoZWC/g==
Message-ID: <7c6a6b6d-a023-47e8-b27e-1c45929e0fc3@kernel.org>
Date: Thu, 14 May 2026 14:42:56 +0900
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] btrfs: zoned: don't account data relocation
 space-info in statfs free space
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
 Hans Holmberg <Hans.Holmberg@wdc.com>, Boris Burkov <boris@bur.io>,
 Naohiro Aota <naohiro.aota@wdc.com>, Christoph Hellwig <hch@lst.de>
References: <20260513123445.43197-1-johannes.thumshirn@wdc.com>
 <20260513123445.43197-5-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260513123445.43197-5-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/05/13 21:34, Johannes Thumshirn wrote:
> Don't account the free space in a data relocation space-info sub-group as
> usable free space in statfs.
> 
> This is misleading as no user allocations can be made in this space-info
> sub-group. It is only a target for relocation.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

It feels like this one also needs a Fixes tag...

> ---
>  fs/btrfs/super.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index fb15decb0861..a0dbc0d2213f 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1739,7 +1739,8 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>  	int mixed = 0;
>  
>  	list_for_each_entry(found, &fs_info->space_info, list) {
> -		if (found->flags & BTRFS_BLOCK_GROUP_DATA) {
> +		if (found->flags & BTRFS_BLOCK_GROUP_DATA &&
> +		    found->subgroup_id != BTRFS_SUB_GROUP_DATA_RELOC) {
>  			int i;
>  
>  			total_free_data += found->disk_total - found->disk_used;


-- 
Damien Le Moal
Western Digital Research
