Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55338 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751451AbdC0QsL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 12:48:11 -0400
Date: Mon, 27 Mar 2017 18:47:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, bo.li.liu@oracle.com
Subject: Re: [PATCH v2 2/5] btrfs: scrub: Fix RAID56 recovery race condition
Message-ID: <20170327164727.GJ4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170324020027.21228-1-quwenruo@cn.fujitsu.com>
 <20170324020027.21228-3-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170324020027.21228-3-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 24, 2017 at 10:00:24AM +0800, Qu Wenruo wrote:
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -1065,6 +1065,7 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
>  	unsigned int have_csum;
>  	struct scrub_block *sblocks_for_recheck; /* holds one for each mirror */
>  	struct scrub_block *sblock_bad;
> +	int lock_ret;

No need to introduce another variable, just use 'ret'.

>  	int ret;
>  	int mirror_index;
>  	int page_num;
> @@ -1428,6 +1440,9 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
>  		kfree(sblocks_for_recheck);
>  	}
>  
> +	lock_ret = unlock_full_stripe(fs_info, logical);
> +	if (lock_ret < 0)
> +		return lock_ret;
>  	return 0;

Here.
