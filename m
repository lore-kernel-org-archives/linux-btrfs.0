Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15869391827;
	Fri, 27 Mar 2026 12:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774614229; cv=none; b=b/I+Y0GX1SKEXE8b+eDlmfTcGimm8M9sE+B5UiqrSH37YsbfhM72PoRum3bMgJ1/bHqNFhiadpGQFUcZ684/giRjOIqhmJB/FzaBIkpQK03PUcRWRSWzF9nsk3WRBs4lBgL+m43mlVNcu2L4kewrCCxV8RXBVzQ2nX5L7CXgQJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774614229; c=relaxed/simple;
	bh=V8sGUJvbBSQZ15CzkQaKkEa1Er8HddnCsDI3BKLTvtU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kmbY/r/LGFVEQaBiMvMemZALlxGTPJTAWlnlTbCaQCcJ9qdpLF1yi+Ec5jzoGoZHOBdbQGVGqxb6vtJhTecqOD2EYVcJg1eeeRh1kkhIWPh6zqTAmUCM7MmAZCpTudSZPgYqxSYtdW1tys+zXPQduzvaeLj4pRExAP8Ov4CEZm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F8g4lx3T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F8g4lx3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B8CC2BC87;
	Fri, 27 Mar 2026 12:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774614228;
	bh=V8sGUJvbBSQZ15CzkQaKkEa1Er8HddnCsDI3BKLTvtU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F8g4lx3TiflLWf5tCAz6PYcHqfwkdC2OZT6fbVgng80WiGZeUSPvNUYNoJG8K5b1k
	 ctE+Y9mi2tJbXfyDuDYpL+MLulBxdZdLTJ7hf9Gv3NjsRIyv2n3D02pKsxew980YrY
	 4+aAgDeHNXTwUC9zVA8rD9RTvSfLv0b6MeQipBsM5cx/SVt0thD2DT5zRNOUOiBohx
	 XMc2WXmuFzojQexEc+KdEdDUrkHdVKh24ktJCp5ilaCqdqttDpFSYHjHh2i73tnbQz
	 gfZfOymgqxXaJrXm1saxMePV2fv6gwfSo+frkerGCyGdg58aV7PsrIPFpK3l/AGZwr
	 7gLG979b4EszA==
Date: Fri, 27 Mar 2026 12:23:46 +0000
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
Subject: Re: [PATCH v1 03/10] mm: fs: remove filemap_nr_thps*() functions and
 their users
Message-ID: <aaea8ce1-eac6-49d6-8c85-7361977b9a9f@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-4-ziy@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327014255.2058916-4-ziy@nvidia.com>

On Thu, Mar 26, 2026 at 09:42:48PM -0400, Zi Yan wrote:
> They are used by READ_ONLY_THP_FOR_FS to handle writes to FSes without
> large folio support, so that read-only THPs created in these FSes are not
> seen by the FSes when the underlying fd becomes writable. Now read-only PMD
> THPs only appear in a FS with large folio support and the supported orders
> include PMD_ORDRE.

Typo: PMD_ORDRE -> PMD_ORDER

>
> Signed-off-by: Zi Yan <ziy@nvidia.com>

