Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49186 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753886AbaFWOMQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jun 2014 10:12:16 -0400
Date: Mon, 23 Jun 2014 16:12:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/4] btrfs-progs: deal with invalid option combinations
 for btrfs-image
Message-ID: <20140623141214.GF1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1403142363-29482-1-git-send-email-guihc.fnst@cn.fujitsu.com>
 <1403142363-29482-2-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1403142363-29482-2-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 19, 2014 at 09:46:01AM +0800, Gui Hecheng wrote:
> For btrfs-image,
> 	dump 	may not come with option '-o'
> 	-r	may not come with option '-c', '-s', '-w', dev_cnt != 1
> 	-m	may not come with dev_cnt < 2
> All of the above should be regarded as invalid combinations,
> and the usage will show up.

The generic usage works, but is not very descriptive what really
happened. Would be good to print a message as soon as an error is
detectd. See below:

> @@ -2500,15 +2501,20 @@ int main(int argc, char *argv[])
>  		}
>  	}
>  
> -	if ((old_restore) && create)
> -		print_usage();

In this case the old code makes more sense followed by the message that
create and restore cannot be used at the same time.

> -	if (multi_devices && dev_cnt < 2)
> -		print_usage();

Applies to both modes, eg. "not enoug devices specified for -m option".

> -	if (!multi_devices && dev_cnt != 1)
> +	if (create) {
> +		usage_error = old_restore;
> +	} else {
> +		usage_error = walk_trees || sanitize || compress_level;

Error message here if usage_error is set.

> +		if (multi_devices)
> +			usage_error = usage_error || (dev_cnt < 2);
> +		else
> +			usage_error = usage_error || (dev_cnt != 1);

Could be merged with the multi_devices check above, accepts only one
without -m option.
