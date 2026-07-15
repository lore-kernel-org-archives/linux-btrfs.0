Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3F443C7A9
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jul 2026 10:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784112089; cv=none; b=hV1DQ19c5Bg2pSaKMAmcSxHwrNJ8kvPBPHD6Avz493HXaLi1fbaMIV5v1qzclh3vqS6xIPSkueKryW5iTeoBXOjsrhf5hjzetpyPhPCq5R2fV8iPYsNk2Cq/h2KYAUoZPctHYrVIWCEdvCNk4V7x2dy1cMbh1u1KyxZLEkwcOrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784112089; c=relaxed/simple;
	bh=PHyClpK9phqHGDVTjsNdB6YNa41U6zj5hqmEpuRbXf0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ocA6Zq6wOc12aiSVU0zLgqetIqAZOIasjpnzj/q65GyDaH0ii4+T1aZDdSfq6zU0k2p9OS6nACfMzedUCc7C713Jj5MsOyqIADx5W54SuUb+/LqIQkCLej459qsjneS2rMDy2++Y+uAdM/gmYLT3xUxhr5MrjTMtmfw0zFqbv18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nvikc1vP; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nvikc1vP"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-84536ecfc5bso1820852b3a.2
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jul 2026 03:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784112088; x=1784716888; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C1V0/bjj6Tkqz7TMbPWdzZqfQ4IAEFe78FNpOzUj2Yo=;
        b=nvikc1vPxUVho3YhAbgSutmUBzgLDJBLFI/978wlarjecmmpb2QPfD8o4suK44FAfx
         xyDGqz9NA/nXPPaw1i2OlwmKDYSxFKFVu7nIduQiKtEgUd8eqCaJOB9sKbaLVxtswlah
         TLggoY9u1/CKWTLz4ZxmzLo97tAyAKTvhHw5qPXJpWuljzBOHvPjmMljubzSISxwTYy5
         M/kREFW4QaD9HzCrAsm3vI7MhpsJydDWG2K35Z5ijLZy9ikHAs9ojE0ga6/WcdC+cgHo
         vauGjVs8TONu8bBR94J/u1EUNYNq8DyLvdH4Mge8y7fEZQsXG5MebT7i8Q/3NX0lHmhc
         0u8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784112088; x=1784716888;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C1V0/bjj6Tkqz7TMbPWdzZqfQ4IAEFe78FNpOzUj2Yo=;
        b=PdXqp7H7ynKU9LzeFLJOd/5QYSPiY1bfPiwDSJhqPTlJL17dFJzBEkwB1orlmvdx+R
         WA4nLgGFzwcyqG++lSh2vYgDQCl2ypYQZw/67CLJTN7q8dUPROa2ExgNZ+zA2z9rNtnx
         P6gInlrwTvmDWi4bnhCdz8FjIeWA9/TxA5RKRqMGYmz1bVVz8W4AyGP5z31ERft0oZmI
         L2oF2EZTwiGrec4D/+A+xw+BrSAruSaYwOLi+2JdoBUu+J2iCSZE4vvzqEg6Mll3eSUP
         hiUpln8jUVlNVOGUHURb0q4A0BZogCfu/4L0r8kraq4n49ROotGGCFQVvflJjUX4ONFx
         BxLQ==
X-Forwarded-Encrypted: i=1; AHgh+RpiivdIWaHPEtqexjsXmMz49rgBtViycr7sortFdkpExowsHdcQPxSlXAeSOVqDRJ7FYqmsEVqrDa5YKw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxMhWV8w7dp3c5hO/o7QQyEtzXlXF7jVOCqDSZJ1F2IXc3D1NN6
	ssYsklrvDZr9jWiL9VBHP3gNNFqel+IdxbjZlQo1B37CxryMZOrfVo8tN7gbLw==
