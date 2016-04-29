Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f196.google.com ([209.85.213.196]:36808 "EHLO
	mail-ig0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbcD2LYQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Apr 2016 07:24:16 -0400
Received: by mail-ig0-f196.google.com with SMTP id c3so2129280igl.3
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Apr 2016 04:24:15 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 29 Apr 2016 11:24:12 +0000
Message-ID: <CAEr_6SvhqyiyHiyU9CwSP9stN__6SwT-KbF2MXhr8EvFTVyjjQ@mail.gmail.com>
Subject: recovery problem raid5
From: Pierre-Matthieu anglade <pierre.matthieu.anglade@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello all,

Setting up and then testing a system I've stumbled upon something that
looks exactly similar to the behaviour depicted by Marcin Solecki here
https://www.spinics.net/lists/linux-btrfs/msg53119.html.

Maybe unlike Martin I still have all my disk working nicely. So the
Raid array is OK, the system running on it is ok. But If I remove one
of the drive and try to mount in degraded mode, mounting the
filesystem, and then recovering fails.

More precisely, the situation is the following :
# uname -a
Linux ubuntu 4.4.0-21-generic #37-Ubuntu SMP Mon Apr 18 18:33:37 UTC
2016 x86_64 x86_64 x86_64 GNU/Linu

# btrfs --version
btrfs-progs v4.4

# btrfs fi show
warning, device 1 is missing
warning, device 1 is missing
warning devid 1 not found already
bytenr mismatch, want=125903568896, have=125903437824
Couldn't read tree root
Label: none  uuid: 26220e12-d6bd-48b2-89bc-e5df29062484
    Total devices 4 FS bytes used 162.48GiB
    devid    2 size 2.71TiB used 64.38GiB path /dev/sdb2
    devid    3 size 2.71TiB used 64.91GiB path /dev/sdc2
    devid    4 size 2.71TiB used 64.91GiB path /dev/sdd2
    *** Some devices missing

# mount -o degraded /dev/sdb2 /mnt
mount: /dev/sdb2: can't read superblock

# dmesg |tail
[12852.044823] BTRFS info (device sdd2): allowing degraded mounts
[12852.044829] BTRFS info (device sdd2): disk space caching is enabled
[12852.044831] BTRFS: has skinny extents
[12852.073746] BTRFS error (device sdd2): bad tree block start 196608
125257826304
[12852.121589] BTRFS: open_ctree failed

----------------
In case it may help I came there the following way :
1) *I've installed ubuntu on a single btrfs partition.
* Then I have added 3 other partitions
* convert the whole thing to a raid5 array
* play with the system and shut-down
2) * Removed drive sdb and replaced it with a new drive
* restored the whole thing (using a livecd, and btrfs replace)
* reboot
* checked that the system is still working
* shut-down
3) *removed drive sda and replaced it with a new one
* tried to perform the exact same operations I did when replacing sdb.
* It fails with some messages (not quite sure they were the same as above).
* shutdown
4) * put back sda
* check that I don't get any error message with my btrfs raid 5. So
I'm sure nothings looks like being corrupted
* shut-down
5) * tried again step 3.
* get the messages shown above.

I guess I can still put back my drive sda and get my btrfs working.
I'd be quite grateful for any comment or help.
I'm wondering if in my case the problem is not comming from the fact
the tree root (or something of that kind living only on sda) has not
been replicated when setting up the raid array ?

Best regards,


-- 
Pierre-Matthieu Anglade
