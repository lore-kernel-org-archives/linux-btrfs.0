Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:32938 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751227AbcLEC2i (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Dec 2016 21:28:38 -0500
Received: by mail-pg0-f46.google.com with SMTP id 3so130938335pgd.0
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Dec 2016 18:28:38 -0800 (PST)
Received: from [172.27.27.99] (122-59-45-101.jetstream.xtra.co.nz. [122.59.45.101])
        by smtp.gmail.com with ESMTPSA id a30sm22716830pgd.45.2016.12.04.18.28.34
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Dec 2016 18:28:36 -0800 (PST)
To: linux-btrfs@vger.kernel.org
From: Calle Kabo <calle.kabo@gmail.com>
Subject: btrfs repair and zero-log doesn't seem to do anything
Message-ID: <d3fdffb8-b5b5-11a7-1e04-d40c75059be7@gmail.com>
Date: Mon, 5 Dec 2016 15:28:30 +1300
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------62280DD6EC2BF19ADC61D16A"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------62280DD6EC2BF19ADC61D16A
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi,

I've got a Netgear NAS with an encrypted 4 disk RAID5 setup. One of the
hard drives was emailing me about errors so I swapped it out before it
died. While syncing another disk died. So I've cloned the disk I
replaced before it died and managed to get the array running again. You
can read more about that here:
https://community.netgear.com/t5/Using-your-ReadyNAS/Re-adding-disk-to-volume/m-p/1179982/highlight/false

But now BTRFS won't mount. I'd like to mount it read only so I can move
the stuff to another drive and then format the NAS into a new array. If
there's some data loss that's fine, the most important stuff is already
backed up, but there are a few things that aren't backed up that I find
it worth the effort of trying to restore if at all possible.

Mandatory information:
root@MyNAS:~# uname -a
Linux MyNAS 4.1.30.armada.1 #1 SMP Thu Sep 22 16:39:49 PDT 2016 armv7l
GNU/Linux
root@MyNAS:~# btrfs --version
btrfs-progs v4.7.3
root@MyNAS:~# btrfs fi show
Label: '0e35246e:data'  uuid: b6283e48-ebd3-4fdb-8976-b66b1f0868bc
        Total devices 1 FS bytes used 3.99TiB
        devid    1 size 8.17TiB used 4.22TiB path /dev/dm-0

Here's what I've done (/dev/mapper/data-0 is symlinked to /dev/dm-0 so
they're interchangeable):

root@MyNAS:~# mount -t btrfs -o ro,recovery,nospace_cache,clear_cache
/dev/dm-0 /data
mount: wrong fs type, bad option, bad superblock on /dev/mapper/data-0,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.
root@MyNAS:~# dmesg | tail
[25168.491582] BTRFS info (device dm-0): enabling auto recovery
[25168.724395] BTRFS (device dm-0): parent transid verify failed on
2474687627264 wanted 558760 found 558769
[25168.732497] BTRFS (device dm-0): parent transid verify failed on
2474687627264 wanted 558760 found 558769
[25168.734444] BTRFS (device dm-0): parent transid verify failed on
2474687627264 wanted 558760 found 558769
[25168.736294] BTRFS (device dm-0): parent transid verify failed on
2474687627264 wanted 558760 found 558769
[25169.583328] BTRFS (device dm-0): bad tree block start
6746185026026631152 3067274493952
[25169.595978] BTRFS (device dm-0): bad tree block start
13892978140409233545 3067274493952
[25169.597777] BTRFS (device dm-0): bad tree block start
6746185026026631152 3067274493952
[25169.599472] BTRFS (device dm-0): bad tree block start
13892978140409233545 3067274493952
[25169.599516] BTRFS: Failed to read block groups: -5
[25169.640222] BTRFS: open_ctree failed

root@MyNAS:~# btrfs rescue zero-log /dev/mapper/data-0
parent transid verify failed on 2474648240128 wanted 558760 found 558765
parent transid verify failed on 2474648240128 wanted 558760 found 558765
parent transid verify failed on 2474648240128 wanted 558760 found 558765
parent transid verify failed on 2474648240128 wanted 558760 found 558765
Ignoring transid failure
parent transid verify failed on 2474688413696 wanted 558760 found 558769
parent transid verify failed on 2474688413696 wanted 558760 found 558769
parent transid verify failed on 2474688413696 wanted 558760 found 558769
parent transid verify failed on 2474688413696 wanted 558760 found 558769
Ignoring transid failure
parent transid verify failed on 2474691854336 wanted 558765 found 558758
parent transid verify failed on 2474691854336 wanted 558765 found 558758
parent transid verify failed on 2474691854336 wanted 558765 found 558758
parent transid verify failed on 2474691854336 wanted 558765 found 558758
Ignoring transid failure
leaf parent key incorrect 2474691854336
Clearing log on /dev/mapper/data-0, previous log_root 0, level 0
Unable to find block group for 0
extent-tree.c:289: find_search_start: Assertion `1` failed.

The output of btrfs check --repair /dev/mapper/data-0 is attached.

What should I do next? Run --init-csum-tree? btrfs restore to a USB
drive? Any help much appreciated.

/Calle

--------------62280DD6EC2BF19ADC61D16A
Content-Type: text/x-log;
 name="btrfsrepair.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="btrfsrepair.log"

parent transid verify failed on 2474648240128 wanted 558760 found 558765
parent transid verify failed on 2474648240128 wanted 558760 found 558765
parent transid verify failed on 2474648240128 wanted 558760 found 558765
parent transid verify failed on 2474648240128 wanted 558760 found 558765
Ignoring transid failure
parent transid verify failed on 2474688413696 wanted 558760 found 558769
parent transid verify failed on 2474688413696 wanted 558760 found 558769
parent transid verify failed on 2474688413696 wanted 558760 found 558769
parent transid verify failed on 2474688413696 wanted 558760 found 558769
Ignoring transid failure
parent transid verify failed on 2474691854336 wanted 558765 found 558758
parent transid verify failed on 2474691854336 wanted 558765 found 558758
parent transid verify failed on 2474691854336 wanted 558765 found 558758
parent transid verify failed on 2474691854336 wanted 558765 found 558758
Ignoring transid failure
leaf parent key incorrect 2474691854336
checking extents
parent transid verify failed on 2474682548224 wanted 558760 found 558769
parent transid verify failed on 2474682548224 wanted 558760 found 558769
parent transid verify failed on 2474682548224 wanted 558760 found 558769
parent transid verify failed on 2474682548224 wanted 558760 found 558769
Ignoring transid failure
parent transid verify failed on 2474721148928 wanted 558758 found 558769
parent transid verify failed on 2474721148928 wanted 558758 found 558769
parent transid verify failed on 2474721148928 wanted 558758 found 558769
parent transid verify failed on 2474721148928 wanted 558758 found 558769
Ignoring transid failure
checksum verify failed on 2474683826176 found A7762F46 wanted 1C12DF79
checksum verify failed on 2474683826176 found A7762F46 wanted 1C12DF79
checksum verify failed on 2474683826176 found 7B09FD0A wanted 6F493491
checksum verify failed on 2474683826176 found 7B09FD0A wanted 6F493491
bytenr mismatch, want=2474683826176, have=13830340915957161993
parent transid verify failed on 2474648338432 wanted 558765 found 558760
parent transid verify failed on 2474648338432 wanted 558765 found 558760
parent transid verify failed on 2474648338432 wanted 558765 found 558760
parent transid verify failed on 2474648338432 wanted 558765 found 558760
Ignoring transid failure
parent transid verify failed on 2474648338432 wanted 558765 found 558760
Ignoring transid failure
parent transid verify failed on 2474648338432 wanted 558765 found 558760
Ignoring transid failure
parent transid verify failed on 2474648338432 wanted 558765 found 558760
Ignoring transid failure
parent transid verify failed on 2474648338432 wanted 558765 found 558760
Ignoring transid failure
parent transid verify failed on 2474648338432 wanted 558765 found 558760
Ignoring transid failure
parent transid verify failed on 2474648338432 wanted 558765 found 558760
Ignoring transid failure
parent transid verify failed on 2474648338432 wanted 558765 found 558760
Ignoring transid failure
parent transid verify failed on 2474648338432 wanted 558765 found 558760
Ignoring transid failure
parent transid verify failed on 2474648338432 wanted 558765 found 558760
Ignoring transid failure
parent transid verify failed on 2474648338432 wanted 558765 found 558760
Ignoring transid failure
parent transid verify failed on 2474648338432 wanted 558765 found 558760
Ignoring transid failure
parent transid verify failed on 2474648338432 wanted 558765 found 558760
Ignoring transid failure
parent transid verify failed on 2474648338432 wanted 558765 found 558760
Ignoring transid failure
parent transid verify failed on 2474648338432 wanted 558765 found 558760
Ignoring transid failure
parent transid verify failed on 2474648338432 wanted 558765 found 558760
Ignoring transid failure
parent transid verify failed on 2474648338432 wanted 558765 found 558760
Ignoring transid failure
parent transid verify failed on 2474648338432 wanted 558765 found 558760
Ignoring transid failure
parent transid verify failed on 2474648338432 wanted 558765 found 558760
Ignoring transid failure
parent transid verify failed on 2474682548224 wanted 558760 found 558769
Ignoring transid failure
parent transid verify failed on 2474648338432 wanted 558765 found 558760
Ignoring transid failure
leaf parent key incorrect 2474682548224
bad block 2474682548224
Errors found in extent allocation tree or chunk allocation
parent transid verify failed on 2474691854336 wanted 558765 found 558758
Ignoring transid failure
leaf parent key incorrect 2474691854336
extent buffer leak: start 2474648240128 len 32768
extent buffer leak: start 2474648240128 len 32768
extent buffer leak: start 2474648240128 len 32768
extent buffer leak: start 2474648240128 len 32768
extent buffer leak: start 2474648240128 len 32768
extent buffer leak: start 2474648240128 len 32768
extent buffer leak: start 2474648240128 len 32768
extent buffer leak: start 2474648240128 len 32768
extent buffer leak: start 2474648240128 len 32768
extent buffer leak: start 2474648240128 len 32768
extent buffer leak: start 2474648240128 len 32768
extent buffer leak: start 2474648240128 len 32768
extent buffer leak: start 2474648240128 len 32768
extent buffer leak: start 2474648240128 len 32768
extent buffer leak: start 2474648240128 len 32768
extent buffer leak: start 2474648240128 len 32768
extent buffer leak: start 2474648240128 len 32768
extent buffer leak: start 2474648240128 len 32768
extent buffer leak: start 2474648240128 len 32768
extent buffer leak: start 2474648240128 len 32768
enabling repair mode
Checking filesystem on /dev/mapper/data-0
UUID: b6283e48-ebd3-4fdb-8976-b66b1f0868bc

--------------62280DD6EC2BF19ADC61D16A--
