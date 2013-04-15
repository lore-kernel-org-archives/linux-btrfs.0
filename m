Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:54319 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab3DOMyv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 08:54:51 -0400
Received: by mail-pd0-f177.google.com with SMTP id u11so2468188pdi.22
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Apr 2013 05:54:51 -0700 (PDT)
Content-Type: text/plain; charset=GB2312
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH V2] Btrfs: fix confusing edquot happening case
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <1366030116-9019-1-git-send-email-wangshilong1991@gmail.com>
Date: Mon, 15 Apr 2013 20:54:46 +0800
Cc: Wang Shilong <wangsl-fnst@fujitsu.com>
Message-Id: <DC1CC098-16DC-47AD-BD1E-0863151B8956@gmail.com>
References: <1366030116-9019-1-git-send-email-wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am sorry, please ignore this¡­I will resend it..

> From: Wang Shilong <wangsl-fnst@fujitsu.com>
> 
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
> From the perspective of users, qgroup's referenced or exclusive
> is negative,but user can not continue to write data! a workaround
> way is to cast u64 to s64 when doing qgroup reservation.
> 
> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> Reviewed-by: Arne Jansen <sensille@gmx.net>
> ---
> Changelog v1->v2:
> -use s64 instead of signed long long
> ---
> fs/btrfs/qgroup.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index b44124d..ab364a2 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1523,14 +1523,14 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
> 		qg = (struct btrfs_qgroup *)(uintptr_t)unode->aux;
> 
> 		if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
> -		    qg->reserved + qg->rfer + num_bytes >
> +		    qg->reserved + (s64)qg->rfer + num_bytes >
> 		    qg->max_rfer) {
> 			ret = -EDQUOT;
> 			goto out;
> 		}
> 
> 		if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL) &&
> -		    qg->reserved + qg->excl + num_bytes >
> +		    qg->reserved + (s64)qg->excl + num_bytes >
> 		    qg->max_excl) {
> 			ret = -EDQUOT;
> 			goto out;
> -- 
> 1.7.11.7
> 

