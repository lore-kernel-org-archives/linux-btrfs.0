Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37B13E6383;
	Fri, 27 Mar 2026 13:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774616760; cv=none; b=LVMxLFJnZ1smLdL5f4luAd36eT7c+dpiMbpXgI+98HZxCD+6EXXZlMbL9vZL3UVb2uONm9A5txM8+GxETXe72cUgHO1dDMbmLOkThfEBoVv7BMW65xvQjAPjKTlWkKwubnJXxmOOyTU52Eq86QwxkN23qY6OFQWB5tT2+mlcBC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774616760; c=relaxed/simple;
	bh=d9Up/u6razcCkBI/74+4G1ND2cTaNh5pT3UQX+rht0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bM8UQThRsYIwJC1dMewSzlB1uxn5abG0nl0bq9EwAV3YLxVEVjFvH5+F5m3ZAFxiR3hgF/EjCqR8IMS3VmO4V/MVakpbXV/wsFAFv+SNRP/GIC+AKsxjMjsF4vCkFVQjGWBGCO1MSFEuGY3ShaimgD8+XioAYl6Nw8ECSqE5SYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jzLXndaw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jzLXndaw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E173AC19423;
	Fri, 27 Mar 2026 13:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774616760;
	bh=d9Up/u6razcCkBI/74+4G1ND2cTaNh5pT3UQX+rht0Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jzLXndawfLJkQValNjTETBv475Kvw4SFYaKpEkaMfFtUyVIlUSL5BSb/j9M9KpFWU
	 kjzXid+okYLCGy2z8DBdKrN5AMamZUBP50gFVKG5jQsVlqU5koXyq4I8NabJL4PLyw
	 rbdCO1qdXp8wI4u4Dh1BML9zKWaMXm3iJtEAZlGlGn6pp+8BbtIj0M4TcKI8QJVDRA
	 ZssEKV+HUeH94mXoiDdXXkyOQbiMaIlK8oEd+6VuqJ3m4sSWUV2E93R4H1GBfXdKAM
	 KhMvbaTDEVERPTAnYC0osbzS1sOTOVB4/64w2SYUhRIOC3iFGZjvQvj1tZF0i9x6q3
	 z7H3ivtU1VeVA==
Date: Fri, 27 Mar 2026 13:05:58 +0000
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
Subject: Re: [PATCH v1 09/10] selftests/mm: remove READ_ONLY_THP_FOR_FS in
 khugepaged
Message-ID: <4e00d7a8-0504-44aa-ac8a-6a2269228525@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-10-ziy@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327014255.2058916-10-ziy@nvidia.com>

On Thu, Mar 26, 2026 at 09:42:54PM -0400, Zi Yan wrote:
> Change the requirement to a file system with large folio support and the
> supported order needs to include PMD_ORDER.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  tools/testing/selftests/mm/khugepaged.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index 3fe7ef04ac62..bdcdd31beb1e 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -1086,8 +1086,8 @@ static void usage(void)
>  	fprintf(stderr, "\t<context>\t: [all|khugepaged|madvise]\n");
>  	fprintf(stderr, "\t<mem_type>\t: [all|anon|file|shmem]\n");
>  	fprintf(stderr, "\n\t\"file,all\" mem_type requires [dir] argument\n");
> -	fprintf(stderr, "\n\t\"file,all\" mem_type requires kernel built with\n");
> -	fprintf(stderr,	"\tCONFIG_READ_ONLY_THP_FOR_FS=y\n");
> +	fprintf(stderr, "\n\t\"file,all\" mem_type requires a file system\n");
> +	fprintf(stderr,	"\twith large folio support (order >= PMD order)\n");
>  	fprintf(stderr, "\n\tif [dir] is a (sub)directory of a tmpfs mount, tmpfs must be\n");
>  	fprintf(stderr,	"\tmounted with huge=advise option for khugepaged tests to work\n");
>  	fprintf(stderr,	"\n\tSupported Options:\n");
> --
> 2.43.0
>
