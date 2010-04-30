From: Victor Roetman <victory747@gmail.com>
Subject: Not compressing with compress (but will with compress-force)
Date: Fri, 30 Apr 2010 16:51:34 +0800
Message-ID: <4BDA9A16.1020009@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I am running 2.6.34-rc5 64 bit, and testing was done on a 4G USB thumb
drive. mount with compress-force compresses, but mount with compress
does not.

The file was a plain text file repeated many times to make a large file.
It also compresses very well as you can see:

-rw-r--r-- 1 vic vic 1.4G 2010-04-30 15:28 PLAINTEXT2.txt
-rw-r--r-- 1 vic vic 8.8M 2010-04-30 15:30 PLAINTEXT2.txt.gz

$ sudo mkfs.btrfs  -L testcompress /dev/sde1
$ sudo mount -t btrfs /dev/sde1 /media/testcompress -o compress-force
$ dmesg | tail -2
[22583.767477] device label testcompress devid 1 transid 7 /dev/sde1
[22583.780428] btrfs: forcing compression

I copied the file three times.

$ ls -al
total 4225768
dr-xr-xr-x 1 root root         84 2010-04-30 16:06 .
drwxr-xr-x 3 root root       4096 2010-04-30 15:46 ..
-rw-r--r-- 1 root root 1449901628 2010-04-30 15:58 PLAINTEXT2.txt
-rw-r--r-- 1 root root 1449901628 2010-04-30 15:59 PLAINTEXT3.txt
-rw-r--r-- 1 root root 1449901628 2010-04-30 16:06 PLAINTEXT4.txt

$ du -sh .
4.1G	.

$ df -h .
Filesystem            Size  Used Avail Use% Mounted on
/dev/sde1             3.8G  295M  3.1G   9% /media/testcompress

$ btrfs filesystem df .
Metadata, DUP: total=190.88MB, used=5.74MB
System, DUP: total=8.00MB, used=4.00KB
Data: total=771.50MB, used=283.61MB
Metadata: total=8.00MB, used=0.00
System: total=4.00MB, used=0.00

Why it says 771MB total instead of 3+GB, I don't know. But at least it's
compressing.

If I remount it with -o compress,
$ sudo mount -t btrfs /dev/sde1 /media/testcompress -o compress
$ dmesg | tail -2
[23422.050375] device label testcompress devid 1 transid 22 /dev/sde1
[23422.051832] btrfs: use compression

and copy the file again:
$ ls -al
total 5509080
dr-xr-xr-x 1 root root        112 2010-04-30 16:20 .
drwxr-xr-x 3 root root       4096 2010-04-30 15:46 ..
-rw-r--r-- 1 root root 1449901628 2010-04-30 15:58 PLAINTEXT2.txt
-rw-r--r-- 1 root root 1449901628 2010-04-30 15:59 PLAINTEXT3.txt
-rw-r--r-- 1 root root 1449901628 2010-04-30 16:06 PLAINTEXT4.txt
-rw-r--r-- 1 root root 1449901628 2010-04-30 16:20 PLAINTEXT5.txt

$ du -sh .
5.5G	.

$ df -h .
Filesystem            Size  Used Avail Use% Mounted on
/dev/sde1             3.8G  1.7G  1.8G  49% /media/testcompress

$ btrfs filesystem df .
Metadata, DUP: total=190.88MB, used=7.49MB
System, DUP: total=8.00MB, used=4.00KB
Data: total=2.62GB, used=1.60GB
Metadata: total=8.00MB, used=0.00
System: total=4.00MB, used=0.00

It did not seem to compress the file at all, even though it's just plain
text.

vic
