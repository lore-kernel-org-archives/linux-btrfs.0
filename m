Received: from out198-156.us.a.mail.aliyun.com (out198-156.us.a.mail.aliyun.com [47.90.198.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFC44DEC2B
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2026 15:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=47.90.198.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790956494; cv=none; b=Y8FBCx3qoaRNWt5czbJ1CR2isdkTNHVo2GaaANh07M6+63dZV2Jn0E1RaKl44M3OAbz+W73fHLRAQZev5/nzm3QxNe/D3dn989VZmK92cg88rmevjjO9CilinUf3NFuNN8U+uIJZtnuWbqC4JVvPifDVby8Dmdzgw/3scBuHJTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790956494; c=relaxed/simple;
	bh=H3+BgUWUi/bYzbJ4v9X6cYlKbCYEmIrkiTuHKeCz/0w=;
	h=Date:From:To:Subject:Cc:In-Reply-To:References:Message-Id:
	 MIME-Version:Content-Type; b=uGvrkZW4DGNmRZsS1UG2y2FQ/KAyHhhcgCTS/Qt4hxyqclsunBvhXoNKCVeQwTu6ZiO2SWxohX2KwrXYfLXyMQqrd/B1ePe7zfyehw2BJBqAtvDsS14/BRRku709TXgSFP/ajN5PuDbpht8PJQtFfcgjjegfMC9U0V6aAIKorTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com; spf=pass smtp.mailfrom=e16-tech.com; arc=none smtp.client-ip=47.90.198.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=e16-tech.com
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.04443379|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.580679-0.000214871-0.419106;FP=1205038819756476153|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033037021217;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=3;RT=3;SR=0;TI=SMTPD_---.jThF4DX_1790955534;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.jThF4DX_1790955534 cluster:ay29)
          by smtp.aliyun-inc.com;
          Fri, 02 Oct 2026 23:38:55 +0800
Date: Fri, 02 Oct 2026 23:38:57 +0800
From: Wang Yugui <wangyugui@e16-tech.com>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH v2 1/4] btrfs: zoned: only change active zone counter on successful (de)activation
Cc: linux-btrfs@vger.kernel.org,
 Naohiro Aota <naohiro.aota@wdc.com>
In-Reply-To: <20261002073715.2191177-2-johannes.thumshirn@wdc.com>
References: <20261002073715.2191177-1-johannes.thumshirn@wdc.com> <20261002073715.2191177-2-johannes.thumshirn@wdc.com>
Message-Id: <20261002233856.C191.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.83.03 [en]

Hi,

> btrfs_zone_activate() unconditionally decrements the reserved_active_zones
> counter regardless if btrfs_dev_set_active_zone() fails to set the zone
> active, i.e. because it raced with another call that already set the bit
> in the bitmask, or not.
> 
> This can lead to a double decrement of the counter in case the bit has
> already been set.
> 
> Only decrement the counter *iff* btrfs_dev_set_active_zone() successfully
> marked the zone in the bitmap.
> 
> Mirror this behaviour when clearing the bit again.
> 
> Fixes: a7e1ac7bdc5a ("btrfs: zoned: reserve zones for an active metadata/system block group")
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>  fs/btrfs/zoned.c | 27 +++++++++++++++++++--------
>  1 file changed, 19 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index 9f562cc34e38..d68b91008e76 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -1126,11 +1126,13 @@ u64 btrfs_find_allocatable_zones(struct btrfs_device *device, u64 hole_start,
>  	return pos;
>  }
>  
> -static bool btrfs_dev_set_active_zone(struct btrfs_device *device, u64 pos)
> +static bool btrfs_dev_set_active_zone(struct btrfs_device *device, u64 pos, bool *new)
>  {
>  	struct btrfs_zoned_device_info *zone_info = device->zone_info;
>  	unsigned int zno = (pos >> zone_info->zone_size_shift);
>  
> +	*new = false;
> +
>  	/* We can use any number of zones */
>  	if (zone_info->max_active_zones == 0)
>  		return true;
> @@ -1142,23 +1144,30 @@ static bool btrfs_dev_set_active_zone(struct btrfs_device *device, u64 pos)
>  		if (test_and_set_bit(zno, zone_info->active_zones)) {
>  			/* Someone already set the bit */
>  			atomic_inc(&zone_info->active_zones_left);
> +		} else {
> +			*new = true;
>  		}
>  	}
>  
>  	return true;
>  }
>  
> -static void btrfs_dev_clear_active_zone(struct btrfs_device *device, u64 pos)
> +static bool btrfs_dev_clear_active_zone(struct btrfs_device *device, u64 pos)
>  {
>  	struct btrfs_zoned_device_info *zone_info = device->zone_info;
>  	unsigned int zno = (pos >> zone_info->zone_size_shift);
>  
> +
>  	/* We can use any number of zones */
>  	if (zone_info->max_active_zones == 0)
> -		return;
> +		return false;
>  
> -	if (test_and_clear_bit(zno, zone_info->active_zones))
> +	if (test_and_clear_bit(zno, zone_info->active_zones)) {
>  		atomic_inc(&zone_info->active_zones_left);
> +		return true;
> +	}
> +
> +	return false;
>  }
>  
>  int btrfs_reset_device_zone(struct btrfs_device *device, u64 physical,
> @@ -2411,6 +2420,7 @@ bool btrfs_zone_activate(struct btrfs_block_group *block_group)
>  	u64 physical;
>  	const bool is_data = (block_group->flags & BTRFS_BLOCK_GROUP_DATA);
>  	bool ret;
> +	bool new;

'new' is not a good var name because it is a keyword in C++/Java.

'is_new' just like above 'is_data'  maybe a better var name.

Best  Regards
Wang Yugui

