Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794949786;
	b=lwgCSwLQeJbjn8mCbhcPHb3tAZlie4p8K8GFQXYhBf4lnBFxphjEQ98hHI1bkw+ZPjX1
	 nwVk0SWBejCq66mIl2J8jJPnpFl7EtSqAoacvSf6qV4Uf1RU+aRC4NuKchR66dfwAEMwi
	 5YmuuM9v6hbpwo12AS70bHIt21wrF+LX6KGNkJti54KTQh2Sfp6DqF4eaCJ9mSZv/YzoS
	 N5F1lZpQwTWvfy7QOhvX0SLR7Cw9K9XOOMKHEy2Fw95qPtKRZ7DOofI5zF/U1xJlhXe48
	 TkPUUXsfyKmZGxndNZzJSn7Ztws1YPHMqA+Xba1ZBHak7Yxaj/HkM6xaf3AnjHpy5DQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794949786;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Organization:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=yIaVmSvGOn9J9jwwxFt0/dRjawVrKNBUfAUugZvtz8I=;
	b=GjKcR0atEv3/NfLFA1DzeCO0V7z4E7nYeHw9XfdA+fP2dTUqvZBhxXoK1J3cjXMU9wab
	 GR+tljcf5V1qe+a51yx1qmaFilSWqyvVx3uyvQJiOlQkGvutZCny2KiJsBoNGfH7XyIrW
	 sG//E8K9J6uXtqZ14dB2bejInN6nHo417N3pC+NpxzEIAC2di3Q/EpcaXT5/NzAEBn5/m
	 z3zm2SzooozeAzW+LCjjuH8aBI7DViNTpf8sfx/HoPMmdFp4MKD2o50G4X7BlSf6KCWVN
	 6fIecalMUTyuczhwQJ5VD794l7dxbaUP8wtLcGSU9nnRGubw1KzczLOKivmSgmBWhcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FzLuRWPW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A45606A89B
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Nov 2026 21:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FzLuRWPW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58CDF1F000C4;
	Tue, 17 Nov 2026 21:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794949785;
	bh=yIaVmSvGOn9J9jwwxFt0/dRjawVrKNBUfAUugZvtz8I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FzLuRWPWjrxR5+odMCAY3xl+3zX2PEHXh9x9931Q2L/FfgP+rFoQFZbWq0C9PRK+Z
	 LL9wmKif4gx7oUjuOTcTK6HIuc+jdF0MPxCNuCyVsg1PQeQDf1qnXY/mR4uXa52yPX
	 wCutx3Wzkm9av2Al8qEDvVKN/bfBztEg8LD9zh70YQ6oF43uc5rJsmcOIT2inhXyjv
	 /TWfgon2uDegXoxSvgqyBJTNfKPsq3R6Unkgn/JZY23d17/W/F34q2pCsQaJXa0OZB
	 DMPp8sdyDauEzG1o27Y9duSHCaMRqkMzMBzRs6opQE3TC3CbSRO5j8k6LBIWlXOtiG
	 gHQiEOulhqCFQ==
Message-ID: <e0cfda55-eb33-471d-9db5-38f4ef5d540c@kernel.org>
Date: Tue, 17 Nov 2026 13:09:44 -0800
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
Subject: Re: [PATCH v7 03/27] btrfs: zoned: fix possible race for
 reserved_active_zones
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naohiro.aota@wdc.com>, David Sterba <dsterba@suse.com>,
 Boris Burkov <boris@bur.io>, Sashiko <sashiko-bot@kernel.org>
References: <20261117185850.4128157-1-johannes.thumshirn@wdc.com>
 <20261117185850.4128157-4-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20261117185850.4128157-4-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/17/26 10:58, Johannes Thumshirn wrote:
> In call_zone_finish() the counter for reserved active zones is
> incremented without holding the per filesystem zone_active_bgs_lock
> potentially leading to a race for the active zone count.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Fixes: a7e1ac7bdc5a ("btrfs: zoned: reserve zones for an active metadata/system block group")
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>



-- 
Damien Le Moal
Western Digital Research
