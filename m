From: Mathijs Kwik <bluescreen303@gmail.com>
Subject: raid modes, balancing, and order in which data gets written
Date: Thu, 15 Jul 2010 10:29:07 +0200
Message-ID: <AANLkTimPpNmiJ-sr4_DjsWHXAgfb2FUPDeEi6n86pKEH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I read that btrfs - in a raid mode - does not mimic the behavior of
traditional (hw/sw) raid.
After writing to a btrfs raid filesystem, data will only be
distributed the way you expect after running a rebalance.

Say I write a file to the a raid1 (or raid10) fs, and run the "sync"
command afterwards to make sure it is fully committed.
Does btrfs guarantee the data is on at least 2 disks at this stage?

And how about distributing io load on raid0 (or the part of raid10
"behind" the raid 1), if I write a big file, will it instantly be
striped/divided between disks?
Or do I need to rebalance after writing the file for this to happen?
Does this happen on extent basis or on file basis (in other words, do
files get striped between disks or does a file always stay whole on
first write)?

If you never rebalance manually, will the filesystem do this in the
background (when idle)?
Or will the fs never rebalance itself and only become "more balanced"
again after writing/changing some files, which it will then place on
the drive which has the lowest balance?

Basically, I'm not sure I fully understood balancing, so any info on
this would be great.
In traditional raid0 and raid10 (block based), it is guaranteed that
any big file will always be stiped between disks equally, so a certain
performance can be assumed.
With non-automatic balancing, I'm afraid some files might not be
distributed as well as they could, resulting in lower performance.
Is this an issue to be aware of, or can I safely assume that for most
use cases the performance will roughly be the same as sw-raid?
2 cases I'm interested in:
- big databases(lots of rewrites)
- real-time video-capturing (sustained write to 1 or more big files,
needing a guaranteed write throughput)

Any info on this or balancing in general will be greatly appreciated.
Thanks,
Mathijs
