Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBAF37C901
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 21:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775597245; cv=none; b=uCBBz/+UCFM/2bshCFkanEwmLHdMMUG3Wpi5esgqobP//EjARnHHjCGiZgleMfdeHWchYBvu6Z+kkDFg6Jd1stPHhtihPl+LNHvw8zuXPtIEX5yFhyt+8DCC47bqE7Mej+MhxZdNunr9B3+f/JnKW7oqVCnZPvojsl1YCXsC0jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775597245; c=relaxed/simple;
	bh=g2lKnDa68MobJwapVH0dI97OxJhhHOKbAuSrO05drBw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ejcXUQG0aE2LIKGgEsZIhDXle0VBAQhyoKrL1szBGox5WuDOk9S8a3i9VDa63Q5aUWbgVwIMlFfAYvI2UEyij5uDKIjWoePvHICyBHWgvGzuoPTXUV4Sc/w7DAiiK5bvYptyLwGRAXbkp80FVqSiRRuX4DsRNdeOXL10Lt1K22o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=b5kLR76O; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ZRudllEA; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="b5kLR76O";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ZRudllEA"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 77D81EC0084;
	Tue,  7 Apr 2026 17:27:23 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Tue, 07 Apr 2026 17:27:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1775597243; x=1775683643; bh=io/QTFjI/M
	tyIYU1x+zgLT11Ti6V5c7S7yf/YFcv8/c=; b=b5kLR76ONiHflCKZWHNM+J0TsW
	2iDaJEipY5o+r6Ii2FPZVhI6dGYWrP1I5csUNMinvBfGB2EMJ3Mtv6X1CI4/s1DC
	PgVodgo+WYFzjb3E9enGLQWJfsmj7NnJGTxV0dpH7iKUcDJXRPg2thvZZBxIMJQT
	RaBgoaU+LwJbdAiTOp97PRiyH2sV4cTBMG2e3X7BM/uMTKh9bhM45bf3pDqH9PbY
	wzpftdAqiJiRnifGtM4RG4FmwkhBbk8o44GPc6ha5QpuUUqNIhs4oT6z6rJYlHzK
	0eahQtLkmwtmjJpBIA4NAA9umKKdS1g/VT2N81xUGh3CVsF8PQkYF2cfFG1A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1775597243; x=1775683643; bh=io/QTFjI/MtyIYU1x+zgLT11Ti6V5c7S7yf
	/YFcv8/c=; b=ZRudllEAnXdKzNBdMWzhwbO9Xu//ywqNnHtwglVdjnaVVa48eH2
	/qP4iNumV9KC2rnxh2Ukg0awn6HS6e2P3HB2Th+WPy6JcccHtoBRBdBLA7/eAgWB
	m8mHgdRdzyPF59aMAWd7lpGK0IyOBi4DRhIyCevcb1eITLh/Gv0b3WQwpFOav6lH
	PDzYzEWc0ouIO4nwoDyzNi6A87eCRS23c66DJV+zSgbc0mq4YLonHNmp2ltWJrEr
	aoJ+nZry9u28etckw4xA+GmFsaO2JXTTr9TM1316bsG/8zjfWwd2HVsDj0o2vcjv
	Zwu4B7KcSI+LJCgDrUu8KGfDXb5QEusbQGA==
X-ME-Sender: <xms:u3bVaa9KTcz_9S36BChXr1jjs0vSi4tBjRir7A1SXvDh1giZkpluZw>
    <xme:u3bVaQum6eG5wI-0P3tCyv_7AB4idi2_utDTmPUGj5vp4Y6FN0ObG58MN47WSweno
    mOsxLh8XKvm2LiCEMOQwqdcbdKx8CYO6KNdrw3CMJCV-m8VSYjxWQs>
X-ME-Received: <xmr:u3bVadqKFuxnm_gNjv68U-qqxLaBmZ5aNgr-IyWzwuOC8trtm9OSbFcPTRsdpmVGBBhfy6MdC-L2n3u1IYWmUtvWYXY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddvudejgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhrihhsuceu
    uhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhepkedvke
    ffjeellefhveehvdejudfhjedthfdvveeiieeiudfguefgtdejgfefleejnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhishessghurh
    drihhopdhnsggprhgtphhtthhopedvpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pehmrghrkheshhgrrhhmshhtohhnvgdrtghomhdprhgtphhtthhopehlihhnuhigqdgsth
    hrfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:u3bVadlDK_vrTyBYmKY59B2zmVDH7FS43smQeSyw9l50ga3D3gTDrQ>
    <xmx:u3bVaRxXM3Q9D84zIO9H-MrOAAyu4kqwIxOHbVzsIs88JG4diEjmmg>
    <xmx:u3bVaVkqh81ifw-YJbHe4zN0RM56AtEzPyGlq_5UoHQMrcN3n0Bm9g>
    <xmx:u3bVaaewOQYdL72DTw-k2vtx3u3Hb_oRmo4uHMyiWp08sI1mGaMuzA>
    <xmx:u3bVaUR9dxcHObTqbO-wspyNT1hx8qi_xpjqNcj0GOcIWx0p1bem_HQj>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Apr 2026 17:27:23 -0400 (EDT)
Date: Tue, 7 Apr 2026 14:27:13 -0700
From: Boris Burkov <boris@bur.io>
To: Mark Harmstone <mark@harmstone.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix bytes_may_use leak in move_existing_remap()
Message-ID: <20260407212713.GB1564178@zen.localdomain>
References: <20260323143618.119698-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323143618.119698-1-mark@harmstone.com>

On Mon, Mar 23, 2026 at 02:36:14PM +0000, Mark Harmstone wrote:
> If the call to btrfs_reserve_extent() in move_existing_remap() returns a
> smaller extent than we asked for, currently we're not undoing the
> bytes_may_use change that we made. Fix this by calling
> btrfs_space_info_update_bytes_may_use() again for the difference.
> 
> Signed-off-by: Mark Harmstone <mark@harmstone.com>
Reviewed-by: Boris Burkov <boris@bur.io>
> Fixes: bbea42dfb91f ("btrfs: move existing remaps before relocating block group")
> ---
>  fs/btrfs/relocation.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 1c42c5180bddd5..3d1756b6116246 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -4174,6 +4174,12 @@ static int move_existing_remap(struct btrfs_fs_info *fs_info,
>  		return ret;
>  	}
>  
> +	if (ins.offset < length) {
> +		spin_lock(&sinfo->lock);
> +		btrfs_space_info_update_bytes_may_use(sinfo, ins.offset - length);
> +		spin_unlock(&sinfo->lock);
> +	}
> +
>  	dest_addr = ins.objectid;
>  	dest_length = ins.offset;
>  
> -- 
> 2.52.0
> 
