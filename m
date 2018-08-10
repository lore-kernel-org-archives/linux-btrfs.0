Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:34157 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727516AbeHJOCI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Aug 2018 10:02:08 -0400
Received: by mail-io0-f194.google.com with SMTP id l7-v6so7391426ioj.1
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2018 04:32:36 -0700 (PDT)
Subject: Re: Report correct filesystem usage / limits on BTRFS subvolumes with
 quota
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Tomasz Pala <gotar@polanet.pl>
Cc: linux-btrfs@vger.kernel.org
References: <0059606f-88bf-c919-450b-bf08e184b5a2@mailbox.org>
 <b10a3950-0b86-e4fb-3621-f4c5ad3d79e7@gmx.com>
 <20180809174811.GA27001@polanet.pl>
 <ecd793f3-55b3-84d4-80cf-3382a580037f@gmx.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <9861aa7b-bdc8-f508-1726-3d748485e1ee@gmail.com>
Date: Fri, 10 Aug 2018 07:32:31 -0400
MIME-Version: 1.0
In-Reply-To: <ecd793f3-55b3-84d4-80cf-3382a580037f@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-08-09 19:35, Qu Wenruo wrote:
> 
> 
> On 8/10/18 1:48 AM, Tomasz Pala wrote:
>> On Tue, Jul 31, 2018 at 22:32:07 +0800, Qu Wenruo wrote:
>>
>>> 2) Different limitations on exclusive/shared bytes
>>>     Btrfs can set different limit on exclusive/shared bytes, further
>>>     complicating the problem.
>>>
>>> 3) Btrfs quota only accounts data/metadata used by the subvolume
>>>     It lacks all the shared trees (mentioned below), and in fact such
>>>     shared tree can be pretty large (especially for extent tree and csum
>>>     tree).
>>
>> I'm not sure about the implications, but just to clarify some things:
>>
>> when limiting somebody's data space we usually don't care about the
>> underlying "savings" coming from any deduplicating technique - these are
>> purely bonuses for system owner, so he could do larger resource overbooking.
> 
> In reality that's definitely not the case.
> 
>  From what I see, most users would care more about exclusively used space
> (excl), other than the total space one subvolume is referring to (rfer).
> 
> The most common case is, you do a snapshot, user would only care how
> much new space can be written into the subvolume, other than the total
> subvolume size.
I would really love to know exactly who these users are, because it 
sounds to me like you've heard from exactly zero people who are 
currently using conventional quotas to impose actual resource limits on 
other filesystems (instead of just using them for accounting, which is a 
valid use case but not what they were originally designed for).
> 
>>
>> So - the limit set on any user should enforce maximum and absolute space
>> he has allocated, including the shared stuff. I could even imagine that
>> creating a snapshot might immediately "eat" the available quota. In a
>> way, that quota returned matches (give or take) `du` reported usage,
>> unless "do not account reflinks withing single qgroup" was easy to implemet.
> 
> In fact, that's the case. In current implementation, accounting on
> extent is the easiest (if not the only) way to implement.
> 
>>
>> I.e.: every shared segment should be accounted within quota (at least once).
> 
> Already accounted, at least for rfer.
> 
>>
>> And the numbers accounted should reflect the uncompressed sizes.
> 
> No way for current extent based solution.
While this may be true, this would be a killer feature to have.
> 
>>
>>
>> Moreover - if there would be per-subvolume RAID levels someday, the data
>> should be accouted in relation to "default" (filesystem) RAID level,
>> i.e. having a RAID0 subvolume on RAID1 fs should account half of the
>> data, and twice the data in an opposite scenario (like "dup" profile on
>> single-drive filesystem).
> 
> No possible again for current extent based solution.
> 
>>
>>
>> In short: values representing quotas are user-oriented ("the numbers one
>> bought"), not storage-oriented ("the numbers they actually occupy").
> 
> Well, if something is not possible or brings so big performance impact,
> there will be no argument on how it should work in the first place.
> 
> Thanks,
> Qu
> 
