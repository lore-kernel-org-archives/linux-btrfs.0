Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C331511E7C
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 17:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789751077; cv=none; b=Em3ZxX5xBaef6AGjHBy5UlNPUooLd2PGFGt1ZjIBLLAl/m4HOhC0efx38wvWVCtIJVQXVi4VbqTK7Gu8awkvMXXX1+E5kmTeLqsYBwjC/+aBh29w/TkDIqBJ5UWAd8Ut1G88Ekl1SKTkiaiZ1yKQeB8x+9i2KQ9v+VtJUQwA38M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789751077; c=relaxed/simple;
	bh=Rx3+uHgrImNMP9Coyp/835+HkwHSw16l5J4G0XYmfoc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=biyyx4R/CxY0EqrgNBSmUEMkVLOM19AM97ELmw5hzXbl1NaNzGsu5XfQhKKOhs0FU6Xn/kyCl9te0KMlLt6eMXtAW2xVzqb0XCQHvteKzxCsM6MR7IcNwgbKG2/3dIanJA+WlcVLgcRvSoaxYOt/AxpU0qn3pM5pXoBpwfz9A7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=caBbMrLa; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=otdkiZBo; arc=none smtp.client-ip=202.12.124.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="caBbMrLa";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="otdkiZBo"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 295311D00074;
	Fri, 18 Sep 2026 13:04:34 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 18 Sep 2026 13:04:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1789751074; x=1789837474; bh=Jw9JOB6F6H
	RB9r9G8eRQq6pV517O6fL+E8Qlolc0itw=; b=caBbMrLaYH0WQoGuElzaUvvJy3
	RZjxtdB/ozbxdZoiyhalvubkFwOYOFJvebVkgbZerBbwwKBz4PiXmY1qgSRC29x4
	y9GViMaUZ6A/6CrzN6FrhPov+jFdQfoNippQ6sPNnMrt+VrWvcp0vaZEfTwSl6/o
	FuinWoBQ7Xida70uf7tDUDZppu3hTJ3GExO5gP1Ytk16cO+dnyw+86D0lzzhjfag
	NWHk2TdLA6Lu5EM5FPHN2dmxTpYgHol7CPp77POmiU+sHfGbUm43eP6vTlpTJ7Yi
	46dvnWLRIPRKtK4m2v8k+xi6wVyAoX7QnDQ/Q3WOKfb/QRWkVWXa9KJE4RyA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789751074; x=1789837474; bh=Jw9JOB6F6HRB9r9G8eRQq6pV517O6fL+E8Q
	lolc0itw=; b=otdkiZBoHnVkSqB10y0YGvGZJK4YOR9gSK0suLxLscjMdff/dwD
	QvjpzoIY/iGYxvi42Oqo9yeuVQorBCW+llAf8mu00vDUPKxeZAI1sTOU7O0YHYEZ
	6fPl4aHdblfNhcJdw+ZjwUT8M+ZwsodEHBrIzQY7EMAzZ/Fn8D9lgGa03JXPq/z+
	yJtfymdXjkZCBkvZJXGqjKTPpji71KA1WEEn2i+3V6dx+mB4wkuDhW7AZ7DGq7en
	bU3ovZudjRlxbQhkqWmrlyUviek/CTHxN+zE5rLiFlf+SLR7vvbD4cl7gWATQykH
	jIRu8dC3CvuFrNyIQnBZDq3bwIaqwjD7ErQ==
X-ME-Sender: <xms:IW-tao82ut_6_hGEH_VUY7yUky3xVz_6qiegFZYVZumRvdMKOfVa4Q>
    <xme:IW-tamtUtbUWO0lDRR_UWk_lbgO6YvxslH58y3nt8XClZFUGzn0H6nHq9k0ti-uwq
    baBbNy8pZ98TQCwc1lGt1dYchdr0_SVswUwsNI2wAs4xUZrz3mIVPkx>
