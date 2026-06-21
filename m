Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B06E25B092;
	Sun, 21 Jun 2026 22:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782082670; cv=none; b=OIuB0N+n570M5UH+nKoaQ0PuFs+ntW/0hNiQFGEDSNaZAR3rjZxD0IxWK1OFglFUWfzClkZ4L1PyKRRM6KdX9SbcMZFtL4vIBMrCw6DgJwieQjAT1SKo4IbESPnfuSxSLpNTH+dvHgm5CCRi0ou6pxejFTcDgIawZEWv5QArmiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782082670; c=relaxed/simple;
	bh=gDiKuYnGYNkM2dDFonxhgMNhV0rniFFGPyOO7I/lkrU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NIzE6gFjIacGfNzjtBFu6SeFtSlmVLVAJ2FW1Fk0pOoroyWESp493XCd687D5qsKKIyHY4vcjp7+gWwHzGykPF0IrkgY4AJGRhdu+c5qvNbJxhsHZS2uUrRkLNOSVppxUyZjCsQPiHmu3d0UM3ccaNKslt4tgoY5BZRlRtTjXNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vqgCG7q/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vqgCG7q/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=6X+j4Rx/Rh6Ko6r16t8ayluJoXD9V965QhVGkek5yJY=; b=vqgCG7q/m/lbsK4jc4u2lW+7g/
	zS1Cpd2b4hMYZKuCLeQQpiF3gg0Q36WDt1+Kydsto+5prGWDNG0LRwW0PS5wQjgnCu1jS4XQglhch
	KGlBYEMP5EZE3jJH7rbryS/ywN0KGEksuhKjPvxQ0vwMew7IzhBcGmwCiP9/SPZCPJuMByvvnt3zT
	rAl6PRYqD6PHs2wcg/Cb5+HJF0FRu9jNsJ0NFLuXdeJ+a+yGLsEyqk4LvUJisuZCfdjeM/q8tSWID
	jHxPQxAY6cir6Sb0MKj9dLBhFmDcgXtIa+q0s6/X0grK8MjNFoacvkgrjAEEpfLmQNeZCe+0clU87
	xrihzbIw==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wbR6k-00000004EAg-1mEu;
	Sun, 21 Jun 2026 22:57:42 +0000
Message-ID: <877f83af-d3ba-42b3-8867-0aa8f2d56cb9@infradead.org>
Date: Sun, 21 Jun 2026 15:57:41 -0700
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: sysfs: fix path of the "read_policy" module
 parameter in comment
To: Zenghui Yu <zenghui.yu@linux.dev>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: clm@fb.com, dsterba@suse.com
References: <20260621074626.11193-1-zenghui.yu@linux.dev>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260621074626.11193-1-zenghui.yu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 6/21/26 12:46 AM, Zenghui Yu wrote:
> The correct path of the "read_policy" module parameter should be
> /sys/module/btrfs/parameters/read_policy. Fix it.
> 
> Signed-off-by: Zenghui Yu <zenghui.yu@linux.dev>

Acked-by: Randy Dunlap <rdunlap@infradead.org>
Thanks.

> ---
>  fs/btrfs/sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index 0d14570c8bc2..39cb01ee441a 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -1336,7 +1336,7 @@ char *btrfs_get_mod_read_policy(void)
>  	return read_policy;
>  }
>  
> -/* Set perms to 0, disable /sys/module/btrfs/parameter/read_policy interface. */
> +/* Set perms to 0, disable /sys/module/btrfs/parameters/read_policy interface. */
>  module_param(read_policy, charp, 0);
>  MODULE_PARM_DESC(read_policy,
>  "Global read policy: pid (default), round-robin[:<min_contig_read>], devid[:<devid>]");

-- 
~Randy
