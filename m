Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794916745;
	b=Rvsyy3nOsbfxktVUvzs4Ay/3TzwF3LATLKTDtZevfVzPX/LurLryMNXmRrMl3Wkf/N89
	 jXDnKH7arTSHHvPTdVWVcHOG2edq00HrUy6LvrdxZQSVAph9ErZxHsR0iAHA+774oK3xO
	 blXIvNriOAIPpPJR7OO8LobsNnD1bEtQOmoeJ32YfY/wdQf3xS0bqrtajg91hGjPNxXtu
	 /bSXTyzOm8spUxiT6iweeYz5ro8IYowPrf9kq4WRZeFgZpl7ioZOvaVWsZzVT0pEtnirV
	 EEoXQXCF9faVi1iiAPM2cp1f90NWi64N3qLv1TKhKF+mUO6SBI4c/0kFympbhJ+3nmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794916745;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Organization:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=7ggqKGK1nDj95y87UmBOTJfeIZHwiggjE8DBlB2IlYQ=;
	b=mCcgphz0LB266PMVsvtIehHEUp4duioPt+H0IU50A3DX4sdpYI32xgGk39MKGXZXLxZ0
	 wkiDJ8jpZ+GpPzbE2qgCMlxSU/qmuMdCfQqHnJ0uj3TOz+23py6/1D7uZBf60ll0bUr2j
	 DY+LVwGnxS6bsaFa74eKHfRUIEJXB6nEdW0Xb1/TMCVM8Hfbn6uyQCUoE8/GoAUjyZxZZ
	 fPPtUaWdrBZuUQrGtc6kbVm65b6ys8Gur79VF/jbyKjc8fk9eoboP97rGDdx2yXoniQWD
	 eAWhbzR4ED8RAdl+MOhnIF1YBoKWtldgT6qu7X629eS0HvwEk1jjZh5MtpHy1hJ9ebw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ho9Ic4WN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34ED606A885
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 11:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ho9Ic4WN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78191F000C4;
	Tue, 17 Nov 2026 11:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794916745;
	bh=7ggqKGK1nDj95y87UmBOTJfeIZHwiggjE8DBlB2IlYQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ho9Ic4WNgxDppc1Dq1WM2ubfZH8o4Zz+QlK724Q9pWRFweqVpE3Vph/4XQs4CUQRu
	 Q5ShnpXIDRs3of8TlfcYerqeI4NjzK4R5alQbtZkccuyoGTkkwivqDOtC+r+PRAaju
	 h5gbZtcpBBRG66Cum64jqS8e4ZLRc7m64URaeaDnlPxg0B8X9BqEBZW2YcWh7Vx3Vj
	 ihGJ/3zf304xV+zkwnnfJUNvBnrd7DSl23pevV6o6qR75RRJaWBFYdrno2Ub8qBJ9z
	 foK0jOzCooWP3WZ8q+GsskslgePe3ZtzdNIoRJQvBU9n0WtmeFNINyS/McNuSn5Hrb
	 5ZYEAf30Zlkrg==
Message-ID: <c1398625-3a6e-4fa8-a021-bffdfa32ceb0@kernel.org>
Date: Tue, 17 Nov 2026 03:59:03 -0800
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] btrfs-progs: zoned: use cached zone reports if
 available
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Naohiro Aota <naohiro.aota@wdc.com>,
 Qu Wenruo <wqu@suse.com>, Mark Korenberg <socketpair@gmail.com>,
 Dongjiang Zhu <zhudongjiang@fygo.io>
References: <20261117084948.3848762-1-johannes.thumshirn@wdc.com>
 <20261117084948.3848762-2-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20261117084948.3848762-2-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/17/26 00:49, Johannes Thumshirn wrote:
> Since Linux 6.19, BLKREPORTZONEV2 with BLK_ZONE_REP_CACHED reports zones
> from the kernel's cached zone information instead of asking the device.
> Use it when the headers and the kernel support it, fall back to
> BLKREPORTZONE otherwise.
> 
> Cached reports return open and closed zones as BLK_ZONE_COND_ACTIVE,
> handle it where open or closed zones are counted, and provide a fallback
> definition for older headers.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
