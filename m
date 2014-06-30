Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:47823 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753407AbaF3B4h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Jun 2014 21:56:37 -0400
Message-ID: <53B0C412.1030207@cn.fujitsu.com>
Date: Mon, 30 Jun 2014 09:57:38 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Roman Mamedov <rm@romanrm.net>
Subject: Re: [PATCH] btrfs: fix nossd and ssd_spread mount option regression
References: <53ADE727.5000400@redhat.com>
In-Reply-To: <53ADE727.5000400@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Oh, my bad, sorry for the SSD related mount options mess.

Thanks for the patch fixing the bug, comments inlined below.
-------- Original Message --------
Subject: [PATCH] btrfs: fix nossd and ssd_spread mount option regression
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Date: 2014年06月28日 05:50
> The commit
>
> 0780253 btrfs: Cleanup the btrfs_parse_options for remount.
>
> broke ssd options quite badly; it stopped making ssd_spread
> imply ssd, and it made "nossd" unsettable.
>
> Put things back at least as well as they were before
> (though ssd mount option handling is still pretty odd:
> # mount -o "nossd,ssd_spread" works?)
>
> Reported-by: Roman Mamedov <rm@romanrm.net>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>
> I've tested this insofar as I was actually able to mount with
> nossd,and see it reflected in /proc/mounts.
>
> If SSD_SPREAD is set, show_options() won't show you the ssd
> option, so that's not totally obvious.  Still, this is what
> the code did before the regression.
>
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 4662d92..0e8edcc 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -522,9 +522,10 @@ int btrfs_parse_options(struct btrfs_root *root, char *options)
>   		case Opt_ssd_spread:
>   			btrfs_set_and_info(root, SSD_SPREAD,
>   					   "use spread ssd allocation scheme");
> +			btrfs_set_opt(info->mount_opt, SSD);
>   			break;
>   		case Opt_nossd:
> -			btrfs_clear_and_info(root, NOSSD,
> +			btrfs_set_and_info(root, NOSSD,
>   					     "not using ssd allocation scheme");
>   			btrfs_clear_opt(info->mount_opt, SSD);
Since ssd_spread implies ssd, so nossd should also clear ssd_spread.
So btrfs_clear_opt(info->mount_opt, SSD_SPREAD) is also needed.

Thanks,
Qu
>   			break;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


