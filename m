From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 0/3] Btrfs: save free space cache to the disk
Date: Wed, 15 Sep 2010 15:08:51 -0400
Message-ID: <1284577734-3161-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch series introduces the ability for btrfs to store the free space cache
ondisk to make the caching of a block group much quicker.  Previously we had to
search the entire extent-tree to look for gaps everytime we wanted to allocate
in a block group.  This approach instead dumps all of the free space cache to
disk for every dirtied block group each time we commit the transaction.  This is
a disk format change, but in order to use the feature you will have to mount
with -o space_cache, and then from then on you won't be able to use old kernels
with your filesystem.  You can pull these patches from my git tree

git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-work.git

and they should pull right onto Chris's btrfs-unstable tree.  Please test this
as it's a big change and I can only test so much.  That being said this has been
run through xfstests thoroughly and I've been running it on a VM with btrfs as
root.  Thanks,

Josef
