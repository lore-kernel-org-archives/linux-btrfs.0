Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795608941;
	b=djTbQn3xxUYJdZq5qMVpGZYSTaTtjtrE3MtcPPFaBWUSHGsG4y8s8gxtz2KJOKOdX07+
	 KO01eNwWpNYv1f2uX+fZqQDTJ1+e0JokYWULseUEGTSErbBeqaJOMCIPdLEN3snLTU0E+
	 XKtHcrUfN+ySVZiopeEWzZTSY9kLePNzOHY8TUUtIcg1kR/koOKgmA/yPlczrBZJ20adD
	 +vCuXtQ1r6CzDEgvM4ZaQ31MDX/p51ydOkxplj6nmpe2qZyPuaf4i8kxdG2Hp+UH52uMc
	 718MLpVhnw+cuK15vFDMTaCrHquoUkyF+flRuPmqujgwTeL+Zewv7fPvLh3UvV8FC1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795608941;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=peYm9echGqI9fSUtN/Ty4opke/Oi26S7M6+5AcbWpKI=;
	b=wghvqcagGTqYaVucnwANYSMGoxwjtO+OnuvrXGpKdEv7rnm3gOf9w8ysyA9daPEJSfyF
	 iqfsKl8HSJC80Tp2TQsWchmE+gUdOJ9zdI7NyFbAA5ha4j0l8atIXdGj+Pp6EORGexF+V
	 QwRfcHg4GYkzfg7NBAk9QieU+I2pwf0UHBWyny5P7Nwb0lfOXtiXqS2DmKVTYG1ddIzYo
	 g/EVwcdt9hDudEG26deM1FVsvqJFQ5EdWf0WrOcnA2M/hsfDpaV6Ya+4ThicDjnLiYBmg
	 uWQIzoIXJmjzfSWwaH3ASbter6LTZyr7dfnZ7y+AHIm3Lb3oKePsRoDm1gN8vrXzxNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=y6NTEAjo;
	arc=none smtp.remote-ip=185.70.43.17
Received: from mail-4317.protonmail.ch (mail-4317.protonmail.ch [185.70.43.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C11C606A323;
	Wed, 25 Nov 2026 12:15:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C11C606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=y6NTEAjo
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795608939; x=1795868139;
	bh=peYm9echGqI9fSUtN/Ty4opke/Oi26S7M6+5AcbWpKI=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=y6NTEAjoVMoQJDeY4ydEGMfuYgTKaCV9NCz4ER/7a3+ImqEsfI+tQrDVO+kJ1+x4R
	 pjNUS2XEQIj4nSK3M2Wqw/zYyYIrLckOvp3ldQBZxuJMuc5X6F6fV1L7BsJJGEWbHZ
	 BqhxDy47SkEMK+yNqcgbU54d2jZntkMMqrmqaK48WAxiZmobJe9HBiLZ4sMNnTtWpR
	 avxrwSMxeEt8z85FONCXORyDmhC1e7W1tpEeTDgNgX61bkxOdSi0GYJmsECGfCvNeF
	 wSwCriV/Xi9Xsqlio7l4tkQh4fW4t7qecmhs9NfCHmU9Pdqgyf3iAk23vqOqxhuD1q
	 MhBIZ8qjSZ/qw==
Date: Wed, 25 Nov 2026 12:15:27 +0000
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
From: Miroslav Cimerman <mc@raidlab.org>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: wait for block group relocation on remount read-only
Message-ID: <pI5FVmDFvSeAAyaxWboIkNPc198E5Z5EGAqfTPDCrM71yOz1erD7SPXwGAazy2mXn0D7LgzmAnLdvZR2SiladzpCwoHvknvma1nAW5mmGfM=@raidlab.org>
In-Reply-To: <8c893023-3647-40f9-90dc-63ce977fe710@wdc.com>
References: <20261118125816.6878-1-mc@raidlab.org> <20261118202548.82001-1-mc@raidlab.org> <8c893023-3647-40f9-90dc-63ce977fe710@wdc.com>
Feedback-ID: 232820807:user:proton
X-Pm-Message-ID: 47eaacb7bccaa97b5aece4471fe526b39ad33d8b
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Johannes Thumshirn <johannes.thumshirn@wdc.com> wrote:
> The bug looks real to me, but Sashiko has another complaint, that looks
> vaild:
>=20
> https://sashiko.dev/#/patchset/20261118202548.82001-1-mc%40raidlab.org

"btrfs: zoned: fix deadlock between freeze and RECLAIM_ZONES" removes
that dependency. With it, btrfs_reclaim_block_groups() only tries
sb_start_write(). In my lockdep runs, the reclaim works no longer depend
on sb_writers with that patch:
https://lore.kernel.org/linux-btrfs/20261123012459.436826-1-mc@raidlab.org/

Your v8 15/27 contains the same change.

Miroslav
