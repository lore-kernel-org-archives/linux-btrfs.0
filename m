Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:34215 "EHLO
	mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbbIAAIV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 20:08:21 -0400
Received: by qkct7 with SMTP id t7so23352084qkc.1
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2015 17:08:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOE4rSwiQxR16fSNtnaX5D5MaTcG3q+v__=qP4-m3So3fu_ksQ@mail.gmail.com>
References: <CAOE4rSwiQxR16fSNtnaX5D5MaTcG3q+v__=qP4-m3So3fu_ksQ@mail.gmail.com>
Date: Tue, 1 Sep 2015 03:08:20 +0300
Message-ID: <CAOE4rSwY0ZFAzRkRg-maU474FWaHo+TFb8JTG+a66rjVfOSmhg@mail.gmail.com>
Subject: Re: [BUG] kernel BUG at fs/btrfs/extent_io.c:2062 (v4.2.0-rc8)
From: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2015-08-31 18:14 GMT+00:00 Dāvis Mosāns <davispuh@gmail.com>:
> I'm getting kernel crash and complete system lockup when trying to access
> journal on two disk btrfs filesystem with data/metadata as RAID1.
>
> I can't get proper log because whole system hangs and even kdump fails,
> seems it doesn't start or I'm doing something wrong.
>
> Also because there are several call traces and they all get printed on
> screen within few seconds I can get photos only on few last ones.
> But I managed to get some low-quality blurry photos with 80 FPS
> recording.
>
> So from them I saw
>
> kernel BUG at fs/btrfs/extent_io.c:2062
> extent_io.c@2062.png => http://i.imgur.com/uuxOGIR.png
>
> kernel BUG at fs/btrfs/extent_io.c:2140
> extent_io.c@2140.png => http://i.imgur.com/j5xrt7w.png
>
> kernel BUG at fs/btrfs/extent_io.c:2338
> extent_io.c@2338_0.png => http://i.imgur.com/EosplAu.png
> extent_io.c@2338_1.png => http://i.imgur.com/rsE9qNT.png
>
> kernel BUG at fs/btrfs/volumes.c:5399
> volumes.c@5399_0.png => http://i.imgur.com/iV9zqAv.png
> volumes.c@5399_1.png => http://i.imgur.com/VCyr07R.png
>
>
> And better photos
>
> BUG: scheduling while atomic: kworker/u16
> scheduling_while_atomic_0.jpg => http://i.imgur.com/asHjcM9.jpg
> scheduling_while_atomic_1.jpg => http://i.imgur.com/OJSFDUx.jpg
> scheduling_while_atomic_2.jpg => http://i.imgur.com/0nHQin8.jpg
> scheduling_while_atomic_3.jpg => http://i.imgur.com/ZmzOh7f.jpg
>
> Watchdog detected hard LOCKUP on cpu
> watchdog_detected_hard_LOCKUP_0.jpg => http://i.imgur.com/6W4FlfI.jpg
> watchdog_detected_hard_LOCKUP_1.jpg => http://i.imgur.com/WxxGozJ.jpg
> watchdog_detected_hard_LOCKUP_2.jpg => http://i.imgur.com/0Mmifwf.jpg
>
> BUG: unable to handle kernel paging request
> unable_to_handle_kernel_paging_request.jpg => http://i.imgur.com/4Sz4v96.jpg
>
> BUG: unable to handle kernel
> unable_to_handle_kernel.jpg => http://i.imgur.com/T0x7K4a.jpg
>
>
> Weird is that it crashes only sometimes and when reading all files then
> it doesn't crash, but only when try to open journal with journalctl.
> Also btrfs scrub and balance finishes without any errors.
> Even btrfs check and check --repair completed successfully without
> finding anything to repair. Also this crash happened on v4.1.6 too and
> now I'll recompile v4.2 as it got released.
>
>
> I'm getting this crash since I decided to test how well Linux handles
> one disk loss on btrfs RAID1 (I just pulled one disk out), it kept
> working but there were some call traces and when I plugged it back
> in then btrfs failed to write to it and after few mins system froze but
> before that SMART test passed on that disk.
> Then I rebooted and ran scrub which fixed errors on that disk.
> Next I was trying to test other disk and for it executed
> echo 1 > /sys/block/sdf/device/delete
> which caused immediate system hang.
> And now this filesystem crashes kernel when I try to view journal.
> I think RAID1 should handle well such cases when one disk
> disappears or is corrupted but currently it doesn't work and
> crashes whole system.
>


I found that file which is causing kernel crash and most of time it
gives I/O error
/var/log/journal/873a5f55f2aa4b33b2568baca40e6a91/system@00051e80d8810e86-e5a1ec29d9167e9f.journal~:
Input/output error

but sometimes it causes instant system freeze
cat system@00051e80d8810e86-e5a1ec29d9167e9f.journal~ > /dev/null
<system freeze>

There's nothing in kernel logs when freeze happens.
Also any user who can read that file can cause kernel crash, nice DoS

