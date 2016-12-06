Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1.tango.lu ([212.66.75.102]:33562 "HELO mail.tango.lu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
        id S1751593AbcLFNIT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Dec 2016 08:08:19 -0500
Received: from mail.tango.lu (localhost [127.0.0.1])
        by mail.tango.lu (Postfix) with ESMTP id B3FC6385844
        for <linux-btrfs@vger.kernel.org>; Tue,  6 Dec 2016 14:00:28 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 06 Dec 2016 14:00:28 +0100
From: Luescher Claude <stargate@tango.lu>
To: linux-btrfs@vger.kernel.org
Subject: *** Some devices missing ***
Message-ID: <004e03916ff78571800ae947487813d3@tango.lu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have the following array:

Label: 'backup_fs'  uuid: xxxxx
         Total devices 10 FS bytes used 13.46TiB
         devid    1 size 3.64TiB used 3.32TiB path /dev/sdf
         devid    2 size 3.64TiB used 3.32TiB path /dev/sde
         devid    3 size 3.64TiB used 3.32TiB path /dev/sdd
         devid    4 size 3.64TiB used 3.32TiB path /dev/sdg
         devid    5 size 3.64TiB used 3.33TiB path /dev/sdh
         devid    6 size 3.64TiB used 3.33TiB path /dev/sdi
         devid    7 size 3.64TiB used 3.33TiB path /dev/sdc
         devid    8 size 5.46TiB used 1.82TiB path /dev/sdb
         devid    9 size 5.46TiB used 1.82TiB path /dev/sdj
         *** Some devices missing

The server was running 3.13 kernel and btrfs progs 4.0  until it 
crashed. After that mounting the file system hang forever so I decided 
to switch to Linux Kernel 4.8.11 and btrfs-progs v4.8.5.

There are of course no missing devices.  This is what I get in dmesg 
when I try to mount the array with or without the degraded option:

[  362.906958] BTRFS info (device sdf): disk space caching is enabled
[  363.066379] BTRFS error (device sdf): super_num_devices 10 mismatch 
with num_devices 9 found here
[  363.067095] BTRFS error (device sdf): failed to read chunk tree: -22
[  363.086089] BTRFS: open_ctree failed
[  438.747338] BTRFS info (device sdf): allowing degraded mounts
[  438.747341] BTRFS info (device sdf): disk space caching is enabled
[  438.993190] BTRFS error (device sdf): super_num_devices 10 mismatch 
with num_devices 9 found here
[  438.993914] BTRFS error (device sdf): failed to read chunk tree: -22
[  439.013552] BTRFS: open_ctree failed


I only find an old 2014 list entry that it was some bug and fixed so it 
should be long time fixed in 4.8.5. I need to put the device back to 
operation as soon as possible. Anybody have any further ideas what can I 
do?

I running btrfsck on the array and at least that works, but I doubt that 
it will do anything useful.

Thanks
