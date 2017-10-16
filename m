Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18475 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751750AbdJPGqv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 02:46:51 -0400
Subject: Re: [PATCH v2 3/3] btrfs-progs: device: add remove missing-all
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Cc: Duncan <1i5t5.duncan@cox.net>
References: <bb58e829-77d4-1bd1-4021-2db996809a6e@jp.fujitsu.com>
 <be3e6086-5a2f-77d0-5dbc-dcb5a1a57815@jp.fujitsu.com>
 <pan$48dd8$f51614da$34e59787$eb10b745@cox.net>
 <d311a713-a663-a11d-7cdb-bb9d359c4ba5@oracle.com>
 <649452a3-908d-670d-8bfd-b0e248b32b32@jp.fujitsu.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <bf44fc1a-4a33-5dc7-1d11-5c987643552d@oracle.com>
Date: Mon, 16 Oct 2017 14:46:37 +0800
MIME-Version: 1.0
In-Reply-To: <649452a3-908d-670d-8bfd-b0e248b32b32@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/16/2017 12:35 PM, Misono, Tomohiro wrote:
> 
> 
> On 2017/10/16 12:30, Anand Jain wrote:
>>
>>
>> On 10/13/2017 01:27 PM, Duncan wrote:
>>> Misono, Tomohiro posted on Wed, 11 Oct 2017 11:18:50 +0900 as excerpted:
>>>
>>>> Add 'btrfs remove missing-all' to remove all the missing devices at once
>>>> for improving usability.
>>>>
>>>> Example:
>>>>    sudo mkfs.btrfs -f -d raid1 /dev/sdb1 /dev/sdb2 /dev/sdb3 /dev/sdb4
>>>>    sudo wipefs -a /dev/sdb1 /dev/sdb3
>>>>    sudo mount -o degraded /dev/sdb2 /mnt <--
>>
>>
>>     I agree with Duncan here. This step itself will fail even with RO
>>     option.

  Correction. RO mount is possible based on which disk you choose to mount.

Thanks - Anand


>> Do you have any patch that is not in the ML which will
>>     make this step a success in the first place ?
>>
>> Thanks, Anand
>>
> 
> commit 21634a19f646 ("btrfs: Introduce a function to check if all chunks a OK
> for degraded rw mount") allow this from 4.14 (I checked on 4.14-rc4).
> But I will withdraw this patch as Duncan suggests.
> 
> Thanks,
> Tomohiro
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
