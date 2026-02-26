Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082C84657F2
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Feb 2026 16:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772123466; cv=none; b=l0/sRbVWL8VgPMjKeqJn4GaUoDarbsaO6ajbWIm2dNxD+cd2zcz8jhTx6E2AkgIETqjVoqPJOOfUE4G2sqs3gmQz0u+8EIyHSQGFed6xEBZwi+6GRkyBWXPG1oAO9+jPtcB8YKBTwuqMTd7tzE6+Md3wu08th4XcCW+pFEHvN3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772123466; c=relaxed/simple;
	bh=sRMSWEsQbVYqruDLWg50FVRfknHGCccs0DYH9B3QGnM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jgeDL5nxM7xE7leCXXtgG860MB1JdvoOIR1uESNHFG8CyjM4GFbrGGDsbq1bjMgzXq9SOL80WevHmx5owZY2MfiS3nfOpGiFTexSZl5xEXfhHlIsqGz7j5Kzh3xeNhzOJ6mHb13iL6onNfUjcDAp0EcnF0Ly/iLStMEkuqbvhdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dHr0SDE+; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dHr0SDE+"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-4398e347a08so43280f8f.1
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Feb 2026 08:31:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772123462; x=1772728262; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=54084A4OEdYJ/FduLbr67Sj+jCec7nOyoBihp7G/XDQ=;
        b=dHr0SDE+rvIbb4oj9Ahs39A6IS5Ew9H6EAn078RhothmHomZJUck9t/fo/ltv2s+Ab
         02L7L941+nPgmPDrnuBDyc5Afboa0oEehDGBOrGxkGilcA8YWxybll3L1uRWEZCv5jNa
         F4R0allRnGs1QuFDADYY/f9M4Knncl+e4cyhBiGZxVAD6AWVpKTj6OaYbbb73ly11Sn4
         phX78R9LcPIaJw5nBRCcVv1bmtFxtoPBVoQ2ZzP/taNKpuhPNUOYaW8W33EUBK+ks0EF
         AtUt9A6WvPF88+Hf2hdkVbjLhrLzO3y7hOqX0Pp6wV6syfwSWiu3c/jozLpig94nC5l4
         B6MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772123462; x=1772728262;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=54084A4OEdYJ/FduLbr67Sj+jCec7nOyoBihp7G/XDQ=;
        b=oHsKqujeMteT2DmhzBsFTU76DhrjO8yAX1qHWP35fIG1Nnu89vRU1ltCWUX1FIO7BM
         JLAIrqT+jAL1BfnaCZfw5hj0TTPbiQABSUWkHlpJyXcxc7q0l/dO2qDVWEVTxc8mVuaA
         gnwXBHVg3zETDvemOUHHYniqCGNqBqW0j4itGJee7ZxrPPZeo9+IR0kdwiKxth6zPcVM
         id+4kxchY4AW5BQIb2PZ5ANqRgc7D7R42IXR06mApXXXkmhBOe/jA9aKnSJOC+lz3N+P
         /XviVO7997WNq0MMfyq8jKs/aO3EmpcB8xvIgbN011nbNkYlxRTwxn95r/BNybSwhyNR
         d64g==
X-Forwarded-Encrypted: i=1; AJvYcCUnxc3tKxudnAJt01/KWRT7DbRLskSl9XXGo1jAScH24iVVUb1lj4vNCr4LZCo0vKbTv9d3PNXOT03AGw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwZJrcFnRVMh2NSJxKIp+jKvdiCPmI5kqexGeIfxU22hjdPgoHP
	aPEd76Axxqoufntv5r7lqv/F5VjFp7CyiF2BpJ5grAKGnncRU6MZIcyOFRZcofwWp0M=
X-Gm-Gg: ATEYQzwODMs8xRPOwlWRoiRDvY3L5bE0GAHK3TqJiNwnWKCIa6cjv9ooOosaikjvBwr
	3biIRKscgSYleLhESUrodi4ZRZQiQLp4zPZZYUGxvJIdJTr9SDC7VMG+tdNBHbfeLL3K9FjM5qc
	li2m+0gvCtzPhI8FfGVQRbJ7jhLCOYBLMKk1P2lw2M+FCw2KYuZwUXRp2l4zyCl/HZ4FknNJUKr
	pRaIf938BjnrEESB4KS8wf4FqjSTonlZ4q1dEwzGzTX5Mcyk4S7/D5duZE981X8ECloqLVtlB5X
	XZfXomsh+dgXfSoh1bmFjO9CCCt/0gZhep4/Yzm3vnvP8lBLl1RDFbQX8VHK2ahq46mOMICaQIC
	vY36Ue34FpgS4X0D1kw67/UU2NrQD0XRAlRxFtO+CXRYL94Jt9UDPf0al3EqZ8hBBZiqRHSB/EA
	Jkq3GNcO03CtueKHsX91WQZKBbweoKGrNOsTmfnNAXKCQb6bN98taYSKxCmw==
X-Received: by 2002:a05:6000:1101:b0:439:8bee:b984 with SMTP id ffacd0b85a97d-4398beebf07mr6934299f8f.4.1772123462245;
        Thu, 26 Feb 2026 08:31:02 -0800 (PST)
Received: from ?IPV6:2001:1a48:8:903:1ed6:4f73:ce38:f9d4? ([2001:1a48:8:903:1ed6:4f73:ce38:f9d4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4399c76b20bsm596856f8f.35.2026.02.26.08.31.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Feb 2026 08:31:01 -0800 (PST)
Message-ID: <64604c7e-5db9-49b9-b576-bbc627c8ddd1@suse.com>
Date: Thu, 26 Feb 2026 17:31:01 +0100
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] kswapd0: page allocation failure (bisected to "slab:
 add sheaves to most caches")
Content-Language: en-US
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, harry.yoo@oracle.com
Cc: chris.bainbridge@gmail.com, vbabka@suse.cz, surenb@google.com,
 dsterba@suse.cz, hao.li@linux.dev, leitao@debian.org,
 Liam.Howlett@oracle.com, zhao1.liu@intel.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-btrfs@vger.kernel.org, regressions@lists.linux.dev
References: <aZ5aAlDDpUoZxx_g@hyeyoo>
 <20260226162052.36121-1-mikhail.v.gavrilov@gmail.com>
From: Vlastimil Babka <vbabka@suse.com>
In-Reply-To: <20260226162052.36121-1-mikhail.v.gavrilov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/26/26 17:20, Mikhail Gavrilov wrote:
> On Wed, Feb 25, 2026, Harry Yoo <harry.yoo@oracle.com> wrote:
>> Slab fix is submitted here, please feel free to test:
>>
>> https://lore.kernel.org/linux-mm/20260223133322.16705-1-harry.yoo@oracle.com
> 
> No page allocation failures after 33 hours of uptime under normal
> desktop workload with memory pressure (64GB RAM, btrfs + zram swap,
> Chrome with many tabs, AMD GPU).
> 
> Previously without this patch, I was seeing failures from both
> kswapd0/btrfs and chrome/amdgpu callers within 10 hours.
> 
>   Kernel: 7.0.0-rc1 (commit 7dff99b35460 + this patch)
>   Hardware: ASUS ROG STRIX B650E-I, AMD Ryzen, 64GB RAM
> 
> Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>

Thanks, added to the commit.
