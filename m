Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A102F30AACB;
	Fri, 27 Mar 2026 16:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774627702; cv=none; b=DthZ8TX8dHWwnKyM7KIggO/Glr0H4thv5T5hi7bDeMr8sVqYD5gNIHK8t4lj2awv8wm5rIxr/JcGAJP/FfoEi70ni+Aj8nXrwtzEXu4clOwR3RN5LS50j8vz5OscpIBOIgOfIw5xpUA91HE/N1z+agRUlLdjVxfndy7SqeHjrLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774627702; c=relaxed/simple;
	bh=Y5Pd/gbqGEKvddIcFhZ5V8JfJMsZGodNYjSQLfzxngo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ci3+k5A+OZdwZM8wx5E1kWItzn6DYtgWBy9rhQfScas+NiLx2k3pqc/B13ytex9JIyJIknkYSEFkKZ9c2KN2XSRxvfRYy4RD7ZFuIz3nqHjK/rJ4456dpa3WeomXihAoqmAISla4QpESqOGZQtI2ZUTBsQeZWXh3t2WcQ2jTypU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rMAx7SyZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rMAx7SyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACEB1C19423;
	Fri, 27 Mar 2026 16:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774627702;
	bh=Y5Pd/gbqGEKvddIcFhZ5V8JfJMsZGodNYjSQLfzxngo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rMAx7SyZ59sVnwpX2nQDt9UXL44MMBRBHqTRZlQHbacBLtN/aM6d+nxwUxopCyzFY
	 404+v5iCL/0mcPGV/j6+GVooGUNTIxakPVHRrh+DLrnHKrbbBZYyjuQ1/7DRus6AmA
	 itfAQ94fgY2+OOZPz7PKtC5OAfZd6ZfWqieMqdXzcUSntzhU0bwlU+3JcI/2tlU1+t
	 et899fz5Zrxd+VBYlUQZlh6dZRyn+vSvhslG8H/eM5T5XSyGc5FdqRWympWhbuwfgP
	 3dfBDxyhIvxnDheY858lbGkW3NdQxKkMS+/kzr+HU/Z+1xPiveQoLPQds6mhzfMSim
	 rn3OME/5q3Xtg==
Date: Fri, 27 Mar 2026 16:08:14 +0000
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
Message-ID: <10b04dc8-e155-4a31-84b6-17b302e65c7c@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-6-ziy@nvidia.com>
 <5ac47338-1954-43ce-9984-56d70f7c392f@lucifer.local>
 <075A4C69-B386-4557-BDAA-4038EB36370D@nvidia.com>
 <14af57ba-09bc-40ff-812a-b41dfb78a03c@lucifer.local>
 <59A91369-9BCB-4545-AEF8-083B52998CC3@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <59A91369-9BCB-4545-AEF8-083B52998CC3@nvidia.com>

