Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34789 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbcGGSPX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jul 2016 14:15:23 -0400
Received: by mail-wm0-f65.google.com with SMTP id 187so7315854wmz.1
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jul 2016 11:15:22 -0700 (PDT)
MIME-Version: 1.0
From: Laszlo Fiat <laszlo.fiat@gmail.com>
Date: Thu, 7 Jul 2016 20:15:18 +0200
Message-ID: <CA+7w51htypyk_RAUmf0i_12JSawq0BvKckSUk=sqyLHVkwvJNA@mail.gmail.com>
Subject: errors with linux-next-20160701
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a simple btrfs filesystem on a single device. It worked well so far.

Recently I compiled a new kernel linux-next-20160701, with this new
kernel I get warnings and errors in the logs. But btrfs scrub
completes with 0 errors, and if I boot back to the older
linux-next-20160527 kernel, there are no error messages in the logs
when using it or running scrub. The filesystem is mountable
read-write, but I am worried about the warnings and errors. The
checksum warnings always come up with new numbers, never the same.

$ uname -a
Linux debian 4.7.0-rc5-next-20160701+ #46 SMP Sun Jul 3 15:29:10 CEST
2016 x86_64 GNU/Linux

$ btrfs --version
btrfs-progs v4.5.2

# btrfs fi show
Label: none  uuid: d6cab9ca-5e89-4d8c-b55b-c700a6096d37
    Total devices 1 FS bytes used 55.31GiB
    devid    1 size 119.23GiB used 62.07GiB path /dev/mapper/home

# btrfs fi df /home
Data, single: total=59.01GiB, used=54.86GiB
System, DUP: total=32.00MiB, used=16.00KiB
Metadata, DUP: total=1.50GiB, used=462.56MiB
GlobalReserve, single: total=88.42MiB, used=0.00B

# dmesg | grep Btrfs
[    4.530960] Btrfs loaded, crc32c=crc32c-intel

# dmesg | grep BTRFS
[    4.530968] BTRFS: selftest: sectorsize: 4096  nodesize: 4096
[    4.530973] BTRFS: selftest: sectorsize: 4096  nodesize: 8192
[    4.530978] BTRFS: selftest: sectorsize: 4096  nodesize: 16384
[    4.530982] BTRFS: selftest: sectorsize: 4096  nodesize: 32768
[    4.530986] BTRFS: selftest: sectorsize: 4096  nodesize: 65536
[   52.114886] BTRFS: device fsid d6cab9ca-5e89-4d8c-b55b-c700a6096d37
devid 1 transid 29825 /dev/dm-0
[   60.598254] BTRFS info (device dm-0): use lzo compression
[   60.598266] BTRFS info (device dm-0): disk space caching is enabled
[   60.598273] BTRFS info (device dm-0): has skinny extents
[   60.797475] BTRFS warning (device dm-0): dm-0 checksum verify
failed on 343146496 wanted D962670F found 32292342 level 0
[   60.850008] BTRFS info (device dm-0): detected SSD devices, enabling SSD mode
[  165.491150] BTRFS error (device dm-0): bad tree block start
8242807833012638730 658522112

