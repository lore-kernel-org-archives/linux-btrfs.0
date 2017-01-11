Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:61381 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754451AbdAKCdE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jan 2017 21:33:04 -0500
Subject: Re: [RFC] Converging userspace and kernel code
To: Anand Jain <anand.jain@oracle.com>, Goldwyn Rodrigues <rgoldwyn@suse.de>,
        <linux-btrfs@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
        David Sterba <dsterba@suse.com>
References: <512c15bf-3c4b-3b88-1106-a7d43386400f@suse.de>
 <1b68f099-53e8-1bc8-5ffc-2dd0b21a32ae@oracle.com>
 <09ea1fbd-74a1-d9f5-ba86-bc7c9118d49f@suse.de>
 <d0a11a09-322d-89bc-1a15-598f6a14e6be@oracle.com>
 <d0c2e05d-0b7a-a782-80b8-e1776e7b6fdb@suse.de>
 <2dfce804-d1ba-d9e4-e7b3-9c726ff5b49b@oracle.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <d53b25ca-82bb-96ae-33fd-1286f3b367db@cn.fujitsu.com>
Date: Wed, 11 Jan 2017 10:32:43 +0800
MIME-Version: 1.0
In-Reply-To: <2dfce804-d1ba-d9e4-e7b3-9c726ff5b49b@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 01/11/2017 10:23 AM, Anand Jain wrote:
>
>
> On 01/11/17 00:04, Goldwyn Rodrigues wrote:
>>
>>
>> On 01/10/2017 09:20 AM, Anand Jain wrote:
>>>
>>>
>>> On 01/10/17 20:14, Goldwyn Rodrigues wrote:
>>>>
>>>>
>>>> On 01/09/2017 09:28 PM, Anand Jain wrote:
>>>>>
>>>>> Goldwyn,
>>>>>
>>>>>  Could you add a list what functionality in btrfs-progs will
>>>>>  be using the 'core'. ?
>>>>
>>>>
>>>> There are too many to list. It would contain the algorithmic functions
>>>> of btrfs which would be able to interact with both kernel and
>>>> btrfs-progs.
>>>
>>>  I am getting confused. How about a few from the btrfs-progs ?
>>>
>>>
>>
>> Functions such as open_ctree(), or the set/get functions. The idea is to
>> keep the codebase of this core component the same in btrfs-progs and
>> kernel.
>
>  The btrfs-progs open_ctree() is used for the offline functionality
>  such as fsck...
>
>> As an example, see how XFS have done using libxfs. Something around the
>> same lines.
>>
>
>  Does XFS progs access the disks directly (without going through the
>  kernel) while kernel has mounted the disk ? If yes, how does it
>  maintain the consistency ? Calling sync for the sake of read access
>  by the progs, is not a good idea as it causes jitters in the steady
>  state IOPS for the applications. I have investigated these concerns
>  at the data centers earlier.

Just a quick glance, and I found that libxfs is much like interfaces of 
OOP languages.

For example, in libxfs, there are functions calling xfs_trans_commit(), 
but there is not implementation.

The implementation part can diff between kernel and xfsprogs.


Which seems very nicely arranged for me, and since it's just interfaces, 
I hardly see how it can cause performance problems.

Thanks,
Qu
>
> Thanks, Anand
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


