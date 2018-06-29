Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:29585 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752881AbeF2F4C (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 01:56:02 -0400
Subject: Re: So, does btrfs check lowmem take days? weeks?
To: Marc MERLIN <marc@merlins.org>, Qu Wenruo <quwenruo.btrfs@gmx.com>
CC: <linux-btrfs@vger.kernel.org>
References: <20180629042707.vrjwbytg6bxmrgjg@merlins.org>
 <6658a593-3b4a-f1ef-f550-2fb951b2517d@gmx.com>
 <20180629052825.tifg2aw7oy3qyyvw@merlins.org>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <02ba7ad4-b618-85f0-a99f-c43b25d367de@cn.fujitsu.com>
Date: Fri, 29 Jun 2018 14:02:19 +0800
MIME-Version: 1.0
In-Reply-To: <20180629052825.tifg2aw7oy3qyyvw@merlins.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/29/2018 01:28 PM, Marc MERLIN wrote:
> On Fri, Jun 29, 2018 at 01:07:20PM +0800, Qu Wenruo wrote:
>>> lowmem repair seems to be going still, but it's been days and -p seems
>>> to do absolutely nothing.
>>
>> I'm a afraid you hit a bug in lowmem repair code.
>> By all means, --repair shouldn't really be used unless you're pretty
>> sure the problem is something btrfs check can handle.
>>
>> That's also why --repair is still marked as dangerous.
>> Especially when it's combined with experimental lowmem mode.
> 
> Understood, but btrfs got corrupted (by itself or not, I don't know)
> I cannot mount the filesystem read/write
> I cannot btrfs check --repair it since that code will kill my machine
> What do I have left?
> 
>>> My filesystem is "only" 10TB or so, albeit with a lot of files.
>>
>> Unless you have tons of snapshots and reflinked (deduped) files, it
>> shouldn't take so long.
> 
> I may have a fair amount.
> gargamel:~# btrfs check --mode=lowmem --repair -p /dev/mapper/dshelf2
> enabling repair mode
> WARNING: low-memory mode repair support is only partial
> Checking filesystem on /dev/mapper/dshelf2
> UUID: 0f1a0c9f-4e54-4fa7-8736-fd50818ff73d
> Fixed 0 roots.
> ERROR: extent[84302495744, 69632] referencer count mismatch (root: 21872, owner: 374857, offset: 3407872) wanted: 3, have: 4
> Created new chunk [18457780224000 1073741824]
> Delete backref in extent [84302495744 69632]
> ERROR: extent[84302495744, 69632] referencer count mismatch (root: 22911, owner: 374857, offset: 3407872) wanted: 3, have: 4
> Delete backref in extent [84302495744 69632]
> ERROR: extent[125712527360, 12214272] referencer count mismatch (root: 21872, owner: 374857, offset: 114540544) wanted: 181, have: 240
> Delete backref in extent [125712527360 12214272]
> ERROR: extent[125730848768, 5111808] referencer count mismatch (root: 21872, owner: 374857, offset: 126754816) wanted: 68, have: 115
> Delete backref in extent [125730848768 5111808]
> ERROR: extent[125730848768, 5111808] referencer count mismatch (root: 22911, owner: 374857, offset: 126754816) wanted: 68, have: 115
> Delete backref in extent [125730848768 5111808]
> ERROR: extent[125736914944, 6037504] referencer count mismatch (root: 21872, owner: 374857, offset: 131866624) wanted: 115, have: 143
> Delete backref in extent [125736914944 6037504]
> ERROR: extent[125736914944, 6037504] referencer count mismatch (root: 22911, owner: 374857, offset: 131866624) wanted: 115, have: 143
> Delete backref in extent [125736914944 6037504]
> ERROR: extent[129952120832, 20242432] referencer count mismatch (root: 21872, owner: 374857, offset: 148234240) wanted: 302, have: 431
> Delete backref in extent [129952120832 20242432]
> ERROR: extent[129952120832, 20242432] referencer count mismatch (root: 22911, owner: 374857, offset: 148234240) wanted: 356, have: 433
> Delete backref in extent [129952120832 20242432]
> ERROR: extent[134925357056, 11829248] referencer count mismatch (root: 21872, owner: 374857, offset: 180371456) wanted: 161, have: 240
> Delete backref in extent [134925357056 11829248]
> ERROR: extent[134925357056, 11829248] referencer count mismatch (root: 22911, owner: 374857, offset: 180371456) wanted: 162, have: 240
> Delete backref in extent [134925357056 11829248]
> ERROR: extent[147895111680, 12345344] referencer count mismatch (root: 21872, owner: 374857, offset: 192200704) wanted: 170, have: 249
> Delete backref in extent [147895111680 12345344]
> ERROR: extent[147895111680, 12345344] referencer count mismatch (root: 22911, owner: 374857, offset: 192200704) wanted: 172, have: 251
> Delete backref in extent [147895111680 12345344]
> ERROR: extent[150850146304, 17522688] referencer count mismatch (root: 21872, owner: 374857, offset: 217653248) wanted: 348, have: 418
> Delete backref in extent [150850146304 17522688]
> ERROR: extent[156909494272, 55320576] referencer count mismatch (root: 22911, owner: 374857, offset: 235175936) wanted: 555, have: 1449
> Deleted root 2 item[156909494272, 178, 5476627808561673095]
> ERROR: extent[156909494272, 55320576] referencer count mismatch (root: 21872, owner: 374857, offset: 235175936) wanted: 556, have: 1452
> Deleted root 2 item[156909494272, 178, 7338474132555182983]
> ERROR: file extent[374857 235184128] root 21872 owner 21872 backref lost
> Add one extent data backref [156909494272 55320576]
> ERROR: file extent[374857 235184128] root 22911 owner 22911 backref lost
> Add one extent data backref [156909494272 55320576]
> 
My bad.
It's almost possiblelly a bug about extent of lowmem check which
was reported by Chris too.
The extent check was wrong, the the repair did wrong things.

I have figured out the bug is lowmem check can't deal with shared tree 
block in reloc tree. The fix is simple, you can try the follow repo:

https://github.com/Damenly/btrfs-progs/tree/tmp1

Please run lowmem check "without =--repair" first to be sure whether
your filesystem is fine.

Though the bug and phenomenon are clear enough, before sending my patch,
I have to make a test image. I have spent a week to study btrfs balance
but it seems a liitle hard for me.

Thanks,
Su

> The last two ERROR lines took over a day to get generated, so I'm not sure if it's still working, but just slowly.
> For what it's worth non lowmem check used to take 12 to 24H on that filesystem back when it still worked.
> 
>>> 2 things that come to mind
>>> 1) can lowmem have some progress working so that I know if I'm looking
>>> at days, weeks, or even months before it will be done?
>>
>> It's hard to estimate, especially when every cross check involves a lot
>> of disk IO.
>> But at least, we could add such indicator to show we're doing something.
> 
> Yes, anything to show that I should still wait is still good :)
> 
>>> 2) non lowmem is more efficient obviously when it doesn't completely
>>> crash your machine, but could lowmem be given an amount of memory to use
>>> for caching, or maybe use some heuristics based on RAM free so that it's
>>> not so excrutiatingly slow?
>>
>> IIRC recent commit has added the ability.
>> a5ce5d219822 ("btrfs-progs: extent-cache: actually cache extent buffers")
>   
> Oh, good.
> 
>> That's already included in btrfs-progs v4.13.2.
>> So it should be a dead loop which lowmem repair code can't handle.
> 
> I see. Is there any reasonably easy way to check on this running process?
> 
> Both top and iotop show that it's working, but of course I can't tell if
> it's looping, or not.
> 
> Then again, maybe it already fixed enough that I can mount my filesystem again.
> 
> But back to the main point, it's sad that after so many years, the
> repair situation is still so suboptimal, especially when it's apparently
> pretty easy for btrfs to get damaged (through its own fault or not, hard
> to say).
> 
> Thanks,
> Marc
> 


