Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5783E377EB0;
	Fri, 27 Mar 2026 12:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774615351; cv=none; b=AcVRN2neVo/03Ursi660AcBvag/hRnK3nPDA8quAlsSH9GX+1ZK3bV+wSpEu3CCa5dGX9HGQCMxWQ/0YxW5aoASdx2Ry7F6Trp9Ns301txVvO4GCoslbGHFdRMGi9m4HpQZSbB5N7fPSsd7xmKzRXHdgci5NcJP5390Q7wuxiOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774615351; c=relaxed/simple;
	bh=ScnDchtxz3nbi7fNStj38W0DlgF4uUAXNKsNM9UtlG0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OJKcryTXcM8BJssBh4pnt+rOSAKxoSRJWCj39da3f+olNM+fT7h9WcpWTFCeq9znenZGnhVYvQA5R1PgVpOmg84OdXmfCzf8ZOe4fKZU71hrpj5NU6/QtVEcU74mClUSAvkdks1y5u582O45Uy+5y76s2ZkUTlYRJHwRw14SgDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NgS84UX4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NgS84UX4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580B1C19423;
	Fri, 27 Mar 2026 12:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774615351;
	bh=ScnDchtxz3nbi7fNStj38W0DlgF4uUAXNKsNM9UtlG0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NgS84UX4fepMHIzVRMxlxt8c4PNx4Lya0rELlZuOIREISup3fXx7EAl/yssL53GMb
	 yJpn8LwbkGfuY9kIrhEJ5WFKEah4afqMIhdg/2OA9WdokrehMn2KzghmJQfTKF3dUc
	 2V6+fVywGgUmW2nFrij7A/0/JeHrqFABHPQLWZU6y98OppmfAKkmGajb6/zgIkc1PY
	 MroVcDBhYiaIMJDq1rOBLAZWfmTKkVg/mpiLKcri/Ob8guDAdcLLeOs0WBCARqqTup
	 cQJNiAtzEDQoz9oqFkIhcXz07ceXau3Qh6h4xDc8KUC7T4oVZAegzO1fltxzZnDIKA
	 EEoIHwWVH8GLg==
Date: Fri, 27 Mar 2026 12:42:28 +0000
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
Message-ID: <5ac47338-1954-43ce-9984-56d70f7c392f@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-6-ziy@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327014255.2058916-6-ziy@nvidia.com>

On Thu, Mar 26, 2026 at 09:42:50PM -0400, Zi Yan wrote:
> Replace it with a check on the max folio order of the file's address space
> mapping, making sure PMD_ORDER is supported.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  mm/huge_memory.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index c7873dbdc470..1da1467328a3 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -89,9 +89,6 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>  {
>  	struct inode *inode;
>
> -	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
> -		return false;
> -
>  	if (!vma->vm_file)
>  		return false;
>
> @@ -100,6 +97,9 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>  	if (IS_ANON_FILE(inode))
>  		return false;
>
> +	if (mapping_max_folio_order(inode->i_mapping) < PMD_ORDER)
> +		return false;
> +

At this point I think this should be a separate function quite honestly and
share it with 2/10's use, and then you can put the comment in here re: anon
shmem etc.

Though that won't apply here of course as shmem_allowable_huge_orders() would
have been invoked :)

But no harm in refactoring it anyway, and the repetitive < PMD_ORDER stuff is
unfortunate.

Buuut having said that is this right actually?

Because we have:

		if (((in_pf || smaps)) && vma->vm_ops->huge_fault)
			return orders;

Above it, and now you're enabling huge folio file systems to do non-page fault
THP and that's err... isn't that quite a big change?

So yeah probably no to this patch as is :) we should just drop
file_thp_enabled()?

>  	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
>  }
>
> --
> 2.43.0
>
