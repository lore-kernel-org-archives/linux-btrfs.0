From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: btrfs fi defrag -c
Date: Thu, 27 Oct 2011 20:20:22 +0100
Message-ID: <20111027192022.GD4389@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I don't quite understand the behavior of "btrfs fi defrag"

~# truncate -s2G ~/a
~# mkfs.btrfs ~/a
        nodesize 4096 leafsize 4096 sectorsize 4096 size 2.00GB
~# mount -o loop ~/a /mnt/1
/mnt/1# cd x
/mnt/1# df -h .
Filesystem      Size  Used Avail Use% Mounted on
/dev/loop1      2.0G   64K  1.8G   1% /mnt/1
/mnt/1# yes | head -c400M > a
/mnt/1# df -h .
Filesystem      Size  Used Avail Use% Mounted on
/dev/loop1      2.0G   64K  1.8G   1% /mnt/1
/mnt/1# sync
/mnt/1# df -h .
Filesystem      Size  Used Avail Use% Mounted on
/dev/loop1      2.0G  402M  1.4G  23% /mnt/1
/mnt/1# btrfs fi defrag -c a

(exit status == 20 BTW).

(20)/mnt/1# sync
/mnt/1# df -h .
Filesystem      Size  Used Avail Use% Mounted on
/dev/loop1      2.0G  415M  994M  30% /mnt/1

No space gain, even lost 15M or 400M depending on how you look at it.

/mnt/1# btrfs fi defrag  a
(20)/mnt/1# sync
/mnt/1# df -h .
Filesystem      Size  Used Avail Use% Mounted on
/dev/loop1      2.0G  797M  612M  57% /mnt/1

Lost another 400M.

/mnt/1# ls -l
total 409600
-rw-r--r-- 1 root root 419430400 Oct 27 19:53 a
/mnt/1# btrfs fi balance .
/mnt/1# sync
/mnt/1# df -h .
Filesystem      Size  Used Avail Use% Mounted on
/dev/loop1      2.0G  798M  845M  49% /mnt/1

Possibly reclaimed some of the space?

At the point where it says 612M free, if I do:
/mnt/1# cat < /dev/zero > b
cat: write error: No space left on device
/mnt/1# ls -lh b
-rw-r--r-- 1 root root 612M Oct 27 20:14 b

There was indeed 612M free.


When the FS is mounted with compress:

~# mkfs.btrfs ./a
        nodesize 4096 leafsize 4096 sectorsize 4096 size 2.00GB
~# mount -o compress ./a /mnt/1
~# cd /mnt/1
/mnt/1# yes | head -c400M > a
/mnt/1# sync
/mnt/1# df -h .
Filesystem      Size  Used Avail Use% Mounted on
/dev/loop1      2.0G   14M  1.8G   1% /mnt/1
/mnt/1# btrfs fi defrag -c ./a
(20)/mnt/1# sync
/mnt/1# df -h .
Filesystem      Size  Used Avail Use% Mounted on
/dev/loop1      2.0G   21M  1.4G   2% /mnt/1

Lost 400M?

/mnt/1# btrfs fi defrag ./a
(20)/mnt/1# sync
/mnt/1# df -h .
Filesystem      Size  Used Avail Use% Mounted on
/dev/loop1      2.0G   21M  1.4G   2% /mnt/1

I take it it doesn't uncompress?

I'm a bit confused here.

(that's with 3.0 amd64)

-- 
Stephane
