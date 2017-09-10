Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:55514 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750853AbdIJGCU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Sep 2017 02:02:20 -0400
Subject: Re: btrfs check --repair now runs in minutes instead of hours?
 aborting
To: Marc MERLIN <marc@merlins.org>
Cc: quwenruo@cn.fujitsu.com, Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        Chris Mason <clm@fb.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
References: <20170905010531.rfvun5isjwrb5ur5@merlins.org>
 <75b0ebd3-41ea-7f45-bec4-f7d9ec6efee1@gmx.com>
 <20170905025556.GA6392@merlins.org>
 <92e0486d-a7b5-01f8-5ef4-6773f8939bec@gmx.com>
 <20170905144525.rzvncaxil2enxjwe@merlins.org>
 <20170909174426.dvifafqeuqy4axpx@merlins.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <b2eb3d47-e30a-d938-c879-2aaec38e749a@gmx.com>
Date: Sun, 10 Sep 2017 14:01:58 +0800
MIME-Version: 1.0
In-Reply-To: <20170909174426.dvifafqeuqy4axpx@merlins.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月10日 01:44, Marc MERLIN wrote:
> So, should I assume that btrfs progs git has some issue since there is
> no plausible way that a check --repair should be faster than a regular
> check?

Yes, the assumption that repair should be no faster than RO check is 
correct.
Especially for clean fs, repair should just behave the same as RO check.

And I'll first submit a patch (or patches) to output the consumed time 
for each tree, so we could have a clue what is going wrong.
(Digging the code is just a little too boring for me)

Thanks,
Qu

> 
> Thanks,
> Marc
> 
> On Tue, Sep 05, 2017 at 07:45:25AM -0700, Marc MERLIN wrote:
>> On Tue, Sep 05, 2017 at 04:05:04PM +0800, Qu Wenruo wrote:
>>>> gargamel:~# btrfs fi df /mnt/btrfs_pool1
>>>> Data, single: total.60TiB, used.54TiB
>>>> System, DUP: total2.00MiB, used=1.19MiB
>>>> Metadata, DUP: totalX.00GiB, used.69GiB
>>>
>>> Wait for a minute.
>>>
>>> Is that .69GiB means 706 MiB? Or my email client/GMX screwed up the format
>>> (again)?
>>> This output format must be changed, at least to 0.69 GiB, or 706 MiB.
>>   
>> Email client problem. I see control characters in what you quoted.
>>
>> Let's try again
>> gargamel:~# btrfs fi df /mnt/btrfs_pool1
>> Data, single: total=10.66TiB, used=10.60TiB      => 10TB
>> System, DUP: total=64.00MiB, used=1.20MiB        => 1.2MB
>> Metadata, DUP: total=57.50GiB, used=12.76GiB     => 13GB
>> GlobalReserve, single: total=512.00MiB, used=0.00B  => 0
>>
>>> You mean lowmem is actually FASTER than original mode?
>>> That's very surprising.
>>   
>> Correct, unless I add --repair and then original mode is 2x faster than
>> lowmem.
>>
>>> Is there any special operation done for that btrfs?
>>> Like offline dedupe or tons of reflinks?
>>
>> In this case, no.
>> Note that btrfs check used to take many hours overnight until I did a
>> git pull of btrfs progs and built the latest from TOT.
>>
>>> BTW, how many subvolumes do you have in the fs?
>>   
>> gargamel:/mnt/btrfs_pool1# btrfs subvolume list . | wc -l
>> 91
>>
>> If I remove snapshots for btrfs send and historical 'backups':
>> gargamel:/mnt/btrfs_pool1# btrfs subvolume list . | grep -Ev '(hourly|daily|weekly|rw|ro)' | wc -l
>> 5
>>
>>> This looks like a bug. My first guess is related to number of
>>> subvolumes/reflinks, but I'm not sure since I don't have many real-world
>>> btrfs.
>>>
>>> I'll take sometime to look into it.
>>>
>>> Thanks for the very interesting report,
>>
>> Thanks for having a look :)
>>
>> Marc
>> -- 
>> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
>> Microsoft is to operating systems ....
>>                                        .... what McDonalds is to gourmet cooking
>> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
