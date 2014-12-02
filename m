Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:54404 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaLBI2K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Dec 2014 03:28:10 -0500
Received: by mail-vc0-f175.google.com with SMTP id hy10so5440692vcb.6
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Dec 2014 00:28:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <547D6F42.9000009@inwind.it>
References: <CAE8gLhm8Oma6kWdeJtdc1-U2e4+TJDzhmw2Vfr=CYwvJ78GRJQ@mail.gmail.com>
	<547CA4E7.8060209@pobox.com>
	<CAE8gLhmbws6E7YQVBLHfaUXF6Jz1qob9iOFiAEW7pRTq65YCyw@mail.gmail.com>
	<547CF8B1.4000303@pobox.com>
	<CAE8gLhkxgi8nTab0rzmLNzhsek_v2zs6RxPDL9GU_EAen9+kvA@mail.gmail.com>
	<547D6F42.9000009@inwind.it>
Date: Tue, 2 Dec 2014 09:28:09 +0100
Message-ID: <CAE8gLhmVqPTArDKxBenbRasUwifGOEoy+askejqneEA9WH-iOQ@mail.gmail.com>
Subject: Re: PROBLEM: #89121 BTRFS mixes up mounted devices with their snapshots
From: MegaBrutal <megabrutal@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: kreijack@inwind.it, Robert White <rwhite@pobox.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014-12-02 8:50 GMT+01:00 Goffredo Baroncelli <kreijack@inwind.it>:
> On 12/02/2014 01:15 AM, MegaBrutal wrote:
>> 2014-12-02 0:24 GMT+01:00 Robert White <rwhite@pobox.com>:
>>> On 12/01/2014 02:10 PM, MegaBrutal wrote:
>>>>
>>>> Since having duplicate UUIDs on devices is not a problem for me since
>>>> I can tell them apart by LVM names, the discussion is of little
>>>> relevance to my use case. Of course it's interesting and I like to
>>>> read it along, it is not about the actual problem at hand.
>>>>
>>>
>>> Which is why you use the device= mount option, which would take LVM names
>>> and which was repeatedly discussed as solving this very problem.
>>>
>>> Once you decide to duplicate the UUIDs with LVM snapshots you take up the
>>> burden of disambiguating your storage.
>>>
>>> Which is part of why re-reading was suggested as this was covered in some
>>> depth and _is_ _exactly_ about the problem at hand.
>>
>> Nope.
>>
>> root@reproduce-1391429:~# cat /proc/cmdline
>> BOOT_IMAGE=/vmlinuz-3.18.0-031800rc5-generic
>> root=/dev/mapper/vg-rootlv ro
>> rootflags=device=/dev/mapper/vg-rootlv,subvol=@
>>
>> Observe, device= mount option is added.
>
> device= options is needed only in a btrfs multi-volume scenario.
> If you have only one disk, this is not needed
>

I know. I only did this as a demonstration for Robert. He insisted it
will certainly solve the problem. Well, it doesn't.


>>
>> root@reproduce-1391429:~# ./reproduce-1391429.sh
>> #!/bin/sh -v
>> lvs
>>   LV     VG   Attr      LSize   Pool Origin Data%  Move Log Copy%  Convert
>>   rootlv vg   -wi-ao---   1.00g
>>   swap0  vg   -wi-ao--- 256.00m
>>
>> grub-probe --target=device /
>> /dev/mapper/vg-rootlv
>>
>> grep " / " /proc/mounts
>> rootfs / rootfs rw 0 0
>> /dev/dm-1 / btrfs rw,relatime,space_cache 0 0
>>
>> lvcreate --snapshot --size=128M --name z vg/rootlv
>>   Logical volume "z" created
>>
>> lvs
>>   LV     VG   Attr      LSize   Pool Origin Data%  Move Log Copy%  Convert
>>   rootlv vg   owi-aos--   1.00g
>>   swap0  vg   -wi-ao--- 256.00m
>>   z      vg   swi-a-s-- 128.00m      rootlv   0.11
>>
>> ls -l /dev/vg/
>> total 0
>> lrwxrwxrwx 1 root root 7 Dec  2 00:12 rootlv -> ../dm-1
>> lrwxrwxrwx 1 root root 7 Dec  2 00:12 swap0 -> ../dm-0
>> lrwxrwxrwx 1 root root 7 Dec  2 00:12 z -> ../dm-2
>>
>> grub-probe --target=device /
>> /dev/mapper/vg-z
>>
>> grep " / " /proc/mounts
>> rootfs / rootfs rw 0 0
>> /dev/dm-2 / btrfs rw,relatime,space_cache 0 0
>
> What /proc/self/mountinfo contains ?

