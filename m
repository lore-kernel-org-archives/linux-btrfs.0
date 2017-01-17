Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:61527 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750846AbdAQIxa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 03:53:30 -0500
Subject: Re: corruption: yet another one after deleting a ro snapshot
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        <linux-btrfs@vger.kernel.org>
References: <1484183243.10253.5.camel@scientia.net>
 <a7b82ec9-bd8d-d6bb-27e7-3732b466ca06@cn.fujitsu.com>
 <1484188092.29002.4.camel@scientia.net>
 <25993bdf-d1fe-30df-7236-b9d5d6e5cfb2@cn.fujitsu.com>
 <1484499869.17186.1.camel@scientia.net>
 <4d7e21ed-a8f6-6c75-4a14-ff43201bd27b@cn.fujitsu.com>
 <1484535383.7577.53.camel@scientia.net>
 <657ea421-0058-b641-ef31-c7d371fa58ca@cn.fujitsu.com>
 <1484542415.21166.1.camel@scientia.net>
 <a0aad88a-e19e-e013-7533-4a5bf0783763@cn.fujitsu.com>
 <1484604435.7086.22.camel@scientia.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5c66c74f-3c6d-b296-32ea-9263848ea16f@cn.fujitsu.com>
Date: Tue, 17 Jan 2017 16:53:19 +0800
MIME-Version: 1.0
In-Reply-To: <1484604435.7086.22.camel@scientia.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 01/17/2017 06:07 AM, Christoph Anton Mitterer wrote:
> On Mon, 2017-01-16 at 13:47 +0800, Qu Wenruo wrote:
>>>> And I highly suspect if the subvolume 6403 is the RO snapshot you
>>>> just removed.
>>>
>>> I guess there is no way to find out whether it was that snapshot,
>>> is
>>> there?
>>
>> "btrfs subvolume list" could do it."
> Well that was clear,... but I rather meant something that also shows me
> the path of the deleted subvol.

Deleted subvol lost its ROOT_BACKREF, so there is no info where that 
subvolume used to be.

> Anyway:
> # btrfs subvolume list /data/data-a/3/
> ID 6029 gen 2528 top level 5 path data
> ID 6031 gen 3208 top level 5 path backups
> ID 7285 gen 3409 top level 5 path snapshots/_external-fs/data-a1/data/2017-01-11_1
>
> So since I only had two further snapshots in snapshots/_external-
> fs/data-a1/data/ it must be the deleted one.
>
> btw: data is empty, and backup contains actually some files (~25k,
> ~360GB)... these are not created via send/receive, but either via cp or
> rsync.
> And they are always in the same subvol (i.e. the backups svol isn't
> deleted like the snaphots are)
>
>
>> Also checked the extent tree, the result is a little interesting:
>> 1) Most tree backref are good.
>>     In fact, 3 of all the 4 errors reported are tree blocks shared by
>>     other subvolumes, like:
>>
>> item 77 key (51200000 METADATA_ITEM 1) itemoff 13070 itemsize 42
>> 		extent refs 2 gen 11 flags TREE_BLOCK|FULL_BACKREF
>> 		tree block skinny level 1
>> 		tree block backref root 7285
>> 		tree block backref root 6572
>>
>> This means the tree blocks are share by 2 other subvolumes,
>> 7285 and 6572.
>>
>> 7285 subvolume is completely OK, while 6572 is also undergoing
>> subvolume
>> deletion(while real deletion doesn't start yet).
> Well there were in total three snapshots, the still existing:
> snapshots/_external-fs/data-a1/data/2017-01-11_1
> and two earlier ones,
> one from around 2016-09-16_1 (= probably ID 6572?), one even a bit
> earlier from 2016-08-19_1 (probably ID 6403?).
> Each one was created with
> send -p | receive, using the respectively earlier one as parent.
> So it's
> quite reasonable that they share the extents and also that it'sby 2
> subvols.
>
>
>
>> And considering the generation, I assume 6403 is deleted before 6572.
> Don't remember which one of the 2 subvols form 2016 I've deleted first,
> the older or the more recent one... my bash history implies in this
> order:
>  4203  btrfs subvolume delete 2016-08-19_1
>  4204  btrfs subvolume delete 2016-09-16_1
>
>
>> So we're almost clear that, btrfs (maybe only btrfsck) doesn't handle
>> it
>> well if there are multiple subvolume undergoing deletion.
>>
>> This gives us enough info to try to build such image by ourselves
>> now.
>> (Although still quite hard to do though).
> Well keep me informed if you actually find/fix something  :)
>
>
>> And for the scary lowmem mode, it's false alert.
>>
>> I manually checked the used size of a block group and it's OK.
> So you're going to fix this?

Yes, digging now.
The lowmem mode bug should be much easier to fix, compared to the lost 
backref false alert.

>
>
>> BTW, most of your block groups are completely used, without any
>> space.
>> But interestingly, mostly data extent size are just 512K, larger than
>> compressed extent upper limit, but still quite small.
> Not sure if I understand this...
>
>
>> In other words, your fs seems to be fragmented considering the upper
>> limit of a data extent is 128M.
>> (Or your case is quite common in common world?)
> No, I don't think I understand what you mean :D
>
>
>> So you are mostly OK to mount it rw any time you want, and I have
>> already downloaded the raw data.
> Okay, I've remounted it now RW, called btrfs filesystem sync, and
> waited until the HDD became silent and showed no further activity.
>
> (again 3.9)
>
> # btrfs check /dev/nbd0 ; echo $?
> Checking filesystem on /dev/nbd0
> UUID: 326d292d-f97b-43ca-b1e8-c722d3474719
> checking extents
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> found 7469206884352 bytes used err is 0
> total csum bytes: 7281779252
> total tree bytes: 10837262336
> total fs tree bytes: 2011906048
> total extent tree bytes: 1015349248
> btree space waste bytes: 922444044
> file data blocks allocated: 7458369622016
>  referenced 7579485159424
> 0

Nice to see it.

>
>
> => as you can see, original mode pretends things would be fine now.
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
> ERROR: errors found in extent allocation tree or chunk allocation
> checking free space cache
> checking fs roots
> found 7469206884352 bytes used err is -5
> total csum bytes: 7281779252
> total tree bytes: 10837262336
> total fs tree bytes: 2011906048
> total extent tree bytes: 1015349248
> btree space waste bytes: 922444044
> file data blocks allocated: 7458369622016
>  referenced 7579485159424
> 1
>
> => but lomem mode finds quite some errors... actually it seems even
> worse, normally (and before with 3.9 but without having it RW mounted
> yet), the "checking fs roots" took ages (at least an hour or two... nbd
> makes it even slower)... but this time, while checking extents too also
> long, checking fs roots was extremely fast (possibly because of some
> more grave error?), and checking csums didn't even occur.
>
> What do you think... error in the fs or in fsck's lowmem mode?

Just lowmem false alert, as extent-tree dump shows complete fine result.

I'll CC you and adds your reported-by tag when there is any update on 
this case.

Thanks,
Qu
>
>
>> Hard part is remaining for us developers to build such small image
>> to
>> reproduce your situation then.
> Well... that's the life of a btrfs-dev ;-P
>
>
> Cheers,
> Chris.
>


