Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF657374170
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 06:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775544463; cv=none; b=p/u0k4b9KRIYGc5+EP+ECvK0d6md2m0UMuH/xTmwaele3u15D1I7xG0JGUeMCDdFiX2iI9aI9/Fr0lDRkc0EDULlivvASHo8OvEv5mgXbycnPhzwF/rIVsMY6SmM7sBgHU0G8jnfmZKFbONmS0Edy/oIN+sPMXHOUKVW5G/LkMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775544463; c=relaxed/simple;
	bh=/Zb/QrecqGnAWaefJaefRiE7GUB6IzXs1L34jQOaO2I=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=c+q6p+1+T5G+wWUNR+IWhvDITgGDc/KowGs5rvHx5djNwCNUf5tVM7ay/YhQzPmFyHrF3Dd3g0XeiqP215IenmaqfYT5Uga0Tno5wNLvOT+GrVkkYyyXu+//Epfr6T0Oy7Bf5LtTkNMD2XauiE7+sFa/6eZgSkueDCHE9d+kdJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=asJIuWgT; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="asJIuWgT"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2b23f90f53aso42380185ad.0
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Apr 2026 23:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775544460; x=1776149260; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:cc:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RBDhvqKhOIyydAIsbmlRbOE9NdKaxj3xuBav/Ht0mWs=;
        b=asJIuWgT+I8u6SOcI0AmUc+X2gXkQjYmcFF4JFVd6TYjwqANtERZirKSvRQTBfj0oq
         DJZDxFaC+8fmNL6L5mi4vCFSI7vBll4dmEOY8mrhBSl44uE/A5WR2yR8pt8GWIN+LOmC
         L+wTGeoNckM6u8BvNEtgdvOrKhhFwf9qB3WX2bm1FKUfCI8F0tn7u0gldHVnaMxkyV2B
         3W0lisBgY/RxzybJg33GWd1NOzr07eXEHqVOogit6G4a2hoLVcWB85XVJGxBWOpx1uac
         PyUBfakwS2p3zMffQu6hyAQON/ZbW1TPOwgiuOdLbSv3OIyQYYaX/vcMMHvJpgbewjOZ
         zr6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775544460; x=1776149260;
        h=content-transfer-encoding:in-reply-to:cc:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RBDhvqKhOIyydAIsbmlRbOE9NdKaxj3xuBav/Ht0mWs=;
        b=TnobleHd8Phdz6Y/pq6yCDVOMbinymYx84uLapTUoZa/Jb5UrkME4umKj6BD5Aj4DU
         +iUqhHrlCAIvRmVE+cTY1RlUiBvp0CU4ODSTpt1cb65jqpC2sozaSPxq47JkXsTR4THo
         uVyus8qSckAJ6sp3k3nHGVeoxADtxPh6mJV/zCpj8NTFB1Omci7gYLjjw76HAUi102/H
         hc1sFp3zuCe54lg2NuUzgKYycS8BdCfAU+CUOsKttv7EcMv6ktMdphOI/yo2J48U9ck5
         JjWeVeincMDAeFSJluwu64IZTlAKlDvVKTZRmJf5w59Ix4VpQfF3+5s3zjXR22Pn4Z7A
         dSLQ==
X-Forwarded-Encrypted: i=1; AJvYcCUyWZne8YzgDGmc0gZiU1EVS6vHc9XZjXotmvcB91CAE4I9wPNayN6bxphicmPRD2twuRJTKmr3kDtv/Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4aWS1gDknyaSgserx+tsO935lFb+hysmHYVv/F93mVdWtyc7h
	XWJQpjPBHOHBkrrcrafAxkGdEEap9VG1etzmtREYdAzOr4XRzEN5gp9U
X-Gm-Gg: AeBDiesbUjIqMw+/Mzwa8XgrFm8QJLpY32EBlwlDO86Dm5n2+eZHTi2dTGa3J7IAWbq
	g0LggZWtfWkYG2KDrxigujGS6HnaZBAK+VJGtEVOC7Jthp7aLSeK6tuKathYyVXty91CR5DhPuY
	FcvOmPkQAkqktk2/b1P4HYnwCriv2b2Bb9wIBsSwOobC39D646RKaOVMgqVwsiLtHo/fiiye8b3
	y+0kGvrYkFqh1JGV4TUa+FWz6A2Jkobf5v314yJPkWFhnGTdd6EjSy3XQn6oLlHUNq3rGDpzP08
	aD2KXUcl/KTIiYZrZ+ivT87c83ZoAqCkqp77S2d//PZ1UYf7EjLpqHOWwkz1upy580Ej3JOByeO
	vacp9IaoHImJPzrorqPoOtWuP3K77nNnga4CUwylHY6kFmfTsmRUVPSIaNw6VI0Q2wEpv+U8FWA
	kv6fakgPVEv1p0cBp4MiUn51LWik6PazS3d0y3Cg==
