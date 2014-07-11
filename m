Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27136 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751677AbaGKFYN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Jul 2014 01:24:13 -0400
Message-ID: <53BF74ED.5010407@cn.fujitsu.com>
Date: Fri, 11 Jul 2014 13:23:57 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Zhe Zhang <zhe.zhang.research@gmail.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [Question] disk_bytenr with multiple devices
References: <CAMXuLLoeHPkX+Ym9a-HjVv=5ccqx9wo9tkbMLsySmgC=YJxgZQ@mail.gmail.com>
In-Reply-To: <CAMXuLLoeHPkX+Ym9a-HjVv=5ccqx9wo9tkbMLsySmgC=YJxgZQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: [Question] disk_bytenr with multiple devices
From: Zhe Zhang <zhe.zhang.research@gmail.com>
To: linux-btrfs@vger.kernel.org
Date: 2014年07月11日 02:21
> When a btrfs has multiple devices (e.g. /dev/sdb, /dev/sdc), how
> should I interpret disk_bytenr in btrfs_file_extent_item?
>
> Does it depend on the striping config? Say I used raid0, then
> disk_bytenr 0~64K will be on /dev/sdb, and 64K~128K on /dev/sdc?
>
> Thanks,
> Zhe
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
https://btrfs.wiki.kernel.org/index.php/Data_Structures#btrfs_file_extent_item
As you can see in the btrfs wiki,
disk_bytenr is *logical* address in btrfs linear space. Not really on 
disk address.

If you really want the address on device, you need to find the chunk 
containing the address,
then the stripe in chunk item will show the raid profile and device 
address on each device.

Thanks,
Qu
