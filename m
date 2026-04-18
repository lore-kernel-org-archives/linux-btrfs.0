Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346D727FD49;
	Sat, 18 Apr 2026 09:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776504433; cv=none; b=DTSi9Rx8bsKTkmhYpU1C+4q0ZUz7YJ0Rj1c3buHaPOpKriBNyGz8X4q57rCt0u73JQsRgxZvbGh5mVROHhWx5545O1ps7ZamBPnn794gFICQjk0ulsqKskWHAJ7X4u7Y9ganAZbBGDBDsnTsDEb/nmFL15CssLLpZRT+tcs+mkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776504433; c=relaxed/simple;
	bh=qQK1tXEC3bQP9DZ7GFPDMCN0K1t29slMgrLD0yyfeZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RxGcu/qLdDmHJWsbjYg6waZ/PjqHBskssVR1IJmZgaho/v2RXRBJVHC3Ivvis6leSSF36GyvJLEMASD/EUfvcvTzQdhE8lpVbNPu5B0ksWXM6tjyZRUhpelHxBwQ62pzYqbarsJBVOVlGbQZbV2xbNRKipf2GimrCqqlxd8OSag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ikWmHtfu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ikWmHtfu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC7BC19424;
	Sat, 18 Apr 2026 09:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776504432;
	bh=qQK1tXEC3bQP9DZ7GFPDMCN0K1t29slMgrLD0yyfeZ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ikWmHtfu7pVAnscldTDWmT2dkebMotrLIBQE8B3cj/NJm+LMOdJQ1+SicHCaJzh2j
	 hvQDrQkhkcCi9Gs9VMZ+zu/zKq2plSfI+RnUQ2AKfDN0ePzK/cddQUoOimK4WLSszf
	 73s7zVs5pDX8IJ1ORCYFd+4yIo+u+omrpvxuhh0vbNwiJSdalDH28uKWpTGEVH3tOm
	 jyy0UKIxK3Db8Tw+PQ4t/LhdfbHTtt1XgMdnZxUteaIAUPqDeMUzwIoq2wRqAysxrN
	 /iuPRwQi1pEE1O52z35J4YmZ5J/y1R47cZAbeZXVPqXz4SmGwgdUhgQxYkzqAzQNjx
	 3cpLn0aRJZ1mQ==
Date: Sat, 18 Apr 2026 10:27:04 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
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
Subject: Re: [PATCH 7.2 v3 00/12] Remove read-only THP support for FSes
 without large folio support
Message-ID: <aeNNjgD09VqwI0jo@lucifer>
References: <20260418024429.4055056-1-ziy@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260418024429.4055056-1-ziy@nvidia.com>

On Fri, Apr 17, 2026 at 10:44:17PM -0400, Zi Yan wrote:
> Hi all,
>
> This patchset removes READ_ONLY_THP_FOR_FS Kconfig and enables creating
> read-only THPs for FSes with large folio support (the supported orders
> need to include PMD_ORDER) by default.
>
> Before the patchset, the status of creating read-only THPs is below:

Good to specify the read-only bit up front!

>
>                             |    PF     | MADV_COLLAPSE | khugepaged |
>                             |-----------|---------------|------------|
>  large folio FSes only      |     ✓     |       x       |      x     |
>  READ_ONLY_THP_FOR_FS only  |     x     |       ✓       |      ✓     |
>  both                       |     ✓     |       ✓       |      ✓     |

This diagrams seem familiar :P but very nice, thanks!

And since we include cover letter in series in mm this should be some nice
documentation in the commit msg also.

>
> where READ_ONLY_THP_FOR_FS implies no large folio FSes.
>
>
> Now without READ_ONLY_THP_FOR_FS:
>
>                            |    PF     | MADV_COLLAPSE | khugepaged |
>                            |-----------|---------------|------------|
>  large folio FSes          |     ✓     |       ✓       |      ✓     |
>  no large folio FSes       |     x     |       x       |      x     |

This is really nice and clear thanks!

>
> This means no large folio FSes need to add large folio support (the
> supported orders need to include PMD_ORDER), so that they can leverage
> read-only THP creation function.
>
> To prevent breaking read-only THP support for large folio FSes,
> 1. first 4 patches enables the support, so that without READ_ONLY_THP_FOR_FS,
>    read-only THP still works for large folio FSes,

I guess this introduces what was previously supported by
CONFIG_READ_ONLY_THP_FOR_FS to large folios as part of that before removal of
the config option?

> 2. Patch 5 removes READ_ONLY_THP_FOR_FS Kconfig,
> 3. the rest of patches remove code related to READ_ONLY_THP_FOR_FS.

Makes sense thanks!

