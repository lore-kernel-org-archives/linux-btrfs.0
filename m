Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:56167 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbaKQWzS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Nov 2014 17:55:18 -0500
Received: by mail-wi0-f171.google.com with SMTP id bs8so16446wib.16
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Nov 2014 14:55:17 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 17 Nov 2014 16:55:17 -0600
Message-ID: <CAD1x5BB5uevNP4wUsp+2tgVhofGr53QTURunsiM-4ico95R9vQ@mail.gmail.com>
Subject: Btrfs on a failing drive
From: Fennec Fox <fennectech@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

well i am an arch linux user and machine owner using a failing drive
  its still relyable enough for me but btrfs seems not to mark bad
blocks as unusable and continues to try to write to them.
/bbs.archlinux.org/viewtopic.php?pid=1476540#p1476540  this forum post
 has a few more details regarding the problem  i really need a bit of
help  thank you

Btrfs v3.17.1
Linux archos 3.17.3-1-ARCH #1 SMP PREEMPT Fri Nov 14 22:56:01 CET 2014
i686 GNU/Linux
Label: none  uuid: 9d7de4cb-d0a6-4b63-af65-9e055197808d
Total devices 1 FS bytes used 75.62GiB
devid    1 size 288.09GiB used 288.09GiB path /dev/sda1

Btrfs v3.17.1

[fennectech@archos ~]$ sudo   btrfs fi df /
Data, single: total=286.06GiB, used=75.02GiB
System, DUP: total=8.00MiB, used=48.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, DUP: total=1.00GiB, used=615.66MiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=208.00MiB, used=0.00B

10485756k FS
[   15.003094] mousedev: PS/2 mouse device common for all mice
[   17.894442] atl1c 0000:05:00.0: irq 30 for MSI/MSI-X
[   17.907192] IPv6: ADDRCONF(NETDEV_UP): enp5s0: link is not ready
[   17.927793] IPv6: ADDRCONF(NETDEV_UP): wlp4s0: link is not ready
[   19.298877] wlp4s0: authenticate with 20:e5:2a:5f:38:9c
[   19.313224] wlp4s0: send auth to 20:e5:2a:5f:38:9c (try 1/3)
[   19.314876] wlp4s0: authenticated
[   19.316730] wlp4s0: associate with 20:e5:2a:5f:38:9c (try 1/3)
[   19.319151] wlp4s0: RX AssocResp from 20:e5:2a:5f:38:9c
(capab=0x421 status=0 aid=1)
[   19.319274] wlp4s0: associated
[   19.319295] IPv6: ADDRCONF(NETDEV_CHANGE): wlp4s0: link becomes ready
[   70.470562] fuse init (API version 7.23)
[   83.050733] BTRFS info (device sda1): csum failed ino 3048916 off
33030144 csum 1217419445 expected csum 510562246
[   83.052317] BTRFS info (device sda1): csum failed ino 3048916 off
33030144 csum 1217419445 expected csum 510562246
[   84.305761] BTRFS info (device sda1): csum failed ino 3048916 off
21884928 csum 1036763273 expected csum 3160828041
[   84.306348] BTRFS info (device sda1): csum failed ino 3048916 off
21884928 csum 1036763273 expected csum 3160828041
[   84.318911] BTRFS info (device sda1): csum failed ino 3048916 off
9314304 csum 786831086 expected csum 1264200780
[   84.319115] BTRFS info (device sda1): csum failed ino 3048916 off
9314304 csum 786831086 expected csum 1264200780
[   84.319317] BTRFS info (device sda1): csum failed ino 3048916 off
9314304 csum 786831086 expected csum 1264200780
[   86.306536] BTRFS info (device sda1): csum failed ino 3048916 off
33030144 csum 1217419445 expected csum 510562246
[   91.050707] BTRFS info (device sda1): csum failed ino 3048916 off
21884928 csum 1036763273 expected csum 3160828041
[  101.185462] BTRFS info (device sda1): csum failed ino 3048916 off
33030144 csum 1217419445 expected csum 510562246
[  102.998155] BTRFS info (device sda1): csum failed ino 3048916 off
9314304 csum 786831086 expected csum 1264200780
[  103.140555] BTRFS info (device sda1): csum failed ino 3048916 off
21884928 csum 1036763273 expected csum 3160828041
[  103.464885] BTRFS info (device sda1): csum failed ino 3048916 off
9314304 csum 786831086 expected csum 1264200780
[  103.474580] BTRFS info (device sda1): csum failed ino 3048916 off
33030144 csum 1217419445 expected csum 510562246
[  103.496146] BTRFS info (device sda1): csum failed ino 3048916 off
21884928 csum 1036763273 expected csum 3160828041
[  103.498569] BTRFS info (device sda1): csum failed ino 3048916 off
33030144 csum 1217419445 expected csum 510562246
[  103.499630] BTRFS info (device sda1): csum failed ino 3048916 off
21884928 csum 1036763273 expected csum 3160828041
[  103.499783] BTRFS info (device sda1): csum failed ino 3048916 off
9314304 csum 786831086 expected csum 1264200780
