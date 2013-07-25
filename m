Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:33339 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755478Ab3GYLUy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jul 2013 07:20:54 -0400
Message-ID: <51F10A50.9010308@cn.fujitsu.com>
Date: Thu, 25 Jul 2013 19:21:52 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Eryu Guan <guaneryu@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fix segfault when listing column OTIME on
 big endian host
References: <1374744749-12231-1-git-send-email-guaneryu@gmail.com>
In-Reply-To: <1374744749-12231-1-git-send-email-guaneryu@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On thu, 25 Jul 2013 17:32:29 +0800, Eryu Guan wrote:
> The second btrfs command segfaults on big endian host(ppc64)
> 
> 	btrfs subvolume snapshot /mnt/btrfs /mnt/btrfs/snap
> 	btrfs subvolume list -s /mnt/btrfs
> 
> And ltrace shows
> 
> 	localtime(0x10029c482d0)                 = 0
> 	strftime( <no return ...>
> 	--- SIGSEGV (Segmentation fault) ---
> 
> The corresponding code
> 
> btrfs-list.c:
>         case BTRFS_LIST_OTIME:
>                 if (subv->otime)
>                         strftime(tstr, 256, "%Y-%m-%d %X",
>                                  localtime(&subv->otime));
>                 else
>                         strcpy(tstr, "-");
>                 printf("%s", tstr);
>                 break;
> 
> localtime() returned NULL then strftime() got SIGSEGV.
> 
> The reason is that ri->otime.sec is stored as little endian but
> assigned to 't' without conversion.
> 
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>
> ---
>  btrfs-list.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/btrfs-list.c b/btrfs-list.c
> index 4fab858..ca1bae8 100644
> --- a/btrfs-list.c
> +++ b/btrfs-list.c
> @@ -1052,7 +1052,7 @@ static int __list_subvol_search(int fd, struct root_lookup *root_lookup)
>  				flags = btrfs_root_flags(ri);
>  				if(sh.len >
>  				   sizeof(struct btrfs_root_item_v0)) {
> -					t = ri->otime.sec;
> +					t = le64_to_cpu(ri->otime.sec);

It is better to use btrfs_stack_timespec_sec() instead of raw convert.

Thanks
Miao

>  					ogen = btrfs_root_otransid(ri);
>  					memcpy(uuid, ri->uuid, BTRFS_UUID_SIZE);
>  					memcpy(puuid, ri->parent_uuid, BTRFS_UUID_SIZE);
> 

