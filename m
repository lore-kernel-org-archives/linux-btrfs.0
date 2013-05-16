Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46295 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755545Ab3EPHSY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 May 2013 03:18:24 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UcsSA-00050Z-Hx
	for linux-btrfs@vger.kernel.org; Thu, 16 May 2013 09:18:18 +0200
Received: from dyndsl-080-228-190-127.ewe-ip-backbone.de ([80.228.190.127])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 16 May 2013 09:18:18 +0200
Received: from hurikhan77+btrfs by dyndsl-080-228-190-127.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 16 May 2013 09:18:18 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: [RFC 0/5] BTRFS hot relocation support
Date: Thu, 16 May 2013 09:12:53 +0200
Message-ID: <mgde6a-75n.ln1@hurikhan.ath.cx>
References: <1367830418-26865-1-git-send-email-zwu.kernel@gmail.com> <CAEH94LgEAcOHJKpuY+fY4cscxJ+QbynC0H9WbSGiV0fKp+-Ajw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

I think such a solution as part of the filesystem could do much better than 
something outside of it (like bcache). But I'm not sure: What makes data 
hot? I think the most benefit is detecting random read access and mark only 
those data as hot, also writes should go to the SSD first and then should be 
spooled to the harddisks in background. Bcache does a lot regarding this.

Since this is within the filesystem, users could even mark files as being 
always "hot" with some attribute or ioctl. This could be used by a boot-
readahead and preload implementation to automatically make files hot used 
during booting or for preloading when I start an application.

On the other side hot relocation should be able to reduce writes to the SSD 
as good as possible, for example: Do not defragment files during autodefrag, 
it makes no sense. Also write data in bursts of erase block size etc.

And also important: What if the SSD dies due to wearing? Will it gracefully 
fall back to harddisk? What does "relocation" mean? Files (hot data) should 
only be cached in copy to SSD, and not moved there. It should be possible 
for btrfs to just drop a failing SSD from the filesystem without data loss 
because otherwise one should use two SSDs in raid-1 mode to get a safe cache 
storage.

Altogether I think that a spinning media btrfs raid can outperform a single 
SSD so hot relocation should probably be used to reduce head movements 
because this is where SSD really excels. So everything that involves heavy 
head movement should go to SSD first, then written back to harddisk. And I 
think there's a lot potential to optimize because a COW filesystem like 
btrfs naturally has a lot of head movement.

What do you think?

BTW: I have not tried the one or the other yet because I'm still deciding 
which way to go. Your patches are more welcome because I do not need to 
migrate my storage to bcache-provided block devices. OTOH the bcache 
implementation looks a lot more mature (with regard to performance and 
safety) at this point because it provides many of the above mentioned 
features - most importantly gracefully handling failing SSDs.

