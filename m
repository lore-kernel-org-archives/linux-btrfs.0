Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E2838910D;
	Fri, 27 Mar 2026 12:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774614553; cv=none; b=FlTzY2rfSuySEWygtJZMSSpSnDSjrpkV0WpjRlEtpK/YCOLo2LAMBDTf7ijvgZ+M5pYnbZDxvu4ubWgDG2qfnhZM0HMcFolLrOdk/uUD/IQ6GMlPDQg7+SS6+wJ0qvwWfxELeR9/xH8Dm4A+xQp/5y1Pa3dtQLw2vACmqkq1cDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774614553; c=relaxed/simple;
	bh=YgZDlPiJvemYo/gf8s9JAb+1AiSwXPvayCb368ynG4I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V6l+Jh/IhL82MJYG9aEuHAMHJW3uB3FT94CPfDmjNfWeyLw3Qm2MboUTd7OC0HxqfSpMiGqVbo/SCSyiT4MoRvKbSnAC9guAih3mb8hgYz9nZjAQxPG5yPhjrrJUXG6eRYmev6vG9bjWiUTPZD3gazYU9Jn+RQ1NRWZmJ0npdTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P8nvaAV2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P8nvaAV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12598C19423;
	Fri, 27 Mar 2026 12:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774614552;
	bh=YgZDlPiJvemYo/gf8s9JAb+1AiSwXPvayCb368ynG4I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P8nvaAV26WoxCEiijKXxPz27X5f5WPVVmW50/Em6IcSbxbtwykC7Fq6FoJfjrvGnI
	 mdZ/cUzccp77GfiTBOa3d3PVBkLRkZg5AKjVFZqeDnL/O8QAen1YstfoUyKmYl7J7Q
	 KY82Qxxyf4i6TaQfHjikvgEUodvnNiCpAKHmWq5VjRJhchC5tLHP6gBukW6PTzKS8E
	 y5e6gNLo8ZoGnjGJjOEa12iHG9PVrzf84AKevXj5aoTqRMFRriJGQKol8WvKP4HXT6
	 7U2dnzTkl9gSGl59FU2c/W3e1eAbLDQAhnmfbFgYZFG1xAZuRR2z9ssCbwwbYQ9r0v
	 Yg9yUPFoVsrqw==
Date: Fri, 27 Mar 2026 12:29:10 +0000
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
Subject: Re: [PATCH v1 04/10] fs: remove nr_thps from struct address_space
Message-ID: <f98087e1-311b-4b8c-bfff-230cfbdbace5@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-5-ziy@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327014255.2058916-5-ziy@nvidia.com>

On Thu, Mar 26, 2026 at 09:42:49PM -0400, Zi Yan wrote:
> filemap_nr_thps*() are removed, the related field, address_space->nr_thps,
> is no longer needed. Remove it.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>

I wonder if we shouldn't squash this into previous actually, but it's fine
either way, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  fs/inode.c         | 3 ---
>  include/linux/fs.h | 5 -----
>  2 files changed, 8 deletions(-)
>
> diff --git a/fs/inode.c b/fs/inode.c
> index cc12b68e021b..16ab0a345419 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -280,9 +280,6 @@ int inode_init_always_gfp(struct super_block *sb, struct inode *inode, gfp_t gfp
>  	mapping->flags = 0;
>  	mapping->wb_err = 0;
>  	atomic_set(&mapping->i_mmap_writable, 0);
> -#ifdef CONFIG_READ_ONLY_THP_FOR_FS
> -	atomic_set(&mapping->nr_thps, 0);
> -#endif
>  	mapping_set_gfp_mask(mapping, GFP_HIGHUSER_MOVABLE);
>  	mapping->i_private_data = NULL;
>  	mapping->writeback_index = 0;
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 0bdccfa70b44..35875696fb4c 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -455,7 +455,6 @@ extern const struct address_space_operations empty_aops;
>   *   memory mappings.
>   * @gfp_mask: Memory allocation flags to use for allocating pages.
>   * @i_mmap_writable: Number of VM_SHARED, VM_MAYWRITE mappings.
> - * @nr_thps: Number of THPs in the pagecache (non-shmem only).
>   * @i_mmap: Tree of private and shared mappings.
>   * @i_mmap_rwsem: Protects @i_mmap and @i_mmap_writable.
>   * @nrpages: Number of page entries, protected by the i_pages lock.
> @@ -473,10 +472,6 @@ struct address_space {
>  	struct rw_semaphore	invalidate_lock;
>  	gfp_t			gfp_mask;
>  	atomic_t		i_mmap_writable;
> -#ifdef CONFIG_READ_ONLY_THP_FOR_FS
> -	/* number of thp, only for non-shmem files */
> -	atomic_t		nr_thps;
> -#endif
>  	struct rb_root_cached	i_mmap;
>  	unsigned long		nrpages;
>  	pgoff_t			writeback_index;
> --
> 2.43.0
>
