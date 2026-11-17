Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.161.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794935737;
	b=rHjo7XDQHizeB6uSGOOFxUAxl8lFvWegK0P9D8Mva8slg4IuRhz6Wz7U3AuCeZyH4ZoY
	 IzeRTJdydQ91gQr7zEBaq2B0yMRj81IPe7/smfQ9wUUo1DVgeIMMH5Oj/5pVC7MNY8Nnk
	 NgndF0Ezyu9GJiTDci6IUCp+yRXpwJx15Er1bBw8TuhFYqC0WSJHUCMzdoaHq28ww20NJ
	 KIzQAZhuWUkxOpWndPTFJxa+q92DZpO5eLExM8ounizEHeCtHA3p0+oyZGGwTcZKdKn2w
	 GbYW0goE3hzbElq1K+qGk/mrV3GmtgLBxwTAPaJ8eFqWgAPZVNkqIHt6QS/tmHeH1Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794935737;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jShjFF4Sq6gPLLl5+8nJzOEA7mRuIBIl4olxLWqQ+z8=;
	b=um6SyS7PxHuV0q6KldPw7LBPUIyrq3L559nhwc6AFcOWPsvo9BmTUSM5Qk2wnIorUHoe
	 wcGB3pcoRxLJ+UkmedY9+45UAIDlqy+Zt5VO8obn73YyjgiJumGAOh13MWahFbkKEkJrx
	 8suFH8j16D9rXrK9QfCvyzdcA9HCtZcPQM1/l5u6zQ147Jbj2XTyOLp1+2g18ut9vXGIH
	 RmctYIDJHavGPZcNrwk86XSVvwhnpg8StHlpivmEDkUspA4GvbB5MV3KdCZ/UdauLvWL5
	 l3JOBlceT9qom79MrzL3nLcSBTCFhagxPYkrB8Qfvn8v3Rp1uw38Db8udl67V/yo4dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pcHUbHHt;
	arc=none smtp.remote-ip=209.85.161.51
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABADF606A33B
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 17:15:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ABADF606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pcHUbHHt
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-716b58a4365so12039eaf.3
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 09:15:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794935735; x=1795540535; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jShjFF4Sq6gPLLl5+8nJzOEA7mRuIBIl4olxLWqQ+z8=;
        b=pcHUbHHt0AeMS0Ms4Y0DQuKxSTemrUBdN5r0OznUc+FciuSTjNMEdjRaM+Now0Ryc3
         WJiymazNxNDgj+UbUKCnA9bJMpycKapvuAsxrXvEBwMxOGFdfW9hnn83gHcQa7dl+6a5
         Z2KqEaHxIt9Io1qOYeJLqOXrcDcBg4kZQzpWZtiEJVWfR3f9lMCOyK5yhsPI65F+pyqg
         q6Y7AW7d48bzHMpzUJLYpbF+dEZuySOULVW7Qt0MRa0sKLS2YBK006SP7SDeiIb77Egb
         WoPGSyR6JSmusBvRCT2txTEQl7O2nahpmzkGpqHu8xD0SvxOoXRVbYaeFylg0ELGUooJ
         1kgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794935735; x=1795540535;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jShjFF4Sq6gPLLl5+8nJzOEA7mRuIBIl4olxLWqQ+z8=;
        b=avZDpsCBH/J0cp9ljBOoUYVpmWa7jSdta396btIwJrEE/tc9UeX7sV7We47EC2E6+t
         nCoUhssfVqfhVrIbKheQVYDxqHvGHr3TklJGO58BHvxHZ6jakrdtU5TPwZSCawBvL7xh
         VcEZd7PE2UG+DHq+xe1qrlwkTpHMQ84svUaK3rRcZWzP2ye3T8el808rwP6TpfYUbQVC
         1N96q4/K7urBWA06OyAWSSNtwqrv29Mjg+ww0/34rcKL0rhpUtLOxKI8saxIPmPZrvmS
         2ie0bYuZKQ0tddnfw/ulX5TiS51OYq/KENq3A6WaLvxYB6DAu6cHjq7W3s2r6wiCo2gx
         x+1w==
X-Forwarded-Encrypted: i=1; AL+hErHvcFb441PL90OyKpGrhELavWQl7X5ZEfkdHmgDIBqLfVRGmudDJzvwik8Cx8yALvZ81vyMLuMz/jDO2A==@vger.kernel.org
X-Gm-Message-State: APuU4Z87BJHaKlvW7XS/W8oaPwjuEM3nrI8810ay7nTN2rzYdysDqG8w
	mpom2eaoNpGDdZ5R8KgcmGCVbeBdSLny4okqNRZ6cl1jkdfdVywC2nyb
X-Gm-Gg: AYBFou20QqG3ydz7EgD3okb/NCFalqKzZxsNxRg/tK7MFU+Q/Ox1i1GAXBdl52hJCNm
	wVf9+KoxXImezrbVNWqCXHkNLQOYWkGeN2JjiH8MlhKhJ9QkAOldIxd6fsRBg8jvc0QlgO/0+qE
	t0IzWuBwS7N8phb3fuLx/MgbrO7y5wusvfzRLaqhGNmw1XNVfqV+qJQ2o5AqdZN03G1IpJ8ees/
	u+Y72YuhezXFIXDx/AuTWA2pNsaL40yt3+1ITd87jnM3aQdTnQflcLfaHHMJrs9ei6oAU7tHOvX
	ys/5Bd8hQgAODoGEWRJbRgJKy33ZtDZLb4dfjnkydoymiEZc7jLT5HyNAiy6/gsFmJEojnBiRpm
	oKVoBhkxuF26o8taZi2nSe5FdHazxQLs7ZIwVYwNeTEEg4CLh0cCHUNFIONYbhfx2dhqReHkzzY
	Z/6j5CBL2j/r3XtnZFrBs297UKNC8Oig0CB91OU3M5ZQ2XbD/jTQKwOkUp0eLqL+z2kCDr/JHNa
	SHltEaWqREF53HuqBTfPtPzdzgCFf87UcX2FRo4hXJ3a1K3gs5FlaFiK4ItTwE50TpERdEzrcGm
	TKK0FbR9u4mObjV28pesHg==
X-Received: by 2002:a05:6820:2203:b0:6cd:3ffc:ad01 with SMTP id 006d021491bc7-71ace39b3b4mr7492285eaf.81.1794935733793;
        Tue, 17 Nov 2026 09:15:33 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:15::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-71ab42cc12dsm11351357eaf.7.2026.11.17.09.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 09:15:33 -0800 (PST)
From: Vlad Poenaru <vlad.wing@gmail.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.com,
	linux-btrfs@vger.kernel.org,
	mason@kernel.org,
	osandov@osandov.com,
	josef@toxicpanda.com,
	fdmanana@suse.com,
	boris@bur.io,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix bytes_may_use underflow after a failed tree block allocation
Date: Tue, 17 Nov 2026 09:15:26 -0800
Message-ID: <20261117171526.1083793-1-vlad.wing@gmail.com>
In-Reply-To: <700e302d-c85e-4bd8-84b1-0e6eb8565740@gmx.com>
References: <700e302d-c85e-4bd8-84b1-0e6eb8565740@gmx.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, Nov 14, 2026 at 08:05:47AM +1030, Qu Wenruo wrote:
> Can you simplify the commit message, not only by a little but by a ton?
[...]
> To be honest, most (if not all) of your commit message can be extracted
> into a single call trace graph:
[...]

Thanks for the review, and sorry for the overly long changelog. v2 will
follow with a much shorter one, built around a call trace like yours.

Vlad
