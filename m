From: Leonidas Spyropoulos <artafinde@gmail.com>
Subject: btrfs filesystem defragment error
Date: Mon, 8 Nov 2010 23:33:39 +0000
Message-ID: <AANLkTikjgmNmuEz2k-vm-f-O2roaC0+z1p7tNZT-poea@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

While on Ubuntu 10.10 I cannot get defragment working.

inglor@selene:~$ btrfs filesystem defragment /media/Data/
ioctl failed on /media/Data/ ret -1 errno 1
total 1 failures
inglor@selene:~$ uname -a
Linux selene 2.6.35-23-generic #36-Ubuntu SMP Tue Oct 26 17:03:18 UTC
2010 i686 GNU/Linux
inglor@selene:~$ sudo btrfs filesystem show
[sudo] password for inglor:
failed to read /dev/sr0
Label: 'Data'  uuid: 3946b7c3-44c8-430e-b737-0c0c965e16c4
	Total devices 1 FS bytes used 12.32GB
	devid    1 size 29.08GB used 28.75GB path /dev/sda7

Btrfs v0.19-35-g1b444cd

Is it implemented on kernel 2.6.36 and above only?


-- 
Caution: breathing may be hazardous to your health.
