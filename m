Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:33881 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbcCSW66 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Mar 2016 18:58:58 -0400
Received: by mail-wm0-f51.google.com with SMTP id p65so111223263wmp.1
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Mar 2016 15:58:58 -0700 (PDT)
MIME-Version: 1.0
From: Ryan Erato <rerato@gmail.com>
Date: Sat, 19 Mar 2016 15:58:37 -0700
Message-ID: <CAC7HdqknOJAK+FcE53xO38G__gc42GR0GQW+chbGbDxXBt7HFA@mail.gmail.com>
Subject: moving btrfs subvolumes to new disk
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm having quite the time trying to move my current Gentoo install to
an SSD. I first attempted Clonezilla, but that failed while cloning
the btrfs partition. I then realized I could use btrfs send/receive.

The partition has 2 subvolumes ROOT and ROOT/home. ROOT snapshots and
sends without hitch, but /home consistently errors at the same point
(from -vv output on btrfs send). btrfs send returns -2, no such file
or directory, unexpected EOF in stream.

I've read on several sites there have been path bugs and have
attempted to mount the destination drive multiple ways (with and
without specifying ROOT subvol), have taken and saved the /home
snapshot in multiple locations, but all to no avail. Below is as much
information as I can think to give; admittedly I am a bit fresh to
this fs, but I know this can be done.

Thanks for any help!

# uname -a
Linux 4.1.12-gentoo #1 SMP Thu Nov 26 12:08:14 PST 2015 x86_64
Intel(R) Core(TM) i5-3570K CPU @ 3.40GHz GenuineIntel GNU/Linux

# btrfs --version
btrfs-progs v4.0.1

# btrfs fi show
Label: 'Gentoo'  uuid: 6bb38bce-d824-4b9c-8b03-adad460c0f97
Total devices 1 FS bytes used 72.16GiB
devid    1 size 92.02GiB used 82.06GiB path /dev/sda6

# btrfs fi df /
Data, single: total=75.00GiB, used=70.77GiB
System, DUP: total=32.00MiB, used=16.00KiB
Metadata, DUP: total=3.50GiB, used=1.40GiB
GlobalReserve, single: total=480.00MiB, used=0.00B

# cat /etc/fstab
/dev/sda4 /boot vfat noauto,noatime 1 2
/dev/sda6 / btrfs defaults,noatime,compress=lzo,autodefrag,subvol=ROOT 0 0
/dev/sda5 none swap sw 0 0

# btrfs su l /
ID 257 gen 745235 top level 5 path ROOT
ID 258 gen 745235 top level 257 path home
ID 498 gen 744743 top level 5 path ROOT.snap
ID 501 gen 745043 top level 258 path home/home.snap

# cat /proc/self/mountinfo
17 0 0:17 /ROOT / rw,noatime shared:1 - btrfs /dev/sda6
rw,compress=lzo,space_cache,autodefrag
18 17 0:6 / /dev rw,relatime shared:2 - devtmpfs devtmpfs
rw,size=8060596k,nr_inodes=2015149,mode=755
19 17 0:20 / /sys rw,nosuid,nodev,noexec,relatime shared:5 - sysfs sysfs rw
20 17 0:4 / /proc rw,nosuid,nodev,noexec,relatime shared:8 - proc proc rw
21 18 0:21 / /dev/shm rw,nosuid,nodev shared:3 - tmpfs tmpfs rw
22 18 0:13 / /dev/pts rw,nosuid,noexec,relatime shared:4 - devpts
devpts rw,gid=5,mode=620,ptmxmode=000
23 17 0:22 / /run rw,nosuid,nodev shared:9 - tmpfs tmpfs rw,mode=755
24 19 0:23 / /sys/fs/cgroup ro,nosuid,nodev,noexec shared:6 - tmpfs
tmpfs ro,mode=755
25 24 0:24 / /sys/fs/cgroup/systemd rw,nosuid,nodev,noexec,relatime
shared:7 - cgroup cgroup
rw,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd
26 24 0:25 / /sys/fs/cgroup/net_cls,net_prio
rw,nosuid,nodev,noexec,relatime shared:10 - cgroup cgroup
rw,net_cls,net_prio
27 24 0:26 / /sys/fs/cgroup/blkio rw,nosuid,nodev,noexec,relatime
shared:11 - cgroup cgroup rw,blkio
28 24 0:27 / /sys/fs/cgroup/memory rw,nosuid,nodev,noexec,relatime
shared:12 - cgroup cgroup rw,memory
29 24 0:28 / /sys/fs/cgroup/hugetlb rw,nosuid,nodev,noexec,relatime
shared:13 - cgroup cgroup rw,hugetlb
30 24 0:29 / /sys/fs/cgroup/cpu,cpuacct
rw,nosuid,nodev,noexec,relatime shared:14 - cgroup cgroup
rw,cpu,cpuacct
31 24 0:30 / /sys/fs/cgroup/freezer rw,nosuid,nodev,noexec,relatime
shared:15 - cgroup cgroup rw,freezer
32 24 0:31 / /sys/fs/cgroup/devices rw,nosuid,nodev,noexec,relatime
shared:16 - cgroup cgroup rw,devices
33 24 0:32 / /sys/fs/cgroup/perf_event rw,nosuid,nodev,noexec,relatime
shared:17 - cgroup cgroup rw,perf_event
34 24 0:33 / /sys/fs/cgroup/cpuset rw,nosuid,nodev,noexec,relatime
shared:18 - cgroup cgroup rw,cpuset
35 20 0:34 / /proc/sys/fs/binfmt_misc rw,relatime shared:19 - autofs
systemd-1 rw,fd=32,pgrp=1,timeout=0,minproto=5,maxproto=5,direct
36 19 0:7 / /sys/kernel/debug rw,relatime shared:20 - debugfs debugfs rw
37 18 0:35 / /dev/hugepages rw,relatime shared:21 - hugetlbfs hugetlbfs rw
38 17 0:36 / /tmp rw shared:22 - tmpfs tmpfs rw
39 18 0:15 / /dev/mqueue rw,relatime shared:23 - mqueue mqueue rw
64 17 0:22 / /var/run rw,nosuid,nodev shared:9 - tmpfs tmpfs rw,mode=755
244 23 0:45 / /run/user/1000 rw,nosuid,nodev,relatime shared:166 -
tmpfs tmpfs rw,size=1612540k,mode=700,uid=1000,gid=1000
245 64 0:45 / /var/run/user/1000 rw,nosuid,nodev,relatime shared:166 -
tmpfs tmpfs rw,size=1612540k,mode=700,uid=1000,gid=1000
