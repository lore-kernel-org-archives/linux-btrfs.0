Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:35721 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727194AbeINOQ7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 10:16:59 -0400
Received: from t460-skr.localnet ([194.94.224.254]) by mail.gmx.com (mrgmx003
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0Llmcq-1fRgJ32Dp2-00ZLgr for
 <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2018 11:03:25 +0200
From: Stefan K <shadow_7@gmx.net>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: btrfs filesystem show takes a long time
Date: Fri, 14 Sep 2018 11:03:24 +0200
Message-ID: <3275334.7C4KuSQybz@t460-skr>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear Maintainer,

the command btrfs fi show takes too much time:

time btrfs fi show              
Label: none  uuid: 513dc574-e8bc-4336-b181-00d1e9782c1c
Total devices 2 FS bytes used 2.34GiB
devid    1 size 927.79GiB used 4.03GiB path /dev/sdv2
devid    2 size 927.79GiB used 4.03GiB path /dev/sdar2

real    12m59.763s
user    0m0.008s
sys     0m0.044s


time btrfs fi show
Label: none  uuid: 513dc574-e8bc-4336-b181-00d1e9782c1c
Total devices 2 FS bytes used 2.34GiB
devid    1 size 927.79GiB used 4.03GiB path /dev/sdv2
devid    2 size 927.79GiB used 4.03GiB path /dev/sdar2

real    6m22.498s
user    0m0.012s
sys     0m0.024s


time btrfs fi show
Label: none  uuid: 513dc574-e8bc-4336-b181-00d1e9782c1c
Total devices 2 FS bytes used 2.34GiB
devid    1 size 927.79GiB used 4.03GiB path /dev/sdv2
devid    2 size 927.79GiB used 4.03GiB path /dev/sdar2

real    6m19.796s
user    0m0.012s
sys     0m0.024s


Maybe its related to that I've some harddisk in my system:
ls /dev/disk/by-path/ |grep -v part |wc -l
44

This is also a known Debian Bug #891717

-- System Information:
Debian Release: 9.3
  APT prefers stable-updates
  APT policy: (500, 'stable-updates'), (500, 'stable')
Architecture: amd64 (x86_64)

Kernel: Linux 4.9.0-5-amd64 (SMP w/20 CPU cores)
Locale: LANG=en_US.UTF-8, LC_CTYPE=en_US.UTF-8 (charmap=UTF-8), LANGUAGE=en_US:en (charmap=UTF-8)
Shell: /bin/sh linked to /bin/dash
Init: systemd (via /run/systemd/system)

Versions of packages btrfs-progs depends on:
ii  e2fslibs    1.43.4-2
ii  libblkid1   2.29.2-1
ii  libc6       2.24-11+deb9u1
ii  libcomerr2  1.43.4-2
ii  liblzo2-2   2.08-1.2+b2
ii  libuuid1    2.29.2-1
ii  zlib1g      1:1.2.8.dfsg-5
