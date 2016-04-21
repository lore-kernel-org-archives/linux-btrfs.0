Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36769 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbcDUPJf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Apr 2016 11:09:35 -0400
Received: by mail-wm0-f48.google.com with SMTP id v188so248861062wme.1
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Apr 2016 08:09:34 -0700 (PDT)
Received: from [84.250.216.47] (dsl-kpobrasgw1-54fad8-47.dhcp.inet.fi. [84.250.216.47])
        by smtp.gmail.com with ESMTPSA id xt9sm3298186wjb.17.2016.04.21.08.09.32
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Apr 2016 08:09:33 -0700 (PDT)
To: linux-btrfs@vger.kernel.org
From: Jussi Kansanen <jussi.kansanen@gmail.com>
Subject: Raid5 replace disk problems
Message-ID: <5718ED2B.2090406@gmail.com>
Date: Thu, 21 Apr 2016 18:09:31 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have a 4x 2TB HDD raid5 array and one of the disks started going bad
(according to smart no read/write errors seen by btrfs), after replacing the
disk with a new one I ran "btrfs replace" which resulted in kernel crash about
0.5% done:


BTRFS info (device dm-10): dev_replace from <missing disk> (devid 4) to
/dev/mapper/bcrypt_sdj1 started

WARNING: CPU: 1 PID: 30627 at fs/btrfs/inode.c:9125
btrfs_destroy_inode+0x271/0x290()
Modules linked in: algif_skcipher af_alg evdev xt_tcpudp nf_conntrack_ipv4
nf_defrag_ipv4 xt_conntrack nf_conntrack x86_pkg_temp_thermal kvm_intel kvm
irqbypass ghash_clmulni_intel psmouse iptable_filter ip_tables x_tables fan
thermal battery processor button autofs4
CPU: 1 PID: 30627 Comm: umount Not tainted 4.5.0 #1
Hardware name: System manufacturer System Product Name/P8Z77-V LE PLUS, BIOS
0910 03/18/2014
0000000000000000 ffffffff813971f9 0000000000000000 ffffffff817f2b34
ffffffff8107ab78 ffff8800d55daa00 ffff8800cb990998 ffff880212d5b800
0000000000000000 ffff8801fcc0ff58 ffffffff812dbfc1 ffff8800d55daa00
Call Trace:
[<ffffffff813971f9>] ? dump_stack+0x46/0x5d
[<ffffffff8107ab78>] ? warn_slowpath_common+0x78/0xb0
[<ffffffff812dbfc1>] ? btrfs_destroy_inode+0x271/0x290
[<ffffffff812b69a2>] ? btrfs_put_block_group_cache+0x72/0xa0
[<ffffffff812c71d6>] ? close_ctree+0x146/0x330
[<ffffffff81154d9f>] ? generic_shutdown_super+0x5f/0xe0
[<ffffffff81155029>] ? kill_anon_super+0x9/0x10
[<ffffffff8129c5ed>] ? btrfs_kill_super+0xd/0x90
[<ffffffff8115534f>] ? deactivate_locked_super+0x2f/0x60
[<ffffffff8116f376>] ? cleanup_mnt+0x36/0x80
[<ffffffff81091f3c>] ? task_work_run+0x6c/0x90
[<ffffffff810011aa>] ? exit_to_usermode_loop+0x8a/0x90
[<ffffffff8167bce3>] ? int_ret_from_sys_call+0x25/0x8f
---[ end trace 6a7dec9450d45f9c ]---


Replace continues automatically after reboot but ends up using all of memory,
around every 6% of progress (8 hours) and crashes system:


BTRFS info (device dm-10): continuing dev_replace from <missing disk> (devid 4)
to /dev/mapper/bcrypt_sdj1 @0%
Apr 20 14:03:48 localhost kernel: BTRFS warning (device dm-4): devid 4 uuid
e02b8898-c6ce-4c95-956d-24217c470b8a is missing
Apr 20 14:03:52 localhost kernel: BTRFS info (device dm-4): continuing
dev_replace from <missing disk> (devid 4) to /dev/mapper/bcrypt_sdj1 @6%
Apr 20 22:38:41 localhost kernel: BTRFS warning (device dm-4): devid 4 uuid
e02b8898-c6ce-4c95-956d-24217c470b8a is missing
Apr 20 22:38:46 localhost kernel: BTRFS info (device dm-4): continuing
dev_replace from <missing disk> (devid 4) to /dev/mapper/bcrypt_sdj1 @12%
Apr 21 13:14:51 localhost kernel: BTRFS warning (device dm-4): devid 4 uuid
e02b8898-c6ce-4c95-956d-24217c470b8a is missing
Apr 21 13:14:55 localhost kernel: BTRFS info (device dm-4): continuing
dev_replace from <missing disk> (devid 4) to /dev/mapper/bcrypt_sdj1 @18%


The issue is related to "bio-1" using all of memory:

/proc/meminfo:

MemTotal:        8072852 kB
MemFree:          646108 kB
...
Slab:            6235188 kB
SReclaimable:      49320 kB
SUnreclaim:      6185868 kB

/proc/slabinfo:

# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab>
: tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs>
<num_slabs> <sharedavail>
bio-1             17588753 17588964    320   12    1 : tunables    0    0    0 :
slabdata 1465747 1465747      0


The replace operation is super slow (no other load) with avg. 3x20MB/s (old
disks) reads and 1.4MB/s write (new disk) with CFQ scheduler. Using deadline
schd. the performance is better with avg. 3x40MB/s reads and 4MB/s write (both
schds. with default queue/nr_requests).

Write speed seems slow but guess it possible if there's a lot random writes but
why is the difference between data read vs. written so large? According to
iostat replace reads 35 times more data than it writes to the new disk.


