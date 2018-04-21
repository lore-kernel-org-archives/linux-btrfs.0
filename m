Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from demfloro.ru ([188.166.0.225]:50024 "EHLO demfloro.ru"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752350AbeDUPGm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 21 Apr 2018 11:06:42 -0400
Received: from [2001:470:28:88::100] (helo=localhost.localdomain)
        by demfloro.ru with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <demfloro@demfloro.ru>)
        id 1f9tvr-0002bI-KT
        for linux-btrfs@vger.kernel.org; Sat, 21 Apr 2018 14:56:08 +0000
Date: Sat, 21 Apr 2018 17:55:48 +0300
From: Dmitrii Tcvetkov <demfloro@demfloro.ru>
To: linux-btrfs@vger.kernel.org
Subject: 4.17-rc1 FS went read-only during balance
Message-ID: <20180421175548.4b07dffc@demfloro.ru>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/RrBy2fgvkLkRyZKLMJIaSe0"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--MP_/RrBy2fgvkLkRyZKLMJIaSe0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

TL;DR It seems as regression in 4.17, but I managed to find a
workaround to make filesystem rw mountable again.

Kernel built from tag v4.17-rc1
btrfs-progs 4.16

Tonight two my machines (PC (ECC RAM) and laptop(non-ECC RAM)) were
doing usual weekly balance with this command via cron:
btrfs balance start -musage=50 -dusage=50 <mountpoint>
Both machines run same kernel version. 

On PC that caused root and "data" filesystems to go readonly. Root is on
an SSD with data single and metadata DUP, "data" filesystem is on 2 HDDs
with RAID1 for data and metadata.

On laptop only /home went ro, it's on NVMe SSD with data single and
metadata DUP. 

Btrfs check of PC rootfs was without any errors in both modes, I did
them once each before reboot on readonly filesystem with --force flag
and then from live usb. Same output without any errors.

After reboot kernel refused rw mount rootfs with the same error as
during cron balance, ro mount was accepted, error during rw mount:
BTRFS: error (device dm-17) in merge_reloc_roots:2465: errno=-117
unknown BTRFS info (device dm-17): forced readonly BTRFS info (device
dm-17): delayed_refs has NO entry BTRFS error (device dm-17): cleaner
transaction attach returned -3

mount rw with skip_balance parameter didn't help to mount.

After that I mounted rw the rootfs with 4.16.2 kernel, mount was
successful and kernel finished balance. After that the filesystem is
mountable rw by 4.17-rc1 kernel without errors, btrfs check is clean
too.

Data filesystem behaves the same, rw mount on 4.17-rc1 kernel yields:
[ 2321.370113] BTRFS: error (device dm-17) in merge_reloc_roots:2465:
errno=-117 unknown [ 2321.370119] BTRFS warning (device dm-17): failed
to recover relocation: -30 [ 2321.370137] BTRFS info (device dm-17):
delayed_refs has NO entry [ 2321.370155] BTRFS error (device dm-17):
cleaner transaction attach returned -30 [ 2321.414219] BTRFS error
(device dm-17): open_ctree failed

Rw mount on 4.16.2 goes ok and after balance finishes the filesystem is
mountable by 4.17-rc1 again. I saved /home filesystem from laptop in
unmountable by 4.17-rc1 state and can test patches and/or create
btrfs-image if it's needed.

--MP_/RrBy2fgvkLkRyZKLMJIaSe0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=pc-dmesg

