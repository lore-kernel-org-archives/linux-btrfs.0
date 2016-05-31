Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2517 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161880AbcEaBg3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 May 2016 21:36:29 -0400
Subject: Re: btrfs filesystem keeps allocating new chunks for no apparent
 reason
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        <linux-btrfs@vger.kernel.org>
References: <572D0C8B.8010404@mendix.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <89a684c7-364e-f409-5348-bc0077fd438c@cn.fujitsu.com>
Date: Tue, 31 May 2016 09:36:20 +0800
MIME-Version: 1.0
In-Reply-To: <572D0C8B.8010404@mendix.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Hans van Kranenburg wrote on 2016/05/06 23:28 +0200:
> Hi,
>
> I've got a mostly inactive btrfs filesystem inside a virtual machine
> somewhere that shows interesting behaviour: while no interesting disk
> activity is going on, btrfs keeps allocating new chunks, a GiB at a time.
>
> A picture, telling more than 1000 words:
> https://syrinx.knorrie.org/~knorrie/btrfs/keep/btrfs_usage_ichiban.png
> (when the amount of allocated/unused goes down, I did a btrfs balance)

Nice picture.
Really better than 1000 words.

AFAIK, the problem may be caused by fragments.

And even I saw some early prototypes inside the codes to allow btrfs do 
allocation smaller extent than required.
(E.g. caller needs 2M extent, but btrfs returns 2 1M extents)

But it's still prototype and seems no one is really working on it now.

So when btrfs is writing new data, for example, to write about 16M data, 
it will need to allocate a 16M continuous extent, and if it can't find 
large enough space to allocate, then create a new data chunk.

Despite the already awesome chunk level usage pricutre, I hope there is 
info about extent level allocation to confirm my assumption.

You could dump it by calling "btrfs-debug-tree -t 2 <device>".
It's normally recommended to do it unmounted, but it's still possible to 
call it mounted, although not 100% perfect though.
(Then I'd better find a good way to draw a picture of 
allocate/unallocate space and how fragments the chunks are)

Thanks,
Qu
>
> Linux ichiban 4.5.0-0.bpo.1-amd64 #1 SMP Debian 4.5.1-1~bpo8+1
> (2016-04-20) x86_64 GNU/Linux
>
> # btrfs fi show /
> Label: none  uuid: 9881fc30-8f69-4069-a8c8-c057b842b0c4
>     Total devices 1 FS bytes used 6.17GiB
>     devid    1 size 20.00GiB used 16.54GiB path /dev/xvda
>
> # btrfs fi df /
> Data, single: total=15.01GiB, used=5.16GiB
> System, single: total=32.00MiB, used=16.00KiB
> Metadata, single: total=1.50GiB, used=1.01GiB
> GlobalReserve, single: total=144.00MiB, used=0.00B
>
> I'm a bit puzzled, since I haven't seen this happening on other
> filesystems that use 4.4 or 4.5 kernels.
>
> If I dump the allocated chunks and their % usage, it's clear that the
> last 6 new added ones have a usage of only a few percent.
>
> dev item devid 1 total bytes 21474836480 bytes used 17758683136
> chunk vaddr 12582912 type 1 stripe 0 devid 1 offset 12582912 length
> 8388608 used 4276224 used_pct 50
> chunk vaddr 1103101952 type 1 stripe 0 devid 1 offset 2185232384 length
> 1073741824 used 433127424 used_pct 40
> chunk vaddr 3250585600 type 1 stripe 0 devid 1 offset 4332716032 length
> 1073741824 used 764391424 used_pct 71
> chunk vaddr 9271508992 type 1 stripe 0 devid 1 offset 12079595520 length
> 1073741824 used 270704640 used_pct 25
> chunk vaddr 12492734464 type 1 stripe 0 devid 1 offset 13153337344
> length 1073741824 used 866574336 used_pct 80
> chunk vaddr 13566476288 type 1 stripe 0 devid 1 offset 11005853696
> length 1073741824 used 1028059136 used_pct 95
> chunk vaddr 14640218112 type 1 stripe 0 devid 1 offset 3258974208 length
> 1073741824 used 762466304 used_pct 71
> chunk vaddr 26250051584 type 1 stripe 0 devid 1 offset 19595788288
> length 1073741824 used 114982912 used_pct 10
> chunk vaddr 31618760704 type 1 stripe 0 devid 1 offset 15300820992
> length 1073741824 used 488902656 used_pct 45
> chunk vaddr 32692502528 type 4 stripe 0 devid 1 offset 5406457856 length
> 268435456 used 209272832 used_pct 77
> chunk vaddr 32960937984 type 4 stripe 0 devid 1 offset 5943328768 length
> 268435456 used 251199488 used_pct 93
> chunk vaddr 33229373440 type 4 stripe 0 devid 1 offset 7419723776 length
> 268435456 used 248709120 used_pct 92
> chunk vaddr 33497808896 type 4 stripe 0 devid 1 offset 8896118784 length
> 268435456 used 247791616 used_pct 92
> chunk vaddr 33766244352 type 4 stripe 0 devid 1 offset 8627683328 length
> 268435456 used 93061120 used_pct 34
> chunk vaddr 34303115264 type 2 stripe 0 devid 1 offset 6748635136 length
> 33554432 used 16384 used_pct 0
> chunk vaddr 34336669696 type 1 stripe 0 devid 1 offset 16374562816
> length 1073741824 used 105054208 used_pct 9
> chunk vaddr 35410411520 type 1 stripe 0 devid 1 offset 20971520 length
> 1073741824 used 10899456 used_pct 1
> chunk vaddr 36484153344 type 1 stripe 0 devid 1 offset 1094713344 length
> 1073741824 used 441778176 used_pct 41
> chunk vaddr 37557895168 type 4 stripe 0 devid 1 offset 5674893312 length
> 268435456 used 33439744 used_pct 12
> chunk vaddr 37826330624 type 1 stripe 0 devid 1 offset 9164554240 length
> 1073741824 used 32096256 used_pct 2
> chunk vaddr 38900072448 type 1 stripe 0 devid 1 offset 14227079168
> length 1073741824 used 40140800 used_pct 3
> chunk vaddr 39973814272 type 1 stripe 0 devid 1 offset 17448304640
> length 1073741824 used 58093568 used_pct 5
> chunk vaddr 41047556096 type 1 stripe 0 devid 1 offset 18522046464
> length 1073741824 used 119701504 used_pct 11
>
> The only things this host does is
>  1) being a webserver for a small internal debian packages repository
>  2) running low-volume mailman with a few lists, no archive-gzipping
> mega cronjobs or anything enabled.
>  3) some little legacy php thingies
>
> Interesting fact is that most of the 1GiB increases happen at the same
> time as cron.daily runs. However, there's only a few standard things in
> there. An occasional package upgrade by unattended-upgrade, or some
> logrotate. The total contents of /var/log/ together is only 66MB...
> Graphs show only less than about 100 MB reads/writes in total around
> this time.
>
> As you can see in the graph the amount of used space is even decreasing,
> because I cleaned up a bunch of old packages in the repository, and
> still, btrfs keeps allocating new data chunks like a hungry beast.
>
> Why would this happen?
>
> Hans van Kranenburg
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


