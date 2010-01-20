From: "Mr. Tux" <tuxoholic@hotmail.de>
Subject: Howto mount intact left-over device of a degraded btrfs-raid?
Date: Wed, 20 Jan 2010 19:31:24 +0100
Message-ID: <BLU0-SMTP89D73FD06036781FE98000D8640@phx.gbl>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi list

I tried to mount the intact device of a two memer btrfs raid array with one 
device missing:

# mount -o degraded /dev/sdb /mnt

this wouldn't work with kernel 2.6.32-2 - caused some sort of memory segfault

# btrfs-vol -r missing /mnt

complained and refused to mount the array degraded with only one intact array 
member left -> demanded two intact members

How can I mount this array anyway?

thanks!
