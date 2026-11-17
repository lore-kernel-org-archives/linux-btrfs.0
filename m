Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794898472;
	b=0IdBZpB0AIcC23rp9v/Qt03uZRSm13534LqComWG+YUr0jxOUgPkI6FOX64+VziZgjO7
	 DYIoEAD3kS3AkfE7JSaOIXXpVqik3plC0QCakZJ7ie17s0tYlMG9nVZxVtN4PY5+XWRvF
	 sLKNvCpmpmUJh3JHalxBMY55Lw2BRTu9WHOjH5Eb6/mmzF93kYbLDHPyBK0UL1LVJwGXx
	 /2q4uXCM4NkPHXcMu8kP1itppYeBsTbxNDojTYKdCg3inn/jzMMdAYzuA4eIWs4nLUSDZ
	 4GpWokYv11rHQfgP2rlpIltoh1eja2gkARU0vq1BdLQs82f3O2ZIzHdejeMaazeobyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794898472;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=KRxl9/6qde53Vk7mriBy0p9OdUsOse+58tmRT8HCG6E=;
	b=bJVRdSlP8BMJAlPW1PzUjHE8WQG7VzgjRomOLQFVEjGEFO5yvR1ryHeHGpqu0fbn2Pki
	 YpEfru8jCNBo3f+GTui/vU/fQHqqXk7nwunZqRPZ6+9dce1HbvUgRgTRAXoN0+DPe13gZ
	 prLsDCaTdz0Xux24yQBDDLke1tA4uWjuW+wBcZXskmN6zFBg1zfOQ6gtGAvTD+gfbnPMp
	 rD2HAfXDSY4MHeDaXpzYUSXEr4fFblEXl8icpqBmEd3MfecVWgms9xLkNPeuQb1PBSUK0
	 KpjxVyLJ3xUbHPHALlO2gP2c13J1bPT/F7EV3cxRaVVQcKIqerDzRYT7EdTUUU4qC5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=P2B1NFj7;
	arc=none smtp.remote-ip=209.85.221.53
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F889606A323
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 06:54:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F889606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=P2B1NFj7
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-491846221ffso3882743f8f.3
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 22:54:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794898471; x=1795503271; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KRxl9/6qde53Vk7mriBy0p9OdUsOse+58tmRT8HCG6E=;
        b=P2B1NFj7KNHU19gS1NmV6YI4nISKC1xWASjZy8+/Tvs00DBVTznQCZ+4AKBy70wrwM
         4O890lLR0brRlPIDPGkAIX1ff4G7KiJ/SL1aShPo2WNIgZbYesMR6S4oX9kT3tqwXQ1+
         eG3g4BqxCOA5xqT+T9/+N5B4EvGiicjmILIn1+LXYhb4MO3qqOTTPXmNJg//7k5jFi5o
         O5G/EZBCCDEO2sZRRNd+mqiBJVqPFGgsncsxWVYJvgBKjBQWJ3aeHHH305+d+X0EYZzg
         ynluDjBT/PQVezE91CZ1PTI0K0ZINApE+QJUwV7cVBvbW799lM0ua9mNxmAYvNJqhDLl
         Lx2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794898471; x=1795503271;
        h=content-transfer-encoding:content-type:mime-version:message-id
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KRxl9/6qde53Vk7mriBy0p9OdUsOse+58tmRT8HCG6E=;
        b=gu9swWwsJ7ebX2eCGpQs/qUN0aEawozRH5zZHAKGsekYEBAm0bnu2jDmIYZNcC5maH
         GR3zjGzn6vVZKzVhZGhN2WpNLVM6JCrg9DFBAges0GO2v8WgA9MPXIGY5xwXFT2lY67o
         bH9bici1nasAVfp52y6/gpV86iD+L26AO6S5lzL7Lsvj4wu7Di6Q2P969uCPsM/3nSe6
         49jZHW2wgTWXSd6ZBu3N66y4/GcwB/67zaO4ZRu3i/QF6xTHgq2CIi98ORne2RdzcHiZ
         wkDCXgMXCn6lkqXGDCUyP7g9feDkvVPLqxISNZmGKD90J4A7WwhQ+H85Jf2rEiwl5UbG
         gScQ==
