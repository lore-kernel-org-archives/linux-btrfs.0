Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C90C393DDA
	for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2026 06:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779171509; cv=none; b=oWDcZv6EHqV9VPeUT2bS/0fNsUnG2IKQXYT6BVt61rKvFtr10v636Hrrj+6WdcnkEEZyTgdbjIgLvSvuR8+9cEeA3MEJMcuwQgZ+MdL+Zp1moMyz88NyDcF8h9hlBwt5uaS7f8vWBxXCmWsbK/eq1H4XH5PfWkMOkFz9ETE4VQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779171509; c=relaxed/simple;
	bh=P40yBmSFg8vv4hsr/oFplKZ8V4wmkdemPNXjCPuU8VI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=kIzEMbuD53SfLew27C+yFpXA5L8BcCPK7RWc35Rpe6DzkNGeEhsJvTIR1WiV2KH7LKfPRmEOdTn2CncdOf2/i8eZyzO8yVZNSPJz+zgk5MkAnoYeSrpT01NwRiU/4GSsNGC5c5m5Bfz0zkfYo9cJ/JO5LEsbQkdIeFI/ZpR6OCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ao+N2LYR; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ao+N2LYR"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-835399c11e0so1376602b3a.0
        for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2026 23:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779171508; x=1779776308; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P40yBmSFg8vv4hsr/oFplKZ8V4wmkdemPNXjCPuU8VI=;
        b=ao+N2LYRoVP4U/dIrbjKvlnbwMbiuCQP+GLyKhosa00aUx4QYUTUN9eVdPhPCUxTlg
         8mpADQyckI41BwaR3PsoNKB6bcskBODN3xCk8TFuMIdexmwkTgvGmYKRqnm3SZw2ONmK
         2mgbVxq/M/dzntVh7ak8+yoFkGpZs59CTgmesf1vLLXYtzg4/63/gamK1PgcAcK9gdZE
         uWaI8TIOM4kJLBVAovg5NnTTg3AsvRWAys7HtOORnqfNnSLqsifViUfDkyINLmdLIQ+h
         /LYXF6Xi5ey67LUq+kLjcJ84NwWfhGPU33S0QYsyHZ0c/UgVN8rQsWne4qJTxMs0uumG
         v5QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779171508; x=1779776308;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P40yBmSFg8vv4hsr/oFplKZ8V4wmkdemPNXjCPuU8VI=;
        b=XxA8P5iqrg8WWAUkPQUpkJoksHwVNx2+JOFHKE8FtcHrEToap/a1zcT550r6R9lir/
         XrtjIlAJZDlaZhcuyMxWMt/9yKTcr0xalZFK0/Rhe8iAaQ8LEHmJ3zjVjr484vnCuXgy
         cnA2Q6HG090yKjBw8f5UzWVlEdl23ZKKGyL7pyVGJoa0aJFo6AMeDGtfjgFV/cbc80kG
         uDbnGiTMZzuGS5hosqFDEvnLqhtM+ILIkX5Qw18nhOQz8km7V8UQSqbvtD8dpWB9KnWf
         Mr4gNwvQ52fl7YlJ8RdXc2YXFrX7Ws5mIdF47V8OYpBECv2beLYL7/iYVpC2AOnTkwdm
         W5XA==
X-Forwarded-Encrypted: i=1; AFNElJ86UDc6R+zQx3GWY/Yd6aOsp/G/hQiJ1w2k4tU6AG2xXc5ndClO73l3T3tmChyY7tiYF4hgFd9X4ZnGIQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwzJncFprWExdim6YPzhlZlRkGMl3LJQ2rmt6qyyYvEi0ZyOpM4
	ajyYPjhoOP+0aFpJL4EnV3pkVTfL0BSH/aYzfJ2lD4lXp+/0PpN1WQOe9EI+/w==
X-Gm-Gg: Acq92OFVpxFDBcDKAP2Wv3iN/jI+0ulGPmCPIX+/jQxohGifkL4GqpB66m+aZkNCFf1
	MEe/fVVgWjN35F6Q2+l0GAq25DmkTZoMUDH+KjIJfd+eZJgR0XHQSRrXbIKB+Bo21M3gLhdtsZ/
	urHxTQsizwoNPIc76x1q2D+XEyaOG84CPehEN8aw03MmWmorzsjtScQQyuRcRcOPq43FTDZ7Lwz
	6ZASCEkVKW5jdJzlgMW3/ajhSCer4PkW41PwXTfBwsBglOk2ex0zpdOLZIVt7U1OouEzuNfIsXk
	be+qItUhcgN2oMNedtYQm8njRegeZMAsWuvf7OhAu5qtgLQITPbSW0A75ek3SnZaoKzxYPhRx8o
	0ss9s43OPY0b1HE1YR6SBQYouX483FVIldA8+vJg/Lzuv6bOhA3liV+MQrffrdZs7PZ0NiyFaMU
	aUfjLAHJbRQQPBuNTuLSugnL27JzaBMujbqnZ4G/iv
X-Received: by 2002:a05:6a00:3915:b0:81f:ac81:d597 with SMTP id d2e1a72fcca58-83f33a38df2mr17304957b3a.0.1779171507707;
        Mon, 18 May 2026 23:18:27 -0700 (PDT)
Received: from [10.203.107.185] ([129.126.14.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f19664712sm17004315b3a.12.2026.05.18.23.18.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 23:18:27 -0700 (PDT)
Message-ID: <bc32c185-b573-4ed8-bc15-f8fb402a2ff4@gmail.com>
Date: Tue, 19 May 2026 14:18:24 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] btrfs: inline enable_quota helper in test 301
To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com, fstests@vger.kernel.org
References: <cover.1778632843.git.boris@bur.io>
 <3234af372b0f16511aa5856aa7a3a0ca28397fcb.1778632843.git.boris@bur.io>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <3234af372b0f16511aa5856aa7a3a0ca28397fcb.1778632843.git.boris@bur.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


looks good.

Reviewed-by: Anand Jain <asj@kernel.org>

Thanks.
