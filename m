Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CAA3AF64B
	for <linux-btrfs@vger.kernel.org>; Thu, 14 May 2026 05:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778737420; cv=none; b=Plyhqt+mTc93t0ZYlcCvP7/ECUZUXo2asGJq+L/A3kxJfiOdcHrXJruQE9EWf8CjuB05htvZAYIgqIXVp1dtzvzrC5jDGo6frQnoKe0FuPmJeib8b9MzV5VJfvcO3k4LiScYDWFeYBnOqRD3PX44zlhqCpvmtyyf/E4uq5/jLTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778737420; c=relaxed/simple;
	bh=U9r8C8y+h33wPVpFwXiDljqpKV544BmzyMi8+iaolQw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t8i8vWOMZTyC5G4eTrOPVqNIyLkGfMxzLtNaON86Dcd0FVGwBOYxUbxbn+piNuOUyAhwvY7/SHF7/RALYsudP6fFaj+FeMQjRJ6OyHE0C/xpMgralFT8zPGFulXxEyMcbpLz2GXc7TeDVdniD55yvIdYPp3GbWC+qN2s3LK27AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YrZwoSDK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YrZwoSDK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12773C2BCB7;
	Thu, 14 May 2026 05:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778737420;
	bh=U9r8C8y+h33wPVpFwXiDljqpKV544BmzyMi8+iaolQw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YrZwoSDKynIrwr9eVhL4xXxjquyUhAYgNmf/Eiifr1yX989QUOxEkaOpssvS0/P5s
	 gK1/zxi+sPmqJlr2hCLeUcN0IDqmcPfBzsWwy+RTe8JNvA4BbFBZJmcF9SVb3WCrO2
	 cZBATfg5GsAa/SK4DxyGog9WnYN9jcTzT/nSk2XkcnaPe/AtkyoPvDGhJgJe+1FlhM
	 l8kHiIw+YO4Ti3Ri/O20YfZYHywMNZUK6PjwBy8Z3G4Nnagt5yHEPHkITtxK6qGjtl
	 pD3D9MYR1LPuKzYPBUrtTPtWCwcm3X43iQn7ACV6ebm3w3i4hCIv0AAzKpGWM5giJC
	 ASG3FHM+Qx+dA==
Message-ID: <1bb07853-a52e-4eff-b7b7-5cb8d0b9c8db@kernel.org>
Date: Thu, 14 May 2026 14:43:31 +0900
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] btrfs: zoned: subtract zone_unusable space in statfs
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
 Hans Holmberg <Hans.Holmberg@wdc.com>, Boris Burkov <boris@bur.io>,
 Naohiro Aota <naohiro.aota@wdc.com>, Christoph Hellwig <hch@lst.de>
References: <20260513123445.43197-1-johannes.thumshirn@wdc.com>
 <20260513123445.43197-6-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260513123445.43197-6-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/05/13 21:34, Johannes Thumshirn wrote:
> On zoned filesystems, space in block groups that has been freed but not
> yet reset is tracked in bytes_zone_unusable. This space cannot be used for
> new allocations until zone reclaim resets the zones, but it was being
> reported as available space in statfs.
> 
> This caused statfs to over-report free space, leading to ENOSPC errors
> when applications tried to allocate based on the reported free space.
> 
> Fix this by subtracting bytes_zone_unusable from total_free_data in the
> statfs calculation for zoned filesystems.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Fixes tag here as well ? and same for the following patch.

> ---
>  fs/btrfs/super.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index a0dbc0d2213f..498aa3039fbe 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1752,6 +1752,8 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>  					factor = btrfs_bg_type_to_factor(
>  						btrfs_raid_array[i].bg_flag);
>  			}
> +
> +			total_free_data -= found->bytes_zone_unusable * factor;
>  		}
>  
>  		/*


-- 
Damien Le Moal
Western Digital Research
