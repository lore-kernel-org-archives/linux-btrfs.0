Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:58747 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbaCWW5F (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Mar 2014 18:57:05 -0400
Received: from svh-gw.merlins.org ([173.11.111.145]:40769 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1WRrK5-0006hQ-UH by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Sun, 23 Mar 2014 15:57:04 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@legolas.merlins.org>)
	id 1WRrK5-0004WJ-3s
	for linux-btrfs@vger.kernel.org; Sun, 23 Mar 2014 15:56:57 -0700
Date: Sun, 23 Mar 2014 15:56:57 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <20140323225657.GA17039@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: Btrfs and raid5 status with kernel 3.14, documentation, and howto
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ok, thanks to the help I got from you, and my own experiments, I've
written this:
http://marc.merlins.org/perso/btrfs/post_2014-03-23_Btrfs-Raid5-Status.html

If someone reminds me how to edit the btrfs wiki, I'm happy to copy that
there, or give anyone permission to take part of all of what I wrote 
and use it for any purpose.



The highlights are if you're coming from the mdadm raid5 world:

- btrfs does not yet seem to know that if you removed a drive from an
  array and you plug it back in later, that drive is out of date. It
  will auto-add an out of date drive back to an array and that will
  likely cause data loss by hiding files you had but the old drive
  didn't have. This means you should wipe a drive cleanly before you put
  it back into an array it used to be part of

- btrfs does not deal well with a drive that is present but not
  working. It does not know how to kick it from the array, nor can it
  be removed (btrfs device delete) because this causes reading from
  the drive that isn't working. This means btrfs will try to write to
  the bad drive forever. The solution there is to umount the array,
  remount it with the bad drive missing (it cannot be seen by btrfs,
  or it'll get automounted/added), and then rebuild on a new drive or
  rebuild/shrink the array to be one drive smaller (this is explained
  below).

- You can add and remove drives from an array and rebalance to
  grow/shrink an array without umounting it. Note that is slow since it
  forces rewriting of all data blocks, and this takes about 3H per 100GB
  (or 30H per terabyte) with 10 drives on a dual core duo.

- If you are missing a drive, btrfs will refuse to mount the array and
  give an obscure error unless you mount with -o degraded

- btrfs has no special rebuild procedure. Rebuilding is done by
  rebalancing the array. You could actualy rebalance a degraded array to
  a smaller array by rebuilding/balancing without adding a drive, or you
  can add a drive, rebalance on it, and that will force a read/rewrite
  of all data blocks, which will restripe them nicely.

- btrfs replace does not work, but you can easily do btrfs device add,
  and btrfs remove of the other drive, and this will do the same thing.

- btrfs device add will not cause an auto rebalance. You could chose
  not to rebalance existing data and only have new data be balanced
  properly.

- btrfs device delete will force all data from the deleted drive to be
  rebalanced and the command completes when the drive has been freed up.

- The magic command to delete an unused drive from an array while it is
  missing from the system is btrfs device delete missing .

- btrfs doesn't easily tell you that your array is in degraded mode (run
  btrfs fi show, and it'll show a missing drive as well as how much of
  your total data is still on it). This does means you can have an array
  that is half degraded: half the files are striped over the current
  drives because they were written after the drive was removed, or were
  written by a rebalance that hasn't finished, while the other half of
  your data could be in degraded mode.
  You can see this by looking at the amount of data on each drive,
  anything on drive 11 is properly striped 10 way, while anything on
  drive 3 is in degraded mode:

polgara:~# btrfs fi show
Label: backupcopy  uuid: eed9b55c-1d5a-40bf-a032-1be6980648e1
        Total devices 11 FS bytes used 564.54GiB
        devid    1 size 465.76GiB used 63.14GiB path /dev/dm-0
        devid    2 size 465.76GiB used 63.14GiB path /dev/dm-1
        devid    3 size 465.75GiB used 30.00GiB path   <- this device is missing
        devid    4 size 465.76GiB used 63.14GiB path /dev/dm-2
        devid    5 size 465.76GiB used 63.14GiB path /dev/dm-3
        devid    6 size 465.76GiB used 63.14GiB path /dev/dm-4
        devid    7 size 465.76GiB used 63.14GiB path /dev/mapper/crypt_sdi1
        devid    8 size 465.76GiB used 63.14GiB path /dev/mapper/crypt_sdj1
        devid    9 size 465.76GiB used 63.14GiB path /dev/dm-7
        devid    10 size 465.76GiB used 63.14GiB path /dev/dm-8
        devid    11 size 465.76GiB used 33.14GiB path /dev/mapper/crypt_sde1 <- this device was added


Hope this helps,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
