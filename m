Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E72C2116F4;
	Fri, 27 Mar 2026 14:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774620731; cv=none; b=sZeF1UfbOcgQf+dTgM9qZtOnGEG3OWKLQpykbWkY3Z1OvlssW/WFmwpFfZPGXgJ3bALA0oulw1qvAMchMPjUt6OROm8GpTCv1mFBTj63YGBjt2rKUl0gHWR/B/RdEg6Rmz0+UwAlbSIW+9wSvNm6vbmjp1pKwhkDJzbUJVtn3cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774620731; c=relaxed/simple;
	bh=10d/bauSZZwUaWeqxAp5AEl72kx44Zuct76qpMiWslM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fHwL37vM/4Xph0RE/KUgIay5MBdwx+GXirveotQTMvTP47Hji9RJPUeZYFbdflcsNw3pWSb6/++n0LW8ykZTLNT7QuxYb1xd+g8DH6pygtcpqkfTksjP4r5s329t6Je84g+g5JHa8pl5IJ8M5mzDC/Iggm3VozKLNieGKveJNqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FZfPFmxA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FZfPFmxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896DBC19423;
	Fri, 27 Mar 2026 14:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774620731;
	bh=10d/bauSZZwUaWeqxAp5AEl72kx44Zuct76qpMiWslM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FZfPFmxAuVBhLAkxJIgmHiPwI+Nesyrc086MBBCRNDFpEh3oTv1sjwFdmZ0AuaLPa
	 2DW/s9CaITCvU31XQKpY0QCn4MdCBJzpR2+h0aDrkIGdbhSu36GSw+ztSv2s839Rxa
	 oplhpvpdvKkReCNa0Nq2KZ6RNMLk1ctntQjuU2L4PJvjQTonb4xBAIiDqwXio+T+Ip
	 YT5sIdJtu4nlXcAkeW5rVMVdI3GK1zNsBY+51DSoN7785lZs73UnLXaiD7vDPKxoLV
	 tumNAiNeyQnpj0tqr0Q2JlowB2lo9qylylLn9K8SuCspmKR+dmHlXGZF2QoOsPRVm0
	 jtt0OXTV5qzCg==
Date: Fri, 27 Mar 2026 14:12:03 +0000
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
Message-ID: <89c8b93c-f6dd-4d8e-bcee-3c1ff1c04295@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-3-ziy@nvidia.com>
 <7fd90f5e-65b5-4734-abb2-77b22c733af5@linux.alibaba.com>
 <8f5119a1-9aa9-4a39-ac94-ca1631db26e1@lucifer.local>
 <ec927492-4577-4192-8fad-85eb1bb43121@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec927492-4577-4192-8fad-85eb1bb43121@linux.alibaba.com>

On Fri, Mar 27, 2026 at 09:45:03PM +0800, Baolin Wang wrote:
>
>
> On 3/27/26 8:02 PM, Lorenzo Stoakes (Oracle) wrote:
> > On Fri, Mar 27, 2026 at 05:44:49PM +0800, Baolin Wang wrote:
> > >
> > >
> > > On 3/27/26 9:42 AM, Zi Yan wrote:
> > > > collapse_file() requires FSes supporting large folio with at least
> > > > PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that. shmem with
> > > > huge option turned on also sets large folio order on mapping, so the check
> > > > also applies to shmem.
> > > >
> > > > While at it, replace VM_BUG_ON with returning failure values.
> > > >
> > > > Signed-off-by: Zi Yan <ziy@nvidia.com>
> > > > ---
> > > >    mm/khugepaged.c | 7 +++++--
> > > >    1 file changed, 5 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > > > index d06d84219e1b..45b12ffb1550 100644
> > > > --- a/mm/khugepaged.c
> > > > +++ b/mm/khugepaged.c
> > > > @@ -1899,8 +1899,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> > > >    	int nr_none = 0;
> > > >    	bool is_shmem = shmem_file(file);
> > > > -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
> > > > -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
> > > > +	/* "huge" shmem sets mapping folio order and passes the check below */
> > > > +	if (mapping_max_folio_order(mapping) < PMD_ORDER)
> > > > +		return SCAN_FAIL;
> > >
> > > This is not true for anonymous shmem, since its large order allocation logic
> > > is similar to anonymous memory. That means it will not call
> > > mapping_set_large_folios() for anonymous shmem.
> > >
> > > So I think the check should be:
> > >
> > > if (!is_shmem && mapping_max_folio_order(mapping) < PMD_ORDER)
> > >       return SCAN_FAIL;
> >
> > Hmm but in shmem_init() we have:
> >
> > #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > 	if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
> > 		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
> > 	else
> > 		shmem_huge = SHMEM_HUGE_NEVER; /* just in case it was patched */
> >
> > 	/*
> > 	 * Default to setting PMD-sized THP to inherit the global setting and
> > 	 * disable all other multi-size THPs.
> > 	 */
> > 	if (!shmem_orders_configured)
> > 		huge_shmem_orders_inherit = BIT(HPAGE_PMD_ORDER);
> > #endif
> >
> > And shm_mnt->mnt_sb is the superblock used for anon shmem. Also
> > shmem_enabled_store() updates that if necessary.
> >
> > So we're still fine right?
> >
> > __shmem_file_setup() (used for anon shmem) calls shmem_get_inode() ->
> > __shmem_get_inode() which has:
> >
> > 	if (sbinfo->huge)
> > 		mapping_set_large_folios(inode->i_mapping);
> >
> > Shared for both anon shmem and tmpfs-style shmem.
> >
> > So I think it's fine as-is.
>
> I'm afraid not. Sorry, I should have been clearer.
>
> First, anonymous shmem large order allocation is dynamically controlled via
> the global interface (/sys/kernel/mm/transparent_hugepage/shmem_enabled) and
> the mTHP interfaces
> (/sys/kernel/mm/transparent_hugepage/hugepages-*kB/shmem_enabled).
>
> This means that during anonymous shmem initialization, these interfaces
> might be set to 'never'. so it will not call mapping_set_large_folios()
> because sbinfo->huge is 'SHMEM_HUGE_NEVER'.
>
> Even if shmem large order allocation is subsequently enabled via the
> interfaces, __shmem_file_setup -> mapping_set_large_folios() is not called
> again.

I see your point, oh this is all a bit of a mess...

It feels like entirely the wrong abstraction anyway, since at best you're
getting a global 'is enabled'.

I guess what happened before was we'd never call into this with ! r/o thp for fs
&& ! is_shmem.

But now we are allowing it, but should STILL be gating on !is_shmem so yeah your
suggestion is correct I think actualyl.

I do hate:

	if (!is_shmem && mapping_max_folio_order(mapping) < PMD_ORDER)

As a bit of code though. It's horrible.

Let's abstract that...

It'd be nice if we could find a way to clean things up in the lead up to changes
in series like this instead of sticking with the mess, but I guess since it
mostly removes stuff that's ok for now.

>
> Anonymous shmem behaves similarly to anonymous pages: it is controlled by
> the 'shmem_enabled' interfaces and uses shmem_allowable_huge_orders() to
> check for allowed large orders, rather than relying on
> mapping_max_folio_order().
>
> The mapping_max_folio_order() is intended to control large page allocation
> only for tmpfs mounts. Therefore, I find the current code confusing and
> think it needs to be fixed:
>
> /* Don't consider 'deny' for emergencies and 'force' for testing */
> if (sb != shm_mnt->mnt_sb && sbinfo->huge)
>        mapping_set_large_folios(inode->i_mapping);

Cheers, Lorenzo
