From: Ahmed Kamal <email.ahmedkamal@googlemail.com>
Subject: kernel .32, btrfs-vol -b, why is metadata=data
Date: Sun, 6 Dec 2009 10:50:45 +0200
Message-ID: <3da3b5b40912060050s752b2ff1if19799c1e5d281da@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

I'm running kernel 2.6.32-0.65.rc8.git5.fc13.x86_64. And I ran
"btrfs-vol -b", however for 10G of data I still have 9G of metadata!
How do I fix this ?

[root@matrix ~]# btrfs-vol -b /
ioctl returns 0
You have mail in /var/spool/mail/root
[root@matrix ~]# btrfs-show
failed to read /dev/sr0
Label: none  uuid: 06b0d069-b1cb-48c4-b26f-c5088a2360d2
        Total devices 1 FS bytes used 10.43GB
        devid    1 size 25.72GB used 19.02GB path /dev/dm-1

Btrfs Btrfs v0.19
