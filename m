Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795295976;
	b=hbLRx9CFAVR56YF5UkKcx2PQMvk9GhZ8W9Rxetquq+60NmYYWDCNLuCbuxy4krlTigjE
	 kUDveD+IzSl4bdtGY97Bdiw4xRsReoOgLlv5339O7PKWnx8N/GqbLU4IayCO6uUDMOkDT
	 joFSkbdGhBR+JiiWRImEXAquEH4kwLVNq9wy4I+kDbn5fDED5PscNt5weceA/YFzLDDhn
	 iXVV8BYo0N+NJBm0Q4BNoCAzgC6nsEfwgeUepkn7hZqqi/RoXMnO+BnAURAayoDXN3mdj
	 K2T+knN7eYLLtQ31nusUken1Ir5FPflLDl1GgOtg1nLytZkqj12syjhGj+5gMe6IofQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795295976;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=FIae99VdjOnktXUaF8ZSc8D6iFOOoPDveBDju+SVuiI=;
	b=mT3cDn5dm5aEQq8mj9t0SeYtXFjODn8vK5USfVAsCers8K9AJSJndOjSBVxJ8HeSSlTo
	 Q8g5pdaUEKuTOFhqm8dTDg00QN5a3nSOcYCicPntygtyJCo76UCDU07UczwTndiq7mXjp
	 plcD3q0tVtE+63XBJv43mu0msePL5M6bJf4/+bmktwty/RP7PxZqGwtQdvU3+AJjfWKm+
	 FHgP9FbfI7JWpkA7gc3HYc/NTAnw1u3U/rKgb6XyTFFGa3vXW9OwLcDuKievIHMoqmI5L
	 hHy043TnZQiqzV1kcURa61MMsaaxaUhaCRmL3GqtqtjYphAb2POs77yHg4be5jOiprA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=VHVYYKRD;
	arc=none smtp.remote-ip=79.135.106.24
Received: from mail-10624.protonmail.ch (mail-10624.protonmail.ch [79.135.106.24])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A9A606A681
	for <linux-btrfs@vger.kernel.org>; Sat, 21 Nov 2026 21:19:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1A9A606A681
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=VHVYYKRD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795295972; x=1795555172;
	bh=FIae99VdjOnktXUaF8ZSc8D6iFOOoPDveBDju+SVuiI=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=VHVYYKRDAtKO4egAWKVZIKcjlJep4ohIz535qTP8+M9LYJCKzC/d/wouGFVOFSK7L
	 28UOKuWwUXhTUueNng8TUNWIlW0+Ns1zTe/z1z24fT5k1L+MTDjFubRT6TUmQHyGAn
	 LyeN5dKNF7yJ1QcwyqiYvhsONV+ag+4f2YGwzr/rcf6qlwwEx65UafUTEBB6BgPOH0
	 bWrlkdhEjoG7TLfuudaSNYJUEe+8Al4eNaWyN6XNGvjyljnnsLy0HmleB9p2rTKASs
	 DIHvcGmdsiOduCT0BnG5pIuVbAsizoPH4elTGi9UsFScaBYn8MLVA7jLai2Ux42Jc3
	 1e3hLQO/KaATg==
Date: Sat, 21 Nov 2026 21:19:27 +0000
To: linux-btrfs@vger.kernel.org
From: Miroslav Cimerman <mc@raidlab.org>
Cc: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <johannes.thumshirn@wdc.com>, Qu Wenruo <wqu@suse.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/5] btrfs: zoned: use the highest RAID1 write pointer on degraded mounts
Message-ID: <Zsyg3rL37zRaM6G8PMk9I9QQ94L5mPmCjqZBvTUdSalcGjfQoAnV2XD_0EVngvGjkzSMg39jfSTV-qoo66B2KV6tJcUTN-ogQNlRzF4qbK0=@raidlab.org>
In-Reply-To: <20261121134550.216217-5-mc@raidlab.org>
References: <20261121134550.216217-1-mc@raidlab.org> <20261121134550.216217-5-mc@raidlab.org>
Feedback-ID: 232820807:user:proton
X-Pm-Message-ID: 8f63fdd4432fb1199f9e2ef81906bdc9a41b0391
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

Sashiko's review of this patch [1] found that on a degraded mount, a
RAID1 data block group whose zones differ in their active state can be
marked active without all its zones counted, or, if it is full, left
inactive with an open zone that is never finished. That is right, but
not new in this series: the base compares the active state with stripe 0
the same way and skips the activation on degraded mounts, 1/5 only
compares with the first present stripe, and 4/5 changes it for metadata
only. The 1/5 note mentions the first case and a block group with room
left, but not the full one.

I reproduced both on the base and with this series, and sent a fix that
applies on top of this series:
https://lore.kernel.org/linux-btrfs/20261121205657.1108500-1-mc@raidlab.org=
/

[1] https://sashiko.dev/#/patchset/20261121134550.216217-1-mc%40raidlab.org=
?part=3D4
