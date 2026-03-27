Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C7A39EF23;
	Fri, 27 Mar 2026 12:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774615836; cv=none; b=qER/rxGvdeZmdeXLQfRgfWRco09BfSnXq2cR6ss+cd9FWkSH6J99UZLjiCadoeclftaDLqjymRJnkd2/vGEN7KW2o4c2OFPA1matR5ON3Pbc4J56w3C+X0Ca5CHPN+0pKAB5yLkwlrsIKvDmvO4ofeoS49b7CDGlmJE+Z8w/nUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774615836; c=relaxed/simple;
	bh=7TtvxfvBKonF+oVtDcunkjFuZJVVhgHI8FyFmO9gAyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NzUx5PYB+NEfGDBvwZ6tPwXU6Mj2agjJ5UDbPWjskMB7A3R5B5kJMOw/hDxFAy5C6MJS3fH1ybwqlLoPKBUuLN695gLiBJN+2gSUTDVkit0hrwUoMLTLn1UdWKpmOzr6XM8wDl3f4vo+w/MyHrSiJQT6m8yky1i6x7UZhxjZx0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dbrt/V4U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dbrt/V4U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3774DC19423;
	Fri, 27 Mar 2026 12:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774615835;
	bh=7TtvxfvBKonF+oVtDcunkjFuZJVVhgHI8FyFmO9gAyY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dbrt/V4U3RhDsEEVQice4TAK4sJiHyb4Calj2k3bm3O2B2llHOuxX9IC0SP/Ooufj
	 JKx+gTxPfFON6p/vKpJsGfUm7cJLFZFJf5/wmGK4M5PmC+rL0K2N5sSwFvcU/9lYRe
	 nfsyXZ91doAm0vVLg3oO3pP0FG6a21YhfdVKVCh5Iy9pYCpPb8QbfeD40nECYwrfuZ
	 EGmtmUxAUOUPOOdjKLVDzABtHSkbofi91uoQUVuMOarXnIoyaZ6g1qxjdzE8d6/APx
	 t3jBYudMko9aT53uZlcaIA+tqoETqvMZsu/56Nwx56rIg6ijstSfa6CPmDX0mnlhHP
	 tQouBAQ0ri3rQ==
Date: Fri, 27 Mar 2026 12:50:33 +0000
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
Subject: Re: [PATCH v1 06/10] mm/huge_memory: remove folio split check for
 READ_ONLY_THP_FOR_FS
Message-ID: <e5eed307-c0da-4de8-8be8-eb52e2af413e@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-7-ziy@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327014255.2058916-7-ziy@nvidia.com>

On Thu, Mar 26, 2026 at 09:42:51PM -0400, Zi Yan wrote:
> Without READ_ONLY_THP_FOR_FS, large file-backed folios cannot be created by
> a FS without large folio support. The check is no longer needed.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Seems legitimate, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/huge_memory.c | 22 ----------------------
>  1 file changed, 22 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 1da1467328a3..30eddcbf86f1 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3732,28 +3732,6 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
>  		/* order-1 is not supported for anonymous THP. */
>  		if (new_order == 1)
>  			return -EINVAL;
> -	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
> -		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
> -		    !mapping_large_folio_support(folio->mapping)) {
> -			/*
> -			 * We can always split a folio down to a single page
> -			 * (new_order == 0) uniformly.
> -			 *
> -			 * For any other scenario
> -			 *   a) uniform split targeting a large folio
> -			 *      (new_order > 0)
> -			 *   b) any non-uniform split
> -			 * we must confirm that the file system supports large
> -			 * folios.
> -			 *
> -			 * Note that we might still have THPs in such
> -			 * mappings, which is created from khugepaged when
> -			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
> -			 * case, the mapping does not actually support large
> -			 * folios properly.
> -			 */
> -			return -EINVAL;
> -		}
>  	}
>
>  	/*
> --
> 2.43.0
>
