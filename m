Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47668 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752714AbdKFO0n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 09:26:43 -0500
Date: Mon, 6 Nov 2017 15:24:50 +0100
From: David Sterba <dsterba@suse.cz>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, Josef Bacik <jbacik@fb.com>,
        linux-fsdevel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] btrfs/volumes: Improve unlocking of a mutex in
 __btrfs_balance()
Message-ID: <20171106142450.GF28789@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <d7bcebed-b68f-6137-24df-9332ef1de802@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d7bcebed-b68f-6137-24df-9332ef1de802@users.sourceforge.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 06, 2017 at 09:04:37AM +0100, SF Markus Elfring wrote:
> 
> * Adjust jump targets so that a call of the function "mutex_unlock"
>   can be better reused for error cases at the end of this function.
> 
> * Replace three calls by goto statements.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
> @@ -3682,7 +3678,7 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
>  		counting = false;
>  		goto again;
>  	}
> -error:
> +free_path:
>  	btrfs_free_path(path);
>  	if (enospc_errors) {
>  		btrfs_info(fs_info, "%d enospc errors during balance",
> @@ -3692,6 +3688,10 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
>  	}
>  
>  	return ret;
> +
> +unlock:
> +	mutex_unlock(&fs_info->delete_unused_bgs_mutex);
> +	goto free_path;
>  }

This is also an anti-pattern, the label followed by a goto jumping back
to the exit/cleanup block, right at the end of a function. I've sent
some patches in the past to clean that up and don't want to reintroduce
it.
