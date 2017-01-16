Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14956 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751175AbdAPBjG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 15 Jan 2017 20:39:06 -0500
Subject: Re: corruption: yet another one after deleting a ro snapshot
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        <linux-btrfs@vger.kernel.org>
References: <1484183243.10253.5.camel@scientia.net>
 <a7b82ec9-bd8d-d6bb-27e7-3732b466ca06@cn.fujitsu.com>
 <1484188092.29002.4.camel@scientia.net>
 <25993bdf-d1fe-30df-7236-b9d5d6e5cfb2@cn.fujitsu.com>
 <1484499869.17186.1.camel@scientia.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <4d7e21ed-a8f6-6c75-4a14-ff43201bd27b@cn.fujitsu.com>
Date: Mon, 16 Jan 2017 09:38:53 +0800
MIME-Version: 1.0
In-Reply-To: <1484499869.17186.1.camel@scientia.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 01/16/2017 01:04 AM, Christoph Anton Mitterer wrote:
> On Thu, 2017-01-12 at 10:38 +0800, Qu Wenruo wrote:
>> IIRC, RO mount won't continue background deletion.
> I see.
>
>
>> Would you please try 4.9 btrfs-progs?
>
> Done now, see results (lowmem and original mode) below:
>
> # btrfs version
> btrfs-progs v4.9
>
> # btrfs check /dev/nbd0 ; echo $?
> Checking filesystem on /dev/nbd0
> UUID: 326d292d-f97b-43ca-b1e8-c722d3474719
> checking extents
> ref mismatch on [37765120 16384] extent item 0, found 1
> Backref 37765120 parent 6403 root 6403 not found in extent tree
> backpointer mismatch on [37765120 16384]
> owner ref check failed [37765120 16384]
> ref mismatch on [51200000 16384] extent item 0, found 1
> Backref 51200000 parent 6403 root 6403 not found in extent tree
> backpointer mismatch on [51200000 16384]
> owner ref check failed [51200000 16384]
> ref mismatch on [78135296 16384] extent item 0, found 1
> Backref 78135296 parent 6403 root 6403 not found in extent tree
> backpointer mismatch on [78135296 16384]
> owner ref check failed [78135296 16384]
> ref mismatch on [5960381235200 16384] extent item 0, found 1
> Backref 5960381235200 parent 6403 root 6403 not found in extent tree
> backpointer mismatch on [5960381235200 16384]
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> found 7483995824128 bytes used err is 0
> total csum bytes: 7296183880
> total tree bytes: 10875944960
> total fs tree bytes: 2035286016
> total extent tree bytes: 1015988224
> btree space waste bytes: 920641324
> file data blocks allocated: 8267656339456
>  referenced 8389440876544
> 0
>
>
> # btrfs check --mode=lowmem /dev/nbd0 ; echo $?
> Checking filesystem on /dev/nbd0
> UUID: 326d292d-f97b-43ca-b1e8-c722d3474719
> checking extents
> ERROR: block group[74117545984 1073741824] used 1073741824 but extent items used 0
> ERROR: block group[239473786880 1073741824] used 1073741824 but extent items used 1207959552
> ERROR: block group[500393050112 1073741824] used 1073741824 but extent items used 1207959552
> ERROR: block group[581997428736 1073741824] used 1073741824 but extent items used 0
> ERROR: block group[626557714432 1073741824] used 1073741824 but extent items used 0
> ERROR: block group[668433645568 1073741824] used 1073741824 but extent items used 0
> ERROR: block group[948680261632 1073741824] used 1073741824 but extent items used 0
> ERROR: block group[982503129088 1073741824] used 1073741824 but extent items used 0
> ERROR: block group[1039411445760 1073741824] used 1073741824 but extent items used 0
> ERROR: block group[1054443831296 1073741824] used 1073741824 but extent items used 1207959552
> ERROR: block group[1190809042944 1073741824] used 1073741824 but extent items used 0
> ERROR: block group[1279392743424 1073741824] used 1073741824 but extent items used 0
> ERROR: block group[1481256206336 1073741824] used 1073741824 but extent items used 0
> ERROR: block group[1620842643456 1073741824] used 1073741824 but extent items used 1207959552
> ERROR: block group[1914511032320 1073741824] used 1073741824 but extent items used 1207959552
> ERROR: block group[3055361720320 1073741824] used 1073741824 but extent items used 0
> ERROR: block group[3216422993920 1073741824] used 1073741824 but extent items used 0
> ERROR: block group[3670615785472 1073741824] used 1073741824 but extent items used 1207959552
> ERROR: block group[3801612288000 1073741824] used 1073741824 but extent items used 1207959552
> ERROR: block group[3828455833600 1073741824] used 1073741824 but extent items used 1207959552
> ERROR: block group[4250973241344 1073741824] used 1073741824 but extent items used 0
> ERROR: block group[4261710659584 1073741824] used 1073741824 but extent items used 1074266112
> ERROR: block group[4392707162112 1073741824] used 1073741824 but extent items used 0
> ERROR: block group[4558063403008 1073741824] used 1073741824 but extent items used 0
> ERROR: block group[4607455526912 1073741824] used 1073741824 but extent items used 0
> ERROR: block group[4635372814336 1073741824] used 1073741824 but extent items used 0
> ERROR: block group[4640204652544 1073741824] used 1073741824 but extent items used 0
> ERROR: block group[4642352136192 1073741824] used 1073741824 but extent items used 1207959552
> ERROR: block group[4681006841856 1073741824] used 1073741824 but extent items used 0
> ERROR: block group[5063795802112 1073741824] used 1073741824 but extent items used 0
> ERROR: block group[5171169984512 1073741824] used 1073741824 but extent items used 1207959552
> ERROR: block group[5216267141120 1073741824] used 1073741824 but extent items used 1207959552
> ERROR: block group[5290355326976 1073741824] used 1073741824 but extent items used 0
> ERROR: block group[5445511020544 1073741824] used 1073741824 but extent items used 1074266112
> ERROR: block group[6084387405824 1073741824] used 1073741824 but extent items used 0
> ERROR: block group[6104788500480 1073741824] used 1073741824 but extent items used 0
> ERROR: block group[6878956355584 1073741824] used 1073741824 but extent items used 0
> ERROR: block group[6997067956224 1073741824] used 1073741824 but extent items used 0
> ERROR: block group[7702516334592 1073741824] used 1073741824 but extent items used 0
> ERROR: block group[8051482427392 1073741824] used 1073741824 but extent items used 1084751872
> ERROR: block group[8116980678656 1073741824] used 1073217536 but extent items used 0
> ERROR: extent[5960381235200 16384] backref lost (owner: 6403, level: 1)
> ERROR: check node failed root 6403 bytenr 5960381235200 level 1, force continue check
> ERROR: extent[51200000 16384] backref lost (owner: 257, level: 1)
> ERROR: check node failed root 6403 bytenr 51200000 level 1, force continue check
> ERROR: extent[37765120 16384] backref lost (owner: 257, level: 1)
> ERROR: check node failed root 6403 bytenr 37765120 level 1, force continue check
> ERROR: extent[78135296 16384] backref lost (owner: 257, level: 1)
> ERROR: check node failed root 6403 bytenr 78135296 level 1, force continue check
> ERROR: errors found in extent allocation tree or chunk allocation
> checking free space cache
> checking fs roots
> found 7483995758592 bytes used err is -5
> total csum bytes: 7296183880
> total tree bytes: 11018780672
> total fs tree bytes: 2178121728
> total extent tree bytes: 1015988224
> btree space waste bytes: 936782513
> file data blocks allocated: 9157658292224
>  referenced 9292573106176
> 1
>
>
> It's the same fs as I was talking before, I just had to do it via NBD.
>

