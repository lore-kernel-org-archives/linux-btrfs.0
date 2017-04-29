Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:65359 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1166372AbdD2IhY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Apr 2017 04:37:24 -0400
Received: from jan-latitude-e6510.localnet ([79.238.220.2]) by mail.gmx.com
 (mrgmx102 [212.227.17.168]) with ESMTPSA (Nemesis) id
 0MGoU1-1dHsQ72DCb-00DVj5 for <linux-btrfs@vger.kernel.org>; Sat, 29 Apr 2017
 10:37:22 +0200
From: Jan =?ISO-8859-1?Q?K=F6ster?= <jan.koester@gmx.net>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs check bug
Date: Sat, 29 Apr 2017 10:37:15 +0200
Message-ID: <10231431.b8s2GCdD3Q@jan-latitude-e6510>
In-Reply-To: <trinity-726bddc0-9890-43bb-97d9-65ba9d426e17-1492544073645@3capp-gmx-bs21>
References: <trinity-726bddc0-9890-43bb-97d9-65ba9d426e17-1492544073645@3capp-gmx-bs21>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Dienstag, 18. April 2017, 21:34:33 CEST schrieben Sie:
> Hi,
> 
> i have to try to create a new extent-tree after checksum error not solveable
> with srub or init-csum-tree. Now i got this failure output from btrfs
> --repair:
>  
> ERROR: errors found in extent allocation tree or chunk allocation
> Fixed 0 roots.
> checking free space cache
> checking fs roots
> root 5 missing its root dir, recreating
> btrfs unable to find ref byte nr 2279425310720 parent 0 root 5  owner 3
> offset 0 btrfs unable to find ref byte nr 2279422181376 parent 0 root 5
>  owner 2 offset 1 btrfs unable to find ref byte nr 2279422672896 parent 0
> root 5  owner 1 offset 1 btrfs unable to find ref byte nr 2279413121024
> parent 0 root 5  owner 0 offset 1 cmds-check.c:3370: check_inode_recs:
> BUG_ON `ret` triggered, value -17 btrfs(+0x50788)[0x5565c775b788]
> btrfs(+0x507db)[0x5565c775b7db]
> btrfs(+0x598e6)[0x5565c77648e6]
> btrfs(cmd_check+0x2bd4)[0x5565c7770185]
> btrfs(main+0x8b)[0x5565c771c0f5]
> /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf1)[0x7f76045232b1]
> btrfs(_start+0x2a)[0x5565c771bd7a]
> enabling repair mode
> Checking filesystem on /dev/disk/by-label/home
> UUID: 74454fdd-035b-4a3d-98ec-e38d3e7bcd6b
> cache and super generation don't match, space cache will be invalidated
> Failed to find [2278878576640, 168, 16384]
> Failed to find [2278878593024, 168, 16384]
> Failed to find [2278878609408, 168, 16384]
> Failed to find [2278878625792, 168, 16384]
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I have try a chunck recover to solve my problem after this i got this error 
with btrfs check:

root@dibsi:/# gdb --args btrfs check /dev/disk/by-label/home 
GNU gdb (Debian 7.12-6) 7.12.0.20161007-git
Copyright (C) 2016 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
<http://www.gnu.org/software/gdb/documentation/>.
For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from btrfs...done.
(gdb) r
Starting program: /usr/local/bin/btrfs check /dev/disk/by-label/home
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
Checking filesystem on /dev/disk/by-label/home
UUID: 74454fdd-035b-4a3d-98ec-e38d3e7bcd6b
checking extents
parent transid verify failed on 2278878494720 wanted 1961093 found 1961096
Ignoring transid failure

Program received signal SIGSEGV, Segmentation fault.
__memcpy_ssse3 () at ../sysdeps/x86_64/multiarch/memcpy-ssse3.S:130
130     ../sysdeps/x86_64/multiarch/memcpy-ssse3.S: Datei oder Verzeichnis 
nicht gefunden.
(gdb) bt
#0  __memcpy_ssse3 () at ../sysdeps/x86_64/multiarch/memcpy-ssse3.S:130
#1  0x000055555557e4ce in memcpy (__len=439, __src=<optimized out>, 
__dest=0x5555558641c0)
    at /usr/include/x86_64-linux-gnu/bits/string3.h:53
#2  read_extent_buffer (eb=eb@entry=0x5555558292e0, 
dst=dst@entry=0x7fffffffe3f0, start=<optimized out>, 
    len=len@entry=439) at extent_io.c:863
#3  0x00005555555b31e6 in check_chunks_and_extents 
(root=root@entry=0x5555558641c0) at cmds-check.c:9881
#4  0x00005555555b7240 in cmd_check (argc=<optimized out>, argv=<optimized 
out>) at cmds-check.c:12977
#5  0x00005555555650f5 in main (argc=2, argv=0x7fffffffec80) at btrfs.c:246


