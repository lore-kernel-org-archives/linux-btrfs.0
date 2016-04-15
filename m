Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kolab.zavadatar.com ([46.101.124.0]:59594 "EHLO
	kolab.zavadatar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbcDOTtl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Apr 2016 15:49:41 -0400
Received: by mail-vk0-f48.google.com with SMTP id e185so159374581vkb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Apr 2016 12:49:37 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 15 Apr 2016 12:49:36 -0700
Message-ID: <CAKWEGV65rRmpuRnUejCqVpdS+S5nbzrQnFAdy+y3X5EYZJgqpw@mail.gmail.com>
Subject: RAID6, errors at missing device replacement
From: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

I have discovered case when replacement of missing devices causes
metadata corruption. Does anybody know anything about this?

I use 4.4.5 kernel with latest global spare patches.

If we have RAID6 (may be reproducible on RAID5 too) and try to replace
one missing drive by other and after this try to remove another drive
and replace it, plenty of errors are shown in the log:

[  748.641766] BTRFS error (device sdf): failed to rebuild valid
logical 7366459392 for dev /dev/sde
[  748.678069] BTRFS error (device sdf): failed to rebuild valid
logical 7381139456 for dev /dev/sde
[  748.693559] BTRFS error (device sdf): failed to rebuild valid
logical 7290974208 for dev /dev/sde
[  752.039100] BTRFS error (device sdf): bad tree block start
13048831955636601734 6919258112
[  752.647869] BTRFS error (device sdf): bad tree block start
12819300352 6919290880
[  752.658520] BTRFS error (device sdf): bad tree block start
31618367488 6919290880
[  752.712633] BTRFS error (device sdf): bad tree block start
31618367488 6919290880

After device replacement finish, scrub shows uncorrectable errors.
Btrfs check complains about errors too:
root@test:~/# btrfs check -p /dev/sdc
Checking filesystem on /dev/sdc
UUID: 833fef31-5536-411c-8f58-53b527569fa5
checksum verify failed on 9359163392 found E4E3BDB6 wanted 00000000
checksum verify failed on 9359163392 found E4E3BDB6 wanted 00000000
checksum verify failed on 9359163392 found 4D1F4197 wanted DE0E50EC
bytenr mismatch, want=9359163392, have=9359228928

Errors found in extent allocation tree or chunk allocation
checking free space cache [.]
checking fs roots [.]
checking csums
checking root refs
found 1049788420 bytes used err is 0
total csum bytes: 1024000
total tree bytes: 1179648
total fs tree bytes: 16384
total extent tree bytes: 16384
btree space waste bytes: 124962
file data blocks allocated: 1049755648
 referenced 1049755648

After first replacement metadata seems not spread across all devices:
Label: none  uuid: 3db39446-6810-47bf-8732-d5a8793500f3
        Total devices 4 FS bytes used 1002.00MiB
        devid    1 size 8.00GiB used 1.28GiB path /dev/sdc
        devid    2 size 8.00GiB used 1.28GiB path /dev/sdd
        devid    3 size 8.00GiB used 1.28GiB path /dev/sdf
        devid    4 size 8.00GiB used 1.25GiB path /dev/sdg

# btrfs device usage /mnt/
/dev/sdc, ID: 1
   Device size:             8.00GiB
   Data,RAID6:              1.00GiB
   Metadata,RAID6:        256.00MiB
   System,RAID6:           32.00MiB
   Unallocated:             6.72GiB

/dev/sdd, ID: 2
   Device size:             8.00GiB
   Data,RAID6:              1.00GiB
   Metadata,RAID6:        256.00MiB
   System,RAID6:           32.00MiB
   Unallocated:             6.72GiB

/dev/sdf, ID: 3
   Device size:             8.00GiB
   Data,RAID6:              1.00GiB
   Metadata,RAID6:        256.00MiB
   System,RAID6:           32.00MiB
   Unallocated:             6.72GiB

/dev/sdg, ID: 4
   Device size:             8.00GiB
   Data,RAID6:              1.00GiB
   Metadata,RAID6:        256.00MiB
   Unallocated:             6.75GiB


Steps to reproduce:
1) Create and mount RAID6
2) remove drive belonging to RAID, try write and let kernel code close
the device
3) replace missing device by 'btrfs replace start' command
4) remove drive in another slot, try write, wait for closing of it
5) start replacing of missing drive -> ERRORS.

If full balance after step 3) was done, no errors appeared.
