Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:62320 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751755AbdKDKzZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Nov 2017 06:55:25 -0400
Received: from localhost ([93.232.15.98]) by mrelayeu.kundenserver.de
 (mreue005 [212.227.15.129]) with ESMTPSA (Nemesis) id
 0MJYJr-1e90Qi1y0Z-0037Hx for <linux-btrfs@vger.kernel.org>; Sat, 04 Nov 2017
 11:55:23 +0100
To: linux-btrfs@vger.kernel.org
From: Lars Altenhain <lars@altenhain.de>
Subject: btrfs-progs crash with segfault on broken filesystem
Message-ID: <09e4e163-bbed-241e-d26b-756f617d3a59@altenhain.de>
Date: Sat, 4 Nov 2017 11:55:18 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a broken btrfs filesystem, which would not mount (even with -o
ro,recovery) and I also can't copy any of the data using "btrfs rescue"
because the btrfs tool crashes with a segfault. The system is running
openSUSE Leap 42.3 with kernel 4.13.3 and I used the latest btrfs-progs
compiled from the master branch.

This is the output from dmesg when trying to mount the filesystem

[62168.092250] BTRFS info (device dm-11): trying to use backup root at
mount time
[62168.092252] BTRFS info (device dm-11): disk space caching is enabled
[62168.092254] BTRFS info (device dm-11): has skinny extents
[62168.234903] BTRFS error (device dm-11): parent transid verify failed
on 12074580082688 wanted 343981 found 343917
[62168.249432] BTRFS error (device dm-11): parent transid verify failed
on 12074580082688 wanted 343981 found 343917
[62168.261386] BTRFS error (device dm-11): failed to read chunk tree: -5
[62168.318513] BTRFS error (device dm-11): open_ctree failed

Here is the output of "btrfs restore /dev/mapper/DATA_CRYPT /tmp/"
running under gdb:

GNU gdb (GDB; openSUSE Leap 42.3) 8.0.1
Copyright (C) 2017 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later
<http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-suse-linux".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://bugs.opensuse.org/>.
Find the GDB manual and other documentation resources online at:
<http://www.gnu.org/software/gdb/documentation/>.
For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from ./btrfs...done.
(gdb) run
Starting program: /root/src/btrfs-progs/btrfs restore
/dev/mapper/DATA_CRYPT /tmp/
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib64/libthread_db.so.1".
parent transid verify failed on 12074580082688 wanted 343981 found 343917
parent transid verify failed on 12074580082688 wanted 343981 found 343917
parent transid verify failed on 12074580082688 wanted 343981 found 343917
parent transid verify failed on 12074580082688 wanted 343981 found 343917
Ignoring transid failure

Program received signal SIGSEGV, Segmentation fault.
0x00000000004293e1 in btrfs_device_id (s=0x550ec065, eb=0x847eb0) at
ctree.h:1448
1448    BTRFS_SETGET_FUNCS(device_id, struct btrfs_dev_item, devid, 64);
(gdb) macro expand BTRFS_SETGET_FUNCS(device_id, struct btrfs_dev_item,
devid, 64)
expands to: static inline u64 btrfs_device_id(const struct extent_buffer
*eb, const struct btrfs_dev_item *s) { unsigned long offset = (unsigned
long)s; const struct btrfs_dev_item *p = (struct btrfs_dev_item *)
(eb->data + offset); return (( u64)(__le64)(((const struct __una_u64
*)(&p->devid))->x)); } static inline void btrfs_set_device_id(struct
extent_buffer *eb, struct btrfs_dev_item *s, u64 val) { unsigned long
offset = (unsigned long)s; struct btrfs_dev_item *p = (struct
btrfs_dev_item *) (eb->data + offset); (((struct __una_u64
*)(&p->devid))->x = (( __le64)(u64)(val))); }

I also tried the the offline_scrub branch and then running "btrfs scrub
start --offline -r /dev/mapper/DATA_CRYPT" and this gets the segfault at
the same BTRFS_SETGET_FUNCS(device_id, struct btrfs_dev_item, devid, 64)
line in ctree.h


Best regards,

Lars Altenhain
