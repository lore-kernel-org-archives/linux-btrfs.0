Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:49237 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755700Ab3DOKqA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 06:46:00 -0400
Received: from mailout-de.gmx.net ([10.1.76.24]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0M1Cg2-1UgsMI3lH6-00tEyy for
 <linux-btrfs@vger.kernel.org>; Mon, 15 Apr 2013 12:45:58 +0200
Message-ID: <516BDA62.5080008@gmx.net>
Date: Mon, 15 Apr 2013 12:45:54 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH RFC] Btrfs: fix confusing edquot happening case
References: <516BD85B.3050508@cn.fujitsu.com>
In-Reply-To: <516BD85B.3050508@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 15.04.2013 12:37, Wang Shilong wrote:
> Step to reproduce:
> 	mkfs.btrfs <disk>
> 	mount <disk> <mnt>
> 	dd if=/dev/zero of=/<mnt>/data bs=1M count=10
> 	sync
> 	btrfs quota enable <mnt>
> 	btrfs qgroup create 0/5 <mnt>
> 	btrfs qgroup limit 5M 0/5 <mnt>
> 	rm -f /<mnt>/data
> 	sync
> 	btrfs qgroup show <mnt>
> 	dd if=/dev/zero of=data bs=1M count=1
> 
> From the perspective of users, qgroup's referenced or referenced
> 
> is negative,But user can not continue to write data! a workaround
> way is to cast u64 to int64 when doing qgroup reservation.
> 
> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> ---
> This confusing edquot may also happen after Jan's qgroup
> rescan has been implemented.
> ---
>  fs/btrfs/qgroup.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index b44124d..0178223 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1523,14 +1523,14 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
>  		qg = (struct btrfs_qgroup *)(uintptr_t)unode->aux;
>  
>  		if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
> -		    qg->reserved + qg->rfer + num_bytes >
> +		    qg->reserved + (signed long long)qg->rfer + num_bytes >

why not use s64 instead of signed long long? Otherwise this is the right way to
solve this.

Thanks,
Arne

>  		    qg->max_rfer) {
>  			ret = -EDQUOT;
>  			goto out;
>  		}
>  
>  		if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL) &&
> -		    qg->reserved + qg->excl + num_bytes >
> +		    qg->reserved + (signed long long)qg->excl + num_bytes >
>  		    qg->max_excl) {
>  			ret = -EDQUOT;
>  			goto out;