# grep "BTRFS error" /var/log/syslog.1
Jul  6 19:35:23 debian kernel: [ 2712.823929] BTRFS error (device
dm-0): bad tree block start 10283429131165574676 662503424
Jul  6 19:35:23 debian kernel: [ 2712.850468] BTRFS error (device
dm-0): bad tree block start 14801127411347629381 663502848
Jul  6 19:35:23 debian kernel: [ 2712.888038] BTRFS error (device
dm-0): bad tree block start 9855282569545798023 664141824
Jul  6 19:35:23 debian kernel: [ 2712.888491] BTRFS error (device
dm-0): bad tree block start 12220505751590977444 664207360
Jul  6 19:35:59 debian kernel: [ 2748.728044] BTRFS error (device
dm-0): bad tree block start 16324583772582058537 665927680
Jul  6 19:37:31 debian kernel: [ 2840.465648] BTRFS error (device
dm-0): bad tree block start 13618790082605902229 309936128
Jul  6 19:37:31 debian kernel: [ 2840.465672] BTRFS error (device
dm-0): bad tree block start 9260130888975445835 309870592
Jul  6 19:37:31 debian kernel: [ 2840.466526] BTRFS error (device
dm-0): bad tree block start 17351834078110360434 309968896
Jul  6 19:37:31 debian kernel: [ 2840.466579] BTRFS error (device
dm-0): bad tree block start 3476538019772833052 309985280
Jul  6 19:37:31 debian kernel: [ 2840.509021] BTRFS error (device
dm-0): bad tree block start 1881224518785478735 327696384
Jul  6 19:37:31 debian kernel: [ 2840.509085] BTRFS error (device
dm-0): bad tree block start 14212257183956925500 327712768
Jul  6 19:37:31 debian kernel: [ 2840.533393] BTRFS error (device
dm-0): bad tree block start 13574459615317154064 331268096
Jul  6 19:37:53 debian kernel: [ 2862.852848] BTRFS error (device
dm-0): bad tree block start 13618790082605902229 309936128
Jul  7 19:52:05 debian kernel: [  165.491150] BTRFS error (device
dm-0): bad tree block start 8242807833012638730 658522112

# grep "BTRFS warning" /var/log/syslog.1
Jul  6 19:35:24 debian kernel: [ 2712.926597] BTRFS warning (device
dm-0): dm-0 checksum verify failed on 665927680 wanted 2E7409B found
44E60A96 level 0
Jul  6 19:35:24 debian kernel: [ 2713.001532] BTRFS warning (device
dm-0): dm-0 checksum verify failed on 671416320 wanted D7E63A7D found
17064A1 level 0
Jul  6 19:37:31 debian kernel: [ 2840.596783] BTRFS warning (device
dm-0): dm-0 checksum verify failed on 373882880 wanted 55479736 found
3C3D6BD6 level 0
Jul  6 19:37:31 debian kernel: [ 2840.785562] BTRFS warning (device
dm-0): dm-0 checksum verify failed on 668319744 wanted A6C233A1 found
625A2B9D level 0
Jul  7 19:50:21 debian kernel: [   60.797475] BTRFS warning (device
dm-0): dm-0 checksum verify failed on 343146496 wanted D962670F found
32292342 level 0

# zgrep "BTRFS warning" /var/log/syslog.*.gz
/var/log/syslog.2.gz:Jul  5 19:40:23 debian kernel: [ 3560.469370]
BTRFS warning (device dm-0): dm-0 checksum verify failed on 373145600
wanted FDF307ED found F56F3DA6 level 0
/var/log/syslog.2.gz:Jul  5 19:42:10 debian kernel: [ 3668.114486]
BTRFS warning (device dm-0): dm-0 checksum verify failed on 661995520
wanted A026D859 found E8A164B1 level 0
/var/log/syslog.2.gz:Jul  5 19:44:19 debian kernel: [ 3796.438526]
BTRFS warning (device dm-0): dm-0 checksum verify failed on 352927744
wanted 1EE0C42D found 4E2BDB88 level 0
/var/log/syslog.2.gz:Jul  5 19:44:19 debian kernel: [ 3796.486052]
BTRFS warning (device dm-0): dm-0 checksum verify failed on 385957888
wanted 6143652E found 8C83C87D level 0
/var/log/syslog.4.gz:Jul  4 18:29:39 debian kernel: [   90.223108]
BTRFS warning (device dm-0): dm-0 checksum verify failed on 95879168
wanted 28DC698C found BB2539B9 level 0
/var/log/syslog.4.gz:Jul  4 18:30:08 debian kernel: [  118.628385]
BTRFS warning (device dm-0): dm-0 checksum verify failed on 284934144
wanted 76564818 found 9FC8C87F level 0

# btrfs scrub status /home
scrub status for d6cab9ca-5e89-4d8c-b55b-c700a6096d37
    scrub started at Thu Jul  7 18:49:12 2016 and finished after 00:44:48
    total bytes scrubbed: 55.76GiB with 0 errors
