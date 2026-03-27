Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E47C3F7E9C;
	Fri, 27 Mar 2026 14:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774621873; cv=none; b=V/ELPGJvy2w1LV74rgdg2ienVc1GWzuciTbxrisi/ID96dAhuaMxf3qYwDdzcbl/Rt6aRGG6oX8XtZBiYWdHdHfUPOHQNTeAUrx+ceiE/v7/sVEBUpzmitKj/PElhsOmBtmX0g/cPPcogkJAOCCX/7/2cQiCEvW8cF0ZareRiwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774621873; c=relaxed/simple;
	bh=MrvKjRWkl1Y6HHbAPwGm0kWozY8T3Glyl78Hgi7yspY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aROwFMGDBJhBez+iVFVDQ7dyPpEZxFiQYcoKcfFWdSqE9r9BSUywzMWnyITOxSZJEBMNXhuJY32QjYIL7f14/Td5nMgeP+uNxV4fjjWxCaGRK0K2BwZ5Ou0d2R4a5bsNiWVRb6aXVkBeixDwNAZwf18qUWLY0rmn2KfNvbgaRXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FA65YRld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FA65YRld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8E8C2BC87;
	Fri, 27 Mar 2026 14:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774621873;
	bh=MrvKjRWkl1Y6HHbAPwGm0kWozY8T3Glyl78Hgi7yspY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FA65YRldQYG5G3drQMMoAc8SfQ4mmeIUA90nBgmb1APmS8p6BhrzYu9nrBDDjJfto
	 tMBA9seiAdGawC246pLjV+Fl5yut7bDI2tSd1BoHbsW+K3JnTkXzANWLMFai+Z0b+8
	 +lyTw8FpFfTPmDRtT9Qo8aGRXT3lo236j74uh/mLZvP2qfIlCIGdmBFY+f1STVdcdV
	 i7GtH/LWRU0i++pN+8Bt945zXeQXk5IQKYViC1aplops7W8LmQ8KPMcMekKZnq2GHT
	 wZX83qWDlNnCQT3ZAIXM+3nmM7S475HJjU6WRuj+KtTSvG7Mw46mbRhKWnsePUXjna
	 7p88Q+af6JbLw==
Date: Fri, 27 Mar 2026 14:31:05 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 02/10] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Message-ID: <6442d533-27ae-4e2d-b8d1-64acdd2dfbd9@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-3-ziy@nvidia.com>
 <7fd90f5e-65b5-4734-abb2-77b22c733af5@linux.alibaba.com>
 <8f5119a1-9aa9-4a39-ac94-ca1631db26e1@lucifer.local>
 <ec927492-4577-4192-8fad-85eb1bb43121@linux.alibaba.com>
 <89c8b93c-f6dd-4d8e-bcee-3c1ff1c04295@lucifer.local>
 <b9bc241f-91a0-4df3-a5fb-2221bee3ab68@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9bc241f-91a0-4df3-a5fb-2221bee3ab68@linux.alibaba.com>

