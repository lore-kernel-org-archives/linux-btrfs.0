From: Zach Carter <z.carter@f5.com>
Subject: BUG: btrfsck segfaults on regular file
Date: Mon, 19 Jan 2009 10:16:34 -0800
Message-ID: <200901191016.34941.z.carter@f5.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We should probably just get an informative error message here, not a segfault.

Also, I got the same segfault when running "btrfsck -h" (it was looking for a 
file named "-h".  I'd be happy to contribute a getopts patch, if that is 
desired.

-Zach

[zcarter@nudj btrfs-progs-unstable]$ touch foo
[zcarter@nudj btrfs-progs-unstable]$ ./btrfsck ./foo
No valid Btrfs found on ./foo
Segmentation fault
[zcarter@nudj btrfs-progs-unstable]$ gdb ./btrfsck
GNU gdb Fedora (6.8-29.fc10)
Copyright (C) 2008 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-redhat-linux-gnu"...
(gdb) run ./foo
Starting program: /opt/src/btrfs-progs-unstable/btrfsck ./foo
No valid Btrfs found on ./foo

Program received signal SIGSEGV, Segmentation fault.
check_extents (root=0x0) at btrfsck.c:2006
2006		add_root_to_pending(root->fs_info->tree_root->node, bits, bits_nr,
(gdb) 

