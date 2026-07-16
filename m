Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E5F3B27F3;
	Thu, 16 Jul 2026 10:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784196312; cv=none; b=gsGeGKT2og6JPN+ZTP44lkTAQpya/u82oQi3YAr4rEvaldPzCkIu+5dN2FUOvYCjyPUMjL5hxdKwG/wp+Cj82eM2xCW4rkjj13KtZKX+R52+fAcaB+7HvzllqpkmCcXGaDtOUHpqPmRDodpYyqIBQUM4mzgRJDbpqF0gcdGF4wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784196312; c=relaxed/simple;
	bh=RdoHU5m00yBlcM6/EwN3D1PKI/00v8/DGwGDdzgyR8k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CY4C3gnF8WXdS36ECsvneSIkGVPpvZUmZe3soQ+Sflvc8iAngn+mwqvq1RseB6LVhsUNCaWdb9NCsGLHYJl6RXUQmR7aATSjGub5c98UP2yowKYpMGQWFStkmqmfttgOeAxPX/H2bbzlWe+6CdbKGr5uDTYj+SNjeXRf5pnBNRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ksnfh6eG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ksnfh6eG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7E41F00A3A;
	Thu, 16 Jul 2026 10:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784196310;
	bh=ff09r8WSJFJe3vIaHtpOtkrOMGaD3zvc3JToEJZ+6XQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ksnfh6eGMevX1hWC4T7/Eb2TZ02zXHxAhXHRlawVmuWi3C2uvnH8H6mVIoo7xW3zd
	 o4zRjtrLn69d9zS7wCrfhprrH41bbzWLuCJ2rmG1iVTuvUcsrmYPhpjTh+D6FDHhp/
	 Nx4wLJlwRbv/DGvrRosD5xSbrn5phGvuu6e7UrVTRQkpCE88jf0/FWpgDyHMcHbw7l
	 txr3UJzp1SehQw72lbhdY105FdegbgiOYrLayDdsORxYJ3kRrrQSkT2rxDfSuwqIo0
	 JxLbYipwLzau+DJRxOO7MjchPjAmeZVQMUedL+5ornMq7W77HufZ0GHicmJ67lj8dN
	 R1sfQSs6B84dA==
Message-ID: <eb4d4f50-f60f-4a4e-8e9b-6dbb69b8e0e4@kernel.org>
Date: Thu, 16 Jul 2026 12:05:06 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] block: do not warn when doing greedy allocation in
 folio_alloc_greedy()
Content-Language: en-US
To: Christoph Hellwig <hch@infradead.org>, Qu Wenruo <wqu@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Matthew Wilcox <willy@infradead.org>
Cc: linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org,
 linux-mm@kvack.org
References: <d10571445ee505d95ba6eaad7558fc1f556d2921.1784020005.git.wqu@suse.com>
 <alikjtke-YNWdd1I@infradead.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <alikjtke-YNWdd1I@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/16/26 11:29, Christoph Hellwig wrote:
> On Tue, Jul 14, 2026 at 06:37:39PM +0930, Qu Wenruo wrote:
>>  	while (*size > minsize) {
>> -		folio = folio_alloc(gfp | __GFP_NORETRY, get_order(*size));
>> +		folio = folio_alloc(gfp | __GFP_NORETRY | __GFP_NOWARN,
>> +				    get_order(*size));
> 
> I though I read somewhere that we now don't have to specify
> __GFP_NOWARN when using __GFP_NORETRY, but a quick dive into the page
> allocator suggest that no such thing exists.

There was a change a while ago that added __GFP_NOWARN to GFP_NOWAIT, maybe
that's what you read about?

> But can we make it happen?  Having to specify __GFP_NOWARN when the
> caller clearly indicated that failure is perfectly fine using
> __GFP_NORETRY is silly.  The same probably applies to
> __GFP_RETRY_MAYFAIL.

It makes sense to me. The risk of missing some useful warning due to a
coding error (conjuring up an unexpected __GFP_NORETRY/__GFP_RETRY_MAYFAIL
in whatever way and then silently failing) is probably low here and it makes
the API better.