X-Forwarded-Encrypted: i=1; AL+hErGJcFVr8QztN7kICX53nnWf2YRSmd1Pr/2l3HUx76XZv4ImCmor9tQVpaT9pftuKZvr47m6tM3MxuHjOQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z9RMF5uMtpo8xxETSuZsMcy4uUL0AT5WoVeHk3ZfrrKnf7s9/nm
	RSiJZgbLEY3Yerm4wMBr6Ga+GOpj+P6AGLzwDlW5g+FZ/yLMFMuP1dqBsWGWy6O5a6s=
X-Gm-Gg: AZFdTZfP54CLc2OaiVm1xMzovmswQDAR1MBe3UiVVnAaNBl/mXMFh3XLJo1Wj0SMa7d
	3n9ImakHVWkUUIrz+lLqTEuzYDQv6YaPR5XRF9LTik2pLHvlgRm71xos4ogrTT8Xw/CZjOTmElE
	aN+PcE1fSC0EOxoNSiJLz2h0tuyYsNYDqrNCE+aIAyidAEUrRn6yzO5PlN9ZrL8f8r+J+v/6NTQ
	274caKYZ+Lg/Insgl5PIW0NVadjBa1LtppihG1iXfVaI2QOgiXLFwIhQmtTrKvm8caEsgpKaBl8
	m08JrKDnUd5OLY67Dqa01pJV2XdgOykeG48WDoS/Zf0w1Or/0jy45gj0K7VZ9YfEKfTC0ZVHdjX
	CIj//lPKpNmvCfW3w9E/KmoY+II2FVY1NoY5mfgADtCH2I4e/F6KyeMGKiGNe6oC2tL0D3uICf1
	JuNgDCfB4mQmcA8u507MUH1rySesEoPhEAY0UVqt8sTb2dszAMZg3hEFG2adZLC+mT6n3kJX3VV
	6PgxsEzSaEztegb2bXcYNnZGTBp5gOzVwqo0yHV0Rs9xaCZ8kyAjZZHajuQHr1XeoUJWst4BCys
	yTRPTTNhOMwB+Co+ELlQx6q50pTTmA7FuTNuOxbR0UoS5mT6qQUGANljzfaRDtgnjh89zwsQM0N
	DcBSrEv8XIZGVkymB84Noe/OZZzdFTc+YwcM=
X-Received: by 2002:a5d:5e88:0:b0:48e:679a:4aeb with SMTP id ffacd0b85a97d-49c6d63fbe1mr26407389f8f.3.1794898470695;
        Mon, 16 Nov 2026 22:54:30 -0800 (PST)
Received: from localhost ([46.36.23.99])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c60d9fff8sm27710685f8f.52.2026.11.16.22.54.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 22:54:30 -0800 (PST)
Date: Tue, 17 Nov 2026 11:54:28 +0500
From: Mark Korenberg <socketpair@gmail.com>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
 Naohiro Aota <naohiro.aota@wdc.com>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: zoned: reset leaked zones on read-write mount
In-Reply-To: <20261102-b4-btrfs-zoned-reset-leaked-zones-v3-1-7979bda654ff@gmail.com>
References: <20261102-b4-btrfs-zoned-reset-leaked-zones-v3-1-7979bda654ff@gmail.com>
Message-ID: <81f8a131f512f715c71947046ddc87a9@gmail.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

On Mon, 02 Nov 2026 20:35:04 +0500, Mark Korenberg wrote:
> If a transaction commit is aborted after the zones of a new block group
> were written but before the superblock was, the chunk item and the dev
> extent are never persisted and the zones leak.

Hi Johannes,

a gentle ping on this one. It is the patch you handed over to me in the
RFC thread, could you have a look when you have time?

It still applies cleanly on top of today's for-next (146946479b45) and
builds there, no changes since v3. I can resend it rebased if that is
more convenient.

Thanks,
Mark
