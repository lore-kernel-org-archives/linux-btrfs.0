Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:34698 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751835AbdHBI1y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Aug 2017 04:27:54 -0400
Received: by mail-wr0-f181.google.com with SMTP id 12so15766328wrb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Aug 2017 01:27:53 -0700 (PDT)
From: Thomas Wurfbaum <thomas@wurfbaum.net>
To: linux-btrfs@vger.kernel.org
Reply-To: thomas@wurfbaum.net
Subject: Crashed filesystem, nothing helps
Date: Wed, 02 Aug 2017 10:27:50 +0200
Message-ID: <1569935.QpkscbukDQ@nimrod.thomas.wurfbaum.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Yesterday morning i recognized a hard reboot of my system, but the /data 
filesystem was 
not possible to mount.


mainframe:~ # uname -a
Linux mainframe 4.11.8-2-default #1 SMP PREEMPT Thu Jun 29 14:37:33 UTC 2017 
(42bd7a0) x86_64 x86_64 x86_64 GNU/Linux
mainframe:~ # btrfs --version
btrfs-progs v4.10.2+20170406
mainframe:~ # btrfs fi show
Label: none  uuid: 22aaaa76-0885-4683-ac04-477c27cfab80
        Total devices 1 FS bytes used 2.88TiB
        devid    1 size 4.53TiB used 2.92TiB path /dev/sdb1
