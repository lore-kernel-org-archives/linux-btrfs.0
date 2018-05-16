Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:39935 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751533AbeEPOcS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 10:32:18 -0400
Received: by mail-it0-f66.google.com with SMTP id c3-v6so2429278itj.4
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 07:32:18 -0700 (PDT)
Subject: Re: [PATCH v2 3/3] btrfs: balance: add kernel log for end or paused
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180516025128.9899-1-anand.jain@oracle.com>
 <20180516025128.9899-4-anand.jain@oracle.com>
 <ee980204-dcf3-44ce-8c66-7c82e736c793@gmail.com>
 <89cd7df8-199e-f8d2-748a-3eb1f9ca872b@oracle.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <f17c9c26-5afc-ade6-ad4b-7cbed33ed61e@gmail.com>
Date: Wed, 16 May 2018 10:32:17 -0400
MIME-Version: 1.0
In-Reply-To: <89cd7df8-199e-f8d2-748a-3eb1f9ca872b@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-05-16 09:23, Anand Jain wrote:
> 
> 
> On 05/16/2018 07:25 PM, Austin S. Hemmelgarn wrote:
>> On 2018-05-15 22:51, Anand Jain wrote:
>>> Add a kernel log when the balance ends, either for cancel or completed
>>> or if it is paused.
>>> ---
>>> v1->v2: Moved from 2/3 to 3/3
>>>
>>>   fs/btrfs/volumes.c | 7 +++++++
>>>   1 file changed, 7 insertions(+)
>>>
>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>> index ce68c4f42f94..a4e243a29f5c 100644
>>> --- a/fs/btrfs/volumes.c
>>> +++ b/fs/btrfs/volumes.c
>>> @@ -4053,6 +4053,13 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
>>>       ret = __btrfs_balance(fs_info);
>>>       mutex_lock(&fs_info->balance_mutex);
>>> +    if (ret == -ECANCELED && atomic_read(&fs_info->balance_pause_req))
>>> +        btrfs_info(fs_info, "balance: paused");
>>> +    else if (ret == -ECANCELED && 
>>> atomic_read(&fs_info->balance_cancel_req))
>>> +        btrfs_info(fs_info, "balance: canceled");
>>> +    else
>>> +        btrfs_info(fs_info, "balance: ended with status: %d", ret);
>>> +
>>>       clear_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags);
>>>       if (bargs) {
>>>
>> Is there some way that these messages could be extended to include 
>> info about which volume the balance in question was on.  Ideally, 
>> something that matches up with what's listed in the message from the 
>> previous patch.  There's nothi9ng that prevents you from running 
>> balances on separate BTRFS volumes in parallel, so this message won't 
>> necessarily be for the most recent balance start message.
> 
>   Hm. That's not true, btrfs_info(fs_info,,) adds the fsid.
>   So its already drilled down to the lowest granular possible.
> 
Ah, you're right, it does.  Sorry about the noise.

