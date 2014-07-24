Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49431 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757460AbaGXNTu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 09:19:50 -0400
Date: Thu, 24 Jul 2014 15:19:45 +0200
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 02/10] Btrfs: don't write any data into a readonly device
 when scrub
Message-ID: <20140724131945.GA1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1406173035-29478-1-git-send-email-miaox@cn.fujitsu.com>
 <1406173035-29478-2-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1406173035-29478-2-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 24, 2014 at 11:37:07AM +0800, Miao Xie wrote:
> We should not write data into a readonly device especially seed device when
> doing scrub, skip those devices.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.cz>

One minor comment below.

> @@ -2904,6 +2904,7 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
>  	struct scrub_ctx *sctx;
>  	int ret;
>  	struct btrfs_device *dev;
> +	struct rcu_string *name;
>  
> +	if (!is_dev_replace && !readonly && !dev->writeable) {

You can define 'name' within the block.

> +		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
> +		rcu_read_lock();
> +		name = rcu_dereference(dev->name);
> +		btrfs_err(fs_info, "scrub: device %s is not writable",
> +			  name->str);
> +		rcu_read_unlock();
> +		return -EROFS;
> +	}
