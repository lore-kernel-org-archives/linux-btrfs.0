Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFA12236F7
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Jan 2026 18:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768932337; cv=none; b=mQqGq+IEWTRhsdAPeK1apmD80LwOTUX+xUqBuO/G6B5S5P8+gAd9kjklu965fHyQR3M6noZdKsxtdpkAzDWP/wEOzmO+lCJwb2OzagSEd02TXYHuR2WVUAM2GQq2UKCvYJt2Huioc3RGNdAgG4gLcV6ef0v0ewnMA02S5+CUXzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768932337; c=relaxed/simple;
	bh=PLPBMJ+Xul+GCVmsfjqrQBSjs4dMWtSa1Yyl4ZdhPyk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=HV9NzCQy/ArasQzz1sX/cvyRQr5X/FgqHEnJQDMm5G9wMqL36fxN48y10pg/N9cJqU+gbuvhA809OZtdxGwNsTGervUG1mjH0h/csu3X7DtZLDW345RP0tDhXDnmHtPndOdqS1hClih2/JCGFAkRVjVqUQeBcNw6Q77nwm5KiS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=jakstys.lt; spf=pass smtp.mailfrom=jakstys.lt; dkim=pass (2048-bit key) header.d=jakstys.lt header.i=@jakstys.lt header.b=TOEr5Fsa; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=jakstys.lt
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jakstys.lt
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jakstys.lt header.i=@jakstys.lt header.b="TOEr5Fsa"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b870732cce2so866559166b.3
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Jan 2026 10:05:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jakstys.lt; s=google; t=1768932332; x=1769537132; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UCVqhiNdGxyvTknOJgRK/gQVdV9IWty332W75iVfXug=;
        b=TOEr5FsasC0qBqi2cwml4hr4XRysGftOZSPVJTFdhU9KstaiF0CRanBOMYdozr6pOi
         xUN8Y3oY4X4dqOJ08Ho+qAUWwQN3rrOQnRkozCf6o4emQDxW1MxgKA6nm02H2iNuDnu1
         pqGkU5F6IyPx1D7C+ZxukPo+TD5f2kKQ2V9um9Ej8ijolEuM3KPLjYR3A6RjLJSsk4rA
         hkATtOv9o/e3kBBBvHVeYgIdl4byeqzyfY6kyMY7v9I+fqEmjH4F3LfFmel5AKmiPl4v
         eZ9QjDmFnlHl+OJZ6XzscNNZKJoUFh+AeM6woyyccLQDbepSPryGccw1sNw65ggsS6gn
         ECIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768932332; x=1769537132;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UCVqhiNdGxyvTknOJgRK/gQVdV9IWty332W75iVfXug=;
        b=dC7hA0DIje+fKQBjwDOCLaN5ZaNZXoSZJTjmz+pRZICyYweqNA8r5l5KVdGucwXnnW
         CJmk1uD0n5Nn9sNuBQnInEp1godNCMhug+qcsmRcmP2qOXuRarbUuGaTWBD/Y77zJrVE
         r/f41n33h1nrLWBvYAmD5MIiUJ5tbrXjmKfGff7fsRGfGhBSZM39GTsCbkKZ87gqpk9A
         rv2qVdJ2pBAdBt9gG+DNZYmxDyDRazsWUtfR68UT0WM6AmRXNNyo6tpYm/SKRJVSjpZ9
         2v9MUfPZgPaS6JWxOzuzA6R7qJryOZZDLJ06wb8hdJ9o77LQ4QAIs/XXcgZtHHszjiMo
         nPwg==
X-Forwarded-Encrypted: i=1; AJvYcCVegMDCrLR9Hf00fsqDE/5m3O70z1dPV8SfGNwLkWGKoU1GfXzMI9su5W11orrl2js2jEXpcgnq7K5KOA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/MQCbjf/nvkZqdW2dZgUztZeyR4vnUI/FGeTu4MUD2g17B4ul
	ALhUWDk5bqe7M5Ohrtw6VepQvFPzsWVsZv/LUjp9fbgAv5rvPSeuNwsJ8TdVkmhhTw==
X-Gm-Gg: AZuq6aLAJ9ypoBw2wKju+UVGhFkhrAAcr4nE326Gwz3KggvAD6Q0mTo3sTLJwOWZh4e
	5nfDBf27URjla9+LK7NLwCiQFO/w+8gId3G3bQ+1JQnS2nP6oiUrKly31HlxDf3SJtYr68/QFDe
	64QvobqlpeI4wfJU3wuT6HXQheZBmspDE2l+FRMqiJ/mcBu4/gh5xDt+Bn90C2+jgo8So2vkwFs
	pktE46SZC0DS2uYFNfQ007vwqHcQwAa+syIjDgvKuDOLUUKJ6USz2YcT4rVvdulVuu/lz5L1GiQ
	5PpR/F/82ZbyT8BSvqpTLkOB/xK39BZJJ/5a9Bs8Yz48L/h/txUoT87bj4pynXOAJ464+j4mMOr
	mT9SwfA0lQZuGJpHdV+6DQVq8HKPRH+sNhJRwfrv1MsNdXpdqPvbWNCro6qMo6rvsDZcWw7B+KV
	lLKrdLCuMVuFmy/BZBTqI1HB6vmF73FqfSyVTHxROQ5V4K4g0pxEtN0nz4pNAIaysLo0NHP29IU
	UEEpTHP30Jy6vaRu5qnV88nksLjZSY=
X-Received: by 2002:a17:907:9443:b0:b3b:5fe6:577a with SMTP id a640c23a62f3a-b87968b6ac7mr1274696166b.8.1768932331790;
        Tue, 20 Jan 2026 10:05:31 -0800 (PST)
Received: from localhost ([185.104.176.238])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b879513ea20sm1495498766b.12.2026.01.20.10.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 10:05:30 -0800 (PST)
Date: Tue, 20 Jan 2026 20:05:28 +0200
From: Motiejus =?utf-8?Q?Jak=C5=A1tys?= <motiejus@jakstys.lt>
To: stable@vger.kernel.org
Cc: sashal@kernel.org, clm@fb.com, dsterba@suse.com, fdmanana@suse.com, 
	linux-btrfs@vger.kernel.org, robbieko@synology.com
Subject: btrfs: fix deadlock in wait_current_trans() due to ignored
 transaction type
Message-ID: <kytenpx2jfpyit2rxt2v7owrcxd6qy7amlrxkizdgcmuvhkqjg@tqzxg44mrsey>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Dear stable maintainers,

Please apply 5037b342825df7094a4906d1e2a9674baab50cb2:

    btrfs: fix deadlock in wait_current_trans() due to ignored transaction type

To stable kernels v5.10 - v6.18.

This patch fixes a btrfs lock-up, which we have observed a couple of
times over the last few months.

Motiejus
