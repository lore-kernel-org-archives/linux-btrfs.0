Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B74368277
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Mar 2026 03:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774582500; cv=none; b=SLyC10h3FA7qusKQYTOz6vVrh9Jc47gN6lPgFBDwXBLqSa0d4qwGgiTjroJKHs1MdBbhmxnccb0C1LaYZypaKavnxlbmtiu0UQ+knkp+btM74bNEdW9JPdXoqnhcLeo9kTISLBezrbupZuux2gVm8DRv/ulLBXe5JnHGTEgdJGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774582500; c=relaxed/simple;
	bh=rjU42GzsJ8D4He9RlZ1RusrcVlvGFOqA9ThQRr0yrls=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MbXi2pBdQz0g21OtwHbPMEqjO1bvahPS7S+d6LYaeyt2T5FjzrB4CQ+RMd2sojn3Irvqh8mKdcEWD0zaZzGjtJQkQPJEB6uUOcqzMU2hmJOn5ikAq4PgdVrqzRQ22nrmJ9dAZENUBeWbHXxb2ymtPkUt+Uqt3RqnodgKxDMuZ/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=I/gT1eEe; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="I/gT1eEe"
Message-ID: <1dcba0ef-372a-474b-8d70-23459f0f6511@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774582487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6TWDsxV9lU7FBIa32CWnztZa9knkN9tMw44cGL5HLts=;
	b=I/gT1eEeSyEToxNlVnMH/CCJCSe05HzFNgWKQFUlGhY6scwL4X6yf7paHgq/7XyJO3SNPM
	295kl4/TYQ1HT/bNr5evjmY0CbL2ZHx3LQvJ1UqEEUBKvShJ8GXELPnoHl9VJkxfs9m3WN
	p1t7HX2dffY2d9jJKwB6QxSFpOXagm8=
Date: Fri, 27 Mar 2026 11:33:43 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v1 07/10] mm/truncate: use folio_split() in
 truncate_inode_partial_folio()
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Song Liu <songliubraving@fb.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-8-ziy@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260327014255.2058916-8-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 2026/3/27 09:42, Zi Yan wrote:
> After READ_ONLY_THP_FOR_FS is removed, FS either supports large folio or
> not. folio_split() can be used on a FS with large folio support without
> worrying about getting a THP on a FS without large folio support.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   include/linux/huge_mm.h | 25 ++-----------------------
>   mm/truncate.c           |  8 ++++----
>   2 files changed, 6 insertions(+), 27 deletions(-)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 1258fa37e85b..171de8138e98 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -389,27 +389,6 @@ static inline int split_huge_page_to_order(struct page *page, unsigned int new_o
>   	return split_huge_page_to_list_to_order(page, NULL, new_order);
>   }
>   
> -/**
> - * try_folio_split_to_order() - try to split a @folio at @page to @new_order
> - * using non uniform split.
> - * @folio: folio to be split
> - * @page: split to @new_order at the given page
> - * @new_order: the target split order
> - *
> - * Try to split a @folio at @page using non uniform split to @new_order, if
> - * non uniform split is not supported, fall back to uniform split. After-split
> - * folios are put back to LRU list. Use min_order_for_split() to get the lower
> - * bound of @new_order.
> - *
> - * Return: 0 - split is successful, otherwise split failed.
> - */
> -static inline int try_folio_split_to_order(struct folio *folio,
> -		struct page *page, unsigned int new_order)
> -{
> -	if (folio_check_splittable(folio, new_order, SPLIT_TYPE_NON_UNIFORM))
> -		return split_huge_page_to_order(&folio->page, new_order);
> -	return folio_split(folio, new_order, page, NULL);
> -}
>   static inline int split_huge_page(struct page *page)
>   {
>   	return split_huge_page_to_list_to_order(page, NULL, 0);
> @@ -641,8 +620,8 @@ static inline int split_folio_to_list(struct folio *folio, struct list_head *lis
>   	return -EINVAL;
>   }
>   
> -static inline int try_folio_split_to_order(struct folio *folio,
> -		struct page *page, unsigned int new_order)
> +static inline int folio_split(struct folio *folio, unsigned int new_order,
> +		struct page *page, struct list_head *list);

Ouch, that ';' wasn't supposed to be there, right?