Apr 20 23:46:00 fire kernel: BTRFS: device label root devid 1 transid 350197 /dev/dm-2
Apr 20 23:46:00 fire kernel: BTRFS info (device dm-2): enabling auto defrag
Apr 20 23:46:00 fire kernel: BTRFS info (device dm-2): use lzo compression, level 0
Apr 20 23:46:00 fire kernel: BTRFS info (device dm-2): using free space tree
Apr 20 23:46:00 fire kernel: BTRFS info (device dm-2): has skinny extents
Apr 20 23:46:00 fire kernel: BTRFS info (device dm-2): using free space tree
Apr 20 23:46:10 fire kernel: BTRFS: device label home devid 2 transid 358906 /dev/dm-5
Apr 20 23:46:13 fire kernel: BTRFS: device label home devid 1 transid 358906 /dev/dm-12
Apr 20 23:46:13 fire kernel: BTRFS info (device dm-12): use zstd compression, level 0
Apr 20 23:46:13 fire kernel: BTRFS info (device dm-12): enabling auto defrag
Apr 20 23:46:13 fire kernel: BTRFS info (device dm-12): using free space tree
Apr 20 23:46:13 fire kernel: BTRFS info (device dm-12): has skinny extents
Apr 20 23:52:32 fire kernel: BTRFS: device label storage devid 1 transid 357668 /dev/dm-17
Apr 20 23:52:32 fire kernel: BTRFS: device label backup devid 1 transid 5383 /dev/dm-18
Apr 20 23:52:41 fire kernel: BTRFS: device label storage devid 2 transid 357668 /dev/dm-21
Apr 20 23:52:41 fire kernel: BTRFS: device label backup devid 2 transid 5383 /dev/dm-22
Apr 20 23:52:42 fire kernel: BTRFS info (device dm-17): enabling auto defrag
Apr 20 23:52:42 fire kernel: BTRFS info (device dm-17): use zstd compression, level 0
Apr 20 23:52:42 fire kernel: BTRFS info (device dm-17): using free space tree
Apr 20 23:52:42 fire kernel: BTRFS info (device dm-17): has skinny extents
Apr 20 23:52:45 fire kernel: BTRFS info (device dm-18): enabling auto defrag
Apr 20 23:52:45 fire kernel: BTRFS info (device dm-18): use zstd compression, level 0
Apr 20 23:52:45 fire kernel: BTRFS info (device dm-18): using free space tree
Apr 20 23:52:45 fire kernel: BTRFS info (device dm-18): has skinny extents
Apr 21 01:30:00 fire kernel: BTRFS info (device dm-2): relocating block group 27309113344 flags system|dup
Apr 21 01:30:00 fire kernel: BTRFS info (device dm-12): relocating block group 62910365696 flags system|raid1
Apr 21 01:30:00 fire kernel: BTRFS info (device dm-17): relocating block group 2140869230592 flags metadata|raid1
Apr 21 01:30:00 fire kernel: BTRFS info (device dm-2): relocating block group 27040677888 flags metadata|dup
Apr 21 01:30:00 fire kernel: BTRFS info (device dm-12): relocating block group 61836623872 flags data|raid1
Apr 21 01:30:01 fire kernel: BTRFS info (device dm-12): found 5 extents
Apr 21 01:30:01 fire kernel: BTRFS: error (device dm-2) in merge_reloc_roots:2465: errno=-117 unknown
Apr 21 01:30:01 fire kernel: BTRFS info (device dm-2): forced readonly
Apr 21 01:30:03 fire kernel: BTRFS info (device dm-12): found 5 extents
Apr 21 01:30:04 fire kernel: BTRFS info (device dm-12): relocating block group 60762882048 flags metadata|raid1
Apr 21 01:30:08 fire kernel: BTRFS info (device dm-17): found 1521 extents
Apr 21 01:30:08 fire kernel: BTRFS info (device dm-17): relocating block group 2139761934336 flags metadata|raid1
Apr 21 01:30:22 fire kernel: BTRFS info (device dm-12): found 1709 extents
Apr 21 01:30:25 fire kernel: BTRFS info (device dm-17): found 4297 extents
Apr 21 01:30:25 fire kernel: BTRFS info (device dm-2): delayed_refs has NO entry
Apr 21 01:30:26 fire kernel: BTRFS: error (device dm-17) in merge_reloc_roots:2465: errno=-117 unknown
Apr 21 01:30:26 fire kernel: BTRFS info (device dm-17): forced readonly
Apr 21 01:30:26 fire kernel: BTRFS info (device dm-17): delayed_refs has NO entry
Apr 21 10:28:29 fire kernel: BTRFS error (device dm-17): cleaner transaction attach returned -30

--MP_/RrBy2fgvkLkRyZKLMJIaSe0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=laptop-dmesg

