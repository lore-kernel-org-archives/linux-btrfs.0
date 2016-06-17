Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:27986 "EHLO
	mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811AbcFQAOi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jun 2016 20:14:38 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id E0F31AC011E
	for <linux-btrfs@vger.kernel.org>; Fri, 17 Jun 2016 09:14:32 +0900 (JST)
Subject: Re: [PATCH] Btrfs-progs: Initialize stripesize to the value of
 sectorsize
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org
References: <1466095109-26044-1-git-send-email-chandan@linux.vnet.ibm.com>
Cc: dsterba@suse.com, bo.li.liu@oracle.com
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <589a75e9-277e-8c79-a904-6db5fc2a9a23@jp.fujitsu.com>
Date: Fri, 17 Jun 2016 09:14:07 +0900
MIME-Version: 1.0
In-Reply-To: <1466095109-26044-1-git-send-email-chandan@linux.vnet.ibm.com>
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016/06/17 1:38, Chandan Rajendra wrote:
> stripesize should ideally be set to the value of sectorsize. However
> previous versions of btrfs-progs/mkfs.btrfs had set stripesize to a
> value of 4096. On machines with PAGE_SIZE other than 4096, This could
> lead to the following scenario,
> 
> - /dev/loop0, /dev/loop1 and /dev/loop2 are mounted as a single
>   filesystem. The filesystem was created by an older version of mkfs.btrfs
>   which set stripesize to 4k.
> - losetup -a
>    /dev/loop0: [0030]:19477 (/root/disk-imgs/file-0.img)
>    /dev/loop1: [0030]:16577 (/root/disk-imgs/file-1.img)
>    /dev/loop2: [64770]:3423229 (/root/disk-imgs/file-2.img)
> - /etc/mtab lists only /dev/loop0
> - losetup /dev/loop4 /root/disk-imgs/file-1.img
>   The new mkfs.btrfs invoked as 'mkfs.btrfs -f /dev/loop4' succeeds even
>   though /dev/loop1 has already been mounted and has
>   /root/disk-imgs/file-1.img as its backing file.
> 
> The above behaviour occurs because check_super() function returns an
> error code (due to stripesize not being set to 4096) and hence
> check_mounted_where() function treats /dev/loop1 as a disk containing a
> filesystem other than Btrfs.
> 
> Hence as a workaround this commit allows 4096 as a valid stripesize.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>  disk-io.c | 4 +++-
>  mkfs.c    | 1 +
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/disk-io.c b/disk-io.c
> index 77eb0a6..1ac7631 100644
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -1476,7 +1476,9 @@ static int check_super(struct btrfs_super_block *sb)
>  		error("invalid bytes_used %llu", btrfs_super_bytes_used(sb));
>  		goto error_out;
>  	}
> -	if (btrfs_super_stripesize(sb) != 4096) {
> +
> +        if ((btrfs_super_stripesize(sb) != 4096)

Just one trivial comment. Tab was converted to some spaces.

Thanks,
Satoru

> +		&& (btrfs_super_stripesize(sb) != btrfs_super_sectorsize(sb))) {
>  		error("invalid stripesize %u", btrfs_super_stripesize(sb));
>  		goto error_out;
>  	}
> diff --git a/mkfs.c b/mkfs.c
> index a3a3c14..697bdc2 100644
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -1482,6 +1482,7 @@ int main(int argc, char **argv)
>  	}
>  
>  	sectorsize = max(sectorsize, (u32)sysconf(_SC_PAGESIZE));
> +	stripesize = sectorsize;
>  	saved_optind = optind;
>  	dev_cnt = argc - optind;
>  	if (dev_cnt == 0)
> 
