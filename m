Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B14E34F48C
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Mar 2026 07:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772523270; cv=none; b=qLXCdS036Wf8nVscLCZvnKfRfUpzRV7gwEFtSqBrPh/T33GDVMz6iVuxuRNe1l2uwv/qrBafb1v4PZ+0b1sgUKGHQAu0FP7ymrUWutqPJ2WviMU37hou+qX2iCAEGxk7sm+K5cZQexCMNwacMQHo2i7KNUnjN75Zs/QHP6UT1ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772523270; c=relaxed/simple;
	bh=p8gEBLqw0tJIOJzuJTpFTHzMn0lIFi0U7Z5ec0RJ7Jk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ds0I67TdTmBZKxOsdj4ztk8iGvSEDDFyu4C7fab09pItrT1l6BXOYyrh4PKpdCI3h+ZGugp78YONPaSZNnX2BbQd4CsG3O7CjBwV/mq0mROxSSG9yFypONZBZCkI2Q9DhOAI08jH+g6wY4dyCa2Z4YL0/HzYmnmCmPsXtUCPQOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=osqGJ34Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="osqGJ34Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9995C19425;
	Tue,  3 Mar 2026 07:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772523270;
	bh=p8gEBLqw0tJIOJzuJTpFTHzMn0lIFi0U7Z5ec0RJ7Jk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=osqGJ34ZpZnMAHINPuWt3P4bP72FHNgB7UGk6q6cD8P3uFJ2GngvoP3NYiIsOft9h
	 SplOsv4ziPkTw7S9V2vFGRGdcP9zED/k/d+/M2fUZy3afCVaTkqYom361y9tMv0Mqt
	 GESscDCWs8dmuT2fKBMpMBrz0i48O6153+ZJb5Nozg1G1CzC4UYjUIQPTu4Kaq4OCi
	 kqqlvVKf0fjVu+JGktcopnhN4P3hHCooATmlhhM4KYhPgV4F4IRh+zIwY4HJYO7dP3
	 7GmpfiXy0ec2lDyP9q6vbdeB/c0iz0PWnWwkFnTTN+Q1KyGdm8dzG/U+hBb9UvirxR
	 ZUj1amo8geP0A==
Message-ID: <49d9540e-aa23-427d-92d1-f0dca6ed8328@kernel.org>
Date: Tue, 3 Mar 2026 16:34:28 +0900
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] btrfs: move reclaiming of a single block group into
 its own function
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>
References: <20260302143942.115619-1-johannes.thumshirn@wdc.com>
 <20260302143942.115619-2-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260302143942.115619-2-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/2/26 23:39, Johannes Thumshirn wrote:
> The main work of reclaiming a single block-group in
> btrfs_reclaim_bgs_work() is done inside the loop iterating over all the
> block_groups in the fs_info->reclaim_bgs list.
> 
> Factor out reclaim of a single block group from the loop to improve
> readability.
> 
> No functional change intented.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Looks good to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
