From: Ritesh Raj Sarraf <rrs@researchut.com>
Subject: some btrfs test results
Date: Mon, 26 Oct 2009 01:06:16 +0530
Message-ID: <iuler6-lth.ln1@news.researchut.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I converted my ext4 volume to btrfs with success. Things seem to be working 
but there were many performance problems too.

* btrfs-convert /dev/sda6 took almost 5 hrs to create the btrfs metadata for 
my 120G SATA HDD

* After I boot into my newly converted btrfs / filesystem, df reports 
erratic.

rrs@learner:~$ mount
/dev/sda6 on / type btrfs (rw)
tmpfs on /lib/init/rw type tmpfs (rw,nosuid,mode=0755)
proc on /proc type proc (rw,noexec,nosuid,nodev)
sysfs on /sys type sysfs (rw,noexec,nosuid,nodev)
udev on /dev type tmpfs (rw,mode=0755)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
devpts on /dev/pts type devpts (rw,noexec,nosuid,gid=5,mode=620)
overflow on /tmp type tmpfs (rw,size=1048576,mode=1777)
fusectl on /sys/fs/fuse/connections type fusectl (rw)


rrs@learner:~$ df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda6             106G  -64Z  -54G 100% /
tmpfs                1013M     0 1013M   0% /lib/init/rw
udev                   10M  244K  9.8M   3% /dev
tmpfs                1013M     0 1013M   0% /dev/shm
overflow              1.0M     0  1.0M   0% /tmp
rrs@learner:~$ df -m
Filesystem           1M-blocks      Used Available Use% Mounted on
/dev/sda6               108078 -72057594037764906    -54953 100% /
tmpfs                     1013         0      1013   0% /lib/init/rw
udev                        10         1        10   3% /dev
tmpfs                     1013         0      1013   0% /dev/shm
overflow                     1         0         1   0% /tmp

On another test device, where an mkfs.btrfs was done, the space utilization 
was shown correctly.

Kernel: 2.6.31
Btrfs Btrfs v0.19

Ritesh
-- 
Given the large number of mailing lists I follow, I request you to CC me
in replies for quicker response

