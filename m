From: Leonidas Spyropoulos <artafinde@gmail.com>
Subject: btrfs filesystem df not working
Date: Tue, 12 Oct 2010 11:12:01 +0100
Message-ID: <AANLkTik-414saDjSZFtEKWn4h7zSbbLBqa_0S+uf4SQR@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The above command is not working on my system.
Information:
btrfs f df /media/data

Btrfs v0.19-35-g1b444cd

Linux woofy 2.6.32-5-amd64 #1 SMP Fri Sep 17 21:50:19 UTC 2010 x86_64 GNU/Linux

mount info:
/dev/sdd2 on /media/data type btrfs (rw,noexec,nosuid,nodev)
/media/data is a raid 0 filesystem

$ btrfs filesystem show
failed to read /dev/sr0
Label: none  uuid: 1882b025-58e4-4287-98a3-9b772af0ad76
	Total devices 2 FS bytes used 72.56GB
	devid    2 size 74.53GB used 54.01GB path /dev/sdd2
	devid    3 size 74.53GB used 54.01GB path /dev/sde2

Any ideas?
This is on an testing/unstable Debian system.

-- 
Caution: breathing may be hazardous to your health.
