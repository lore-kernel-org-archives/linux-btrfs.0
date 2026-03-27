Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50803537E7;
	Fri, 27 Mar 2026 11:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774611924; cv=none; b=iz6it7+aKM2iTwKmoKCuOWjvvCKYMapdPTJso7FLLqIXxjUaxuOjTlk/eHT+iZBErER1m54ZH0Bfsrq3w7VcRjLeV/2es6z8vHGHmPc4aMow7ufJzXlxbIKEjzqMd2k8nZSDkl6bFf4oyZRy9YT9zf2RqtHKQRU+Wnyq1oDGbzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774611924; c=relaxed/simple;
	bh=CMDDACTrdygYzTYvrKSSaSH6FKG2wjukDIQD9gkXUzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IpYdNKc7EcWx4W3eegqJ1qA6BLGI01n1GNATMQYnHbQrRDtA4EkYzx/tLgQG9+oNBnQlmWZNowBy3/vH12Mak5/AFmbjoKRq77cLAcBS31GHUC3yJAaR+wNSRFy71EsjCibkkREGuL1/e+QEEOZUX6q7jdT6/kgfhsoU5C06Ka8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gEcinbef; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gEcinbef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E39C19423;
	Fri, 27 Mar 2026 11:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774611924;
	bh=CMDDACTrdygYzTYvrKSSaSH6FKG2wjukDIQD9gkXUzE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gEcinbefxRX5JaurQEZogXVJ8MYHd9x9g2Qve1IojhXhrFbxIJe1GNNSRQGRLrDyQ
	 HEAAWE4DjW5jAKM0ZkuWMnfyKZ4tcjUt1AOOCFPW7uv3rY4NFXkOg7Y/ZZAt9VzQV4
	 Hsv3t4eWLjOxEf9Vziukg+r1vvXfrvtAHeQGC8tQ1q6+KBgbyGwO5FoT5NiVLypqbB
	 zJLXflzrd5LqHvrrGoNfpmOeTB9ovOJh5U65lKVjVcq6zYhzZAvF0gjudpCPfgSAW+
	 dTk3/4HUrSzPU/viVOP7DgR5VgFU0+jIa1UBTZDum22TxChy831iPE3403iyeduQuh
	 zTb9UP3l2jFcA==
Date: Fri, 27 Mar 2026 11:45:22 +0000
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
Subject: Re: [PATCH v1 01/10] mm: remove READ_ONLY_THP_FOR_FS Kconfig option
Message-ID: <21b4c6cb-567c-4a70-b311-fbe782ad18c1@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-2-ziy@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327014255.2058916-2-ziy@nvidia.com>

On Thu, Mar 26, 2026 at 09:42:46PM -0400, Zi Yan wrote:
> No one will be able to use it, so the related code can be removed in the
> coming commits.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Seems a reasonable ordering, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/Kconfig | 11 -----------
>  1 file changed, 11 deletions(-)
>
> diff --git a/mm/Kconfig b/mm/Kconfig
> index bd283958d675..408fc7b82233 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -937,17 +937,6 @@ config THP_SWAP
>
>  	  For selection by architectures with reasonable THP sizes.
>
> -config READ_ONLY_THP_FOR_FS
> -	bool "Read-only THP for filesystems (EXPERIMENTAL)"
> -	depends on TRANSPARENT_HUGEPAGE
> -
> -	help
> -	  Allow khugepaged to put read-only file-backed pages in THP.
> -
> -	  This is marked experimental because it is a new feature. Write
> -	  support of file THPs will be developed in the next few release
> -	  cycles.
> -
>  config NO_PAGE_MAPCOUNT
>  	bool "No per-page mapcount (EXPERIMENTAL)"
>  	help
> --
> 2.43.0
>
