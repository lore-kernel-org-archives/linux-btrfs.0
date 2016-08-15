Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24149 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbcHON5D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Aug 2016 09:57:03 -0400
Subject: Re: About minimal device number for RAID5/6
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, btrfs <linux-btrfs@vger.kernel.org>
References: <d87a7caa-d414-1dbc-7c7e-a051e382114a@cn.fujitsu.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <0bd5e1f1-40bc-95c8-0d7a-ceba5487850c@oracle.com>
Date: Mon, 15 Aug 2016 21:58:19 +0800
MIME-Version: 1.0
In-Reply-To: <d87a7caa-d414-1dbc-7c7e-a051e382114a@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Have a look at this..

http://www.spinics.net/lists/linux-btrfs/msg54779.html

----------
RAID5&6 devs_min values are in the context of degraded volume.
RAID1&10.. devs_min values are in the context of healthy volume.

RAID56 is correct. We already have devs_max to know the number
of devices in a healthy volumes. RAID1's devs_min is wrong so
it ended up being same as devs_max.
----------

Any comments?
Also you may use the btrfs-raid-cal simulator tool to verify.
https://github.com/asj/btrfs-raid-cal/blob/master/state-table


Thanks, Anand



On 08/15/2016 03:50 PM, Qu Wenruo wrote:
> Hi,
>
> Recently I found that manpage of mkfs is saying minimal device number
> for RAID5 and RAID6 is 2 and 3.
>
> Personally speaking, although I understand that RAID5/6 only requires
> 1/2 devices for parity stripe, it is still quite strange behavior.
>
> Under most case, user use raid5/6 for striping AND parity. For 2 devices
> RAID5, it's just a more expensive RAID1.
>
> IMHO it's better to warn user about 2 devices RAID5 or 3 devices RAID6.
>
> Any comment is welcomed.
>
> Thanks,
> Qu
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
