Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:64837 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678AbaF0Sdy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 14:33:54 -0400
Received: from [0.0.0.0] ([37.0.123.207]) by mail.gmx.com (mrgmx103) with
 ESMTPSA (Nemesis) id 0LvlWS-1WbAnq3wTc-017Y2x for
 <linux-btrfs@vger.kernel.org>; Fri, 27 Jun 2014 20:33:51 +0200
Message-ID: <53ADB90A.60502@gmx.net>
Date: Fri, 27 Jun 2014 20:33:46 +0200
From: "myLC@gmx.net" <myLC@gmx.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Cannot delete snapshot
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, =)

I got a problem with a simple backup bash script. It creates a snapshot and then backs it up.
The user (Ubuntu 12.04, 64-bit) interrupted the script with CTRL+C shortly after it started.
Then the machine was rebooted several times. Now these snapshots cannot be deleted anymore
and new ones can't be taken.


This is what the script does before it starts the backup process:

mount /mnt/big -o remount -o rw # /mnt/big is a partition for backups, which is read-only
mkdir /mnt/backup_root
mount /dev/sda1 /mnt/backup_root # /dev/sda1 on /home type btrfs (rw,subvol=@home)
btrfs subvolume snapshot /mnt/backup_root/@ /mnt/backup_root/@snapshot_backup_root
btrfs subvolume snapshot /mnt/backup_root/@home /mnt/backup_root/@snapshot_backup_home
mkdir /mnt/backup
mount --bind /mnt/backup_root/@snapshot_backup_root /mnt/backup/
mount --bind /mnt/backup_root/@snapshot_backup_home/ /mnt/backup/home/
mount --bind /boot /mnt/backup/boot/

This is what it didn't do, as it was interrupted:
umount /mnt/backup/boot/ 1> /dev/null 2> /dev/null
umount /mnt/backup/home/ 1> /dev/null 2> /dev/null
umount /mnt/backup 1> /dev/null 2> /dev/null
rmdir /mnt/backup 1> /dev/null 2> /dev/null
btrfs subvolume delete /mnt/backup_root/@snapshot_backup_home 1> /dev/null 2> /dev/null
btrfs subvolume delete /mnt/backup_root/@snapshot_backup_root 1> /dev/null 2> /dev/null
umount /mnt/backup_root 1> /dev/null 2> /dev/null
rmdir /mnt/backup_root 1> /dev/null 2> /dev/null
mount /mnt/big -o remount -o ro 1> /dev/null 2> /dev/null


This is what the file-system is supposed to look like:
# btrfs subvolume list '/'
ID 256 top level 5 path @
ID 257 top level 5 path @home

and this is what it looks like instead:
# btrfs subvolume list '/'
ID 256 top level 5 path @
ID 257 top level 5 path @home
ID 258 top level 5 path @snapshot_backup_root
ID 259 top level 5 path @snapshot_backup_home
ID 260 top level 5 path @snapshot_backup_root/@
ID 261 top level 5 path @snapshot_backup_home/@home
# btrfs subvolume list '/mnt'
ERROR: '/mnt' is not a subvolume
# btrfs subvolume list '/mnt/backup_root'
ERROR: error accessing '/mnt/backup_root'


When running the script again, it prints:
ERROR: cannot snapshot '/mnt/backup_root/@'
and
ERROR: cannot snapshot '/mnt/backup_root/@home'
as they still seem to exist.

But deleting the snapshots fails as well.

btrfs subvolume delete  '/@snapshot_backup_root'
btrfs subvolume delete  '/@snapshot_backup_home'
btrfs subvolume delete  '/@snapshot_backup_root/@'
btrfs subvolume delete  '/@snapshot_backup_home/@home'
btrfs subvolume delete  '/@snapshot_backup_root'
btrfs subvolume delete  '/@snapshot_backup_home'

didn't work (ERROR: error accessing '/@snapshot_backup_root'.
Simply running the unmount/delete snapshot part of the script didn't either.

How can I get rid of those snapshots (ID 257-261)?

I tried:
# mkdir /tmp/t
# mount /dev/sda1 /tmp/t  -o subvol=/
# ls /tmp/t

@
@home
@snapshot_backup_home
@snapshot_backup_root

# btrfs subvol delete /tmp/t/@snapshot_backup_home
Delete subvolume '/tmp/t/@snapshot_backup_home'
ERROR: cannot delete '/tmp/t/@snapshot_backup_home'


Needless to say that such an error message isn't really helpful.


I'd appreciate any help. As I'm NOT SUBSCRIBED TO THE MAILING LIST,
please CC to
                  myLC@gmx.net

Thank you very much! :-)



PS.: I didn't append any dmesg and such as they likely won't be of any use,
     given the very specific problem. If needed I can supply them.