On Fri, Mar 27, 2026 at 10:26:53PM +0800, Baolin Wang wrote:
>
>
> On 3/27/26 10:12 PM, Lorenzo Stoakes (Oracle) wrote:
> > On Fri, Mar 27, 2026 at 09:45:03PM +0800, Baolin Wang wrote:
> > >
> > >
> > > On 3/27/26 8:02 PM, Lorenzo Stoakes (Oracle) wrote:
> > > > On Fri, Mar 27, 2026 at 05:44:49PM +0800, Baolin Wang wrote:
> > > > >
> > > > >
> > > > > On 3/27/26 9:42 AM, Zi Yan wrote:
> > > > > > collapse_file() requires FSes supporting large folio with at least
> > > > > > PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that. shmem with
> > > > > > huge option turned on also sets large folio order on mapping, so the check
> > > > > > also applies to shmem.
> > > > > >
> > > > > > While at it, replace VM_BUG_ON with returning failure values.
> > > > > >
> > > > > > Signed-off-by: Zi Yan <ziy@nvidia.com>
> > > > > > ---
> > > > > >     mm/khugepaged.c | 7 +++++--
> > > > > >     1 file changed, 5 insertions(+), 2 deletions(-)
> > > > > >
> > > > > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > > > > > index d06d84219e1b..45b12ffb1550 100644
> > > > > > --- a/mm/khugepaged.c
> > > > > > +++ b/mm/khugepaged.c
> > > > > > @@ -1899,8 +1899,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> > > > > >     	int nr_none = 0;
> > > > > >     	bool is_shmem = shmem_file(file);
> > > > > > -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
> > > > > > -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
> > > > > > +	/* "huge" shmem sets mapping folio order and passes the check below */
> > > > > > +	if (mapping_max_folio_order(mapping) < PMD_ORDER)
> > > > > > +		return SCAN_FAIL;
> > > > >
> > > > > This is not true for anonymous shmem, since its large order allocation logic
> > > > > is similar to anonymous memory. That means it will not call
> > > > > mapping_set_large_folios() for anonymous shmem.
> > > > >
> > > > > So I think the check should be:
> > > > >
> > > > > if (!is_shmem && mapping_max_folio_order(mapping) < PMD_ORDER)
> > > > >        return SCAN_FAIL;
> > > >
> > > > Hmm but in shmem_init() we have:
> > > >
> > > > #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > > > 	if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
> > > > 		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
> > > > 	else
> > > > 		shmem_huge = SHMEM_HUGE_NEVER; /* just in case it was patched */
> > > >
> > > > 	/*
> > > > 	 * Default to setting PMD-sized THP to inherit the global setting and
> > > > 	 * disable all other multi-size THPs.
> > > > 	 */
> > > > 	if (!shmem_orders_configured)
> > > > 		huge_shmem_orders_inherit = BIT(HPAGE_PMD_ORDER);
> > > > #endif
> > > >
> > > > And shm_mnt->mnt_sb is the superblock used for anon shmem. Also
> > > > shmem_enabled_store() updates that if necessary.
> > > >
> > > > So we're still fine right?
> > > >
> > > > __shmem_file_setup() (used for anon shmem) calls shmem_get_inode() ->
> > > > __shmem_get_inode() which has:
> > > >
> > > > 	if (sbinfo->huge)
> > > > 		mapping_set_large_folios(inode->i_mapping);
> > > >
> > > > Shared for both anon shmem and tmpfs-style shmem.
> > > >
> > > > So I think it's fine as-is.
> > >
> > > I'm afraid not. Sorry, I should have been clearer.
> > >
> > > First, anonymous shmem large order allocation is dynamically controlled via
> > > the global interface (/sys/kernel/mm/transparent_hugepage/shmem_enabled) and
> > > the mTHP interfaces
> > > (/sys/kernel/mm/transparent_hugepage/hugepages-*kB/shmem_enabled).
> > >
> > > This means that during anonymous shmem initialization, these interfaces
> > > might be set to 'never'. so it will not call mapping_set_large_folios()
> > > because sbinfo->huge is 'SHMEM_HUGE_NEVER'.
> > >
> > > Even if shmem large order allocation is subsequently enabled via the
> > > interfaces, __shmem_file_setup -> mapping_set_large_folios() is not called
> > > again.
> >
> > I see your point, oh this is all a bit of a mess...
> >
> > It feels like entirely the wrong abstraction anyway, since at best you're
> > getting a global 'is enabled'.
> >
> > I guess what happened before was we'd never call into this with ! r/o thp for fs
> > && ! is_shmem.
>
> Right.
>
> > But now we are allowing it, but should STILL be gating on !is_shmem so yeah your
> > suggestion is correct I think actualyl.
> >
> > I do hate:
> >
> > 	if (!is_shmem && mapping_max_folio_order(mapping) < PMD_ORDER)
> >
> > As a bit of code though. It's horrible.
>
> Indeed.
>
> > Let's abstract that...
> >
> > It'd be nice if we could find a way to clean things up in the lead up to changes
> > in series like this instead of sticking with the mess, but I guess since it
> > mostly removes stuff that's ok for now.
>
> I think this check can be removed from this patch.
>
> During the khugepaged's scan, it will call thp_vma_allowable_order() to
> check if the VMA is allowed to collapse into a PMD.
>
> Specifically, within the call chain thp_vma_allowable_order() ->
> __thp_vma_allowable_orders(), shmem is checked via
> shmem_allowable_huge_orders(), while other FSes are checked via
> file_thp_enabled().

It sucks not to have an assert. Maybe in that case make it a
VM_WARN_ON_ONCE().

I hate that you're left tracing things back like that...

>
> For those other filesystems, Patch 5 has already added the following check,
> which I think is sufficient to filter out those FSes that do not support
> large folios:
>
> if (mapping_max_folio_order(inode->i_mapping) < PMD_ORDER)
> 	return false;

2 < 5, we won't tolerate bisection hazards.

>
>
> > > Anonymous shmem behaves similarly to anonymous pages: it is controlled by
> > > the 'shmem_enabled' interfaces and uses shmem_allowable_huge_orders() to
> > > check for allowed large orders, rather than relying on
> > > mapping_max_folio_order().
> > >
> > > The mapping_max_folio_order() is intended to control large page allocation
> > > only for tmpfs mounts. Therefore, I find the current code confusing and
> > > think it needs to be fixed:
> > >
> > > /* Don't consider 'deny' for emergencies and 'force' for testing */
> > > if (sb != shm_mnt->mnt_sb && sbinfo->huge)
> > >         mapping_set_large_folios(inode->i_mapping);
> >
> > Cheers, Lorenzo
>

Cheers, Lorenzo
