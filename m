Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:62065 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752476AbcKLJ3C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 12 Nov 2016 04:29:02 -0500
Received: from dibsi.localnet ([79.238.194.104]) by mail.gmx.com (mrgmx102
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0LtDpH-1cpBYZ18WJ-012pyt for
 <linux-btrfs@vger.kernel.org>; Sat, 12 Nov 2016 10:28:56 +0100
From: Jan Koester <jan.koester@gmx.net>
To: linux-btrfs@vger.kernel.org
Subject: chunk recover segfault
Date: Sat, 12 Nov 2016 10:28:55 +0100
Message-ID: <1648986.7uRE55pA1A@dibsi>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

got segault if i run rescue chunk-recover.

My Kernel:
Linux dibsi 4.9.0-040900rc2-generic #201610232131 SMP Mon Oct 24 01:32:49 UTC 
2016 x86_64 x86_64 x86_64 GNU/Linux

btrfs Progs:
btrfs-progs v4.8.3

gdb ouput btrfs rescue chunk-recover:
Starting program: /home/jan/btrfs-progs/btrfs rescue chunk-recover /dev/disk/
by-uuid/73d4dc77-6ff3-412f-9b0a-0d11458faf32
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
[New Thread 0x7ffff6f6e700 (LWP 29108)]
[New Thread 0x7fffeffff700 (LWP 29109)]
[New Thread 0x7ffff676d700 (LWP 29110)]
[New Thread 0x7ffff5f6c700 (LWP 29111)]
[New Thread 0x7ffff576b700 (LWP 29112)]
Scanning: 938721280 in dev0, 959299584 in dev1, 845529088 in dev2, 913293312 
in dev3, 962314240 in dev4                
Thread 6 "btrfs" received signal SIGSEGV, Segmentation fault.
[Switching to Thread 0x7ffff576b700 (LWP 29112)]
btrfs_new_chunk_record (leaf=leaf@entry=0x7fffd80008c0, 
key=key@entry=0x7ffff576ac90, slot=slot@entry=11)
    at cmds-check.c:5126
5126                    rec->stripes[i].devid =

dmesg output:
btrfs[29091]: segfault at 7f229c022000 ip 0000000000427d41 sp 00007f22ab7fdc10 
error 4 in btrfs[400000+a1000]
