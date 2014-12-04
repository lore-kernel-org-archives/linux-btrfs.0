Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:56795 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751825AbaLDW6g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Dec 2014 17:58:36 -0500
Received: from i7.lan (unknown [77.41.115.136])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: pva)
	by smtp.gentoo.org (Postfix) with ESMTPSA id B0B7F340587
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Dec 2014 22:58:35 +0000 (UTC)
Message-ID: <1417733909.6853.17.camel@gentoo.org>
Subject: Reiterate: btrfs stuck with lot's of files
From: Peter Volkov <pva@gentoo.org>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Fri, 05 Dec 2014 01:58:29 +0300
In-Reply-To: <547D16F0.60809@cn.fujitsu.com>
References: <1417434411.20237.1.camel@gentoo.org>
	 <547D16F0.60809@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, guys again. Looking at this issue, I suspect this is bug in btrfs.
We'll have to clean up this installation soon, so if there is any
request to do some debugging, please, ask. I'll try to reiterate what
was said in this thread.

Short story: btrfs filesystem made of 22 1Tb disks with lot's of files
(~30240000). Write load is 25 Mbyte/second. After some time file system
became unable to cope with this load. Also at this time `sync` takes
ages to finish, shutdown -r hangs (I guess related to sync).

Also I see there is one some kernel kworker that is main suspect for
this behavior: all the time it takes 100% of CPU core, jumping from core
to core. At the same time according to iostat write/read speed is close
to zero and everything is stuck.

Siting some details from previous messages:

> > top - 13:10:58 up 1 day,  9:26,  5 users,  load average: 157.76, 156.61, 149.29
> > Tasks: 235 total,   2 running, 233 sleeping,   0 stopped,   0 zombie
> > %Cpu(s): 19.8 us, 15.0 sy,  0.0 ni, 60.7 id,  3.9 wa,  0.0 hi,  0.6 si, 0.0 st
> > KiB Mem:  65922104 total, 65414856 used,   507248 free,     1844 buffers
> > KiB Swap:        0 total,        0 used,        0 free. 62570804 cached Mem
> >
> >    PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+
> > COMMAND
> >   8644 root      20   0       0      0      0 R  96.5  0.0 127:21.95 kworker/u16:16
> >   5047 dvr       20   0 6884292 122668   4132 S   6.4  0.2 258:59.49 dvrserver
> > 30223 root      20   0   20140   2600   2132 R   6.4  0.0   0:00.01 top
> >      1 root      20   0    4276   1628   1524 S   0.0  0.0   0:40.19 init
> >
> > There are about 300 treads on server, some of which are writing on disk.
> > A bit information about this btrfs filesystem: this is 22 disk file
> > system with raid1 for metadata and raid0 for data:
> >
> >   # btrfs filesystem df /store/
> > Data, single: total=11.92TiB, used=10.86TiB
> > System, RAID1: total=8.00MiB, used=1.27MiB
> > System, single: total=4.00MiB, used=0.00B
> > Metadata, RAID1: total=46.00GiB, used=33.49GiB
> > Metadata, single: total=8.00MiB, used=0.00B
> > GlobalReserve, single: total=512.00MiB, used=128.00KiB
> >   # btrfs property get /store/
> > ro=false
> > label=store
> >   # btrfs device stats /store/
> > (shows all zeros)
> >   # btrfs balance status /store/
> > No balance found on '/store/'

 # btrfs filesystem show
Label: 'store'  uuid: 296404d1-bd3f-417d-8501-02f8d7906bcf
	Total devices 22 FS bytes used 6.50TiB
	devid    1 size 931.51GiB used 558.02GiB path /dev/sdb
	devid    2 size 931.51GiB used 559.00GiB path /dev/sdc
	devid    3 size 931.51GiB used 559.00GiB path /dev/sdd
	devid    4 size 931.51GiB used 559.00GiB path /dev/sde
	devid    5 size 931.51GiB used 559.00GiB path /dev/sdf
	devid    6 size 931.51GiB used 559.00GiB path /dev/sdg
	devid    7 size 931.51GiB used 559.00GiB path /dev/sdh
	devid    8 size 931.51GiB used 559.00GiB path /dev/sdi
	devid    9 size 931.51GiB used 559.00GiB path /dev/sdj
	devid   10 size 931.51GiB used 559.00GiB path /dev/sdk
	devid   11 size 931.51GiB used 559.00GiB path /dev/sdl
	devid   12 size 931.51GiB used 559.00GiB path /dev/sdm
	devid   13 size 931.51GiB used 559.00GiB path /dev/sdn
	devid   14 size 931.51GiB used 559.00GiB path /dev/sdo
	devid   15 size 931.51GiB used 559.00GiB path /dev/sdp
	devid   16 size 931.51GiB used 559.00GiB path /dev/sdq
	devid   17 size 931.51GiB used 559.00GiB path /dev/sdr
	devid   18 size 931.51GiB used 559.00GiB path /dev/sds
	devid   19 size 931.51GiB used 559.00GiB path /dev/sdt
	devid   20 size 931.51GiB used 559.00GiB path /dev/sdu
	devid   21 size 931.51GiB used 559.01GiB path /dev/sdv
	devid   22 size 931.51GiB used 560.01GiB path /dev/sdw

Btrfs v3.17.1

> > iostat 1 exposes following problem:
> >
> > avg-cpu:  %user   %nice %system %iowait  %steal   %idle
> >            16.96    0.00   17.09   65.95    0.00    0.00
> >
> > Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
> > sda               0.00         0.00         0.00          0          0
> > sdc               0.00         0.00         0.00          0          0
> > sdb               0.00         0.00         0.00          0          0
> > sde               0.00         0.00         0.00          0          0
> > sdd               0.00         0.00         0.00          0          0
> > sdf               0.00         0.00         0.00          0          0
> > sdg               0.00         0.00         0.00          0          0
> > sdj               0.00         0.00         0.00          0          0
> > sdh               0.00         0.00         0.00          0          0
> > sdk               0.00         0.00         0.00          0          0
> > sdi               1.00         0.00       200.00          0        200
> > sdl               0.00         0.00         0.00          0          0
> > sdn              48.00         0.00     17260.00          0      17260
> > sdm               0.00         0.00         0.00          0          0
> > sdp               0.00         0.00         0.00          0          0
> > sdo               0.00         0.00         0.00          0          0
> > sdq               0.00         0.00         0.00          0          0
> > sdr               0.00         0.00         0.00          0          0
> > sds               0.00         0.00         0.00          0          0
> > sdt               0.00         0.00         0.00          0          0
> > sdv               0.00         0.00         0.00          0          0
> > sdw               0.00         0.00         0.00          0          0
> > sdu               0.00         0.00         0.00          0          0

At that time I saw such load profile. Write load changed from disk to
disk with time, so I do not suspect broken disk. Currently write profile
is different:
https://drive.google.com/file/d/0BygFL6N3ZVUAVmxaZ1Q5VTZpSGc/view?usp=sharing
Sometimes like above, sometimes all zero, most time load is very low.

> > write goes to one disk. I've tried to debug what's going in kworker and
> > did
> >
> > $ echo workqueue:workqueue_queue_work
> >> /sys/kernel/debug/tracing/set_event
> > $ cat /sys/kernel/debug/tracing/trace_pipe > trace_pipe.out2

I've put result here:
https://drive.google.com/file/d/0BygFL6N3ZVUAMWxCQ0tDREE1Uzg/view?usp=sharing

> > Server has 64Gb of RAM. 
kernel is 3.16.7-gentoo

--
Peter.


