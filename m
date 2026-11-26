Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795727493;
	b=16L8TblzwPX6BFtyJONVuChkd/N2X/W/480UBCv4eJ3tZtG4KobIMA11gfAY1nPbhohW
	 t73wMmEDMvYmqY5B702EFSRMb+mN1X0sT7ZaZoHPnpchJjCuEQQOyJhQyv+YtxXCwb5vj
	 YeBh7lgztWBmKpg3/aZ8RnDkO6FpWlBqzkj+sV0rm+gIib1H5hrTDCbH3+x7QaB9Fpvwv
	 4HjSI+eXmeqc18hIMsbDxnpHk1MOwW/yZeDvIzn1dQAMLCIFoLcxACQfX9JFJHeZl/zOZ
	 uZZ6OL+2lU4XvXkuo9VpH0YtgkrRkP9iavgz9Z9u5IbpUzij9KtKtKouEzBZiY56qUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795727493;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Organization:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=IRsJ8Vx+Dt6VRu8KfUC570ilwm5vfrXSYlpSxfS/5Og=;
	b=0Z9OTx8hvsja2r4fXKHYleCZ4Ew4bLZLzvPoDYLFL5yB5VLJWMZ3AirE68xuSyyT/90d
	 u2mioM9i4vbY0kpcYOK3fNG86qClIJ0406uaMprYBFYuqs5dnRIK751j7S7wXGdeyaljJ
	 uivbkjeM7Sf0n6E93rLWxphxXjD3L08l0bNyUbvzuEuCW0tz3p73tLs6zggNeVIFMr4jV
	 b4ldtnachuUzulvDP6AB5T8cPzllw9z3ATQ4kYIgabGTS7/uzlyMOzGqOyZH0OKimu2zK
	 8qfilstI6v6zLvI4FBM8/JeMDve72GSjygZOgjmJ1Ll5PUGnXEUCcSMbyaoE6QRHBCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mesPUG9h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22776606A31C
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 21:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mesPUG9h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774D21F00898;
	Thu, 26 Nov 2026 21:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795727492;
	bh=IRsJ8Vx+Dt6VRu8KfUC570ilwm5vfrXSYlpSxfS/5Og=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mesPUG9hco9jm/LZH3ZjWZTGEBGCboijdGdt+ZUopZKXsPq0rdpp3q6qSTTEQK4CF
	 N8VS8ZzvKsH1+b2N5ZwAB6wW8P7P3bAqtKzHEo2R1yv4nkk+67ogewVY8g70GQB/Nc
	 HJyYJLmcnWPtUKj53gXnZjsuBfyxBlzA5RymlH5H42kVU2HAM375xKW4g1Bhllpc0S
	 5RlkGSYgkiAXlhe1iwrQhb1lSafq3rIEwrGoHomCH2d85FFMETwnnQ9FyrFVNuIzKK
	 h1lbrqNi5AhWt7xNA7oy9shFcByGmo3OI5Rm2ZPycO+OXM30purKDva/YIR8fm0Dp5
	 suK3cVTgdKvng==
Message-ID: <fbcef348-679c-43b8-b057-7c5010d80089@kernel.org>
Date: Fri, 27 Nov 2026 06:11:30 +0900
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
Subject: Re: [PATCH 2/5] btrfs: zoned: save last allocation as placement hint
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Hans Holmberg <Hans.Holmberg@wdc.com>,
 Naohiro Aota <naohiro.aota@wdc.com>, Josef Bacik <josef@toxicpanda.com>,
 Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
 Boris Burkov <boris@bur.io>, Qu Wenruo <wqu@suse.com>,
 Wilfred Mallawa <wilfred.opensource@gmail.com>
References: <20261126132820.570379-1-johannes.thumshirn@wdc.com>
 <20261126132820.570379-3-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20261126132820.570379-3-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/26/26 22:28, Johannes Thumshirn wrote:
> Save the last allocation of a data extent in the inode and if set use it
> as a placement hint for a subsequent extent allocation in the extent
> allocator.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
