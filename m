From: "Fajar A. Nugraha" <list@fajar.net>
Subject: btrfs root + mount subvolid=0 problem
Date: Mon, 10 Oct 2011 14:30:30 +0700
Message-ID: <CAG1y0scXmy=DAGisOh9_6=LzueBhM5VMxpPWGeNPc+iOEc3scA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi

I have a system with Ubuntu natty i386 which uses btrfs root. It has
worked mostly well, but I have a problem when I want to create new
snapshot.
Current layout looks something like this

$ mount | grep btrfs
/dev/sda6 on / type btrfs (rw,noatime,subvolid=258,compress-force=lzo)
/dev/sda6 on /home type btrfs (rw,noatime,subvolid=259,compress-force=lzo)
/dev/sda6 on /data type btrfs (rw,noatime,subvolid=260,compress-force=lzo)
/dev/sda6 on /data/vm type btrfs (rw,noatime,subvolid=261,compress-force=lzo)
/dev/sda6 on /boot type btrfs (rw,noatime,subvolid=289,compress-force=lzo)

$ sudo btrfs su li /
[sudo] password for user:
ID 258 top level 5 path subvol/root
ID 259 top level 5 path subvol/home
ID 260 top level 5 path subvol/data
ID 261 top level 5 path subvol/vm
ID 289 top level 5 path boot
ID 318 top level 5 path subvol/oneiric

A few days ago I was able to mount subvolid=0 to a temporary path
(e.g. /mnt/tmp), and on that create a snapshot of subvol/root as
subvol/oneiric (for test upgrade purposes). That worked well. The
problem is now I can't repeat the process

$ sudo mount /dev/sda6 -o subvolid=0 /mnt/tmp
$ ls /mnt/tmp
boot  subvol
$ ls /mnt/tmp/subvol

(hangs at this point, I have to perform hard reset or "reboot -f").

This happens both with natty's 2.6.38-11-generic and kernel 3.0.4
(backported from oneiric). Does anyone know if this is a know problem,
or how to get further information to fix this?

Thanks,

Fajar
