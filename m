Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:56590 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223Ab3DXLYg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Apr 2013 07:24:36 -0400
Received: by mail-bk0-f45.google.com with SMTP id j4so669184bkw.4
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Apr 2013 04:24:34 -0700 (PDT)
MIME-Version: 1.0
From: Tom Gundersen <teg@jklm.no>
Date: Wed, 24 Apr 2013 13:24:14 +0200
Message-ID: <CAG-2HqV6F1ifawsjAUHN3e+C8eo+wQwSLmbH3z=2dcqWeyb+uA@mail.gmail.com>
Subject: [BUG] "btrfs csum failed" on v3.9.0-rc7
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm having lots of problems with wrong checksums on the most recent
kernels. Note that this is not a regression as far as I know, just
more pronounced now than before (the increase in severity might be due
to changes in my setup).

I see that this was discussed on the ML a few months back, but it was
not clear to me if the problem is still open or if a solution should
have landed upstream.



This is what I'm seeing:

Pretty much on every reboot some (but not all) of the files written to
or created before the reboot are broken. If the offending files are
deleted / overwritten the problem goes away (at least until next
reboot when other files are affected). A random selection of "dmesg |
grep btrfs" is attached below.

As I can easily reproduce, please let me know how I can help debugging
further. For instance, how can I tell btrfs to ignore the checksum
error and give me the file it has anyway (to see if the file is
garbled, or just the checksum is wrong)?

My btrfs volume is made up of two partitions, and is split into three
subvolumes. When mounting the rootfs I see this in dmesg:

Apr 24 01:31:47 toms-air kernel: device fsid
0d7a2474-3523-413e-8611-1f489b8a9891 devid 1 transid 141284 /dev/sda4
Apr 24 01:31:47 toms-air kernel: device fsid
0d7a2474-3523-413e-8611-1f489b8a9891 devid 2 transid 141284 /dev/sda2
Apr 24 01:31:47 toms-air kernel: device fsid
0d7a2474-3523-413e-8611-1f489b8a9891 devid 2 transid 141284 /dev/sda2
Apr 24 01:31:47 toms-air kernel: device fsid
0d7a2474-3523-413e-8611-1f489b8a9891 devid 1 transid 141284 /dev/sda4
Apr 24 01:31:47 toms-air kernel: device fsid
0d7a2474-3523-413e-8611-1f489b8a9891 devid 2 transid 141284 /dev/sda2
Apr 24 01:31:47 toms-air kernel: btrfs: use ssd allocation scheme
Apr 24 01:31:47 toms-air kernel: btrfs: use lzo compression
Apr 24 01:31:47 toms-air kernel: btrfs: disk space caching is enabled
Apr 24 01:31:47 toms-air kernel: btrfs: bdev /dev/sda2 errs: wr 0, rd
0, flush 0, corrupt 2056270, gen 6
Apr 24 01:31:47 toms-air kernel: btrfs: bdev /dev/sda4 errs: wr 0, rd
0, flush 0, corrupt 2049061, gen 6
Apr 24 01:31:47 toms-air kernel: device fsid
0d7a2474-3523-413e-8611-1f489b8a9891 devid 2 transid 141284 /dev/sda2

And the output of findmnt is:

TARGET SOURCE                                    FSTYPE OPTIONS
/home  UUID=0d7a2474-3523-413e-8611-1f489b8a9891 btrfs
subvol=home,ssd,compress=lzo,x-systemd.automount,nofail
/var   UUID=0d7a2474-3523-413e-8611-1f489b8a9891 btrfs
subvol=var,ssd,compress=lzo
/usr   UUID=0d7a2474-3523-413e-8611-1f489b8a9891 btrfs
subvol=usr,ssd,compress=lzo



Errors reported in dmesg:

