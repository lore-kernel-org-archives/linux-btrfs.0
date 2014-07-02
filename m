Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57337 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751306AbaGBDEN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jul 2014 23:04:13 -0400
Message-ID: <53B375A8.9000802@cn.fujitsu.com>
Date: Wed, 2 Jul 2014 10:59:52 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>
CC: <linux-btrfs@vger.kernel.org>, <quwenruo@cn.fujitsu.com>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 1/2 v3 RESEND] Btrfs: device_list_add() should not update
 list when mounted
References: <1402633581-19265-1-git-send-email-Anand.Jain@oracle.com> <53B26066.1060505@cn.fujitsu.com> <53B2E27D.2030609@oracle.com>
In-Reply-To: <53B2E27D.2030609@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/02/2014 12:31 AM, Anand Jain wrote:
>
>
> Thanks for the commenting Wang.
> inline below.
>
>
> On 01/07/2014 15:16, Wang Shilong wrote:
>> Hi Anand,
>>
>> Sorry for delay reply, more comments below:
>>
>> On 06/13/2014 12:26 PM, Anand Jain wrote:
>>> From: Anand Jain <anand.jain@oracle.com>
>>>
[...]
>> I agree we don't allow to update device list when mounted, i tested this
>> patch, it worked but
>
> Thanks for testing this patch set.
>
>> it will output the following message:
>>
>> Scanning for Btrfs filesystems in '/dev/sdc'
>> ERROR: unable to scan the device '/dev/sdc' - Device or resource busy
>>
>> I think this is a little confusing for common users. Maybe don't return
>> error but output
>> some log message into kernel buffer, better?
>
>
>  the Other choices are:
>
>  display the error only when specific device is used
>  by the user like 'btrfs dev scan /dev/sdc' And don't print busy /
>  invalid error when a system wide scan is used like 'btrfs dev scan'.
>  To achieve this we have to tweak btrfs-progs.

Maybe return EEXIST value here is better.

Also for your second patch, if we replace one disk with existed disk,
printk that info is good.:-)

Regard,
Wang
>
>  or put the error under the verbose option in the btrfs-progs.
>
>
>
>
>> Thanks,
>> Wang
>>>           name = rcu_string_strdup(path, GFP_NOFS);
>>>           if (!name)
>>>               return -ENOMEM;
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
> .
>

