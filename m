Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:62344 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaC1Hcq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Mar 2014 03:32:46 -0400
Message-ID: <53352599.6000407@friedels.name>
Date: Fri, 28 Mar 2014 08:32:41 +0100
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: free space inode generation (0) did not match free space cache
 generation
References: <532DF38B.40409@friedels.name> <532DFDAB.7000600@friedels.name> <pan$b7ff$285d59f6$2419371$b3946ebe@cox.net> <53309AF9.8090203@friedels.name> <pan$8258b$aea97c0c$211631c9$d306a8a9@cox.net> <5331E10E.6080806@friedels.name> <20140325201020.GC7442@carfax.org.uk>
In-Reply-To: <20140325201020.GC7442@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

after merely 5 days, I have the same Problem:

root@homeserver:~# ./btrfs/integration/devel/btrfs fi df /mnt/test1/
Disk size:                29.50GiB
Disk allocated:           29.30GiB
Disk unallocated:        202.00MiB
Used:                     13.84GiB
Free (Estimated):        929.95MiB      (Max: 1.01GiB, min: 929.95MiB)
Data to disk ratio:           50 %
root@homeserver:~# ./btrfs/integration/devel/btrfs fi show /mnt/test1/
Label: 'ROOT_BTRFS_RAID'  uuid: a2d5f2db-04ca-413a-aee1-cb754aa8fba5
         Total devices 2 FS bytes used 13.84GiB
         devid    1 size 14.85GiB used 14.65GiB path /dev/sde2
         devid    2 size 14.65GiB used 14.65GiB path /dev/sdd2


         root@homeserver:~# ./btrfs/integration/devel/btrfs fi df 
/mnt/test1/
Disk size:                29.50GiB
Disk allocated:           29.30GiB
Disk unallocated:        202.00MiB
Used:                     13.84GiB
Free (Estimated):        929.95MiB      (Max: 1.01GiB, min: 929.95MiB)
Data to disk ratio:           50 %
root@homeserver:~# ./btrfs/integration/devel/btrfs fi show /mnt/test1/
Label: 'ROOT_BTRFS_RAID'  uuid: a2d5f2db-04ca-413a-aee1-cb754aa8fba5
         Total devices 2 FS bytes used 13.84GiB
         devid    1 size 14.85GiB used 14.65GiB path /dev/sde2
         devid    2 size 14.65GiB used 14.65GiB path /dev/sdd2

Btrfs this-will-become-v3.13-48-g57c3600
root@homeserver:~# time ./btrfs/integration/devel/btrfs balance start 
-dusage=0 /mnt/test1
Done, had to relocate 0 out of 22 chunks

real    0m2.734s
user    0m0.000s
sys     0m0.022s


I increased dusage until I got:
root@homeserver:~# time ./btrfs/integration/devel/btrfs balance start 
-dusage=90 /mnt/test1
ERROR: error during balancing '/mnt/test1' - No space left on device
There may be more info in syslog - try dmesg | tail


Before I could do a full balance I had to delete all Snapshots:
~20 on my root subvolume
~40 on my /home and /root subvolume

I do not find this a extraordinary high number of snapshots. Also others 
should have higher numbers, when they use snapper.

Any Idea of what could be the reason here?

Regards,
Hendrik



Am 25.03.2014 21:10, schrieb Hugo Mills:
> On Tue, Mar 25, 2014 at 09:03:26PM +0100, Hendrik Friedel wrote:
>> Hi,
>>
>>> Well, given the relative immaturity of btrfs as a filesystem at this
>>> point in its lifetime, I think it's acceptable/tolerable.  However, for a
>>> filesystem feted[1] to ultimately replace the ext* series as an assumed
>>> Linux default, I'd definitely argue that the current situation should be
>>> changed such that btrfs can automatically manage its own de-allocation at
>>> some point, yes, and that said "some point" really needs to come before
>>> that point at which btrfs can be considered an appropriate replacement
>>> for ext2/3/4 as the assumed default Linux filesystem of the day.
>>
>> Agreed! I hope, this is on the ToDo List?!
>
> https://btrfs.wiki.kernel.org/index.php/Project_ideas#Block_group_reclaim
>
>     Yes. :)
>
>>> [1] feted: celebrated, honored.  I had to look it up to be sure my
>>> intuition on usage was correct, and indeed I had spelled it wrong
>>
>> :-)
>
>     Did you mean "fated": intended, destined?
>
>     Hugo.
>


-- 
Hendrik Friedel
Auf dem Brink 12
28844 Weyhe
Mobil 0178 1874363
