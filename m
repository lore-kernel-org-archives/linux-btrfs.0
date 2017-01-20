Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:12485 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751377AbdATH76 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jan 2017 02:59:58 -0500
Subject: Re: [PATCH] btrfs-progs: lowmem-check: Fix wrong extent tree
 iteration
To: Christoph Anton Mitterer <calestyo@scientia.net>
References: <20170118084838.27102-1-quwenruo@cn.fujitsu.com>
 <1484845829.6821.5.camel@scientia.net>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <f63d9d82-750b-8ecc-c71a-3601468b47c9@cn.fujitsu.com>
Date: Fri, 20 Jan 2017 15:58:47 +0800
MIME-Version: 1.0
In-Reply-To: <1484845829.6821.5.camel@scientia.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 01/20/2017 01:10 AM, Christoph Anton Mitterer wrote:
> Hey Qu.
>
>
> On Wed, 2017-01-18 at 16:48 +0800, Qu Wenruo wrote:
>> To Christoph,
>>
>> Would you please try this patch, and to see if it suppress the block
>> group
>> warning?
> I did another round of fsck in both modes (original/lomem), first
> WITHOUT your patch, then WITH it... both on progs version 4.9... no
> further RW mount between these 4 runs:
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
> found 7469206884352 bytes used err is 0
> total csum bytes: 7281779252
> total tree bytes: 10837262336
> total fs tree bytes: 2011906048
> total extent tree bytes: 1015349248
> btree space waste bytes: 922444044
> file data blocks allocated: 7458369622016
>  referenced 7579485159424
> 0
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
> ERROR: block group[8116980678656 1073741824] used 1073217536 but extent items used 0
> ERROR: errors found in extent allocation tree or chunk allocation
> checking free space cache
> checking fs roots
> Checking filesystem on /dev/nbd0
> UUID: 326d292d-f97b-43ca-b1e8-c722d3474719
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
>
> => so the problem still shows up when unpatched
>
>
> btrfs-progs v4.9 WITH patch:
> ****************************
> # btrfs check /dev/nbd0 ; echo $?
> checking extents
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> Checking filesystem on /dev/nbd0
> UUID: 326d292d-f97b-43ca-b1e8-c722d3474719
> found 7469206884352 bytes used err is 0
> total csum bytes: 7281779252
> total tree bytes: 10837262336
> total fs tree bytes: 2011906048
> total extent tree bytes: 1015349248
> btree space waste bytes: 922444044
> file data blocks allocated: 7458369622016
>  referenced 7579485159424
> 0
>
> # btrfs check --mode=lowmem /dev/nbd0 ; echo $?
> checking extents
> checking free space cache
> checking fs roots
> Checking filesystem on /dev/nbd0
> UUID: 326d292d-f97b-43ca-b1e8-c722d3474719
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
> => so the original mode output is identical, but while lowmem mode no
> longer prints so many errors there's now a:
>> found 7469206884352 bytes used err is -5
> and exit code 1

Nice to hear that, although the -5 error seems to be caught incorrectly.

I'll locate the problem and then send the patch.

Thanks for your testing!
Qu

>
>
> Cheers,
> Chris.
>


