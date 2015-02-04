Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f181.google.com ([209.85.160.181]:49741 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbbBDHC5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Feb 2015 02:02:57 -0500
Received: by mail-yk0-f181.google.com with SMTP id 79so26343504ykr.12
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Feb 2015 23:02:56 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 4 Feb 2015 00:02:56 -0700
Message-ID: <CAJCQCtS1cTQqbsYM01baLUmqTXDNE5HZfM-uL8gx0HkHXo-a+A@mail.gmail.com>
Subject: paused balance convert from raid1 can no longer be a writeable mount
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Problem occurs with 3.19.0-0.rc7.git0.1.fc22.x86_64, no regression
testing or attempt to reproduce has been done yet. But the file system
isn't particularly old.

Steps 1-6 occur with kernel 3.16 through 3.19 with no errors.

1. mkfs.btrfs -draid1 -mraid1 /dev/sd[bc]  ## btrfs-progs ~3.16 or 3.17
2. mount /dev/sdb /mnt/btr
3. copy some files to /mnt/btr
4. unmount /mnt/btr
5. Disconnect /dev/sdc

Steps 6-10 occur only with kernel 3.19

6. mount -odegraded /dev/sdb /mnt/btr
7. btrfs balance start -dconvert=single -mconvert=single -f /mnt/btr
8. In another shell, btrfs balance pause /mnt/btr
9. Wait for pause confirmation in 1st shell, then umount /mnt/btr
10. mount -odegraded /dev/sdb /mnt/btr

-msingle=dup was disallowed so I chose single

[ 2029.715092] BTRFS error (device sdc): unable to start balance with
target metadata profile 32


Result when mounting:

[39691.150313] BTRFS info (device sdb): allowing degraded mounts
[39691.152501] BTRFS info (device sdb): disk space caching is enabled
[39693.756987] BTRFS: too many missing devices, writeable mount is not allowed
[39693.778349] BTRFS: open_ctree failed

I have no reason to think this is a regression, but haven't tried
older kernels yet.

Additional information:


[ 5719.840900] BTRFS info (device sdc): found 16 extents
[ 6097.761142] usb 1-1.4: USB disconnect, device number 4
[ 6097.774052] sd 3:0:0:0: [sdc] Synchronizing SCSI cache
[ 6097.783575] sd 3:0:0:0: [sdc] Synchronize Cache(10) failed: Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK

5719 is about the time of the balance pause. I don't know the meaning
of the last two messages or their implication in possibly causing the
problem.


[root@f22s ~]# btrfs check /dev/sdb
warning, device 2 is missing
warning devid 2 not found already
Checking filesystem on /dev/sdb
UUID: 0f1c615f-30a0-4166-8a3c-987849551513
checking extents
checking free space cache
Error reading 476011409408, -1
failed to load free space cache for block group 476368076800
checking fs roots
checking csums
checking root refs
found 164679408219 bytes used err is 0
total csum bytes: 354762924
total tree bytes: 608239616
total fs tree bytes: 139395072
total extent tree bytes: 58785792
btree space waste bytes: 84024816
file data blocks allocated: 378008100864
 referenced 385864163328
Btrfs v3.18.2

No change with -orecovery,degraded; -oro,degraded does mount.

btrfs-image -c9 -t4 uses 100% CPU and hangs indefinitely, 353MB image here:
https://drive.google.com/file/d/0B_2Asp8DGjJ9b2p0aUpGUTVzVU0/view?pli=1

bug report for writeable mount fail is here, includes dmesg
https://bugzilla.kernel.org/show_bug.cgi?id=92641

separate bug report for btrfs-image hang (includes strace), here
https://bugzilla.kernel.org/show_bug.cgi?id=92651




-- 
Chris Murphy
