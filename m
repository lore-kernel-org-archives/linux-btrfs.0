Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=37.120.160.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794654328;
	b=og9CTD3j1uniBrK5RIzM++3I9lJaBVj8qwfEknFVYx1+tArsebWgfCmgLGlf/MuhyHsB
	 c/9cWWcRKDjYFslPElKGbLd+1iYo9nIKaE0HTcQq0qaq8o7t6AQyuuEXpHpXZBvoabriA
	 gZYUf+E99paloJpx+A+pp0Bbmwr2vFeKRsfWFn0iiD7/4kLbIcCjS+Ij8YhmSI2k4P+lC
	 DnT0jl8gsntlekuDfTUCAm1Szzfas8vMbvEZar6C5NOw02G00GuN63VWZRsz1sJbKRGJB
	 He8njwSE4DRZ/WafQ10tDiaYRFUd8RZ0h1NzO7kX0FCWXH3XUn5R+qRNIx0Rw4QbW8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794654328;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type;
	bh=VnALL7G1BXIU4RBlWtLcmdltQvGlQBiNpIdRrOxsod0=;
	b=sBFLvlqgHFgTMz445U+hbMkyrW05uM/AoKFQCY3Ck14y2clJA/8eM6d6j70XMCJ0ZiJh
	 IZM+ZSaVk5xNx0fpml4UiSsSwGauaPImVFDHWrVsU9yTl9AvIUzcxqi4h/pZMhgSjJEPv
	 r+AaQDIj62UtJcVAt6Ue8BhK8z0Wjh5IJjia34yKzc2JMnHmRnovG/c6zRIa5d9+tMfN4
	 bvWHue2E0PfPfdKWOzUoUzUCdoAX0Y2ATrtW2CrMqUTdRHNJ+OvhJ0asAT4GVlAzH+8T3
	 nhrpJXTeumwt0dO0fKkXGTipRBXdBo0RsQXKgYaMBineKoHzWx1HA4Y18ZLbBE1oruQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=lichtvoll.de;
	spf=pass smtp.mailfrom=lichtvoll.de;
	arc=none smtp.remote-ip=37.120.160.25
Received: from mail.lichtvoll.de (lichtvoll.de [37.120.160.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708E4606A323
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2026 11:05:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 708E4606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id CFF92291B78;
	Sat, 14 Nov 2026 11:05:24 +0000 (UTC)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin@lichtvoll.de smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: BTRFS <linux-btrfs@vger.kernel.org>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Martin Steigerwald <martin@lichtvoll.de>
Subject:
 Re: SSD overheating during scrub in laptop (SOLVED: no overheating but
 firmware issue)
Date: Sat, 14 Nov 2026 12:05:24 +0100
Message-ID: <-s0v2GXuRt2gJpFQn2y9bw@lichtvoll.de>
In-Reply-To: <-8JrlgE5SLizPVsfOSFaOg@lichtvoll.de>
References:
 <1938311.tdWV9SEqCh@lichtvoll.de>
 <967be80b-f683-4611-a473-0ad02897c451@gmx.com>
 <-8JrlgE5SLizPVsfOSFaOg@lichtvoll.de>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

Martin Steigerwald - 14.11.26, 11:29:30 CET:
> Just completed a scrub of 2 TiB data. Twice in a row, first on TTY
> without loaded desktop with about 3 GiB/s, then on desktop with
> power-profiles- daemon set to performance mode with about 3,8 GiB/s.

A third successful attempt:

Rate:             4.22GiB/s

So it really seems read stability has improved.

With an BCacheFS filesystem with 180 GiB I have even seen rates of up to 
5,5 GiB/s during scrub.

Best,
-- 
Martin