Before creating snapshot:

15 20 0:15 / /sys rw,nosuid,nodev,noexec,relatime - sysfs sysfs rw
16 20 0:3 / /proc rw,nosuid,nodev,noexec,relatime - proc proc rw
17 20 0:5 / /dev rw,relatime - devtmpfs udev
rw,size=241692k,nr_inodes=60423,mode=755
18 17 0:12 / /dev/pts rw,nosuid,noexec,relatime - devpts devpts
rw,gid=5,mode=620,ptmxmode=000
19 20 0:16 / /run rw,nosuid,noexec,relatime - tmpfs tmpfs
rw,size=50084k,mode=755
20 0 0:17 /@ / rw,relatime - btrfs /dev/dm-1 rw,space_cache
<----- THIS!
21 15 0:20 / /sys/fs/cgroup rw,relatime - tmpfs none rw,size=4k,mode=755
22 15 0:21 / /sys/fs/fuse/connections rw,relatime - fusectl none rw
23 15 0:6 / /sys/kernel/debug rw,relatime - debugfs none rw
24 15 0:10 / /sys/kernel/security rw,relatime - securityfs none rw
25 19 0:22 / /run/lock rw,nosuid,nodev,noexec,relatime - tmpfs none
rw,size=5120k
26 19 0:23 / /run/shm rw,nosuid,nodev,relatime - tmpfs none rw
27 19 0:24 / /run/user rw,nosuid,nodev,noexec,relatime - tmpfs none
rw,size=102400k,mode=755
28 15 0:25 / /sys/fs/pstore rw,relatime - pstore none rw
29 20 253:1 / /boot rw,relatime - ext2 /dev/vda1 rw


After creating snapshot:

15 20 0:15 / /sys rw,nosuid,nodev,noexec,relatime - sysfs sysfs rw
16 20 0:3 / /proc rw,nosuid,nodev,noexec,relatime - proc proc rw
17 20 0:5 / /dev rw,relatime - devtmpfs udev
rw,size=241692k,nr_inodes=60423,mode=755
18 17 0:12 / /dev/pts rw,nosuid,noexec,relatime - devpts devpts
rw,gid=5,mode=620,ptmxmode=000
19 20 0:16 / /run rw,nosuid,noexec,relatime - tmpfs tmpfs
rw,size=50084k,mode=755
20 0 0:17 /@ / rw,relatime - btrfs /dev/dm-2 rw,space_cache
<----- WTF?!
21 15 0:20 / /sys/fs/cgroup rw,relatime - tmpfs none rw,size=4k,mode=755
22 15 0:21 / /sys/fs/fuse/connections rw,relatime - fusectl none rw
23 15 0:6 / /sys/kernel/debug rw,relatime - debugfs none rw
24 15 0:10 / /sys/kernel/security rw,relatime - securityfs none rw
25 19 0:22 / /run/lock rw,nosuid,nodev,noexec,relatime - tmpfs none
rw,size=5120k
26 19 0:23 / /run/shm rw,nosuid,nodev,relatime - tmpfs none rw
27 19 0:24 / /run/user rw,nosuid,nodev,noexec,relatime - tmpfs none
rw,size=102400k,mode=755
28 15 0:25 / /sys/fs/pstore rw,relatime - pstore none rw
29 20 253:1 / /boot rw,relatime - ext2 /dev/vda1 rw


So it's consistent with what /proc/mounts reports.


>
> And more important question: it is only the value
> returned by /proc/mount wrongly or also the filesystem
> content is affected ?
>

I quote my bug report on this:

"The information reported in /proc/mounts is certainly bogus, since
still the origin device is being written, the kernel does not actually
mix up the devices for write operations, and such, the phenomenon does
not cause data corruption. (I did an entire distro release upgrade
while the conditions were present, and I centainly would have suffered
severe data corruption otherwise. Fortunately, the origin device had
the new distro, and the snapshot device had the old one, so besides
the mixup in /proc/mounts, no actual damage happened.)"