Here's a btrfs-image from that filesystems /dev/sdb
https://drive.google.com/file/d/0B82_Tz1_6URAQmV5LTZHUmR4YXM/view?usp=sharing
sha256sum
88fb561b4a581319ae18c1f27b6ac108e9c08ff80954e192cb3201cc5d4c19ff raid1_sdb.img
size 142M

only difference for btrfs-image between disks
image from /dev/sdb  => image from /dev/sdf
0x00000400 2fc3d988 => 8c421133
0x000004c9 02 => 01
0x0000050b 7ed7472cd5d44f5e842ede789208dfd9 => 3ceab04840a3412da65cab36dba5c17e

mount options rw,noatime,compress=lzo,space_cache,autodefrag
and features
* big_metadata
* compress_lzo
* default_subvol
* extended_iref
* mixed_backref
* no_holes
* skinny_metadata

$ btrfs filesystem show
Label: 'RAID'  uuid: 247e6249-6de1-45cb-9dd0-fa8a654234bf
        Total devices 2 FS bytes used 16.38GiB
        devid    1 size 2.73TiB used 18.03GiB path /dev/sdb
        devid    2 size 2.73TiB used 18.03GiB path /dev/sdf

$ btrfs filesystem usage
Overall:
    Device size:                   5.46TiB
    Device allocated:             36.06GiB
    Device unallocated:            5.42TiB
    Device missing:                  0.00B
    Used:                         32.75GiB
    Free (estimated):              2.71TiB      (min: 2.71TiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:               48.00MiB      (used: 0.00B)

Data,RAID1: Size:17.00GiB, Used:16.24GiB
   /dev/sdb       17.00GiB
   /dev/sdf       17.00GiB

Metadata,RAID1: Size:1.00GiB, Used:136.64MiB
   /dev/sdb        1.00GiB
   /dev/sdf        1.00GiB

System,RAID1: Size:32.00MiB, Used:16.00KiB
   /dev/sdb       32.00MiB
   /dev/sdf       32.00MiB

Unallocated:
   /dev/sdb        2.71TiB
   /dev/sdf        2.71TiB


$ btrfs scrub start -B -d -R /dev/sdb
scrub device /dev/sdb (id 1) done
        scrub started at Mon Aug 31 20:58:45 2015 and finished after 00:01:29
        data_extents_scrubbed: 359177
        tree_extents_scrubbed: 8746
        data_bytes_scrubbed: 17442004992
        tree_bytes_scrubbed: 143294464
        read_errors: 0
        csum_errors: 0
        verify_errors: 0
        no_csum: 42403
        csum_discards: 100132
        super_errors: 0
        malloc_errors: 0
        uncorrectable_errors: 0
        unverified_errors: 0
        corrected_errors: 0
        last_physical: 21504196608

$ btrfs scrub start -B -d -R /dev/sdf
scrub device /dev/sdf (id 2) done
        scrub started at Mon Aug 31 21:18:33 2015 and finished after 00:01:31
        data_extents_scrubbed: 359177
        tree_extents_scrubbed: 8746
        data_bytes_scrubbed: 17442004992
        tree_bytes_scrubbed: 143294464
        read_errors: 0
        csum_errors: 0
        verify_errors: 0
        no_csum: 42403
        csum_discards: 100132
        super_errors: 0
        malloc_errors: 0
        uncorrectable_errors: 0
        unverified_errors: 0
        corrected_errors: 0
        last_physical: 21484273664

$ btrfs balance start -v
Dumping filters: flags 0x7, state 0x0, force is off
  DATA (flags 0x0): balancing
  METADATA (flags 0x0): balancing
  SYSTEM (flags 0x0): balancing
Done, had to relocate 19 out of 19 chunks

$ btrfs check --repair --check-data-csum /dev/sdb
enabling repair mode
Checking filesystem on /dev/sdb
UUID: 247e6249-6de1-45cb-9dd0-fa8a654234bf
checking extents
Fixed 0 roots.
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
checking csums
checking root refs
found 17581105170 bytes used err is 0
total csum bytes: 16863596
total tree bytes: 143294464
total fs tree bytes: 111984640
total extent tree bytes: 12009472
btree space waste bytes: 25424343
file data blocks allocated: 17710305280
 referenced 20970795008
btrfs-progs v4.1.2


$ btrfs check --repair --check-data-csum /dev/sdf
enabling repair mode
Checking filesystem on /dev/sdf
UUID: 247e6249-6de1-45cb-9dd0-fa8a654234bf
checking extents
Fixed 0 roots.
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
checking csums
checking root refs
found 17581105170 bytes used err is 0
total csum bytes: 16863596
total tree bytes: 143294464
total fs tree bytes: 111984640
total extent tree bytes: 12009472
btree space waste bytes: 25424343
file data blocks allocated: 17710305280
 referenced 20970795008
btrfs-progs v4.1.2


Seems btrfs-progs think everything is fine with filesystem even if
some files give I/O error or crash kernel on RAID1