This looks obviously-correct since this stuff wouldn't have been invoked for
large folio file systems before + they already had to handle it separately, and
this function is only tied to CONFIG_READ_ONLY_THP_FOR_FS (+ a quick grep
suggests you didn't miss anything), so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  fs/open.c               | 27 ---------------------------
>  include/linux/pagemap.h | 29 -----------------------------
>  mm/filemap.c            |  1 -
>  mm/huge_memory.c        |  1 -
>  mm/khugepaged.c         | 29 ++---------------------------
>  5 files changed, 2 insertions(+), 85 deletions(-)
>
> diff --git a/fs/open.c b/fs/open.c
> index 91f1139591ab..cef382d9d8b8 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -970,33 +970,6 @@ static int do_dentry_open(struct file *f,
>  	if ((f->f_flags & O_DIRECT) && !(f->f_mode & FMODE_CAN_ODIRECT))
>  		return -EINVAL;
>
> -	/*
> -	 * XXX: Huge page cache doesn't support writing yet. Drop all page
> -	 * cache for this file before processing writes.
> -	 */
> -	if (f->f_mode & FMODE_WRITE) {
> -		/*
> -		 * Depends on full fence from get_write_access() to synchronize
> -		 * against collapse_file() regarding i_writecount and nr_thps
> -		 * updates. Ensures subsequent insertion of THPs into the page
> -		 * cache will fail.
> -		 */
> -		if (filemap_nr_thps(inode->i_mapping)) {
> -			struct address_space *mapping = inode->i_mapping;
> -
> -			filemap_invalidate_lock(inode->i_mapping);
> -			/*
> -			 * unmap_mapping_range just need to be called once
> -			 * here, because the private pages is not need to be
> -			 * unmapped mapping (e.g. data segment of dynamic
> -			 * shared libraries here).
> -			 */
> -			unmap_mapping_range(mapping, 0, 0, 0);
> -			truncate_inode_pages(mapping, 0);
> -			filemap_invalidate_unlock(inode->i_mapping);
> -		}
> -	}
> -
>  	return 0;
>
>  cleanup_all:
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index ec442af3f886..dad3f8846cdc 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -530,35 +530,6 @@ static inline size_t mapping_max_folio_size(const struct address_space *mapping)
>  	return PAGE_SIZE << mapping_max_folio_order(mapping);
>  }
>
> -static inline int filemap_nr_thps(const struct address_space *mapping)
> -{
> -#ifdef CONFIG_READ_ONLY_THP_FOR_FS
> -	return atomic_read(&mapping->nr_thps);
> -#else
> -	return 0;
> -#endif
> -}
> -
> -static inline void filemap_nr_thps_inc(struct address_space *mapping)
> -{
> -#ifdef CONFIG_READ_ONLY_THP_FOR_FS
> -	if (!mapping_large_folio_support(mapping))
> -		atomic_inc(&mapping->nr_thps);
> -#else
> -	WARN_ON_ONCE(mapping_large_folio_support(mapping) == 0);
> -#endif
> -}
> -
> -static inline void filemap_nr_thps_dec(struct address_space *mapping)
> -{
> -#ifdef CONFIG_READ_ONLY_THP_FOR_FS
> -	if (!mapping_large_folio_support(mapping))
> -		atomic_dec(&mapping->nr_thps);
> -#else
> -	WARN_ON_ONCE(mapping_large_folio_support(mapping) == 0);
> -#endif
> -}
> -
>  struct address_space *folio_mapping(const struct folio *folio);
>
>  /**
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 2b933a1da9bd..4248e7cdecf3 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -189,7 +189,6 @@ static void filemap_unaccount_folio(struct address_space *mapping,
>  			lruvec_stat_mod_folio(folio, NR_SHMEM_THPS, -nr);
>  	} else if (folio_test_pmd_mappable(folio)) {
>  		lruvec_stat_mod_folio(folio, NR_FILE_THPS, -nr);
> -		filemap_nr_thps_dec(mapping);
>  	}
>  	if (test_bit(AS_KERNEL_FILE, &folio->mapping->flags))
>  		mod_node_page_state(folio_pgdat(folio),
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index b2a6060b3c20..c7873dbdc470 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3833,7 +3833,6 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
>  				} else {
>  					lruvec_stat_mod_folio(folio,
>  							NR_FILE_THPS, -nr);
> -					filemap_nr_thps_dec(mapping);
>  				}
>  			}
>  		}
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 45b12ffb1550..8004ab8de6d2 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2104,20 +2104,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  		goto xa_unlocked;
>  	}
>
> -	if (!is_shmem) {
> -		filemap_nr_thps_inc(mapping);
> -		/*
> -		 * Paired with the fence in do_dentry_open() -> get_write_access()
> -		 * to ensure i_writecount is up to date and the update to nr_thps
> -		 * is visible. Ensures the page cache will be truncated if the
> -		 * file is opened writable.
> -		 */
> -		smp_mb();
> -		if (inode_is_open_for_write(mapping->host)) {
> -			result = SCAN_FAIL;
> -			filemap_nr_thps_dec(mapping);
> -		}
> -	}
> +	if (!is_shmem && inode_is_open_for_write(mapping->host))
> +		result = SCAN_FAIL;
>
>  xa_locked:
>  	xas_unlock_irq(&xas);
> @@ -2296,19 +2284,6 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  		folio_putback_lru(folio);
>  		folio_put(folio);
>  	}
> -	/*
> -	 * Undo the updates of filemap_nr_thps_inc for non-SHMEM
> -	 * file only. This undo is not needed unless failure is
> -	 * due to SCAN_COPY_MC.
> -	 */
> -	if (!is_shmem && result == SCAN_COPY_MC) {
> -		filemap_nr_thps_dec(mapping);
> -		/*
> -		 * Paired with the fence in do_dentry_open() -> get_write_access()
> -		 * to ensure the update to nr_thps is visible.
> -		 */
> -		smp_mb();
> -	}
>
>  	new_folio->mapping = NULL;
>
> --
> 2.43.0
>

Cheers, Lorenzo
