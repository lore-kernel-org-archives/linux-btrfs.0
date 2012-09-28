Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:34378 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757329Ab2I1KKC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Sep 2012 06:10:02 -0400
Date: Fri, 28 Sep 2012 12:09:54 +0200
From: David Sterba <dave@jikos.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V5 1/2] Btrfs: cleanup duplicated division functions
Message-ID: <20120928100953.GH14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <5051BAB8.7080200@cn.fujitsu.com>
 <505A8632.10101@cn.fujitsu.com>
 <505C2E62.2000400@cn.fujitsu.com>
 <5064284E.9020504@cn.fujitsu.com>
 <50650219.7080306@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50650219.7080306@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 28, 2012 at 09:49:13AM +0800, Miao Xie wrote:
> diff --git a/fs/btrfs/math.h b/fs/btrfs/math.h
> new file mode 100644
> index 0000000..4fef49f
> --- /dev/null
> +++ b/fs/btrfs/math.h
> @@ -0,0 +1,35 @@
> +
> +/*
> + * Copyright (C) 2012 Fujitsu.  All rights reserved.
> + * Written by Miao Xie <miaox@cn.fujitsu.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public
> + * License v2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public
> + * License along with this program; if not, write to the
> + * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
> + * Boston, MA 021110-1307, USA.
> + */
> +
> +#ifndef __BTRFS_MATH_H
> +#define __BTRFS_MATH_H
> +
> +#include <asm/div64.h>
> +
> +static inline u64 div_factor(u64 num, int factor)
> +{
> +	WARN_ON(factor > 100 || factor < 0);
> +
> +	num *= factor;
> +	do_div(num, 100);
> +	return num;
> +}
> +
> +#endif

Sorry no, a 4 line function does not deserve a separate file.

david
