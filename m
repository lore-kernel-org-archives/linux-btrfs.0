From: Steven Pratt <slpratt@austin.ibm.com>
Subject: nodatacsum broken?
Date: Mon, 16 Nov 2009 10:22:59 -0600
Message-ID: <4B017C63.5000600@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Did we break the ability to run with -o nodatacsum somewhere along the 
way? I had not run just this option in a while (usually doing nodatacow 
which implies nodatacsum).  Just did a full run with just nodatacsum and 
it looks like we still did csums.

from proc/mounts:

/dev/ffsbdev1 on /mnt/ffsb1 type btrfs (rw,nodatacsum)

but profile:

samples % app name symbol name

1664460  15.3103  vmlinux-2.6.31-autokern1 copy_user_generic_unrolled
1514349  13.9295  vmlinux-2.6.31-autokern1 crc32c
606147    5.5756  vmlinux-2.6.31-autokern1 rb_get_reader_page
562936    5.1781  vmlinux-2.6.31-autokern1 mutex_spin_on_owner
433405    3.9866  vmlinux-2.6.31-autokern1 ring_buffer_consume


This was for a sequential read test on the unstable tree from 11-12.

Steve