So the fs is REALLY corrupted. Although we still don't know if it's 
persistent.

BTW, lowmem mode seems to have a new false alert when checking the block 
group item.

>
>> But, I'm still not sure whether it's a false alert or a *REAL*
>> corruption.
>>
>> Even it may cause problem and corrupt your data, I still hope you
>> could
>> do a rw mount and trigger a btrfs fi sync.
>>
>> If it's a false alert, we can fix it then with ease.
>> Or, it's a really big problem.
>
> So what should I do next (as said, this is just a backup for me, so
> while it would be annoying to recreate it (because nearly the full
> 8TiB) I could do it without any problem)... in terms of debugging this
> issue?

Did you have any "lightweight" method to reproduce the bug?

For example, on a 1G btrfs fs with moderate operations, for example 
15min or so, to reproduce the bug?

>
> Shall I rw-mount the fs and do sync and wait and retry? Or is there
> anything else that you want me to try before in order to get the kernel
> bug (if any) or btrfs-progs bug nailed down?

Personally speaking, rw mount would help, to verify if it's just a bug 
that will disappear after the deletion is done.

But considering the size of your fs, it may not be a good idea as we 
don't have reliable method to recover/rebuild extent tree yet.

Thanks,
Qu

>
>
> Cheers,
> Chris.
>