Apr 12 14:56:42 xps kernel: BTRFS info (device dm-3): enabling auto defrag
Apr 12 14:56:42 xps kernel: BTRFS info (device dm-3): using free space tree
Apr 12 14:56:42 xps kernel: BTRFS info (device dm-3): has skinny extents
Apr 14 02:00:00 xps kernel: BTRFS info (device dm-1): relocating block group 30496784384 flags data
Apr 14 02:00:00 xps kernel: BTRFS info (device dm-1): found 2 extents
Apr 14 02:00:00 xps kernel: BTRFS info (device dm-1): found 2 extents
Apr 14 02:00:00 xps kernel: BTRFS info (device dm-1): relocating block group 30463229952 flags system|dup
Apr 14 02:00:00 xps kernel: BTRFS info (device dm-1): found 1 extents
Apr 14 02:00:00 xps kernel: BTRFS info (device dm-1): relocating block group 29892804608 flags metadata|dup
Apr 14 02:00:00 xps kernel: BTRFS info (device dm-1): found 849 extents
Apr 14 02:05:00 xps kernel: BTRFS info (device dm-3): relocating block group 64453869568 flags metadata|dup
Apr 14 02:05:01 xps kernel: BTRFS info (device dm-3): found 2145 extents
Apr 14 02:05:01 xps kernel: BTRFS info (device dm-3): relocating block group 64420315136 flags system|dup
Apr 14 02:05:01 xps kernel: BTRFS info (device dm-3): found 1 extents
Apr 14 02:05:01 xps kernel: BTRFS info (device dm-3): relocating block group 61165535232 flags data
Apr 14 02:05:01 xps kernel: BTRFS info (device dm-3): found 13 extents
Apr 14 02:05:01 xps kernel: BTRFS info (device dm-3): found 13 extents
Apr 14 02:05:01 xps kernel: BTRFS info (device dm-3): relocating block group 60091793408 flags data
Apr 14 02:05:01 xps kernel: BTRFS info (device dm-3): found 5 extents
Apr 14 02:05:01 xps kernel: BTRFS info (device dm-3): found 5 extents
Apr 14 02:05:01 xps kernel: BTRFS info (device dm-3): relocating block group 59018051584 flags data
Apr 14 02:05:01 xps kernel: BTRFS info (device dm-3): found 5 extents
Apr 14 02:05:01 xps kernel: BTRFS info (device dm-3): found 5 extents
Apr 14 02:05:01 xps kernel: BTRFS info (device dm-3): relocating block group 57944309760 flags data
Apr 14 02:05:01 xps kernel: BTRFS info (device dm-3): found 4 extents
Apr 14 02:05:01 xps kernel: BTRFS info (device dm-3): found 4 extents
Apr 14 02:05:01 xps kernel: BTRFS info (device dm-3): relocating block group 56870567936 flags data
Apr 14 02:05:01 xps kernel: BTRFS info (device dm-3): found 3 extents
Apr 14 02:05:02 xps kernel: BTRFS info (device dm-3): found 3 extents
Apr 14 02:05:02 xps kernel: BTRFS info (device dm-3): relocating block group 55796826112 flags data
Apr 14 02:05:02 xps kernel: BTRFS info (device dm-3): found 4 extents
Apr 14 02:05:02 xps kernel: BTRFS info (device dm-3): found 4 extents
Apr 14 02:05:02 xps kernel: BTRFS info (device dm-3): relocating block group 54723084288 flags data
Apr 14 02:05:02 xps kernel: BTRFS info (device dm-3): found 7 extents
Apr 14 02:05:02 xps kernel: BTRFS info (device dm-3): found 7 extents
Apr 14 02:05:02 xps kernel: BTRFS info (device dm-3): relocating block group 53649342464 flags data
Apr 14 02:05:02 xps kernel: BTRFS info (device dm-3): found 8 extents
Apr 14 02:05:02 xps kernel: BTRFS info (device dm-3): found 8 extents
Apr 14 02:05:02 xps kernel: BTRFS info (device dm-3): relocating block group 52575600640 flags data
Apr 14 02:05:02 xps kernel: BTRFS info (device dm-3): found 2 extents
Apr 14 02:05:03 xps kernel: BTRFS info (device dm-3): found 2 extents
Apr 14 02:05:03 xps kernel: BTRFS info (device dm-3): relocating block group 51501858816 flags data
Apr 14 02:05:03 xps kernel: BTRFS info (device dm-3): found 4 extents
Apr 14 02:05:03 xps kernel: BTRFS info (device dm-3): found 4 extents
Apr 14 02:05:03 xps kernel: BTRFS info (device dm-3): relocating block group 50428116992 flags data
Apr 14 02:05:03 xps kernel: BTRFS info (device dm-3): found 3 extents
Apr 14 02:05:03 xps kernel: BTRFS info (device dm-3): found 3 extents
Apr 14 02:05:03 xps kernel: BTRFS info (device dm-3): relocating block group 49354375168 flags data
Apr 14 02:05:03 xps kernel: BTRFS info (device dm-3): found 7 extents
Apr 14 02:05:03 xps kernel: BTRFS info (device dm-3): found 7 extents
Apr 14 02:05:03 xps kernel: BTRFS info (device dm-3): relocating block group 48280633344 flags data
Apr 14 02:05:03 xps kernel: BTRFS info (device dm-3): found 7 extents
Apr 14 02:05:04 xps kernel: BTRFS info (device dm-3): found 7 extents
Apr 14 02:05:04 xps kernel: BTRFS info (device dm-3): relocating block group 47206891520 flags data
Apr 14 02:05:04 xps kernel: BTRFS info (device dm-3): found 7 extents
Apr 14 02:05:04 xps kernel: BTRFS info (device dm-3): found 7 extents
Apr 14 02:05:04 xps kernel: BTRFS info (device dm-3): relocating block group 46133149696 flags data
Apr 14 02:05:04 xps kernel: BTRFS info (device dm-3): found 8 extents
Apr 14 02:05:04 xps kernel: BTRFS info (device dm-3): found 8 extents
Apr 14 02:05:04 xps kernel: BTRFS info (device dm-3): relocating block group 45059407872 flags data
Apr 14 02:05:04 xps kernel: BTRFS info (device dm-3): found 7 extents
Apr 14 02:05:05 xps kernel: BTRFS info (device dm-3): found 7 extents
Apr 17 22:00:37 xps kernel: BTRFS: device label root devid 1 transid 186700 /dev/dm-1
Apr 17 22:00:37 xps kernel: BTRFS: device label home devid 1 transid 269843 /dev/dm-3
Apr 17 22:00:37 xps kernel: BTRFS info (device dm-1): enabling auto defrag
Apr 17 22:00:37 xps kernel: BTRFS info (device dm-1): using free space tree
Apr 17 22:00:37 xps kernel: BTRFS info (device dm-1): has skinny extents
Apr 17 22:00:37 xps kernel: BTRFS info (device dm-1): using free space tree
Apr 17 22:00:38 xps kernel: BTRFS info (device dm-3): enabling auto defrag
Apr 17 22:00:38 xps kernel: BTRFS info (device dm-3): using free space tree
Apr 17 22:00:38 xps kernel: BTRFS info (device dm-3): has skinny extents
Apr 21 02:00:00 xps kernel: BTRFS info (device dm-1): relocating block group 31100764160 flags data
Apr 21 02:00:00 xps kernel: BTRFS info (device dm-1): found 2 extents
Apr 21 02:00:00 xps kernel: BTRFS info (device dm-1): found 2 extents
Apr 21 02:00:00 xps kernel: BTRFS info (device dm-1): relocating block group 30832328704 flags metadata|dup
Apr 21 02:00:01 xps kernel: BTRFS info (device dm-1): found 1104 extents
Apr 21 02:00:01 xps kernel: BTRFS info (device dm-1): found 188 extents
Apr 21 02:00:01 xps kernel: BTRFS info (device dm-1): found 188 extents
Apr 21 02:00:01 xps kernel: BTRFS info (device dm-1): found 188 extents
Apr 21 02:00:01 xps kernel: BTRFS info (device dm-1): relocating block group 30798774272 flags system|dup
Apr 21 02:00:01 xps kernel: BTRFS info (device dm-1): found 1 extents
Apr 21 02:05:00 xps kernel: BTRFS info (device dm-3): relocating block group 68815945728 flags data
Apr 21 02:05:00 xps kernel: BTRFS info (device dm-3): found 18 extents
Apr 21 02:05:00 xps kernel: BTRFS info (device dm-3): found 18 extents
Apr 21 02:05:00 xps kernel: BTRFS info (device dm-3): relocating block group 67742203904 flags metadata|dup
Apr 21 02:05:01 xps kernel: BTRFS: error (device dm-3) in merge_reloc_roots:2465: errno=-117 unknown
Apr 21 02:05:01 xps kernel: BTRFS info (device dm-3): forced readonly
Apr 21 02:05:11 xps kernel: BTRFS error (device dm-3): pending csums is 13107200

