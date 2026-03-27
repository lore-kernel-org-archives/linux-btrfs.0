Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E13377EA2;
	Fri, 27 Mar 2026 12:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774613245; cv=none; b=J7kcDJ76XykQUGlW5vzFJBdPL1KfPi3Q/IRl/UP8WB1znf1ciX+yjzDC2nWgCDpuWS1Yk7TDyxJoI00LlquCYgjkMXPH/arI9LmoudBUrYpe6Ucp70y58FoC2pI1JfriQbWRulsTWsx5zn/ihSSdxz1NSrYR0TjRQnubUF9mhRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774613245; c=relaxed/simple;
	bh=2nB5DCPY0+8yCmvF7X6fCAPWRpuyi5kzCg7/hMaBpWM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aOKGBT962fk65+rsMbkwPHtrXjeoiiI0gddCl1YI9g3ChR5kJxdl5hzhOZQ8p9cUGQn7oWztsv6DQ39Tk+VO71viUUpQYosNI25qqc1wow7JVRG5iBthVfGDvytPUAyJK6RX7VDEL2wp3SGoDpB5m/zOIYSOi34vGlbKIH+lJJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GV/OuxUv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GV/OuxUv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000F7C19423;
	Fri, 27 Mar 2026 12:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774613244;
	bh=2nB5DCPY0+8yCmvF7X6fCAPWRpuyi5kzCg7/hMaBpWM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GV/OuxUvODHLD58X/NXS2HIl2fDAtcrOkYl1usoY5dT3mhOCLFz+yYGOP1vLLqYOU
	 15w99o49viWVLThwMVhKQQ4mpejWHKm/7mtnHk603YlQMPyZeiGUpI1aYuUMTC1qoK
	 KP9QBrIxE8qH4usannUbPyhHkjf13t9L/naWuMmlMqpNeQm5IoyhpmO87gPoLqBf38
	 FLBh1X6kvQW7NNnskhElLwD+CVW0SDGiuK3j+25mlnqfgSphcqJQtpx/983A9czRbG
	 4lwP0/0dPbdKzGiM8hrNqbD6znlN6oHLzNcQqRNhGxdV9U8tI0Q7kPFORW+bOdT5XM
	 WrZvcbArOiAzg==
Date: Fri, 27 Mar 2026 12:07:22 +0000
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
Subject: Re: [PATCH v1 02/10] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Message-ID: <31d9d5c1-02af-42b3-bc3e-aea151d3552b@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-3-ziy@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327014255.2058916-3-ziy@nvidia.com>

On Thu, Mar 26, 2026 at 09:42:47PM -0400, Zi Yan wrote:
> collapse_file() requires FSes supporting large folio with at least
> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that. shmem with
> huge option turned on also sets large folio order on mapping, so the check
> also applies to shmem.
>
> While at it, replace VM_BUG_ON with returning failure values.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>



> ---
>  mm/khugepaged.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index d06d84219e1b..45b12ffb1550 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1899,8 +1899,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  	int nr_none = 0;
>  	bool is_shmem = shmem_file(file);
>
> -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
> -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
> +	/* "huge" shmem sets mapping folio order and passes the check below */

I think this isn't quite clear and could be improved to e.g.:

	/*
	 * Either anon shmem supports huge pages as set by shmem_enabled sysfs,
	 * or a shmem file system mounted with the "huge" option.
	 */

> +	if (mapping_max_folio_order(mapping) < PMD_ORDER)
> +		return SCAN_FAIL;

As per rest of thread, this looks correct.

> +	if (start & (HPAGE_PMD_NR - 1))
> +		return SCAN_ADDRESS_RANGE;

Hmm, we're kinda making this - presumably buggy situation - into a valid input
that just fails the scan.

Maybe just make it a VM_WARN_ON_ONCE()? Or if we want to avoid propagating the
bug that'd cause it any further:

	if (start & (HPAGE_PMD_NR - 1)) {
		VM_WARN_ON_ONCE(true);
		return SCAN_ADDRESS_RANGE;
	}

Or similar.

>
>  	result = alloc_charge_folio(&new_folio, mm, cc);
>  	if (result != SCAN_SUCCEED)
> --
> 2.43.0
>

Cheers, Lorenzo
