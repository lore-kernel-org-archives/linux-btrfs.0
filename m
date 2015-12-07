Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:59355 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755643AbbLGXwP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Dec 2015 18:52:15 -0500
Subject: Re: [PATCH] btrfs: Introduce new mount option to disable tree log
 replay
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <1449468402-27914-1-git-send-email-quwenruo@cn.fujitsu.com>
 <8056366.2GdjmACnsD@localhost.localdomain>
Cc: linux-btrfs@vger.kernel.org
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <56661B9B.9090607@gmx.com>
Date: Tue, 8 Dec 2015 07:51:55 +0800
MIME-Version: 1.0
In-Reply-To: <8056366.2GdjmACnsD@localhost.localdomain>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/07/2015 11:38 PM, Chandan Rajendra wrote:
> On Monday 07 Dec 2015 14:06:42 Qu Wenruo wrote:
>> Introduce a new mount option "nologreplay" to co-operate with "ro" mount
>> option to get real readonly mount, like "norecovery" in ext* and xfs.
>>
>> Since the new parse_options() need to check new flags at remount time,
>> so add a new parameter for parse_options().
>>
>
> Hello Qu,
> The patch should add an entry into btrfs_show_options() for 'mount' command to
> be able to display an entry corresponding to 'nologreplay' mount option.

Thanks for the advice.
I just forgot show_mount_options().

And for option to disable "nologreplay", I follow the behavior of xfs 
and ext4 "norecovery" behavior.
Which means no option to disable "norecovery", as it is only used for 
debugging case.
So the only method is to umount it and mount it again.

>
> Even after adding such an entry to btrfs_show_options(),
> the following occurs,
> # mount -o nologreplay,ro /dev/loop6 /mnt/
> # mount | grep loop6
> /dev/loop6 on /mnt type btrfs (ro,relatime,seclabel,nologreplay,space_cache,subvolid=5,subvol=/)
> # mount -o remount,rw /dev/loop6 /mnt/
> # mount | grep loop6
> /dev/loop6 on /mnt type btrfs (rw,relatime,seclabel,nologreplay,space_cache,subvolid=5,subvol=/)
>
> As can be seen from the last line, both 'rw' and 'nologreplay' options are set.
>

I'll double check it, maybe it bypassed btrfs_parse_options(), and 
bypassed the check in it.

Thanks,
Qu
