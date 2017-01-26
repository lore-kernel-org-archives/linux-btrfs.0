Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:3329 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752453AbdAZDKu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jan 2017 22:10:50 -0500
Subject: Re: [PATCH 0/9] Lowmem mode fsck fixes with fsck-tests framework
 update
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        <linux-btrfs@vger.kernel.org>
References: <20170123091359.21390-1-quwenruo@cn.fujitsu.com>
 <1485276845.12065.1.camel@scientia.net>
 <35be430d-1210-9b33-3b18-c22127cc64a7@cn.fujitsu.com>
 <1485305208.12065.9.camel@scientia.net>
 <8d21a04e-7035-5b5d-5b58-9ac0d7f93f02@cn.fujitsu.com>
 <1485399036.23328.7.camel@scientia.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <bb42c075-fcbd-2248-8e9f-ea5d2a836273@cn.fujitsu.com>
Date: Thu, 26 Jan 2017 11:10:34 +0800
MIME-Version: 1.0
In-Reply-To: <1485399036.23328.7.camel@scientia.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for your patient and the test!

At 01/26/2017 10:50 AM, Christoph Anton Mitterer wrote:
> On Wed, 2017-01-25 at 12:16 +0800, Qu Wenruo wrote:
>> https://github.com/adam900710/btrfs-progs/tree/lowmem_fixes
>
> Just finished trying your new patches.
>
> Same game as last time, applied to 4.9, no RW mount between the runs.
>
>
> btrfs-progs v4.9 WITHOUT patch:
> *******************************
> # btrfs check /dev/nbd0 ; echo $?
> checking extents
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> Checking filesystem on /dev/nbd0
> UUID: 326d292d-f97b-43ca-b1e8-c722d3474719
> found 7519512838144 bytes used err is 0
> total csum bytes: 7330834320
> total tree bytes: 10902437888
> total fs tree bytes: 2019704832
> total extent tree bytes: 1020149760
> btree space waste bytes: 925714197
> file data blocks allocated: 7509228494848
>  referenced 7630551511040
> 0
>
>
> # btrfs check --mode=lowmem /dev/nbd0 ; echo $?
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
> ERROR: block group[8116980678656 1073741824] used 1073741824 but extent items used 0
> ERROR: errors found in extent allocation tree or chunk allocation
> checking free space cache
> checking fs roots
> Checking filesystem on /dev/nbd0
> UUID: 326d292d-f97b-43ca-b1e8-c722d3474719
> found 7519512838144 bytes used err is -5
> total csum bytes: 7330834320
> total tree bytes: 10902437888
> total fs tree bytes: 2019704832
> total extent tree bytes: 1020149760
> btree space waste bytes: 925714197
> file data blocks allocated: 7509228494848
>  referenced 7630551511040
> 1

In fact, the result without patches is not really needed for current stage.

Feel free to skip them until the patched ones passed.
Which should save you some time.

>
> btrfs-progs v4.9 WITH patches:
> ******************************
> # btrfs check /dev/nbd0 ; echo $?
> checking extents
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> Checking filesystem on /dev/nbd0
> UUID: 326d292d-f97b-43ca-b1e8-c722d3474719
> found 7519512838144 bytes used, no error found
> total csum bytes: 7330834320
> total tree bytes: 10902437888
> total fs tree bytes: 2019704832
> total extent tree bytes: 1020149760
> btree space waste bytes: 925714197
> file data blocks allocated: 7509228494848
>  referenced 7630551511040
> 0

Same for original mode.

>
> # btrfs check --mode=lowmem /dev/nbd0 ; echo $?
> checking extents
> checking free space cache
> checking fs roots
> ERROR: root 6031 EXTENT_DATA[277 524288] datasum missing
> ERROR: errors found in fs roots
> Checking filesystem on /dev/nbd0
> UUID: 326d292d-f97b-43ca-b1e8-c722d3474719
> found 7519512838144 bytes used, error(s) found
> total csum bytes: 7330834320
> total tree bytes: 10902437888
> total fs tree bytes: 2019704832
> total extent tree bytes: 1020149760
> btree space waste bytes: 925714197
> file data blocks allocated: 7509228494848
>  referenced 7630551511040
> 1
>
> => so unfortunately what seems to be the very same error than before
>
> Just tell me if you find something new :)
>
>
> Cheers,
> Chris.
>
Would you please try lowmem_tests branch of my repo?

That branch contains a special debug output for the case you 
encountered, which should help to debug the case.
pecial debug output for the case you encountered, which
Thanks,
Qu


