Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8CA374728
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 16:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774887059; cv=none; b=e/9aq1CSNk0eCxc0UCv/YXHoMV1G6tGnfS9mGbk2lW4k17ijMTMc5YRgZNFOYCHKk6gsudBpK00MxE/TYpc+mNPNUk91sITsdFiSl1vn0kCQ3WTxR/f6m7VDBlUiRn8Ns3GKidyUjkDEhVU1UXcJdLiEMaUUCTvtIM2jGs/dg6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774887059; c=relaxed/simple;
	bh=2+WYUQHzg+x1gyh1x2+Tb60XcGj0RUlrhGNPEYoS7As=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0P9M3JdyjzTiA8Wm51/Q3v1Si2Mi3ueSUW1vOBFf3v6Rv2BOX8m8VJtmp8yOmrTFfiY6cbr6v+e1PRd4XZc6NI3U94/XxMk+/xBBjdCYq/zSo3U//6y86RPamow3OzKf8dVkLxnsWtO0qD3ZVegxx/oMLIohdWgWc4q49VgpDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20230601.gappssmtp.com header.i=@hev-cc.20230601.gappssmtp.com header.b=zH94waZ/; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20230601.gappssmtp.com header.i=@hev-cc.20230601.gappssmtp.com header.b="zH94waZ/"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a871daa98fso35718195ad.1
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 09:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20230601.gappssmtp.com; s=20230601; t=1774887057; x=1775491857; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y9eg20jGYaatkJRZTB92X2Araip8YA2EKm9tEKL8B00=;
        b=zH94waZ/JAdUqJTYZOOMx0QyDrpJLfsXrBlebLIYvTfE0jBegsOMj4ebiaFNLEMg7a
         tyyjocRb8787286uw9YKaRK6aF+5UdKZHSOmFErSO0JwIToNYwgjVwZllUI507n0VABU
         T9hBZLn9L9MPDufFx4W3c7Rsq/jJcrhUJDcYHXqdOqXFo7ZKAFidPhT+QPWLxwPjThXI
         mextusa3M1a6ZA7qwgcv/fAKoofAyUBqNjv6TxepScn8hldl+BJEAPo5VTX+4/PS0XKJ
         7pu/RQp4x17kVZ3Wg+9nNydKmU0XbIEze0uYaUQaJAVlZnz0DGRp59y3LVVy3VFx6kuu
         AUfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774887057; x=1775491857;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y9eg20jGYaatkJRZTB92X2Araip8YA2EKm9tEKL8B00=;
        b=W7W3SQp62KgFwZ0RbiV3286x67tSIg0oMouYERL97l0/mrXX3chNSl92J4/fuVMvJL
         mmK8CWJPttqa69EYX3SpQHTT/0Osdy7gToV82TohLfDgo9PtwTqf3SVLB4LPjdtAF0ZS
         z99qPL5M22aFBE5+5TEho1XhinYFAdnQNBZnjItRHG8TpKqGOJv9fQTo9JlVIVgSaJQ7
         5QCbDTRatJ3+gTrdBxuZjeMOhW4fU4lZsxW8s4suT9rpkUc/AnJFiqjzXSp0CjZL2Hf+
         3kklLH48XqpgS7oonhsV+bmsLGlqiSPq0d0pH0XA64y1ALsRgMxlL8j/wYrdXfKBBpiJ
         edqw==
X-Forwarded-Encrypted: i=1; AJvYcCVcXVzQzi4YvNVAJLt68m3YUmwCs0/ZbJK39FeAYT64z/Xa2DRhCkc2/PQk4RlSWtpbZPHW5Rl8t/06Bw==@vger.kernel.org
X-Gm-Message-State: AOJu0YycAwGnYqf0kWGWu7Jp02RqappWU59sPfWi6BDDdhOXR99GzSYV
	fYTVjQButRt+UA8d7hc9nPn5rdNjci5U7PVSzGN5njiGB9BSpXXnpXTKBySjDge6U8I=
X-Gm-Gg: ATEYQzzNtqHORmEY0l66dtS5J95bIrMG3FYxmqx751JbsPO9yX2woT5UpV+s0P2nJ3o
	GoR5gsZVDDgXUQiorIlssT1863NZOK5JbD80x6aGanNFy6xyKqlqb0bQYfsnTUvzujUFk5u1hLJ
	j83fTo5wTBzvFCTZg6wtcisAM3HrGAeGK3NCvT4PKuRicQ0lwx90nHKPcKxybXolYGPCOanqZiE
	MP8vh4d80X6kxXueOn7CIUAEtYjHtfQtj8QHVwGnX6Oh0mzu7Rdt5Z93h7pTCkDaxcVlo9uTT1i
	E9agijju8AW7Czxs+RIfr2O6LOB1Drh0eLiaIruAJ/DCwpSWrduiuP7oZ1PRQOGDPMUXXD89mTK
	lqV3HMXvUCofBfBdIbCag/xypca12VDiXxth1jHPJHiVSQVj5qU3fz8Xe66ZYY31YcbOmam/RUQ
	BK
