From: "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
Subject: extremely slow syncing on btrfs with 2.6.39.1
Date: Sun, 10 Jul 2011 17:18:40 -0700
Message-ID: <CABsxX9KzpMRXs0MDD45rXLLsRiU6Gfadd=nUFsTviE4EVL1E9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've been monitoring the lists for a while now but didn't see this
problem mentioned in particular: I've got a fairly standard desktop
system at home, 700gb WD drive, nothing special, with 2 btrfs
filesystems and some snapshots. The system runs for days, and I've
noticed unusual disk activity the other evening - turns out that it's
taking forever to sync().

$ uname -r
2.6.39.1
$ grep btrfs /proc/mounts
/dev/root / btrfs rw,relatime 0 0    # is /dev/sdb2 #
/dev/sdb5 /home btrfs rw,relatime 0 0
$ time sync

real	1m5.552s
user	0m0.000s
sys	0m2.102s

$ time sync

real	1m16.830s
user	0m0.001s
sys	0m1.490s

$ df -h / /home
Filesystem      Size  Used Avail Use% Mounted on
/dev/root        47G   33G  7.7G  82% /
/dev/sdb5       652G  216G  421G  34% /home
$ btrfs fi df /
Data: total=35.48GB, used=29.86GB
System, DUP: total=16.00MB, used=12.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=4.50GB, used=1.67GB
 $ btrfs fi df /home
Data: total=310.01GB, used=209.53GB
System, DUP: total=8.00MB, used=48.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=11.00GB, used=2.98GB
Metadata: total=8.00MB, used=0.00

I'll switch to 3.0 soon, but, given the fact that we're going to be
running MeeGo on 2.6.39 probably for a while, I was wondering if
anyone knows off the top of their heads if this issue is
known/identified. If not then I'll need to make someone do some
patching ;).

Auke
