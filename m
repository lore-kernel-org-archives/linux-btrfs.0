Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:51082 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbaGBFOv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Jul 2014 01:14:51 -0400
Received: by mail-pa0-f51.google.com with SMTP id hz1so11872628pad.38
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Jul 2014 22:14:50 -0700 (PDT)
Received: from mail2.smcindiaonline.com ([59.144.72.226])
        by mx.google.com with ESMTPSA id zq5sm35203554pbb.37.2014.07.01.22.14.48
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Jul 2014 22:14:49 -0700 (PDT)
Date: Wed, 2 Jul 2014 10:44:44 +0530
From: Vikram Goyal <vikigoyal@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: btrfs fi df <mount point> outputs info instead of error even when
 <mount-point> is just a directory
Message-ID: <20140702051444.GA5459@mail2.smcindiaonline.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

As the subject specifies there is some confusion (at least with me:) as
to what should be the ouput/behaviour of command btrfs fi df

Please refer to https://bugzilla.redhat.com/show_bug.cgi?id=1114995

The comment by Eric Sendeen further complicates the understanding.
(again with me:)

1} The command btrfs fi df has been more or less been equated with
   traditional df. The problem is that traditional df does not output
   error when no path is given as what currently is done by btrfs fi df
2} Traditional df outputs a column 'Mounted on' for each device/fs it
   finds which btrfs fi df does not. For Ex.

   [vikram@localhost ~]# df
   Filesystem     1K-blocks      Used Available Use% Mounted on
   /dev/sdb6      153942744  69903440  81431312  47% /
   devtmpfs         1520392         0   1520392   0% /dev
   tmpfs            1527612      1444   1526168   1% /dev/shm
   tmpfs            1527612      9108   1518504   1% /run
   tmpfs            1527612         0   1527612   0% /sys/fs/cgroup
   tmpfs            1527612       120   1527492   1% /tmp
   /dev/sda1        1515376    172040   1248312  13% /boot
   /dev/dm-0      330327632 230022072  97561080  71% /home/vikram

   [vikram@localhost ~]# btrfs fi df /usr/
   Data, RAID1: total=42.00GiB, used=32.44GiB
   System, RAID1: total=32.00MiB, used=12.00KiB
   Metadata, RAID1: total=2.00GiB, used=915.04MiB

   [vikram@localhost ~]# btrfs fi df /
   Data, RAID1: total=42.00GiB, used=32.44GiB
   System, RAID1: total=32.00MiB, used=12.00KiB
   Metadata, RAID1: total=2.00GiB, used=915.04MiB

  [ivikram@localhost ~]# btrfs fi show
  Label: 'fedora'  uuid: d2b3420c-99c1-44cc-a922-ac266072c7fb
          Total devices 2 FS bytes used 33.33GiB
          devid    2 size 73.51GiB used 44.03GiB path /dev/sdb6
          devid    3 size 73.30GiB used 44.03GiB path /dev/sda2

  Label: 'Vikram'  uuid: 0809b072-35f3-4866-92b8-af4772b23ed6
          Total devices 2 FS bytes used 109.68GiB
          devid    1 size 158.03GiB used 157.00GiB path /dev/dm-0
          devid    2 size 157.00GiB used 157.00GiB path /dev/mapper/sdb1

So there in no way to understand if there was an error (except for non existant
path) in the path argument given to btrfs fi df. This can create a lot of
confusion in administeration.

So IMHO some changes need to done to btrfs fi df.

1} The requirement for path arg be removed, since that gives a false impression
   by a valid output that the arg was correct as in fs mount point sense POV.

2} btrfs fi df should output the mount point in all cases:
   a} Where arg path is valid but not a mount point. Should output btrfs FS info with mount point as traditional df.
   b} Where arg path is valid & is also a mount point. Should show output for that mount only.
   c} Where no arg is given, Should output all btrfs FSes info with mount points.

3} btrfs fi df should error out on an invalid path as it does currently.

Thanks for your precious time.

-- 
vikram...
         ||||||||
         ||||||||
^^'''''^^||root||^^^'''''''^^
        // \\   ))
       //(( \\// \\
      // /\\ ||   \\
     || / )) ((    \\
-- 
Nice boy, but about as sharp as a sack of wet mice.
		-- Foghorn Leghorn
-- 
  o
 ~|~
  =