X-ME-Received: <xmr:IW-taroJ-hgLjpzIxg3_2e9jRBlM0vHDfitpplZyBKTvlQeAkUTHszY>
X-ME-Proxy-Cause: dmFkZTGjd0mnVEVH6UkFmJkJcwQc+BZkou28c/gJ+v21vIIIzRY19NWvrFsjFuAdbLz6co
    ehBxyDGlmzUfglW8x8safk6VxU7q0SvuIg/cxFCLGCgjnwlvPJ9HT8yPB/TAaDrOQVFt7L
    JwutXfCkWkQIAvmEGwUNutz7Q9wJ7tOZ70t5mVt4U20tBmfhTmyGmVmg34fpQBL0IbMrvc
    mI+LVJrIwilZzYh6atRI7xS2ttfhlPoTJ0lWmDUoEfaK2VZ2uIwoS3pkfCDoFN6mMmJ/H9
    xEX5kcd7P/6W22ARQ8UXSz5qHVeNlLeh9y5Wndars7H6jbqSKbKgR5SYJdI7Yk+lJ3ZRpb
    oSRNmiZgYQmQQXtTnFsv/2tOXdnvmSU3Y5+li3luK6srCUZL9S+cN5Hyq3glKhAKUfO+7c
    ExuFCungzJskbYjzS/emPteWPC4ARC/KoSPoraQkWkImYEOvywH/89A++vReUofruzUibK
    cXeca4CVluiYavNf/ZHuzdzG2KCjFRMK38bVusu5YIDARH6B0vKW8Wjhge2KWsi+hwRyDR
    QLaSK23Ju3gkV5XfVeE9c9TXoZIqvQlVfQkpT7bmaQIpa84EWLKN1L89eA/DaeWMG3GxxA
    54j0n7xlw3M1gfucn7hQUpH4Ob1dksDS+ICLvyUuek3yAiRw8YpLc3zE9nXQ
X-ME-Proxy: <xmx:IW-tajmJhbLmWj_yP_F85cysjUfI1F_OegVbBfF3FnMbt-HcHokc5g>
    <xmx:IW-tavwgd9TDxHXT7ro2fR7zgE1wrV9tVUMzwqs3KOuhpjJ-jeoK0A>
    <xmx:IW-tarleQwzPIJKTRsjDu8OVFVeHCu1snW1Uxkyt8hyO6xOVHP54zQ>
    <xmx:IW-taoc96lslhMUfpvhL3isr-ioS6KtnZ-TGws55jCKDaivl8k9sUA>
    <xmx:Im-taiT6zzvVGFmakTR06xu4cwuGSDHjREe3KFQybodFnSiveyu64koi>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Sep 2026 13:04:33 -0400 (EDT)
Date: Fri, 18 Sep 2026 10:04:45 -0700
From: Boris Burkov <boris@bur.io>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix dangling nodes in tree-mod-log after error in
 btrfs_tree_mod_log_insert_root()
Message-ID: <20260918170445.GA2900089@zen.localdomain>
References: <d2bc9a10e82d87166dbd60797a93a69560f02411.1789750133.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2bc9a10e82d87166dbd60797a93a69560f02411.1789750133.git.fdmanana@suse.com>

On Fri, Sep 18, 2026 at 05:49:14PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If in btrfs_tree_mod_log_insert_root() there is an error in the call to
> tree_mod_log_insert() (the only possible error is -EEXIST, which means we
> have a bug or some memory corruption maybe) we free all the nodes in the
> 'tm_list' array but we don't remove them from the tree-mod-log rbtree,
> which can result in use-after-free bugs later.
> 
> So make sure we remove the nodes from the rbtree before freeing them after
> an error.
> 
> Fixes: 5de865eebb83 ("Btrfs: fix tree mod logging")
> Assisted-by: LLM (found the bug)
Reviewed-by: Boris Burkov <boris@bur.io>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/tree-mod-log.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/tree-mod-log.c b/fs/btrfs/tree-mod-log.c
> index a8094928f4c9..f2a00a7df1cd 100644
> --- a/fs/btrfs/tree-mod-log.c
> +++ b/fs/btrfs/tree-mod-log.c
> @@ -498,8 +498,11 @@ int btrfs_tree_mod_log_insert_root(struct extent_buffer *old_root,
>  
>  free_tms:
>  	if (tm_list) {
> -		for (i = 0; i < nritems; i++)
> +		for (i = 0; i < nritems; i++) {
> +			if (tm_list[i] && !RB_EMPTY_NODE(&tm_list[i]->node))
> +				rb_erase(&tm_list[i]->node, &fs_info->tree_mod_log);
>  			kfree(tm_list[i]);
> +		}
>  		kfree(tm_list);
>  	}
>  	kfree(tm);
> -- 
> 2.47.2
> 
