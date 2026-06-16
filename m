Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751BC39DBCB
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2026 20:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781643089; cv=none; b=Q+gTBBXoFrFkpRVs7gX90LzQ0uHIC7jhp+xWXIJHTMgnz1W9RD/g3PB+R3VM/cmIuslZPJ2TRI+y9oQLfAylP4rpEFDi5TOXLdnk2YM6TXomk7g6uzlT3wK9LQTiFPy+DaKm8p3xRESNmdgeZXT2Xq4pT4VgjxyCBEEwqg9X3OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781643089; c=relaxed/simple;
	bh=qqvgI8rvdQwsy+7G48Skg3XH+plfsX+hs9hWY2BSqmE=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=f9L2cvTgEE/WRhCfhpDWYPxuIe3cpI6/RjFgKQ0z7bXfW/Ag6sXAk+GiG5c55R2Hrj2nFq1tWF0y1RYU5FynoCuJeVYA/pw56XQk1B5tsUuDZrMdYUG3yKBde2iPZs2dcQKtXhyyZy+fw3qMwBLVDTxzLmdo9OxTrNkd49arYpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=i6yGth8K; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="i6yGth8K"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-69e1eba21a6so4086716eaf.3
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2026 13:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781643085; x=1782247885; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M+dpE/j7xi29wlPNe1Z59Oj5BFfMHneb4BxvwGVl0lo=;
        b=i6yGth8K+xHjGLSGYjoW1pvgN+WCbhurXVJrkm8By1kzteQ7KOu2b0xx69lovX4dP5
         gMsawAaMZJPvwnUAR4cFYB/OS0F2HBE0qeWIkj+ElYjyG5oyTwx8/xbuwmHUfr/jeTUp
         qIwb9iOKCtSVWKyEWsYWaCraSJ2NxKkePwOO4Ntv5o2IrfFPP+30LwyNpRu4iq/CF+GF
         n28+Dq7x0Rvca7nwQybIcje51mJ+BbjxyuSX345gTdv8TMEhbTqIej4BpIv3Vsvl+Dse
         x55NGPD0TkjP2MFKhOG8twRkGETjOiQEZkteaJK0s+WmbEPsBrWRf7qyY8n/ZnqRK9sS
         Ejjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781643085; x=1782247885;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=M+dpE/j7xi29wlPNe1Z59Oj5BFfMHneb4BxvwGVl0lo=;
        b=el0pWAwO657o2MdQvSgYpZ7CyxrNINHyM4PPKl5WonHH2XddryBTYNn6Rh3k3mK9wR
         aimZIqEaUjwK98ESzTcaIdDBoL75SZX1yMxv46kk9X4RMFJllmQ06p01/rqr14uvNca3
         pQokNTSqs+OG9VkZBvWkOZ6tWSppkpTAqMQQVzp6pzugV30Rt87sYazxxEhSF4H77mU/
         mzI4mg78+aP63VnobrwWRcPaUnkcOilOGUvlPvwx+X94Afcg5BVIe0DVYXLvIx8SpZmr
         J3n008Wi8FEYMBnkbltTirLCFLs3HENJp8x1KXvwcsb4hK6pCnjRqt2h0ff3YiyBf/TP
         Vpeg==
X-Gm-Message-State: AOJu0Ywg8wjlaHkXOay6PeFrzA4Lm0orDZnqNhcF9F67XUjXXqF/gTvZ
	6s6lmBLtoJ9Z34uNYCB3v/iavl510XYoxCatAtAOUyJh81sNW79ERLZqvEpH5+tk7UQ=
X-Gm-Gg: Acq92OEk4Lp4re5BS7nQaJxNQI2cMtxyBYvCWdx0+yz0EXzQCj9O1/rZsmQT0JwsN24
	XU6nEqi2jmDgv9c764h1nmVe6DZA7ASotNj3JK3r1+sAoPQmSlwsxVIdnUlj4wP6IkpHX4uo3gF
	bULJ+Sn2n32HRtzC/tixQfzrLMgGF+yYs5/yhzDP+xqt3z17H5gOcR1sB7JS9HkBahKclIMtJb/
	+Y0yTW/PIxwMlQWS2jLda9zC52DEAaGUkxIDlnFIFh0fWKraDStutNk3ETo533MTOju9Rq7mTom
	v5Zh8mPIzLZHEvZYPRFV3xaK1To1fWQta0OJQYzAih77W6I2fK3ExEygz2G5D4PpcaIxUXuhVKi
	uhuK+QutfuEWl2R44ihD30PcJPQD8XpJCoB8YuVztiWqHRRzNzUe2Zstz7GrGhoK/3gotazSthr
	31XUCEbZRIus+CDBmocmVEZGsKi1w2DSeciuLbZ9c7F65wtQ4OmRxiLn4k9Z49AN7Ib44myIuVL
	uug
X-Received: by 2002:a05:6820:6ac8:b0:69e:33ef:4b9c with SMTP id 006d021491bc7-6a0b5e0e16cmr630112eaf.6.1781643085197;
        Tue, 16 Jun 2026 13:51:25 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4430900e368sm2887576fac.16.2026.06.16.13.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 13:51:24 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
 Qu Wenruo <wqu@suse.com>
In-Reply-To: <cover.1781597506.git.wqu@suse.com>
References: <cover.1781597506.git.wqu@suse.com>
Subject: Re: (subset) [PATCH v4 0/3] btrfs: use IOMAP_DIO_BOUNCE flag
 instead of falling back to buffered IO
Message-Id: <178164308431.2260944.8317946373333928448.b4-ty@b4>
Date: Tue, 16 Jun 2026 14:51:24 -0600
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.2


On Tue, 16 Jun 2026 17:42:34 +0930, Qu Wenruo wrote:
> [CHANGELOG]
> v4:
> - Follow iomap/block layer code style to avoid lines over 80 chars
> 
> - Reject NOWAIT BOUNCE direct writes inside btrfs
>   The iomap code still allocates memory with GFP_KERNEL in other
>   locations.
>   For now just disable NOWAIT BOUNCE direct writes and let the caller
>   fall back to blocking mode.
> 
> [...]

Applied, thanks!

[1/3] block: revert the iov_iter after a short copy in bio_iov_iter_bounce_write()
      commit: b68d4979c88e31488970373f67ac79b4f6267008
[2/3] block: respect iov_iter::nofault flag in bio_iov_iter_bounce_write()
      commit: d5b58fbb2fd7ac25fcd7e1c14730f998a90b0322

Best regards,
-- 
Jens Axboe



