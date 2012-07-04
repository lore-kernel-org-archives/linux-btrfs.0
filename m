Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35505 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240Ab2GDGx4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2012 02:53:56 -0400
Received: by wgbdr13 with SMTP id dr13so7045170wgb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Jul 2012 23:53:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FF3D27F.4070402@cn.fujitsu.com>
References: <CAMVG2stz6ED4D-YzST7V59jFsDS0gcB4cXrVd8ZTpXohRZh6Hw@mail.gmail.com>
	<CAMVG2st-qr+PpTUQB=wQ-_21h=d86=aDayb7FvFSSZf4ZyRVhQ@mail.gmail.com>
	<4FF3D27F.4070402@cn.fujitsu.com>
Date: Wed, 4 Jul 2012 14:53:54 +0800
Message-ID: <CAMVG2suP+-1JORm-k1nYx0n7hcE2DHa_fSOhdW=s2pov1NO50Q@mail.gmail.com>
Subject: Re: Please hammer my for-linus branch
From: Daniel J Blueman <daniel@quora.org>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: Chris Mason <chris.mason@fusionio.com>, Josef Bacik <jbacik@fusionio.com>,
        Linux BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4 July 2012 13:19, Liu Bo <liubo2009@cn.fujitsu.com> wrote:
> On 07/04/2012 11:37 AM, Daniel J Blueman wrote:
>>> Hi everyone,
>>>
>>> I've got a nice set of fixes from Josef, Jan, Ilya and others in my
>>> for-linus branch:
>>>
>>> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus
>>>
>>> Some of the changes are fixes for the tree logging code, so I ran some
>>> extra crash runs against them Friday night.
>>>
>>> I ended up with a new crash in the tree log directory deletion replay
>>> code, so I didn't send out the pull request to Linus.
>>>
>>> It isn't clear yet if the new crash is because I was testing differently
>>> or if it is a regression.  I'm nailing it down this weekend, but please
>>> give my for-linus a shot.
>>
>> I consistently run into this assertion [1] while running a fio
>> workload on a fresh RAID10 filesystem with a balance running.
>>
>> Let me know if you need steps to reproduce, debug etc.
>
> Seems that additional condition does not catch the bug.
>
> Plz show us the steps to reproduce, I'll try to reproduce it locally and nail it down.

The reproducer auto-generated from my test [1] consistently hits the
spot here; config @ http://quora.org/2012/kconfig-btrfs . You'll need
the fio workload file [2] in the same dir.

Thanks,
  Daniel

--- [1]

#!/bin/bash -ex

modprobe brd rd_size=1572864 rd_nr=4
# or use kernel param: ramdisk_size=1572864
mkdir -p /tmp/btrfsathon
sync

mkfs.btrfs -m raid1 -d raid1 -l 4096 -n 4096 /dev/ram2 /dev/ram3 /dev/ram1
mount /dev/ram1 /tmp/btrfsathon -o nodatacow,autodefrag,ssd,flushoncommit
btrfs filesystem defragment /tmp/btrfsathon ||: & sleep 0.017
fio --timeout=60 ./workload ||: & sleep 0.000
btrfs filesystem defragment /tmp/btrfsathon ||: & sleep 0.012
btrfs filesystem defragment /tmp/btrfsathon ||: & sleep 0.010
btrfs filesystem defragment /tmp/btrfsathon ||: & sleep 0.003
btrfs filesystem defragment /tmp/btrfsathon ||: & sleep 0.003
btrfs filesystem balance /tmp/btrfsathon ||: & sleep 0.003
fio --timeout=60 ./workload ||: & sleep 0.000
wait
umount /tmp/btrfsathon

--- [2] 'workload'

[global]
directory=/tmp/btrfsathon
rw=randread
size=128m
ioengine=libaio
iodepth=32
invalidate=1
direct=1

[bgwriter]
rw=randwrite
iodepth=32

[queryA]
iodepth=2
ioengine=mmap
direct=0
thinktime=1

[queryB]
iodepth=2
ioengine=mmap
direct=0
thinktime=1

[bgupdater]
rw=randrw
iodepth=32
size=64m
-- 
Daniel J Blueman
