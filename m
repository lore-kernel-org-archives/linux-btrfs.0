Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-34-i6.italiaonline.it ([212.48.14.168]:39021 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751185AbdIPL6h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Sep 2017 07:58:37 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH] Btrfs: fix unexpected result when dio reading corrupted
 blocks
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
References: <20170915210651.8385-1-bo.li.liu@oracle.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <56ce21c9-406d-7cfe-f162-f21454ba3b2a@inwind.it>
Date: Sat, 16 Sep 2017 13:58:34 +0200
MIME-Version: 1.0
In-Reply-To: <20170915210651.8385-1-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/15/2017 11:06 PM, Liu Bo wrote:
> commit 4246a0b63bd8 ("block: add a bi_error field to struct bio")
> changed the logic of how dio read endio reports errors.
> 
> For single stripe dio read, %bio->bi_status reflects the error before
> verifying checksum, and now we're updating it when data block matches
> with its checksum, while in the mismatching case, %bio->bi_status is
> not updated to relfect that.
> 
> When some blocks in a file have been corrupted on disk, reading such a
> file ends up with
> 
> 1) checksum errros are reported in kernel log
> 2) read(2) returns successfully with some content being 0x01.
> 
> In order to fix it, we need to report its checksum mismatch error to
> the upper layer (dio layer in this case) as well.

I tested it, and now it works: even using O_DIRECT -EIO is returned if the file is corrupted.

ghigo@venice:~/btrfs/crash-o-direct/t$ ls -li
total 16384
257 -rw-r--r-- 1 root root 16777216 Sep 15 20:51 abcd
ghigo@venice:~/btrfs/crash-o-direct/t$ date
Sat Sep 16 13:56:26 CEST 2017

ghigo@venice:~/btrfs/crash-o-direct/t$ cat abcd 
cat: abcd: Input/output error
ghigo@venice:~/btrfs/crash-o-direct/t$ dmesg -T | tail -1
[Sat Sep 16 13:56:29 2017] BTRFS warning (device sdd5): csum failed root 5 ino 257 off 0 csum 0x98f94189 expected csum 0x0ab6be80 mirror 1

ghigo@venice:~/btrfs/crash-o-direct/t$ dd if=abcd iflag=direct
dd: error reading 'abcd': Input/output error
0+0 records in
0+0 records out
0 bytes copied, 0.000404156 s, 0.0 kB/s
ghigo@venice:~/btrfs/crash-o-direct/t$ dmesg -T | tail -1
[Sat Sep 16 13:56:41 2017] BTRFS warning (device sdd5): csum failed root 5 ino 257 off 0 csum 0x98f94189 expected csum 0x0ab6be80 mirror 1




> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> Reported-by: Goffredo Baroncelli <kreijack@inwind.it>
> cc: Goffredo Baroncelli <kreijack@inwind.it>
> ---
>  fs/btrfs/inode.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 24bcd5c..a46799e 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -8267,11 +8267,8 @@ static void btrfs_endio_direct_read(struct bio *bio)
>  	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
>  	blk_status_t err = bio->bi_status;
>  
> -	if (dip->flags & BTRFS_DIO_ORIG_BIO_SUBMITTED) {
> +	if (dip->flags & BTRFS_DIO_ORIG_BIO_SUBMITTED)
>  		err = btrfs_subio_endio_read(inode, io_bio, err);
> -		if (!err)
> -			bio->bi_status = 0;
> -	}
>  
>  	unlock_extent(&BTRFS_I(inode)->io_tree, dip->logical_offset,
>  		      dip->logical_offset + dip->bytes - 1);
> @@ -8279,7 +8276,7 @@ static void btrfs_endio_direct_read(struct bio *bio)
>  
>  	kfree(dip);
>  
> -	dio_bio->bi_status = bio->bi_status;
> +	dio_bio->bi_status = err;
>  	dio_end_io(dio_bio);
>  
>  	if (io_bio->end_io)
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
