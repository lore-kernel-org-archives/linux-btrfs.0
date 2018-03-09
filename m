Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:34552 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750926AbeCIGpe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Mar 2018 01:45:34 -0500
Received: by mail-lf0-f47.google.com with SMTP id l191-v6so11792903lfe.1
        for <linux-btrfs@vger.kernel.org>; Thu, 08 Mar 2018 22:45:33 -0800 (PST)
Subject: Re: Inconsistence between sender and receiver
To: bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org
References: <20180307184930.GA26754@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
 <1a7f0c8f-9bf1-b6eb-ff5c-517d935b84e8@gmail.com>
 <20180309053808.GD26754@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <060e33f0-e0b7-649d-8696-75e5a1f7ce85@gmail.com>
Date: Fri, 9 Mar 2018 09:45:30 +0300
MIME-Version: 1.0
In-Reply-To: <20180309053808.GD26754@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

09.03.2018 08:38, Liu Bo пишет:
> On Thu, Mar 08, 2018 at 09:15:50AM +0300, Andrei Borzenkov wrote:
>> 07.03.2018 21:49, Liu Bo пишет:
>>> Hi,
>>>
>>> In the following steps[1], if <parent> on receiver side has got
>>> changed via 'btrfs property set', then after doing incremental
>>> updates, receiver gets a different snapshot from what sender has sent.
>>>
>>> The reason behind it is that there is no change about file 'foo' in
>>> the send stream, such that receiver simply creates a snapshot of
>>> <parent> on its side with nothing to apply from the send stream.
>>>
>>> A possible way to avoid this is to check rtransid and ctranid of
>>> <parent> on receiver side, but I'm not very sure whether the current
>>> behavior is made deliberately, does anyone have an idea? 
>>>
>>> Thanks,
>>>
>>> -liubo
>>>
>>> [1]:
>>> $ btrfs sub create /mnt/send/sub
>>> $ touch /mnt/send/sub/foo
>>> $ btrfs sub snap -r /mnt/send/sub /mnt/send/parent
>>>
>>> # send parent out
>>> $ btrfs send /mnt/send/parent | btrfs receive /mnt/recv/
>>>
>>> # change parent and file under it
>>> $ btrfs property set -t subvol /mnt/recv/parent ro false
>>
>> Is removing the ability to modify read-only property an option? What are
>> use cases for it? What can it do that "btrfs sub snap read-only
>> writable" cannot?
>>
> 
> Tbh, I don't know any usecase for that, I just wanted to toggle off
> the ro bit in order to change something inside <parent>.
> 
>>> $ truncate -s 4096 /mnt/recv/parent/foo
>>>
>>> $ btrfs sub snap -r /mnt/send/sub /mnt/send/update
>>> $ btrfs send -p /mnt/send/parent /mnt/send/update | btrfs receive /mnt/recv
>>>
>>
>> This should fail right away because /mnt/send/parent is not read-only.
>> If it does not, this is really a bug.
>>
> 
> It's not '/mnt/send/parent', but '/mnt/recv/parent' got changed.
> 

Ah, sorry.

What happened to this patch which clears received_uuid when ro is
flipped off?

https://patchwork.kernel.org/patch/9986521/