Info:

kernel 4.5 (now 4.5.2, no change)
btrfs-progs 4.5.1
dm-crypted partitions, 4k aligned
mount opts: defaults,noatime,compress=lzo
8GB RAM


btrfs fi usage /bstorage/
WARNING: RAID56 detected, not implemented
WARNING: RAID56 detected, not implemented
WARNING: RAID56 detected, not implemented
Overall:
    Device size:                   9.10TiB
    Device allocated:                0.00B
    Device unallocated:            9.10TiB
    Device missing:                1.82TiB
    Used:                            0.00B
    Free (estimated):                0.00B      (min: 8.00EiB)
    Data ratio:                       0.00
    Metadata ratio:                   0.00
    Global reserve:              512.00MiB      (used: 0.00B)

Data,RAID5: Size:1.52TiB, Used:1.46TiB
   /dev/mapper/bcrypt_sdg1       520.00GiB
   /dev/mapper/bcrypt_sdh1       520.00GiB
   /dev/mapper/bcrypt_sdi1       520.00GiB
   missing       520.00GiB

Metadata,RAID5: Size:4.03GiB, Used:1.96GiB
   /dev/mapper/bcrypt_sdg1         1.34GiB
   /dev/mapper/bcrypt_sdh1         1.34GiB
   /dev/mapper/bcrypt_sdi1         1.34GiB
   missing         1.34GiB

System,RAID5: Size:76.00MiB, Used:128.00KiB
   /dev/mapper/bcrypt_sdg1        36.00MiB
   /dev/mapper/bcrypt_sdh1        36.00MiB
   /dev/mapper/bcrypt_sdi1        36.00MiB
   missing         4.00MiB

Unallocated:
   /dev/mapper/bcrypt_sdg1         1.31TiB
   /dev/mapper/bcrypt_sdh1         1.31TiB
   /dev/mapper/bcrypt_sdi1         1.31TiB
   /dev/mapper/bcrypt_sdj1         1.82TiB
   missing         1.31TiB


btrfs fi show /bstorage/
Label: 'btrfs_bstorage'  uuid: 3861e35a-43ef-4293-b2bf-f841c8bcb4e4
        Total devices 5 FS bytes used 1.47TiB
        devid    0 size 1.82TiB used 521.35GiB path /dev/mapper/bcrypt_sdj1
        devid    1 size 1.82TiB used 521.38GiB path /dev/mapper/bcrypt_sdg1
        devid    2 size 1.82TiB used 521.38GiB path /dev/mapper/bcrypt_sdh1
        devid    3 size 1.82TiB used 521.38GiB path /dev/mapper/bcrypt_sdi1
        *** Some devices missing


btrfs device stats /bstorage/
[/dev/mapper/bcrypt_sdj1].write_io_errs   0
[/dev/mapper/bcrypt_sdj1].read_io_errs    0
[/dev/mapper/bcrypt_sdj1].flush_io_errs   0
[/dev/mapper/bcrypt_sdj1].corruption_errs 0
[/dev/mapper/bcrypt_sdj1].generation_errs 0
[/dev/mapper/bcrypt_sdg1].write_io_errs   0
[/dev/mapper/bcrypt_sdg1].read_io_errs    0
[/dev/mapper/bcrypt_sdg1].flush_io_errs   0
[/dev/mapper/bcrypt_sdg1].corruption_errs 0
[/dev/mapper/bcrypt_sdg1].generation_errs 0
[/dev/mapper/bcrypt_sdh1].write_io_errs   0
[/dev/mapper/bcrypt_sdh1].read_io_errs    0
[/dev/mapper/bcrypt_sdh1].flush_io_errs   0
[/dev/mapper/bcrypt_sdh1].corruption_errs 0
[/dev/mapper/bcrypt_sdh1].generation_errs 0
[/dev/mapper/bcrypt_sdi1].write_io_errs   0
[/dev/mapper/bcrypt_sdi1].read_io_errs    0
[/dev/mapper/bcrypt_sdi1].flush_io_errs   0
[/dev/mapper/bcrypt_sdi1].corruption_errs 0
[/dev/mapper/bcrypt_sdi1].generation_errs 0
[(null)].write_io_errs   0
[(null)].read_io_errs    0
[(null)].flush_io_errs   0
[(null)].corruption_errs 0
[(null)].generation_errs 0


btrfs dev usage /bstorage/
/dev/mapper/bcrypt_sdg1, ID: 1
   Device size:             1.82TiB
   Data,RAID5:            520.00GiB
   Metadata,RAID5:          1.34GiB
   System,RAID5:            4.00MiB
   System,RAID5:           32.00MiB
   Unallocated:             1.31TiB

/dev/mapper/bcrypt_sdh1, ID: 2
   Device size:             1.82TiB
   Data,RAID5:            520.00GiB
   Metadata,RAID5:          1.34GiB
   System,RAID5:            4.00MiB
   System,RAID5:           32.00MiB
   Unallocated:             1.31TiB

/dev/mapper/bcrypt_sdi1, ID: 3
   Device size:             1.82TiB
   Data,RAID5:            520.00GiB
   Metadata,RAID5:          1.34GiB
   System,RAID5:            4.00MiB
   System,RAID5:           32.00MiB
   Unallocated:             1.31TiB

/dev/mapper/bcrypt_sdj1, ID: 0
   Device size:             1.82TiB
   Unallocated:             1.82TiB

missing, ID: 4
   Device size:               0.00B
   Data,RAID5:            520.00GiB
   Metadata,RAID5:          1.34GiB
   System,RAID5:            4.00MiB
   Unallocated:             1.31TiB
