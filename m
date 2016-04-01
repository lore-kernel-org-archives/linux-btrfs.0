Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:32649 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754687AbcDABKv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Mar 2016 21:10:51 -0400
Subject: Re: btrfsck: backpointer mismatch (and multiple other errors)
To: Henk Slager <eye1tm@gmail.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20160331224452.0753d5c7@jupiter.sol.kaishome.de>
 <CAPmG0jZ6hs4TA_0ozNEP4x6ucn971Nj-6+uempGi1VwTWAdCYQ@mail.gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56FDCA94.3030001@cn.fujitsu.com>
Date: Fri, 1 Apr 2016 09:10:44 +0800
MIME-Version: 1.0
In-Reply-To: <CAPmG0jZ6hs4TA_0ozNEP4x6ucn971Nj-6+uempGi1VwTWAdCYQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Henk Slager wrote on 2016/04/01 01:27 +0200:
> On Thu, Mar 31, 2016 at 10:44 PM, Kai Krakow <hurikhan77@gmail.com> wrote:
>> Hello!
>>
>> I already reported this in another thread but it was a bit confusing by
>> intermixing multiple volumes. So let's start a new thread:
>>
>> Since one of the last kernel upgrades, I'm experiencing one VDI file
>> (containing a NTFS image with Windows 7) getting damaged when running
>> the machine in VirtualBox. I got knowledge about this after
>> experiencing an error "duplicate object" and btrfs went RO. I fixed it
>> by deleting the VDI and restoring from backup - but no I get csum
>> errors as soon as some VM IO goes into the VDI file.
>>
>> The FS is still usable. One effect is, that after reading all files
>> with rsync (to copy to my backup), each call of "du" or "df" hangs, also
>> similar calls to "btrfs {sub|fi} ..." show the same effect. I guess one
>> outcome of this is, that the FS does not properly unmount during
>> shutdown.
>>
>> Kernel is 4.5.0 by now (the FS is much much older, dates back to 3.x
>> series, and never had problems), including Gentoo patch-set r1.
>
> One possibility could be that the vbox kernel modules somehow corrupt
> btrfs kernel area since kernel 4.5.
>
> In order to make this reproducible (or an attempt to reproduce) for
> others, you could unload VirtualBox stuff and restore the VDI file
> from backup (or whatever big file) and then make pseudo-random, but
> reproducible writes to the file.
>
> It is not clear to me what 'Gentoo patch-set r1' is and does. So just
> boot a vanilla v4.5 kernel from kernel.org and see if you get csum
> errors in dmesg.
>
> Also, where does 'duplicate object' come from? dmesg ? then please
> post its surroundings, straight from dmesg.
>
>> The device layout is:
>>
>> $ lsblk -o NAME,MODEL,FSTYPE,LABEL,MOUNTPOINT
>> NAME        MODEL            FSTYPE LABEL      MOUNTPOINT
>> sda         Crucial_CT128MX1
>> ├─sda1                       vfat   ESP        /boot
>> ├─sda2
>> └─sda3                       bcache
>>    ├─bcache0                  btrfs  system
>>    ├─bcache1                  btrfs  system
>>    └─bcache2                  btrfs  system     /usr/src
>> sdb         SAMSUNG HD103SJ
>> ├─sdb1                       swap   swap0      [SWAP]
>> └─sdb2                       bcache
>>    └─bcache2                  btrfs  system     /usr/src
>> sdc         SAMSUNG HD103SJ
>> ├─sdc1                       swap   swap1      [SWAP]
>> └─sdc2                       bcache
>>    └─bcache1                  btrfs  system
>> sdd         SAMSUNG HD103UJ
>> ├─sdd1                       swap   swap2      [SWAP]
>> └─sdd2                       bcache
>>    └─bcache0                  btrfs  system
>>
>> Mount options are:
>>
>> $ mount|fgrep btrfs
>> /dev/bcache2 on / type btrfs (rw,noatime,compress=lzo,nossd,discard,space_cache,autodefrag,subvolid=256,subvol=/gentoo/rootfs)
>>
>> The FS uses mraid=1 and draid=0.
>>
>> Output of btrfsck is:
>> (also available here:
>> https://gist.github.com/kakra/bfcce4af242f6548f4d6b45c8afb46ae)
>>
>> $ btrfsck /dev/disk/by-label/system
>> checking extents
>> ref mismatch on [10443660537856 524288] extent item 1, found 2
> This   10443660537856  number is bigger than the  1832931324360 number
> found for total bytes. AFAIK, this is already wrong.

Nope. That's btrfs logical space address, which can be beyond real disk 
bytenr.

The easiest method to reproduce such case, is write something in a 256M 
btrfs, and balance the fs several times.

Then all chunks can be at bytenr beyond 256M.

The real problem is, the extent has mismatched reference.
Normally it can fixed by --init-extent-tree option, but it normally 
means bigger problem, especially it has already caused kernel 
delayed-ref problem.

No to mention the error "extent item 11271947091968 has multiple extent 
items", which makes the problem more serious.


I assume some older kernel have already screwed up the extent tree, as 
although delayed-ref is bug-prove, it has improved in recent years.

But it seems fs tree is less damaged, I assume the extent tree 
corruption could be fixed by "--init-extent-tree".

For the only fs tree error (missing csum), if "btrfsck 
--init-extent-tree --repair" works without any problem, the most simple 
fix would be, just removing the file.
Or you can use a lot of CPU time and disk IO to rebuild the whole csum, 
by using "--init-csum-tree" option.

Thanks,
Qu

>
> [...]
>
>> checking fs roots
>> root 4336 inode 4284125 errors 1000, some csum missing
> What is in this inode?
>
>> Checking filesystem on /dev/disk/by-label/system
>> UUID: d2bb232a-2e8f-4951-8bcc-97e237f1b536
>> found 1832931324360 bytes used err is 1
>> total csum bytes: 1730105656
>> total tree bytes: 6494474240
>> total fs tree bytes: 3789783040
>> total extent tree bytes: 608219136
>> btree space waste bytes: 1221460063
>> file data blocks allocated: 2406059724800
>>   referenced 2040857763840
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


