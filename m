From: Francesco Cepparo <francesco.cepparo@gmail.com>
Subject: kernel BUG at fs/btrfs/extent_io.c:1890!
Date: Wed, 11 Apr 2012 14:44:26 +0000
Message-ID: <CACfQV3hb92zrYUJ8to1mq8s1wzfdEoMBDi9b5VmfZ0AZ=UBkFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, I've been using btrfs for a while now, and some months ago one of
my filesystems stopped mounting. I tried to fix it by mounting it with
the recovery option, by using btrfs-zero-log and by restoring the
superblock but it didn't work, so I left the filesystem standing there
waiting for the fsck repairing tool to be released (running the
version of fsck I had at the time produced the following output:
http://dl.dropbox.com/u/2565562/btrfsck-old-output while running the
2012-03-28 version of btrfsck produces the following output:
http://dl.dropbox.com/u/2565562/btrfsck-20120328-output.gz ).
I'm still waiting for the repairing tool and I haven't tried the
dangerous don't ever use branch, but as I have updated the kernel to
version 3.4.0-rc2 I tried to mount the filesystem again with the new
kernel, and instead of failing with this error message:
http://dl.dropbox.com/u/2565562/btrfs-kernel-3.3 as it did with kernel
3.3.1 and the previous kernels, with 3.4.0-rc2 it now hits the
following kernel BUG:
http://dl.dropbox.com/u/2565562/btrfs-kernel-3.4-bug

I hope I can be of any help in improving the already great btrfs.
Also, is there any hope for me to recover my old filesystem? :)