X-Received: by 2002:a17:903:1a67:b0:2b2:51e8:2c20 with SMTP id d9443c01a7336-2b251e831bemr51399275ad.21.1774887057296;
        Mon, 30 Mar 2026 09:10:57 -0700 (PDT)
Received: from gpc ([2400:8902:e002:dea1:c507:1213:2c85:ae99])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b242642905sm110979985ad.17.2026.03.30.09.10.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 09:10:56 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: ziy@nvidia.com,
	ljs@kernel.org
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	brauner@kernel.org,
	clm@fb.com,
	david@kernel.org,
	dev.jain@arm.com,
	dsterba@suse.com,
	jack@suse.cz,
	lance.yang@linux.dev,
	linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@suse.com,
	npache@redhat.com,
	r@hev.cc,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	songliubraving@fb.com,
	surenb@google.com,
	vbabka@kernel.org,
	viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH v1 05/10] mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
Date: Tue, 31 Mar 2026 00:09:42 +0800
Message-ID: <20260330160942.173324-1-r@hev.cc>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <DDFEC0C1-3ECF-41CC-9630-A4A742F2B842@nvidia.com>
References: <DDFEC0C1-3ECF-41CC-9630-A4A742F2B842@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Lorenzo and Zi,

>>> Is there a reason we can't keep this hack while continuing to push filesystems
>>> toward proper large folio support?
>>
>> IMO - It's time for us to stop allowing filesystems to fail to implement what
>> mm requires of them, while still providing a hack to improve performance.
>>
>> Really this hack shouldn't have been there in the first place, but it was a
>> 'putting on notice' that filesystems need to support large folios, which
>> has been made amply clear to them for some time.
>>
>> So yes there will be regressions for filesystems which _still_ do not
>> implement this, I'd suggest you focus on trying to convince them to do so
>> (or send patches :)
>>
>
> Thank Lorenzo for clarifying the intention of this patchset.
>
> Hi Rui,
>
> READ_ONLY_THP_FOR_FS is an experimental feature since 2019 and that means the
> feature can go away at any time.
>
> In addition, Matthew has made a heads-up on its removal [1] several months ago.
> We have not heard any objection since.
>
> It seems that you care about btrfs with large folio support. Have you
> talked to btrfs people on the timeline of moving the large folio support out
> of the experimental state?
>
>
> [1] https://lore.kernel.org/all/aTJg9vOijOGVTnVt@casper.infradead.org/

Thanks for the clarification.

I fully agree with the long-term direction here. Ideally this should be
handled by filesystems, and mm has already done a lot of work to make
that possible.

However, in practice it does not look like simply enabling an
experimental feature is sufficient today. I did a quick check of
mapping_max_folio_size() across a few common filesystems, and only XFS
consistently reaches PMD order under both 4K and 16K base pages.
Even ext4 falls short under 16K.

PAGE_SIZE = 4K, PMD_SIZE = 2M

Filesystem                     mapping_max_folio_size   PMD order
------------------------------------------------------------------
ext4                           2M                       yes
btrfs (without experimental)   4K                       no
btrfs (with experimental)      256K                     no
xfs                            2M                       yes

PAGE_SIZE = 16K, PMD_SIZE = 32M

Filesystem                     mapping_max_folio_size   PMD order
------------------------------------------------------------------
ext4                           8M                       no
btrfs (without experimental)   16K                      no
btrfs (with experimental)      256K                     no
xfs                            32M                      yes

Given the diversity of filesystems in use, each one requires dedicated
engineering effort to implement and validate large folio support, and
that assumes both sufficient resources and prioritization on the
filesystem side. Even after support lands, coverage across different
base page sizes and configurations may take additional time to mature.

What I am really concerned about is the transition period: if filesystem
support is not yet broadly ready, while we have already removed the
fallback path, we may end up in a situation where PMD-sized mappings
become effectively unavailable on many systems for some time.

This is not about the long-term direction, but about the timing and
practical readiness.

Thanks,
Rui
