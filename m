Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:33605 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbbHSQSD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Aug 2015 12:18:03 -0400
Received: by iods203 with SMTP id s203so14852728iod.0
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Aug 2015 09:18:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55D412A9.3030903@cn.fujitsu.com>
References: <CAK7bmU_MnppE5EptmAmqDYfpmC4vP8ydOLb6JROXDZFuasPong@mail.gmail.com>
	<55D3DCA5.9070607@cn.fujitsu.com>
	<CAK7bmU_=JcjNT-tqcHmCTQNdFJdGqiCKptypC2c949eG_aAVqA@mail.gmail.com>
	<55D3EE99.2000702@cn.fujitsu.com>
	<CAK7bmU8RK25Zd=sgni1i3M17=mY9xRecFtn+e=Mj03DwjMSBTw@mail.gmail.com>
	<55D412A9.3030903@cn.fujitsu.com>
Date: Wed, 19 Aug 2015 12:18:02 -0400
Message-ID: <CAK7bmU_tGTtWNLfXDNehD=7vO-DBYYuzEFObE-G3Tq=B88eVug@mail.gmail.com>
Subject: Re: btrfs-image gets stuck, using 100%, looping on bad file descriptor
From: Timothy Normand Miller <theosib@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 19, 2015 at 1:22 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> Timothy Normand Miller wrote on 2015/08/18 22:55 -0400:
>>
>> On Tue, Aug 18, 2015 at 10:48 PM, Qu Wenruo <quwenruo@cn.fujitsu.com>
>> wrote:
>>>
>>>
>>>
>>> Timothy Normand Miller wrote on 2015/08/18 22:46 -0400:
>>>>
>>>>
>>>> On Tue, Aug 18, 2015 at 9:32 PM, Qu Wenruo <quwenruo@cn.fujitsu.com>
>>>> wrote:
>>>>>
>>>>>
>>>>> Hi Timothy,
>>>>>
>>>>> Although I have replied to the bugzilla, IMHO it's more appropriate to
>>>>> discuss it in mail list, as it's not a kernel bug.
>>>>>
>>>>
>>>> All four devices were online.  The "missing" one was a drive that
>>>> died, which was replaced by a new one, but btrfs wouldn't finish the
>>>> deletion of the missing device.
>>>>
>>> By replaced, did you mean "btrfs replace"? Or just change the physical
>>> disk
>>> without using "btrfs replace"?
>>
>>
>> Here's what happened:
>>
>> - A drive started throwing bad sectors.  Somehow this caused metadata
>> on other drives to get messed up.
>
>
> Did that cause any huge damage?

It seems that metadata was damaged on all drives.

>
>> - I took that drive offline and mounted degraded (it's a 4-drive RAID1)
>> - I did a "btrfs add" on a new drive and then a "btrfs delete missing"
>> - The replacement drive failed during the replacement operation, and
>> everything went to crap.
>> - With some help, I got a kernel patch that allowed me to mount the
>> original three drives with TWO missing devices.
>
>
> So the original 3 drives are still OK,
> original bad one is missing, and the newly add one is also missing?
>
> That sounds quite repairable.

Nothing I tried would run to completion.  There were always errors.

>
>> - I added a brand new drive and then did "delete missing" again.  This
>> time, the first "delete missing" was successful, but it didn't fully
>> balance the drives, and there was another missing device, so I had to
>> do a "delete missing" again, and that failed.
>>
>> I wanted to get this back online and restored from a backup, but I was
>> willing to keep it this way if people wanted to probe at, in case we
>> can uncover any btrfs bugs.  So it was suggested to get a metadata
>> image, but that ran into some kind of bug in btrfs-image.
>
> If btrfs-image doesn't work, you can also try btrfs-debug-tree.
> IIRC, debug-tree should be more robust than btrfs-image.
>
> BTW, have you tried btrfsck on it? Does it also cause the infinite loop?
>
> I'll also try to reproduce it and investigate the codes directly.

Well, I had to get things back online, so I've restored from backup.
I do have what limited metadata image I could get from btrfs-image.

>
> Thanks,
> Qu
>
>>
>> Currently, I'm restoring from backup, but I have at least a partial
>> metadata dump.
>>
>>
>



-- 
Timothy Normand Miller, PhD
Assistant Professor of Computer Science, Binghamton University
http://www.cs.binghamton.edu/~millerti/
Open Graphics Project
