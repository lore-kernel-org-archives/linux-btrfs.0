Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:63924 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbaITOEa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Sep 2014 10:04:30 -0400
Received: by mail-pd0-f176.google.com with SMTP id z10so397470pdj.7
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Sep 2014 07:04:29 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: Performance Issues
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <1678306.dObPo7E7s7@fb07-iapwap2>
Date: Sat, 20 Sep 2014 22:04:16 +0800
Cc: =?utf-8?Q?Holger_Hoffst=C3=A4tte?=
	<holger.hoffstaette@googlemail.com>,
        linux-btrfs@vger.kernel.org
Message-Id: <6DB655AC-0808-4B52-840C-823B46030795@gmail.com>
References: <1411129114.1811.7.camel@zarniwoop.blob> <pan.2014.09.19.13.51.22@googlemail.com> <1678306.dObPo7E7s7@fb07-iapwap2>
To: Marc Dietrich <marvin24@gmx.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

just my two cents here.^_^

> Am Freitag, 19. September 2014, 13:51:22 schrieb Holger Hoffstätte:
>> 
>> On Fri, 19 Sep 2014 13:18:34 +0100, Rob Spanton wrote:
>> 
>>> I have a particularly uncomplicated setup (a desktop PC with a hard
>>> disk) and I'm seeing particularly slow performance from btrfs.  A `git
>>> status` in the linux source tree takes about 46 seconds after dropping
>>> caches, whereas on other machines using ext4 this takes about 13s.  My
>>> mail client (evolution) also seems to perform particularly poorly on
>>> this setup, and my hunch is that it's spending a lot of time waiting on
>>> the filesystem.
>> 
>> This is - unfortunately - a particular btrfs oddity/characteristic/flaw,
>> whatever you want to call it. git relies a lot on fast stat() calls,
>> and those seem to be particularly slow with btrfs esp. on rotational
>> media. I have the same problem with rsync on a freshly mounted volume;
>> it gets fast (quite so!) after the first run.
> 
> my favorite benchmark is "ls -l /usr/bin":
> 
> ext4:     0.934s
> btrfs:   21.814s

I did a quick benchmark for this:

Testing tool is something like follows, it create 50W files
and 50w directories under a fresh mkfs filesystem, btrfs is just
a little slower than ext4:

For ext4:
real	0m9.295s
user	0m2.252s
sys	0m7.010s

For btrfs:
real	0m10.207s
user	0m1.347s
sys	0m8.353s

And test is done with a 20G vm disk(backend is hard disk) with
latest kernel compiled under VM.

#!/bin/bash

umount /dev/sdc
#~/source/e2fsprogs/misc/mke2fs -F -O inline_data /dev/sdc >/dev/null
mkfs.ext4 -F /dev/sdc >/dev/null
mount /dev/sdc /mnt
./mdtest  -d /mnt/ext4 -n 500000 -C >&/dev/null
echo 3 > /proc/sys/vm/drop_caches
time ls -l /mnt/ext4/\#test-dir.0/mdtest_tree.0 >& /dev/null

umount /dev/sdc
mkfs.btrfs -f /dev/sdc >/dev/null
mount /dev/sdc /mnt
./mdtest  -d /mnt/btrfs -n 500000 -C >/dev/null
echo 3 > /proc/sys/vm/drop_caches
time ls -l /mnt/btrfs/\#test-dir.0/mdtest_tree.0 >& /dev/null

So here i think Btrfs is not that you think much slower than Ext4 at least
for ‘ls’ which means directory reading performances…

Here i think you could do several ways to improve or avoid such things:

1. create a separate subvolume or separate partition for /usr and use noatime
   mount option if possible.(I remembered Marc MARLIEN gave some good example for this)

2. running defrag command to reduce fragmentation.

Reasons for doing these are because that directory like /usr/bin is regularly accessed
which will also trigger Btrfs widely COWed which may cause serious fragmentation
and that may cause some bad performances..

And another factor btrfs in default all files are mixed together in a a fs
B-tree, which means that all read/write lock will walk through same tree which
may cause some lock contention problem.

So use a separate subvoulme tree could improve lock thing a bit for that IMO.

BTW, next time if someone reported some problems,it will be nice to
give your detailed information for example kernel version, how many subvolumes/snapshots,
btrfs file system configurations, usage(running btrfs file show,btrfs file df e.g.)
these informations are useful for others to reproduce and analysis...

> 
> also mounting large partitons (several 100Gs) takes lot of time on btrfs.
> Better to defer it during boot using e.g. "noauto,x-systemd.automount".
> 
> Marc

Best Regards,
Wang Shilong

