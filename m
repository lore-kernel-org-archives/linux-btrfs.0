Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:50517 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbaJKLHf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Oct 2014 07:07:35 -0400
Received: by mail-la0-f48.google.com with SMTP id gi9so4527918lab.21
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Oct 2014 04:07:32 -0700 (PDT)
MIME-Version: 1.0
From: Victor Hooi <victorhooi@gmail.com>
Date: Sat, 11 Oct 2014 22:07:12 +1100
Message-ID: <CAMnnoUJawjQM48AiE_WhvJt9QMy=b+MacOJ4wUcrRvDmH3jOZA@mail.gmail.com>
Subject: BTRFS root filesystem and large discrepancy between du (73Gb used)
 and df (125 Gb used)?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a Ubuntu 14.04 Server host using BTRFS that seems to show large
discrepancies between the output of du (73 GB used) and df (125 GB
used).

The hardware is a HP DL360 G5 with two 73 GB SAS drives running in
RAID0 (yes, I know...).

Basically, I'm running out of space on the root (/) filesystem, and I
can't work out why.

Output of df:

$ df -h
Filesystem         Size  Used Avail Use% Mounted on
/dev/cciss/c0d0p1  135G  125G  9.3G  94% /
none               4.0K     0  4.0K   0% /sys/fs/cgroup
udev               990M  4.0K  990M   1% /dev
tmpfs              200M  1.9M  199M   1% /run
none               5.0M     0  5.0M   0% /run/lock
none              1000M     0 1000M   0% /run/shm
none               100M     0  100M   0% /run/user
/dev/cciss/c0d0p1  135G  125G  9.3G  94% /home

Output of du:

$ sudo du -chs *
9.7M bin
174M boot
4.0K dev
8.3M etc
5.4G home
4.0K initrd.img
4.0K initrd.img.old
1.2G lib
4.0K lib64
0 media
0 mnt
0 opt
du: cannot access ‘proc/14648/task/14648/fd/4’: No such file or directory
du: cannot access ‘proc/14648/task/14648/fdinfo/4’: No such file or directory
du: cannot access ‘proc/14648/fd/4’: No such file or directory
du: cannot access ‘proc/14648/fdinfo/4’: No such file or directory
0 proc
8.0K root
1.9M run
13M sbin
36G srv
0 sys
4.0K system.properties
48K tmp
1.5G usr
28G var
4.0K vmlinuz
4.0K vmlinuz.old
73G total

Output of mount:

$ mount
/dev/cciss/c0d0p1 on / type btrfs (rw,relatime,subvol=@)
proc on /proc type proc (rw,noexec,nosuid,nodev)
sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
none on /sys/fs/cgroup type tmpfs (rw)
none on /sys/fs/fuse/connections type fusectl (rw)
none on /sys/kernel/debug type debugfs (rw)
none on /sys/kernel/security type securityfs (rw)
udev on /dev type devtmpfs (rw,mode=0755)
devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=0620)
tmpfs on /run type tmpfs (rw,noexec,nosuid,size=10%,mode=0755)
none on /run/lock type tmpfs (rw,noexec,nosuid,nodev,size=5242880)
none on /run/shm type tmpfs (rw,nosuid,nodev)
none on /run/user type tmpfs (rw,noexec,nosuid,nodev,size=104857600,mode=0755)
none on /sys/fs/pstore type pstore (rw)
cgroup on /sys/fs/cgroup/cpuset type cgroup (rw,relatime,cpuset)
cgroup on /sys/fs/cgroup/cpu type cgroup (rw,relatime,cpu)
cgroup on /sys/fs/cgroup/cpuacct type cgroup (rw,relatime,cpuacct)
cgroup on /sys/fs/cgroup/memory type cgroup (rw,relatime,memory)
cgroup on /sys/fs/cgroup/devices type cgroup (rw,relatime,devices)
cgroup on /sys/fs/cgroup/freezer type cgroup (rw,relatime,freezer)
cgroup on /sys/fs/cgroup/blkio type cgroup (rw,relatime,blkio)
cgroup on /sys/fs/cgroup/perf_event type cgroup (rw,relatime,perf_event)
cgroup on /sys/fs/cgroup/hugetlb type cgroup (rw,relatime,hugetlb)
/dev/cciss/c0d0p1 on /home type btrfs (rw,relatime,subvol=@home)
systemd on /sys/fs/cgroup/systemd type cgroup
(rw,noexec,nosuid,nodev,none,name=systemd)

Contents of /etc/fstab:

$ cat /etc/fstab
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
# / was on /dev/cciss/c0d0p1 during installation
UUID=d1fac2b3-63dc-4b60-a8d2-1ac7a38187f7 /               btrfs
relatime,subvol=@ 0       1
# /home was on /dev/cciss/c0d0p1 during installation
UUID=d1fac2b3-63dc-4b60-a8d2-1ac7a38187f7 /home           btrfs
relatime,subvol=@home 0       2
# swap was on /dev/cciss/c0d0p5 during installation
UUID=119e00c3-6b4f-49aa-b5b0-4736d5398c28 none            swap    sw
           0       0

Output of lsblk:

$ lsblk
NAME           MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
cciss!c0d0     104:0    0 136.7G  0 disk
├─cciss!c0d0p1 104:1    0 134.7G  0 part
├─cciss!c0d0p2 104:2    0     1K  0 part
└─cciss!c0d0p5 104:5    0     2G  0 part

Contents of /proc/partitions:

$ cat /proc/partitions
major minor  #blocks  name
 104        0  143305920 cciss/c0d0
 104        1  141209600 cciss/c0d0p1
 104        2          1 cciss/c0d0p2
 104        5    2094080 cciss/c0d0p5

Output of btrfs fi df:

$ sudo btrfs fi df /
[sudo] password for victorhooi:
Data, single: total=132.64GiB, used=122.88GiB
System, DUP: total=8.00MiB, used=20.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, DUP: total=1.00GiB, used=700.39MiB
Metadata, single: total=8.00MiB, used=0.00

lsof shows a single deleted file currently:

$ sudo lsof | grep deleted
init          1                  root    9w      REG
0,19         196    2173841 /var/log/upstart/systemd-logind.log.1
(deleted)

Any thoughts on what might be going on?

Regards,
Victor
