Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32848 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751053AbdE2PZ2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 May 2017 11:25:28 -0400
Date: Mon, 29 May 2017 17:24:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs: check namelen with boundary in verify dir_item
Message-ID: <20170529152424.GM14523@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170525020908.25830-1-suy.fnst@cn.fujitsu.com>
 <20170525020908.25830-2-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170525020908.25830-2-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 25, 2017 at 10:09:07AM +0800, Su Yue wrote:
> @@ -472,6 +474,15 @@ int verify_dir_item(struct btrfs_fs_info *fs_info,
>  		return 1;
>  	}
>  
> +	namelen = btrfs_dir_name_len(leaf, dir_item);
> +	namelen_ret = btrfs_check_namelen(leaf, slot,
> +			(unsigned long)(dir_item + 1), namelen);
> +	if (namelen_ret != namelen) {
> +		btrfs_crit(fs_info, "invalid dir item name len: %u",
> +		       (unsigned)btrfs_dir_name_len(leaf, dir_item));
> +		return 1;
> +	}

Extending verify_dir_item is ok, as we always have the slot parameter to
pass, no problem here.
