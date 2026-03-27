Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1991FB67A;
	Fri, 27 Mar 2026 13:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774616813; cv=none; b=sSOKMXXZ06xt8THQuwAyCin0MdT6LNmG8rNQOTXsKVIlMDCXGzU8s6EAtsjbw/VOCvjCTN+G4Hz/u0aJ3UrqnMzs7KLsOHZ3OCO0NGW5yye7KAGyw/xcToGlcWou3ziWl6vlj33WP2foPs0ZmZt8nhSCiRgYKvP3UhWDimnsDb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774616813; c=relaxed/simple;
	bh=T6zhnYK1CSxgWl26f7UE87XgwORwUJZ0zoolakMA3Cc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yhr92iSXRFBAknG2dOYXBSTfgRVwwTif4YGfgAnAP45pG72egOHJwzcqqK/mmZ+zPFeguxoc2sChzBcLEwwubTlhpOumiddKUxLFDi/gCbGe3vEYAftiQlGF56EH0GY0GkKYlWAiP18ikyw5qK7LeMh9KY1oPCPdV8rnovUj9y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ESs5wAPQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ESs5wAPQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2916CC19423;
	Fri, 27 Mar 2026 13:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774616812;
	bh=T6zhnYK1CSxgWl26f7UE87XgwORwUJZ0zoolakMA3Cc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ESs5wAPQcVULuQ7S7HOjKjH8K2FBszktECzFfHQQXJ0+q/smu1H3g3rioWCecJWCC
	 fbRmqDxo8x3gNaTs7qh/dsuYs+wkC+8NzGF8a7lmkDNi8mH/GP057TD/jiDv0EwBZ6
	 gNCncafuwfUhUX6FPMSqCs9odJp+RPrVHoB4sV5hfxuqPmgW8bd5D3C0F719cuYK9G
	 cD/v5R+gEIiL97io5O8wIFlnHDiwTjDEPk3KJ4UAh+KP9G09J8oOqCilEAMDvI5hu+
	 zuWoBsxH1T58iVn4s68sOXe9gCG7612GZRvzjS4o0nmHdqMPYAx07pvA54PE1njAm0
	 A818CiAVQGBiQ==
Date: Fri, 27 Mar 2026 13:06:50 +0000
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
Subject: Re: [PATCH v1 10/10] selftests/mm: remove READ_ONLY_THP_FOR_FS from
 comments in guard-regions
Message-ID: <3f59afdd-1f55-43a7-a390-6160beac1a16@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-11-ziy@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327014255.2058916-11-ziy@nvidia.com>

On Thu, Mar 26, 2026 at 09:42:55PM -0400, Zi Yan wrote:
> Any file system with large folio support and the supported orders include
> PMD_ORDER can be used.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Thanks :) Wondered if you'd fix these up :) So:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Cheers, Lorenzo

> ---
>  tools/testing/selftests/mm/guard-regions.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
> index 48e8b1539be3..13e77e48b6ef 100644
> --- a/tools/testing/selftests/mm/guard-regions.c
> +++ b/tools/testing/selftests/mm/guard-regions.c
> @@ -2205,7 +2205,7 @@ TEST_F(guard_regions, collapse)
>
>  	/*
>  	 * We must close and re-open local-file backed as read-only for
> -	 * CONFIG_READ_ONLY_THP_FOR_FS to work.
> +	 * MADV_COLLAPSE to work.
>  	 */
>  	if (variant->backing == LOCAL_FILE_BACKED) {
>  		ASSERT_EQ(close(self->fd), 0);
> @@ -2237,9 +2237,10 @@ TEST_F(guard_regions, collapse)
>  	/*
>  	 * Now collapse the entire region. This should fail in all cases.
>  	 *
> -	 * The madvise() call will also fail if CONFIG_READ_ONLY_THP_FOR_FS is
> -	 * not set for the local file case, but we can't differentiate whether
> -	 * this occurred or if the collapse was rightly rejected.
> +	 * The madvise() call will also fail if the file system does not support
> +	 * large folio or the supported orders do not include PMD_ORDER for the
> +	 * local file case, but we can't differentiate whether this occurred or
> +	 * if the collapse was rightly rejected.
>  	 */
>  	EXPECT_NE(madvise(ptr, size, MADV_COLLAPSE), 0);
>
> --
> 2.43.0
>
