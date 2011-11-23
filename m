From: Blair Zajac <blair@orcaware.com>
Subject: fsck with "err is 1"
Date: Tue, 22 Nov 2011 21:33:38 -0800
Message-ID: <EB38FBF9-9284-4902-ABC6-B6FB6B6D4E50@orcaware.com>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm trying btrfs in a VirtualBox VM running Ubuntu 11.10 with kernel 3.0.0.  Running fsck I get a message with "err is 1".

root@ubuntu-11-10-i386:/# fsck -v -v /
fsck from util-linux 2.19.1
root 257 inode 878 errors 400
found 6938783744 bytes used err is 1
total csum bytes: 6281436
total tree bytes: 501153792
total fs tree bytes: 465928192
btree space waste bytes: 134778274
file data blocks allocated: 12274962432
 referenced 6405234688
Btrfs Btrfs v0.19

Does this mean there's an error?  Is err either always 0 or 1, or does err increment beyond 1?

I've tried doing the following to fix the filesystem, but "err is 1" doesn't change.

- btrfs filesystem balance /
- find / -mount -type f -print0 | xargs -0 cat >/dev/null

The later shows no errors in dmesg.

Thanks,
Blair

