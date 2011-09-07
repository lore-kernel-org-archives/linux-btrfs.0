From: Jeff Liu <jeff.liu@oracle.com>
Subject: mount a multi-device filesystem using a loopback device
Date: Wed, 07 Sep 2011 12:18:24 +0800
Message-ID: <4E66F090.4030507@oracle.com>
Reply-To: jeff.liu@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I was trying to create a multi-device Btrfs filesystem using two 
loopback devices, by referring to the following page:
https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices

However, I met a strange thing while mounting the first loop device 
without any extra mount options,

1.  Create and format two images, the 1st in 400Mbytes, and 2nd in 
286Mbytes.
root@pibroch:/btrfs-progs# ls -lh /usr/src/linux-3.0/img*
-rw-r--r-- 1 jeff jeff 400M 2011-09-07 12:00 /usr/src/linux-3.0/img0
-rw-r--r-- 1 jeff jeff 286M 2011-09-07 12:00 /usr/src/linux-3.0/img1

root@pibroch:/btrfs-progs# mkfs.btrfs /usr/src/linux-3.0/img0 
/usr/src/linux-3.0/img1

WARNING! - Btrfs v0.19-35-g1b444cd IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

failed to read /dev/sr0
failed to read /dev/sr0
adding device /usr/src/linux-3.0/img1 id 2
fs created label (null) on /usr/src/linux-3.0/img0
     nodesize 4096 leafsize 4096 sectorsize 4096 size 685.50MB
Btrfs v0.19-35-g1b444cd

2. Setup the loopback manually:
root@pibroch:/btrfs-progs# losetup /dev/loop0 /usr/src/linux-3.0/img0
root@pibroch:/btrfs-progs# losetup /dev/loop1 /usr/src/linux-3.0/img1
root@pibroch:/btrfs-progs# losetup -a
/dev/loop0: [0802]:1736614 (/usr/src/linux-3.0/img0)
/dev/loop1: [0802]:1736726 (/usr/src/linux-3.0/img1)

3. Try to mount loop0, it will failed as below:
root@pibroch:/btrfs-progs# mount /dev/loop0 /mnt
mount: wrong fs type, bad option, bad superblock on /dev/loop0,
        missing codepage or helper program, or other error
        In some cases useful info is found in syslog - try
        dmesg | tail  or so

4. Try to mount loop1, it works:
root@pibroch:/btrfs-progs# mount /dev/loop1 /mnt
root@pibroch:/btrfs-progs# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda2              46G   23G   21G  52% /
none                  896M  700K  895M   1% /dev
none                  957M   80K  957M   1% /dev/shm
none                  957M  104K  957M   1% /var/run
none                  957M     0  957M   0% /var/lock
/dev/loop1            686M   56K  493M   1% /mnt

5. umount loop1, and try to mount loop0 again, it works at this time:
root@pibroch:/btrfs-progs# umount /mnt
root@pibroch:/btrfs-progs# mount /dev/loop0 /mnt
root@pibroch:/btrfs-progs# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda2              46G   23G   21G  52% /
none                  896M  700K  895M   1% /dev
none                  957M   80K  957M   1% /dev/shm
none                  957M  104K  957M   1% /var/run
none                  957M     0  957M   0% /var/lock
/dev/loop0            686M   56K  493M   1% /mnt

According to my debugging result, for the 1st time, mount loop0 failed 
at around volumes.c:3468:

                 map->stripes[i].dev = btrfs_find_device(root, devid, uuid,
                                                         NULL);
                 if (!map->stripes[i].dev && !btrfs_test_opt(root, 
DEGRADED)) {
                         kfree(map);
                         free_extent_map(em);
                         return -EIO;

So I repeat the above steps again, and try to mount loop0 with "-o 
degraded" option, it works as expected:
root@pibroch:/btrfs-progs# mount -o degraded /dev/loop0 /mnt
root@pibroch:/btrfs-progs# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda2              46G   23G   21G  52% /
none                  896M  700K  895M   1% /dev
none                  957M  140K  957M   1% /dev/shm
none                  957M  104K  957M   1% /var/run
none                  957M     0  957M   0% /var/lock
/dev/loop0            686M   56K  136M   1% /mnt


kernel version 3.1.0-rc2+.

Is it a bug? or Am I missing something?


Thanks,
-Jeff
