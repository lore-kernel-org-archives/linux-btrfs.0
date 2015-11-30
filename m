Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5969 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752055AbbK3Byr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Nov 2015 20:54:47 -0500
Subject: Re: btrfs check help
To: Vincent Olivier <vincent@up4.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <AF79907D-A36B-4806-B31A-3E327F2E5642@up4.com>
 <5654C86C.9080800@gmail.com> <20151124203210.GR24333@carfax.org.uk>
 <B369C8E5-3E5E-4008-BD99-C174D7ABFB36@up4.com>
 <56566416.5000405@cn.fujitsu.com>
 <4EF3E931-9089-40FB-8E8E-1928539D39D4@up4.com>
 <3E0A8132-7121-482F-BAAC-BAC6D18661AC@up4.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <565BAC49.3090404@cn.fujitsu.com>
Date: Mon, 30 Nov 2015 09:54:17 +0800
MIME-Version: 1.0
In-Reply-To: <3E0A8132-7121-482F-BAAC-BAC6D18661AC@up4.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Vincent Olivier wrote on 2015/11/27 06:25 -0500:
>
>> On Nov 26, 2015, at 10:03 PM, Vincent Olivier <vincent@up4.com> wrote:
>>
>>>
>>> On Nov 25, 2015, at 8:44 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>>
>>>
>>>
>>> Vincent Olivier wrote on 2015/11/25 11:51 -0500:
>>>> I should probably point out that there is 64GB of RAM on this machine and it’s a dual Xeon processor (LGA2011-3) system. Also, there is only Btrfs served via Samba and the kernel panic was caused Btrfs (as per what I remember from the log on the screen just before I rebooted) and happened in the middle of the night when zero (0) client was connected.
>>>>
>>>> You will find below the full “btrfs check” log for each device in the order it is listed by “btrfs fi show”.
>>>
>>> There is really no need to do such thing, as btrfs is able to manage multiple device, calling btrfsck on any of them is enough as long as it's not hugely damaged.
>>>
>>>>
>>>> Ca I get a strong confirmation that I should run with the “—repair” option on each device? Thanks.
>>>
>>> YES.
>>>
>>> Inode nbytes fix is *VERY* safe as long as it's the only error.
>>>
>>> Although it's not that convincing since the inode nbytes fix code is written by myself and authors always tend to believe their codes are good....
>>> But at least, some other users with more complicated problem(with inode nbytes error) fixed it.
>>>
>>> The last decision is still on you anyway.
>>
>> I will do it on the first device from the “fi show” output and report.
>
>
> ok this doesn’t look good. i ran —repair and check again and it looks even worse. please help.
>
>
> [root@3dcpc5 ~]# btrfs check --repair /dev/sdk
> enabling repair mode
> Checking filesystem on /dev/sdk
> UUID: 6a742786-070d-4557-9e67-c73b84967bf5
> checking extents
> Fixed 0 roots.
> checking free space cache
> cache and super generation don't match, space cache will be invalidated
> checking fs roots
> reset nbytes for ino 1341670 root 5
> reset nbytes for ino 1341670 root 11406

As mentioned by other guys, inode nbytes seems to be fixed.

But to make it sure, if the inode is a directory or a normal file?

> warning line 3653

Seems to be a unexpected warning.
The subvolume root seems to be shared by other subvolume.

It may be one corner case for inode nbytes repair code.
But it seems no harm yet.

