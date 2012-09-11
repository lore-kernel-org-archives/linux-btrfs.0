Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:57547 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930Ab2IKFNe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Sep 2012 01:13:34 -0400
Message-ID: <504EC8BA.7010706@libero.it>
Date: Tue, 11 Sep 2012 07:14:34 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Wang Sheng-Hui <shhuiw@gmail.com>
CC: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, cwillu <cwillu@cwillu.com>,
        Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH] btrfs: fix disk-io.c/btrfs_read_dev_super with BTRFS_SUPER_MIRROR_MAX
 to control the loops
References: <504D8AEB.9090401@gmail.com>
In-Reply-To: <504D8AEB.9090401@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 09/10/2012 08:38 AM, Wang Sheng-Hui wrote:
> To check the duplicated super blocks, use BTRFS_SUPER_MIRROR_MAX
> as the loops limit.
>
> Signed-off-by: Wang Sheng-Hui<shhuiw@gmail.com>
> ---
>   fs/btrfs/disk-io.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 22e98e0..a431144 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2723,7 +2723,7 @@ struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
>   	 * So, we need to add a special mount option to scan for
>   	 * later supers, using BTRFS_SUPER_MIRROR_MAX instead
>   	 */
> -	for (i = 0; i<  1; i++) {
> +	for (i = 0; i<  BTRFS_SUPER_MIRROR_MAX; i++) {
>   		bytenr = btrfs_sb_offset(i);
>   		if (bytenr + 4096>= i_size_read(bdev->bd_inode))
>   			break;


Pay attention that when a device is removed from a filesystem by the 
command "btrfs device delete", *only* the 1st superblock btrfs signature 
is zeroed [1]. This means that the other (backup) superblocks will be 
considered valid with your change.



[1] See the function btrfs_rm_device() in volume.c