X-Received: by 2002:a17:903:40d2:b0:2ae:ac0c:5a29 with SMTP id d9443c01a7336-2b281674f1emr165153295ad.10.1775544460209;
        Mon, 06 Apr 2026 23:47:40 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2749eeb9esm198445755ad.84.2026.04.06.23.47.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Apr 2026 23:47:39 -0700 (PDT)
Message-ID: <66b3a6ae-f035-412c-8683-8f869edad00f@gmail.com>
Date: Tue, 7 Apr 2026 14:47:37 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] btrfs: btrfs_log_dev_io_error() on all bio errors
To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
References: <335133ce1989ac89a6de007d4db05f5f4a6c1be2.1775491985.git.boris@bur.io>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
In-Reply-To: <335133ce1989ac89a6de007d4db05f5f4a6c1be2.1775491985.git.boris@bur.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/4/26 00:15, Boris Burkov wrote:
> As far as I can tell, we never intentionally constrained ourselves to
> these status codes, and it is misleading and surprising to lack the
> bdev error logging when we get a different error code from the block
> layer. This can lead to jumping to a wrong conclusion like "this
> system didn't see any bio failures but aborted with EIO".
> 

> For example on nvme devices, I observe many failures coming back as
> BLK_STS_MEDIUM. It is apparent that the nvme driver returns a variety of
> BLK_STS_* status values in nvme_error_status().


BLK_STS_PROTECTION is interpreted differently depending on the device.
In NVMe, it indicates invalid Protection Information (PI), while in
HDDs/SSDs it typically points to a malformed CDB (often a software bug).
This is one of several possible error conditions.

Rather than introducing new BLK_STS_* codes, vendors have reused
existing ones for newer device types to maintain backward compatibility.

There isn't much we can do about this for now. I assume the malformed
CDB-related issues have largely been resolved, so this Btrfs fix is
effectively NVMe-specific.

Reviewed-by: Anand Jain <asj@kernel.org>

Thanks
Anand

> So handle the known expected errors and make some noise on the rest
> which we expect won't really happen.
> 
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
> Changelog:
> v3:
> - actually do the change stated in v2...
> v2:
> - proper bdev err logging for expected block errors
> - btrfs_warn_rl for all other errors
> 
> ---
>  fs/btrfs/bio.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
> index 2a2a21aec817..9c3cd6978880 100644
> --- a/fs/btrfs/bio.c
> +++ b/fs/btrfs/bio.c
> @@ -4,6 +4,7 @@
>   * Copyright (C) 2022 Christoph Hellwig.
>   */
>  
> +#include "linux/blk_types.h"
>  #include <linux/bio.h>
>  #include "bio.h"
>  #include "ctree.h"
> @@ -350,11 +351,18 @@ static void btrfs_check_read_bio(struct btrfs_bio *bbio, struct btrfs_device *de
>  
>  static void btrfs_log_dev_io_error(const struct bio *bio, struct btrfs_device *dev)
>  {
> +	blk_status_t sts = bio->bi_status;
> +
>  	if (!dev || !dev->bdev)
>  		return;
> -	if (bio->bi_status != BLK_STS_IOERR && bio->bi_status != BLK_STS_TARGET)
> +	if (unlikely(sts == BLK_STS_OK))
>  		return;
> -
> +	if (unlikely(sts != BLK_STS_IOERR && sts != BLK_STS_TARGET &&
> +		     sts != BLK_STS_MEDIUM && sts != BLK_STS_PROTECTION)) {
> +		btrfs_warn_rl(dev->fs_info, "bdev %s unexpected block io error: %d",
> +			      btrfs_dev_name(dev), sts);
> +		return;
> +	}
>  	if (btrfs_op(bio) == BTRFS_MAP_WRITE)
>  		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_WRITE_ERRS);
>  	else if (!(bio->bi_opf & REQ_RAHEAD))

