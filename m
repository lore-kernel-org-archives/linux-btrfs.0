Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B074392C39
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2026 20:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781642897; cv=none; b=d+fn96VP7nzE3brjKR1OCEGDh6uL8GbYNYlt8jqHNqkHKc4j3m6PP7E5T7cOqM8FWMvnoNe1iY+iSwNmXxhDbXxEf4Q0kM6hfC3H0mTyCS4PZFSNHhNK+sUyRhgCr91byE53r2/4LsAySzN5ovT/jixUfY95SIXvvkQ0pBipUp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781642897; c=relaxed/simple;
	bh=Sw5kaEYR+kOXbMOw6h0GSGzuO0FP6TMElZAcRsybMMk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XDp1PpfcLWhF5LIeTq5qOl6jy6z40PRCo84yc1T8i0kZixpphsefWpTQb/MjYZ2OOdek8MmzKBti+2EpziBOrmPrFWNjmWXiga6nxJy2HG1EyB67ymtOsumcmNRJWquEizVlp6wcuZPKxCJZHOLoGb3/PDQyq4pzS+7Oc5AFiEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=sZNhXX9+; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="sZNhXX9+"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-488b3fd8d0dso588829b6e.1
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2026 13:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781642895; x=1782247695; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vHjBmEtaY4MZyV1ZaXFC26z+hDeMIBdFKC6hpsQyryE=;
        b=sZNhXX9+cpbkSuQrhd/qkVQ9KMH3MK5AEqY2ezI3n3tT1VZzI+G7CTD7+R8ZgLGmaH
         hWaORWu6giR94C52lhyZfjX7iTve0DPwv6YIYH1jVlQ5hAZ0vj6cLwaFHwjFRIAetijA
         9w2sNQewsF/ifGCOHm+Wvg5+cmLpbkU8eurUQyGiJlz/R3ilAKxEyunoMSjeaZGqQnby
         oIvGV5C67Kl7t01rdI64ijkrzxsltfL88+wBVdLcjMrPO1b2V0xqg+SvnLQ7ncXp0uQ2
         uTaq7SHsZNLiYSAOOy7V6E+tzOFxF3wzNECrwH91h3AW9p0697UZNO8bcDXFsgt9DEUy
         y4iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781642895; x=1782247695;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vHjBmEtaY4MZyV1ZaXFC26z+hDeMIBdFKC6hpsQyryE=;
        b=j1vPr9MUdUUoWp8UTfW+eZvbfjrdlneDKE9pLZrnZn9jCJjVBrVnnxCZG4ChAbQ2zE
         5fL5YTg8BjKvzsSKFQcVHBlkVXrOTrr/NV6PVZ1FZEi9HOjsXxdbxAyHtXyDMY96jW+c
         wB+u5OGao1pwfNG8+yHR/TWsrKbhmc++B38eFo+RpNlYRBt8rAqd1Dcu1+soIrdl4Tbm
         BXPy+1onk5blqr6/Q4TKBlcqOgicqCzx0P9tIhBFuUdlmr55oXyUOKlspcMjnu2rbVnT
         fqwMd007hkPP6kH/8H1osGPz1s9CNQmiVRP3GRPjx54/yf4W5D9rg6pvUQdAgL44Tgph
         9mOQ==
X-Gm-Message-State: AOJu0YwYDmeBOyCNKR8LKsQS2FP5rfw0KnOM2QTJQIbM1Ypa44B75/e4
	t9Vw4gK4VU7oXqr8P1HDRtrjRRF1kbC5UyT6rvoZ4bWhj+sQZa8Dg9CPrzP++hbUC0o=
X-Gm-Gg: Acq92OETMidU21q2a9QrCDsrU+lF7HN2SWCLvzHHcdJubMRjojUg8YKLbI+3+Kosoce
	Iiae1FlGciyRRhiECyd63H/JtxT2UmWLfbZ7EQPNg6YGUjso/VFjtG/lgRXof+pPkcKVcdYHlZk
	kXNJRIeNsCW+U86l+cIeqRn8yn5/HsFYc68Q0rCiJCvvY5h6VTZJoFoGUOvWrfMlq2KVm1kyF/6
	myE2SLl55jcg1Oad3ACNGaUqYYSdFvasHHUD0RphAGq3R9qpyameGQpzqTriktmr+bzL8MlQTlK
	zZXgQQjMpltEgURbg5hlmp1be2Mj3LuhYz/H9m/1RMqvpIlVyNx3v7MnCb96Twq8puqY4LqXpQw
	QJM63JCjdJwyr+9JZia6St/7WGZBTC2tbbtu7N49VJ/pVfm/I4JmqaN3U5p4RFV37uq2+ty3WD7
	RfS08LqJ9N2PU+8A/DtIkRs0WMRYc6lXfbgjq984QbdzwscD2IcY/xRlOcLiDsAvpckmr8MfBee
	tmi5WMefA==
X-Received: by 2002:a05:6808:f89:b0:479:dc74:3696 with SMTP id 5614622812f47-4894285f7a5mr987811b6e.7.1781642895670;
        Tue, 16 Jun 2026 13:48:15 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4875dfe4a89sm5237391b6e.18.2026.06.16.13.48.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2026 13:48:14 -0700 (PDT)
Message-ID: <e94bfdb4-6932-4cae-9693-6f0d6f51aa17@kernel.dk>
Date: Tue, 16 Jun 2026 14:48:10 -0600
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/3] btrfs: use IOMAP_DIO_BOUNCE flag instead of
 falling back to buffered IO
To: Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
References: <cover.1781597506.git.wqu@suse.com>
 <ajFFYT10i1dvAy89@infradead.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ajFFYT10i1dvAy89@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/16/26 6:45 AM, Christoph Hellwig wrote:
> Note: You'll need to include Jens for the block bits to get either an
> ACK or a merge through the block tree.

I can queue 1-2, then Qu can push the btrfs change in once that lands.

-- 
Jens Axboe

