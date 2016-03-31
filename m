Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58525 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933327AbcCaUpO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Mar 2016 16:45:14 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aljSp-0006yG-3l
	for linux-btrfs@vger.kernel.org; Thu, 31 Mar 2016 22:45:11 +0200
Received: from ip5f5ae008.dynamic.kabel-deutschland.de ([95.90.224.8])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Mar 2016 22:45:11 +0200
Received: from hurikhan77 by ip5f5ae008.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Mar 2016 22:45:11 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: btrfsck: backpointer mismatch (and multiple other errors)
Date: Thu, 31 Mar 2016 22:44:52 +0200
Message-ID: <20160331224452.0753d5c7@jupiter.sol.kaishome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

I already reported this in another thread but it was a bit confusing by
intermixing multiple volumes. So let's start a new thread:

Since one of the last kernel upgrades, I'm experiencing one VDI file
(containing a NTFS image with Windows 7) getting damaged when running
the machine in VirtualBox. I got knowledge about this after
experiencing an error "duplicate object" and btrfs went RO. I fixed it
by deleting the VDI and restoring from backup - but no I get csum
errors as soon as some VM IO goes into the VDI file.

The FS is still usable. One effect is, that after reading all files
with rsync (to copy to my backup), each call of "du" or "df" hangs, also
similar calls to "btrfs {sub|fi} ..." show the same effect. I guess one
outcome of this is, that the FS does not properly unmount during
shutdown.

Kernel is 4.5.0 by now (the FS is much much older, dates back to 3.x
series, and never had problems), including Gentoo patch-set r1.

The device layout is:

$ lsblk -o NAME,MODEL,FSTYPE,LABEL,MOUNTPOINT
NAME        MODEL            FSTYPE LABEL      MOUNTPOINT
sda         Crucial_CT128MX1
├─sda1                       vfat   ESP        /boot
├─sda2
└─sda3                       bcache
  ├─bcache0                  btrfs  system
  ├─bcache1                  btrfs  system
  └─bcache2                  btrfs  system     /usr/src
sdb         SAMSUNG HD103SJ
├─sdb1                       swap   swap0      [SWAP]
└─sdb2                       bcache
  └─bcache2                  btrfs  system     /usr/src
sdc         SAMSUNG HD103SJ
├─sdc1                       swap   swap1      [SWAP]
└─sdc2                       bcache
  └─bcache1                  btrfs  system
sdd         SAMSUNG HD103UJ
├─sdd1                       swap   swap2      [SWAP]
└─sdd2                       bcache
  └─bcache0                  btrfs  system

Mount options are:

$ mount|fgrep btrfs
/dev/bcache2 on / type btrfs (rw,noatime,compress=lzo,nossd,discard,space_cache,autodefrag,subvolid=256,subvol=/gentoo/rootfs)

The FS uses mraid=1 and draid=0.