> checking csums
> checking root refs
> found 19343374874998 bytes used err is 0
> total csum bytes: 18863243900
> total tree bytes: 27413118976
> total fs tree bytes: 4455694336
> total extent tree bytes: 3077373952
> btree space waste bytes: 2882193883
> file data blocks allocated: 19461564538880
>   referenced 20155355832320
>
>
>
>
>
> root@3dcpc5 ~]# btrfs check /dev/sdk
> Checking filesystem on /dev/sdk
> UUID: 6a742786-070d-4557-9e67-c73b84967bf5
> checking extents
> checking free space cache
> block group 53328591454208 has wrong amount of free space
> failed to load free space cache for block group 53328591454208
> block group 53329665196032 has wrong amount of free space
> failed to load free space cache for block group 53329665196032
> Wanted offset 58836887044096, found 58836887011328
> Wanted offset 58836887044096, found 58836887011328
> cache appears valid but isnt 58836887011328
> Wanted offset 60505481887744, found 60505481805824
> Wanted offset 60505481887744, found 60505481805824
> cache appears valid but isnt 60505481805824
> Wanted bytes 16384, found 81920 for off 60979001966592
> Wanted bytes 1073725440, found 81920 for off 60979001966592
> cache appears valid but isnt 60979001950208
> Wanted offset 61297908056064, found 61297908006912
> Wanted offset 61297908056064, found 61297908006912
> cache appears valid but isnt 61297903271936
> Wanted bytes 32768, found 16384 for off 61711301296128
> Wanted bytes 1066319872, found 16384 for off 61711301296128
> cache appears valid but isnt 61711293874176
> There is no free space entry for 62691824041984-62691824058368
> There is no free space entry for 62691824041984-62692693901312
> cache appears valid but isnt 62691620159488
> There is no free space entry for 63723505205248-63723505221632
> There is no free space entry for 63723505205248-63724559794176
> cache appears valid but isnt 63723486052352
> Wanted bytes 32768, found 16384 for off 64746920902656
> Wanted bytes 914849792, found 16384 for off 64746920902656
> cache appears valid but isnt 64746762010624
> There is no free space entry for 65770368401408-65770368434176
> There is no free space entry for 65770368401408-65771111710720
> cache appears valid but isnt 65770037968896
> Wanted offset 66758954270720, found 66758954221568
> Wanted offset 66758954270720, found 66758954221568
> cache appears valid but isnt 66758954188800
> block group 70204591702016 has wrong amount of free space
> failed to load free space cache for block group 70204591702016
> block group 70205665443840 has wrong amount of free space
> failed to load free space cache for block group 70205665443840
> block group 70206739185664 has wrong amount of free space
> failed to load free space cache for block group 70206739185664
> Wanted offset 70216543715328, found 70216543698944
> Wanted offset 70216543715328, found 70216543698944
> cache appears valid but isnt 70216537079808
> Wanted offset 71025067474944, found 71025067409408
> Wanted offset 71025067474944, found 71025067409408
> cache appears valid but isnt 71025064673280
> Wanted offset 71455641354240, found 71455641337856
> Wanted offset 71455641354240, found 71455641337856
> cache appears valid but isnt 71455635144704
> block group 71662867316736 has wrong amount of free space
> failed to load free space cache for block group 71662867316736
> block group 71663941058560 has wrong amount of free space
> failed to load free space cache for block group 71663941058560
> There is no free space entry for 72725872967680-72725872984064
> There is no free space entry for 72725872967680-72726945464320
> cache appears valid but isnt 72725871722496
> block group 73207981801472 has wrong amount of free space
> failed to load free space cache for block group 73207981801472
> found 19343374940534 bytes used err is -22

Just free space cache mismatch.
Quite common for btrfsck, as it doesn't modify free space cache and 
alloced/freed some space.

It seems quite scary but in fact won't be a big problem.
The behavior can be improved for btrfsck, if it found old free space 
cache, just clean it to ensure good output.

To fix the problem, mount the filesystem with "-o clear_cache" to 
cleanup the wrong space cache.

Thanks,
Qu

> total csum bytes: 18863243900
> total tree bytes: 27413184512
> total fs tree bytes: 4455727104
> total extent tree bytes: 3077406720
> btree space waste bytes: 2882234096
> file data blocks allocated: 19461573357568
>   referenced 20155367563264
> [root@3dcpc5 ~]# --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


