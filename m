Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:54235 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751493AbcIZKei (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Sep 2016 06:34:38 -0400
Received: from localhost (localhost [127.0.0.1])
        by mailext.virtall.com (Postfix) with ESMTP id 2CB652C40E0
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Sep 2016 12:34:34 +0200 (CEST)
Received: from mailext.virtall.com ([127.0.0.1])
        by localhost (web1.virtall.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id EGsUybvCAgkh for <linux-btrfs@vger.kernel.org>;
        Mon, 26 Sep 2016 12:34:32 +0200 (CEST)
Received: from admin.virtall.com (localhost [127.0.0.1])
        by mailext.virtall.com (Postfix) with ESMTP
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Sep 2016 12:34:32 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 26 Sep 2016 19:34:32 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: btrfs on md RAID-5 /etc/fstab mounting: open_ctree failed
Message-ID: <a890370e2811c5fe4d1aac187c0c8210@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My btrfs on md RAID-5 mounts in an odd way and fails to mount via 
/etc/fstab (kernel is 4.8-rc8).

This is /etc/fstab entry for btrfs:

/dev/md2 /data btrfs noatime,compress-force=zlib,device=/dev/md2 0 0


Following a system restart, it didn't mount with these in dmesg:

[   11.099524] Btrfs loaded, crc32c=crc32c-intel
[   11.100125] BTRFS: device label data devid 1 transid 118760 /dev/md2
[   11.187585] BTRFS info (device md2): force zlib compression
[   11.187587] BTRFS info (device md2): disk space caching is enabled
[   11.187588] BTRFS info (device md2): has skinny extents
[  106.215206] BTRFS: open_ctree failed



Then, it mounted fine after I did "mount -a":

[  243.131317] BTRFS info (device md2): force zlib compression
[  243.131320] BTRFS info (device md2): disk space caching is enabled
[  243.131322] BTRFS info (device md2): has skinny extents


It's the same after each reboot.

Is it expected? How do I make it "automount" via /etc/fstab?


# btrfs fi show /data
Label: 'data'  uuid: fddbd057-4fa6-4b2e-a9ca-993829bab4b9
         Total devices 1 FS bytes used 11.69TiB
         devid    1 size 16.30TiB used 11.88TiB path /dev/md2

# btrfs fi df /data
Data, single: total=11.79TiB, used=11.64TiB
System, DUP: total=8.00MiB, used=1.27MiB
Metadata, DUP: total=48.00GiB, used=45.88GiB
GlobalReserve, single: total=512.00MiB, used=0.00B


In /proc/mdstat:

md2 : active raid5 sdc3[2] sdd3[4] sda3[0] sdb3[1]
       17500952064 blocks super 1.2 level 5, 512k chunk, algorithm 2 
[4/4] [UUUU]


Tomasz Chmielewski
https://lxadm.com
