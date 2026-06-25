Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797C53101B9
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 23:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782428607; cv=none; b=ItHv3X07gkrNWJOMJHY6O9GtjDiiM9wqywmegAcvVkUzZOEKQRm0/unZSla2UnBMscNnFcv3TVisuznzwb0TpWxsg2L95QtORaGhnhq7pt+A/6XUwZPhV4w4vX4Gloy+N08ENT6UXcf6Rl90qTh/PM9JmL04sykzvu4JJwcHD6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782428607; c=relaxed/simple;
	bh=UQKgRoFjyOpIY6uBWHwmMspLpnTBwovqxNvKjSGgxA4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=nbbqPrx1PYRcr//AuM+FfwWf4CzKatw6OlO+oUkKCuGTduqFbPqAWg3qssbR4AmdtN8Sk8LXAvkUF9tMBG75VoBQLhcabsnh7aKORi8o/YDArpkERy73JLW8LuDfuXpX0iw6sUVwAhVjrzW54SdOHrsvPdp8aP8rYxK7VxZ34T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q79bJj4b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q79bJj4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E771F000E9;
	Thu, 25 Jun 2026 23:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782428606;
	bh=nEqqefD4yPVpD3tdjvGQ58sjwEOKpEkzMAERLa/NsMM=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=Q79bJj4bkoo/PqTzEVkD/EEtcxMkpxIEEA/WbwL6WZApF40fR89gAQ6fTjF3wJ/H9
	 /zZqSR057coxffXJaraBv6/HCUNzTcfTFCc4URuyfRf5lhxAvt3wVBr12pWPnbhw99
	 +lJNIdhfUs5/rkiT2QiaByF03dgCgxfKFeKRa1VF2LNBVvGQHedixqQ4nIr8mTKr+/
	 KUTTI98XTiKVXdoKh8qHy50Lkg9DedBCPmF9R95o/Ju54mB0qMkiULhaF8nNXBiev5
	 rIwQCEzhoN0Cn4QbmnWDqQCXBZqmcoirYkKmfcXA/17jMt6A0DuhqAmlZA4FThlyRf
	 OuRrOry266r1w==
Message-ID: <00642b09-55d8-49bc-a1a4-af65b2172bbf@kernel.org>
Date: Fri, 26 Jun 2026 07:03:23 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] btrfs: defrag: remove pointless list_del_init() in
 defrag_one_cluster()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <cover.1782321584.git.fdmanana@suse.com>
 <d8b39c1c786efa00d5de3d5ca999e23fcbc6c277.1782321584.git.fdmanana@suse.com>
Content-Language: en-US
From: Anand Suveer Jain <asj@kernel.org>
In-Reply-To: <d8b39c1c786efa00d5de3d5ca999e23fcbc6c277.1782321584.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 26/6/26 03:20, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> There's no need to call list_del_init() against each entry when freeing
> the list, as the list is local and we are freeing the entry.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/defrag.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
> index 7b3f779775a0..6ec5dd760d42 100644
> --- a/fs/btrfs/defrag.c
> +++ b/fs/btrfs/defrag.c
> @@ -1319,10 +1319,8 @@ static int defrag_one_cluster(struct btrfs_inode *inode,
>  				      inode->root->fs_info->sectorsize_bits;
>  	}
>  out:
> -	list_for_each_entry_safe(entry, tmp, &target_list, list) {
> -		list_del_init(&entry->list);
> +	list_for_each_entry_safe(entry, tmp, &target_list, list)
>  		kfree(entry);
> -	}
>  	if (ret >= 0)
>  		*last_scanned_ret = max(*last_scanned_ret, start + len);
>  	return ret;

LGTM
Reviewed-by: Anand Jain <asj@kernel.org>


