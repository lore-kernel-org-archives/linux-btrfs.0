From: Dirk Lutzebaeck <dirk@lutzebaeck.net>
Subject: Trying to mount RAID1 degraded with removed disk -> open_ctree failed
Date: Sun, 22 Jan 2012 16:05:14 +0100
Message-ID: <jfh8ja$pa$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have setup a RAID1 using 3 devices (500G each) on separate disks. 
After removing one disk physically the filesystem cannot be mounted in 
degraded nor in recovery mode. When putting the disk back in the 
filesystem can be mounted without errors. I did a cold-swap (powercycle 
after removal/insertion of the disk).

Here are the details:

- latest kernel 3.2.1 and btrfs-tools on xubuntu 11.10

# uname -a
Linux sol2 3.2.1-030201-generic #201201121644 SMP Thu Jan 12 21:45:24 
UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

# btrfs device scan

# btrfs fi show btrfs-r1b
Label: 'btrfs-r1b'  uuid: 11ac3be1-62ce-4b1c-8069-63942f1354bd
         Total devices 3 FS bytes used 206.60GB
         devid    3 size 465.66GB used 140.00GB path /dev/sdc1
         devid    2 size 465.66GB used 139.02GB path /dev/sda2
         *** Some devices missing

# mount -o degraded /r1b
mount: /dev/sdc1: can't read superblock
[ 2156.393337] device label btrfs-r1b devid 3 transid 2441 /dev/sdc1
[ 2156.407816] btrfs: allowing degraded mounts
[ 2156.770745] parent transid verify failed on 448316575744 wanted 2427 
found 2425
[ 2156.770762] parent transid verify failed on 448316575744 wanted 2427 
found 2425
[ 2156.770769] parent transid verify failed on 448316575744 wanted 2427 
found 2425
[ 2156.770774] parent transid verify failed on 448316575744 wanted 2427 
found 2425
[ 2156.784722] btrfs warning page private not zero on page 448229711872
[ 2156.784842] btrfs: open_ctree failed


# mount -o recovery /r1b
[ 2286.282041] device label btrfs-r1b devid 3 transid 2441 /dev/sdc1
[ 2286.282664] btrfs: enabling auto recovery
[ 2286.284709] btrfs: failed to read chunk tree on sda2
[ 2286.285045] btrfs: open_ctree failed


# find-root /dev/sda2
warning devid 1 not found already
Failed to read: Illegal seek
warning, device 1 is missing
warning, device 1 is missing
warning, device 1 is missing
Super think's the tree root is at 448316571648, chunk root 20983808


# btrfsck /dev/sda2
warning devid 1 not found already
parent transid verify failed on 448316575744 wanted 2427 found 2425
parent transid verify failed on 448316575744 wanted 2427 found 2425
Ignoring transid failure
Check tree block failed, want=448316588032, have=11529940786129179172
Check tree block failed, want=448316588032, have=11529940786129179172
Check tree block failed, want=448316588032, have=11529940786129179172
read block failed check_tree_block


What is happening? RAID1 should be mountable degraded with one 
missing/removed device.


-Dirk


