Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41322 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726313AbeHBMNB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Aug 2018 08:13:01 -0400
Subject: Re: [PATCH] btrfs: dereferencing error pointer in
 btrfs_quota_enable()
To: Dan Carpenter <dan.carpenter@oracle.com>, Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20180802084428.k2uemow7k6j3us47@kili.mountain>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <2d11e8b5-5e6f-42d2-3351-3d31f53ece1b@suse.com>
Date: Thu, 2 Aug 2018 13:22:27 +0300
MIME-Version: 1.0
In-Reply-To: <20180802084428.k2uemow7k6j3us47@kili.mountain>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  2.08.2018 11:44, Dan Carpenter wrote:
> The error handling in "goto out;" expects that if "trans" is non-NULL
> that means it's valid.  Unfortunately it could also be an error pointer.
> 
> Fixes: c9a6fe84fe43 ("btrfs: qgroups: Move transaction management inside btrfs_quota_enable/disable")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>


Good catch !

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 3a9019928329..380ff978defa 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -904,6 +904,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info)
>  	trans = btrfs_start_transaction(tree_root, 2);
>  	if (IS_ERR(trans)) {
>  		ret = PTR_ERR(trans);
> +		trans = NULL;
>  		goto out;
>  	}
>  
> 
