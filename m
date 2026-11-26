Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795728634;
	b=rAyJTvcHza1yoNucggALDtB0atUxEQEYno5/AEjagmB6nPKYif2XcLwQxX+CnKufMZ3C
	 Dhw9UZjWuOYGsC1gbNz0hWBU5WUR1S6DWDJYFg3XGViW25maHg1dTuyrMTEm2oPMZKzdK
	 9KFjbpThLMPS0btt/wB9aaqHp0+5bJYBirLFnB0ZPXpfMJ7NwAQoxvOo+Fk/6j5d+3slQ
	 CGSIAt01K47Ost5O34G615hNcTkNDl+B3kRCVZiUPfdVj1gGozsabaz04mL98tlTtwF9C
	 PGoFoTImeA9bp1iyFS3g/rD/Pv7MkyF571zpO8ROkjm5WlyYz5HBkbqt/jsPeBZDoSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795728634;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Organization:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=CpeE9fSNjQ7aYaqMM8gIHg+kuotbC6/pUZusoJqQ/oA=;
	b=zf2xDV7DQR/kGzTsevi+YyEeFYwqL0APg9VgVIC71p+614O91gs4L/OFHexGuFtSAfxR
	 fBQy1FQDmg7JP/n6dm+0fl23zlQQanCmnDA8XsyarQCcUsvBdi5yL4+wKXCcgjJt40ZVC
	 yjBNHQS9PRsg0ZbASTdj9QqgFAu09t15Wg+3PisHVGqeRgmvQBK0NWQrqB690u6i/ocnS
	 VyfCDStxR6zYqPLd08ABqr2jqEtoN5pjdsgSYFYJEqKsMT7PkiPgf9/PyzMVcbRVb4Iw1
	 4qr1XxI5sGMHompF4dzwShP8E+9Q02AbuEgowjRgDd48m1fiymAm2LyhoTNYnL+xuLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ABh7FniD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC53A606A323
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2026 21:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ABh7FniD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54881F008A0;
	Thu, 26 Nov 2026 21:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795728634;
	bh=CpeE9fSNjQ7aYaqMM8gIHg+kuotbC6/pUZusoJqQ/oA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ABh7FniD8Is+99XOWAhcKTvy4dnGybFm86CQ1VrwnByyRWgw7ECF/2/TfhE3aiqz2
	 /4Gh8Se1wRykoPLm9d+Qk6HxSOtR2ZwwE34yQhu76AmZQnir0fxMC6A+3fJNSunm74
	 ayP0Ed/oDOyHrmygd6GcxlHFUc5go8eGOrOGOhdXR6YniF4pjxHPMkJ5rTwsYgSt4S
	 3KlBstxVtP2WZeWke9/Yj5gOejWvAnNDsockj0VHlQ9G4Ofcb19d6T7OetFS2c3rJi
	 a895BGQrTB/798KjZPEUKUqDU39JgqZ+JoBEVlorfmjYocoxn1CkQBACojzga3Ft9S
	 uLDGfNBneCifg==
Message-ID: <27ca67bf-0d07-48f3-ad8a-c2d799e2ac8e@kernel.org>
Date: Fri, 27 Nov 2026 06:30:31 +0900
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
Subject: Re: [PATCH 5/5] btrfs: zoned: break concurrent chunk allocation race
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Hans Holmberg <Hans.Holmberg@wdc.com>,
 Naohiro Aota <naohiro.aota@wdc.com>, Josef Bacik <josef@toxicpanda.com>,
 Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
 Boris Burkov <boris@bur.io>, Qu Wenruo <wqu@suse.com>,
 Wilfred Mallawa <wilfred.opensource@gmail.com>
References: <20261126132820.570379-1-johannes.thumshirn@wdc.com>
 <20261126132820.570379-6-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20261126132820.570379-6-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/26/26 22:28, Johannes Thumshirn wrote:
> btrfs_chunk_alloc() coalesces concurrent allocations, so a fresh
> block-group request can end up without a chunk of its own when several
> new files race.
> 
> Retry the chunk allocation a few times before giving up on a fresh
> block-group.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Modulo the already commented fact that "fresh" is not a super nice name, looks
good to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

But I strongly suggest to be more precise with the naming and replace "fresh"
with "free" or "empty" and always have bg or block_group as the qualifying name.
E.g. ffe_ctl->want_empty_bg

That would make the code a lot easier to follow and avoid confusions with other
things that can be fresh, like beer :)


-- 
Damien Le Moal
Western Digital Research
