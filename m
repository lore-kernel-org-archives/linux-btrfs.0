Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275AC3914EF;
	Fri, 27 Mar 2026 13:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774616739; cv=none; b=hJZhIQ76TT3mNLvitTjwk7CN6k3Eauw8WW8M2woN4xwnzKEEdq7sNb9wNajBz6aWko0w8ydMVbe1XOiAKuJ71l7TcnW0lfAnCHLjV4D/EKHQfrfREM7sQcj4sI6htXvQdrJcff9cVd3bRdJXQ9OCncnfPP9IVcxeMKgFE5FYgPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774616739; c=relaxed/simple;
	bh=ESd8XmCxuShsE/KtPdm5tiY/5sKpCpx8qvZ4REVh3I8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lYCLw3k8VcCa/p3VR82aW2qz38zYNnKu1Dy2osVrOmf5UI1/SbJiysoOb7cjb7zQrPlKn5xwl8jtoUMRBt1tsIJUw8FZwegPd9YKCZgWl/YzUuoaT3BI9kiMV2pEzbi7TzdUDo+LHfOpt/RW03gS2zHMVUlKU92hVgBQ5tnhM7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r3MyAhxJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r3MyAhxJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1F2C19423;
	Fri, 27 Mar 2026 13:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774616738;
	bh=ESd8XmCxuShsE/KtPdm5tiY/5sKpCpx8qvZ4REVh3I8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r3MyAhxJLKeSjQ+ral4sSIkopkB1pfJzJjj6TP8/N/Bv2YFjtGQR/CiMmUMEVB1MC
	 XhSN7XVUDHJfQ3tFHCL+kfGnqrpGG3a+iqixzPmFVlT7lQZ2nMJnXYeXWUp9+MDjzw
	 RQ1bU/74oszj4mKKm158d5PNzIYQ3kKiIUPxcSrLEmoXNJb0Tmr+71J38cT0W52qz8
	 cfKSnbPx5brs5xBW+gzd8tW8clkK55F0GnPWCWB0CeKS1QwMuqpbKnOkY/mQPmi3+E
	 X3Cf1PUT7d5gBY+t/dzAUGFrVySbQquU1v5s47EgDEnKKGPepTA1peQHscmN9JCDFq
	 Lf20YgBuxs+FQ==
Date: Fri, 27 Mar 2026 13:05:36 +0000
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
Subject: Re: [PATCH v1 08/10] fs/btrfs: remove a comment referring to
 READ_ONLY_THP_FOR_FS
Message-ID: <5a77eb28-cf8a-4e6d-ac5e-a059198a676f@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-9-ziy@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327014255.2058916-9-ziy@nvidia.com>

On Thu, Mar 26, 2026 at 09:42:53PM -0400, Zi Yan wrote:
> READ_ONLY_THP_FOR_FS is no longer present, remove related comment.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Sterba <dsterba@suse.com>

LGTM so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  fs/btrfs/defrag.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
> index 7e2db5d3a4d4..a8d49d9ca981 100644
> --- a/fs/btrfs/defrag.c
> +++ b/fs/btrfs/defrag.c
> @@ -860,9 +860,6 @@ static struct folio *defrag_prepare_one_folio(struct btrfs_inode *inode, pgoff_t
>  		return folio;
>
>  	/*
> -	 * Since we can defragment files opened read-only, we can encounter
> -	 * transparent huge pages here (see CONFIG_READ_ONLY_THP_FOR_FS).
> -	 *
>  	 * The IO for such large folios is not fully tested, thus return
>  	 * an error to reject such folios unless it's an experimental build.
>  	 *
> --
> 2.43.0
>