--MP_/RrBy2fgvkLkRyZKLMJIaSe0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=pc-data-original-check

# btrfs check --readonly /dev/disk/by-uuid/011912ff-8375-4fd0-8568-715cd28c2b8b
Checking filesystem on /dev/disk/by-uuid/011912ff-8375-4fd0-8568-715cd28c2b8b
UUID: 011912ff-8375-4fd0-8568-715cd28c2b8b
checking extents
checking free space tree
checking fs roots
checking csums
checking root refs
found 1023097102336 bytes used, no error found
total csum bytes: 995795540
total tree bytes: 1777254400
total fs tree bytes: 499777536
total extent tree bytes: 156712960
btree space waste bytes: 206534832
file data blocks allocated: 2580921212928
 referenced 1103042093056

--MP_/RrBy2fgvkLkRyZKLMJIaSe0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=pc-data-lowmem-check

# btrfs check --mode lowmem --readonly /dev/disk/by-uuid/011912ff-8375-4fd0-8568-715cd28c2b8b                                                                                         [18/6001]
Checking filesystem on /dev/disk/by-uuid/011912ff-8375-4fd0-8568-715cd28c2b8b
UUID: 011912ff-8375-4fd0-8568-715cd28c2b8b
checking extents
ERROR: extent[1211914780672, 16777216] referencer count mismatch (root: 2073, owner: 236200, offset: 33554432) wanted: 17, have: 18
ERROR: extent[1623008329728, 16777216] referencer count mismatch (root: 2073, owner: 241424, offset: 83886080) wanted: 12, have: 17
ERROR: extent[1636104806400, 16777216] referencer count mismatch (root: 2073, owner: 195667, offset: 117440512) wanted: 13, have: 14
ERROR: extent[1639128367104, 16777216] referencer count mismatch (root: 2073, owner: 197430, offset: 0) wanted: 13, have: 17
ERROR: extent[1689763446784, 16777216] referencer count mismatch (root: 2073, owner: 246255, offset: 67108864) wanted: 4, have: 17
ERROR: extent[1811447328768, 16777216] referencer count mismatch (root: 2073, owner: 253089, offset: 33554432) wanted: 15, have: 16
ERROR: extent[1853376790528, 16777216] referencer count mismatch (root: 2073, owner: 265031, offset: 117440512) wanted: 4, have: 5
ERROR: extent[1864968953856, 16777216] referencer count mismatch (root: 2073, owner: 271372, offset: 100663296) wanted: 12, have: 15
ERROR: extent[1865509302272, 16777216] referencer count mismatch (root: 2073, owner: 271480, offset: 0) wanted: 15, have: 19
ERROR: extent[1873773236224, 16777216] referencer count mismatch (root: 260, owner: 28919, offset: 33554432) wanted: 1, have: 2
ERROR: extent[1875367809024, 16777216] referencer count mismatch (root: 2073, owner: 275001, offset: 0) wanted: 12, have: 15
ERROR: extent[2060846788608, 134217728] referencer count mismatch (root: 263, owner: 265, offset: 50054324224) wanted: 31, have: 111
ERROR: extent[2080751099904, 134217728] referencer count mismatch (root: 263, owner: 265, offset: 32112349184) wanted: 2, have: 12
ERROR: extent[2094597668864, 186949632] referencer count mismatch (root: 259, owner: 33786, offset: 0) wanted: 27, have: 69
ERROR: errors found in extent allocation tree or chunk allocation
checking free space tree
checking fs roots
checking csums
checking root refs
found 1023097102336 bytes used, error(s) found
total csum bytes: 995795540
total tree bytes: 1976434688
total fs tree bytes: 698957824
total extent tree bytes: 156712960
btree space waste bytes: 219547602
file data blocks allocated: 2849277431808
 referenced 1426447798272

