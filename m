Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.218
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793099698;
	b=AShKs0SHtB/7sB+NFHCwR+bMjrBs4qQuye+jh0QsekClBhRRs32AABBG7cNX6Kxp1hyB
	 V5LxSkJRVHpHwOMm6Yqugm6c61di9m5TtBykcE+kA5OuwrICD06l5o7avi3BNqHUU1JWx
	 7IOvaD6+f3vUifCllO8xv/URaE6v7n0Z4r9qxE534zJcUnJs+ZXcombRh8rVsjFfLf5dp
	 I5zWv5kFLLS+JsFxCqq47vYFX+7Jgm6EwTJ3KzcDRaVTjA36PUlRfa7YUyE9VmgBY67E4
	 Zuen0B/lpQMNw1s8Rst7gLOyfr5m49I6fSo9A6RWRKj7drGd3KZd2K9dA3n2rdhpawg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793099698;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=erC0p436ipwyI6asEt7WUOhnni2WzxvEwWVFbMmqkS0=;
	b=weyZ5LUojnqOgobdwwsUShX22frUqwjnAcpM9Dj5aOXAEBVy81uDXe25AmfcT9BjHvfF
	 OJoiS9mEQKlmp39Io5BJHsPyRQu091anzwGB/8tITXCta67e96i6A48VZPJCwihxCPJnD
	 SAFA4JQUauJDWd7vsbuOLLi9x91bNoeWTy/QxuHqqlg1pKnwAu7jFF4zbLtBdZmK+M4xy
	 vxl+mabWs5+lgnZ/wmtukeCG0drwmPUtn9I9zh/6vZl1aczZ6YC7Rygf6XPFfBTouW6CI
	 ltq3DBAr6S6I06a98FTxM4ti3t5KhhM/7CMw+NtIsfViGhcY+IOobN6oW5SRnHlBuXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CBfck7VX;
	arc=none smtp.remote-ip=91.218.175.218
Received: from mta0.migadu.com (out-218.mta0.migadu.com [91.218.175.218])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDA2606A328
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 11:14:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0FDA2606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CBfck7VX
X-Envelope-To: linux-btrfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=KtPACx9uluOb4kE38HVLKkwCk631bhedpoXc64nfCOM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793099690; v=1; x=1793704490;
 b=CBfck7VXkbPtz+84PzdUCArP23RlwI/MjoPzn3kF7zRwsbYD08nN61iITlgHo4p8UHYKUa3B
 dFExtvyN8LH0WRdS47W0F2c43aTTsDYpuOqJLLTbubJNMztnFbqYsrzwOl92SM6rFrkucwqAHZz
 ry6BkY5woJ25nA7t/x/KqnLw=
X-Envelope-To: linux-btrfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id cbc3ab62f1579971;
	Tue, 27 Oct 2026 11:14:50 +0000
X-Mizu-Trace-ID: cbc3ab62f1579971
X-Migadu-Flow: FLOW_OUT
Message-ID: <3048fa10-007e-41d1-9b95-5be5923e4a68@linux.dev>
Date: Tue, 27 Oct 2026 12:14:48 +0100
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iomap: only follow dio alignment requirement if specified
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org, da.gomez@kernel.org,
 gost.dev@samsung.com
References: <9fae60fcce5ae356deef5e38931124b9634dba3b.1792997261.git.wqu@suse.com>
 <at-p1QXETaTvvj_r@quentin> <5f49d819-12ec-48b2-b9b2-adce264d266d@gmx.com>
 <0046bdae-1dd1-4f4b-a1e5-9eb7fe8b5fe0@linux.dev>
 <04a7e656-567d-458c-99b0-e9aa5960bd99@gmx.com>
Content-Language: en-US
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <04a7e656-567d-458c-99b0-e9aa5960bd99@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 10/27/2026 11:12 AM, Qu Wenruo wrote:
> 
> 
> 在 2026/10/27 20:37, Pankaj Raghav 写道:
>>
>>
> [...]
>>>>> Cc: stable@vger.kernel.org
>>
>> FYI, your patches are not in 7.3 and only in linux-next. So we don't need to 
>> cc stable?
> 
> Unfortunately, it's already upstreamed.
> 
> The commit hash, 4025185cf953 ("iomap: follow the alignment requirement for 
> iomap_dio_hole_iter()"), is already in the upstream.
> 
Yes. My point is this was merged as a part of the current v7.4 merge window, so 
the fixes can go as a part of RCs? Does it still require a CC to stable?

--
Pankaj
