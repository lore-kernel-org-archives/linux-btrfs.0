Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:44732 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755661AbdKBLBm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Nov 2017 07:01:42 -0400
Received: by mail-io0-f175.google.com with SMTP id m16so13035456iod.1
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Nov 2017 04:01:42 -0700 (PDT)
Subject: Re: Several questions regarding btrfs
To: ST <smntov@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <1509467017.1662.37.camel@gmail.com>
 <edd9dfa6-a73d-54d6-d9d6-48bd5fd7f724@gmail.com>
 <1509480384.1662.84.camel@gmail.com>
 <ea097624-d485-9423-387f-3c9427508883@gmail.com>
 <1509545153.1662.105.camel@gmail.com>
 <7e8d6430-01e0-ba8e-5822-510ba1daef9f@gmail.com>
 <1509613781.1662.115.camel@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <173c1ba3-1a05-1a27-7bee-22141200cbf8@gmail.com>
Date: Thu, 2 Nov 2017 07:01:37 -0400
MIME-Version: 1.0
In-Reply-To: <1509613781.1662.115.camel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-11-02 05:09, ST wrote:
>>>>>
>>>>> Ok. I'll use more standard approaches. Which of following commands will
>>>>> work with BTRFS:
>>>>>
>>>>> https://debian-handbook.info/browse/stable/sect.quotas.html
>>>> None, qgroups are the only option right now with BTRFS, and it's pretty
>>>> likely to stay that way since the internals of the filesystem don't fit
>>>> well within the semantics of the regular VFS quota API.  However,
>>>> provided you're not using huge numbers of reflinks and subvolumes, you
>>>> should be fine using qgroups.
>>>
>>> I want to have 7 daily (or 7+4) read-only snapshots per user, for ca.
>>> 100 users. I don't expect users to invoke cp --reflink or take
>>> snapshots.
>> Based on what you say below about user access, you should be absolutely
>> fine then.
>>
>> There's one other caveat though, only root can use the qgroup ioctls,
>> which means that only root can check quotas.
> 
> Only root can check quotas?! That is really strange. How users are
> supposed to know they are about to be out of space?... Is this by design
> so and will remain like that or it's just because this feature was not
> finished yet?
> 
I have no idea if it's intended to be that way, but quite a few things 
in BTRFS are root-only that debatably should not be.  I think the quota 
ioctls fall under the same category as the tree search ioctl, they 
access data that's technically privileged and can let you see things 
beyond the mount point they're run on.
