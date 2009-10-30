From: Alex Dedul <rotmer@gmail.com>
Subject: Chromium hdd thrashing with btrfs
Date: Fri, 30 Oct 2009 15:44:39 +0200
Message-ID: <5f8586d40910300644j13e50752xcbc59cb5d4a8cdc5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

Quite a bit of time i'm watching in chromium strange behavior when
downloading files - after like 2Mb of any download it starts hdd
thrashing(with hdd noise/lots of seeks or the like). After some
research and seeing like no one else experiencing this i tried to
switch ~/.cache/chromium to ext4 fs - and on it no hdd thrashing
occurs. So this is seems like btrfs related issue. After talking on
#btrfs with cmason about this i'm attaching now vmstats and strace log
of what is going on:

--- normal state ---
plisk .cache # vmstat
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0      0  36168  39720 1405324    0    0   148   179  384 1402  8  3 76 13

--- thrashing state ---
plisk .cache # vmstat
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0      0  47304  52592 1377932    0    0   137   174  380 1469  8  3 77 12

Strace log is here
http://narod.ru/disk/14617356000/strace-log.bz2.html (just put an
captcha on the bottom left)

With best regards from the Soul, Alex.