mainframe:~ # btrfs restore /dev/sdb1 /mnt     
parent transid verify failed on 29392896 wanted 1486833 found 1486836
parent transid verify failed on 29392896 wanted 1486833 found 1486836
parent transid verify failed on 29392896 wanted 1486833 found 1486836
parent transid verify failed on 29392896 wanted 1486833 found 1486836
Ignoring transid failure
parent transid verify failed on 29409280 wanted 1486829 found 1486833
parent transid verify failed on 29409280 wanted 1486829 found 1486833
parent transid verify failed on 29409280 wanted 1486829 found 1486833
parent transid verify failed on 29409280 wanted 1486829 found 1486833
Ignoring transid failure
parent transid verify failed on 29376512 wanted 1327723 found 1486833
parent transid verify failed on 29376512 wanted 1327723 found 1486833
parent transid verify failed on 29376512 wanted 1327723 found 1486833
parent transid verify failed on 29376512 wanted 1327723 found 1486833
Ignoring transid failure
mainframe:~ # mount /dev/sdb1 /data                 
mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.
mainframe:~ # mount -o usebackuproot /dev/sdb1 /data
mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.
mainframe:~ # btrfs check /dev/sdb1
parent transid verify failed on 29392896 wanted 1486833 found 1486836
parent transid verify failed on 29392896 wanted 1486833 found 1486836
parent transid verify failed on 29392896 wanted 1486833 found 1486836
parent transid verify failed on 29392896 wanted 1486833 found 1486836
Ignoring transid failure
parent transid verify failed on 29409280 wanted 1486829 found 1486833
parent transid verify failed on 29409280 wanted 1486829 found 1486833
parent transid verify failed on 29409280 wanted 1486829 found 1486833
parent transid verify failed on 29409280 wanted 1486829 found 1486833
Ignoring transid failure
parent transid verify failed on 29376512 wanted 1327723 found 1486833
parent transid verify failed on 29376512 wanted 1327723 found 1486833
parent transid verify failed on 29376512 wanted 1327723 found 1486833
parent transid verify failed on 29376512 wanted 1327723 found 1486833
Ignoring transid failure
Checking filesystem on /dev/sdb1
UUID: 22aaaa76-0885-4683-ac04-477c27cfab80
checking extents
parent transid verify failed on 290766848 wanted 1486826 found 1486085
parent transid verify failed on 290766848 wanted 1486826 found 1486085
parent transid verify failed on 290766848 wanted 1486826 found 1486085
parent transid verify failed on 290766848 wanted 1486826 found 1486085
Ignoring transid failure
parent transid verify failed on 292339712 wanted 1486826 found 1486086
parent transid verify failed on 292339712 wanted 1486826 found 1486086
parent transid verify failed on 291078144 wanted 1486826 found 1486085
parent transid verify failed on 291078144 wanted 1486826 found 1486085
parent transid verify failed on 291078144 wanted 1486826 found 1486085
parent transid verify failed on 291078144 wanted 1486826 found 1486085
Ignoring transid failure
parent transid verify failed on 292978688 wanted 1486826 found 1486086
parent transid verify failed on 292978688 wanted 1486826 found 1486086
parent transid verify failed on 292978688 wanted 1486826 found 1486086
parent transid verify failed on 292978688 wanted 1486826 found 1486086
Ignoring transid failure
parent transid verify failed on 292519936 wanted 1486826 found 1486086
parent transid verify failed on 292519936 wanted 1486826 found 1486086
parent transid verify failed on 292536320 wanted 1486826 found 1486086
parent transid verify failed on 292536320 wanted 1486826 found 1486086
parent transid verify failed on 292552704 wanted 1486826 found 1486086
parent transid verify failed on 292552704 wanted 1486826 found 1486086
parent transid verify failed on 292585472 wanted 1486826 found 1486086
parent transid verify failed on 292585472 wanted 1486826 found 1486086
parent transid verify failed on 292585472 wanted 1486826 found 1486086
parent transid verify failed on 292585472 wanted 1486826 found 1486086
Ignoring transid failure
parent transid verify failed on 290766848 wanted 1486826 found 1486085
Ignoring transid failure
leaf parent key incorrect 290766848
bad block 290766848
ERROR: errors found in extent allocation tree or chunk allocation
parent transid verify failed on 290766848 wanted 1486826 found 1486085
Ignoring transid failure
leaf parent key incorrect 290766848
ERROR: failed to repair root items: Operation not permitted
mainframe:~ # btrfs rescue super-recover /dev/sdb1
All supers are valid, no need to recover
mainframe:~ # btrfs rescue zero-log /dev/sdb1
parent transid verify failed on 29392896 wanted 1486833 found 1486836
parent transid verify failed on 29392896 wanted 1486833 found 1486836
parent transid verify failed on 29392896 wanted 1486833 found 1486836
parent transid verify failed on 29392896 wanted 1486833 found 1486836
Ignoring transid failure
parent transid verify failed on 29409280 wanted 1486829 found 1486833
parent transid verify failed on 29409280 wanted 1486829 found 1486833
parent transid verify failed on 29409280 wanted 1486829 found 1486833
parent transid verify failed on 29409280 wanted 1486829 found 1486833
Ignoring transid failure
parent transid verify failed on 29376512 wanted 1327723 found 1486833
parent transid verify failed on 29376512 wanted 1327723 found 1486833
parent transid verify failed on 29376512 wanted 1327723 found 1486833
parent transid verify failed on 29376512 wanted 1327723 found 1486833
Ignoring transid failure
Clearing log on /dev/sdb1, previous log_root 0, level 0
parent transid verify failed on 29474816 wanted 1486833 found 1486837
Ignoring transid failure
leaf parent key incorrect 29474816
disk-io.c:524: update_cowonly_root: BUG_ON `ret` triggered, value -1
btrfs(+0x26304)[0x555686369304]
btrfs(btrfs_commit_transaction+0x98)[0x55568636aed8]
btrfs(+0x69efa)[0x5556863acefa]
btrfs(main+0x84)[0x555686361e34]
/lib64/libc.so.6(__libc_start_main+0xf1)[0x7f43653df291]
btrfs(_start+0x2a)[0x555686361f4a]
Aborted (core dumped)
mainframe:~ # btrfs rescue chunk-recover /dev/sdb1
This command still runs, even after 15 hours.

Is there anything else i could do?

Regards,
Thomas