--MP_/RrBy2fgvkLkRyZKLMJIaSe0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=laptop-home-original-check

WARNING: filesystem mounted, continuing because of --force
checking extents
checking free space tree
checking fs roots
checking csums
checking root refs
Checking filesystem on /dev/xps/home
UUID: 4b4b80dc-e2e3-4d76-96ae-02d42879771d
found 24599171072 bytes used, no error found
total csum bytes: 23610896
total tree bytes: 405340160
total fs tree bytes: 357548032
total extent tree bytes: 18857984
btree space waste bytes: 79738263
file data blocks allocated: 38386794496
 referenced 38672330752

--MP_/RrBy2fgvkLkRyZKLMJIaSe0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=laptop-home-lowmem-check

WARNING: filesystem mounted, continuing because of --force
checking extents
checking free space tree
checking fs roots
ERROR: root 5 DIR INODE[791126] shouldn't have more than one link(0)
ERROR: errors found in fs roots
Checking filesystem on /dev/xps/home
UUID: 4b4b80dc-e2e3-4d76-96ae-02d42879771d
found 24599171072 bytes used, error(s) found
total csum bytes: 23610896
total tree bytes: 353976320
total fs tree bytes: 306184192
total extent tree bytes: 18857984
btree space waste bytes: 66493351
file data blocks allocated: 24513560576
 referenced 24935272448

--MP_/RrBy2fgvkLkRyZKLMJIaSe0--