[10520.530437] btrfs csum failed ino 1988603 off 1277952 csum
2566472073 private 2887162790
[10520.535299] btrfs csum failed ino 1988542 off 172032 csum
1032373158 private 2555710917
[10520.535489] btrfs csum failed ino 1988542 off 172032 csum
1032373158 private 2555710917
[10520.536448] btrfs csum failed ino 1988542 off 307200 csum
2566472073 private 4189934277
[10521.404738] btrfs csum failed ino 1988603 off 1277952 csum
2566472073 private 2887162790
[10521.406514] btrfs csum failed ino 1988542 off 192512 csum
2359321615 private 259683409
[10521.407797] btrfs csum failed ino 1988542 off 372736 csum
2566472073 private 1399566794
[10521.620012] btrfs csum failed ino 1988603 off 1277952 csum
2566472073 private 2887162790
[10521.621371] btrfs csum failed ino 1988542 off 192512 csum
2359321615 private 259683409
[10521.622048] btrfs csum failed ino 1988542 off 372736 csum
2566472073 private 1399566794
[10546.115794] btrfs_readpage_end_io_hook: 26 callbacks suppressed
[10546.115806] btrfs csum failed ino 1988548 off 28672 csum 2066685480
private 49363816
[10546.116811] btrfs csum failed ino 1988548 off 28672 csum 2066685480
private 49363816
[10546.117847] btrfs csum failed ino 1988548 off 28672 csum 2066685480
private 49363816
[10546.118527] btrfs csum failed ino 1988548 off 28672 csum 2066685480
private 49363816
[10546.118910] btrfs csum failed ino 1988548 off 28672 csum 2066685480
private 49363816
[10546.119436] btrfs csum failed ino 1988548 off 28672 csum 2066685480
private 49363816
[10546.119856] btrfs csum failed ino 1988548 off 28672 csum 2066685480
private 49363816
[10546.120292] btrfs csum failed ino 1988548 off 28672 csum 2066685480
private 49363816
[10546.120683] btrfs csum failed ino 1988548 off 28672 csum 2066685480
private 49363816
[10546.121086] btrfs csum failed ino 1988548 off 28672 csum 2066685480
private 49363816
[10553.246253] btrfs_readpage_end_io_hook: 2 callbacks suppressed
[10553.246269] btrfs csum failed ino 114348 off 45056 csum 1787155441
private 2298707641
[10553.246541] btrfs csum failed ino 114348 off 45056 csum 1787155441
private 2298707641
[10554.761105] btrfs csum failed ino 1988542 off 372736 csum
2566472073 private 1399566794
[10554.762052] btrfs csum failed ino 1988603 off 1204224 csum
4217002373 private 516821494
[10605.966575] btrfs csum failed ino 1988548 off 28672 csum 1496083883
private 49363816
[10681.761222] btrfs csum failed ino 1988542 off 217088 csum 652086749
private 371373290
[10707.199412] btrfs csum failed ino 1988548 off 28672 csum 1496083883
private 49363816
[10711.777982] btrfs csum failed ino 1988542 off 217088 csum 652086749
private 371373290
[10711.778511] btrfs csum failed ino 1988543 off 4096 csum 1242025980
private 1116748566
[10711.778786] btrfs csum failed ino 1988543 off 4096 csum 1242025980
private 1116748566
[10743.754821] btrfs csum failed ino 1988547 off 12288 csum 1555062722
private 1166323098
[10743.755264] btrfs csum failed ino 1988542 off 569344 csum
1587824662 private 1165253717
[10743.755549] btrfs csum failed ino 1988543 off 4096 csum 1242025980
private 1116748566
[10743.755660] btrfs csum failed ino 1988543 off 4096 csum 1242025980
private 1116748566
[10743.761723] btrfs csum failed ino 1988542 off 569344 csum
1587824662 private 1165253717
[10743.761968] btrfs csum failed ino 1988547 off 12288 csum 1555062722
private 1166323098
[10743.877909] btrfs csum failed ino 1988547 off 12288 csum 1555062722
private 1166323098
[10743.878433] btrfs csum failed ino 1988547 off 12288 csum 1555062722
private 1166323098
[10743.878824] btrfs csum failed ino 1988547 off 12288 csum 1555062722
private 1166323098
[10743.879210] btrfs csum failed ino 1988547 off 12288 csum 1555062722
private 1166323098
[10773.121616] btrfs_readpage_end_io_hook: 2 callbacks suppressed
[10773.121628] btrfs csum failed ino 1988548 off 28672 csum 1496083883
private 49363816
[10774.871002] btrfs csum failed ino 1988603 off 1204224 csum
4217002373 private 516821494




Cheers,

Tom
