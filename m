Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34216 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbcF3LQ4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jun 2016 07:16:56 -0400
Received: by mail-wm0-f65.google.com with SMTP id 187so21951988wmz.1
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Jun 2016 04:16:55 -0700 (PDT)
MIME-Version: 1.0
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Thu, 30 Jun 2016 14:16:14 +0300
Message-ID: <CAGqmi75KFyiCzF2J5Xa_a8S27iR6Kp1jxH4JcwHBe1pD8m1egg@mail.gmail.com>
Subject: RAID1: if one disk failed, what errors are expected?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi list,
has done some stability test and AFAIK, i see unexpected errors

So:
Take 2 flash devices:
/dev/sdb
/dev/sdc

Format it:
mkfs.btrfs -L TEST -m raid1 -d raid1 /dev/sdb /dev/sdc

Mount:
mount /dev/sdb /mnt

Config test.fio:
[global]
size=1g
filename=/mnt/testfile.fio
numjobs=1
runtime=60
ioengine=libaio
buffer_compress_percentage=15
overwrite=1
end_fsync=1
direct=1
startdelay=30
bs=4k
iodepth=64
rw=randrw
[Disk-4k-randomrw-depth-64]
rwmixread=50
stonewall

Run fio:
fio test.fio

While testing remove one of usb drive, and fio has hang to several
seconds and show errors:
--cut--
fio: io_u error on file /mnt/testfile.fio: Input/output error: read
offset=34193408, buflen=4096
fio: io_u error on file /mnt/testfile.fio: Input/output error: read
offset=80621568, buflen=65536
fio: pid=24696, err=5/file:io_u.c:1697, func=io_u error,
error=Input/output error
--cut--

