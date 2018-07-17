Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:39681 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729673AbeGQPG2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 11:06:28 -0400
Subject: Re: [PATCH] btrfs: fix size_t format string
To: Arnd Bergmann <arnd@arndb.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, Nikolay Borisov <nborisov@suse.com>,
        Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20180717135236.3673195-1-arnd@arndb.de>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <dbbb1882-65bf-dda9-eb26-a6217b240def@gmx.com>
Date: Tue, 17 Jul 2018 22:33:07 +0800
MIME-Version: 1.0
In-Reply-To: <20180717135236.3673195-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年07月17日 21:52, Arnd Bergmann wrote:
> The newly added check_block_group_item() function causes a build warning
> on 32-bit architectures:
> 
> fs/btrfs/tree-checker.c: In function 'check_block_group_item':
> fs/btrfs/tree-checker.c:404:41: error: format '%lu' expects argument of type 'long unsigned int', but argument 6 has type 'unsigned int' [-Werror=format=]
> 
> The type of a sizeof() expression is size_t, which is correctly printed
> using the %zu format string.
> 
> Fixes: 9dc16aad5660 ("btrfs: tree-checker: Verify block_group_item")

My fault again. :(

Is there anyway to make gcc report such problem even under x86_64?

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/tree-checker.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index e9414c3f375e..4c82a628df85 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -401,7 +401,7 @@ static int check_block_group_item(struct btrfs_fs_info *fs_info,
>  
>  	if (item_size != sizeof(bgi)) {
>  		block_group_err(fs_info, leaf, slot,
> -			"invalid item size, have %u expect %lu",
> +			"invalid item size, have %u expect %zu",
>  				item_size, sizeof(bgi));
>  		return -EUCLEAN;
>  	}
> 
