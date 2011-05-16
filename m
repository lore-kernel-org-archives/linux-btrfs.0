From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: No space left, with 80 GB space free
Date: Mon, 16 May 2011 20:08:23 +0200
Message-ID: <4DD16817.9020302@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've been trying to run PostgreSQL with a ~20-30 GB database on a btrfs 
filesystem (rest of the filesystem filled with KVM images, compressed 
archives etc.). Snapshots are cool, and let you rollback to a different 
database version easily ;)

Unfortunately, running PostgreSQL on btrfs wasn't very reliable as I was 
getting rather frequent "No space left" for some disk intensive 
operations (CREATE INDEX, REINDEX, VACUUM ANALYZE).

As the error happens, I still have around 80 GB free space on the 
filesystem:

Filesystem            Size  Used Avail Use% Mounted on
/dev/sdb4             336G  255G   80G  77% /mnt/btrfs


What's even more interesting, after the error happened, I'm able to 
write a ~85 GB file with dd before it exits with "out of space" (with 
and without the oflag=direct):

# dd if=/dev/urandom of=bigfile bs=1M
dd: writing `bigfile': No space left on device
81056+0 records in
81055+0 records out
84992327680 bytes (85 GB) copied, 9429.28 s, 9.0 MB/s


The kernel used was 2.6.39-rc5.

If it matters, I had the filesystem mounted with compress-force flag:

/dev/sdb4 on /mnt/btrfs type btrfs (rw,noatime,compress-force)



-- 
Tomasz Chmielewski
http://wpkg.org
