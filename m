Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:41866 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752015AbeEPCsi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 22:48:38 -0400
From: Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH 2/2] btrfs: add balance args info during start and resume
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20180426080129.3270-1-anand.jain@oracle.com>
 <20180426080129.3270-3-anand.jain@oracle.com>
 <9822975f-9fe7-429d-2871-84ed9e5d299d@suse.com>
 <16571dc5-de44-fe74-5641-e825af114cee@oracle.com>
Message-ID: <653cffe1-3d20-308c-953f-5ae0492f71a3@oracle.com>
Date: Wed, 16 May 2018 10:51:05 +0800
MIME-Version: 1.0
In-Reply-To: <16571dc5-de44-fe74-5641-e825af114cee@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


  All comments accepted in v2 in ml, except for the one below.

>>>       clear_bit(BTRFS_FS_BALANCE_RUNNING, &fs_info->flags);
>>>       if (bargs) {
>>> @@ -3947,10 +4096,8 @@ static int balance_kthread(void *data)
>>>       int ret = 0;
>>>       mutex_lock(&fs_info->balance_mutex);
>>> -    if (fs_info->balance_ctl) {
>>> -        btrfs_info(fs_info, "balance: resuming");
>>> +    if (fs_info->balance_ctl)
>>>           ret = btrfs_balance(fs_info->balance_ctl, NULL);
>>> -    }
>> Unrelated change.
> 
>   Why?

  I believe this change is related to this patch, as this patch has
  added the resume log at btrfs_balance() and so we don't needed
  the resume log again in btrfs_kthread().
  OR.
  I don't know your reasoning. I am ignoring this comment as of now.

  V2 is in the ML.

Thanks, Anand
