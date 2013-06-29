Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:61463 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab3F2HzO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Jun 2013 03:55:14 -0400
Received: by mail-la0-f47.google.com with SMTP id fe20so2840150lab.6
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Jun 2013 00:55:13 -0700 (PDT)
Received: from ?IPv6:2001:470:28:50b:8e89:a5ff:fec1:1ac2? ([2001:470:28:50b:8e89:a5ff:fec1:1ac2])
        by mx.google.com with ESMTPSA id p7sm3718876lbi.15.2013.06.29.00.55.11
        for <linux-btrfs@vger.kernel.org>
        (version=SSLv3 cipher=RC4-SHA bits=128/128);
        Sat, 29 Jun 2013 00:55:12 -0700 (PDT)
Message-ID: <1372492506.3088.0.camel@Waves.darkmere>
Subject: raid 10 corruption from single drive failure
From: "D. Spindel" <spider@skuggor.se>
To: linux-btrfs@vger.kernel.org
Date: Sat, 29 Jun 2013 09:55:06 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi,
  I'm evaluating btrfs for a future deployment, and managed to 
(repeatedly
) get btrfs to the state where the system can't mount, can't fsck and 
can't
recover.


The test setup is pretty small, 6 devices of various size:

  butter-1.5GA vg_dolt -wi-a----
1.50g
  butter-1.5GB vg_dolt -wi-a----
1.50g
  butter-2GA vg_dolt -wi-a----
2.00g
  butter-2GB vg_dolt -wi-a----
2.00g
  butter-3GA vg_dolt -wi-a----
3.00g
  butter-3GB vg_dolt -wi-a----
3.00g


Created an btrfs volume:
mkfs.btrfs -d raid10 -m raid1 /dev/mapper/vg_dolt-butter--1.5GA
/dev/mapper/vg_dolt-butter--1.5GA /dev/mapper/vg_dolt-butter--2GA
/dev/mapper/vg_dolt-butter--2GB /dev/mapper/vg_dolt-butter--3GA
/dev/mapper/vg_dolt-butter--3GB


( Note how above it is mistyped, This is a 5 disk raid10. Where 1.5GA 
was
listed twice. )


--
mount it and fill it with files ( I downloaded parts of the fedora 
src.rpm
tree ).

unmount the partition

Zero one drive
dd if=/dev/zero of=/dev/vg_dolt/butter-3GB bs=1M skip=100

( It's sort of hard to fake a corrupt drive, this is a decent way of 
doing
it )

trying to mount it gives the following setup:
Jun 28 23:58:34 dolt kernel: [2815554.803082] device fsid
379e495a-9ba7-4485-ae74-6c8939f7b22e devid 3 transid 27
/dev/mapper/vg_dolt-butter--2GB
Jun 28 23:58:34 dolt kernel: [2815554.850211] btrfs: disk space caching 
is
enabled
Jun 28 23:58:34 dolt kernel: [2815554.850856] btrfs: failed to read 
chunk
tree on dm-6
Jun 28 23:58:34 dolt kernel: [2815554.856453] btrfs: open_ctree failed
Jun 28 23:58:44 dolt kernel: [2815565.475519] device fsid
379e495a-9ba7-4485-ae74-6c8939f7b22e devid 3 transid 27
/dev/mapper/vg_dolt-butter--2GB
Jun 28 23:58:44 dolt kernel: [2815565.476939] btrfs: enabling auto 
recovery
Jun 28 23:58:44 dolt kernel: [2815565.476944] btrfs: disk space caching 
is
enabled
Jun 28 23:58:44 dolt kernel: [2815565.477648] btrfs: failed to read 
chunk
tree on dm-6
Jun 28 23:58:44 dolt kernel: [2815565.486300] btrfs: open_ctree failed
Jun 28 23:58:52 dolt kernel: [2815573.522271] device fsid
379e495a-9ba7-4485-ae74-6c8939f7b22e devid 2 transid 27
/dev/mapper/vg_dolt-butter--2GA
Jun 28 23:58:52 dolt kernel: [2815573.536624] btrfs: enabling auto 
recovery
Jun 28 23:58:52 dolt kernel: [2815573.536628] btrfs: disk space caching 
is
enabled
Jun 28 23:58:52 dolt kernel: [2815573.537185] btrfs: failed to read 
chunk
tree on dm-6
Jun 28 23:58:52 dolt kernel: [2815573.542938] btrfs: open_ctree failed


[root@dolt mnt]# btrfsck /dev/vg_dolt/butter-2GA
failed to read /dev/sr0
failed to read /dev/sr0
warning, device 5 is missing
warning devid 5 not found already
checking extents
checking fs roots
checking root refs
Segmentation fault

[root@dolt mnt]# mount -o recovery,ro /dev/mapper/vg_dolt-butter--2GA
/mnt/test/
mount: wrong fs type, bad option, bad superblock on
/dev/mapper/vg_dolt-butter--2GA,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail or so
[root@dolt mnt]#

debuginfo-install btrfs-progs-0.20.rc1.20121017git91d9eec-3.fc18.x86_64


[root@dolt mnt]# gdb btrfsck /dev/vg_dolt/butter-2GA
GNU gdb (GDB) Fedora (7.5.1-38.fc18)
Copyright (C) 2012 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later 
<http://gnu.org/licenses/gpl.html
 >
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law. Type "show 
copying"
and "show warranty" for details.
This GDB was configured as "x86_64-redhat-linux-gnu".
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>...
Reading symbols from /usr/sbin/btrfsck...Reading symbols from
/usr/lib/debug/usr/sbin/btrfsck.debug...done.
done.
"/dev/vg_dolt/butter-2GA" is not a core dump: File format not recognized
(gdb) run /dev/vg_dolt/butter-2GA
Starting program: /usr/sbin/btrfsck /dev/vg_dolt/butter-2GA
failed to read /dev/sr0
failed to read /dev/sr0
warning, device 5 is missing
warning devid 5 not found already
checking extents
checking fs roots
checking root refs

Program received signal SIGSEGV, Segmentation fault.
__GI___libc_free (mem=0x8000000000) at malloc.c:2907
2907 if (chunk_is_mmapped(p)) /* release mmapped
memory. */
(gdb) bt full
#0 __GI___libc_free (mem=0x8000000000) at malloc.c:2907
        ar_ptr = <optimized out>
        p = <optimized out>
        hook = 0x0
#1 0x000000000040d429 in close_all_devices (fs_info=0x6323e0) at
disk-io.c:1088
        list = 0x631050
        next = 0x6300b0
        tmp = 0x630430
        device = 0x6300b0
#2 0x000000000040e3df in close_ctree (root=root@entry=0x6426e0) at
disk-io.c:1135
        ret = <optimized out>
        fs_info = 0x6323e0
        __PRETTY_FUNCTION__ = "close_ctree"
#3 0x0000000000401d8d in main (ac=<optimized out>, av=<optimized out>) 
at
btrfsck.c:3593
        root_cache = {root = {rb_node = 0x0, rotate_notify = 
0x423aad
<__libc_csu_init+93>}}
        root = <optimized out>
        info = <optimized out>
        trans = <optimized out>
        bytenr = <optimized out>
        ret = 0
        num = <optimized out>
        repair = <optimized out>
        option_index = 0
        init_csum_tree = <optimized out>
        rw = 0

---

Making this with all 6 devices from the beginning and btrfsck doesn't
segfault. But it also doesn't repair the system enough to make it
mountable. ( nether does -o recover, however -o degraded works, and 
files
are then accessible )


Regards,
   D.S.



