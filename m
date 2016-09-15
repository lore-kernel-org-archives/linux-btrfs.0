Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:35214 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754112AbcIOHoV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 03:44:21 -0400
Received: by mail-wm0-f46.google.com with SMTP id i130so85041268wmf.0
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Sep 2016 00:44:21 -0700 (PDT)
Received: from [192.168.0.1] (alexandrepoux.fr. [82.239.190.36])
        by smtp.googlemail.com with ESMTPSA id r8sm2051152wjs.22.2016.09.15.00.44.18
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Sep 2016 00:44:18 -0700 (PDT)
To: linux-btrfs@vger.kernel.org
From: Alexandre Poux <pums974@gmail.com>
Subject: multi-device btrfs with single data mode and disk failure
Message-ID: <1634818f-ff1d-722c-6d73-747ed7203a13@gmail.com>
Date: Thu, 15 Sep 2016 09:44:18 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I had a btrfs partition on a 6 disk array without raid (metadata in
raid10, but data in single), and one of the disks just died.

So I lost some of my data, ok, I knew that.

But two question :

  *

    Is it possible to know (using metadata I suppose) what data I have
    lost ?

  *

    Is it possible to do some king of a "btrfs delete missing" on this
    kind of setup, in order to recover access in rw to my other data, or
    I must copy all my data on a new partition

I haven't been able to get any answer on google or in the wiki, so I
send here an e-mail, hoping that's the right place. Excuse me, if I'm wrong.

Thank you for any help

(Sorry for my poor english)

uname -a :
Linux Grand-PC 4.7.2-1-ARCH #1 SMP PREEMPT Sat Aug 20 23:02:56 CEST 2016
x86_64 GNU/Linux

btrfs --version :
btrfs-progs v4.7.1

btrfs fi show :
Label: 'Data'  uuid: 62db560b-a040-4c64-b613-6e7db033dc4d
    Total devices 6 FS bytes used 6.66TiB
    devid    1 size 2.53TiB used 2.12TiB path /dev/sdd6
    devid    7 size 2.53TiB used 2.12TiB path /dev/sdb6
    devid    9 size 262.57GiB used 0.00B path /dev/sde6
    devid   11 size 2.53TiB used 2.12TiB path /dev/sdc6
    devid   12 size 728.32GiB used 312.03GiB path /dev/sda6
    *** Some devices missing


mount -o recovery,ro,degraded /dev/sda6 /Data

relevant part of dmesg :
[ 1828.093704] BTRFS warning (device sda6): 'recovery' is deprecated,
use 'usebackuproot' instead
[ 1828.093708] BTRFS info (device sda6): trying to use backup root at
mount time
[ 1828.093718] BTRFS info (device sda6): allowing degraded mounts
[ 1828.093719] BTRFS info (device sda6): disk space caching is enabled
[ 1828.107763] BTRFS warning (device sda6): devid 8 uuid
950378c0-307c-413d-9805-ab2bb899aa78 missing

btrfs fi df /Data
Data, single: total=6.65TiB, used=6.65TiB
System, RAID1: total=32.00MiB, used=768.00KiB
Metadata, RAID1: total=13.00GiB, used=10.99GiB
GlobalReserve, single: total=512.00MiB, used=0.00B



