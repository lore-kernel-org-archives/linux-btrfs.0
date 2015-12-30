Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36859 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754818AbbL3VIl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Dec 2015 16:08:41 -0500
Date: Wed, 30 Dec 2015 16:08:32 -0500
From: Chris Mason <clm@fb.com>
To: Nicholas Krause <xerofoify@gmail.com>
CC: <jbacik@fb.com>, <dsterba@suse.com>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND 2/2] btrfs:Fix error handling in the function
 btrfs_dev_replace_kthread
Message-ID: <20151230210832.vzhwzngdaicadtpu@ret.masoncoding.com>
References: <1451437807-23173-1-git-send-email-xerofoify@gmail.com>
 <1451437807-23173-2-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1451437807-23173-2-git-send-email-xerofoify@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 29, 2015 at 08:10:07PM -0500, Nicholas Krause wrote:
> This fixes error handling in the function btrfs_dev_replace_kthread
> by checking if the call to the function btrfs_dev_replace_continue_on_mount
> has failed and if so return the error code to this function's caller in
> order to signal a failure has occurred when calling this particular
> function.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  fs/btrfs/dev-replace.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index 38ffd73..b26f68c 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -803,6 +803,7 @@ static int btrfs_dev_replace_kthread(void *data)
>  	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
>  	struct btrfs_ioctl_dev_replace_args *status_args;
>  	u64 progress;
> +	int ret;
>  
>  	status_args = kzalloc(sizeof(*status_args), GFP_NOFS);
>  	if (status_args) {
> @@ -820,7 +821,9 @@ static int btrfs_dev_replace_kthread(void *data)
>  			"<missing target disk>",
>  			(unsigned int)progress);
>  	}
> -	btrfs_dev_replace_continue_on_mount(fs_info);
> +	ret = btrfs_dev_replace_continue_on_mount(fs_info);
> +	if (ret)
> +		return ret;
>  	atomic_set(&fs_info->mutually_exclusive_operation_running, 0);

This atomic_set that you're skipping is really important.

-chris
