Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38574 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725942AbeIGL3T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 07:29:19 -0400
Subject: Re: [PATCH 34/35] btrfs: wait on ordered extents on abort cleanup
To: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-35-josef@toxicpanda.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <a86ef70f-116d-5607-661a-783691ae1b7b@suse.com>
Date: Fri, 7 Sep 2018 09:49:49 +0300
MIME-Version: 1.0
In-Reply-To: <20180830174225.2200-35-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 30.08.2018 20:42, Josef Bacik wrote:
> If we flip read-only before we initiate writeback on all dirty pages for
> ordered extents we've created then we'll have ordered extents left over
> on umount, which results in all sorts of bad things happening.  Fix this
> by making sure we wait on ordered extents if we have to do the aborted
> transaction cleanup stuff.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/disk-io.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 54fbdc944a3f..51b2a5bf25e5 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -4188,6 +4188,14 @@ static void btrfs_destroy_all_ordered_extents(struct btrfs_fs_info *fs_info)
>  		spin_lock(&fs_info->ordered_root_lock);
>  	}
>  	spin_unlock(&fs_info->ordered_root_lock);
> +
> +	/*
> +	 * We need this here because if we've been flipped read-only we won't
> +	 * get sync() from the umount, so we need to make sure any ordered
> +	 * extents that haven't had their dirty pages IO start writeout yet
> +	 * actually get run and error out properly.
> +	 */
> +	btrfs_wait_ordered_roots(fs_info, U64_MAX, 0, (u64)-1);
>  }
>  
>  static int btrfs_destroy_delayed_refs(struct btrfs_transaction *trans,
> 
