Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABFA37F8B6;
	Sat, 25 Apr 2026 22:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777154492; cv=none; b=Rh72/Xt2i1UUpUGlVaQ+pRua8OCeyo2orfBI7OYYohg6jxef+bsJ3KE20uW1kk2J98Be1kkRKmzUHM/vsMDkU0ICYBr1QWt3CZh8S+9lPDCSXMiuf3CcfM+OJ4DB1PiE5wgJVgbJ07frhPkudnFC1143W4VnfU7Yv/oR630zQZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777154492; c=relaxed/simple;
	bh=0NuIDsEyNQ/Ifatv/CQaE7y12IP9xQxKHtJQ4WrtH/U=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=APnSQadpqWUf8ZPh6yHEODqRpS+FcidNzulqmf2Bc2hviSljTkmmZJy/6zNH4beYKOMkGUVZZ6GFQ05Jvyt6lBhP4SfGIJv0nYXsq224iXqVNYTIvQf/xVEwVYJ2eHBiquwpyyuila/3gSi2VBBpuYedR7s15Fuc+23rn+y2jiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qWwiMSnu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qWwiMSnu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94764C2BCB3;
	Sat, 25 Apr 2026 22:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777154492;
	bh=0NuIDsEyNQ/Ifatv/CQaE7y12IP9xQxKHtJQ4WrtH/U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qWwiMSnupHPl2CqJmPf5mv5cppTi87sHIgN8pIR1OUU5pCHxR6Hc+Oek1h/58ER7s
	 lIxgZPW9kw83+47mMnBo+ffv2OfnZlPugTdXzLSWW3ze7+vEtzognUMoc2P1bhJb6q
	 pyfFW6pYNWDsZj+NRecEwCULFziFnLmWvOW5PlxM=
Date: Sat, 25 Apr 2026 15:01:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Song Liu
 <songliubraving@fb.com>, Chris Mason <clm@fb.com>, David Sterba
 <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan
 <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v4 01/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check
Message-Id: <20260425150131.c4b3703b65e6de0fd3893d48@linux-foundation.org>
In-Reply-To: <20260424024915.28758-2-ziy@nvidia.com>
References: <20260424024915.28758-1-ziy@nvidia.com>
	<20260424024915.28758-2-ziy@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 23 Apr 2026 22:49:04 -0400 Zi Yan <ziy@nvidia.com> wrote:

> collapse_file() requires FSes supporting large folio with at least
> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.
> MADV_COLLAPSE ignores shmem huge config, so exclude the check for shmem.
> 
> While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.
> 
> Add a helper function mapping_pmd_thp_support() for FSes supporting large
> folio with at least PMD_ORDER.

My arm allnoconfig blew up.

> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -513,6 +513,15 @@ static inline bool mapping_large_folio_support(const struct address_space *mappi
>  	return mapping_max_folio_order(mapping) > 0;
>  }
>  
> +static inline bool mapping_pmd_thp_support(const struct address_space *mapping)
> +{
> +	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
> +	VM_WARN_ON_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON);
> +
> +	return mapping_max_folio_order(mapping) >= PMD_ORDER;
> +}
> +
> +

- Should it be named "mapping_pmd_thp_supported"?

- What does it actually *do*?  A little comment explaining this would
  be appropriate.

- Is it appropriate that this be inlined?

I added the below.


From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-khugepaged-remove-read_only_thp_for_fs-check-fix
Date: Sat Apr 25 02:54:04 PM PDT 2026

fix arm64 allnoconfig by uninlining mapping_pmd_thp_support()

In file included from ./include/linux/mm.h:31,
                 from fs/inode.c:9:
./include/linux/pagemap.h: In function 'mapping_pmd_thp_support':
./include/linux/pgtable.h:8:26: error: 'PMD_SHIFT' undeclared (first use in this function); did you mean 'PUD_SHIFT'?
    8 | #define PMD_ORDER       (PMD_SHIFT - PAGE_SHIFT)
      |                          ^~~~~~~~~
./include/linux/pagemap.h:521:52: note: in expansion of macro 'PMD_ORDER'
  521 |         return mapping_max_folio_order(mapping) >= PMD_ORDER;
      |                                                    ^~~~~~~~~
./include/linux/pgtable.h:8:26: note: each undeclared identifier is reported only once for each function it appears in
    8 | #define PMD_ORDER       (PMD_SHIFT - PAGE_SHIFT)
      |                          ^~~~~~~~~
./include/linux/pagemap.h:521:52: note: in expansion of macro 'PMD_ORDER'
  521 |         return mapping_max_folio_order(mapping) >= PMD_ORDER;
      |                                                    ^~~~~~~~~
make[3]: *** [scripts/Makefile.build:289: fs/inode.o] Error 1
make[2]: *** [scripts/Makefile.build:548: fs] Error 2
make[1]: *** [/usr/src/25/Makefile:2139: .] Error 2
make: *** [Makefile:248: __sub-make] Error 2

Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    9 +--------
 mm/filemap.c            |    8 ++++++++
 2 files changed, 9 insertions(+), 8 deletions(-)

--- a/include/linux/pagemap.h~mm-khugepaged-remove-read_only_thp_for_fs-check-fix
+++ a/include/linux/pagemap.h
@@ -513,14 +513,7 @@ static inline bool mapping_large_folio_s
 	return mapping_max_folio_order(mapping) > 0;
 }
 
-static inline bool mapping_pmd_thp_support(const struct address_space *mapping)
-{
-	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
-	VM_WARN_ON_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON);
-
-	return mapping_max_folio_order(mapping) >= PMD_ORDER;
-}
-
+bool mapping_pmd_thp_support(const struct address_space *mapping);
 
 /* Return the maximum folio size for this pagecache mapping, in bytes. */
 static inline size_t mapping_max_folio_size(const struct address_space *mapping)
--- a/mm/filemap.c~mm-khugepaged-remove-read_only_thp_for_fs-check-fix
+++ a/mm/filemap.c
@@ -126,6 +126,14 @@
  *    ->private_lock		(zap_pte_range->block_dirty_folio)
  */
 
+bool mapping_pmd_thp_support(const struct address_space *mapping)
+{
+	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
+	VM_WARN_ON_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON);
+
+	return mapping_max_folio_order(mapping) >= PMD_ORDER;
+}
+
 static void page_cache_delete(struct address_space *mapping,
 				   struct folio *folio, void *shadow)
 {
_

