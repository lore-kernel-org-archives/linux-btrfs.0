Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5270B3793BF
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 21:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775597231; cv=none; b=fViG8y0HSA6ghkViuPvU05Pz51ZzyPbsR9GkWf+wJ7RqiaeaktQdUtBOQjqMCYwbvtrTB2l9Jbg6OkuBiTrkHuiauQ5Zh2MWXKrK2i3O0IjywL+XniLYzXy7p+vR/o5dTTPi7D2CgkdDij+RlLSjC1yBQXAKRwhyZKhSv4omg9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775597231; c=relaxed/simple;
	bh=9J9jl9JjyHFj+4Z+Ns/hUN2WETJ31jhuPy2FfaAaTUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ts/HaDfPOG6cmogAGPS7CcI2+yeOFRhCJF+zk1uS2+02GymqfzZ1Bxez3jvTGbTIs8XIYDWaAQCrnd3MGvdKhdx7ebFaZHfa/8aCQgmw29/zoaKx9dYnfpFccndC/EJRu3GKPhdJhIpiysYMMuUtvmTF8ljnVTp1c8d4OzAVMPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=KpRxnWIX; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=gQEKs6Gf; arc=none smtp.client-ip=103.168.172.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="KpRxnWIX";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="gQEKs6Gf"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 842BD1400215;
	Tue,  7 Apr 2026 17:27:08 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Tue, 07 Apr 2026 17:27:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1775597228; x=1775683628; bh=u7xZB/Wb8N
	1s+ci0zPKSWeyO/ySI2HBZU7UdMlFRzpc=; b=KpRxnWIXCpO5sksVsQ/Jdy11Ty
	8K+BZH5apEbHK2lZv13sEEMbKPDJTuFdH8vEESgLJQPEeyiy/B8m8rw9rc09FDkM
	TcNfEYI4gSlwuoeTUZTl7imx2Hys7A0ct1Amg5Qg8fH2KN25Sba19ARq/wZHTf61
	cKaGryMzEyCUFhq9br+KHg7eIe6xRnMdGDNk1/cul+P2BvIM/ZDi9VyNI3M5Nj6X
	az4ZHb2EH33b/GVjbcteYCvDdVEnKAm7dLSZToqUzKx7TvxnjqNGwjuPva1C1BaU
	KyN8BVcK+xR5AHsscjPIy6hJmKLHHgvhqeammQ7dLolVZMa6wyO6A/gX/gQQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1775597228; x=1775683628; bh=u7xZB/Wb8N1s+ci0zPKSWeyO/ySI2HBZU7U
	dMlFRzpc=; b=gQEKs6GffvVvIUAG3zxP4KKlF/gDUnQmDoIkgd9qh8GnzyePsdk
	YPhmiKcP2ywd7BWwL7ZNwLwBxnPkOvllniE/C10lazKjiozdvvit1sdaX5z3zKpf
	PGZK5sRA+ypfXFWyRGnpkjnNxrscEaxUoYb5+45JBSgwEt8W+XwtaAEVmBz7ylhF
	J/ZhQQeFXVDPU6kmnjN9MFA8LeD9Lfa1L2Ns6nuGdS7pEvjDJxm1OOfydH0wI4Xv
	y5CKnuZzOea/d87qmHgZKy5tR8a/NiAtZJv/OOo3hELETt7oQzZfSnfhHqaJopAU
	qFblsHLBoJSKnhsoUt/Wu3IFNkVJMXrQGFg==
X-ME-Sender: <xms:rHbVafqdx17W2DFjMC5gJuI7eNJly1GOeedgIAkseddQ58F6GqA06w>
    <xme:rHbVafp--Pl2VrcpzlxRlRyki8TL16CHMe1_Q-I-X5wtaW1DLMVjw_dAubgLiTKGS
    hl2U4I3kI7H5EE5JN1UGou8ibyQymLx85hjfNJ7cA_qfVx8RiaSFnpb>
X-ME-Received: <xmr:rHbVaZ2io7_nBTjvie1xysdAye6tE-1ctuFfOQrgd98_Nyfyk9gkSxKVY5Ky77a-COppTsMwJEzhYQqWOOYObrjvPyE>
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
X-ME-Proxy: <xmx:rHbVaeCTW9Oydu1QbCusDAUgrgyaX3ZG-I-iXd9DXCn7eobyZXIcEw>
    <xmx:rHbVaRe0H8FXNdCvpA6b0ZkZUVq4cXljpII8L_GwMx_Ot_DqXQcR9Q>
    <xmx:rHbVaThDGEuE4GS-K9WFyYK4UeJ5ujLgk-_Vrn7RkD8TMjGBKL8jbA>
    <xmx:rHbVaZqh7SgimmxYzl8JyccGOdz9SvWDykiW8i8nC6tC2-TfvsZBaQ>
    <xmx:rHbVabfj7XHpj2GO2-g5AaNoCzRMuqp9aAsRzoP1rfS-fzbrv_FkWM7v>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Apr 2026 17:27:07 -0400 (EDT)
Date: Tue, 7 Apr 2026 14:26:58 -0700
From: Boris Burkov <boris@bur.io>
To: Mark Harmstone <mark@harmstone.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix bytes_may_use leak in do_remap_reloc_trans()
Message-ID: <20260407212658.GA1564178@zen.localdomain>
References: <20260323143704.119969-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323143704.119969-1-mark@harmstone.com>

On Mon, Mar 23, 2026 at 02:36:51PM +0000, Mark Harmstone wrote:
> If the call to btrfs_reserve_extent() in do_remap_reloc_trans() returns
> a smaller extent than we asked for, currently we're not undoing the
> bytes_may_use change that we made. Fix this by calling
> btrfs_space_info_update_bytes_may_use() again for the difference.
> 
> Signed-off-by: Mark Harmstone <mark@harmstone.com>
Reviewed-by: Boris Burkov <boris@bur.io>
> Fixes: fd6594b1446c ("btrfs: replace identity remaps with actual remaps when doing relocations")
> ---
>  fs/btrfs/relocation.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 1c42c5180bddd5..c0bd6db6011965 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -5000,6 +5000,12 @@ static int do_remap_reloc_trans(struct btrfs_fs_info *fs_info,
>  		return ret;
>  	}
>  
> +	if (ins.offset < remap_length) {
> +		spin_lock(&sinfo->lock);
> +		btrfs_space_info_update_bytes_may_use(sinfo, ins.offset - remap_length);
> +		spin_unlock(&sinfo->lock);
> +	}
> +
>  	made_reservation = true;
>  
>  	new_addr = ins.objectid;
> -- 
> 2.52.0
> 
