Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25549 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751319AbaBFUW2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Feb 2014 15:22:28 -0500
Message-ID: <52F3EED4.7030603@fb.com>
Date: Thu, 6 Feb 2014 15:21:40 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.net>, <linux-btrfs@vger.kernel.org>
Subject: Re: Provide a better free space estimate on RAID1
References: <20140206021516.304732cd@natsu>
In-Reply-To: <20140206021516.304732cd@natsu>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 02/05/2014 03:15 PM, Roman Mamedov wrote:
> Hello,
>
> On a freshly-created RAID1 filesystem of two 1TB disks:
>
> # df -h /mnt/p2/
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/sda2       1.8T  1.1M  1.8T   1% /mnt/p2
>
> I cannot write 2TB of user data to that RAID1, so this estimate is clearly
> misleading. I got tired of looking at the bogus disk free space on all my
> RAID1 btrfs systems, so today I decided to do something about this:
>
> --- fs/btrfs/super.c.orig	2014-02-06 01:28:36.636164982 +0600
> +++ fs/btrfs/super.c	2014-02-06 01:28:58.304164370 +0600
> @@ -1481,6 +1481,11 @@
>   	}
>   
>   	kfree(devices_info);
> +
> +	if (type & BTRFS_BLOCK_GROUP_RAID1) {
> +		do_div(avail_space, min_stripes);
> +	}
> +
>   	*free_bytes = avail_space;
>   	return 0;
>   }

This needs to be more flexible, and also this causes the problem where 
now you show the actual usable amount of space _but_ you are also 
showing twice the amount of used space.  I'm ok with going in this 
direction, but we need to convert everybody over so it works for raid10 
as well and the used values need to be adjusted.  Thanks,

Josef
