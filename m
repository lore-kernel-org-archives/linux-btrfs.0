Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2539E369D77
	for <linux-btrfs@vger.kernel.org>; Thu, 28 May 2026 23:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780011092; cv=none; b=FZgK0ZythkpOyaRYD4K5kkBqA4gI9Xrqds+Vbdb6rMEMRu31zkMnKtiD6whVDSnwtHTO12eyj4Kw4gUbxYDdBeGdgwMdgF2kzKoNrLwJm1q73C4kRXojMItMUr1BjDDqYtyZpWX9pm/uE49Y3Cp85OEtHCLOxhVYIBCyk+PwZSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780011092; c=relaxed/simple;
	bh=lqxv8nVHPEdwe2QwwpE33htDLQMxjsFPk2OHMI4P2Sg=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=hfBddnFxrfWThwE+24UOxBQ40vfs6xp2jigEk5KIJiUqr5rclAWb3JrxRD4xZB5g78tC68Ui8IE3sjdbEOrQV6BEwaGoCKZtUHSeGIcpBh1j3SJSoxZJ+yKDpSmdENBcyNdHWjSBIc5bh0wnGDvAswzYEkxkuZcPTIZyuwyh6v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kO1zR5SL; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kO1zR5SL"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-83d31ac4017so6683724b3a.3
        for <linux-btrfs@vger.kernel.org>; Thu, 28 May 2026 16:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780011090; x=1780615890; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:reply-to:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=lqxv8nVHPEdwe2QwwpE33htDLQMxjsFPk2OHMI4P2Sg=;
        b=kO1zR5SLHrqM7dLUL4kBg3HB4HhvocZhBEAk6jjGwvaxchGb3k3tS8QHnlS78MaJNk
         SaOYLkQ3grAzMLMmvzi9E6ybzsGfc/WcA8qEI4UyfvNiHgCB+oOAMFiJrGSYopCEjgJY
         d6wRPq8wpfnFR/aXjgnH79oZp3MWRiQSMZb0B2mnOmsEw/OsNRZgoK05Zc5REA+0Avu1
         oX4N5SM35S9JvwbMd4TzKm4cp1uuPLq2FY2BPYzXKdM5RYMLoHzNHYOpB3sunyeLESk5
         r+iAki/HOMSGiH08yh+1U87fzDYbgui23Gtqv+A/PmNdom3/r/8rKtGUiqF/+fKek0nn
         /r8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780011090; x=1780615890;
        h=content-transfer-encoding:in-reply-to:reply-to:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lqxv8nVHPEdwe2QwwpE33htDLQMxjsFPk2OHMI4P2Sg=;
        b=FGMkjsuwkzfTxVIn9Yk+j8JwdytIEqMSLzShXCuZS0WUU1x41JVJClEQOoM1lFwb/H
         m6mfa3L4hFDoIvNpbDPWR5P7NjpQEyclSDm8BwvsWpA/80gMb82YeQOz8RY+ypbUugda
         6JY90Zhp+FVZWyESrvBJlVcTDtj97sjVVCKfWPQKfubUqR6CdqnuyEhQaoLosJdfLrUD
         E+Vq4Jt3Cv7s4oGvQU5m7QYx8lqb/g0q2yoXQPgmwuxaO3IQ17NA5wzvtgIdO1q65OkN
         5f7trxy8IGg8+ArarKuELd7bHxrGUw9Cdvt4dd4sXax4pCtK0sFJw3aDmdjB4WwJ8nPM
         cjdw==
X-Forwarded-Encrypted: i=1; AFNElJ80AXU/c9bp+O07IsxrltM3H+xOqKMEkYiECTO1mUwuByLJa4lgPYeOD+b2LyKjEWhl2BOWJ0CMZJxAQg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyzrdnSk+v7ffHRCx3UK4tDtKSaTAMNbtSnTzTOG6gptIGVQDZH
	258oD/pdSYEnoUzPD3cs+sqUFFpYUz8+v8vLT28SupkKuPUN05h3foK0
X-Gm-Gg: Acq92OGcJ/XhkWVBnweUa25CffWbYpeK9Rf2Dd/XqFGRrzcl1BlfQSk64w/67FWI2f6
	1LipfxCUM54pSHi82E4azLj8kvT26zF6hE9twbSty/WaytJO5vHFdQm4/6SHd919VA+IVZt2S0K
	7e+kFJ6RJUkVa6Wq/PXs/uBqblywuKgpFTg/1JxCdybd8Kx6sr87S9Wr9quM9H4Tg155ifmvov1
	9U5h15/9wG9BjhwHnKWqk+RDKxmoMAPs7R9Kg1HL+mBTM5C4q70t1xUd6CmfY/zUbpC1yNXaonV
	Ig2ECuSu8A0bQFIXTEHFbc+nO14r6zoY0jlYsozl0ItxPpLd3HeSQZuqmv7Y8Rep4UFTM51vCUE
	yRM6Bq9Ajr7RmYGrE2tQklTUzwO9vJuS89rlJDTUUVhfOPqSlmf9co0v8v7l+bEXWWyGyqP6aoh
	aEViy2bpNfYhggvvDv9oVNx5bucTx7mAtTN1TqMZuO
X-Received: by 2002:a05:6a00:3d07:b0:835:351c:f236 with SMTP id d2e1a72fcca58-84212ba1e7cmr295411b3a.29.1780011090452;
        Thu, 28 May 2026 16:31:30 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84213121564sm76760b3a.24.2026.05.28.16.31.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2026 16:31:30 -0700 (PDT)
From: Anand Jain <anajain.sg@gmail.com>
X-Google-Original-From: Anand Jain <asj@kernel.org>
Message-ID: <a690deac-20ee-4985-aee4-4cfd819fbd9b@kernel.org>
Date: Fri, 29 May 2026 07:31:27 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] fstests: remove dio related target file to respect
 mount options that only affecst new inodes
To: Qu Wenruo <wqu@suse.com>, fstests@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@suse.com>
References: <20260528111659.87113-1-wqu@suse.com>
Content-Language: en-US
Reply-To: asj@kernel.org
In-Reply-To: <20260528111659.87113-1-wqu@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


In the patch title s/affecst/affect/g

Reviewed-by: Anand Jain <asj@kernel.org>

