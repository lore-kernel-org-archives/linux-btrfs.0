From: Ben Gamari <bgamari@gmail.com>
Subject: Recovering data from disk with loose cable
Date: Wed, 9 Feb 2011 21:46:38 -0500
Message-ID: <AANLkTinsT-FRkV0Ja63YCqCn2OWdZnYORxPFgKm4DxQW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We have a disk array behind two external SATA port multipliers (four
disks on each multiplier) which has been running btrfs (RAID 1 for
both data and metadata). Unfortunately, earlier today it seems one of
the SATA cables came loose, resulting in the kernel (2.6.37)
eventually OOPSing although apparently not before writing quite a bit
of data. Upon reboot, I was met with the dreaded,

    disk-io.c:741: open_ctree_fd: Assertion `!(!tree_root->node)' failed.

Unfortunately any attempt to run any of the btrfs-progs utilities
(from git) met a similar end. There was recently a patch to try harder
in recovering from this problem posted to the list[1], although
unfortunately it is unable to find a root. Considering there are eight
disks in the array and only four were affected by the loose cable, I
find it very hard to believe there is no way to recover this volume.
Any suggestions at all would be greatly appreciated. Recovering this
data would mean a lot. Thanks,

- Ben


[1] https://patchwork.kernel.org/patch/506631/

[2] Output from patched btrfsck

$ sudo ./btrfsck /dev/sdj
trying potential super #0 at bytenr 65536
super #0 at bytenr 65536 has better generation 43887 than 0, using that
trying potential super #1 at bytenr 67108864
super #1 at bytenr 67108864 has same generation 43887 than 43887, skipping
   warning: super #1 at bytenr 67108864 has different contents!
trying potential super #2 at bytenr 274877906944
super #2 at bytenr 274877906944 has same generation 43887 than 43887, skipping
   warning: super #2 at bytenr 274877906944 has different contents!
trying potential super #0 at bytenr 65536
super #0 at bytenr 65536 has better generation 43887 than 0, using that
trying potential super #1 at bytenr 67108864
super #1 at bytenr 67108864 has same generation 43887 than 43887, skipping
   warning: super #1 at bytenr 67108864 has different contents!
trying potential super #2 at bytenr 274877906944
super #2 at bytenr 274877906944 has same generation 43887 than 43887, skipping
   warning: super #2 at bytenr 274877906944 has different contents!
trying potential super #0 at bytenr 65536
super #0 at bytenr 65536 has better generation 43887 than 0, using that
trying potential super #1 at bytenr 67108864
super #1 at bytenr 67108864 has same generation 43887 than 43887, skipping
   warning: super #1 at bytenr 67108864 has different contents!
trying potential super #2 at bytenr 274877906944
super #2 at bytenr 274877906944 has same generation 43887 than 43887, skipping
   warning: super #2 at bytenr 274877906944 has different contents!
trying potential super #0 at bytenr 65536
super #0 at bytenr 65536 has better generation 43887 than 0, using that
trying potential super #1 at bytenr 67108864
super #1 at bytenr 67108864 has same generation 43887 than 43887, skipping
   warning: super #1 at bytenr 67108864 has different contents!
trying potential super #2 at bytenr 274877906944
super #2 at bytenr 274877906944 has same generation 43887 than 43887, skipping
   warning: super #2 at bytenr 274877906944 has different contents!
trying potential super #0 at bytenr 65536
super #0 at bytenr 65536 has better generation 43887 than 0, using that
trying potential super #1 at bytenr 67108864
super #1 at bytenr 67108864 has same generation 43887 than 43887, skipping
   warning: super #1 at bytenr 67108864 has different contents!
trying potential super #2 at bytenr 274877906944
super #2 at bytenr 274877906944 has same generation 43887 than 43887, skipping
   warning: super #2 at bytenr 274877906944 has different contents!
trying potential super #0 at bytenr 65536
super #0 at bytenr 65536 has better generation 43884 than 0, using that
trying potential super #1 at bytenr 67108864
super #1 at bytenr 67108864 has same generation 43884 than 43884, skipping
   warning: super #1 at bytenr 67108864 has different contents!
trying potential super #2 at bytenr 274877906944
super #2 at bytenr 274877906944 has same generation 43884 than 43884, skipping
   warning: super #2 at bytenr 274877906944 has different contents!
trying potential super #0 at bytenr 65536
super #0 at bytenr 65536 has better generation 43884 than 0, using that
trying potential super #1 at bytenr 67108864
super #1 at bytenr 67108864 has same generation 43884 than 43884, skipping
   warning: super #1 at bytenr 67108864 has different contents!
trying potential super #2 at bytenr 274877906944
super #2 at bytenr 274877906944 has same generation 43884 than 43884, skipping
   warning: super #2 at bytenr 274877906944 has different contents!
trying potential super #0 at bytenr 65536
super #0 at bytenr 65536 has better generation 43884 than 0, using that
trying potential super #1 at bytenr 67108864
super #1 at bytenr 67108864 has same generation 43884 than 43884, skipping
   warning: super #1 at bytenr 67108864 has different contents!
trying potential super #2 at bytenr 274877906944
super #2 at bytenr 274877906944 has same generation 43884 than 43884, skipping
   warning: super #2 at bytenr 274877906944 has different contents!
trying potential super #0 at bytenr 65536
super #0 at bytenr 65536 has better generation 43884 than 0, using that
trying potential super #1 at bytenr 67108864
super #1 at bytenr 67108864 has same generation 43884 than 43884, skipping
   warning: super #1 at bytenr 67108864 has different contents!
trying potential super #2 at bytenr 274877906944
super #2 at bytenr 274877906944 has same generation 43884 than 43884, skipping
   warning: super #2 at bytenr 274877906944 has different contents!
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    misplaced block thinks it's at 0
trying potential super #2 at bytenr 274877906944
    misplaced block thinks it's at 7810207560462397294
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    misplaced block thinks it's at 0
trying potential super #2 at bytenr 274877906944
    misplaced block thinks it's at 6004222992565259776
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    misplaced block thinks it's at 0
trying potential super #2 at bytenr 274877906944
    misplaced block thinks it's at 5629534856563150433
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    misplaced block thinks it's at 0
trying potential super #2 at bytenr 274877906944
    misplaced block thinks it's at 2314885531594477088
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 13633814763508087371
trying potential super #1 at bytenr 67108864
    misplaced block thinks it's at 13675223438066551223
trying potential super #2 at bytenr 274877906944
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 8315161591618561071
trying potential super #1 at bytenr 67108864
    misplaced block thinks it's at 13768406020965233321
trying potential super #2 at bytenr 274877906944
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 102597697750990864
trying potential super #1 at bytenr 67108864
    misplaced block thinks it's at 7205870954452514560
trying potential super #2 at bytenr 274877906944
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 458752
trying potential super #1 at bytenr 67108864
    misplaced block thinks it's at 2254
trying potential super #2 at bytenr 274877906944
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    misplaced block thinks it's at 0
trying potential super #2 at bytenr 274877906944
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    misplaced block thinks it's at 0
trying potential super #2 at bytenr 274877906944
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    misplaced block thinks it's at 0
trying potential super #2 at bytenr 274877906944
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 327680
trying potential super #1 at bytenr 67108864
    misplaced block thinks it's at 2747241352741333024
trying potential super #2 at bytenr 274877906944
    misplaced block thinks it's at 18446744073709551615
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 327680
trying potential super #1 at bytenr 67108864
    misplaced block thinks it's at 2747241352741333024
trying potential super #2 at bytenr 274877906944
    misplaced block thinks it's at 18446744073709551615
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 327680
trying potential super #1 at bytenr 67108864
    misplaced block thinks it's at 2747241352741333024
trying potential super #2 at bytenr 274877906944
    misplaced block thinks it's at 18446744073709551615
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 18446744073709551615
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
super #0 at bytenr 65536 has better generation 43887 than 0, using that
trying potential super #1 at bytenr 67108864
super #1 at bytenr 67108864 has same generation 43887 than 43887, skipping
   warning: super #1 at bytenr 67108864 has different contents!
trying potential super #2 at bytenr 274877906944
super #2 at bytenr 274877906944 has same generation 43887 than 43887, skipping
   warning: super #2 at bytenr 274877906944 has different contents!
trying potential super #0 at bytenr 65536
super #0 at bytenr 65536 has better generation 43887 than 0, using that
trying potential super #1 at bytenr 67108864
super #1 at bytenr 67108864 has same generation 43887 than 43887, skipping
   warning: super #1 at bytenr 67108864 has different contents!
trying potential super #2 at bytenr 274877906944
super #2 at bytenr 274877906944 has same generation 43887 than 43887, skipping
   warning: super #2 at bytenr 274877906944 has different contents!
trying potential super #0 at bytenr 65536
super #0 at bytenr 65536 has better generation 43887 than 0, using that
trying potential super #1 at bytenr 67108864
super #1 at bytenr 67108864 has same generation 43887 than 43887, skipping
   warning: super #1 at bytenr 67108864 has different contents!
trying potential super #2 at bytenr 274877906944
super #2 at bytenr 274877906944 has same generation 43887 than 43887, skipping
   warning: super #2 at bytenr 274877906944 has different contents!
trying potential super #0 at bytenr 65536
super #0 at bytenr 65536 has better generation 43887 than 0, using that
trying potential super #1 at bytenr 67108864
super #1 at bytenr 67108864 has same generation 43887 than 43887, skipping
   warning: super #1 at bytenr 67108864 has different contents!
trying potential super #2 at bytenr 274877906944
super #2 at bytenr 274877906944 has same generation 43887 than 43887, skipping
   warning: super #2 at bytenr 274877906944 has different contents!
trying potential super #0 at bytenr 65536
super #0 at bytenr 65536 has better generation 43887 than 0, using that
trying potential super #1 at bytenr 67108864
super #1 at bytenr 67108864 has same generation 43887 than 43887, skipping
   warning: super #1 at bytenr 67108864 has different contents!
trying potential super #2 at bytenr 274877906944
super #2 at bytenr 274877906944 has same generation 43887 than 43887, skipping
   warning: super #2 at bytenr 274877906944 has different contents!
trying potential super #0 at bytenr 65536
super #0 at bytenr 65536 has better generation 43884 than 0, using that
trying potential super #1 at bytenr 67108864
super #1 at bytenr 67108864 has same generation 43884 than 43884, skipping
   warning: super #1 at bytenr 67108864 has different contents!
trying potential super #2 at bytenr 274877906944
super #2 at bytenr 274877906944 has same generation 43884 than 43884, skipping
   warning: super #2 at bytenr 274877906944 has different contents!
trying potential super #0 at bytenr 65536
super #0 at bytenr 65536 has better generation 43884 than 0, using that
trying potential super #1 at bytenr 67108864
super #1 at bytenr 67108864 has same generation 43884 than 43884, skipping
   warning: super #1 at bytenr 67108864 has different contents!
trying potential super #2 at bytenr 274877906944
super #2 at bytenr 274877906944 has same generation 43884 than 43884, skipping
   warning: super #2 at bytenr 274877906944 has different contents!
trying potential super #0 at bytenr 65536
super #0 at bytenr 65536 has better generation 43884 than 0, using that
trying potential super #1 at bytenr 67108864
super #1 at bytenr 67108864 has same generation 43884 than 43884, skipping
   warning: super #1 at bytenr 67108864 has different contents!
trying potential super #2 at bytenr 274877906944
super #2 at bytenr 274877906944 has same generation 43884 than 43884, skipping
   warning: super #2 at bytenr 274877906944 has different contents!
trying potential super #0 at bytenr 65536
super #0 at bytenr 65536 has better generation 43884 than 0, using that
trying potential super #1 at bytenr 67108864
super #1 at bytenr 67108864 has same generation 43884 than 43884, skipping
   warning: super #1 at bytenr 67108864 has different contents!
trying potential super #2 at bytenr 274877906944
super #2 at bytenr 274877906944 has same generation 43884 than 43884, skipping
   warning: super #2 at bytenr 274877906944 has different contents!
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    misplaced block thinks it's at 0
trying potential super #2 at bytenr 274877906944
    misplaced block thinks it's at 7810207560462397294
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    misplaced block thinks it's at 0
trying potential super #2 at bytenr 274877906944
    misplaced block thinks it's at 6004222992565259776
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    misplaced block thinks it's at 0
trying potential super #2 at bytenr 274877906944
    misplaced block thinks it's at 5629534856563150433
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    misplaced block thinks it's at 0
trying potential super #2 at bytenr 274877906944
    misplaced block thinks it's at 2314885531594477088
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 13633814763508087371
trying potential super #1 at bytenr 67108864
    misplaced block thinks it's at 13675223438066551223
trying potential super #2 at bytenr 274877906944
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 8315161591618561071
trying potential super #1 at bytenr 67108864
    misplaced block thinks it's at 13768406020965233321
trying potential super #2 at bytenr 274877906944
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 102597697750990864
trying potential super #1 at bytenr 67108864
    misplaced block thinks it's at 7205870954452514560
trying potential super #2 at bytenr 274877906944
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 458752
trying potential super #1 at bytenr 67108864
    misplaced block thinks it's at 2254
trying potential super #2 at bytenr 274877906944
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    misplaced block thinks it's at 0
trying potential super #2 at bytenr 274877906944
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    misplaced block thinks it's at 0
trying potential super #2 at bytenr 274877906944
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    misplaced block thinks it's at 0
trying potential super #2 at bytenr 274877906944
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 0
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 327680
trying potential super #1 at bytenr 67108864
    misplaced block thinks it's at 2747241352741333024
trying potential super #2 at bytenr 274877906944
    misplaced block thinks it's at 18446744073709551615
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 327680
trying potential super #1 at bytenr 67108864
    misplaced block thinks it's at 2747241352741333024
trying potential super #2 at bytenr 274877906944
    misplaced block thinks it's at 18446744073709551615
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 327680
trying potential super #1 at bytenr 67108864
    misplaced block thinks it's at 2747241352741333024
trying potential super #2 at bytenr 274877906944
    misplaced block thinks it's at 18446744073709551615
trying potential super #0 at bytenr 65536
    misplaced block thinks it's at 18446744073709551615
trying potential super #1 at bytenr 67108864
    got only 0 bytes instead of 2859
trying potential super #0 at bytenr 65536
super #0 at bytenr 65536 has better generation 43887 than 0, using that
trying potential super #1 at bytenr 67108864
super #1 at bytenr 67108864 has same generation 43887 than 43887, skipping
   warning: super #1 at bytenr 67108864 has different contents!
trying potential super #2 at bytenr 274877906944
super #2 at bytenr 274877906944 has same generation 43887 than 43887, skipping
   warning: super #2 at bytenr 274877906944 has different contents!
start place mismatch, buf says 21037056  btrfs_hdr says 20971520
start place mismatch, buf says 21041152  btrfs_hdr says 20975616
start place mismatch, buf says 21045248  btrfs_hdr says 20979712
start place mismatch, buf says 21049344  btrfs_hdr says 20983808
start place mismatch, buf says 21053440  btrfs_hdr says 20987904
start place mismatch, buf says 21057536  btrfs_hdr says 20992000
start place mismatch, buf says 854739120128  btrfs_hdr says 854738923520
start place mismatch, buf says 854739120128  btrfs_hdr says 0
start place mismatch, buf says 854739120128  btrfs_hdr says 0
