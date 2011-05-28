From: Andrea Gelmini <andrea.gelmini@gmail.com>
Subject: Problem with latest for-linus branch
Date: Sat, 28 May 2011 19:05:47 +0200
Message-ID: <BANLkTikmYx+K9crXYFeBmsJm+qUq9_W+gQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,
   and thanks a lot for your work.
   Well, I'm using my home with BTRFS. It's a Ext4 converted to BTRFS
via btrfs-convert.
   Everything works good with stock Ubuntu 11.04 kernel (2.6.38),
vanilla 2.6.38 and vanilla 2.6.39.
   If I use Linus' git tree, BTRFS ooops at mount.
   So I bisected using kernel version 2.6.39 + latest for-linus branch.
   Bisect complains about this commit:
581bb050941b4f220f84d3e5ed6dace3d42dd382 is the first bad commit
commit 581bb050941b4f220f84d3e5ed6dace3d42dd382
Author: Li Zefan <lizf@cn.fujitsu.com>
Date:   Wed Apr 20 10:06:11 2011 +0800

    Btrfs: Cache free inode numbers in memory

   And bisect log is this:
git bisect start
# bad: [174ba50915b08dcfd07c8b5fb795b46a165fa09a] Btrfs: use the
device_list_mutex during write_dev_supers
git bisect bad 174ba50915b08dcfd07c8b5fb795b46a165fa09a
# good: [61c4f2c81c61f73549928dfd9f3e8f26aa36a8cf] Linux 2.6.39
git bisect good 61c4f2c81c61f73549928dfd9f3e8f26aa36a8cf
# bad: [aa2dfb372a2a647beedac163ce6f8b0fcbefac29] Merge branch
'allocator' of git://git.kernel.org/pub/scm/linux/kernel/git/arne/btrfs-unstable-arne
into inode_numbers
git bisect bad aa2dfb372a2a647beedac163ce6f8b0fcbefac29
# good: [7a36ddec1003a4e84e79f28ee714a142ed6bc529] btrfs: use
printk_ratelimited instead of printk_ratelimit
git bisect good 7a36ddec1003a4e84e79f28ee714a142ed6bc529
# bad: [0965537308ac3b267ea16e731bd73870a51c53b8] Merge branch
'ino-alloc' of git://repo.or.cz/linux-btrfs-devel into inode_numbers
git bisect bad 0965537308ac3b267ea16e731bd73870a51c53b8
# bad: [581bb050941b4f220f84d3e5ed6dace3d42dd382] Btrfs: Cache free
inode numbers in memory
git bisect bad 581bb050941b4f220f84d3e5ed6dace3d42dd382
# good: [f38b6e754d8cc4605ac21d9c1094d569d88b163b] Btrfs: Use bitmap_set/clear()
git bisect good f38b6e754d8cc4605ac21d9c1094d569d88b163b
# good: [34d52cb6c50b5a43901709998f59fb1c5a43dc4a] Btrfs: Make free
space cache code generic
git bisect good 34d52cb6c50b5a43901709998f59fb1c5a43dc4a

  I can see two kind of problems, with different commit, of course.
  Sometimes the Ooops happens just as kernel mounts the partition,
sometimes the mount is good, but HD keeps reading for more than 30
seconds, and the it Ooops.
  Also, you can read but you can't write, meanwhile.

In attachment my config.

I have photos of the Ooops, but right now I can't take 'em from the phone...
But, maybe, you already knew and solved the problem.
Anyway, if you need much more details, just tell me.

Thanks a lot for your time,
Andrea
