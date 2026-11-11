Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794392300;
	b=mReRpd7JwTuLnRyV3eZYTBupFGC61jj0X94bUBN/jjtCEIopXcv2ls0fPSMLU2fLM6pm
	 vlaEVXd0NHLs4ZNHz6HT0ylfn1ofJAtDtE2udkZtvxngRxchujo6TsZ/vRmo9qzpRROyh
	 FljmpAELRwLCZufgEglYngmHJigp2RABsaLYcTSHB3pGYg/ElCK/Q8mZudjL8Td6Tce0q
	 DOpT1PhTs++uFxd+sHB3Cf9ip+fXL+nrK+Bvp0mWgwQgN3np158aR27NhC6kxjUtZvGuw
	 wOX2b/G5kspna/oBuf/5F18aTGLn52aCeECqDJgwzHmsyS27NSVMbLx3neigxyfdQdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794392300;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=9k5V3+dqOiShJRt1JwapzUiCjwV9ozeskwLymScoi9I=;
	b=cIaXlSEhrSnho1MN2DsZ5G/lIxWgkav1esOoaDKWV2KVyeomiFmen/CO2vCwVgbkKExC
	 XPgo4zmdZBnMcByUV9ecqg2+wIEr8YcxODAeBgsC1RcXra185aB0H1C+6QSQa13/Cq52y
	 Z6+guB8UFguNgKy+RUTAe/TJG4OyNKKim232Lwx1b6T5Cn3lrIOTg8+OGWd93ycxJQERL
	 kLLwi92wYv+IDdbaBggu7kL4ZEUxeqDQznyXe/DeIdEod4pMFdJZXOsxhQ2UFjXKqvjxP
	 dhQVy1Dd5KuqBNZS/IOYoKyeD6uHkOqy7fZhaDnLr9aX62ekaLS3hKCdIwLVRRYTbiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SswqOGHZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5089606A31C;
	Wed, 11 Nov 2026 10:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SswqOGHZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A7C1F00A05;
	Wed, 11 Nov 2026 10:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794392300;
	bh=9k5V3+dqOiShJRt1JwapzUiCjwV9ozeskwLymScoi9I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SswqOGHZ1t718bIr1XhSZ4ZfdcEY35DZonubgj1DQPfgvodJWl6mVWbrgsoybbLcS
	 CgYTXzNgRp0xinix2mbuu5LZVPonM/fW1m7WMc0oK/+KBUGROBX9Vk2UZrPTNZH7lv
	 um7NpADhGYNASnOk4rnSx8PmKL169mKUCRXtDWlOdEfTQ/XD5wi1ABaO+7JX0p2Xjx
	 pjk8M6PjQVxecHu58OudlJafwpiKJwDCiM22A8W9aXRmXx+L9O3IwGbFm6miHdYJFK
	 52bee1MUcCQAyMJI4NToLaqd+qYqzN5l9ZD5p0o28dbHUz2pi75EJHaseUZ1Ro/13D
	 lG3EV7yPkPi4w==
Date: Wed, 11 Nov 2026 11:18:15 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Zorro Lang <zlang@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Naohiro Aota <naohiro.aota@wdc.com>, linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] common/zoned: allow setting the zloop device
 capacity and extra parameters
Message-ID: <avRActUZsyGVFKb6@cronus.toxiclabs.cc>
References: <20261109175146.1146100-1-johannes.thumshirn@wdc.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109175146.1146100-1-johannes.thumshirn@wdc.com>

On Mon, Nov 09, 2026 at 06:51:45PM +0100, Johannes Thumshirn wrote:
> Add optional fourth and fifth arguments to _create_zloop() so tests can
> size the backing device, which matters when the backing files share a
> filesystem with the test data, and pass additional zloop parameters.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  common/zoned | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/common/zoned b/common/zoned
> index 89d0a061..7fe794f9 100644
> --- a/common/zoned
> +++ b/common/zoned
> @@ -81,9 +81,17 @@ _create_zloop()
>          local conv_zones=",conv_zones=$3"
>      fi
>  
> +    if [ -n "$4" ]; then
> +        local capacity=",capacity_mb=$4"
> +    fi
> +
> +    if [ -n "$5" ]; then
> +        local extra=",$5"
> +    fi
> +
>      mkdir -p "$zloop_base/$id"
>  
> -    local zloop_args="add id=$id,base_dir=$zloop_base$zone_size$conv_zones"
> +    local zloop_args="add id=$id,base_dir=$zloop_base$zone_size$conv_zones$capacity$extra"

Looks good.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  
>      echo "$zloop_args" > /dev/zloop-control || \
>          _fail "cannot create zloop device"
> -- 
> 2.56.0
> 
> 