Regarding btrfs raid outperforms SSD: During boot my spinning media 3 device 
btrfs raid reads boot files with up to 600 MB/s (from LZ compressed fs), 
boot takes about 7 seconds until the display manager starts (which takes 
another 30 seconds but that's another story), and the system is pretty 
crowded with services I actually wouldn't need if I optimized for boot 
performance. But I think systemd's read-ahead implementation has a lot 
influence on this fast booting: It defragments and relocates boot files on 
btrfs during boot so the harddisks can sequentially read all this stuff. I 
think it also compresses boot files if compression is enabled because 
booting is IO bound, not CPU bound. Benchmarks showed that my btrfs raid 
could technically read up to 450 MB/s, so I think the 600 MB/s counts for 
decompressed data. A single SSD could not do that. For that same reason I 
created a small script to defragment and compress files used by the preload 
daemon. Without benchmarking it, this felt like another small performance 
boost. So I'm eager what could be next with some sort of SSD cache because 
the only problem left seems to be heavy head movement which slows down the 
system.

Zhi Yong Wu <zwu.kernel@gmail.com> schrieb:

> HI,
> 
>    What do you think if its design approach goes correctly? Do you
> have any comments or better design idea for BTRFS hot relocation
> support? any comments are appreciated, thanks.
> 
> 
> On Mon, May 6, 2013 at 4:53 PM,  <zwu.kernel@gmail.com> wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>>   The patchset as RFC is sent out mainly to see if it goes in the
>> correct development direction.
>>
>>   The patchset is trying to introduce hot relocation support
>> for BTRFS. In hybrid storage environment, when the data in
>> HDD disk get hot, it can be relocated to SSD disk by BTRFS
>> hot relocation support automatically; also, if SSD disk ratio
>> exceed its upper threshold, the data which get cold can be
>> looked up and relocated to HDD disk to make more space in SSD
>> disk at first, and then the data which get hot will be relocated
>> to SSD disk automatically.
>>
>>   BTRFS hot relocation mainly reserve block space from SSD disk
>> at first, load the hot data to page cache from HDD, allocate
>> block space from SSD disk, and finally write the data to SSD disk.
>>
>>   If you'd like to play with it, pls pull the patchset from
>> my git on github:
>>   https://github.com/wuzhy/kernel.git hot_reloc
>>
>> For how to use, please refer too the example below:
>>
>> root@debian-i386:~# echo 0 > /sys/block/vdc/queue/rotational
>> ^^^ Above command will hack /dev/vdc to be one SSD disk
>> root@debian-i386:~# echo 999999 > /proc/sys/fs/hot-age-interval
>> root@debian-i386:~# echo 10 > /proc/sys/fs/hot-update-interval
>> root@debian-i386:~# echo 10 > /proc/sys/fs/hot-reloc-interval
>> root@debian-i386:~# mkfs.btrfs -d single -m single -h /dev/vdb /dev/vdc
>> -f
>>
>> WARNING! - Btrfs v0.20-rc1-254-gb0136aa-dirty IS EXPERIMENTAL
>> WARNING! - see http://btrfs.wiki.kernel.org before using
>>
>> [ 140.279011] device fsid c563a6dc-f192-41a9-9fe1-5a3aa01f5e4c devid 1
>> [ transid 16 /dev/vdb 140.283650] device fsid
>> [ c563a6dc-f192-41a9-9fe1-5a3aa01f5e4c devid 2 transid 16 /dev/vdc
>> [ 140.517089] device fsid 197d47a7-b9cd-46a8-9360-eb087b119424 devid 1
>> [ transid 3 /dev/vdb 140.550759] device fsid
>> [ 197d47a7-b9cd-46a8-9360-eb087b119424 devid 1 transid 3 /dev/vdb
>> [ 140.552473] device fsid c563a6dc-f192-41a9-9fe1-5a3aa01f5e4c devid 2
>> [ transid 16 /dev/vdc
>> adding device /dev/vdc id 2
>> [ 140.636215] device fsid 197d47a7-b9cd-46a8-9360-eb087b119424 devid 2
>> [ transid 3 /dev/vdc
>> fs created label (null) on /dev/vdb
>> nodesize 4096 leafsize 4096 sectorsize 4096 size 14.65GB
>> Btrfs v0.20-rc1-254-gb0136aa-dirty
>> root@debian-i386:~# mount -o hot_move /dev/vdb /data2
>> [ 144.855471] device fsid 197d47a7-b9cd-46a8-9360-eb087b119424 devid 1
>> [ transid 6 /dev/vdb 144.870444] btrfs: disk space caching is enabled
>> [ 144.904214] VFS: Turning on hot data tracking
>> root@debian-i386:~# dd if=/dev/zero of=/data2/test1 bs=1M count=2048
>> 2048+0 records in
>> 2048+0 records out
>> 2147483648 bytes (2.1 GB) copied, 23.4948 s, 91.4 MB/s
>> root@debian-i386:~# df -h
>> Filesystem Size Used Avail Use% Mounted on
>> /dev/vda1 16G 13G 2.2G 86% /
>> tmpfs 4.8G 0 4.8G 0% /lib/init/rw
>> udev 10M 176K 9.9M 2% /dev
>> tmpfs 4.8G 0 4.8G 0% /dev/shm
>> /dev/vdb 15G 2.0G 13G 14% /data2
>> root@debian-i386:~# btrfs fi df /data2
>> Data: total=3.01GB, used=2.00GB
>> System: total=4.00MB, used=4.00KB
>> Metadata: total=8.00MB, used=2.19MB
>> Data_SSD: total=8.00MB, used=0.00
>> root@debian-i386:~# echo 108 > /proc/sys/fs/hot-reloc-threshold
>> ^^^ Above command will start HOT RLEOCATE, because The data temperature
>> is currently 109 root@debian-i386:~# df -h
>> Filesystem Size Used Avail Use% Mounted on
>> /dev/vda1 16G 13G 2.2G 86% /
>> tmpfs 4.8G 0 4.8G 0% /lib/init/rw
>> udev 10M 176K 9.9M 2% /dev
>> tmpfs 4.8G 0 4.8G 0% /dev/shm
>> /dev/vdb 15G 2.1G 13G 14% /data2
>> root@debian-i386:~# btrfs fi df /data2
>> Data: total=3.01GB, used=6.25MB
>> System: total=4.00MB, used=4.00KB
>> Metadata: total=8.00MB, used=2.26MB
>> Data_SSD: total=2.01GB, used=2.00GB
>> root@debian-i386:~#
>>
>> Zhi Yong Wu (5):
>>   vfs: add one list_head field
>>   btrfs: add one new block group
>>   btrfs: add one hot relocation kthread
>>   procfs: add three proc interfaces
>>   btrfs: add hot relocation support
>>
>>  fs/btrfs/Makefile            |   3 +-
>>  fs/btrfs/ctree.h             |  26 +-
>>  fs/btrfs/extent-tree.c       | 107 +++++-
>>  fs/btrfs/extent_io.c         |  31 +-
>>  fs/btrfs/extent_io.h         |   4 +
>>  fs/btrfs/file.c              |  36 +-
>>  fs/btrfs/hot_relocate.c      | 802
>>  +++++++++++++++++++++++++++++++++++++++++++
>>  fs/btrfs/hot_relocate.h      |  48 +++
>>  fs/btrfs/inode-map.c         |  13 +-
>>  fs/btrfs/inode.c             |  92 ++++-
>>  fs/btrfs/ioctl.c             |  23 +-
>>  fs/btrfs/relocation.c        |  14 +-
>>  fs/btrfs/super.c             |  30 +-
>>  fs/btrfs/volumes.c           |  28 +-
>>  fs/hot_tracking.c            |   1 +
>>  include/linux/btrfs.h        |   4 +
>>  include/linux/hot_tracking.h |   1 +
>>  kernel/sysctl.c              |  22 ++
>>  18 files changed, 1234 insertions(+), 51 deletions(-)
>>  create mode 100644 fs/btrfs/hot_relocate.c
>>  create mode 100644 fs/btrfs/hot_relocate.h
>>
>> --
>> 1.7.11.7
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 


