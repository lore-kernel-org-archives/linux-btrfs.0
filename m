Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:50871 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696AbaLAOrj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Dec 2014 09:47:39 -0500
Received: from [139.20.7.1] ([139.20.7.1]) by smtp.web.de (mrweb002) with
 ESMTPSA (Nemesis) id 0Mare6-1Xc7vO2upW-00KLh4 for
 <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 15:47:36 +0100
Message-ID: <547C7F7C.3080701@web.de>
Date: Mon, 01 Dec 2014 15:47:24 +0100
From: Oliver <r.oliver@web.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Online Drive Replacement: BTRFS with RAID 6
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

on a testing machine I installed four HDDs and they are configured as 
RAID6. For a test I removed one of the drives (/dev/sdk) while the 
volume was mounted and data was written to it. This worked well, as far 
as I can see. Some I/O errors were written to /var/log/syslog, but the 
volume kept working. Unfortunately the command "btrfs fi sh" did not 
show any missing drives. So I remounted the volume in degraded mode: 
"mount -t btrfs /dev/sdx1 -o remount,rw,degraded,noatime /mnt". This way 
the drive in question was reported as missing. Then I plugged in the HDD 
again (it is of course /dev/sdk again) and started a balancing in hope 
that this will restore RAID6: "btrfs filesystem balance start /mnt". Now 
the volume looks like this:

$ btrfs fi sh
Label: none  uuid: 28410e37-77c1-4c01-8075-0d5068d9ffc2
     Total devices 4 FS bytes used 257.05GiB
     devid    1 size 465.76GiB used 262.03GiB path /dev/sdi1
     devid    2 size 465.76GiB used 262.00GiB path /dev/sdj1
     devid    3 size 465.76GiB used 261.03GiB path /dev/sdh1
     devid    4 size 465.76GiB used 0.00 path /dev/sdk1

How do I reinitiate /dev/sdk1? As running "btrfs fi ba start /mnt" does 
not help, I tried to remove the hdd, but

$ btrfs de de /dev/sdk1 /mnt/
ERROR: error removing the device '/dev/sdk1' - unable to go below four 
devices on raid6

A replacement does not work this way either:

$ btrfs replace start -f -r /dev/sdk1 /dev/sdk1 /mnt
/dev/sdk1 is mounted

Are there other ways to replace/reinitiate the hdd then converting to 
RAID 5?


Here are some more information about my configuration:

$   uname -a
Linux hostname 3.13.0-30-generic #55-Ubuntu SMP Fri Jul 4 21:40:53 UTC 
2014 x86_64 x86_64 x86_64 GNU/Linux
$   btrfs --version
Btrfs v3.12
$ btrfs fi df /mnt
Data, RAID6: total=263.00GiB, used=256.82GiB
System, RAID1: total=32.00MiB, used=36.00KiB
Metadata, RAID1: total=1.00GiB, used=271.13MiB
