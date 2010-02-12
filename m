From: Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: zero-length files in snapshots
Date: Thu, 11 Feb 2010 20:49:42 -0500
Message-ID: <12b5f1ef1002111749u4f33b626jb6a901b29f05337f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I often get zero-length files in btrfs snapshots (when the original
files were not zero-length).  The shell script below reproduces this
problem on two Ubuntu machines, with Ubuntu kernels 2.6.31-17.54 and
2.6.32-12.17.  Is there some mistaken assumption I'm making here in
terms of how btrfsctl works?

Nickolai.

---

root@sahara:/# cat /tmp/btrbug.sh
#!/bin/sh -x
if id | grep -qv uid=0; then
    echo "Must run setup as root"
    exit 1
fi

if losetup -a | grep -q /dev/shm/fs.img; then
    echo "Loopback FS mounted, unmounting.."
    umount /mnt/x || exit 2
fi

rmmod btrfs
rmmod zlib_deflate
rmmod libcrc32c
modprobe btrfs

dd if=/dev/zero of=/dev/shm/fs.img bs=1024k count=256 || exit 2
mkfs -t btrfs /dev/shm/fs.img || exit 2

mkdir -p /mnt/x || exit 2
mount -o loop -t btrfs /dev/shm/fs.img /mnt/x || exit 2

mkdir /mnt/x/d || exit 2
echo x1 > /mnt/x/d/foo.txt || exit 2
btrfsctl -s /mnt/x/snap /mnt/x/d

wc -l /mnt/x/d/foo.txt
wc -l /mnt/x/snap/d/foo.txt

root@sahara:/# /tmp/btrbug.sh
+ id
+ grep -qv uid=0
+ losetup -a
+ grep -q /dev/shm/fs.img
+ echo Loopback FS mounted, unmounting..
Loopback FS mounted, unmounting..
+ umount /mnt/x
+ rmmod btrfs
+ rmmod zlib_deflate
+ rmmod libcrc32c
+ modprobe btrfs
+ dd if=/dev/zero of=/dev/shm/fs.img bs=1024k count=256
256+0 records in
256+0 records out
268435456 bytes (268 MB) copied, 0.231684 s, 1.2 GB/s
+ mkfs -t btrfs /dev/shm/fs.img

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/shm/fs.img
	nodesize 4096 leafsize 4096 sectorsize 4096 size 256.00MB
Btrfs Btrfs v0.19
+ mkdir -p /mnt/x
+ mount -o loop -t btrfs /dev/shm/fs.img /mnt/x
+ mkdir /mnt/x/d
+ echo x1
+ btrfsctl -s /mnt/x/snap /mnt/x/d
operation complete
Btrfs Btrfs v0.19
+ wc -l /mnt/x/d/foo.txt
1 /mnt/x/d/foo.txt
+ wc -l /mnt/x/snap/d/foo.txt
0 /mnt/x/snap/d/foo.txt
root@sahara:/#
