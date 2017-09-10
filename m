Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:52887 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751413AbdIJL5G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Sep 2017 07:57:06 -0400
Subject: Re: [PATCH] btrfs: tests: Fix a memory leak in error handling path in
 'run_test()'
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, clm@fb.com,
        jbacik@fb.com, dsterba@suse.com, nborisov@suse.com, jeffm@suse.com,
        osandov@fb.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20170910111938.15201-1-christophe.jaillet@wanadoo.fr>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <72f72ca7-8c48-5501-7835-ac619801cd34@gmx.com>
Date: Sun, 10 Sep 2017 19:56:17 +0800
MIME-Version: 1.0
In-Reply-To: <20170910111938.15201-1-christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月10日 19:19, Christophe JAILLET wrote:
> If 'btrfs_alloc_path()' fails, we must free the resourses already
> allocated, as done in the other error handling paths in this function.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: Qu Wenruo <quwenruo.btrfs@gmx.com>

BTW, I also checked all btrfs_alloc_path() in self tests, not such leak 
remaining.

Thanks,
Qu
> ---
>   fs/btrfs/tests/free-space-tree-tests.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/tests/free-space-tree-tests.c b/fs/btrfs/tests/free-space-tree-tests.c
> index 1458bb0ea124..8444a018cca2 100644
> --- a/fs/btrfs/tests/free-space-tree-tests.c
> +++ b/fs/btrfs/tests/free-space-tree-tests.c
> @@ -500,7 +500,8 @@ static int run_test(test_func_t test_func, int bitmaps, u32 sectorsize,
>   	path = btrfs_alloc_path();
>   	if (!path) {
>   		test_msg("Couldn't allocate path\n");
> -		return -ENOMEM;
> +		ret = -ENOMEM;
> +		goto out;
>   	}
>   
>   	ret = add_block_group_free_space(&trans, root->fs_info, cache);
> 
