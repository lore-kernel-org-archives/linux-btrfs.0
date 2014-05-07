Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8706 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750793AbaEGBrj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 May 2014 21:47:39 -0400
Message-ID: <536990F8.6040608@cn.fujitsu.com>
Date: Wed, 7 May 2014 09:48:40 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <kreijack@inwind.it>, <linux-btrfs@vger.kernel.org>
CC: Anand Jain <Anand.Jain@oracle.com>
Subject: Re: [RFC PATCH 0/2] Kernel space btrfs missing device detection.
References: <1399357993-9254-1-git-send-email-quwenruo@cn.fujitsu.com> <536925A7.4000201@libero.it>
In-Reply-To: <536925A7.4000201@libero.it>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [RFC PATCH 0/2] Kernel space btrfs missing device detection.
From: Goffredo Baroncelli <kreijack@libero.it>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Date: 2014年05月07日 02:10
> Hi,
>
> instead of extending the BTRFS_IOCTL_DEV_INFO ioctl, why do not add a field under /sys/fs/btrfs/<UUID>/ ? Something like /sys/fs/btrfs/<UUID>/missing_device
>
> BR
> G.Baroncelli
I think that is also a good idea. I'll try to add it later.

Thanks
Qu

>
> On 05/06/2014 08:33 AM, Qu Wenruo wrote:
>> Original btrfs will not detection any missing device since there is
>> no notification mechanism for fs layer to detect missing device in
>> block layer.
>>
>> However we don't really need to notify fs layer upon dev remove,
>> probing in dev_info/rm_dev ioctl is good enough since they are the
>> only two ioctls caring about missing device.
>>
>> This patchset will do ioctl time missing dev detection and return
>> device missing status in dev_info ioctl using a new member in
>> btrfs_ioctl_dev_info_args with a backward compatible method.
>>
>> Cc: Anand Jain <Anand.Jain@oracle.com> Qu Wenruo (2): btrfs: Add
>> missing device check in dev_info/rm_dev ioctl btrfs: Add new member
>> of btrfs_ioctl_dev_info_args.
>>
>> fs/btrfs/ioctl.c           |  4 ++++ fs/btrfs/volumes.c         | 25
>> ++++++++++++++++++++++++- fs/btrfs/volumes.h         |  2 ++
>> include/uapi/linux/btrfs.h |  5 ++++- 4 files changed, 34
>> insertions(+), 2 deletions(-)
>>
>

