From: Tobias Kronawitter <tobias.kronawitter@tuhh.de>
Subject: Mounting a RAID 1 in degraded mode
Date: Wed, 22 Jun 2011 13:15:43 +0200
Message-ID: <BANLkTikKNpUfGadK72tg2yq0y_G=3=v6Ew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi

I fooled around with RAID and didn't quite get how to use -o degraded
the way it's meant. I asked on
http://askubuntu.com/questions/49893/how-does-btrfs-raid-work-in-degraded-mode/
. It goes like this:
-Create the raid array "sudo mkfs.btrfs -m raid1 -d raid1 /dev/loop1 /dev/loop2"
-mount them "sudo mount /dev/loop1 /mnt" and mark them "touch goodcondition"
-You unmount and simulate disk failure (remove disk or delete loopback
device loop2 in my case)
-You mount degraded "-o degraded" and mark again "touch degraded"
-You add the bad disk again "sudo btrfs dev add /dev/loop2"
-You rebalance "sudo btrfs fi ba /mnt"
And Raid 1 should work again. But that's not the case. "sudo btrfs fi show":

Total devices 3 FS bytes used 28.00KB
devid    3 size 4.00GB used 264.00MB path /dev/loop1
devid    2 size 4.00GB used 272.00MB path /dev/loop2
*** Some devices missing

It looks like I added another device instead of replacing.
I got the info so far from
https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices#Creating_a_Multi-device_FS
last paragraph.

So howdo I tell btrfs to use the newly created loop2 as a replacement for loop2

NB This is the first time I'm using a mailing list, so if I'm making
some obvious mistakes please point them out.

Tobias Kronawitter
