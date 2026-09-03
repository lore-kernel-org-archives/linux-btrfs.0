Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FFC4CA287
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 21:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788471766; cv=none; b=Ukc66Sv6AVKoru6TC0KzOq48NYZCW8S7whmTNzGu7k49uft+bQdp6fBcJxQ4tDqcEOPRUNH8FJ7WguSXe3RyCZos54x96TU06+Xrn5BrpOudRkyYoIv/e3LEEOd9W/087KY3ZiRj1uE9eyWiLgvOI6GjjYv8kBMmcoJ4rLuLV24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788471766; c=relaxed/simple;
	bh=3Py5V4xmBkLAKbqeVqmWDtpAvc17ll9SOlsxxjUIV3c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dJKWkI8w6SJ+swqDy4C0x5z7sOXeuz9CPhsHnq5aguLIKgFryUGRYu24veDZ0T/Kgn6QymWwqf7oVTDVErbe57mHYR71beDl21wUmUjvVYRo3cViAu/4BbXgEC4ovHgSS9mX/0qDf4oEiA6P0KABQ0UZpq6vk6XstRFIY28Nd8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=effMUOyh; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=LkSF01u5; arc=none smtp.client-ip=202.12.124.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="effMUOyh";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="LkSF01u5"
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfout.stl.internal (Postfix) with ESMTP id 388C81D0010C;
	Thu,  3 Sep 2026 17:42:43 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Thu, 03 Sep 2026 17:42:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1788471763; x=1788558163; bh=KQFj5UAiaf
	rlTjaFQJ6bQ+z4zf1/kX6YzGqJskUSRhs=; b=effMUOyhscBoYAX8Z1Uhu9JaDR
	rbsFZtizze0mddzkcLkhCSJDAWpF60w4BcyecD2fHU2gUS6VJ7JVyds2YAKNrMnE
	L3yxXl2J7+W69l9iAyZKAazfDJXRN3QbIpG+pCtkboXoXg7vNb4LHPrV0fvJyFF0
	VkRWRP9CrSxDczdIczTl/3BTQDpqSIildiLnThB5e8RLvIa+m/g/dyDMUXcRzwip
	E8x0Wk4SodY8GEyi9XK6sflJN1bdyB4jpFAjbJlhQA0GoHiZZPPNqFZ5aAtTUlJY
	tV/CWJJIZhzsMliDGu23VGmHF/ZkJi5TJRRq3whvtnHF3kxg6ekY1H8isEGQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1788471763; x=1788558163; bh=KQFj5UAiafrlTjaFQJ6bQ+z4zf1/kX6YzGq
	JskUSRhs=; b=LkSF01u5n5z9wSqcLFlu7QYXDGKW597QmzOHUJl1ktyfRqa1tf2
	03J+vMOEmD+7I2Le9x3cFpzBYLjhGc5VbPHLUQOAhHY5GvLtG/E/9RdwNu8sdeSu
	rQN8jtH/CjU8WppnRtBKyhWyXt9Nb96FqDBV1RQ5XTFdKUbA30tykukYZQTCFq3y
	Y8KF9CPp0of0v2ujXrf6A5JHtDBWsoF+t0i4UD5D10LjR0UeUl9EQclDFiAQhNBK
	FdvND+UjwmMjuAQO+jHYgJ0DGiyXVk/B8AE2nUp7sl7np/WQEBZRLPyP83v1wUi6
	PmSVVHemUO+AGj9fXG2it1pGvMKmVhFJyNQ==
X-ME-Sender: <xms:0-mZagTU5n0cFw8b6RWEihaY_1eG3SM1FZrPgKsL5j2XcLVd42mjjw>
    <xme:0-mZajx9B8Kaxk-9pZRRxK6iXQKOZx3KLAB_x-PEDh36NUVIoJpyR-rnIoEeQ_G90
    gNyFWNshEWK55Rbj4O__-1VaD25pXeC46INuOl1dFj4clNxqnD1aXxW>
