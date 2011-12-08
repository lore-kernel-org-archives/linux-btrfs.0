From: Jeremy Sanders <jeremy@jeremysanders.net>
Subject: Btrfs switches to using mostly one thread
Date: Thu, 08 Dec 2011 15:19:38 +0000
Message-ID: <jbqkib$v1g$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi - I'm trying out btrfs again, and I see the same old bug in kernel 3.1.4 
(Fedora 16, x86_64, dual-core), where after a few hours of writing, it 
switches from writing with several threads to writing with one:

After:

21996 root      20   0     0    0    0 R 97.2  0.0 109:03.57 btrfs-delalloc-
23332 root      20   0  137m  14m 1000 S  3.3  1.0   5:40.32 tar
23333 root      20   0  125m 3620  960 D  2.7  0.2   4:33.04 tar
22026 root      20   0     0    0    0 S  2.0  0.0   3:14.73 btrfs-endio-wri
23626 root      20   0     0    0    0 S  2.0  0.0   0:17.64 kworker/0:0
   55 root      20   0     0    0    0 S  1.3  0.0   6:46.35 kswapd0
22255 root      20   0     0    0    0 S  1.0  0.0   2:12.30 kworker/0:2
22025 root      20   0     0    0    0 S  0.3  0.0   3:16.34 btrfs-endio-wri

Before:

23867 root      20   0     0    0    0 R 66.6  0.0   0:13.45 btrfs-delalloc-
24021 root      20   0     0    0    0 R 60.6  0.0   0:10.58 btrfs-delalloc-
24025 root      20   0     0    0    0 R 45.7  0.0   0:10.01 btrfs-delalloc-
24018 root      20   0  124m 2384 1116 R  8.6  0.2   0:03.31 tar
24019 root      20   0  124m 2276 1052 S  7.0  0.1   0:02.47 tar
   55 root      20   0     0    0    0 S  2.6  0.0   6:47.92 kswapd0
24022 root      20   0     0    0    0 S  2.0  0.0   0:00.59 btrfs-endio-wri
22255 root      20   0     0    0    0 S  1.7  0.0   2:13.45 kworker/0:2
23626 root      20   0     0    0    0 S  1.7  0.0   0:18.84 kworker/0:0
24024 root      20   0     0    0    0 S  1.7  0.0   0:00.77 btrfs-endio-wri
23866 root      20   0     0    0    0 S  0.7  0.0   0:00.25 btrfs-submit-0
23912 root      20   0     0    0    0 D  0.3  0.0   0:00.26 flush-btrfs-4

It can be put back to its initial behaviour by unmounting and reloading the 
btrfs kernel module. I'm using compress-force=zlib for this, and it's 
writing with a tar-to-tar pipe (or rsync). I think switching to one thread 
it has a pretty negative impact on write speed (50%).

I think the cause is writing lots of small files to the disk, but I can't be 
sure.

Jeremy

