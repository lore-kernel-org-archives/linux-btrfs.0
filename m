From: Milko Krachounov <sombre@gmail.com>
Subject: Error on creating snapshots (btrfs: could not do orphan cleanup -116)
Date: Mon, 5 Sep 2011 18:57:21 +0300
Message-ID: <CAJ-vRAKSGSXa5kjJ6zwk8qos2LgoJq8m4CYFPz+zHmkaoiGGDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This happens on a freshly created btrfs filesystem in a raid10 (4x1TB)
configuration with three
subvolumes and 1.5 TB data.

When I try to snapshot one of the subvolumes (with 100 GB of data), it
says that the snapshot
creation failed and I get the following error message:

btrfs: could not do orphan cleanup -116

After the failure:
- The snapshot exists in `btrfs subvolume list'
- The snapshot CAN'T be accessed from the mounted subvolume where I created the
snapshot (but the directory entry exists and displays non-sense when
you try to do `ls -la')
- The snapshot CAN be accessed from any other mount of the same subvolume
- The snapshot CAN be accessed after unmount/remount

This was also coupled with a warning in dmesg that was fixed with
slyich's patch from
`[PATCH] btrfs: fix warning in iput for bad-inode.'

I did a little bit of research on the problem, and while I'm too
unfamiliar with the code of btrfs to diagnose it,
I'd like to share some of the observations as they appear to be of importance:

The failure happens when btrfs_orphan_cleanup calls btrfs_iget to get
the inode and it returns
ERR_PTR(-ESTALE). This happens when is_bad_inode(inode) is true.
However, after the call
to btrfs_iget there is an explicit code path for the case when
is_bad_inode(inode) is true (line 2393).
This code path would *never ever* get executed unless something
happening in another thread can
affect the return value between the two calls. I believe that lines
2394-2402 would never be executed.

What's more I discovered the following patch:

[PATCH 5/6] btrfs: Add per subvolume cached inode tree #2
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg02435.html

The patch changes the behaviour of btrfs_orphan_cleanup -- without it
there is no code that would lead
to ERR_PTR(-ESTALE) and the bad inode code path will run. With it,
suddenly this code path isn't called
and instead an error is produced.

I think I should try and reverse this specific change in the following
days and see if it fixes the problem, but
I'm not confident enough to blindly change the code without asking for
comments first, so any comment is
appreciated.

Thank you.
