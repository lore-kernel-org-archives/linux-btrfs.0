Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863CF1FB1
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Apr 2026 00:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775779434; cv=none; b=UpZtjgTv0lXMU0fjTqJab/TZAe6P6jaM5vqsF8ifVfDqW1Q94jH29+Um6+0j62dfrcGtSlv8bI2AEt4+/uiBtP1I4SoHcEX+SudZE1Y55HGT1cCmhKkp8j+KH8fCS0CCUQf6ZB14xiTG0Ol/e2TZyDOISOAtZT98YoAnD3qCHsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775779434; c=relaxed/simple;
	bh=WarLYAiPD05Wiruh3S3J9OC2s9BzoQwbi15q9+Trh94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bi0LxcwWFIEWNnSPdhW7PXUTqOylsdTIxTkkoNrpV0kCS75f/OqhFweJKcHxqUZkOt/uNP01vuYboIqVQGWfL5v9U4G0KXPAKnGiFDPD5KQCYpbJ0hhDQqIGyHNUCtHyaUoczE14mDZ2eQhjGvblg+hkoyLjG6L9YtII5AUh1rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=I+5mmMZv; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=RO41vMzl; arc=none smtp.client-ip=202.12.124.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="I+5mmMZv";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="RO41vMzl"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id B6F2A1D000CA;
	Thu,  9 Apr 2026 20:03:51 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Thu, 09 Apr 2026 20:03:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1775779431; x=1775865831; bh=+WN2BNTCxV
	WnxwUSYUcWEzgON278ZVSTdB2HtZa4fGk=; b=I+5mmMZvD0y0I3QDQWU99rntml
	DHp3T7tz1FPMTwQAHtkX9TTyUZ09Of0OVfFhb+2ZyS9dHqKi7tmiiq9prSEr3b83
	Q/H468QMvRVv4gpPYdC7kS3T2LkxIFJY0Hib7eXP6zCh+cSJ3+VOodEu0WaquzK/
	S40NiHRfMfpyEpURgDFkgj35Id6FqdRU3MnEOBC5915Z3oWI3+KE60T97xvN6hKw
	W8RdV5j+EIBO09VZKBxpjHQdVnkip7nT0SJkZA3kshmadFEF1/cD6b1JV0VX8AfF
	NqiZW2tiULle7w/i+QAuxdS+yF0ZqoXyl0xbdFYcwdR/ZtOXA1b0REMDB18g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1775779431; x=1775865831; bh=+WN2BNTCxVWnxwUSYUcWEzgON278ZVSTdB2
	HtZa4fGk=; b=RO41vMzlIzhLXOJjxSMpf2np8kjK2SV6CkC+BcAo/Ha0dhJLAkc
	MCLzUlaDWYY00WLK8ZrZWt8Sb6kE8QGQ6rctjiGvoyU68dAhD9/uZITe933ZjDVO
	TRQINj0ZIzbWTf7xqbwHouNg/xZ9VcoZ2OTlBy0Hp3P/luslXN60NRbzGP320k8E
	L+5a97adRjcC61pjb72pv56fMcN+Oqwq01Kqo6i2EGWDZK/Ti+jJmlnptWW74sn/
	xL0TY7xxskiAcWOkMa7Nt4M+qRIcy7ZCRp0g+3kPZjZ7KKpdsM00kkk1vDzG2CCP
	eDxlsqWulLSzarOBJcg/xEALQumsKuGyx0Q==
X-ME-Sender: <xms:Zz7YaZqmvNVExugt3aTUoqGjrRqfxG1aRyiSiCzjPi7oqDoAB1iHbA>
    <xme:Zz7YaRrrjHnoZ7tJYllnki9Q7o6DKkpQX_6f9qsPnaj_6cK4tXldxzzE9wcR8SBUD
    2QF8qhNDZJJnKJ-uoR2fbWD3F0B4GiRSppQWgEc5PaPbs27bOyVd2k>
X-ME-Received: <xmr:Zz7YaT1seth6K2ZZpMEBiBJQQdG8X_efj3_GDjroJ3kr72PjcpPf1gDGItcWh5-z2aayfA2Wbv5JNLfDNYBht-1tie4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddvjeeklecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhrihhsuceu
    uhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhepkedvke
    ffjeellefhveehvdejudfhjedthfdvveeiieeiudfguefgtdejgfefleejnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhishessghurh
    drihhopdhnsggprhgtphhtthhopedvpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    peifqhhusehsuhhsvgdrtghomhdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvgh
    gvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:Zz7YaQAtdf8H7oVHp9wEJEaKnRhTofbgfke4IRHQEoxBOYqFEs3nog>
    <xmx:Zz7YabemGHF5Q5U7vVf2iVgtIbP7FF7kmgxpzQs8TLunnjhzi-imRA>
    <xmx:Zz7YaVhRk02qFZ5QwuqeSaHFd6v2El-Y6gopR0-xZXfYH7OvpVm8HA>
    <xmx:Zz7YaTplg4tHJYMwG76mTaxKiUBgPhHEig-aQ6-3F9lEZdDs9R8z8w>
    <xmx:Zz7YaY1yFLfjbhOZ3jc__MYsFgB19y7y3hZSS7me9Zccsj9xufY9AjFG>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 9 Apr 2026 20:03:50 -0400 (EDT)
