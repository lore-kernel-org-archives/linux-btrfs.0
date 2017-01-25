Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5765 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750966AbdAYAqs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jan 2017 19:46:48 -0500
Subject: Re: [PATCH 0/9] Lowmem mode fsck fixes with fsck-tests framework
 update
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        <linux-btrfs@vger.kernel.org>
References: <20170123091359.21390-1-quwenruo@cn.fujitsu.com>
 <1485276845.12065.1.camel@scientia.net>
CC: <chris@colorremedies.com>, <dsterba@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <35be430d-1210-9b33-3b18-c22127cc64a7@cn.fujitsu.com>
Date: Wed, 25 Jan 2017 08:44:03 +0800
MIME-Version: 1.0
In-Reply-To: <1485276845.12065.1.camel@scientia.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 01/25/2017 12:54 AM, Christoph Anton Mitterer wrote:
> Hey Qu.
>
> I was giving your patches a try, again on the very same fs (which saw
> however writes in the meantime), from my initial report.
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
>
> => so the fs would still show the symptoms
>
>
> Then, with no RW mount to the fs in between, 4.9 with the following of
> your patches:
> 0001-btrfs-progs-lowmem-check-Fix-wrong-block-group-check.patch
> 0003-btrfs-progs-fsck-Output-verbose-error-when-fsck-foun.patch
> 0004-btrfs-progs-lowmem-check-Fix-false-alert-in-checking.patch
> 0005-btrfs-progs-lowmem-check-Fix-extent-item-size-false-.patch
> the others were anyway just tests related, AFAICS.
>
> btrfs-progs v4.9 WITH patches:
> ****************************
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
>
> => bon!
>
> # btrfs check --mode=lowmem /dev/nbd0 ; echo $?
> checking extents
> checking free space cache
> checking fs roots
> ERROR: root 6031 EXTENT_DATA[277 524288] datasum missing

There must be some hidden corner case I didn't cover.

Considering lowmem mode check functions are quite independent to each 
other, I think I could find out the reason just using the error output.

Thanks for the test,
Qu

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
> => some new errors :-(
> Not sure though, whether this is an issue in your patch or a new
> problem due to my writes (I did just another round of incremental send
> -p/receive)
>
>
> Any ideas?
>
>
> Best,
> Chris.
>


