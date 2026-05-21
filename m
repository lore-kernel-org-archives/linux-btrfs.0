Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6B6408009
	for <linux-btrfs@vger.kernel.org>; Thu, 21 May 2026 19:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779393208; cv=none; b=RVhofuwOPyUuUlqWxlpFUAZM1WUO9g7u0y2pTfx1UBenPccCbqUmfsODyJt6yTon4MqwGgBn6svRurh9PVaJA89XiJ7ZZVrQoV/PPnSXw6zYr0Dht+GbMS4qBrq2MGO9d4NQbKZ6ADnAuIYpjGB8IsR82HHg65VQgEjHs8RawkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779393208; c=relaxed/simple;
	bh=sxibLr+Bc7llR+CNKGoqZKRrYsubJWjVa+bUFMB3lMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HpKpysMeoKM/2nVzBNoppHdmcHuyVVYNEWT4ZkmzE8ovu1rakyGGfOqoK0Mv/TTinoM8nk7zlAI6U7VLPwf7M4GrYOE9X0YHZaFtVQbDMNziWIi/AzoY992ECVcb/iMXhm18X+CIlmOJhkpLQmgtkdg8MZzd3NqTH0rE7ByHkMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=WxLbn0/X; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=BMR0bAEN; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="WxLbn0/X";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="BMR0bAEN"
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.phl.internal (Postfix) with ESMTP id 9D43CEC00B6;
	Thu, 21 May 2026 15:53:24 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Thu, 21 May 2026 15:53:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1779393204; x=1779479604; bh=07IA0o6whd
	VUAiD4HmT9iGaoVIh3vXeHj71ibNKKmwk=; b=WxLbn0/XMxvFP2E3YfLqn4uRCV
	UzvaHx7PfiKCN6EwedofcHo9FVcpnmbAlO+XSR3BjWSgYhUV5cldVRa2yvcTkvsK
	c6ZK9ZBe90ru2Lfpq0xUm2aKDbpUlqaE0EyphnT4MJlW5UZVMH+AN9xsxv6PqL5G
	+LzFdDmfDNnuOdJqTOFIYQJXUkg/chsjmh7di38nW/LINNHN8w2tqQb6mZN+I6tl
	aTZo6BMxcv03c3a0xPVCW/Rb+T+HDWJNYfa+48gTdng4YL/rVnnXaHTFNt5whZ5Q
	zyMLj7neh7Zagu3SbpgVQEib2j/ORGctifB2IBvoXnQByWNh8EU4KA01EAPQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1779393204; x=1779479604; bh=07IA0o6whdVUAiD4HmT9iGaoVIh3vXeHj71
	ibNKKmwk=; b=BMR0bAENPowUAwcUjm+F891m3COGh3U+/jFFNUgEkUU7y4sTvPN
	8+U/yfM6jXsMWJXgXz0a7beGJN8R11JAAVnIer6yMrFM6PiA8/aDFpxx/Y4mT4sQ
	YinF5u8EFQwKuIBX9lopFvS2ECCoC+QZ0JdjTA+HDScOyU0qiv2wI6S8fGcfBD01
	DVk+5SVv0RC43ZhxfygtTXQzr5YSX8Rk2soBTEqaFs8zE8UKJKheTDF35Gk5ROfU
	pyX/9Gg751oSLexpRXpY6zzwCV1kuLARRZAgDXOgXaPnnIEQEh0I+fRge7sDD/YN
	WPFfiHYMYlaAFLLopPckJyFSjUqVtJMHKZQ==
X-ME-Sender: <xms:tGIPat_9wx5Lkrv5I3es0Q5G3ZYuuFtDavqN5126MYSV9Lkp9xkCoA>
    <xme:tGIPansRsXN_-xVtagoNV1YNWIle3mmNZs5sWMiIV2zUk1cUHrnMhn7tLdtqsFzBS
    ba64vjhFV6iu11p29i1eKoW7CTdsrAXzTIHsykxQT55kiHVAy_2WsI>
