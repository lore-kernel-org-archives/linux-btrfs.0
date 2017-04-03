Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.render-wahnsinn.de ([188.40.36.198]:39454 "EHLO
        mail.render-wahnsinn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752393AbdDCKVy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Apr 2017 06:21:54 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.render-wahnsinn.de (Postfix) with ESMTP id 9AAD322641C
        for <linux-btrfs@vger.kernel.org>; Mon,  3 Apr 2017 12:11:01 +0200 (CEST)
Received: from mail.render-wahnsinn.de ([127.0.0.1])
        by localhost (mail.render-wahnsinn.de [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id Y9w1ejAeO8ER for <linux-btrfs@vger.kernel.org>;
        Mon,  3 Apr 2017 12:10:59 +0200 (CEST)
Received: from [192.168.192.246] (ip-109-91-126-168.hsi12.unitymediagroup.de [109.91.126.168])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.render-wahnsinn.de (Postfix) with ESMTPSA id B25EF225201
        for <linux-btrfs@vger.kernel.org>; Mon,  3 Apr 2017 12:10:59 +0200 (CEST)
To: linux-btrfs@vger.kernel.org
From: Robert Krig <robert.krig@render-wahnsinn.de>
Subject: Need some help: "BTRFS critical (device sda): corrupt leaf, slot
 offset bad: block"
Message-ID: <635a5ca8-9fa5-6cd4-21b5-97f9f3db93d3@render-wahnsinn.de>
Date: Mon, 3 Apr 2017 12:11:57 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi guys, I seem to have run into a spot of trouble with my btrfs partition.

I've got 4 x 8TB in a RAID1 BTRFS configuration.

I'm running Debian Jessie 64 Bit, 4.9.0-0.bpo.2-amd64 kernel. Btrfs
progs version v4.7.3

Server has 8GB of Ram.


I was running duperemove using a hashfile, which seemed to have run out
space and aborted. Then I tried a balance operation, with -dusage
progressively set to 0 1 5 15 30 50, which then aborted, I presume that
this caused the fs to mount readonly. I only noticed it somewhat later.

I've since rebooted, and I can mount the filesystem OK, but after some
time (I presume caused by reads or writes) it once again switches to
readonly.

I tried unmounting/remounting again and running a scrub, but the scrub
aborts after some time.


Here is the output from the kernel when the partition crashes:

Apr 03 11:32:57 atlas kernel: BTRFS info (device sda): The free space
cache file (37732863967232) is invalid. skip it
Apr 03 11:33:46 atlas kernel: BTRFS critical (device sda): corrupt leaf,
slot offset bad: block=38666170826752, root=1, slot=157
Apr 03 11:33:46 atlas kernel: ------------[ cut here ]------------
Apr 03 11:33:46 atlas kernel: WARNING: CPU: 0 PID: 17810 at
/home/zumbi/linux-4.9.13/fs/btrfs/extent-tree.c:6961
__btrfs_free_extent.isra.69+0x152/0xd60 [b
Apr 03 11:33:46 atlas kernel: BTRFS: Transaction aborted (error -5)
Apr 03 11:33:46 atlas kernel: Modules linked in: xt_multiport
iptable_filter ip_tables x_tables binfmt_misc cpufreq_userspace
cpufreq_conservative cpufreq_
Apr 03 11:33:46 atlas kernel:  ppdev lp parport autofs4 btrfs xor
raid6_pq dm_mod md_mod fuse sg sd_mod ahci libahci libata crc32c_intel
scsi_mod fan therm
Apr 03 11:33:46 atlas kernel: CPU: 0 PID: 17810 Comm: mc Not tainted
4.9.0-0.bpo.2-amd64 #1 Debian 4.9.13-1~bpo8+1
Apr 03 11:33:46 atlas kernel: Hardware name: ASUS All Series/H87M-E,
BIOS 0703 10/30/2013
Apr 03 11:33:46 atlas kernel:  0000000000000000 ffffffff97d29cd5
ffffb8ab4bb53a50 0000000000000000
Apr 03 11:33:46 atlas kernel:  ffffffff97a778a4 0000154c080b2000
ffffb8ab4bb53aa8 ffff8908ad438b40
Apr 03 11:33:46 atlas kernel:  ffff890951b96000 0000000000000000
ffff89086c3d4000 ffffffff97a7791f
Apr 03 11:33:46 atlas kernel: Call Trace:
Apr 03 11:33:46 atlas kernel:  [<ffffffff97d29cd5>] ? dump_stack+0x5c/0x77
Apr 03 11:33:46 atlas kernel:  [<ffffffff97a778a4>] ? __warn+0xc4/0xe0
Apr 03 11:33:46 atlas kernel:  [<ffffffff97a7791f>] ?
warn_slowpath_fmt+0x5f/0x80
Apr 03 11:33:46 atlas kernel:  [<ffffffffc05853e2>] ?
__btrfs_free_extent.isra.69+0x152/0xd60 [btrfs]
Apr 03 11:33:46 atlas kernel:  [<ffffffffc0589d06>] ?
__btrfs_run_delayed_refs+0x466/0x1360 [btrfs]
Apr 03 11:33:46 atlas kernel:  [<ffffffffc05ca364>] ?
set_extent_buffer_dirty+0x64/0xb0 [btrfs]
Apr 03 11:33:46 atlas kernel:  [<ffffffffc058dacf>] ?
btrfs_run_delayed_refs+0x8f/0x2b0 [btrfs]
Apr 03 11:33:46 atlas kernel:  [<ffffffffc05a314f>] ?
btrfs_should_end_transaction+0x3f/0x60 [btrfs]
Apr 03 11:33:46 atlas kernel:  [<ffffffffc05b00fa>] ?
btrfs_truncate_inode_items+0x63a/0xde0 [btrfs]
Apr 03 11:33:46 atlas kernel:  [<ffffffffc05b1852>] ?
btrfs_evict_inode+0x4a2/0x5f0 [btrfs]
Apr 03 11:33:46 atlas kernel:  [<ffffffff97c1fa06>] ? evict+0xb6/0x180
Apr 03 11:33:46 atlas kernel:  [<ffffffff97c13d98>] ?
do_unlinkat+0x148/0x300
Apr 03 11:33:46 atlas kernel:  [<ffffffff97ffb3fb>] ?
system_call_fast_compare_end+0xc/0x9b
Apr 03 11:33:46 atlas kernel: ---[ end trace 2a45c2819ff7b785 ]---
Apr 03 11:33:46 atlas kernel: BTRFS: error (device sda) in
__btrfs_free_extent:6961: errno=-5 IO failure
Apr 03 11:33:46 atlas kernel: BTRFS info (device sda): forced readonly
Apr 03 11:33:46 atlas kernel: BTRFS: error (device sda) in
btrfs_run_delayed_refs:2967: errno=-5 IO failure
Apr 03 11:33:50 atlas kernel: BTRFS warning (device sda): failed setting
block group ro, ret=-30
Apr 03 11:33:50 atlas kernel: BTRFS warning (device sda): failed setting
block group ro, ret=-30
Apr 03 11:33:52 atlas kernel: BTRFS warning (device sda): failed setting
block group ro, ret=-30
Apr 03 11:33:53 atlas kernel: BTRFS warning (device sda): Skipping
commit of aborted transaction.
Apr 03 11:33:53 atlas kernel: BTRFS: error (device sda) in
cleanup_transaction:1850: errno=-5 IO failure
Apr 03 11:33:53 atlas kernel: BTRFS info (device sda): delayed_refs has
NO entry
Apr 03 11:33:54 atlas kernel: BTRFS warning (device sda): failed setting
block group ro, ret=-30



I tried running a btrfs-debug-tree -b 38666170826752 /dev/sda

btrfs-progs
v4.7.3                                                                                                                                        

leaf 38666170826752 items 199 free space 1506 generation 1248226 owner
2                                                                                  

fs uuid
8c4f8e26-3442-463f-ad8a-668dfef02593                                                                                                              

chunk uuid
1f04f64e-0ec8-4b39-83d9-a2df75179d3e                                                                                                           

        item 0 key (23416295448576 EXTENT_ITEM 36864) itemoff 16230
itemsize
53                                                                           

                extent refs 1 gen 671397 flags
DATA                                                                                                       

                extent data backref root 5 objectid 4959957 offset 0
count
1                                                                              

        item 1 key (23416295485440 EXTENT_ITEM 8192) itemoff 16177
itemsize
53                                                                            

                extent refs 1 gen 972749 flags
DATA                                                                                                       

                extent data backref root 5 objectid 7328099 offset 0
count
1                                                                              

        item 2 key (23416295493632 EXTENT_ITEM 12288) itemoff 16124
itemsize
53                                                                           

                extent refs 1 gen 797708 flags
DATA                                                                                                       

                extent data backref root 5 objectid 5842103 offset
1966080 count
1                                                                        
        item 3 key (23416295505920 EXTENT_ITEM 8192) itemoff 16071
itemsize
53                                                                            

                extent refs 1 gen 1244513 flags
DATA                                                                                                      

                extent data backref root 44107 objectid 28528 offset
974848 count
1                                                                       
        item 4 key (23416295514112 EXTENT_ITEM 8192) itemoff 16034
itemsize
37                                                                            

                extent refs 1 gen 625327 flags
DATA                                                                                                       

                shared data backref parent 38666872045568 count
1                                                                                         

        item 5 key (23416295522304 EXTENT_ITEM 16384) itemoff 15997
itemsize
37                                                                           

                extent refs 1 gen 625327 flags
DATA                                                                                                       

                shared data backref parent 38666872045568 count
1                                                                                         

        item 6 key (23416295538688 EXTENT_ITEM 49152) itemoff 15944
itemsize
53                                                                           

                extent refs 1 gen 585321 flags
DATA                                                                                                       

                extent data backref root 5 objectid 4742401 offset
393216 count
1                                                                         
        item 7 key (23416295587840 EXTENT_ITEM 8192) itemoff 15907
itemsize
37                                                                            

                extent refs 1 gen 625327 flags
DATA                                                                                                       

                shared data backref parent 38666872045568 count
1                 

this goes on and on.  I can provide the entire output if thats helpful.



Any ideas on what I could do to fix the partition? Is it fixable, or is
it a lost cause?

Thanks guys.


