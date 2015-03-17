Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35672 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbbCQHNK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Mar 2015 03:13:10 -0400
Received: by pabyw6 with SMTP id yw6so1460412pab.2
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2015 00:13:10 -0700 (PDT)
Date: Tue, 17 Mar 2015 00:13:07 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2] Btrfs: Remove the check for old-style mkfs
Message-ID: <20150317071307.GA17951@mew>
References: <20150316162534.GO20767@twin.jikos.cz>
 <1426574056-2978-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1426574056-2978-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 17, 2015 at 02:34:16PM +0800, Liu Bo wrote:
> This was used to make sure that a fresh btrfs from an older mkfs.btrfs,
> but it also allows us to mount a buggy btrfs if this btrfs has the right
> superblock head part but has something wrong with chunk tree part[1], and
> after that we can hit BUG_ON()s set in the code to prevent something
> impossible.
> 
> Since David has released "Btrfs progs v3.19-rc2", just remove the check,
> if anyone who wants to make a fresh btrfs, please use the latest one.
> 
> [1]: http://www.spinics.net/lists/linux-btrfs/msg42358.html
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

# mount -o loop btrfs.img /mnt/test
# dmesg | tail
[   28.582698] BTRFS: device fsid 1c0ed5d6-550d-4010-b1b4-ce1828270713 devid 1 transid 4 /dev/loop0
[   28.598365] BTRFS: superblock checksum mismatch
[   28.617205] BTRFS: open_ctree failed

Looks good to me.

Reviewed-by: Omar Sandoval <osandov@osandov.com>

> ---
> v2: Refine the patch subject.
> 
>  fs/btrfs/disk-io.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 41b320e..f63aacf 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -418,12 +418,6 @@ static int btrfs_check_super_csum(char *raw_disk_sb)
>  
>  		if (memcmp(raw_disk_sb, result, csum_size))
>  			ret = 1;
> -
> -		if (ret && btrfs_super_generation(disk_sb) < 10) {
> -			printk(KERN_WARNING
> -				"BTRFS: super block crcs don't match, older mkfs detected\n");
> -			ret = 0;
> -		}
>  	}
>  
>  	if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes)) {
> -- 
> 1.8.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Omar