X-ME-Received: <xmr:tGIPaorpxVME0qVPeIVvLJy7jMs_aQCdyGu9w8YQTf4zgBIZ9nxFVgRX-gq61Wiv-UWikAwiLzN4TWVnvWXlh3hs1lg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddugeekgedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfhfgggtuggjsehttdertd
    dttddvnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhephedthfevgffhtdevgffhlefhgfeuueegtdevudeihe
    eiheetleeghedvfeegfeegnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhiohdpnhgspghrtghpthhtohepvddpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepfhgumhgrnhgrnhgrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqd
    gsthhrfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:tGIPasm0KJogqKIkgWjpVxB8Kcf6ZtZRyCJrH6Z3P3brRfSR8TYoEQ>
    <xmx:tGIPakwN1BbNNN_e1zwDxoVGx8W4G1dkeLfRmJhAfTczCRZnSzy0WQ>
    <xmx:tGIPasnc4wMkhxmeuZqqUBv1Wlm0HluaaAQ7q6w72yzFafHSQcYA1w>
    <xmx:tGIPaldKQhMk8rOT1gugMbHP8qSUsWtv9anVkoQNFHjBdTGGTVfwZQ>
    <xmx:tGIPavSuvnwK9rO0JY7zktWikAje0JIpu8cLaiRNMOZAeGYuenEZMj86>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 21 May 2026 15:53:24 -0400 (EDT)
Date: Thu, 21 May 2026 12:53:20 -0700
From: Boris Burkov <boris@bur.io>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: fix invalid pointer dereference in
 __btrfs_run_delayed_refs()
Message-ID: <20260521195320.GA2360776@zen.localdomain>
References: <f33f040f3ced4b3813dba4ddb0b5377ab5aeac29.1779374308.git.fdmanana@suse.com>
 <f81a69124ba44ff062f13e6287be7f0f5cf56072.1779375954.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f81a69124ba44ff062f13e6287be7f0f5cf56072.1779375954.git.fdmanana@suse.com>

On Thu, May 21, 2026 at 04:07:36PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> In the beginning of the loop, we try to obtain a locked delayed ref head,
> if 'locked_ref' is currently NULL, by calling btrfs_select_ref_head(),
> which can return an error pointer. If the error pointer is -EAGAIN we do
> a continue and go back to the beginning of the loop, which will not try
> again to call btrfs_select_ref_head() since 'locked_ref' is no longer
> NULL but it's ERR_PTR(-EAGAIN), and then we do:
> 
>    spin_lock(&locked_ref->lock);
> 
> against a ERR_PTR(-EAGAIN) value, generating an invalid pointer
> dereference.
> 
> Fix this by ensuring that 'locked_ref' is set to NULL when
> btrfs_select_ref_head() returns ERR_PTR(-EAGAIN) and incrementing 'count'
> as well, to prevent infinite looping. We do this by doing a goto to the
> bottom of the loop that already sets 'locked_ref' to NULL and does a
> cond_resched(), with an increment to 'count' right before the goto.
> These measures were in place before the refactoring in commit 0110a4c43451
> ("btrfs: refactor __btrfs_run_delayed_refs loop") but were unintentionally
> lost afterwards.
> 
> Reported-by: Dan Carpenter <error27@gmail.com>
> Link: https://lore.kernel.org/linux-btrfs/ag8ARRwykv8bpJ87@stanley.mountain/
> Fixes: 0110a4c43451 ("btrfs: refactor __btrfs_run_delayed_refs loop")

Reviewed-by: Boris Burkov <boris@bur.io>

> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
> 
> V2: Use a goto approach to jump to the bottom of the loop, that already
>     sets locked_ref to NULL and does a cond_resched() too.
> 
>  fs/btrfs/extent-tree.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index ecc1acb1e340..6030cdbdb742 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2108,7 +2108,8 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
>  			locked_ref = btrfs_select_ref_head(fs_info, delayed_refs);
>  			if (IS_ERR_OR_NULL(locked_ref)) {
>  				if (PTR_ERR(locked_ref) == -EAGAIN) {
> -					continue;
> +					count++;
> +					goto again;
>  				} else {
>  					break;
>  				}
> @@ -2156,7 +2157,7 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
>  		 * Either success case or btrfs_run_delayed_refs_for_head
>  		 * returned -EAGAIN, meaning we need to select another head
>  		 */
> -
> +again:
>  		locked_ref = NULL;
>  		cond_resched();
>  	} while ((min_bytes != U64_MAX && bytes_processed < min_bytes) ||
> -- 
> 2.47.2
> 