X-Gm-Gg: AfdE7cngJI2Vyc/OJcTBBMPDA0IBj6uis8v/Nb+NZDkIodS8GZ5wQIFLWWutzsyrb8f
	qvbUFHUuOI7i7WsS3OQ/y3h0yOIL9FMf+3mKHbvbw/0RZbB7RMbwaLngiKkd8TvdeJmqLapt5sU
	6dhLRZHZe3OyaQOOeX8/EgXbJ2UbZcgzw+UfKKuMlv/G2XfXFGz3QL+EA7F0nMvCR8aJk6GepUf
	6fRX8dYQy8wNK55Hhlr5ZHDb8AP5sMjiZMFgd8tH7SdMR6cg2dtybcvwSm1LMYx/0prD7S2ltqe
	MgLcnpShNXBezp+ngw3NAHgvt9JnZf+q/a1AJ9XzfNz4Y39RSjHyRyUeDZwz4uETGGridlTMxpe
	/UfUVEb9VDopDTXCfLnTrW6rFlG8Dlavr7qVci9rWMMwRYeixqeFs067ZkHFPs6L+r8B5P2Uign
	MznAQnK4VAvG44yhvluHzjLOys9Dnie/MEGR5ZBCzMZy7gFto/0DBpO96q1PTzh9s=
X-Received: by 2002:a05:6a00:3e24:b0:848:2f84:f435 with SMTP id d2e1a72fcca58-84a67394888mr2131198b3a.78.1784112087804;
        Wed, 15 Jul 2026 03:41:27 -0700 (PDT)
Received: from [0.0.0.0] (ec2-13-113-80-70.ap-northeast-1.compute.amazonaws.com. [13.113.80.70])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84a4f6be65csm2940449b3a.36.2026.07.15.03.41.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2026 03:41:27 -0700 (PDT)
Message-ID: <130adcc1-75e2-4c14-8cfe-ef5b2719814e@gmail.com>
Date: Wed, 15 Jul 2026 18:41:25 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] two raid consistency bugs
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@kernel.org>
References: <20260714161044.7330-1-zhangboyang.id@gmail.com>
 <67cff567-1070-4908-a253-a8907d237734@gmx.com>
 <4289be1b-285c-4641-a7b6-6b8e66f458c6@gmail.com>
 <5eaba968-b8b9-4705-9027-9169942e105f@suse.com>
 <8e02253e-2bd2-4ca1-8def-f91afaac4cd6@gmail.com>
 <8248f43d-d6ab-47e4-9ed9-65bb5c281f4b@suse.com>
 <65a774c8-9019-438f-ab8d-81b458f4f53f@gmail.com>
 <59657910-edd1-4427-8141-ed57d7ffdbe1@gmx.com>
 <ebf9c527-2181-4afe-b88a-4d24fda6d8d9@gmail.com>
 <4674023f-1b70-4be4-ae0c-c65669901feb@gmx.com>
Content-Language: en-US
From: Zhang Boyang <zhangboyang.id@gmail.com>
In-Reply-To: <4674023f-1b70-4be4-ae0c-c65669901feb@gmx.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

On 2026/7/15 18:11, Qu Wenruo wrote:
>> That's exactly what I'm doing. I'm not requesting devs to fix this bug 
>> immediately or implement my fancy idea. I wrote two test cases and 
>> hope it will be helpful to btrfs development. It would be better if 
>> these two test cases can be merged to test suite.
> 
> No, we will not push for test cases without a fix.
> 
> There is already a known failure, generic/747, and at least I'm not the 
> only one regretting pushing that.
> 

That's a strange policy. Is this a btrfs policy only or it applies to 
whole xfstests?

>>
>> I even wrote a draft patch to fix the second bug. However, the first 
>> bug is not easily solvable. So I had to discuss possible solutions. If 
>> possible, I would have written‌ a draft patch for the first bug, too.
> 
> This is already what I call fancy ideas.
> 
> Anyway, this will mostly just get yourself ignored if you really choose 
> to start from fancy projects.
> Those long existing problems are still there for a reason.
> 

Ok, the first bug is a bit fancy, but what about the second one? I don't 
think the second bug is hard to solve (if you ignore the first bug).

> If you believe you're smarter than everyone else, then go ahead, no one 
> is going to make you change your mind.
> 

This is a strange accusation‌ and I don't like your attitude. I never 
thought I am smarter than everyone else.


Zhang Boyang

