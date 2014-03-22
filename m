Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.13]:59411 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaCVSNy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Mar 2014 14:13:54 -0400
Message-ID: <532DD2DC.3030408@friedels.name>
Date: Sat, 22 Mar 2014 19:13:48 +0100
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: free space inode generation (0) did not match free space cache generation
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have a file-system on which I cannot write anymore (no space left on 
device, which is not true
root@homeserver:~/btrfs/integration/devel# df -h
Dateisystem    Größe Benutzt Verf. Verw% Eingehängt auf
/dev/sdd2        30G     24G  5,1G   83% /mnt/test1
)

About the filesystem:
root@homeserver:~/btrfs/integration/devel# ./btrfs fi show /mnt/test1
Label: 'ROOT_BTRFS_RAID'  uuid: a2d5f2db-04ca-413a-aee1-cb754aa8fba5
         Total devices 2 FS bytes used 11.84GiB
         devid    1 size 14.85GiB used 14.67GiB path /dev/sde2
         devid    2 size 14.65GiB used 14.65GiB path /dev/sdd2
Btrfs this-will-become-v3.13-48-g57c3600


Check of the filesystem:
root@homeserver:~/btrfs/integration/devel# umount /mnt/test1
root@homeserver:~/btrfs/integration/devel# ./btrfsck /dev/sdd2
Checking filesystem on /dev/sdd2
UUID: a2d5f2db-04ca-413a-aee1-cb754aa8fba5
checking extents
checking free space cache
free space inode generation (0) did not match free space cache 
generation (41)
free space inode generation (0) did not match free space cache 
generation (7380)
free space inode generation (0) did not match free space cache 
generation (3081)
checking fs roots
checking csums
checking root refs
found 3680170466 bytes used err is 0
total csum bytes: 10071956
total tree bytes: 2398781440
total fs tree bytes: 2308784128
total extent tree bytes: 74203136
btree space waste bytes: 372004575
file data blocks allocated: 341759610880
  referenced 75292241920
Btrfs this-will-become-v3.13-48-g57c3600

Before the btrfsck I did a
  mount -o clear_cache  /dev/sdd2 /mnt/test1/

which in fact reduced the number of error messages (did not match free 
space cache generation) from more than ten to just three.

I do have a backup of the FS and in fact it would have been quicker just 
whiping the disk and using the backup (just 16GB), than writing this 
message.
But:
Is it of interest to look at fixing this for someone, so that the 
development of btrfs can profit of this, or should I just whipe the disc?

Greetings,
Hendrik
