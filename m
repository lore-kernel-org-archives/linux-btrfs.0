Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537C748EC87
	for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 07:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792395936; cv=none; b=OwY9Mzp3XFo7n3HxILtOaS4O8SHi07+O4Vm/ExLGv2u7auSJzc5Q6JJvctmLvwvPqJBHG+GiZ7EEIrbh2/SW53j8NCNo2YC7PjbzA/MOZ99SCbK1qb8vWjuK8qlqvZZq1GmklwkwDALWvX5XbMQbojiSoV7YHBIW8z+v3YrIQyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792395936; c=relaxed/simple;
	bh=SNxeDdIJq+/yP6ezhBcZsmmGKtMBjvY7qIcTac4+r9A=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=YGaH0LCEbOmscHWnU+cIqRi8JX7JpRRcVlZDzTfy6H12FULsc6o9qhgTZFYqgjs6NUkkauBRcBU2b2kukXMqN1DMXm3bLfCR0JmJIk4fML4MLPFrZd4w9kxXGjoek4620YRokjyHrEE0hTn/h+tFbrwLvqJzTRH2A+Mb686SZwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=M/YBdPb2; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="M/YBdPb2"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a018792ab3so12884525e9.0
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2026 00:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792395933; x=1793000733; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=e3ppAxxEWdSUYX49PSl7nHUgvQApi7yJOwVtmaOG7eQ=;
        b=M/YBdPb26dAxbxs1k+bR6Ef2WY8ucDv1h8fkjTUesk+cTHjT1m5Ql4QX02/7MXcebQ
         5pbzKaVR4VuF89PgIPCZQyFf7nbLAoBGUhS2u7gVWHQCAGiDQZ0CtdW593XiSp+dJTx/
         AwUHhFvikBy5KgIz9BG1m06TSSX85jNJyYf+6CeZSexdLsKLs2NsBSaFnF9feR3DDLGi
         5YPNMdGZbNAAGskQFFUMaatsRTduNcjNO50MngEJHsUsViNulSeyEpicebYSbnXQZXRH
         8DQF6BFKYkalr/rneJeDcd8E0Lg5YRpYUJaX9IC/CseQ336o8+/x9OT868rbOhrT30Zl
         NRFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792395933; x=1793000733;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=e3ppAxxEWdSUYX49PSl7nHUgvQApi7yJOwVtmaOG7eQ=;
        b=LHmBvRTcBLUcSY8qTs4KpXj0487vHGSKHx2QaX64JmU7voY5rKxt4ghNB52ejUloN8
         lXu1tez8freV1QiKYTFzhA3FElD5hgh+Ho5BCuzXlCRVWadvNX5QCvcpU4veS9SsQPU4
         Rm6T01bMOdP7zkdUfjGM2SxzshtximKcqcGVll8RUZxNFARp/W4C51mYrD0AxZaM7fkE
         KGSEtTqY+xk1H1/mXzsR9DJ9bNTLiYVZeWthRXbXyJpdjEX39K93sZPa+K00DHHb5npb
         C6OGfXLUuk98upjkOD0rWhMfR5OsXwTtwQ5XwirRaeibVtlEV2VToYE+r1uSsmKzNjL0
         oStg==
X-Gm-Message-State: AFq9FYJXsOKJKAYpCbpkTHKad6oJBoqK3xFi+lGLv5vzMudY37wEmOua
	p7kLV7nADoEdI83/Qp3bYynfLlzSC5JsC0a3AV84tYWZRl6Tde0pSHnXpijQ/PATciFUXSNAF95
	dVd/iagm+Aw==
