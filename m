Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bay004-omc3s3.hotmail.com ([65.54.190.141]:54607 "EHLO
        BAY004-OMC3S3.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932257AbcJMV3C (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Oct 2016 17:29:02 -0400
From: Alberto Bursi <alberto.bursi@outlook.it>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Copy BTRFS volume to another BTRFS volume including subvolumes and
 snapshots
Date: Thu, 13 Oct 2016 21:21:09 +0000
Message-ID: <AM3PR08MB06423820D86D1E408FFD766492DC0@AM3PR08MB0642.eurprd08.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, I'm using OpenSUSE on a btrfs volume spanning 2 disks (set as raid1 
for both metadata and data), no separate /home partition.
The distro loves to create dozens of subvolumes for various things and 
makes snapshots, see:
alby@openSUSE-xeon:~> sudo btrfs subvolume list /
ID 257 gen 394 top level 5 path @
ID 258 gen 293390 top level 257 path @/.snapshots
ID 259 gen 293607 top level 258 path @/.snapshots/1/snapshot
ID 260 gen 107012 top level 257 path @/boot/grub2/i386-pc
ID 261 gen 107012 top level 257 path @/boot/grub2/x86_64-efi
ID 262 gen 293610 top level 257 path @/home
ID 263 gen 292439 top level 257 path @/opt
ID 264 gen 288726 top level 257 path @/srv
ID 265 gen 293610 top level 257 path @/tmp
ID 266 gen 292657 top level 257 path @/usr/local
ID 267 gen 104612 top level 257 path @/var/crash
ID 268 gen 133454 top level 257 path @/var/lib/libvirt/images
ID 269 gen 104612 top level 257 path @/var/lib/mailman
ID 270 gen 104612 top level 257 path @/var/lib/mariadb
ID 271 gen 292441 top level 257 path @/var/lib/mysql
ID 272 gen 104612 top level 257 path @/var/lib/named
ID 273 gen 104612 top level 257 path @/var/lib/pgsql
ID 274 gen 293608 top level 257 path @/var/log
ID 275 gen 104612 top level 257 path @/var/opt
ID 276 gen 293610 top level 257 path @/var/spool
ID 277 gen 293606 top level 257 path @/var/tmp
ID 362 gen 228259 top level 258 path @/.snapshots/56/snapshot
ID 364 gen 228259 top level 258 path @/.snapshots/57/snapshot
ID 528 gen 228259 top level 258 path @/.snapshots/110/snapshot
ID 529 gen 228259 top level 258 path @/.snapshots/111/snapshot
ID 670 gen 228259 top level 258 path @/.snapshots/240/snapshot
ID 671 gen 228259 top level 258 path @/.snapshots/241/snapshot
ID 894 gen 228283 top level 258 path @/.snapshots/438/snapshot
ID 895 gen 228283 top level 258 path @/.snapshots/439/snapshot
ID 896 gen 228283 top level 258 path @/.snapshots/440/snapshot
ID 897 gen 228283 top level 258 path @/.snapshots/441/snapshot
ID 1033 gen 288965 top level 258 path @/.snapshots/554/snapshot
ID 1034 gen 289531 top level 258 path @/.snapshots/555/snapshot
ID 1035 gen 289726 top level 258 path @/.snapshots/556/snapshot
ID 1036 gen 289729 top level 258 path @/.snapshots/557/snapshot
ID 1037 gen 290297 top level 258 path @/.snapshots/558/snapshot
ID 1038 gen 290301 top level 258 path @/.snapshots/559/snapshot
ID 1039 gen 290336 top level 258 path @/.snapshots/560/snapshot
ID 1041 gen 290338 top level 258 path @/.snapshots/562/snapshot
ID 1043 gen 292047 top level 258 path @/.snapshots/563/snapshot
ID 1044 gen 292051 top level 258 path @/.snapshots/564/snapshot
ID 1045 gen 292531 top level 258 path @/.snapshots/565/snapshot
ID 1046 gen 293153 top level 258 path @/.snapshots/566/snapshot

I'd like to be able to clone verbatim the whole volume to another 
volume, for backup purposes.

Now, I think I can do that with a brutal partition clone from my 
"recovery" (a debian system installed in another drive) and then doing 
the procedures to deal with a lost drive.

But I'd rather prefer a clone on a live system, and without doing a 
brutal clone as that will keep the same UUIDs.

I can(will) script this so even if it is a tedious process or it 
involves writing a huge line in the commandline it's not an issue.

Thanks for any input.

-Alberto
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˝ªk~œ‚ûÿ^nár°ˆ¶zÀÅÎhô®Ë≠⁄&£˚‡zø‰zπﬁó˙+Ä +zf£¢∑höàß~Ü≠Ü€iˇˇÔÅÍˇëÍÁz_ËÆÊj:+vâ®˛)ﬂ£¯m
