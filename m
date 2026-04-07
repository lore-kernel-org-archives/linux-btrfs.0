Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBAC33D503;
	Tue,  7 Apr 2026 16:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775580102; cv=none; b=FIhQNbgAopTJ4ULi71DVMqABlfjHAhYCnY8/imAErVmV5HAgm6b0Jg2K7GDw8g0DTp2XP9uOY5dIWNQ6aRH/6nfiyBrvn5rIDNuA4k6YuZe9Xw0PyDT8bYZHWvFxy03vjTlfCAcw+XeqMrBJwCf3bqc4Npv5Fu/DycaEdNFkXUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775580102; c=relaxed/simple;
	bh=WNeYBHR4gj7HbvRJA/umEbGwIrHaVkF/qsWTpaR3ngo=;
	h=Message-ID:Date:Mime-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E/D42i1m/hBlP15628YUClRPKLadBTNAOLVjvXapVjwVv3yf7zYWmI5/+nzDkT4VCjd1RryiFP2QaP3WuLySckQkffGFvWnMW5ZLPq2RAB4IISIteIW7BklWRHiC1JJEsACg4OKHw0wq3E4kiWGt90IiHqrFkQlKrluNacybneY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=Ou3iTtgd; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="Ou3iTtgd"
Received: from [IPV6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2] (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
	 client-signature RSA-PSS (2048 bits) client-digest SHA256)
	(Client CN "hellas", Issuer "burntcomma.com" (verified OK))
	by mail.burntcomma.com (Postfix) with ESMTPS id 27B0731A3D6;
	Tue,  7 Apr 2026 17:41:38 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1775580098;
	bh=fJgRtw3kQaVYssGz5/5rVHWommRknDPCg3d4iNmUAVM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ou3iTtgdTlde3apgGjWjT/RMSM3CWxqhI137JaNkNLjsXfGduI9kXaUg/MQCc78yu
	 1u2YCW2z8n6qPFR8YCPQPI8/WpxX4i+nqluGoTdpGWPqK01qsU0jlcIbHDvoWzABYS
	 JzLjAgIO183p00z6zKhS36XIrw2MyqosXeSjP0VQ=
Message-ID: <234dff5a-598d-4b8c-8874-786689cad127@harmstone.com>
Date: Tue, 7 Apr 2026 17:41:38 +0100
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: Re: [PATCH] btrfs: fix silent IO error loss in encoded writes and
 zoned split
To: Michal Grzedzicki <mge@meta.com>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
References: <20260330160644.3678224-1-mge@meta.com>
Content-Language: en-US
From: Mark Harmstone <mark@harmstone.com>
Autocrypt: addr=mark@harmstone.com; keydata=
 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
In-Reply-To: <20260330160644.3678224-1-mge@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Reviewed-by: Mark Harmstone <mark@harmstone.com>

On 30/03/2026 5.06 pm, Michal Grzedzicki wrote:
> can_finish_ordered_extent() and btrfs_finish_ordered_zoned() set
> BTRFS_ORDERED_IOERR via bare set_bit(). Later,
> btrfs_mark_ordered_extent_error() in btrfs_finish_one_ordered() uses
> test_and_set_bit(), finds it already set, and skips
> mapping_set_error(). The error is never recorded on the inode's
> address_space, making it invisible to fsync. For encoded writes this
> causes btrfs receive to silently produce files with zero-filled holes.
> 
> Fix: replace bare set_bit(BTRFS_ORDERED_IOERR) with
> btrfs_mark_ordered_extent_error() which pairs test_and_set_bit() with
> mapping_set_error(), guaranteeing the error is recorded exactly once.
> 
> Signed-off-by: Michal Grzedzicki <mge@meta.com>
> ---
>   fs/btrfs/ordered-data.c | 2 +-
>   fs/btrfs/zoned.c        | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index 5df02c707aee..b65c1f1e2956 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -385,7 +385,7 @@ static bool can_finish_ordered_extent(struct btrfs_ordered_extent *ordered,
>   	}
>   
>   	if (!uptodate)
> -		set_bit(BTRFS_ORDERED_IOERR, &ordered->flags);
> +		btrfs_mark_ordered_extent_error(ordered);
>   
>   	if (ordered->bytes_left)
>   		return false;
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 0cd7fd3fcfa3..d728c3bafc09 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -2136,7 +2136,7 @@ void btrfs_finish_ordered_zoned(struct btrfs_ordered_extent *ordered)
>   			continue;
>   		}
>   		if (!btrfs_zoned_split_ordered(ordered, logical, len)) {
> -			set_bit(BTRFS_ORDERED_IOERR, &ordered->flags);
> +			btrfs_mark_ordered_extent_error(ordered);
>   			btrfs_err(fs_info, "failed to split ordered extent");
>   			goto out;
>   		}