Date: Thu, 9 Apr 2026 17:03:37 -0700
From: Boris Burkov <boris@bur.io>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: pass a valid btrfs_tree_parent_check when possible
Message-ID: <20260410000337.GA1018385@zen.localdomain>
References: <64f82fae3b8c690a3ad27d21fa80401f62b9e0ac.1775776582.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64f82fae3b8c690a3ad27d21fa80401f62b9e0ac.1775776582.git.wqu@suse.com>

On Fri, Apr 10, 2026 at 08:46:40AM +0930, Qu Wenruo wrote:
> Commit 6e181cfe2409 ("btrfs: revalidate cached tree blocks on the
> uptodate path") introduced the @check parameter for
> btrfs_buffer_uptodate() to allow re-validation of a cached extent
> buffer.
> 
> But there are still call sites that doesn't utilize this parameter,
> which exposes them to possible corrupted tree blocks, e.g. an empty
> child leaf of a parent node, which should be rejected by
> btrfs_verify_level_key() but if @check is NULL such check will be
> skipped and cause problems.
> 
> Thankfully for a lot of cases there is already an existing @check
> structure around and we can pass it directly to btrfs_buffer_uptodate().
> 
Reviewed-by: Boris Burkov <boris@bur.io>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/ctree.c       | 16 +++++-----------
>  fs/btrfs/extent-tree.c | 11 ++++++++---
>  fs/btrfs/extent_io.c   |  2 +-
>  3 files changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index d70da290bedf..829d8be7f423 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -1497,17 +1497,11 @@ read_block_for_search(struct btrfs_root *root, struct btrfs_path *p,
>  		if (p->reada == READA_FORWARD_ALWAYS)
>  			reada_for_search(fs_info, p, parent_level, slot, key->objectid);
>  
> -		/* first we do an atomic uptodate check */
> -		if (btrfs_buffer_uptodate(tmp, check.transid, NULL) > 0) {
> -			/*
> -			 * Do extra check for first_key, eb can be stale due to
> -			 * being cached, read from scrub, or have multiple
> -			 * parents (shared tree blocks).
> -			 */
> -			if (unlikely(btrfs_verify_level_key(tmp, &check))) {
> -				ret = -EUCLEAN;
> -				goto out;
> -			}
> +		/* Check if the cached eb is uptodate. */
> +		ret = btrfs_buffer_uptodate(tmp, check.transid, &check);
> +		if (unlikely(ret < 0))
> +			goto out;
> +		if (ret > 0) {
>  			*eb_ret = tmp;
>  			tmp = NULL;
>  			ret = 0;
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 391fad41c3b6..5d5b42ea4ade 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -5781,16 +5781,21 @@ static int check_next_block_uptodate(struct btrfs_trans_handle *trans,
>  
>  	generation = btrfs_node_ptr_generation(path->nodes[level], path->slots[level]);
>  
> -	if (btrfs_buffer_uptodate(next, generation, NULL))
> -		return 0;
> -
>  	check.level = level - 1;
>  	check.transid = generation;
>  	check.owner_root = btrfs_root_id(root);
>  	check.has_first_key = true;
>  	btrfs_node_key_to_cpu(path->nodes[level], &check.first_key, path->slots[level]);
>  
> +	ret = btrfs_buffer_uptodate(next, generation, &check);
> +	if (ret > 0)
> +		return 0;
>  	btrfs_tree_unlock(next);
> +	if (ret < 0) {
> +		free_extent_buffer(next);
> +		return ret;
> +	}
> +
>  	if (level == 1)
>  		reada_walk_down(trans, root, wc, path);
>  	ret = btrfs_read_extent_buffer(next, &check);
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index a8887285deda..3f59fb0a9ee5 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -4648,7 +4648,7 @@ void btrfs_readahead_tree_block(struct btrfs_fs_info *fs_info,
>  	if (IS_ERR(eb))
>  		return;
>  
> -	if (btrfs_buffer_uptodate(eb, gen, NULL)) {
> +	if (btrfs_buffer_uptodate(eb, gen, &check)) {
>  		free_extent_buffer(eb);
>  		return;
>  	}
> -- 
> 2.53.0
> 
