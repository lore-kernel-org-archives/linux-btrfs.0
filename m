Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27482 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755309AbaGDB5j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 21:57:39 -0400
Message-ID: <53B60A51.5030101@cn.fujitsu.com>
Date: Fri, 4 Jul 2014 09:58:41 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>, Chris Mason <clm@fb.com>
CC: Miao Xie <miaox@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix wrong uevent target
References: <1404291834-11113-1-git-send-email-miaox@cn.fujitsu.com> <53B539CE.7070201@cn.fujitsu.com> <53B56211.4060403@fb.com> <53B5939B.2050808@oracle.com>
In-Reply-To: <53B5939B.2050808@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH] Btrfs: fix wrong uevent target
From: Anand Jain <anand.jain@oracle.com>
To: Chris Mason <clm@fb.com>
Date: 2014年07月04日 01:32
> Chris,
>
>   This fix is theoretically correct but my guess that this would
>   solve problem as reported by Qu Wenruo was wrong [1].
>   Patch is good to integrate.
>
> Thanks, Anand
>
> [1] Re: [PATCH RFC] btrfs: Add ctime/mtime update for btrfs device 
> add/remove.
Yes, whatever uevent improvement will not solve the problem of 'btrfs 
dev scan; btrfs dev del; btrfs dev scan'.
Since uevent event is send from kernel and received by ueventd, then 
ueventd goes to update the device file ctime/mtine.
The uevent procedure is always asynchronized, so it will not fix the 
'btrfs dev scan' libblkid cache problem.

Althogh my RFC patch is ugly, it will provide a synchronzied method to 
update ctime/mtime from kernel.

Thank,
Qu
>
>
> On 03/07/2014 22:00, Chris Mason wrote:
>> On 07/03/2014 07:09 AM, Miao Xie wrote:
>>> CC Anand Jain
>>>
>>> Sorry, please ignore this patch.
>>> Anand wrote the same patch several days ago, so this bug fix belongs 
>>> to Anand
>>> though he NACKed his patch at that time.
>>
>> It certainly looks right, but Anand had mentioned that he had a few
>> questions on testing.  I've pulled it out for now, but I'll take Anand's
>> version when you're both happy.
>>
>> -chris
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

