Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40334 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710AbaJ3D3S (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Oct 2014 23:29:18 -0400
Message-ID: <5451B173.6040206@oracle.com>
Date: Thu, 30 Oct 2014 11:33:07 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: zcoffey@mytech42.com
CC: linux-btrfs@vger.kernel.org
Subject: Re: RAID1 fails to recover chunk tree
References: <544FFD52.6010604@gmail.com> <5450651C.3010104@oracle.com> <545140D4.4060404@gmail.com>
In-Reply-To: <545140D4.4060404@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  just notice your case is different from others seen/working on.
  in your the layout has issue. its not about the raid. sorry.

  try: mount -o recovery,ro



On 10/30/2014 03:32 AM, Zack Coffey wrote:
>
> $ sudo mount -o degraded,ro /dev/sdd1 /asdf
> mount: wrong fs type, bad option, bad superblock on /dev/sdd1,
>         missing codepage or helper program, or other error
>
>         In some cases useful info is found in syslog - try
>         dmesg | tail or so.
> $ dmesg | tail
> [524718.760792] BTRFS info (device sdd1): allowing degraded mounts
> [524718.760800] BTRFS info (device sdd1): disk space caching is enabled
> [524718.762087] BTRFS: failed to read chunk root on sdd1
> [524718.776524] BTRFS: open_ctree failed
>
> $ uname -a
> Linux mach 3.17.1-52.g5c4d099-desktop #1 SMP PREEMPT Sat Oct 18 23:36:23
> UTC 2014 (5c4d099) x86_64 x86_64 x86_64 GNU/Linux
> $ btrfs --version
> Btrfs v3.16.2+20141003
>
>
> On 10/28/2014 11:55 PM, Anand Jain wrote:
>>
>>
>>  'mount degraded,ro'
>>   see if there is any non-zero non-raid1 group profile.
>>
>>
>>
>> On 10/29/14 04:32, Zack Coffey wrote:
>>> Revisit of a previous issue. Setup a single 640GB drive with BTRFS and
>>> compression. This was not a system drive, just a place to put random
>>> junk.
>>>
>>> Made a RAID1 with another drive of just the metadata. Was in
>>> that state for less than 12 hours-ish, removed the second drive and
>>> now cannot get to any data on the original drive. Data remained single
>>> while only metadata was RAID1.
>>>
>>> Single drive btrfs was made on Ubuntu with kernel 3.13.0 and tools
>>> 3.12.
>>>
>>> $ sudo mount -o degraded /dev/sdc1 /media/Data/
>>> mount: wrong fs type, bad option, bad superblock on /dev/sdc1,
>>>         missing codepage or helper program, or other error
>>>         In some cases useful info is found in syslog - try
>>>         dmesg | tail  or so
>>>
>>> $ dmesg | tail
>>> [45353.869448] KBD BUG in
>>> ../../../../../../../../
>>> drivers/2d/lnx/fgl/drm/kernel/
>>> gal.c at line:
>>> 304!
>>> [45353.901511] KBD BUG in
>>> ../../../../../../../../
>>> drivers/2d/lnx/fgl/drm/kernel/gal.c at line:
>>> 304!
>>> [45353.901666] KBD BUG in
>>> ../../../../../../../../drivers/2d/lnx/fgl/drm/kernel/gal.c at line:
>>> 304!
>>> [45354.148488] KBD BUG in
>>> ../../../../../../../../drivers/2d/lnx/fgl/drm/kernel/gal.c at line:
>>> 304!
>>> [45354.148573] KBD BUG in
>>> ../../../../../../../../drivers/2d/lnx/fgl/drm/kernel/gal.c at line:
>>> 304!
>>> [46241.155350] btrfs: device fsid bd78815a-802b-43e2-8387-fc6ab4237d67
>>> devid 1 transid 60944 /dev/sdc1
>>> [46241.155923] btrfs: allowing degraded mounts
>>> [46241.155927] btrfs: disk space caching is enabled
>>> [46241.159436] btrfs: failed to read chunk root on sdc1
>>> [46241.177815] btrfs: open_ctree failed
>>>
>>> $ btrfs-show-super /dev/sdc1
>>> superblock: bytenr=65536, device=/dev/sdc1
>>> ------------------------------
>>> ---------------------------
>>> csum                    0x93bcb1b5 [match]
>>> bytenr                  65536
>>> flags                   0x1
>>> magic                   _BHRfS_M [match]
>>> fsid                    bd78815a-802b-43e2-8387-fc6ab4237d67
>>> label
>>> generation              60944
>>> root                    909586694144
>>> sys_array_size          97
>>> chunk_root_generation   60938
>>> root_level              1
>>> chunk_root              911673917440
>>> chunk_root_level        1
>>> log_root                0
>>> log_root_transid        0
>>> log_root_level          0
>>> total_bytes             1115871535104
>>> bytes_used              321833435136
>>> sectorsize              4096
>>> nodesize                4096
>>> leafsize                4096
>>> stripesize              4096
>>> root_dir                6
>>> num_devices             2
>>> compat_flags            0x0
>>> compat_ro_flags         0x0
>>> incompat_flags          0x9
>>> csum_type               0
>>> csum_size               4
>>> cache_generation        60944
>>> uuid_tree_generation    60944
>>> dev_item.uuid           d82b2027-17b6-4513-a86d-9227a42d7ed1
>>> dev_item.fsid           bd78815a-802b-43e2-8387-fc6ab4237d67 [match]
>>> dev_item.type           0
>>> dev_item.total_bytes    615763673088
>>> dev_item.bytes_used     324270030848
>>> dev_item.io_align       4096
>>> dev_item.io_width       4096
>>> dev_item.sector_size    4096
>>> dev_item.devid          1
>>> dev_item.dev_group      0
>>> dev_item.seek_speed     0
>>> dev_item.bandwidth      0
>>> dev_item.generation     0
>>>
>>>
>>> $ sudo btrfs device add -f /dev/sdh1 /dev/sdc1
>>> ERROR: error adding the device '/dev/sdh1' - Inappropriate ioctl for
>>> device
>>>
>>> $ sudo btrfs device delete missing /dev/sdc1
>>> ERROR: error removing the device 'missing' - Inappropriate ioctl for
>>> device
>>>
>>> $ sudo mount -o degraded,defaults,compress=lzo /dev/sdc1 /media/Data/
>>> mount: wrong fs type, bad option, bad superblock on /dev/sdc1,
>>>         missing codepage or helper program, or other error
>>>         In some cases useful info is found in syslog - try
>>>         dmesg | tail  or so
>>>
>>> $ dmesg | tail
>>> [106991.655384] btrfs: device fsid
>>> bd78815a-802b-43e2-8387-fc6ab4237d67 devid 1 transid 60944 /dev/sdc1
>>> [106991.665066] btrfs: device fsid
>>> bd78815a-802b-43e2-8387-fc6ab4237d67 devid 1 transid 60944 /dev/sdc1
>>> [107019.954397] btrfs: device fsid
>>> bd78815a-802b-43e2-8387-fc6ab4237d67 devid 1 transid 60944 /dev/sdc1
>>> [107019.962009] btrfs: device fsid
>>> bd78815a-802b-43e2-8387-fc6ab4237d67 devid 1 transid 60944 /dev/sdc1
>>> [107070.124927] btrfs: device fsid
>>> bd78815a-802b-43e2-8387-fc6ab4237d67 devid 1 transid 60944 /dev/sdc1
>>> [107070.126475] btrfs: allowing degraded mounts
>>> [107070.126479] btrfs: use lzo compression
>>> [107070.126480] btrfs: disk space caching is enabled
>>> [107070.127254] btrfs: failed to read chunk root on sdc1
>>> [107070.142983] btrfs: open_ctree failed
>>>
>>> $ sudo btrfs rescue super-recover -v /dev/sdc1
>>> All Devices:
>>>          Device: id = 1, name = /dev/sdc1
>>>
>>> Before Recovering:
>>>          [All good supers]:
>>>                  device name = /dev/sdc1
>>>                  superblock bytenr = 65536
>>>
>>>                  device name = /dev/sdc1
>>>                  superblock bytenr = 67108864
>>>
>>>                  device name = /dev/sdc1
>>>                  superblock bytenr = 274877906944
>>>
>>>          [All bad supers]:
>>>
>>> All supers are valid, no need to recover
>>>
>>> $ btrfs rescue chunk-recover -v /dev/sdc1
>>> <<snipped>>
>>> Chunk: start = 860100755456, len = 1073741824, type = 1, num_stripes = 1
>>>        Stripes list:
>>>        [ 0] Stripe: devid = 1, offset = 26877100032
>>>        No block group.
>>>        No device extent.
>>>    Chunk: start = 861174497280, len = 1073741824, type = 1,
>>> num_stripes = 1
>>>        Stripes list:
>>>        [ 0] Stripe: devid = 1, offset = 27950841856
>>>        No block group.
>>>        No device extent.
>>>
>>> Total Chunks:   333
>>>    Heathy:       305
>>>    Bad:  28
>>>
>>> Orphan Block Groups:
>>>    Block Group: start = 872985657344, len = 1073741824, flag = 4
>>>    Block Group: start = 911673917440, len = 33554432, flag = 2
>>>    Block Group: start = 911707471872, len = 1073741824, flag = 4
>>>
>>> Orphan Device Extents:
>>>    Device extent: devid = 2, start = 2182086656, len = 33554432, chunk
>>> offset = 911673917440
>>>    Device extent: devid = 2, start = 2215641088, len = 1073741824,
>>> chunk offset = 911707471872
>>> Fail to recover the chunk tree.
>>> <</snipped>>
>>>
>>> Here's the full snipped paste: http://pastebin.com/fEm3Gup7
>>>
>>> Now I'm on openSUSE Tumbleweed (kernel 3.17). Still get the same
>>> result from 'chunk-recover'. There's 305 healthy chunks, is there
>>> anyway to recover that data and forget about the bad ones?
>>>
>>> A good portion of the data on that drive was backed up, but some
>>> wasn't. My fault, I've learned. Can I get anything back from that
>>> drive?
>>>
>>> Thanks
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
