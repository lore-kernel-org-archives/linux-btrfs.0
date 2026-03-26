Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC043A0E88;
	Thu, 26 Mar 2026 19:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774554076; cv=none; b=DiBEycZ7oWGl0duzAIzap+fs9C2R2wauxcQXYHbildkpYYp9r+Dd6+6cfrQvafH4ab0bDxGCvfBTYYD9Zx1QVx+zCh39ChAIrvAXctYMQdHNXceO2B98idYQ/BeVaUerP0/uzU07zl6KPYU5RHSR0iNLA8E3Zn3UELN52zJJpQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774554076; c=relaxed/simple;
	bh=C9/NPr+Pl9jEmgwpnRIFZPHBQXxhE7qS+DKPun17jRU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oEIypXcQE2GTS7e8J2+P/1DLmaQvh/TgQFxCEt/DUmdK/J8SFwlhsKkqANQkFT8086iewy1v0Jrsfd8f7lt69mfryEAmXfwyXI/p+oOzmGTocGHAfroTngywqPS7QfEzU41IFMWI6EABWpvvxcaSkQErbdRQw6FGFvjlYAEVC2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Luq0fhBB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Luq0fhBB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481ABC116C6;
	Thu, 26 Mar 2026 19:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774554076;
	bh=C9/NPr+Pl9jEmgwpnRIFZPHBQXxhE7qS+DKPun17jRU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Luq0fhBBvzuS68tdGrtzBRVbaH6F0u71w94JQ5jl8BJZ6EU+NlyhUlt9ojWyV5JId
	 8n1NjlymQFXD2/hdKtTgTzzjBL58MKIxYXjWixu4nhbMTLf31PEcUQbRF3mz3MgdYB
	 ugp/abGLULr7kmkqLOFOZLys4fA0+ZKIcP/o8BYlzUCRVl5TIYYUy3uLiujrWIIInW
	 3sPBmRr3RaItnMh0A5/DYKtRKjYXLVe5NO1YIilKQjQ0ahLscsAsWXIzYCZTsUTTer
	 5d2157eWwXaZs7aHMpkA7+5+AmCs1vPQh6u8t98bY2wdlmkmLWY2q7Vfk5bQl0vyjF
	 KZrpHW/gMK8Ng==
Date: Thu, 26 Mar 2026 09:41:14 -1000
From: Tejun Heo <tj@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, puranjay@kernel.org,
	linux-crypto@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Michael van der Westhuizen <rmikey@meta.com>, kernel-team@meta.com,
	Chuck Lever <chuck.lever@oracle.com>, jlayton@kernel.or
Subject: Re: [PATCH v2 2/5] workqueue: add WQ_AFFN_CACHE_SHARD affinity scope
Message-ID: <acWL2hxO7m2H4g_r@slm.duckdns.org>
References: <20260320-workqueue_sharded-v2-0-8372930931af@debian.org>
 <20260320-workqueue_sharded-v2-2-8372930931af@debian.org>
 <acHCE96gzEUaGZFP@slm.duckdns.org>
 <acVbF0cGGJx--Tci@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <acVbF0cGGJx--Tci@gmail.com>

On Thu, Mar 26, 2026 at 09:20:15AM -0700, Breno Leitao wrote:
> Assuming wq_cache_shard_size = 8;, we would have the following number of pool
> per number of CPU (not vCPU):
> 
>   - 1–11 CPUs → DIV_ROUND_CLOSEST(n, 8) ≤ 1 → 1 pool containing all CPUs.
>   - 12 CPUs → DIV_ROUND_CLOSEST(12, 8) = 2 → 2 pools of 6 cores each. This is the first split.
>   - 12–19 → 2 pools
>   - 20–27 → 3 pools
>   - 28–35 → 4 pools
>   - 36–43 → 5 pools
>   - 44–51 → 6 pools
>   - 52–59 → 7 pools
>   - 60–67 → 8 pools
>   - 68–75 → 9 pools (e.g. 72-CPU NVIDIA Grace → 9×8)
>   - 76–83 → 10 pools
>   - 84–91 → 11 pools
>   - 92–99 → 12 pools
>   - 100 → 13 pools (9×8 + 4×7)
> 
> Is this what you meant?

Yes.

> +static int __init llc_core_to_shard(int core_pos, int cores_per_shard,
> +				    int remainder)
> +{
> +	int ret;
> +
> +	/*
> +	 * These cores falls within the large shards.
> +	 * Each large shard has (cores_per_shard + 1) cores
> +	 */
> +	if (core_pos < remainder * (cores_per_shard + 1))
> +		return core_pos / (cores_per_shard + 1);
> +
> +	/* These are standard shards */
> +	ret = (core_pos - remainder * (cores_per_shard + 1)) / cores_per_shard;

This is too smart. Any chance you can dumb it down? If you have to go
through intermediate data structures, that's fine too.

Thanks.

-- 
tejun