Output of btrfsck is:
(also available here:
https://gist.github.com/kakra/bfcce4af242f6548f4d6b45c8afb46ae)

$ btrfsck /dev/disk/by-label/system
checking extents
ref mismatch on [10443660537856 524288] extent item 1, found 2
Backref 10443660537856 root 256 owner 23536425 offset 1310720 num_refs 0 not found in extent tree
Incorrect local backref count on 10443660537856 root 256 owner 23536425 offset 1310720 found 1 wanted 0 back 0x4ceee750
Backref disk bytenr does not match extent record, bytenr=10443660537856, ref bytenr=10443660914688
Backref bytes do not match extent backref, bytenr=10443660537856, ref bytes=524288, backref bytes=69632
backpointer mismatch on [10443660537856 524288]
extent item 11271946579968 has multiple extent items
ref mismatch on [11271946579968 110592] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271946579968, ref bytenr=11271946629120
backpointer mismatch on [11271946579968 110592]
extent item 11271946690560 has multiple extent items
ref mismatch on [11271946690560 114688] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271946690560, ref bytenr=11271946739712
Backref bytes do not match extent backref, bytenr=11271946690560, ref bytes=114688, backref bytes=110592
backpointer mismatch on [11271946690560 114688]
extent item 11271946805248 has multiple extent items
ref mismatch on [11271946805248 114688] extent item 1, found 3
Backref disk bytenr does not match extent record, bytenr=11271946805248, ref bytenr=11271946850304
Backref bytes do not match extent backref, bytenr=11271946805248, ref bytes=114688, backref bytes=53248
Backref disk bytenr does not match extent record, bytenr=11271946805248, ref bytenr=11271946903552
Backref bytes do not match extent backref, bytenr=11271946805248, ref bytes=114688, backref bytes=49152
backpointer mismatch on [11271946805248 114688]
extent item 11271946919936 has multiple extent items
ref mismatch on [11271946919936 61440] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271946919936, ref bytenr=11271946952704
Backref bytes do not match extent backref, bytenr=11271946919936, ref bytes=61440, backref bytes=110592
backpointer mismatch on [11271946919936 61440]
extent item 11271946981376 has multiple extent items
ref mismatch on [11271946981376 110592] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271946981376, ref bytenr=11271947063296
backpointer mismatch on [11271946981376 110592]
extent item 11271947091968 has multiple extent items
ref mismatch on [11271947091968 110592] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271947091968, ref bytenr=11271947173888
Backref bytes do not match extent backref, bytenr=11271947091968, ref bytes=110592, backref bytes=114688
backpointer mismatch on [11271947091968 110592]
extent item 11271947202560 has multiple extent items
ref mismatch on [11271947202560 110592] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271947202560, ref bytenr=11271947288576
Backref bytes do not match extent backref, bytenr=11271947202560, ref bytes=110592, backref bytes=102400
backpointer mismatch on [11271947202560 110592]
extent item 11271947313152 has multiple extent items
ref mismatch on [11271947313152 114688] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271947313152, ref bytenr=11271947390976
Backref bytes do not match extent backref, bytenr=11271947313152, ref bytes=114688, backref bytes=110592
backpointer mismatch on [11271947313152 114688]
extent item 11271947427840 has multiple extent items
ref mismatch on [11271947427840 110592] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271947427840, ref bytenr=11271947501568
backpointer mismatch on [11271947427840 110592]
extent item 11271947538432 has multiple extent items
ref mismatch on [11271947538432 86016] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271947538432, ref bytenr=11271947612160
Backref bytes do not match extent backref, bytenr=11271947538432, ref bytes=86016, backref bytes=81920
backpointer mismatch on [11271947538432 86016]
extent item 11271947624448 has multiple extent items
ref mismatch on [11271947624448 77824] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271947624448, ref bytenr=11271947694080
Backref bytes do not match extent backref, bytenr=11271947624448, ref bytes=77824, backref bytes=102400
backpointer mismatch on [11271947624448 77824]
ref mismatch on [11271947702272 102400] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271947702272, ref bytenr=11271947796480
Backref bytes do not match extent backref, bytenr=11271947702272, ref bytes=102400, backref bytes=90112
backpointer mismatch on [11271947702272 102400]
extent item 11271947862016 has multiple extent items
extent item 11271947886592 has multiple extent items
ref mismatch on [11271947886592 131072] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271947886592, ref bytenr=11271947948032
Backref bytes do not match extent backref, bytenr=11271947886592, ref bytes=131072, backref bytes=102400
backpointer mismatch on [11271947886592 131072]
extent item 11271948017664 has multiple extent items
ref mismatch on [11271948017664 49152] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271948017664, ref bytenr=11271948050432
Backref bytes do not match extent backref, bytenr=11271948017664, ref bytes=49152, backref bytes=94208
backpointer mismatch on [11271948017664 49152]
extent item 11271948144640 has multiple extent items
ref mismatch on [11271948144640 73728] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271948144640, ref bytenr=11271948148736
Backref bytes do not match extent backref, bytenr=11271948144640, ref bytes=73728, backref bytes=110592
backpointer mismatch on [11271948144640 73728]
extent item 11271948218368 has multiple extent items
ref mismatch on [11271948218368 110592] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271948218368, ref bytenr=11271948259328
Backref bytes do not match extent backref, bytenr=11271948218368, ref bytes=110592, backref bytes=102400
backpointer mismatch on [11271948218368 110592]
extent item 11271948328960 has multiple extent items
ref mismatch on [11271948328960 106496] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271948328960, ref bytenr=11271948361728
Backref bytes do not match extent backref, bytenr=11271948328960, ref bytes=106496, backref bytes=110592
backpointer mismatch on [11271948328960 106496]
extent item 11271948435456 has multiple extent items
ref mismatch on [11271948435456 110592] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271948435456, ref bytenr=11271948472320
Backref bytes do not match extent backref, bytenr=11271948435456, ref bytes=110592, backref bytes=114688
backpointer mismatch on [11271948435456 110592]
extent item 11271948546048 has multiple extent items
ref mismatch on [11271948546048 110592] extent item 1, found 3
Backref disk bytenr does not match extent record, bytenr=11271948546048, ref bytenr=11271948587008
Backref bytes do not match extent backref, bytenr=11271948546048, ref bytes=110592, backref bytes=61440
Backref disk bytenr does not match extent record, bytenr=11271948546048, ref bytenr=11271948648448
Backref bytes do not match extent backref, bytenr=11271948546048, ref bytes=110592, backref bytes=73728
backpointer mismatch on [11271948546048 110592]
extent item 11271948656640 has multiple extent items
ref mismatch on [11271948656640 110592] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271948656640, ref bytenr=11271948722176
backpointer mismatch on [11271948656640 110592]
extent item 11271948767232 has multiple extent items
ref mismatch on [11271948767232 114688] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271948767232, ref bytenr=11271948832768
Backref bytes do not match extent backref, bytenr=11271948767232, ref bytes=114688, backref bytes=73728
backpointer mismatch on [11271948767232 114688]
extent item 11271948881920 has multiple extent items
ref mismatch on [11271948881920 114688] extent item 1, found 3
Backref disk bytenr does not match extent record, bytenr=11271948881920, ref bytenr=11271948906496
Backref bytes do not match extent backref, bytenr=11271948881920, ref bytes=114688, backref bytes=12288
Backref disk bytenr does not match extent record, bytenr=11271948881920, ref bytenr=11271948926976
Backref bytes do not match extent backref, bytenr=11271948881920, ref bytes=114688, backref bytes=524288
backpointer mismatch on [11271948881920 114688]
extent item 11271949414400 has multiple extent items
ref mismatch on [11271949414400 110592] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271949414400, ref bytenr=11271949451264
Backref bytes do not match extent backref, bytenr=11271949414400, ref bytes=110592, backref bytes=81920
backpointer mismatch on [11271949414400 110592]
extent item 11271949524992 has multiple extent items
ref mismatch on [11271949524992 57344] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271949524992, ref bytenr=11271949533184
Backref bytes do not match extent backref, bytenr=11271949524992, ref bytes=57344, backref bytes=94208
backpointer mismatch on [11271949524992 57344]
extent item 11271949582336 has multiple extent items
ref mismatch on [11271949582336 86016] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271949582336, ref bytenr=11271949627392
Backref bytes do not match extent backref, bytenr=11271949582336, ref bytes=86016, backref bytes=81920
backpointer mismatch on [11271949582336 86016]
extent item 11271949668352 has multiple extent items
ref mismatch on [11271949668352 94208] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271949668352, ref bytenr=11271949709312
Backref bytes do not match extent backref, bytenr=11271949668352, ref bytes=94208, backref bytes=98304
backpointer mismatch on [11271949668352 94208]
extent item 11271949762560 has multiple extent items
ref mismatch on [11271949762560 81920] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271949762560, ref bytenr=11271949807616
Backref bytes do not match extent backref, bytenr=11271949762560, ref bytes=81920, backref bytes=94208
backpointer mismatch on [11271949762560 81920]
extent item 11271949844480 has multiple extent items
ref mismatch on [11271949844480 94208] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271949844480, ref bytenr=11271949901824
backpointer mismatch on [11271949844480 94208]
extent item 11271949938688 has multiple extent items
ref mismatch on [11271949938688 81920] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271949938688, ref bytenr=11271949996032
Backref bytes do not match extent backref, bytenr=11271949938688, ref bytes=81920, backref bytes=90112
backpointer mismatch on [11271949938688 81920]
extent item 11271950020608 has multiple extent items
ref mismatch on [11271950020608 81920] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271950020608, ref bytenr=11271950086144
Backref bytes do not match extent backref, bytenr=11271950020608, ref bytes=81920, backref bytes=94208
backpointer mismatch on [11271950020608 81920]
extent item 11271950180352 has multiple extent items
ref mismatch on [11271950180352 81920] extent item 1, found 2
Backref bytes do not match extent backref, bytenr=11271950180352, ref bytes=81920, backref bytes=98304
backpointer mismatch on [11271950180352 81920]
ref mismatch on [11271950262272 81920] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271950262272, ref bytenr=11271950278656
Backref bytes do not match extent backref, bytenr=11271950262272, ref bytes=81920, backref bytes=102400
backpointer mismatch on [11271950262272 81920]
extent item 11271950344192 has multiple extent items
ref mismatch on [11271950344192 77824] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271950344192, ref bytenr=11271950381056
Backref bytes do not match extent backref, bytenr=11271950344192, ref bytes=77824, backref bytes=98304
backpointer mismatch on [11271950344192 77824]
extent item 11271950422016 has multiple extent items
ref mismatch on [11271950422016 81920] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271950422016, ref bytenr=11271950479360
Backref bytes do not match extent backref, bytenr=11271950422016, ref bytes=81920, backref bytes=98304
backpointer mismatch on [11271950422016 81920]
extent item 11271950503936 has multiple extent items
ref mismatch on [11271950503936 86016] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271950503936, ref bytenr=11271950577664
Backref bytes do not match extent backref, bytenr=11271950503936, ref bytes=86016, backref bytes=94208
backpointer mismatch on [11271950503936 86016]
extent item 11271950589952 has multiple extent items
ref mismatch on [11271950589952 86016] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271950589952, ref bytenr=11271950671872
Backref bytes do not match extent backref, bytenr=11271950589952, ref bytes=86016, backref bytes=94208
backpointer mismatch on [11271950589952 86016]
extent item 11271950675968 has multiple extent items
ref mismatch on [11271950675968 98304] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271950675968, ref bytenr=11271950766080
backpointer mismatch on [11271950675968 98304]
extent item 11271950774272 has multiple extent items
ref mismatch on [11271950774272 94208] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271950774272, ref bytenr=11271950864384
Backref bytes do not match extent backref, bytenr=11271950774272, ref bytes=94208, backref bytes=98304
backpointer mismatch on [11271950774272 94208]
extent item 11271950954496 has multiple extent items
ref mismatch on [11271950954496 90112] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271950954496, ref bytenr=11271950962688
Backref bytes do not match extent backref, bytenr=11271950954496, ref bytes=90112, backref bytes=61440
backpointer mismatch on [11271950954496 90112]
extent item 11271952793600 has multiple extent items
ref mismatch on [11271952793600 98304] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271952793600, ref bytenr=11271952879616
Backref bytes do not match extent backref, bytenr=11271952793600, ref bytes=98304, backref bytes=102400
backpointer mismatch on [11271952793600 98304]
extent item 11271952891904 has multiple extent items
ref mismatch on [11271952891904 262144] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271952891904, ref bytenr=11271952994304
Backref bytes do not match extent backref, bytenr=11271952891904, ref bytes=262144, backref bytes=1052672
backpointer mismatch on [11271952891904 262144]
extent item 11271953993728 has multiple extent items
ref mismatch on [11271953993728 114688] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271953993728, ref bytenr=11271954046976
Backref bytes do not match extent backref, bytenr=11271953993728, ref bytes=114688, backref bytes=1052672
backpointer mismatch on [11271953993728 114688]
ref mismatch on [11271954878464 393216] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271954878464, ref bytenr=11271955099648
Backref bytes do not match extent backref, bytenr=11271954878464, ref bytes=393216, backref bytes=3149824
backpointer mismatch on [11271954878464 393216]
extent item 11271956312064 has multiple extent items
ref mismatch on [11271958249472 2101248] extent item 0, found 1
Backref 11271958249472 parent 12160723820544 owner 0 offset 0 num_refs 0 not found in extent tree
Incorrect local backref count on 11271958249472 parent 12160723820544 owner 0 offset 0 found 1 wanted 0 back 0x14d56620
backpointer mismatch on [11271958249472 2101248]
extent item 11271960338432 has multiple extent items
ref mismatch on [11271960338432 57344] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271960338432, ref bytenr=11271960350720
Backref bytes do not match extent backref, bytenr=11271960338432, ref bytes=57344, backref bytes=1052672
backpointer mismatch on [11271960338432 57344]
extent item 11271961325568 has multiple extent items
ref mismatch on [11271961325568 81920] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271961325568, ref bytenr=11271961403392
Backref bytes do not match extent backref, bytenr=11271961325568, ref bytes=81920, backref bytes=1052672
backpointer mismatch on [11271961325568 81920]
extent item 11271962333184 has multiple extent items
ref mismatch on [11271962333184 524288] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271962333184, ref bytenr=11271962456064
Backref bytes do not match extent backref, bytenr=11271962333184, ref bytes=524288, backref bytes=1052672
backpointer mismatch on [11271962333184 524288]
extent item 11271963475968 has multiple extent items
ref mismatch on [11271963475968 393216] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271963475968, ref bytenr=11271963508736
Backref bytes do not match extent backref, bytenr=11271963475968, ref bytes=393216, backref bytes=1052672
backpointer mismatch on [11271963475968 393216]
extent item 11271964389376 has multiple extent items
ref mismatch on [11271964389376 524288] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271964389376, ref bytenr=11271964561408
Backref bytes do not match extent backref, bytenr=11271964389376, ref bytes=524288, backref bytes=1052672
backpointer mismatch on [11271964389376 524288]
extent item 11271965601792 has multiple extent items
ref mismatch on [11271965601792 90112] extent item 1, found 2
Backref disk bytenr does not match extent record, bytenr=11271965601792, ref bytenr=11271965614080
Backref bytes do not match extent backref, bytenr=11271965601792, ref bytes=90112, backref bytes=1052672
backpointer mismatch on [11271965601792 90112]
extent item 11271968571392 has multiple extent items
ref mismatch on [11271968571392 1052672] extent item 1, found 3
Backref disk bytenr does not match extent record, bytenr=11271968571392, ref bytenr=11271969107968
Backref bytes do not match extent backref, bytenr=11271968571392, ref bytes=1052672, backref bytes=69632
Backref disk bytenr does not match extent record, bytenr=11271968571392, ref bytenr=11271969177600
Backref bytes do not match extent backref, bytenr=11271968571392, ref bytes=1052672, backref bytes=262144
backpointer mismatch on [11271968571392 1052672]
checking free space cache
checking fs roots
root 4336 inode 4284125 errors 1000, some csum missing
Checking filesystem on /dev/disk/by-label/system
UUID: d2bb232a-2e8f-4951-8bcc-97e237f1b536
found 1832931324360 bytes used err is 1
total csum bytes: 1730105656
total tree bytes: 6494474240
total fs tree bytes: 3789783040
total extent tree bytes: 608219136
btree space waste bytes: 1221460063
file data blocks allocated: 2406059724800
 referenced 2040857763840


-- 
Regards,
Kai

Replies to list-only preferred.


