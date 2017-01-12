Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45693 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751517AbdALCiu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jan 2017 21:38:50 -0500
Subject: Re: corruption: yet another one after deleting a ro snapshot
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        <linux-btrfs@vger.kernel.org>
References: <1484183243.10253.5.camel@scientia.net>
 <a7b82ec9-bd8d-d6bb-27e7-3732b466ca06@cn.fujitsu.com>
 <1484188092.29002.4.camel@scientia.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <25993bdf-d1fe-30df-7236-b9d5d6e5cfb2@cn.fujitsu.com>
Date: Thu, 12 Jan 2017 10:38:41 +0800
MIME-Version: 1.0
In-Reply-To: <1484188092.29002.4.camel@scientia.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 01/12/2017 10:28 AM, Christoph Anton Mitterer wrote:
> Hey Qu,
>
> On Thu, 2017-01-12 at 09:25 +0800, Qu Wenruo wrote:
>> And since you just deleted a subvolume and unmount it soon
> Indeed, I unmounted it pretty quickly afterwards...
>
> I had mounted it (ro) in the meantime, and did a whole
> find mntoint > /dev/null
> on it just to see whether going through the file hierarchy causes any
> kernel errors already.
> There are about 1,2 million files on the fs (in now only one snapshot)
> and that took some 3-5 mins...
> Not sure whether it continues to delete the subvol when it's mounted
> ro... if so, it would have had some time.

IIRC, RO mount won't continue background deletion.

So the fsck result won't change.
>
> However, another fsck afterwards:
> # btrfs check /dev/mapper/data-a3 ; echo $?
> Checking filesystem on /dev/mapper/data-a3
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
>> , I assume
>> the
>> btrfs is still doing background subvolume deletion, maybe it's just
>> a
>> false alert from btrfsck.
> If one deleted a subvol and unmounts too fast, will this already cause
> a corruption or does btrfs simply continue to cleanup during the next
> time(s) it's mounted?

It will continue the deletion on next RW mount.

But, I'm still not sure whether it's a false alert or a *REAL* corruption.

Even it may cause problem and corrupt your data, I still hope you could 
do a rw mount and trigger a btrfs fi sync.

If it's a false alert, we can fix it then with ease.
Or, it's a really big problem.

>
>
>
>> Would you please try btrfs check --mode=lowmem using latest btrfs-
>> progs?
> Here we go, however still with v4.7.3:
>
> # btrfs check --mode=lowmem /dev/mapper/data-a3 ; echo $?
> Checking filesystem on /dev/mapper/data-a3
> UUID: 326d292d-f97b-43ca-b1e8-c722d3474719
> checking extents
> ERROR: block group[74117545984 1073741824] used 1073741824 but extent items used 0

Errr, lowmem mode is much restrict on this case then.
Quite some block groups has mismatch used space.

But according to the same used number, I assume it's a lowmmem mode bug.

Would you please try 4.9 btrfs-progs?

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

So same missing backref.
It's quite possible a kernel bug then.

> ERROR: check node failed root 6403 bytenr 5960381235200 level 1, force continue check
> ERROR: extent[51200000 16384] backref lost (owner: 257, level: 1)
> ERROR: check node failed root 6403 bytenr 51200000 level 1, force continue check
> ERROR: extent[37765120 16384] backref lost (owner: 257, level: 1)
> ERROR: check node failed root 6403 bytenr 37765120 level 1, force continue check
> ERROR: extent[78135296 16384] backref lost (owner: 257, level: 1)
> ERROR: check node failed root 6403 bytenr 78135296 level 1, force continue check
> Errors found in extent allocation tree or chunk allocation
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> found 7483995758592 bytes used err is 0
> total csum bytes: 7296183880
> total tree bytes: 11018780672
> total fs tree bytes: 2178121728
> total extent tree bytes: 1015988224
> btree space waste bytes: 936782513
> file data blocks allocated: 9157658292224
>  referenced 9292573106176
> 0
>
>
> btw: even if these may be false positives... shouldn't btrfs-check
> return non-zero in any case an error might have been found?! Seems like
> another bug...

IIRC it's fixed in latest btrfs-progs.
So it's always recommended to use latest btrfs-progs.

Thanks,
Qu

>
>
>
> For policy reasons here it's a bit problematic to simply compile my own
>  btrfs-progs from git master... so I could either go leave it with just
> 4.7.3 (which is probably little helpful for you) and mount the fs now
> rw for a while, see whether the errors still occur after say 15 mins
> (where it should have had time to delete the subvol)... or  we shelve
> this until 4.9.something hit Debian.
> What would you prefer?
>
>
>> And it's also recommended to call btrfs fi sync, then wait for some
>> time
>> (depending on the subvolume size) to allow btrfs to fully delete the
>> subvolume, then try btrfsck.
>
> Shouldn't it do these things automatically on unmount (or probably even
> remount,ro)?!
> I mean a normal user will never know about the necessity of these
> steps,... and "some time" is also pretty unspecific even if one knows
> about it.
>
>
> Cheers,
> Chris.
>


