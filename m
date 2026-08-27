Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F24546E00B;
	Thu, 27 Aug 2026 15:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787846332; cv=none; b=FCS5u2q4Nv02h9ZSA4j1TQbPp+RoUtugW3FoCjcKJpKs3ls//dnyWAezh3iNqR3+/V8MqJl1+MjlhaFsFRfbI5QuFRcyNQMnb7ZpWqUVve4LChfW0jWlU1kh+lgBiJTFoO21tc6rqmjQBZHZ6nnvDLfzNEk3hHfTSw9jmI9a76o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787846332; c=relaxed/simple;
	bh=r6fdGHH6aJ3IojxQ+Wsb63oZm0srBmfPmQkfERd14dY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CoSjgPjXiR/CfhCCxv+ZLWOMk6k1sTL2GLdX/JQ/k197ZhHP1TagYZeK/GpYy70IqEmWx93E/6EY+SRUZoyx4sq1Ajkj+dhHE/U1crTzwfgLFyd168Nq6DWONF355ZYShb7mxHPPDF3JOK2hbyMCyrlBrLpZwWW7BU/WkNFB4/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wif9Jf2p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wif9Jf2p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF63A1F000E9;
	Thu, 27 Aug 2026 15:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787846331;
	bh=pxmt1ucf5uyfo9Y2k28gW/pjL6vxLIYCKLcU2EPJ5y8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Wif9Jf2pIX+r447tKHv4tFQESoyzyPYeqXilcXGSnljj5ZCls4QexZSkxyeXdGd5d
	 JMRphWx0jwMAH1djLJAbXWqZ5x5EE4srn8Lc3XtrJp2Jy2/HCSPB8mElZd9ZokPo/I
	 sanCjp577lBkD1sIi7DbrPEwp7jtKpVTWrcn/7fvWGQuQ+T6rJBnrqYFuTQFRQW9a+
	 BvxB+TrmiXkI23It6Pv7saPVzuN6WWKFupIM5NU7VXh2T+va1G3J46fHRs+dwf/fPY
	 wKGB28vGUem05Nk3xehmaekq/Xl2xxtxB+dSCs//s1zY2Zl0g9rhE8fbltGuFvS4Gu
	 l3vw7RmwFCxHQ==
Date: Thu, 27 Aug 2026 23:58:44 +0800
From: Zorro Lang <zlang@kernel.org>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 5/5] generic/781: fix copyright
Message-ID: <apBd_LNAobthcrs1@zlang-mailbox>
Mail-Followup-To: Johannes Thumshirn <johannes.thumshirn@wdc.com>, 
	Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	Christoph Hellwig <hch@lst.de>
References: <20260819131606.1478488-1-johannes.thumshirn@wdc.com>
 <20260819131606.1478488-6-johannes.thumshirn@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260819131606.1478488-6-johannes.thumshirn@wdc.com>

On Wed, Aug 19, 2026 at 03:16:05PM +0200, Johannes Thumshirn wrote:
> My employer is called Western Digital not Wesgtern Digital. I'm sorry.
> 
> Spotted-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  tests/generic/781 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/generic/781 b/tests/generic/781
> index 575cc4ab..38536d64 100755
> --- a/tests/generic/781
> +++ b/tests/generic/781
> @@ -1,6 +1,6 @@
>  #! /bin/bash
>  # SPDX-License-Identifier: GPL-2.0
> -# Copyright (c) 2025 Wesgtern Digital Corporation.  All Rights Reserved.
> +# Copyright (c) 2025 Western Digital Corporation.  All Rights Reserved.
>  #
>  # FS QA Test No. 781
>  #
> -- 
> 2.55.0
> 
> 
