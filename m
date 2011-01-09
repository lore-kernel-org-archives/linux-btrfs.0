From: Paul Richards <paul.richards@gmail.com>
Subject: Swap file on btrfs fails ("swapfile has holes")
Date: Sun, 9 Jan 2011 17:21:02 +0000
Message-ID: <AANLkTimF8y+yBwcs3S0UQxDV=xWyTQRKxzKxR7ZHZnFL@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I have just recently installed Debian squeeze with a root filesystem
on btrfs [1].  I have noticed however that I cannot set up a swap file
stored on the btrfs volume:

dd if=/dev/zero of=/var/swap bs=16M count=4
mkswap /var/swap
chmod 0 /var/swap
swapon /var/swap

[ 01751.879759] swapon: swapfile has holes
swapon: /var/swap: swapon failed: Invalid argument

For now I've set up a swap file under /boot (ext4), but is swap on
btrfs expected to work?  I'm using the stock Debian linux kernel
2.6.32-5-amd64.


1: This took a little bit of work -
http://lists.debian.org/debian-user/2011/01/msg00217.html


-- 
Paul Richards
@pauldoo
