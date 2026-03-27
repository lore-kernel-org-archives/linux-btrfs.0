Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669C83EB7FE;
	Fri, 27 Mar 2026 13:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774616714; cv=none; b=GtL9/84LiogaMPDXu670jIesh8ctdlJb/Eeo1vOk7ATroiRmFV/li+jpjlQLZVv1AA0pJgTLXRxJrQ3w8gIkrdYs25xSm/paoVHricqDCHjWSCYkWReVhe4CXe0WwclD+8sKlqk+fzCfzLFEaCOuMW/pRKezoUw0UJ2RBCn1vcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774616714; c=relaxed/simple;
	bh=PqXcV4WSvyMk8Vn+F2Kg1MQdaYAo4KXzJ8hAAWSm71g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ki3DW9pWysW2HZ4SR88fpKN7jzObTTSgbU02pk6HBEJv3P1vP4oICEa7CJ3UTyxMB8Re6fHjoBb0JZNHu5ZOWc8sgyrrELlYqtVT0ZCrx2Iz6TO1MjFjOJsPNeBLmOlO+fHxrnJwNqosEjaCs+7+2u3OMtZrFS6hQLN17FnoK4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c3NOQ76A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c3NOQ76A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85AE5C19423;
	Fri, 27 Mar 2026 13:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774616714;
	bh=PqXcV4WSvyMk8Vn+F2Kg1MQdaYAo4KXzJ8hAAWSm71g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c3NOQ76Ap+l+WZMg5rcl/obGqdtuXxtub6mu8Y6VCc7sPEedeVy2XMY7SGnFFtNoI
	 R9DN7RUE7167yC/+yjCqg2cN3gwubzdq8Z+Jo9+zZUc2Bl2cfARoATervXLZUexU8d
	 rWtlp9mulM+FNdsjE7IudqxHHwSpbSTfbY7epuZAbU804rQxk0ObhZwV0sz1pVQGiU
	 Iam59sv+UJxg0RMpKgIMo+JDSoDFE/WDvas0x4OcI9bKKdK9EmEaOz8oitQbWqWZ9g
	 D9wOW2+0iO5Z+ZJzRUJfxGu0608LwTeFBAn6+INnpsPy4jCkzkB8dbkQGoZTTNLtmc
	 vAQbCu8Jx6gFw==
Date: Fri, 27 Mar 2026 13:05:11 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 07/10] mm/truncate: use folio_split() in
 truncate_inode_partial_folio()
Message-ID: <e23792e4-3331-45b6-b709-cd0896146a3f@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-8-ziy@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327014255.2058916-8-ziy@nvidia.com>

On Thu, Mar 26, 2026 at 09:42:52PM -0400, Zi Yan wrote:
> After READ_ONLY_THP_FOR_FS is removed, FS either supports large folio or
> not. folio_split() can be used on a FS with large folio support without
> worrying about getting a THP on a FS without large folio support.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  include/linux/huge_mm.h | 25 ++-----------------------
>  mm/truncate.c           |  8 ++++----
>  2 files changed, 6 insertions(+), 27 deletions(-)
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 1258fa37e85b..171de8138e98 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -389,27 +389,6 @@ static inline int split_huge_page_to_order(struct page *page, unsigned int new_o
>  	return split_huge_page_to_list_to_order(page, NULL, new_order);
>  }
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
>  static inline int split_huge_page(struct page *page)
>  {
>  	return split_huge_page_to_list_to_order(page, NULL, 0);
> @@ -641,8 +620,8 @@ static inline int split_folio_to_list(struct folio *folio, struct list_head *lis
>  	return -EINVAL;
>  }

Hmm there's nothing in the comment or obvious jumping out at me to explain why
this is R/O thp file-backed only?

This seems like an arbitrary helper that just figures out whether it can split
using the non-uniform approach.

I think you need to explain more in the commit message why this was R/O thp
file-backed only, maybe mention some commits that added it etc., I had a quick
glance and even that didn't indicate why.

I look at folio_check_splittable() for instance and see:

	...

	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
		    !mapping_large_folio_support(folio->mapping)) {
			...
			return -EINVAL;
		}
	}

	...

	if ((split_type == SPLIT_TYPE_NON_UNIFORM || new_order) && folio_test_swapcache(folio)) {
		return -EINVAL;
	}

	if (is_huge_zero_folio(folio))
		return -EINVAL;

	if (folio_test_writeback(folio))
		return -EBUSY;

	return 0;
}

None of which suggest that you couldn't have non-uniform splits for other
cases? This at least needs some more explanation/justification in the
commit msg.

>
> -static inline int try_folio_split_to_order(struct folio *folio,
> -		struct page *page, unsigned int new_order)
> +static inline int folio_split(struct folio *folio, unsigned int new_order,
> +		struct page *page, struct list_head *list);

Yeah as Lance pointed out that ; probably shouldn't be there :)

>  {
>  	VM_WARN_ON_ONCE_FOLIO(1, folio);
>  	return -EINVAL;
> diff --git a/mm/truncate.c b/mm/truncate.c
> index 2931d66c16d0..6973b05ec4b8 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -177,7 +177,7 @@ int truncate_inode_folio(struct address_space *mapping, struct folio *folio)
>  	return 0;
>  }
>
> -static int try_folio_split_or_unmap(struct folio *folio, struct page *split_at,
> +static int folio_split_or_unmap(struct folio *folio, struct page *split_at,
>  				    unsigned long min_order)

I'm not sure the removal of 'try_' is warranted in general in this patch,
as it seems like it's not guaranteed any of these will succeed? Or am I
wrong?

>  {
>  	enum ttu_flags ttu_flags =
> @@ -186,7 +186,7 @@ static int try_folio_split_or_unmap(struct folio *folio, struct page *split_at,
>  		TTU_IGNORE_MLOCK;
>  	int ret;
>
> -	ret = try_folio_split_to_order(folio, split_at, min_order);
> +	ret = folio_split(folio, min_order, split_at, NULL);
>
>  	/*
>  	 * If the split fails, unmap the folio, so it will be refaulted
> @@ -252,7 +252,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>
>  	min_order = mapping_min_folio_order(folio->mapping);
>  	split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
> -	if (!try_folio_split_or_unmap(folio, split_at, min_order)) {
> +	if (!folio_split_or_unmap(folio, split_at, min_order)) {
>  		/*
>  		 * try to split at offset + length to make sure folios within
>  		 * the range can be dropped, especially to avoid memory waste
> @@ -279,7 +279,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>  		/* make sure folio2 is large and does not change its mapping */
>  		if (folio_test_large(folio2) &&
>  		    folio2->mapping == folio->mapping)
> -			try_folio_split_or_unmap(folio2, split_at2, min_order);
> +			folio_split_or_unmap(folio2, split_at2, min_order);
>
>  		folio_unlock(folio2);
>  out:
> --
> 2.43.0
>

Cheers, Lorenzo