dmesg:
Jun 30 13:54:38 titovetst-beplan kernel: sd 6:0:0:0: [sdc] Attached
SCSI removable disk
Jun 30 13:54:39 titovetst-beplan kernel: sd 5:0:0:0: [sdb] Attached
SCSI removable disk
Jun 30 13:54:39 titovetst-beplan kernel: BTRFS: device label TEST
devid 2 transid 10 /dev/sdb
Jun 30 13:55:21 titovetst-beplan kernel: BTRFS: device label TEST
devid 1 transid 3 /dev/sdb
Jun 30 13:55:21 titovetst-beplan kernel: BTRFS: device label TEST
devid 2 transid 3 /dev/sdc
Jun 30 13:58:03 titovetst-beplan kernel: BTRFS info (device sdc): disk
space caching is enabled
Jun 30 13:58:03 titovetst-beplan kernel: BTRFS: has skinny extents
Jun 30 13:58:03 titovetst-beplan kernel: BTRFS: flagging fs with big
metadata feature
Jun 30 13:58:03 titovetst-beplan kernel: BTRFS: creating UUID tree
Jun 30 13:59:07 titovetst-beplan kernel: usb 2-1: Disable of
device-initiated U1 failed.
Jun 30 13:59:12 titovetst-beplan kernel: usb 2-1: Disable of
device-initiated U2 failed.
Jun 30 13:59:16 titovetst-beplan kernel: usb usb2-port1: Cannot
enable. Maybe the USB cable is bad?
Jun 30 13:59:20 titovetst-beplan kernel: usb usb2-port1: Cannot
enable. Maybe the USB cable is bad?
Jun 30 13:59:24 titovetst-beplan kernel: usb usb2-port1: Cannot
enable. Maybe the USB cable is bad?
Jun 30 13:59:28 titovetst-beplan kernel: usb usb2-port1: Cannot
enable. Maybe the USB cable is bad?
Jun 30 13:59:28 titovetst-beplan kernel: usb 2-1: USB disconnect,
device number 5
Jun 30 13:59:28 titovetst-beplan kernel: sd 6:0:0:0: [sdc] tag#0
UNKNOWN(0x2003) Result: hostbyte=0x01 driverbyte=0x00
Jun 30 13:59:28 titovetst-beplan kernel: sd 6:0:0:0: [sdc] tag#0 CDB:
opcode=0x2a 2a 00 00 25 3a 38 00 00 08 00
Jun 30 13:59:28 titovetst-beplan kernel: blk_update_request: I/O
error, dev sdc, sector 2439736
Jun 30 13:59:28 titovetst-beplan kernel:
btrfs_dev_stat_print_on_error: 11 callbacks suppressed
Jun 30 13:59:28 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 1, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:28 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 2, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:28 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 3, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:28 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 4, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:28 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 5, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:28 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 6, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:28 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 7, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:28 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 8, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:28 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 9, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:28 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 10, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:28 titovetst-beplan kernel: sd 6:0:0:0: [sdc] tag#0
UNKNOWN(0x2003) Result: hostbyte=0x01 driverbyte=0x00
Jun 30 13:59:28 titovetst-beplan kernel: sd 6:0:0:0: [sdc] tag#0 CDB:
opcode=0x2a 2a 00 00 25 3a 40 00 00 08 00
Jun 30 13:59:28 titovetst-beplan kernel: blk_update_request: I/O
error, dev sdc, sector 2439744
Jun 30 13:59:28 titovetst-beplan kernel: scsi 6:0:0:0: rejecting I/O
to dead device
Jun 30 13:59:28 titovetst-beplan kernel: scsi 6:0:0:0: rejecting I/O
to dead device
Jun 30 13:59:28 titovetst-beplan kernel: scsi 6:0:0:0: rejecting I/O
to dead device
Jun 30 13:59:30 titovetst-beplan kernel: BTRFS warning (device sdc):
lost page write due to IO error on /dev/sdc
Jun 30 13:59:30 titovetst-beplan kernel: BTRFS warning (device sdc):
lost page write due to IO error on /dev/sdc
Jun 30 13:59:33 titovetst-beplan kernel:
btrfs_dev_stat_print_on_error: 675 callbacks suppressed
Jun 30 13:59:33 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 686, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:33 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 687, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:33 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 688, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:33 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 689, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:33 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 690, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:33 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 691, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:33 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 692, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:33 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 693, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:33 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 694, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:33 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 695, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:38 titovetst-beplan kernel:
btrfs_dev_stat_print_on_error: 2604 callbacks suppressed
Jun 30 13:59:38 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 3300, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:38 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 3301, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:38 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 3302, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:38 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 3303, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:38 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 3304, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:38 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 3305, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:38 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 3306, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:38 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 3307, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:38 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 3308, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:38 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 3309, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:43 titovetst-beplan kernel:
btrfs_dev_stat_print_on_error: 2498 callbacks suppressed
Jun 30 13:59:43 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 5808, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:43 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 5809, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:43 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 5810, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:43 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 5811, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:43 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 5812, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:43 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 5813, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:43 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 5814, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:43 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 5815, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:43 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 5816, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:43 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 5817, rd 0, flush 0, corrupt 0, gen 0
Jun 30 13:59:47 titovetst-beplan kernel: BTRFS warning (device sdc):
lost page write due to IO error on /dev/sdc
Jun 30 13:59:47 titovetst-beplan kernel: __readpage_endio_check: 953
callbacks suppressed
Jun 30 13:59:47 titovetst-beplan kernel: BTRFS warning (device sdc):
csum failed ino 257 off 34193408 csum 3296610491 expected csum
2851752621
Jun 30 13:59:47 titovetst-beplan kernel: BTRFS warning (device sdc):
csum failed ino 257 off 24379392 csum 2406443022 expected csum
1923858090
Jun 30 13:59:47 titovetst-beplan kernel: BTRFS warning (device sdc):
csum failed ino 257 off 24383488 csum 3345930685 expected csum
3020105143
Jun 30 13:59:47 titovetst-beplan kernel: BTRFS warning (device sdc):
csum failed ino 257 off 24387584 csum 1052262849 expected csum
2202542860
Jun 30 13:59:47 titovetst-beplan kernel: BTRFS warning (device sdc):
csum failed ino 257 off 24391680 csum 1655461868 expected csum
334008598
Jun 30 13:59:47 titovetst-beplan kernel: BTRFS warning (device sdc):
csum failed ino 257 off 24395776 csum 2335878395 expected csum
3030887001
Jun 30 13:59:47 titovetst-beplan kernel: BTRFS warning (device sdc):
csum failed ino 257 off 24399872 csum 2416743016 expected csum
3793710707
Jun 30 13:59:47 titovetst-beplan kernel: BTRFS warning (device sdc):
csum failed ino 257 off 24403968 csum 2783559276 expected csum
166368162
Jun 30 13:59:47 titovetst-beplan kernel: BTRFS warning (device sdc):
csum failed ino 257 off 24408064 csum 2684031708 expected csum
3886142186
Jun 30 13:59:47 titovetst-beplan kernel: BTRFS warning (device sdc):
csum failed ino 257 off 24412160 csum 3605391328 expected csum
2694225271
Jun 30 13:59:47 titovetst-beplan kernel: BTRFS warning (device sdc):
direct IO failed ino 257 rw 0 sector 0x22b378 len 4096 err no -5
Jun 30 13:59:47 titovetst-beplan kernel: BTRFS warning (device sdc):
direct IO failed ino 257 rw 0 sector 0x22b380 len 4096 err no -5
Jun 30 13:59:47 titovetst-beplan kernel: BTRFS warning (device sdc):
direct IO failed ino 257 rw 0 sector 0x221cf8 len 4096 err no -5
Jun 30 13:59:47 titovetst-beplan kernel: BTRFS warning (device sdc):
direct IO failed ino 257 rw 0 sector 0x221d00 len 4096 err no -5
Jun 30 13:59:47 titovetst-beplan kernel: BTRFS warning (device sdc):
direct IO failed ino 257 rw 0 sector 0x221de8 len 12288 err no -5
Jun 30 13:59:47 titovetst-beplan kernel: BTRFS warning (device sdc):
direct IO failed ino 257 rw 0 sector 0x221e00 len 12288 err no -5
Jun 30 13:59:47 titovetst-beplan kernel: BTRFS warning (device sdc):
direct IO failed ino 257 rw 0 sector 0x208c78 len 4096 err no -5
Jun 30 13:59:47 titovetst-beplan kernel: BTRFS warning (device sdc):
direct IO failed ino 257 rw 0 sector 0x208c80 len 20480 err no -5
Jun 30 13:59:48 titovetst-beplan kernel: BTRFS warning (device sdc):
direct IO failed ino 257 rw 0 sector 0x2092f0 len 8192 err no -5
Jun 30 13:59:48 titovetst-beplan kernel: BTRFS warning (device sdc):
direct IO failed ino 257 rw 0 sector 0x209300 len 4096 err no -5
Jun 30 13:59:48 titovetst-beplan kernel: BTRFS warning (device sdc):
direct IO failed ino 257 rw 0 sector 0x209568 len 12288 err no -5
Jun 30 13:59:48 titovetst-beplan kernel: BTRFS warning (device sdc):
direct IO failed ino 257 rw 0 sector 0x209580 len 4096 err no -5
Jun 30 13:59:48 titovetst-beplan kernel: BTRFS warning (device sdc):
direct IO failed ino 257 rw 0 sector 0x2433f8 len 4096 err no -5
Jun 30 13:59:48 titovetst-beplan kernel: BTRFS warning (device sdc):
direct IO failed ino 257 rw 0 sector 0x243400 len 4096 err no -5
Jun 30 13:59:48 titovetst-beplan kernel: BTRFS warning (device sdc):
direct IO failed ino 257 rw 0 sector 0x228570 len 8192 err no -5
Jun 30 13:59:48 titovetst-beplan kernel: BTRFS warning (device sdc):
direct IO failed ino 257 rw 0 sector 0x228580 len 24576 err no -5
Jun 30 13:59:48 titovetst-beplan kernel: BTRFS warning (device sdc):
direct IO failed ino 257 rw 0 sector 0x228748 len 28672 err no -5
Jun 30 13:59:48 titovetst-beplan kernel: BTRFS warning (device sdc):
direct IO failed ino 257 rw 0 sector 0x228780 len 8192 err no -5
Jun 30 13:59:48 titovetst-beplan kernel: BTRFS warning (device sdc):
direct IO failed ino 257 rw 0 sector 0x20e8f8 len 4096 err no -5
Jun 30 13:59:48 titovetst-beplan kernel: BTRFS warning (device sdc):
direct IO failed ino 257 rw 0 sector 0x20e900 len 12288 err no -5
Jun 30 13:59:48 titovetst-beplan kernel: BTRFS warning (device sdc):
direct IO failed ino 257 rw 0 sector 0x215f68 len 12288 err no -5
Jun 30 13:59:48 titovetst-beplan kernel: BTRFS warning (device sdc):
direct IO failed ino 257 rw 0 sector 0x215f80 len 8192 err no -5
Jun 30 13:59:48 titovetst-beplan kernel: BTRFS warning (device sdc):
direct IO failed ino 257 rw 0 sector 0x20bc68 len 12288 err no -5
Jun 30 13:59:48 titovetst-beplan kernel: BTRFS warning (device sdc):
direct IO failed ino 257 rw 0 sector 0x20bc80 len 12288 err no -5
Jun 30 13:59:48 titovetst-beplan kernel: BTRFS warning (device sdc):
direct IO failed ino 257 rw 0 sector 0x224ce8 len 12288 err no -5
Jun 30 13:59:48 titovetst-beplan kernel: BTRFS warning (device sdc):
direct IO failed ino 257 rw 0 sector 0x224d00 len 36864 err no -5
Jun 30 14:00:00 titovetst-beplan kernel:
btrfs_dev_stat_print_on_error: 4765 callbacks suppressed
Jun 30 14:00:00 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 9883, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:00 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 9884, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:00 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 9885, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:00 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 9886, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:00 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 9887, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:00 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 9888, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:00 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 9889, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:00 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 9890, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:00 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 9891, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:00 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 9892, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:01 titovetst-beplan kernel: BTRFS warning (device sdc):
lost page write due to IO error on /dev/sdc
Jun 30 14:00:01 titovetst-beplan kernel: BTRFS warning (device sdc):
lost page write due to IO error on /dev/sdc
Jun 30 14:00:08 titovetst-beplan kernel:
btrfs_dev_stat_print_on_error: 79 callbacks suppressed
Jun 30 14:00:08 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 9972, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:08 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 9973, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:08 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 9974, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:08 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 9975, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:08 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 9976, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:08 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 9977, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:08 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 9978, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:08 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 9979, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:08 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 9980, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:08 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 9981, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:13 titovetst-beplan kernel:
btrfs_dev_stat_print_on_error: 579 callbacks suppressed
Jun 30 14:00:13 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 10561, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:13 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 10562, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:13 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 10563, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:13 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 10564, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:13 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 10565, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:13 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 10566, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:13 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 10567, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:13 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 10568, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:13 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 10569, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:13 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 10570, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:18 titovetst-beplan kernel:
btrfs_dev_stat_print_on_error: 17518 callbacks suppressed
Jun 30 14:00:18 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 28089, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:18 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 28090, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:18 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 28091, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:18 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 28092, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:18 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 28093, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:18 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 28094, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:18 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 28095, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:18 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 28096, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:18 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 28097, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:18 titovetst-beplan kernel: BTRFS error (device sdc):
bdev /dev/sdc errs: wr 28098, rd 700, flush 0, corrupt 0, gen 0
Jun 30 14:00:22 titovetst-beplan kernel: BTRFS warning (device sdc):
lost page write due to IO error on /dev/sdc
Jun 30 14:00:22 titovetst-beplan kernel: BTRFS warning (device sdc):
lost page write due to IO error on /dev/sdc

So, AFAIK RAID1 mode must guarantee errors resilience for software
running on it.
But fio show errors while testing, if that expected? Why?

P.S.
If i do the same with:
mdadm --create --verbose /dev/md0 --level=mirror --raid-devices=2
/dev/sdb /dev/sdc
mkfs.btrfs -L TEST -m single -d single /dev/md0
mount /dev/md0 /mnt
And then run fio, remove device & etc.

Fio don't show any errors.

P.S.S
Kernel: Linux 4.6.3-1-ARCH #1 SMP PREEMPT Fri Jun 24 21:19:13 CEST
2016 x86_64 GNU/Linux
btrfs-progs: v4.6.1

Thanks.
-- 
Have a nice day,
Timofey.