On Fri, Mar 27, 2026 at 11:43:57AM -0400, Zi Yan wrote:
> On 27 Mar 2026, at 11:29, Lorenzo Stoakes (Oracle) wrote:
>
> > On Fri, Mar 27, 2026 at 11:12:46AM -0400, Zi Yan wrote:
> >> On 27 Mar 2026, at 8:42, Lorenzo Stoakes (Oracle) wrote:
> >>
> >>> On Thu, Mar 26, 2026 at 09:42:50PM -0400, Zi Yan wrote:
> >>>> Replace it with a check on the max folio order of the file's address space
> >>>> mapping, making sure PMD_ORDER is supported.
> >>>>
> >>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
> >>>> ---
> >>>>  mm/huge_memory.c | 6 +++---
> >>>>  1 file changed, 3 insertions(+), 3 deletions(-)
> >>>>
> >>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> >>>> index c7873dbdc470..1da1467328a3 100644
> >>>> --- a/mm/huge_memory.c
> >>>> +++ b/mm/huge_memory.c
> >>>> @@ -89,9 +89,6 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
> >>>>  {
> >>>>  	struct inode *inode;
> >>>>
> >>>> -	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
> >>>> -		return false;
> >>>> -
> >>>>  	if (!vma->vm_file)
> >>>>  		return false;
> >>>>
> >>>> @@ -100,6 +97,9 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
> >>>>  	if (IS_ANON_FILE(inode))
> >>>>  		return false;
> >>>>
> >>>> +	if (mapping_max_folio_order(inode->i_mapping) < PMD_ORDER)
> >>>> +		return false;
> >>>> +
> >>>
> >>> At this point I think this should be a separate function quite honestly and
> >>> share it with 2/10's use, and then you can put the comment in here re: anon
> >>> shmem etc.
> >>>
> >>> Though that won't apply here of course as shmem_allowable_huge_orders() would
> >>> have been invoked :)
> >>>
> >>> But no harm in refactoring it anyway, and the repetitive < PMD_ORDER stuff is
> >>> unfortunate.
> >>>
> >>> Buuut having said that is this right actually?
> >>>
> >>> Because we have:
> >>>
> >>> 		if (((in_pf || smaps)) && vma->vm_ops->huge_fault)
> >>> 			return orders;
> >>>
> >>> Above it, and now you're enabling huge folio file systems to do non-page fault
> >>> THP and that's err... isn't that quite a big change?
> >>
> >> That is what READ_ONLY_THP_FOR_FS does, creating THPs after page faults, right?
> >> This patchset changes the condition from all FSes to FSes with large folio
> >> support.
> >
> > No, READ_ONLY_THP_FOR_FS operates differently.
> >
> > It explicitly _only_ is allowed for MADV_COLLAPSE and only if the file is
> > mounted read-only.
> >
> > So due to:
> >
> > 		if (((in_pf || smaps)) && vma->vm_ops->huge_fault)
> > 			return orders;
> >
> > 		if (((!in_pf || smaps)) && file_thp_enabled(vma))
> > 			return orders;
> >
> >                       |    PF     | MADV_COLLAPSE | khugepaged |
> > 		      |-----------|---------------|------------|
> > large folio fs        |     ✓     |       x       |      x     |
> > READ_ONLY_THP_FOR_FS  |     x     |       ✓       |      ✓     |
> >
> > After this change:
> >
> >                       |    PF     | MADV_COLLAPSE | khugepaged |
> > 		      |-----------|---------------|------------|
> > large folio fs        |     ✓     |       ✓       |      ?     |
> >
> > (I hope we're not enabling khugepaged for large folio fs - which shouldn't
> > be necessary anyway as we try to give them folios on page fault and they
> > use thp-friendly get_unused_area etc. :)
> >
> > We shouldn't be doing this.
> >
> > It should remain:
> >
> >                       |    PF     | MADV_COLLAPSE | khugepaged |
> > 		      |-----------|---------------|------------|
> > large folio fs        |     ✓     |       x       |      x     |
> >
> > If we're going to remove it, we should first _just remove it_, not
> > simultaneously increase the scope of what all the MADV_COLLAPSE code is
> > doing without any confidence in any of it working properly.
> >
> > And it makes the whole series misleading - you're actually _enabling_ a
> > feature not (only) _removing_ one.
>
> That is what my RFC patch does, but David and willy told me to do this. :)
> IIUC, with READ_ONLY_THP_FOR_FS, FSes with large folio support will
> get THP via MADV_COLLAPSE or khugepaged. So removing the code like I
> did in RFC would cause regressions.

OK I think we're dealing with a union of the two states here.

READ_ONLY_THP_FOR_FS is separate from large folio support, as checked by
file_thp_enabled():

static inline bool file_thp_enabled(struct vm_area_struct *vma)
{
	struct inode *inode;

	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
		return false;

	if (!vma->vm_file)
		return false;

	inode = file_inode(vma->vm_file);

	if (IS_ANON_FILE(inode))
		return false;

	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
}

So actually:

                       |    PF     | MADV_COLLAPSE | khugepaged |
		       |-----------|---------------|------------|
 large folio fs        |     ✓     |       x       |      x     |
 READ_ONLY_THP_FOR_FS  |     x     |       ✓       |      ✓     |
 both!                 |     ✓     |       ✓       |      ✓     |

(Where it's impllied it's a read-only mapping obviously for the later two
cases.)

Now without READ_ONLY_THP_FOR_FS you're going to:

                       |    PF     | MADV_COLLAPSE | khugepaged |
		       |-----------|---------------|------------|
 large folio fs        |     ✓     |       x       |      x     |
 large folio + r/o     |     ✓     |       ✓       |      ✓     |

And intentionally leaving behind the 'not large folio fs, r/o' case because
those file systems need to implement large folio support.

I guess we'll regress those users but we don't care?

I do think all this needs to be spelled out in the commit message though as it's
subtle.

Turns out this PitA config option is going to kick and scream a bit first before
it goes...

>
> I guess I need to rename the series to avoid confusion. How about?
>
> Remove read-only THP support for FSes without large folio support.

Yup that'd be better :)

Cheers, Lorenzo

>
> [1] https://lore.kernel.org/all/7382046f-7c58-4a3e-ab34-b2704355b7d5@kernel.org/
>
> >
> > So let's focus as David suggested on one thing at a time, incrementally.
> >
> > And let's please try and sort some of this confusing mess out in the code
> > if at all possible...
> >
> >>
> >> Will add a helper, mapping_support_pmd_folio(), for
> >> mapping_max_folio_order(inode->i_mapping) < PMD_ORDER.
> >>
> >>>
> >>> So yeah probably no to this patch as is :) we should just drop
> >>> file_thp_enabled()?
> >>
> >>
> >>
> >>>
> >>>>  	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
> >>>>  }
> >>>>
> >>>> --
> >>>> 2.43.0
> >>>>
> >>
> >>
> >> Best Regards,
> >> Yan, Zi
> >
> > Cheers, Lorenzo
>
>
> Best Regards,
> Yan, Zi
