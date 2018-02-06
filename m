Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:40127 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752237AbeBFH4c (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Feb 2018 02:56:32 -0500
Received: by mail-wm0-f47.google.com with SMTP id v123so1870846wmd.5
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Feb 2018 23:56:32 -0800 (PST)
Received: from [192.168.1.175] (dslb-094-217-067-240.094.217.pools.vodafone-ip.de. [94.217.67.240])
        by smtp.gmail.com with ESMTPSA id d20sm7252099ede.16.2018.02.05.23.56.29
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Feb 2018 23:56:30 -0800 (PST)
To: linux-btrfs@vger.kernel.org
From: Ralph Gauges <ralphgauges@googlemail.com>
Subject: segmentation fault in btrfs tool v4.15
Message-ID: <10214501-3b8e-7f9b-11d6-14fb75da07a5@googlemail.com>
Date: Tue, 6 Feb 2018 08:56:28 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I recently started using the btrfs file system on my backup disk and 
until a power failure during a backup everything seemed to work well.
Due a power failure however, the file systems seems to have become 
corrupted and all trials to check or repair it so far have lead to a 
segmentation fault.

Normally I am using Ubuntu 17.10 and the btrfs version that goes along 
with it, but for testing purposes, I compiled my own version 
(btrfs-progs v4.15).
Unfortunately the segmentation fault is also present in this latest 
version. At the end of this email, you can see the output from btrfs 
when I try to check the partition as well as the backtrace from gdb. I 
hope that helps.

My system is running kernel 4.13.0-32-generic on x86_64.

If you need any additional information please contace me directly since 
I don't subscribe to the mailing list.

Sincerily

Ralph Gauges






(gdb) set args check /dev/sdf1
(gdb) run
Starting program: /home/gauges/Applications/bin/btrfs check /dev/sdf1
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
parent transid verify failed on 266195058688 wanted 1857 found 1864
parent transid verify failed on 266195058688 wanted 1857 found 1864
parent transid verify failed on 266195058688 wanted 1857 found 1864
parent transid verify failed on 266195058688 wanted 1857 found 1864
Ignoring transid failure
Checking filesystem on /dev/sdf1
UUID: 9ccb1eaa-a9ae-46f3-8885-fba4799d6e85
parent transid verify failed on 266196516864 wanted 1858 found 1864
parent transid verify failed on 266196516864 wanted 1858 found 1864
parent transid verify failed on 266196516864 wanted 1858 found 1864
parent transid verify failed on 266196516864 wanted 1858 found 1864
Ignoring transid failure
parent transid verify failed on 266196205568 wanted 1858 found 1864
parent transid verify failed on 266196205568 wanted 1858 found 1864
parent transid verify failed on 266196205568 wanted 1858 found 1864
parent transid verify failed on 266196205568 wanted 1858 found 1864
Ignoring transid failure

Program received signal SIGSEGV, Segmentation fault.
0x00005555555bf7a7 in btrfs_extent_flags (s=0xcc344065, 
eb=0x5555584acce0) at ctree.h:1694
1694    BTRFS_SETGET_FUNCS(extent_flags, struct btrfs_extent_item, 
flags, 64);
(gdb) bt
#0  0x00005555555bf7a7 in btrfs_extent_flags (s=0xcc344065, 
eb=0x5555584acce0) at ctree.h:1694
#1  build_roots_info_cache (info=0x555555821a00) at cmds-check.c:14285
#2  repair_root_items (info=0x555555821a00) at cmds-check.c:14450
#3  cmd_check (argc=<optimized out>, argv=<optimized out>) at 
cmds-check.c:14965
#4  0x0000555555566320 in main (argc=2, argv=0x7fffffffde30) at btrfs.c:302
(gdb)
