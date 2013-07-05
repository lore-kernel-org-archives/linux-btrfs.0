Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:61535 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757186Ab3GEI4f (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Jul 2013 04:56:35 -0400
Message-ID: <51D68A7B.40009@cn.fujitsu.com>
Date: Fri, 05 Jul 2013 16:57:31 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RESEND] Btrfs: fix wrong write offset when replacing a
 device
References: <1372947263-823-1-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1372947263-823-1-git-send-email-sbehrens@giantdisaster.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	thu, 4 Jul 2013 16:14:23 +0200, Stefan Behrens wrote:
> Miao Xie reported the following issue:
> 
> The filesystem was corrupted after we did a device replace.
> 
> Steps to reproduce:
>  # mkfs.btrfs -f -m single -d raid10 <device0>..<device3>
>  # mount <device0> <mnt>
>  # btrfs replace start -rfB 1 <device4> <mnt>
>  # umount <mnt>
>  # btrfsck <device4>
> 
> The reason for the issue is that we changed the write offset by mistake,
> introduced by commit 625f1c8dc.
> 
> We read the data from the source device at first, and then write the
> data into the corresponding place of the new device. In order to
> implement the "-r" option, the source location is remapped using
> btrfs_map_block(). The read takes place on the mapped location, and
> the write needs to take place on the unmapped location. Currently
> the write is using the mapped location, and this commit changes it
> back by undoing the change to the write address that the aforementioned
> commit added by mistake.
> 
> Reported-by: Miao Xie <miaox@cn.fujitsu.com>
> Cc: <stable@vger.kernel.org> # 3.10+
> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>

Thanks!

Reviewed-and-Tested-by: Miao Xie <miaox@cn.fujitsu.com>

> ---
> Resent to add stable@vger.kernel.org since the regression was added
> in 3.10 RC1.
> 
>  fs/btrfs/scrub.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 4ba2a69..64a157b 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -2495,7 +2495,7 @@ again:
>  			ret = scrub_extent(sctx, extent_logical, extent_len,
>  					   extent_physical, extent_dev, flags,
>  					   generation, extent_mirror_num,
> -					   extent_physical);
> +					   extent_logical - logical + physical);
>  			if (ret)
>  				goto out;
>  
> 

