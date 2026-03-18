Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E2A211290
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2026 01:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773797579; cv=none; b=fqYDMPXlqNBx0bVDA2HoLlVyC1h7gSK02K2Ezlh6UgOszOQzxDO/rhw9JPYoQuLsnvxYdkzM9DvK2Q4E/7UtSOtcbTlgyKajKiksZvvICktPl9EY6l6Unhw66srHxExiWpODm7uQMykWfK6ISegQQnZeXzsieC+n1G9UbcAEZP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773797579; c=relaxed/simple;
	bh=GRstfBVXNlbiYAxkAU3SHSfOiFMDR6YnMSauQ2q6p+U=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=tDDLhYM35Y9sYCUrAY/+CEpZ2ltSFVCAgH1sBe4/+gOtqnvC56Lf2TwUGU5IGxZ3LdOa4ITRlbj6Ytv8EH+xOZgrPPTCxP9eCtMUdGMcbxZkOf/CMdbGhtBemLIEk7YL8vJMc9Hq/tMKyFeC6ev7Tztz+bQhH7Fz1q3FOUgh60k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=bPgpq7S8; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="bPgpq7S8"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-67934c83063so2299574eaf.0
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2026 18:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773797576; x=1774402376; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HLfhLlYzRdtJlSsGGbMPLpW3sMVv8KiDOySz/m154e8=;
        b=bPgpq7S8OX6ruhD9/Poy0Ac5fuL52BD8oidqgl5OTrOo48Gu+gfrabpg4ViBnH0TjK
         BK1DPrAv6mCcrdv+3K/VnrqasDyUwAVNqvXvyW2wOnUAPHyEnAQakMSiB6gm7y2hbG8n
         EdCLNkbtKsKORt6N8SpAxruDSk2f4seFgZgWDfv/3MD5hpZ/or6fWeGK/mvTnrtMj5a9
         uezAR+lzxfUbvv3y2TxY1WHE7L+9GJe5S8Eg+Qw8mYoSK6JLhCpL7atRi1hhYDt279q+
         WHjihurxJxJ1PFKHCzlLctBbBqkzZEByjLXI4CefT3CROCCUhtEZPqslAtc6qZhYserE
         /ydQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773797576; x=1774402376;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HLfhLlYzRdtJlSsGGbMPLpW3sMVv8KiDOySz/m154e8=;
        b=We93l77d08TGlSUIWNzz3b3iFeDKbrJMnVL88J8dGyS0oyCCXiajvSZT0SboF2A9f7
         NDHR8+qvXWC/4NdCWyvDk3OPvfkP4u3vsmjrn2cLWrMkTv2pDNCxT6npvco3V4LxbUJQ
         ZRBrObDmaTxVnioBL2J+f3xhGev2aT6e8im8mqWIvZziDk0NpGi1YMaNBLjpeLWqqNtB
         7OlUAodSW6Enb7k/Pz4egbrZrz8IlrhkjEaW2jACWLSZiui5v4gfJ0oLAK8Oc0JXw8/O
         /JTfluUkuXj9sqDCH34M944nkx2LHa/PZ4oykg1r7Xe5P6bnrtuBOufbZ6RaEQmOwLKA
         PZgQ==
X-Gm-Message-State: AOJu0YwD1CPJMdHlSXAy017WA8617rbue5fPIUvjRonrPkibYrKlo/jF
	1bDgbTPShasBsdJMfykDo8zDV9n+jGPme2odEg5cIAvQsotCy6Xowuvqg4ymgRxtWuh0bhxJldJ
	QwE+tDtM=
X-Gm-Gg: ATEYQzyDQXDMj4MAjtmpR1uQcVKQwYF+GDQdhTfEv/sclgbAjfxAFM7PDufViqqZtDq
	wUs8Jd9c83KwCMstJ2QjFSjQ9Oq4pANH5PnfPYCDF2JIoIHck3/7QKNVd7nr2r0fZhCiw0PyHOT
	XV6YoaDN+rdG7rWL2+QkvkOntbYkB621IQwE+58680rzuqa3yKIUvReTOX9LNxxqpwhyDlUnK7I
	ujTOg5285avCzDzW48AcIEszApsQS82jSVdATIsqGOouYIymzrh+844lOuRxzqMciWAOEsyvi7o
	DuCHIzvqwEE15nHLMEUqMWxyfFh5bKk+K9BfSoacxGWLGZ8AgMCNkwnD9LgBs1S2Yv0pFAIORR+
	vABxytun0NE+D5zdzbf3XfE5ysEbCHrHM0Q4X2qACzvxK6HTRwp/4Zt9HB3QvBYDB6Yz6ikCMnI
	9WhbAerTBMhEd2yM7gec8UD0V3xXbLsa3WAN+WpjFb+uGsaiy/SWjnyz6TOflG1EZ1br91s/Ryq
	gVMqaM2BwnwxdU=
X-Received: by 2002:a05:6820:2d43:b0:67b:ba75:3eaa with SMTP id 006d021491bc7-67c0da9512emr992362eaf.11.1773797576434;
        Tue, 17 Mar 2026 18:32:56 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41bd288d791sm1441221fac.7.2026.03.17.18.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 18:32:55 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org, 
 Qu Wenruo <wqu@suse.com>
In-Reply-To: <bc2223c080f38d0b63f968f605c918181c840f40.1773734749.git.wqu@suse.com>
References: <bc2223c080f38d0b63f968f605c918181c840f40.1773734749.git.wqu@suse.com>
Subject: Re: [PATCH v2] block: reject zero length in bio_add_page()
Message-Id: <177379757513.1036731.13768359483777366854.b4-ty@kernel.dk>
Date: Tue, 17 Mar 2026 19:32:55 -0600
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Tue, 17 Mar 2026 18:36:34 +1030, Qu Wenruo wrote:
> The function bio_add_page() returns the number of bytes added to the
> bio, and if that failed it should return 0.
> 
> However there is a special quirk, if a caller is passing a page with
> length 0, that function will always return 0 but with different results:
> 
> - The page is added to the bio
>   If there is enough bvec slot or the folio can be merged with the last
>   bvec.
> 
> [...]

Applied, thanks!

[1/1] block: reject zero length in bio_add_page()
      commit: 643893647cac7317bafca4040dd0cfb815b510d4

Best regards,
-- 
Jens Axboe