X-Gm-Gg: AYBFou0LqtVTzK5Sh7b+0oO+o8e+T3HZXv24q1HdoPlPo7xfwYLkpwtTZWo77cTLSb6
	kePrfkns2iaOrBsPrPYmVzOmt3rES/wdT9BXLRsNhcJmvlilA+pcE/vK9y+8akuZMgpiPJsxlrU
	lRgJ5froVjbOWj4HuPzD8sL5Yz0Jw9X3OGzzogeeUJ3vXFq2eWAAhq7ixbrwKGiEp4wNozm7whu
	R4z2in0sIt/L3D+Q7zQ3hLbMyYeghbSTSukVCbbKnhHpDcT+mS34Zt/00kOcPOX0WfClwDg7Eix
	pp+pRKgYUUqu4KKWGcR3EK0jHNDuG9xV53nwp7B6myY2RfoG1X9xH/V4shJE4EPCOzGYCGwS7Gm
	zPvTey75+LTUx9x0pk6QXVTpcl9tDmcQhhWk0Cj/wmdz+e6jnwxA276VyrT+LKAEeBwcqceBuSg
	6bTI8RR8SlBO7pHov0+rSzH4dSnEXloXEafNJa1JLis89YONNyQM7pvqibowVjAg==
X-Received: by 2002:a05:600c:4e8a:b0:49f:cbf3:551c with SMTP id 5b1f17b1804b1-4a1d75f8399mr150163055e9.12.1792395933461;
        Mon, 19 Oct 2026 00:45:33 -0700 (PDT)
Received: from [10.86.129.46] ([149.22.87.44])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acc48f19d9sm14493812a91.11.2026.10.19.00.45.31
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2026 00:45:32 -0700 (PDT)
Message-ID: <44cfc49f-f89d-465e-91ac-f300d5ca976a@suse.com>
Date: Mon, 19 Oct 2026 18:15:29 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/9] btrfs: prepare for variable stripe_len
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
References: <cover.1792391732.git.wqu@suse.com>
Content-Language: en-US
In-Reply-To: <cover.1792391732.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/19 17:09, Qu Wenruo 写道:
> This is a preparation patchset, to support a stripe_len that is not
> 64KiB.
> 
> This is for the future variable stripe length RAID56 feature, where
> RAID56_VSL profile is allowed for data chunks, and the stripe_len can be
> as small as sectorsize, meanwhile data IO are kept to be aligned to
> data_size, which is power of 2, and larger than sector size.
> 
> Finally, RAID56_VSL will always have a number of devices that nr_data ==
> data_size / sector_size.
> 
> So that's why we want a variable stripe_len.
> 
> This series does all the preparation, including supporting stripe_len <
> PAGE_SIZE.
> 
> For now, tree-checker will still reject stripe_len != 64K, but that
> limit will be removed when RAID56_VSL feature is introduced and can be
> properly tested.

Forget to mention that, this series relies on this patch which is 
already sent to the list but not yet merged:

https://lore.kernel.org/linux-btrfs/bd4a247e970e35e3adc140c5417da14bfab2f4f8.1792296994.git.wqu@suse.com/

That's why Sashiko is mentioning two minor problems.

> 
> Qu Wenruo (9):
>    btrfs: reduce the width of num_stripes and sub_stripes
>    btrfs: load the on-disk btrfs_chunk::stripe_len
>    btrfs: add btrfs_io_context::stripe_len and load it
>    btrfs: change scrub to use stripe_len
>    btrfs: add a new 'stripe_len' parameter to btrfs_stripe_nr_to_offset()
>    btrfs: convert volumes.c and block-group.c to use map->stripe_len
>    btrfs: convert raid56.c to use rbio->bioc->stripe_len
>    btrfs: convert zoned.c to use map->stripe_len
>    btrfs: introduce extra limits on btrfs_chunk::stripe_len
> 
>   fs/btrfs/block-group.c  |   9 +--
>   fs/btrfs/raid56.c       |  52 ++++++++++++------
>   fs/btrfs/raid56.h       |   7 +--
>   fs/btrfs/scrub.c        | 118 ++++++++++++++++++++++++++--------------
>   fs/btrfs/tree-checker.c |  13 ++++-
>   fs/btrfs/volumes.c      |  84 ++++++++++++++++++----------
>   fs/btrfs/volumes.h      |  16 ++++--
>   fs/btrfs/zoned.c        |  54 ++++++++++--------
>   8 files changed, 226 insertions(+), 127 deletions(-)
> 

