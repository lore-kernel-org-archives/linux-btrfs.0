Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:60073 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbcENKmd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 May 2016 06:42:33 -0400
Subject: Re: [PATCH 1/7] Btrfs: replace BUG() with WARN_ONCE in raid56
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
References: <1463184422-13584-1-git-send-email-bo.li.liu@oracle.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <33302071-6932-471f-2c1f-b923c1420347@gmx.com>
Date: Sat, 14 May 2016 18:42:22 +0800
MIME-Version: 1.0
In-Reply-To: <1463184422-13584-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=gbk; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/14/2016 08:06 AM, Liu Bo wrote:
> This BUG() has been triggered by a fuzz testing image, but in fact
> btrfs can handle this gracefully by returning -EIO.
>
> Thus, use WARN_ONCE for warning purpose and don't leave a possible
> kernel panic.
>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/raid56.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index 0b7792e..863f7fe 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -2139,7 +2139,7 @@ int raid56_parity_recover(struct btrfs_root *root, struct bio *bio,
>
>  	rbio->faila = find_logical_bio_stripe(rbio, bio);
>  	if (rbio->faila == -1) {
> -		BUG();
> +		WARN_ONCE(1, KERN_WARNING "rbio->faila is -1\n");

Just a personal idea, it would be much better if we can use 
btrfs_info/error/warn() to output the warning message.
This would help to locate the fs causing the problem, if there are 
several btrfs mounted.

Like:
        btrfs_warn(root->fs_info, "rbio->faia is -1");
        WARN_ON(1);

Or adds a new helper like btrfs_dump_warn()?

Thanks,
Qu

>  		if (generic_io)
>  			btrfs_put_bbio(bbio);
>  		kfree(rbio);
>
