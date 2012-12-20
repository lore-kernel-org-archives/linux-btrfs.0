Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:33111 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab2LTTdU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Dec 2012 14:33:20 -0500
Date: Thu, 20 Dec 2012 11:33:19 -0800
From: Zach Brown <zab@zabbo.net>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/3] Btrfs: use wrapper page_offset
Message-ID: <20121220193319.GB9195@lenny.home.zabbo.net>
References: <50D2F45E.2060305@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50D2F45E.2060305@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -	u64 start = (u64)page->index << PAGE_CACHE_SHIFT;
> +	u64 start = (u64)page_offset(page);

The (u64) cast was presumably to keep from losing high bits during the
shift.  page_offset() already has that cast internally and returns
loff_t, which is always long long.  I think that you can drop the cast
from all these calls.

> -		start = ((u64)page->index << PAGE_CACHE_SHIFT) +
> +		start = ((u64)page_offset(page)) +
>  			bvec->bv_offset;

And you can fix the line break now that the line will be nice and short.

And the parenthesis can be removed.

- z
