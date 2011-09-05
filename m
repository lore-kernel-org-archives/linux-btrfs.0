From: Leen Besselink <leen@consolejunkie.net>
Subject: df output wrong ?
Date: Mon, 05 Sep 2011 11:50:43 +0200
Message-ID: <4E649B73.6060802@consolejunkie.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Just noticed something about df -h output I didn't expect.

I'm sorry if this has already been answered or is a know problem.

Just see the test-part below to see what I did.

____ setup ____

- installed Fedora 16 Alpha on a KVM-VM with one 8GB HD-image.
- did a yum update
( - got a kernel update, which broke grub setup, worked around it:
kernel I use is: 3.0.0-1.fc16.x86_64)
- installed btrfs-progs
- created a directory /test
- created 2 files with dd from /dev/zero with the size of 2GB in /test
- created 2 loopback devices of the files
- created a btrfs filesystem with RAID 1 data and RAID1 meta-data
- created directory /test/mnt

____ test _____

- mounted the btrfs filesystem on /test/mnt
- created a file of 256MB with dd from /dev/zero in /test/mnt
- created a snapshot of /test/mnt in /test/mnt/snap1
- deleted 256MB file in /test/mnt
- deleted snapshot /test/mnt/snap1
- checked df -h, 256MB wasn't released. The filesystem does not look empty
- unmounted /test/mnt
- mounted /test/mnt
- checked df -h, 256MB was released. The filesystem does look empty

Hope this is helpful.

Have a nice day,
    Leen.

