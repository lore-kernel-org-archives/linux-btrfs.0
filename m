Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40B4332634;
	Fri, 27 Mar 2026 12:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774612930; cv=none; b=gohs7BIDDfu3H805Sg1VY2uyHeQaw1zykA8fJEFevFEqxI06NZFa/9CAZBFdKSVFCAJyA11GlR0q9ZLDQhb2huONVXpRx7JdkkQ6Y7BH1NaG/jofDLETFMQt/Qr4UqGuxW7sR+yxQQbOybsVDT/d9hjbPdcppfChY4/n7cG/fdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774612930; c=relaxed/simple;
	bh=Ug6PXMZj5EM6WaHP8j75mffKH6tZAhlPhePI6D/ozn8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sBh6zY9gIuJ5W8skWlhmR1G0LrK+xUycu1lh6jZwNxPjEIwlqGBIV3CEpIwSONMzGPsSyHutdKnotGQC4Szm7+6RgyW402TRGO6pE9mDtVZaHqk0APgnsKLtXyB1gDZYF7dbbsexQpP+ozd7lzH5JQGDqwnpIkyF9UUUBZRRpQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=du98Vx8y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="du98Vx8y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C5BC19423;
	Fri, 27 Mar 2026 12:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774612930;
	bh=Ug6PXMZj5EM6WaHP8j75mffKH6tZAhlPhePI6D/ozn8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=du98Vx8yCn1S+x77RS40l3PUv9m7U54a1BwLsWUzQ5x0o5lkD9sbNwm2BqD3vBJ2g
	 4zGGHCojY9pjHPq8vsNhlThNLw74qSgYHIeQnd8TJCxibLmYCoi5bzObLOUjBAXIC0
	 6yMLnMKEqtIOmooxZK5qyFWlLWFQkTl56n+LnDBuRci7Be1pQBZ9o13MsjLYRiLcIH
	 Sbmx+to7Vw0rdUEu//tSfSYufDqE/N4VnQHoA/7wxiuz6FuWkk7ebV01GWnIx5To1z
	 xd8F06ss8tLsfEbejMlZMvaIR3MpZtme2pumQcIVVkhGZ7kl2RLVv3PGYK61pFdqZv
	 gby718h7/72gw==
Date: Fri, 27 Mar 2026 12:02:07 +0000
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
Message-ID: <8f5119a1-9aa9-4a39-ac94-ca1631db26e1@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-3-ziy@nvidia.com>
 <7fd90f5e-65b5-4734-abb2-77b22c733af5@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fd90f5e-65b5-4734-abb2-77b22c733af5@linux.alibaba.com>

On Fri, Mar 27, 2026 at 05:44:49PM +0800, Baolin Wang wrote:
>
>
> On 3/27/26 9:42 AM, Zi Yan wrote:
> > collapse_file() requires FSes supporting large folio with at least
> > PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that. shmem with
> > huge option turned on also sets large folio order on mapping, so the check
> > also applies to shmem.
> >
> > While at it, replace VM_BUG_ON with returning failure values.
> >
> > Signed-off-by: Zi Yan <ziy@nvidia.com>
> > ---
> >   mm/khugepaged.c | 7 +++++--
> >   1 file changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index d06d84219e1b..45b12ffb1550 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -1899,8 +1899,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> >   	int nr_none = 0;
> >   	bool is_shmem = shmem_file(file);
> > -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
> > -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
> > +	/* "huge" shmem sets mapping folio order and passes the check below */
> > +	if (mapping_max_folio_order(mapping) < PMD_ORDER)
> > +		return SCAN_FAIL;
>
> This is not true for anonymous shmem, since its large order allocation logic
> is similar to anonymous memory. That means it will not call
> mapping_set_large_folios() for anonymous shmem.
>
> So I think the check should be:
>
> if (!is_shmem && mapping_max_folio_order(mapping) < PMD_ORDER)
>      return SCAN_FAIL;

Hmm but in shmem_init() we have:

#ifdef CONFIG_TRANSPARENT_HUGEPAGE
	if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
	else
		shmem_huge = SHMEM_HUGE_NEVER; /* just in case it was patched */

	/*
	 * Default to setting PMD-sized THP to inherit the global setting and
	 * disable all other multi-size THPs.
	 */
	if (!shmem_orders_configured)
		huge_shmem_orders_inherit = BIT(HPAGE_PMD_ORDER);
#endif

And shm_mnt->mnt_sb is the superblock used for anon shmem. Also
shmem_enabled_store() updates that if necessary.

So we're still fine right?

__shmem_file_setup() (used for anon shmem) calls shmem_get_inode() ->
__shmem_get_inode() which has:

	if (sbinfo->huge)
		mapping_set_large_folios(inode->i_mapping);

Shared for both anon shmem and tmpfs-style shmem.

So I think it's fine as-is.

Cheers, Lorenzo
