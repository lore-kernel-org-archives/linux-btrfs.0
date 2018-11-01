Return-Path: <SRS0=DppP=NM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B867C0044C
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 11:59:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E3A42081B
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 11:59:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E3A42081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=web.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbeKAVCJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 1 Nov 2018 17:02:09 -0400
Received: from mout.web.de ([212.227.15.3]:45355 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728266AbeKAVCJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Nov 2018 17:02:09 -0400
Received: from [139.20.65.111] ([139.20.65.111]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LiUZg-1fhkLj0OD6-00cfVS for
 <linux-btrfs@vger.kernel.org>; Thu, 01 Nov 2018 12:59:27 +0100
Received: from [139.20.65.111] ([139.20.65.111]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LiUZg-1fhkLj0OD6-00cfVS for
 <linux-btrfs@vger.kernel.org>; Thu, 01 Nov 2018 12:59:27 +0100
To:     linux-btrfs@vger.kernel.org
From:   "Oliver R." <r.oliver@web.de>
Subject: BTRFS RAID5 disk failed while balancing
Message-ID: <fb23de3a-c269-4f84-10d0-dd1055e6b653@web.de>
Date:   Thu, 1 Nov 2018 12:59:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-LU
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:Ll7ngWmYbo8PCKgVEceKe5yuZHiRE4BhY2zJjb0pGbx+ktHe7k2
 egl0XPgSNPBLLCCYBDgmy6tYWdIxPW568qdxrqUEQ0EeSl4iSY/uXvAfCv8d7/YCTRBZJ6K
 IlyUrFeFTBmNB4ARj1gboF8FQ7hNVYRHfxYhXefQcFlD+nwCrX2Vq6x+7H7zpM1vH0EEF8/
 tjP38wgfk7GK/vsUYq3QQ==
X-UI-Out-Filterresults: notjunk:1;V01:K0:BfnuEOIfhlY=:hdjCU6fROOdO23dPNeImuG
 OTG7Y65RF0g219/HFimSmYxURlXiSip2SyjHHm0HY7spPvfCCYcp5sU58WX6keaM2yHjdpi90
 gWdANjgUXkHEr2LpoD6eeTULIEJ8joN6yEkl4/d33MwC+iQHvXzNtATcGeJif8uVp0HwvxLUC
 bKHGj+GrvNBRPDMjBMp85nW4JFj8NqeGGQLnjSv9ncgciITnkhtRErCZNhxk6BW53u+m2KY/B
 GhhEZn6gt1miOHb7MDKjuGvi565LxqYt2X+oS/AgFgfK82v/ZVAOssJZ4ne9BmUfurGoQjAkr
 lkIB8I48ez4msMicFDugTVgZU0yBQPJYJiyxxRZ9TFxzVON0V3aRuaP15aTz2nzcMhCGX6SWh
 MCwd6hMI+qMeRN+P5ulJrFXnUg0jFntLwpnEVN7Q+sU+jtulO9m99T1ZKvhmovNPcDioIuHo5
 Y+arknhI2++AOqBGmGQApo4yYQTDWGDLNH2SCFgv3Zb8KN5/gOxAk6lwGuQWoHjXjN11/A2do
 o1udbC8sA5KQtTZcHCDjtu9manaX9kz+LCEqlByIKkp0FEXr2g0J0iuTNrQ3lzE201cOOPzVe
 H6nkedBUD+/1PZ2cj0mIjYwp5YSvXH8XV4EYiIuWAoQTu3XGi1pOz/6cEep5+THIDMIuIN5CU
 sxMTd52LF+KdovzEeoHqzzo2BT18UKL8J9leEfyb+TyDcZVslKmrO36dz40xAu7ejttQBasGq
 xxRIUN4Z+LlF1E21txtst3zUS0gpYtbRxFY1Sh09opln06nKHBW0DOA0makk4BevIXty2yYns
 MNwo1Iq0KeQHFyYhK2DCOhGWXplQJVIgz4ku+0zpi1YOmoulGeb1MP7qvV/fZGdyQ4MIZo8P7
 fgO3Xj7mAPLLUMvbBkH8sOezOdHUpEzP+5LT7GMMOBx5o73auoSd79VkGzus3E
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

If you clicked on the link to this topic: Thank you!

I have the following setup:

6x 500GB HDD-Drives
1x 32GB NVME-SSD (Intel Optane)

I used bcache to setup up the SSD as caching device and all other six 
drives are backing devices. After all that was in place, I formatted the 
six HHDs with btrfs in RAID5. Everything works as expected for the last 
7 months now.

By now I have a spare of 6x 2TB HDD drives and I want to replace the old 
500GB disks one by one. So I started with the first one by deleting it 
from the btrfs. This worked fine, I had no issues there. After that I 
cleanly detached the empty disk from bcache, still everything is fine, 
so I removed it. Here are the commandlines for this:

     sudo btrfs device delete /dev/bcacheX /media/raid
     cat /sys/block/bcacheX/bcache/state
     cat /sys/block/bcacheX/bcache/dirty_data
     sudo sh -c "echo 1 > /sys/block/bcacheX/bcache/detach"
     cat /sys/block/bcacheX/bcache/state

After that I installed one of 2TB drives, attached it to bcache and 
added it to the raid. The next step was to balance the data over to the 
new drive. Please see the commandlines:

     sudo make-bcache -B /dev/sdY
     sudo sh -c "echo '60a63f7c-2e68-4503-9f25-71b6b00e47b2' > 
/sys/block/bcacheY/bcache/attach"
     sudo sh -c "echo writeback > /sys/block/bcacheY/bcache/cache_mode"
     sudo btrfs device add /dev/bcacheY /media/raid
     sudo btrfs fi ba start /media/raid/

The balance worked fine until ~164GB were written to the new drive, this 
is about 50% of the data to be balanced. Suddenly write errors on the 
disk appear. The Raid slowly became unusable (I was running 3 VMs of the 
RAID while balancing). I think it worked for some time due to the SSD 
commiting the writes. At some point the balancing stopped and I was only 
able to kill the VMs. I checked the I/Os on the disks and the SSD spit 
out constant 1,2 GB/s read. I think the bcache somehow delivered data to 
the btrfs and it got rejected there and requested again, but this is 
just a guess. Anyway, I ended up resetting the host and I physically 
disconnected the broken disk and put a new one in place. I also created 
a bcache backing device on it and issued the following command to 
replace the faulty disk:

     sudo btrfs replace start -r 7 /dev/bcache5 /media/raid

The filesystem needs to be mounted read/write for this command to work. 
It is now doing its work, but very slow, about 3,5 MB/s. Unfortunately 
the syslog reports a lot of these messages:

     ...
     scrub_missing_raid56_worker: 62 callbacks suppressed
     BTRFS error (device bcache0): failed to rebuild valid logical 
4929143865344 for dev (null)
     ...
     BTRFS error (device bcache0): failed to rebuild valid logical 
4932249866240 for dev (null)
     scrub_missing_raid56_worker: 1 callbacks suppressed
     BTRFS error (device bcache0): failed to rebuild valid logical 
4933254250496 for dev (null)
     ....

If I try to read a file from the filesystem, the output-command fails 
with a simple I/O error and the syslog shows something entries similar 
to this:

     BTRFS warning (device bcache0): csum failed root 5 ino 1143 off 
7274496 csum 0xccccf554 expected csum 0x6340b527 mirror 2

So far, so good (or bad). It took about 6 hours for 4,3% of the 
replacement so far. No read or write errors have been reported for the 
replacement procedure ("btrfs replace status"). I will let it to its 
thing until finished. Before the first 2TB disk failed, 164 GB of data 
have been written according to "btrfs filesystem show". If  I check the 
amount of data written to the new drive, the 4,3% represent about 82 GB 
(according to /proc/diskstats). I don't know how to interpret this, but 
anyway.

And now finally my questions: If the replace command finishes 
successfully, what should I do next. A scrub? A balance? Another backup? ;-)
Do you see anything that I have done wrong in this procedure? Do the 
warnings and the errors reported from btrfs mean, that the data is lost? :-(

Here is some additional info (**edited**):

     $ sudo btrfs fi sh
     Total devices 7 FS bytes used 1.56TiB
     Label: none  uuid: 9f765025-5354-47e4-afcc-a601b2a52703
     devid    0 size 1.82TiB used 164.03GiB path /dev/bcache5
     devid    1 size 465.76GiB used 360.03GiB path /dev/bcache4
     devid    3 size 465.76GiB used 360.00GiB path /dev/bcache3
     devid    4 size 465.76GiB used 359.03GiB path /dev/bcache1
     devid    5 size 465.76GiB used 360.00GiB path /dev/bcache0
     devid    6 size 465.76GiB used 360.03GiB path /dev/bcache2
     *** Some devices missing

     $ sudo btrfs dev stats /media/raid/
     [/dev/bcache5].write_io_errs    0
     [/dev/bcache5].read_io_errs     0
     [/dev/bcache5].flush_io_errs    0
     [/dev/bcache5].corruption_errs  0
     [/dev/bcache5].generation_errs  0
     [/dev/bcache4].write_io_errs    0
     [/dev/bcache4].read_io_errs     0
     [/dev/bcache4].flush_io_errs    0
     [/dev/bcache4].corruption_errs  0
     [/dev/bcache4].generation_errs  0
     [/dev/bcache3].write_io_errs    0
     [/dev/bcache3].read_io_errs     0
     [/dev/bcache3].flush_io_errs    0
     [/dev/bcache3].corruption_errs  0
     [/dev/bcache3].generation_errs  0
     [/dev/bcache1].write_io_errs    0
     [/dev/bcache1].read_io_errs     0
     [/dev/bcache1].flush_io_errs    0
     [/dev/bcache1].corruption_errs  0
     [/dev/bcache1].generation_errs  0
     [/dev/bcache0].write_io_errs    0
     [/dev/bcache0].read_io_errs     0
     [/dev/bcache0].flush_io_errs    0
     [/dev/bcache0].corruption_errs  0
     [/dev/bcache0].generation_errs  0
     [/dev/bcache2].write_io_errs    0
     [/dev/bcache2].read_io_errs     0
     [/dev/bcache2].flush_io_errs    0
     [/dev/bcache2].corruption_errs  0
     [/dev/bcache2].generation_errs  0
     [devid:7].write_io_errs    9525186
     [devid:7].read_io_errs     10136573
     [devid:7].flush_io_errs    143
     [devid:7].corruption_errs  0
     [devid:7].generation_errs  0

     $ sudo btrfs fi df /media/raid/
     Data, RAID5: total=1.56TiB, used=1.55TiB
     System, RAID1: total=64.00MiB, used=128.00KiB
     Metadata, RAID1: total=4.00GiB, used=2.48GiB
     GlobalReserve, single: total=512.00MiB, used=0.00B

     $ uname -a
     Linux hostname 4.15.0-36-generic #39-Ubuntu SMP Mon Sep 24 16:19:09 
UTC 2018 x86_64 x86_64 x86_64 GNU/Linux

     $ btrfs --version
     btrfs-progs v4.15.1

     $ cat /etc/lsb-release
     DISTRIB_ID=Ubuntu
     DISTRIB_RELEASE=18.04
     DISTRIB_CODENAME=bionic
     DISTRIB_DESCRIPTION="Ubuntu 18.04.1 LTS"

The 'device replace' just finished. It was next to the 9% mark, I think 
this percentage matches the written amount of data on the drive: 164 GiB 
from a total size of 1,82 TiB. So 100% would mean a full 2TB 
replacemant. So here some additional output:

     $ btrfs replace status -1 /media/raid/
     Started on 30.Oct 08:16:53, finished on 30.Oct 21:05:22, 0 write 
errs, 0 uncorr. read errs

     $ sudo btrfs fi sh
     Label: none  uuid: 9f765025-5354-47e4-afcc-a601b2a52703
     Total devices 6 FS bytes used 1.56TiB
     devid    1 size 465.76GiB used 360.03GiB path /dev/bcache4
     devid    3 size 465.76GiB used 360.00GiB path /dev/bcache3
     devid    4 size 465.76GiB used 359.03GiB path /dev/bcache1
     devid    5 size 465.76GiB used 360.00GiB path /dev/bcache0
     devid    6 size 465.76GiB used 360.03GiB path /dev/bcache2
     devid    7 size 1.82TiB used 164.03GiB path /dev/bcache5

Reading files still aborts with I/O errors, syslog still shows:

     BTRFS warning (device bcache0): csum failed root 5 ino 1143 off 
7274496 csum 0x98f94189 expected csum 0x6340b527 mirror 1
     BTRFS warning (device bcache0): csum failed root 5 ino 1143 off 
7274496 csum 0xccccf554 expected csum 0x6340b527 mirror 2

So I think the most harmless action is a read-only scrub, I just started 
the process. Errors and warnings flood the syslog:

     $ sudo btrfs scrub start -BdrR /media/raid # -B no backgroud, -d 
statistics per device, -rread-only, -R raw statistics per device
     $ tail -f /var/log/syslog
     BTRFS error (device bcache0): bdev /dev/bcache5 errs: wr 0, rd 0, 
flush 0, corrupt 2848, gen 0
     BTRFS warning (device bcache0): checksum error at logical 
4590109331456 on dev /dev/bcache5, physical 2954104832, root 5, inode 
418, offset 1030803456, length 4096, links 1 (path: 
VMs/Virtualbox/Windows 10 Imaging VMs/Windows 10 Imaging/Windows 10 
Imaging-fixed.vdi)
     BTRFS error (device bcache0): bdev /dev/bcache5 errs: wr 0, rd 0, 
flush 0, corrupt 2849, gen 0
     BTRFS warning (device bcache0): checksum error at logical 
4590108811264 on dev /dev/bcache5, physical 2953977856, root 5, inode 
1533, offset 93051236352, length 4096, links 1 (path: 
VMs/Virtualbox/vmrbreb/vmrbreb-fixed.vdi)
     BTRFS error (device bcache0): bdev /dev/bcache5 errs: wr 0, rd 0, 
flush 0, corrupt 2850, gen 0
     BTRFS warning (device bcache0): checksum error at logical 
4590109335552 on dev /dev/bcache5, physical 2954108928, root 5, inode 
418, offset 1030807552, length 4096, links 1 (path: 
VMs/Virtualbox/Windows 10 Imaging VMs/Windows 10 Imaging/Windows 10 
Imaging-fixed.vdi)
     BTRFS error (device bcache0): bdev /dev/bcache5 errs: wr 0, rd 0, 
flush 0, corrupt 2851, gen 0
     BTRFS warning (device bcache0): checksum error at logical 
4590108815360 on dev /dev/bcache5, physical 2953981952, root 5, inode 
621, offset 11864412160, length 4096, links 1 (path: 
VMs/Virtualbox/Win102016_Alter-Firefox/Win102016_Alter-Firefox-disk1.vdi)
     BTRFS error (device bcache0): bdev /dev/bcache5 errs: wr 0, rd 0, 
flush 0, corrupt 2852, gen 0
     BTRFS warning (device bcache0): checksum error at logical 
4590109339648 on dev /dev/bcache5, physical 2954113024, root 5, inode 
418, offset 1030811648, length 4096, links 1 (path: 
VMs/Virtualbox/Windows 10 Imaging VMs/Windows 10 Imaging/Windows 10 
Imaging-fixed.vdi)
     BTRFS error (device bcache0): bdev /dev/bcache5 errs: wr 0, rd 0, 
flush 0, corrupt 2853, gen 0
     BTRFS warning (device bcache0): checksum error at logical 
4590109343744 on dev /dev/bcache5, physical 2954117120, root 5, inode 
418, offset 1030815744, length 4096, links 1 (path: 
VMs/Virtualbox/Windows 10 Imaging VMs/Windows 10 Imaging

My questions still remain: What should I do next. A scrub? A balance? 
Did I do something completely wrong? How to interpret the errors and 
warnings from the read-only scrub, may btrfs be able to fix them?

Thank you for reading and hopefully your answers!
