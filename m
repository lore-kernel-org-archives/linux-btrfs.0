Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:48573 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932102AbeGBB4Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Jul 2018 21:56:16 -0400
Subject: Re: So, does btrfs check lowmem take days? weeks?
To: Marc MERLIN <marc@merlins.org>
CC: Qu Wenruo <quwenruo.btrfs@gmx.com>, <linux-btrfs@vger.kernel.org>
References: <20180629042707.vrjwbytg6bxmrgjg@merlins.org>
 <6658a593-3b4a-f1ef-f550-2fb951b2517d@gmx.com>
 <20180629052825.tifg2aw7oy3qyyvw@merlins.org>
 <02ba7ad4-b618-85f0-a99f-c43b25d367de@cn.fujitsu.com>
 <20180629061001.kkmgvdgqfhz23kll@merlins.org>
 <a0099769-1622-c428-d47a-0e243f66a8b0@cn.fujitsu.com>
 <20180629064354.kbaepro5ccmm6lkn@merlins.org>
 <20180701232202.vehg7amgyvz3hpxc@merlins.org>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <5a603d3d-620b-6cb3-106c-9d38e3ca6d02@cn.fujitsu.com>
Date: Mon, 2 Jul 2018 10:02:33 +0800
MIME-Version: 1.0
In-Reply-To: <20180701232202.vehg7amgyvz3hpxc@merlins.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/02/2018 07:22 AM, Marc MERLIN wrote:
> On Thu, Jun 28, 2018 at 11:43:54PM -0700, Marc MERLIN wrote:
>> On Fri, Jun 29, 2018 at 02:32:44PM +0800, Su Yue wrote:
>>>>> https://github.com/Damenly/btrfs-progs/tree/tmp1
>>>>
>>>> Not sure if I undertand that you meant, here.
>>>>
>>> Sorry for my unclear words.
>>> Simply speaking, I suggest you to stop current running check.
>>> Then, clone above branch to compile binary then run
>>> 'btrfs check --mode=lowmem $dev'.
>>   
>> I understand, I'll build and try it.
>>
>>>> This filesystem is trash to me and will require over a week to rebuild
>>>> manually if I can't repair it.
>>>
>>> Understood your anxiety, a log of check without '--repair' will help
>>> us to make clear what's wrong with your filesystem.
>>
>> Ok, I'll run your new code without repair and report back. It will
>> likely take over a day though.
> 
> Well, it got stuck for over a day, and then I had to reboot :(
> 
> saruman:/var/local/src/btrfs-progs.sy# git remote -v
> origin	https://github.com/Damenly/btrfs-progs.git (fetch)
> origin	https://github.com/Damenly/btrfs-progs.git (push)
> saruman:/var/local/src/btrfs-progs.sy# git branch
>    master
> * tmp1
> saruman:/var/local/src/btrfs-progs.sy# git pull
> Already up to date.
> saruman:/var/local/src/btrfs-progs.sy# make
> Making all in Documentation
> make[1]: Nothing to be done for 'all'.
> 
> However, it still got stuck here:
Thanks, I saw. Some Clues found.

Could you try follow dumps? They shouldn't cost much time.

#btrfs inspect dump-tree -t 21872 <device> | grep -C 50 "374857 
EXTENT_DATA "

#btrfs inspect dump-tree -t 22911 <device> | grep -C 50 "374857 
EXTENT_DATA "

Thanks,
Su

> gargamel:~# btrfs check --mode=lowmem  -p /dev/mapper/dshelf2
> Checking filesystem on /dev/mapper/dshelf2
> UUID: 0f1a0c9f-4e54-4fa7-8736-fd50818ff73d
> ERROR: extent[84302495744, 69632] referencer count mismatch (root: 21872, owner: 374857, offset: 3407872) wanted: 2
> have: 3
> ERROR: extent[84302495744, 69632] referencer count mismatch (root: 22911, owner: 374857, offset: 3407872) wanted: 2
> have: 4
> ERROR: extent[125712527360, 12214272] referencer count mismatch (root: 21872, owner: 374857, offset: 114540544) wan
> d: 180, have: 181
> ERROR: extent[125730848768, 5111808] referencer count mismatch (root: 21872, owner: 374857, offset: 126754816) want
> : 67, have: 68
> ERROR: extent[125730848768, 5111808] referencer count mismatch (root: 22911, owner: 374857, offset: 126754816) want
> : 67, have: 115
> ERROR: extent[125736914944, 6037504] referencer count mismatch (root: 21872, owner: 374857, offset: 131866624) want
> : 114, have: 115
> ERROR: extent[125736914944, 6037504] referencer count mismatch (root: 22911, owner: 374857, offset: 131866624) want
> : 114, have: 143
> ERROR: extent[129952120832, 20242432] referencer count mismatch (root: 21872, owner: 374857, offset: 148234240) wan
> d: 301, have: 302
> ERROR: extent[129952120832, 20242432] referencer count mismatch (root: 22911, owner: 374857, offset: 148234240) wan
> d: 355, have: 433
> ERROR: extent[134925357056, 11829248] referencer count mismatch (root: 21872, owner: 374857, offset: 180371456) wan
> d: 160, have: 161
> ERROR: extent[134925357056, 11829248] referencer count mismatch (root: 22911, owner: 374857, offset: 180371456) wan
> d: 161, have: 240
> ERROR: extent[147895111680, 12345344] referencer count mismatch (root: 21872, owner: 374857, offset: 192200704) wan
> d: 169, have: 170
> ERROR: extent[147895111680, 12345344] referencer count mismatch (root: 22911, owner: 374857, offset: 192200704) wan
> d: 171, have: 251
> ERROR: extent[150850146304, 17522688] referencer count mismatch (root: 21872, owner: 374857, offset: 217653248) wan
> d: 347, have: 348
> ERROR: extent[156909494272, 55320576] referencer count mismatch (root: 22911, owner: 374857, offset: 235175936) wan
> d: 1, have: 1449
> ERROR: extent[156909494272, 55320576] referencer count mismatch (root: 21872, owner: 374857, offset: 235175936) wan
> d: 1, have: 556
> 
> What should I try next?
> 
> Thanks,
> Marc
> 


