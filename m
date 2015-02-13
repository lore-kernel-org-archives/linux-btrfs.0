Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754AbbBMPsq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Feb 2015 10:48:46 -0500
Date: Fri, 13 Feb 2015 16:48:44 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 9/9] btrfs: Use sb_want_write() to protect sysfs feature
 change.
Message-ID: <20150213154844.GI8720@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1423705473-8597-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1423705473-8597-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 12, 2015 at 09:44:33AM +0800, Qu Wenruo wrote:
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -118,13 +118,19 @@ static ssize_t btrfs_feature_attr_store(struct kobject *kobj,
>  	int ret;
>  
>  	fs_info = to_fs_info(kobj);
> -	if (!fs_info)
> -		return -EPERM;
> +	if (!fs_info) {
> +		ret = -EPERM;
> +		goto out;

This would do a call to sb_drop_write() without a pairing
sb_want_write(), immediate 'return' was correct.

[...]
> +	}
>  
> -	ret = kstrtoul(skip_spaces(buf), 0, &val);
> +	ret = sb_want_write(fs_info->sb);
>  	if (ret)
>  		return ret;
[...]
>  
> +out:
> +	sb_drop_write(fs_info->sb);
> +	if (!ret)
> +		return count;
> +	return ret;
