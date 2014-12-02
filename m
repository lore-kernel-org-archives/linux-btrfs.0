Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8662 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932150AbaLBBdj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 20:33:39 -0500
Message-ID: <547D16F0.60809@cn.fujitsu.com>
Date: Tue, 2 Dec 2014 09:33:36 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Peter Volkov <pva@gentoo.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs stuck with lot's of files
References: <1417434411.20237.1.camel@gentoo.org>
In-Reply-To: <1417434411.20237.1.camel@gentoo.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: btrfs stuck with lot's of files
From: Peter Volkov <pva@gentoo.org>
To: linux-btrfs@vger.kernel.org <linux-btrfs@vger.kernel.org>
Date: 2014年12月01日 19:46
> Hi, guys.
>
> We have a problem with btrfs file system: sometimes it became stuck
> without leaving me any way to interrupt it (shutdown -r now is unable to
> restart server). By stuck I mean some processes that previously were
> able to write on disk are unable to cope with load and load average goes
> up:
>
> top - 13:10:58 up 1 day,  9:26,  5 users,  load average: 157.76, 156.61,
> 149.29
> Tasks: 235 total,   2 running, 233 sleeping,   0 stopped,   0 zombie
> %Cpu(s): 19.8 us, 15.0 sy,  0.0 ni, 60.7 id,  3.9 wa,  0.0 hi,  0.6 si,
> 0.0 st
> KiB Mem:  65922104 total, 65414856 used,   507248 free,     1844 buffers
> KiB Swap:        0 total,        0 used,        0 free. 62570804 cached
> Mem
>
>    PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+
> COMMAND
>   8644 root      20   0       0      0      0 R  96.5  0.0 127:21.95
> kworker/u16:16
>   5047 dvr       20   0 6884292 122668   4132 S   6.4  0.2 258:59.49
> dvrserver
> 30223 root      20   0   20140   2600   2132 R   6.4  0.0   0:00.01
> top
>      1 root      20   0    4276   1628   1524 S   0.0  0.0   0:40.19
> init
>
>
>
> There are about 300 treads on server, some of which are writing on disk.
> A bit information about this btrfs filesystem: this is 22 disk file
> system with raid1 for metadata and raid0 for data:
>
>   # btrfs filesystem df /store/
> Data, single: total=11.92TiB, used=10.86TiB
> System, RAID1: total=8.00MiB, used=1.27MiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, RAID1: total=46.00GiB, used=33.49GiB
> Metadata, single: total=8.00MiB, used=0.00B
> GlobalReserve, single: total=512.00MiB, used=128.00KiB
>   # btrfs property get /store/
> ro=false
> label=store
>   # btrfs device stats /store/
> (shows all zeros)
>   # btrfs balance status /store/
> No balance found on '/store/'
>   # btrfs filesystem show /store/
> Btrfs v3.17.1
> (btw, is it supposed to have only version here?)
This is a small bug that if there is appending '/' in the path for 
'btrfs fi show', it can't recognize it....
Patch is already sent and maybe included next version.
>
> As for load we write quite small files of size (some of 313K, some of
> 800K), that's why metadata takes that much. So back to the problem.
> iostat 1 exposes following problem:
>
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            16.96    0.00   17.09   65.95    0.00    0.00
>
> Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
> sda               0.00         0.00         0.00          0          0
> sdc               0.00         0.00         0.00          0          0
> sdb               0.00         0.00         0.00          0          0
> sde               0.00         0.00         0.00          0          0
> sdd               0.00         0.00         0.00          0          0
> sdf               0.00         0.00         0.00          0          0
> sdg               0.00         0.00         0.00          0          0
> sdj               0.00         0.00         0.00          0          0
> sdh               0.00         0.00         0.00          0          0
> sdk               0.00         0.00         0.00          0          0
> sdi               1.00         0.00       200.00          0        200
> sdl               0.00         0.00         0.00          0          0
> sdn              48.00         0.00     17260.00          0      17260
> sdm               0.00         0.00         0.00          0          0
> sdp               0.00         0.00         0.00          0          0
> sdo               0.00         0.00         0.00          0          0
> sdq               0.00         0.00         0.00          0          0
> sdr               0.00         0.00         0.00          0          0
> sds               0.00         0.00         0.00          0          0
> sdt               0.00         0.00         0.00          0          0
> sdv               0.00         0.00         0.00          0          0
> sdw               0.00         0.00         0.00          0          0
> sdu               0.00         0.00         0.00          0          0
>
>
> write goes to one disk. I've tried to debug what's going in kworker and
> did
>
> $ echo workqueue:workqueue_queue_work
>> /sys/kernel/debug/tracing/set_event
> $ cat /sys/kernel/debug/tracing/trace_pipe > trace_pipe.out2
>
> trace_pipe2.out.xz in attachment. Could you comment, what goes wrong
> here?
It seems that attachment is blocked by mail-list so I didn't see the 
attachment.
>
> Server has 64Gb of RAM. Is it possible that it is unable to keep all
> metadata in memory, can we encrease this memory limit, if exists?
Not possible, it will never happen (if nothing goes wrong....).
Kernel has the outstanding page cache mechanism, when memory comes short,
some cached metadata/data can be flushed back(if dirty) to disk to free 
space.
And re-read from disk if needed later.

So kernel don't need to load all the metadata/data into memory, and 
that's mostly impossible for large fs.

And one missing important informantion: kernel version.

What I can see is only the btrfs-progs version, which doesn't really 
help for such kernel stuck problem.

Thanks,
Qu
>
>
> Thanks in advance for any pointers,
> --
> Peter.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

