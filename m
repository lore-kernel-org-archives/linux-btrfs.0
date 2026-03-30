Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E1A33FE0A
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2026 16:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774889539; cv=none; b=l/et17NxgrTBzNJ/ZGdCl6sctOFwj7MfDwRINk0G/BPwt6pgsqfIjWAHjmKvfYwVQMXQllXtuhKgot1Mn5RWUTetfvhdlRRn/Y09mF4LTLG/cDewiEzXKaczl4Nfa3j1O93Ot1+Bt0gpuGfEeU6GGXhfDpF/nQ1RxHTJJyfhjE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774889539; c=relaxed/simple;
	bh=7iLsUgEX7iZN20c7wQ3B573K6TjSCEV3VvQd7mKwN2Y=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=WuaflvqZs8DgtO0Sk6Up/UBELAbxZJwYBsjL1t4+69kEGTyYxGXIWmKTjZpKjNj1VoouW8VUNh1THYWI1fvlCwsKkZV4So+NrCBU01f4zT1BLCTOH0hOPR8x68SCmHTb4sfUcGaVeR8HfBjPK8LYFhv3b8HNf0AswNniXIITssY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TFGpY172; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TFGpY172"
Message-ID: <d8c0d07d-67a6-4ced-9096-e65aaa44cf5a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774889534;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x/yj4OHkYiBZh5qKSnXYJVVHlo7bZLsP8BqorK1lmY4=;
	b=TFGpY172Gf45271athEvtQxtN3rTvAIPvKfJp0n5mq0L35JyWf23ohh191Z1pM7StNLtNd
	U23Yr0BW20gciv5pcNMQdEGLZ8gcITpxCayTJfkJxS/mIcdTx7V5NGo5n3Wl2iiuBxOMdT
	yNk9VhWKdCoqGVGpf2aJR20EGYDNLLU=
Date: Mon, 30 Mar 2026 09:52:10 -0700
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [RESEND PATCH v2] btrfs: prevent direct reclaim during compressed
 readahead
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
To: mark@harmstone.com, boris@bur.io, wqu@suse.com, dsterba@suse.com,
 clm@fb.com, linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-team@meta.com
References: <20260328214619.114790-1-jp.kobryn@linux.dev>
Content-Language: en-US
In-Reply-To: <20260328214619.114790-1-jp.kobryn@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Qu,
Can you give v2 a look?

On 3/28/26 2:46 PM, JP Kobryn (Meta) wrote:
> Under memory pressure, direct reclaim can kick in during compressed
> readahead. This puts the associated task into D-state. Then shrink_lruvec()
> disables interrupts when acquiring the LRU lock. Under heavy pressure,
> we've observed reclaim can run long enough that the CPU becomes prone to
> CSD lock stalls since it cannot service incoming IPIs. Although the CSD
> lock stalls are the worst case scenario, we have found many more subtle
> occurrences of this latency on the order of seconds, over a minute in some
> cases.
> 
> Prevent direct reclaim during compressed readahead. This is achieved by
> using different GFP flags at key points when the bio is marked for
> readahead.
> 
> There are two functions that allocate during compressed readahead:
> btrfs_alloc_compr_folio() and add_ra_bio_pages(). Both currently use
> GFP_NOFS which includes __GFP_DIRECT_RECLAIM.
> 
> For the internal API call btrfs_alloc_compr_folio(), the signature changes
> to accept an additional gfp_t parameter. At the readahead call site, it
> gets flags similar to GFP_NOFS but stripped of __GFP_DIRECT_RECLAIM.
> __GFP_NOWARN is added since these allocations are allowed to fail. Demand
> reads still use full GFP_NOFS and will enter reclaim if needed. All other
> existing call sites of btrfs_alloc_compr_folio() now explicitly pass
> GFP_NOFS to retain their current behavior.
> 
> add_ra_bio_pages() gains a bool parameter which allows callers to specify
> if they want to allow direct reclaim or not. In either case, the
> __GFP_NOWARN flag was added unconditionally since the allocations are
> speculative.
> 
> There has been some previous work done on calling add_ra_bio_pages() [0].
> This patch is complementary: where that patch reduces call frequency, this
> patch reduces the latency associated with those calls.
> 
> [0] https://lore.kernel.org/linux-btrfs/656838ec1232314a2657716e59f4f15a8eadba64.1751492111.git.boris@bur.io/
> 
> Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
> Reviewed-by: Mark Harmstone <mark@harmstone.com>
> ---
> v2:
>   - dropped patch 1/2, squashed into single patch based on David's feedback
>   - changed btrfs_alloc_compr_folio() signature instead of new _gfp variant
>   - update other existing callers to pass GFP_NOFS explicitly
> 
> v1: https://lore.kernel.org/linux-btrfs/20260320073445.80218-1-jp.kobryn@linux.dev/
> 
[...]
