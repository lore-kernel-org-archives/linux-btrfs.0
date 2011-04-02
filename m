From: "Helmut Hullen" <Hullen@t-online.de>
Subject: minor ID for btrfs-control
Date: 02 Apr 2011 18:45:00 +0200
Message-ID: <Bj4lB4gT1uB@helmut.hullen.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo,

if I've understood some mails in this list correct, then btrfs needs a  
character device "btrfs-control"  with the ID 10:55

When I look for this device in

        /sys/class/misc/btrfs-control/dev

I see 10:234

And when I run the command

  mkfs.btrfs -d raid0 -m raid1 /dev/sda1 /dev/sdc1

I get the error messages

  failed to open /dev/btrfs-control skipping device registration

---

  ls -l /dev/bt*

shows

  crw-rw-rw- 1 root root 10,55 2. Apr 17:55 /dev/btrfs-control

---

Kernel 2.6.38.1 (self made), no udev, no initrd, no tempfs. btrfs from  
nov. 2010

What goes wrong?


Viele Gruesse!
Helmut
