Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:36365 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbcCYO5o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 10:57:44 -0400
Received: by mail-lf0-f45.google.com with SMTP id d82so56470532lfe.3
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Mar 2016 07:57:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA7pwKNj+qEUk+RhzyceRFqThzhUkroYMxS3b3gAn_5KEyawMQ@mail.gmail.com>
References: <1458906560.3786108.559411242.3678497C@webmail.messagingengine.com>
 <CAA7pwKNj+qEUk+RhzyceRFqThzhUkroYMxS3b3gAn_5KEyawMQ@mail.gmail.com>
From: Patrik Lundquist <patrik.lundquist@gmail.com>
Date: Fri, 25 Mar 2016 15:57:23 +0100
Message-ID: <CAA7pwKNgDi9C8E+duwNA6H8MrT1nVEHkWAm4=JZp3GjFgAvZ1g@mail.gmail.com>
Subject: Re: Possible Raid Bug
To: Stephen Williams <stephenw@veryfast.biz>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Debian Stretch with Linux 4.4.6, btrfs-progs 4.4 in VirtualBox
5.0.16 with 4*2GB VDIs:

# mkfs.btrfs -m raid10 -d raid10 /dev/sdb /dev/sdc /dev/sdd /dev/sdbe

# mount /dev/sdb /mnt
# touch /mnt/test
# umount /mnt

Everything fine so far.

# wipefs -a /dev/sde

*reboot*

# mount /dev/sdb /mnt
mount: wrong fs type, bad option, bad superblock on /dev/sdb,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.

# dmesg | tail
[   85.979655] BTRFS info (device sdb): disk space caching is enabled
[   85.979660] BTRFS: has skinny extents
[   85.982377] BTRFS: failed to read the system array on sdb
[   85.996793] BTRFS: open_ctree failed

Not very informative! An information regression?

# mount -o degraded /dev/sdb /mnt

# dmesg | tail
[  919.899071] BTRFS info (device sdb): allowing degraded mounts
[  919.899075] BTRFS info (device sdb): disk space caching is enabled
[  919.899077] BTRFS: has skinny extents
[  919.903216] BTRFS warning (device sdb): devid 4 uuid
8549a275-f663-4741-b410-79b49a1d465f is missing

# touch /mnt/test2
# ls -l /mnt/
total 0
-rw-r--r-- 1 root root 0 mar 25 15:17 test
-rw-r--r-- 1 root root 0 mar 25 15:42 test2

# btrfs device remove missing /mnt
ERROR: error removing device 'missing': unable to go below four
devices on raid10

As expected.

# btrfs replace start -B missing /dev/sde /mnt
ERROR: source device must be a block device or a devid

Would have been nice if missing worked here too. Maybe it does in
btrfs-progs 4.5?

# btrfs replace start -B 4 /dev/sde /mnt

# dmesg | tail
[ 1618.170619] BTRFS info (device sdb): dev_replace from <missing
disk> (devid 4) to /dev/sde started
[ 1618.184979] BTRFS info (device sdb): dev_replace from <missing
disk> (devid 4) to /dev/sde finished

Repaired!

# umount /mnt
# mount /dev/sdb /mnt
# dmesg | tail
[ 1729.917661] BTRFS info (device sde): disk space caching is enabled
[ 1729.917665] BTRFS: has skinny extents

All in all it works just fine with Linux 4.4.6.
