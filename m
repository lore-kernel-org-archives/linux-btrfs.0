Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A073115B5;
	Fri, 27 Mar 2026 15:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774625361; cv=none; b=RipPH/N79q44e/ECwKNYuABmbRF65yzXh6zsX1zOfsZB8g1dY/g49o3o43tnMWjSGRHE8g1UvbzVI+bwogzMtLkb17krk+Bs39RbHiVd5VT1Up+GilMXjYYV6QrGKl22w+ecInrOs7Hv8zsz5yzYnYBeAYWHi6LyXPd3e/Yn2NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774625361; c=relaxed/simple;
	bh=K17mO2X2gcCCie6mfJBhNmej8KECCk67Y0OzVkKTvEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bSdcnG0nUuBJjVB2fqD1mQ/pKcaQTIZN76ml0afV+YnWabdfJCvCN837M/CiODf7dMD2/SYFEPPAvaW2KBGpYKUbUV1+w5sKtYL4C4ieHPSiNIBrWTvE+DZBZT21ppsMhjvEowGKU9JXBcmqGaUl4jBPYlXiWwI4RxyinQsahNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=phmTDdlX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="phmTDdlX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645C9C19423;
	Fri, 27 Mar 2026 15:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774625361;
	bh=K17mO2X2gcCCie6mfJBhNmej8KECCk67Y0OzVkKTvEo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=phmTDdlXpdADxRipFRSQchkiH/vZUQAIB/E0MmNMCEKJWne/A1mfRLLILkxcuqbio
	 BqayNnAmTA3drvH1TWDrJWiaC1pzSWItgwlrNrULkmEX1jqgZFcJS4KhGgp3UFeilN
	 WeJjfJHMFHHRQRy2mHnFNnraa0NYP2XkOCfUCAZj5qs2akqb9oPqRG5hKR/2LYAmk+
	 MJabkvCwOgaxmzpYOdxlPxRqY3/piSgVTblTdZwn2wKwqz1kDmrrPzPpH+jnhMPY/6
	 ugpY6sBhZUjYH2ZUAlJZT6t5uL5fOA4YjesryvxV87ewLUfvCyXQW5J67qMj3jlBP4
	 wW1uc4nLlvF/A==
Date: Fri, 27 Mar 2026 15:29:13 +0000
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
Subject: Re: [PATCH v1 05/10] mm/huge_memory: remove READ_ONLY_THP_FOR_FS
 from file_thp_enabled()
Message-ID: <14af57ba-09bc-40ff-812a-b41dfb78a03c@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-6-ziy@nvidia.com>
 <5ac47338-1954-43ce-9984-56d70f7c392f@lucifer.local>
 <075A4C69-B386-4557-BDAA-4038EB36370D@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <075A4C69-B386-4557-BDAA-4038EB36370D@nvidia.com>

On Fri, Mar 27, 2026 at 11:12:46AM -0400, Zi Yan wrote:
> On 27 Mar 2026, at 8:42, Lorenzo Stoakes (Oracle) wrote:
>
> > On Thu, Mar 26, 2026 at 09:42:50PM -0400, Zi Yan wrote:
> >> Replace it with a check on the max folio order of the file's address space
> >> mapping, making sure PMD_ORDER is supported.
> >>
> >> Signed-off-by: Zi Yan <ziy@nvidia.com>
> >> ---
> >>  mm/huge_memory.c | 6 +++---
> >>  1 file changed, 3 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> >> index c7873dbdc470..1da1467328a3 100644
> >> --- a/mm/huge_memory.c
> >> +++ b/mm/huge_memory.c
> >> @@ -89,9 +89,6 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
> >>  {
> >>  	struct inode *inode;
> >>
> >> -	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
> >> -		return false;
> >> -
> >>  	if (!vma->vm_file)
> >>  		return false;
> >>
> >> @@ -100,6 +97,9 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
> >>  	if (IS_ANON_FILE(inode))
> >>  		return false;
> >>
> >> +	if (mapping_max_folio_order(inode->i_mapping) < PMD_ORDER)
> >> +		return false;
> >> +
> >
> > At this point I think this should be a separate function quite honestly and
> > share it with 2/10's use, and then you can put the comment in here re: anon
> > shmem etc.
> >
> > Though that won't apply here of course as shmem_allowable_huge_orders() would
> > have been invoked :)
> >
> > But no harm in refactoring it anyway, and the repetitive < PMD_ORDER stuff is
> > unfortunate.
> >
> > Buuut having said that is this right actually?
> >
> > Because we have:
> >
> > 		if (((in_pf || smaps)) && vma->vm_ops->huge_fault)
> > 			return orders;
> >
> > Above it, and now you're enabling huge folio file systems to do non-page fault
> > THP and that's err... isn't that quite a big change?
>
> That is what READ_ONLY_THP_FOR_FS does, creating THPs after page faults, right?
> This patchset changes the condition from all FSes to FSes with large folio
> support.

No, READ_ONLY_THP_FOR_FS operates differently.

It explicitly _only_ is allowed for MADV_COLLAPSE and only if the file is
mounted read-only.

So due to:

		if (((in_pf || smaps)) && vma->vm_ops->huge_fault)
			return orders;

		if (((!in_pf || smaps)) && file_thp_enabled(vma))
			return orders;

                      |    PF     | MADV_COLLAPSE | khugepaged |
		      |-----------|---------------|------------|
large folio fs        |     ✓     |       x       |      x     |
READ_ONLY_THP_FOR_FS  |     x     |       ✓       |      ✓     |

After this change:

                      |    PF     | MADV_COLLAPSE | khugepaged |
		      |-----------|---------------|------------|
large folio fs        |     ✓     |       ✓       |      ?     |

(I hope we're not enabling khugepaged for large folio fs - which shouldn't
be necessary anyway as we try to give them folios on page fault and they
use thp-friendly get_unused_area etc. :)

We shouldn't be doing this.

It should remain:

                      |    PF     | MADV_COLLAPSE | khugepaged |
		      |-----------|---------------|------------|
large folio fs        |     ✓     |       x       |      x     |

If we're going to remove it, we should first _just remove it_, not
simultaneously increase the scope of what all the MADV_COLLAPSE code is
doing without any confidence in any of it working properly.

And it makes the whole series misleading - you're actually _enabling_ a
feature not (only) _removing_ one.

So let's focus as David suggested on one thing at a time, incrementally.

And let's please try and sort some of this confusing mess out in the code
if at all possible...

>
> Will add a helper, mapping_support_pmd_folio(), for
> mapping_max_folio_order(inode->i_mapping) < PMD_ORDER.
>
> >
> > So yeah probably no to this patch as is :) we should just drop
> > file_thp_enabled()?
>
>
>
> >
> >>  	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
> >>  }
> >>
> >> --
> >> 2.43.0
> >>
>
>
> Best Regards,
> Yan, Zi

Cheers, Lorenzo
