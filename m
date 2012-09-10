Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:41764 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319Ab2IJQO5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Sep 2012 12:14:57 -0400
Date: Mon, 10 Sep 2012 12:14:54 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Wang Sheng-Hui <shhuiw@gmail.com>
CC: "Chris L. Mason" <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] btrfs: fix disk-io.c/btrfs_read_dev_super with
 BTRFS_SUPER_MIRROR_MAX to control the loops
Message-ID: <20120910161454.GA2270@localhost.localdomain>
References: <504D8AEB.9090401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <504D8AEB.9090401@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 10, 2012 at 12:38:35AM -0600, Wang Sheng-Hui wrote:
> To check the duplicated super blocks, use BTRFS_SUPER_MIRROR_MAX
> as the loops limit.
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>  fs/btrfs/disk-io.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 22e98e0..a431144 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2723,7 +2723,7 @@ struct buffer_head *btrfs_read_dev_super(struct block_device *bdev)
>  	 * So, we need to add a special mount option to scan for
>  	 * later supers, using BTRFS_SUPER_MIRROR_MAX instead
>  	 */
> -	for (i = 0; i < 1; i++) {
> +	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
>  		bytenr = btrfs_sb_offset(i);
>  		if (bytenr + 4096 >= i_size_read(bdev->bd_inode))
>  			break;

We don't want to do this, it should be left for -o recovery or some such mount
option.  Thanks,

Josef
