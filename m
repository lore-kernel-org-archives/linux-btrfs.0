Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:34384 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753495Ab2ITN2K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Sep 2012 09:28:10 -0400
Date: Thu, 20 Sep 2012 15:28:03 +0200
From: David Sterba <dave@jikos.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V2 1/2] Btrfs: cleanup duplicated division functions
Message-ID: <20120920132802.GM17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <5051BAB8.7080200@cn.fujitsu.com>
 <505A8632.10101@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <505A8632.10101@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 20, 2012 at 10:57:54AM +0800, Miao Xie wrote:
> Because those functions are mostly used on the hot path, and we are sure
> the parameters are right in the most cases, we don't add complex checks
> for the parameters. But in the other place, we must check and make sure
> the parameters are right. So besides the code cleanup, this patch also
> add a check for the usage of the space balance, it is the only place that
> we need add check to make sure the parameters of div_factor{_fine} are
> right till now.

I've reviewed the hotpaths, makes sense to optimize for speed. Adding
the boundary checks to balance ioctl is ok.

A few suggestions:

* drop the version that does the /10 version and keep only /100 (naming
  it div_factor)
* drop the

+	if (factor == 10)
+		return num;

check, there's only one instance where we pass the maximum value (and
it's not a frequent case), so there's the if() penalty, makes the
function smaller and even more suitable for inlining.

> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 9384a2a..d8d53f7 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3335,6 +3335,24 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
>  
>  			goto do_balance;
>  		}
> +
> +		if ((bargs->data.flags & BTRFS_BALANCE_ARGS_USAGE) &&
> +		    (bargs->data.usage < 0 || bargs->data.usage > 100)) {

data.usage <= 0

otherwise you'd divide by 0 in chunk_usage_filter()

(in current version the check is done in the _fine version, so -dusage=0
does not crash kernel)

> +			ret = -EINVAL;
> +			goto out_bargs;
> +		}
> +
> +		if ((bargs->meta.flags & BTRFS_BALANCE_ARGS_USAGE) &&
> +		    (bargs->meta.usage < 0 || bargs->meta.usage > 100)) {

same here

> +			ret = -EINVAL;
> +			goto out_bargs;
> +		}
> +
> +		if ((bargs->sys.flags & BTRFS_BALANCE_ARGS_USAGE) &&
> +		    (bargs->sys.usage < 0 || bargs->sys.usage > 100)) {

same here

> +			ret = -EINVAL;
> +			goto out_bargs;
> +		}
>  	} else {
>  		bargs = NULL;
>  	}
> diff --git a/fs/btrfs/math.h b/fs/btrfs/math.h
> new file mode 100644
> index 0000000..b7816ce
> --- /dev/null
> +++ b/fs/btrfs/math.h

I think we don't need single file to hold one trivial function then :)

> @@ -0,0 +1,44 @@
> +#include <asm/div64.h>
> +
> +static inline u64 div_factor(u64 num, int factor)
> +{
> +	num *= factor;
> +	do_div(num, 100);
> +	return num;
> +}

david