X-ME-Received: <xmr:0-mZarcwTQdLVgw6tHz60SNl3I7qEsHsydlMjSI1lBAvYVXiFwShX9c>
X-ME-Proxy-Cause: dmFkZTE6bcPXSkdgGz114XCTSUmXunObu+brELl7WZOhf7pKOMpVvvLxGmTRMnOj983c++
    oDprx93Tok9gFQxvbL+s+ZgevZV4EVvFyy9mVSnjDGMk59a3ov7Z9hpUpFNdyDMjiSYeXZ
    cZ/6Y4SeC6zvVUheHzN6rLSDuJB9a8f3/zPtW+ai7tAiz17uJbCSF6TBhQsaoX4ae5PUNs
    P/ky5ldIuLIK97t+92rGCec8D/7DyOhFX0tr3fXox9V5zurthYa4GkcDmOZoHoDOthlQtT
    HBxP2M7qX+EGQ7qFS3yEhpiAXx9+/KOvaL8lf5OQIANlCOB+HFD/0UeXxraqDjZyxTftR+
    MMVFOG20sql35gitPZRgrRA2K56I1ttVDqedMN34Sk0FtAn8JeJg/E6+ol6qUZ6nLV7Co9
    bPJsnHnkOCFAaTgArdTOR1LMPbHd6mAsFthL+dwszYY2DdELZ7nFZBjA1bb/l2pj8VYXQo
    m9TZSsVbFBr1JEBcHtPXAouJ0x0VR9HkX4HRBjWczoz2ggOtlH/DAFLNYfPIMZ9PbrRJOM
    TLmK4+DepqecZ5S2VAdGY82ZMjh+VJ4iTKUmU61rZof8Sk8jGHQua2NldtPonRgE6qGaxh
    0V2ZFKsD2L1fjr123ad+KhZSAuAxfsikXLgVCxvtMEYVJ7an5s6kLzAOExnQ
X-ME-Proxy: <xmx:0-mZavJwMDiUD_gJGmQd5I5Ev0r0qMKbcYrrG8NEK47GQfw4pQ-yhg>
    <xmx:0-mZasEA-FZRUkM-U2pqM8vHXQfvOpny_iW85CB7XaOOF2pGqU3gPA>
    <xmx:0-mZapqjyYWM16pvGKckxTsV5YJgXPCegUey2epPL9bwzFh-v4T6TQ>
    <xmx:0-mZalS3Y1mhQTD45PzpzEWZcaczIkuW-otCt4w81oDky3-Ds5USCA>
    <xmx:0-mZanFeU_jNII8JeNoXqbKfEYCTqz9cra-WR9HqgzLkgjDmrIzK6NXv>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Sep 2026 17:42:42 -0400 (EDT)
Date: Thu, 3 Sep 2026 14:41:55 -0700
From: Boris Burkov <boris@bur.io>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: tree-checker: validate name length for extref
 items
Message-ID: <20260903214155.GC3237930@zen.localdomain>
References: <0fbde4f56df4c84aa62864a2641217fe2a8132c1.1788452841.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fbde4f56df4c84aa62864a2641217fe2a8132c1.1788452841.git.fdmanana@suse.com>

On Thu, Sep 03, 2026 at 05:27:48PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> We are validating the name length of inode ref items, but we miss the same
> validation for extref items. Sashiko pointed this out while reviewing
> other patch. Add the missing validation, similar to what was done in commit
> 3dc22abc21f5 ("btrfs: tree-checker: validate INODE_REF's namelen").
> 
Reviewed-by: Boris Burkov <boris@bur.io>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/tree-checker.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index 3a0715798282..401fd40ec7b2 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -2032,6 +2032,13 @@ static int check_inode_extref(struct extent_buffer *leaf,
>  		}
>  
>  		namelen = btrfs_inode_extref_name_len(leaf, extref);
> +		if (unlikely(namelen == 0 || namelen > BTRFS_NAME_LEN)) {
> +			inode_ref_err(leaf, slot,
> +				"invalid inode extref name length, has %u expect [1, %u]",
> +				namelen, BTRFS_NAME_LEN);
> +			return -EUCLEAN;
> +		}
> +
>  		if (unlikely(ptr + sizeof(*extref) + namelen > end)) {
>  			inode_ref_err(leaf, slot,
>  				"inode extref overflow, ptr %lu end %lu namelen %u",
> -- 
> 2.47.2
> 
