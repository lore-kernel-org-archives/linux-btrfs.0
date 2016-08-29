Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64503 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932946AbcH2MQj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Aug 2016 08:16:39 -0400
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
To: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>,
        <linux-btrfs@vger.kernel.org>
References: <1471023419.16857.9.camel@gmail.com>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <57C426AB.3020607@cn.fujitsu.com>
Date: Mon, 29 Aug 2016 20:12:27 +0800
MIME-Version: 1.0
In-Reply-To: <1471023419.16857.9.camel@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hello,

On 08/13/2016 01:36 AM, Ronan Arraes Jardim Chagas wrote:
> Hi guys,
>
> I'm facing a daily problem with BTRFS. Almost everyday, I get the
> message "No space left on device". Sometimes I can recover by balancing
> the system but sometimes even balancing does not work due to the lack
> of space. In this case, only a hard reset works if I can't delete some
> files. The problem is that I have a huge unallocated space as you can
> see here:
>
> # btrfs fi usage /
> Overall:
>      Device size:		   1.26TiB
>      Device allocated:		 119.07GiB
>      Device unallocated:		   1.14TiB
>      Device missing:		     0.00B
>      Used:			 115.08GiB
>      Free (estimated):		   1.14TiB	(min: 586.21GiB)
>      Data ratio:			      1.00
>      Metadata ratio:		      2.00
>      Global reserve:		 512.00MiB	(used: 0.00B)
>
> Data,single: Size:113.01GiB, Used:111.19GiB
>     /dev/sda6	 113.01GiB
>
> Metadata,DUP: Size:3.00GiB, Used:1.94GiB
>     /dev/sda6	   6.00GiB
>
> System,DUP: Size:32.00MiB, Used:16.00KiB
>     /dev/sda6	  64.00MiB
>
> Unallocated:
>     /dev/sda6	   1.14TiB
>
> It is not easy to trigger the problem. But I do find some correlation
> between two things:
>
> 1) When I started to create jails to build openSUSE packages locally,
> then the problem happens more often. In these jails, some directories
> like /dev/, /dev/pts, /proc, are mounted inside the jail.
>
> 2) When I open my KVM, I also see this problem more often. Notice,
> however, that the KVM disk is stored in another EXT4 partition.
>
> I would be glad if anyone can help me to fix it. In the following, I'm
> providing more information about my system:
>
> # uname -a
> Linux ronanarraes-osd 4.7.0-1-default #1 SMP PREEMPT Mon Jul 25
> 08:42:47 UTC 2016 (89a2ada) x86_64 x86_64 x86_64 GNU/Linux
>
> # btrfs --version
> btrfs-progs v4.6.1+20160714
>
> # btrfs fi show
> Label: none  uuid: 80381f7f-8cef-4bd8-bdbc-3487253ee566
> 	Total devices 1 FS bytes used 113.13GiB
> 	devid    1 size 1.26TiB used 119.07GiB path /dev/sda6
>
> # btrfs fi df /
> Data, single: total=113.01GiB, used=111.19GiB
> System, DUP: total=32.00MiB, used=16.00KiB
> Metadata, DUP: total=3.00GiB, used=1.94GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
When strange ENOSPC errors occur, I think "btrfs fi usage"
or "btrfs di df" do not help too much. Their output do not
reflect btrfs kernel current status :)

Would you please provide attribute files' values in 
/sys/fs/btrfs/$UUID/allocation/data
and /sys/fs/btrfs/$UUID/allocation/metadata when ENOSPC error occurs.

Regards,
Xiaoguang Wang

>
> Regards,
> Ronan Arraes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>



