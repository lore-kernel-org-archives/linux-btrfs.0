Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57960 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932762AbbA3SgB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Jan 2015 13:36:01 -0500
Date: Fri, 30 Jan 2015 19:35:59 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5 9/9] btrfs: Use sb_want_write() to protect sysfs
 feature change.
Message-ID: <20150130183559.GS3641@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1422609654-19519-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1422609654-19519-10-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1422609654-19519-10-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 30, 2015 at 05:20:54PM +0800, Qu Wenruo wrote:
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -154,9 +154,15 @@ static ssize_t btrfs_feature_attr_store(struct kobject *kobj,
>  	btrfs_info(fs_info, "%s %s feature flag",
>  		   val ? "Setting" : "Clearing", fa->kobj_attr.attr.name);
>  
> +	ret = sb_want_write(fs_info->sb);
> +	if (ret)
> +		return ret;

Same here, move it to the beginning, right after fs_info is validated.

> +
>  	trans = btrfs_start_transaction(fs_info->fs_root, 0);
> -	if (IS_ERR(trans))
> -		return PTR_ERR(trans);
> +	if (IS_ERR(trans)) {
> +		ret = PTR_ERR(trans);
> +		goto out;
> +	}
>  