>
>
> The overview of the changes is:
>
> 1. collapse_file() checks for to-be-collapsed folio dirtiness after they
>    are locked, unmapped to make sure no new write happens. Before,
>    mapping->nr_thps and inode->i_writecount are used to cause read-only
>    THP truncation before a fd becomes writable.
>
> 2. hugepage_pmd_enabled() is true for anon, shmem, and file-backed cases
>    if the global khugepaged control is on, otherwise, khugepaged for
>    file-backed case is turned off and anon and shmem depend on per-size
>    control knobs.
>
> 3. collapse_file() from mm/khugepaged.c, instead of checking
>    CONFIG_READ_ONLY_THP_FOR_FS, makes sure the mapping_max_folio_order()
>    of struct address_space of the file is at least PMD_ORDER.
>
> 4. file_thp_enabled() also checks mapping_max_folio_order() instead and
>    no longer checks if the input file is opened as read-only (Change 1
>    handles read-write files).
>
> 5. truncate_inode_partial_folio() calls folio_split() directly instead
>    of the removed try_folio_split_to_order(), since large folios can
>    only show up on a FS with large folio support.
>
> 6. nr_thps is removed from struct address_space, since it is no longer
>    needed to drop all read-only THPs from a FS without large folio
>    support when the fd becomes writable. Its related filemap_nr_thps*()
>    are removed too.
>
> 7. folio_check_splittable() no longer checks READ_ONLY_THP_FOR_FS.
>
> 8. Updated comments in various places.
>
>
> Changelog
> ===
> From V2[3]:
> 1. removed unnecessary check in collapse_scan_file().
>
> 2. removed inode_is_open_for_write() check in file_thp_enabled().
>
> 3. changed hugepage_pmd_enabled() to return true if khugepaged global
>    control is on instead of false. cleaned up anon and shmem code in the
>    function.
>
> 4. moved folio dirtiness check after try_to_unmap() but before
>    try_to_unmap_flush(), since that is sufficient to prevent new writes.
>
> 5. reordered patch 4 and 5, so that khugepaged behavior does not change
>    after READ_ONLY_THP_FOR_FS is removed.
>
> 6. added read-write file test in khugepaged selftest.
>
> 7. removed the read-only file restriction from guard-region selftest.
>
> From V1[2]:
> 1. removed inode_is_open_for_write() check in collapse_file(), since the
>    added folio dirtiness check after try_to_unmap_flush() should be
>    sufficient to prevent writes to candidate folios.
>
> 2. removed READ_ONLY_THP_FOR_FS check in hugepage_pmd_enabled(), please
>    see Patch 5 and item 2 in the overview for more details.
>
> 3. moved the patch removing READ_ONLY_THP_FOR_FS Kconfig after enabling
>    khugepaged and MADV_COLLAPSE to create read-only THPs.
>
> 4. added mapping_pmd_thp_support() helper function.
>
> 5. used VM_WARN_ON_ONCE() in collapse_file() for mapping eligibility check
>    and address alignment check instead of if + return error code. Always
>    allow shmem, since MADV_COLLAPSE ignore shmem huge config.
>
> 6. added mapping eligibility check in collapse_scan_file().
>
> 7. removed trailing ; for folio_split() in the !CONFIG_TRANSPARENT_HUGEPAGE.
>
> 8. simplified code in folio_check_splittable() after removing
>    READ_ONLY_THP_FOR_FS code.
>
> 9. clarified that read-only THP works for FSes with PMD THP support by
>    default.
>
> From RFC[1]:
> 1. instead of removing READ_ONLY_THP_FOR_FS function entirely, turn it
>    on by default for all FSes with large folio support and the supported
>    orders includes PMD_ORDER.
>
> Suggestions and comments are welcome.
>
> Link: https://lore.kernel.org/all/20260323190644.1714379-1-ziy@nvidia.com/ [1]
> Link: https://lore.kernel.org/all/20260327014255.2058916-1-ziy@nvidia.com/ [2]
> Link: https://lore.kernel.org/all/20260413192030.3275825-1-ziy@nvidia.com/ [3]
>
> Zi Yan (12):
>   mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
>   mm/khugepaged: add folio dirty check after try_to_unmap()
>   mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
>   mm/khugepaged: remove READ_ONLY_THP_FOR_FS check in
>     hugepage_pmd_enabled()
>   mm: remove READ_ONLY_THP_FOR_FS Kconfig option
>   mm: fs: remove filemap_nr_thps*() functions and their users
>   fs: remove nr_thps from struct address_space
>   mm/huge_memory: remove folio split check for READ_ONLY_THP_FOR_FS
>   mm/truncate: use folio_split() in truncate_inode_partial_folio()
>   fs/btrfs: remove a comment referring to READ_ONLY_THP_FOR_FS
>   selftests/mm: remove READ_ONLY_THP_FOR_FS in khugepaged
>   selftests/mm: remove READ_ONLY_THP_FOR_FS code from guard-regions
>
>  fs/btrfs/defrag.c                          |   3 -
>  fs/inode.c                                 |   3 -
>  fs/open.c                                  |  27 -----
>  include/linux/fs.h                         |   5 -
>  include/linux/huge_mm.h                    |  25 +----
>  include/linux/pagemap.h                    |  35 ++-----
>  include/linux/shmem_fs.h                   |   2 +-
>  mm/Kconfig                                 |  11 ---
>  mm/filemap.c                               |   1 -
>  mm/huge_memory.c                           |  39 ++------
>  mm/khugepaged.c                            |  86 ++++++++--------
>  mm/truncate.c                              |   8 +-
>  tools/testing/selftests/mm/guard-regions.c |  18 +---
>  tools/testing/selftests/mm/khugepaged.c    | 110 +++++++++++++++------
>  tools/testing/selftests/mm/run_vmtests.sh  |  12 ++-
>  15 files changed, 156 insertions(+), 229 deletions(-)
>
> --
> 2.43.0
>
