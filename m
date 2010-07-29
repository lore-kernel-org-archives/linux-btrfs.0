From: Wang Shaoyan <stufever@gmail.com>
Subject: can subvolumes be specified as compressed?
Date: Thu, 29 Jul 2010 15:50:28 +0800
Message-ID: <AANLkTi=_gp3hbXjqCnpzHJRAkBhRZqVZ1V5jhg1B0RAV@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi.
I want a subvolume in root to be compressed, I try to do this:
# mkfs.btrfs /dev/sda8
# mount /dev/sda8 /home/usr/btrfs
# cd /home/usr/btrfs
# btrfs subvolume create mysubvolume
# mount -o compress,subvol=mysubvolume /dev/sda8 some_dir_in_root
but when I create a file in some_dir_in_root, the file isn't
compressed at all. why? How can I specify some subvolumes to be
compressed, and the others Not to be compressed in a single btrfs?

--
Wang Shaoyan
