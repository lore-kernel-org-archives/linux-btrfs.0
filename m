Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:17191 "EHLO
	mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932321AbcFUA4U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jun 2016 20:56:20 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by yt-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id CD79FAC00A3
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Jun 2016 09:56:14 +0900 (JST)
Subject: Re: Confusing output from fi us/df
To: Marc Grondin <marcfgrondin@gmail.com>, linux-btrfs@vger.kernel.org
References: <29fb52eb-9aed-5d12-1631-0a8d776fb69c@gmail.com>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <d260af09-2cce-51b9-6d8a-8dc3ecf13317@jp.fujitsu.com>
Date: Tue, 21 Jun 2016 09:55:46 +0900
MIME-Version: 1.0
In-Reply-To: <29fb52eb-9aed-5d12-1631-0a8d776fb69c@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016/06/21 8:30, Marc Grondin wrote:
> Hi everyone,
> 
> 
> I have a btrfs filesystem ontop of a 4x1tb mdraid raid5 array and I've
> been getting confusing output on metadata usage. Seems that even tho
> both data and metadata are in single profile metadata is reporting
> double the space(as if it was in dupe profile)
> 
> 
> 
> root@thebeach /h/marcg> uname -a
> Linux thebeach 4.6.2-gentoo-GMAN #1 SMP Sat Jun 11 22:32:27 ADT 2016
> x86_64 Intel(R) Core(TM) i5-2320 CPU @ 3.00GHz GenuineIntel GNU/Linux
> root@thebeach /h/marcg> btrfs --version
> btrfs-progs v4.5.3
> root@thebeach /h/marcg> btrfs fi us /media/Storage2
> Overall:
> Device size: 2.73TiB
> Device allocated: 1.71TiB
> Device unallocated: 1.02TiB
> Device missing: 0.00B
> Used: 1.38TiB
> Free (estimated): 1.34TiB (min: 1.34TiB)
> Data ratio: 1.00
> Metadata ratio: 1.00
> Global reserve: 512.00MiB (used: 0.00B)
> 
> 
> Data,single: Size:1.71TiB, Used:1.38TiB
> /dev/mapper/storage2 1.71TiB
> 
> 
> Metadata,single: Size:3.00GiB, Used:1.53GiB
> /dev/mapper/storage2 3.00GiB
> 
> 
> System,single: Size:32.00MiB, Used:208.00KiB
> /dev/mapper/storage2 32.00MiB
> 
> 
> Unallocated:
> /dev/mapper/storage2 1.02TiB
> root@thebeach /h/marcg> btrfs fi df /media/Storage2
> Data, single: total=1.71TiB, used=1.38TiB
> System, single: total=32.00MiB, used=208.00KiB
> Metadata, single: total=3.00GiB, used=1.53GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> root@thebeach /h/marcg>
> 
> 
> I'm not sure if this is known and if it's btrfs-progs related or if it
> is actually allocating that space.

Could you tell me the location where you think
metadata is reporting double the space?

from fi us:
> Metadata,single: Size:3.00GiB, Used:1.53GiB
> /dev/mapper/storage2 3.00GiB

from fi df:
> Metadata,single: Size:3.00GiB, Used:1.53GiB
> /dev/mapper/storage2 3.00GiB

As far as I can see, Btrfs just allocates 3.00 GiB
from /dev/mapper/storage2, Metadata,single size is
the same as it (not double), and 1.53 GiB is used.


The following is in my case where data is single
and meta is dup.

from fi us:
Metadata,DUP: Size:384.00MiB, Used:221.36MiB
   /dev/vda3     768.00MiB

from fi df:
Metadata, DUP: total=384.00MiB, used=221.36MiB

Here Btrfs allocates 768.0MiB from /dev/vda3 and it's
twice as large as the size of Metadata,DUP(384.00MiB).
I guess it means that "metadata is reporting double the space"
as you said and your case it not the case.

CMIIW.

Thanks,
Satoru

> 
> 
> Thank you for reading.
> 
> 
> Marc
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
