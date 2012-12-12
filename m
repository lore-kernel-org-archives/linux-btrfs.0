Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:38777 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab2LLPBD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Dec 2012 10:01:03 -0500
Received: from [172.24.1.80] (yian-ho01.nir.cronon.net [192.166.201.94])
	by smtp.strato.de (jorabe mo20) (RZmta 31.9 AUTH)
	with ESMTPA id z006ddoBCDrpTu for <linux-btrfs@vger.kernel.org>;
	Wed, 12 Dec 2012 16:01:00 +0100 (CET)
Message-ID: <50C89C2C.70606@giantdisaster.de>
Date: Wed, 12 Dec 2012 16:01:00 +0100
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Linux Btrfs List <linux-btrfs@vger.kernel.org>
Subject: [BUG] issue with btrfs-next and xfstest 241
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The problem is that a new superblock is written which references a block in the log tree although this block is written _after_ the superblock is written and never before.

The referenced block in the following log is the one with the logical byte number 35770368 which physically is located on (mirror=2, device=/dev/sdg, phys_byte_nr 1117900800) and (mirror=1, device=/dev/sdg, phys_byte_nr=44158976).
The submit_bio() of both mirrors and (of course) the completion takes place after the FLUSH request and after the submit_bio() and completion of the superblock.

export TEST_DEV=/dev/sdg
export TEST_DIR=/mnt3
export SCRATCH_DEV=/dev/sdi
export SCRATCH_MNT=/mnt2
cd xfs/cmds/xfstests
grep check_int common.rc
  gives this result:        export MOUNT_OPTIONS="-o check_int,check_int_print_mask=51,compress=lzo,autodefrag,space_cache"

./check 241


...
submit_bio(rw=0x1411 FLUSH, bdev=ffff88022e9aa400)
bio_end_io(err=0) for D @0 (sdg/0/0) -> for the FLUSH
submit_bh(rw=0xc11, blocknr=16 (bytenr 65536), size=4096, data=ffff880228d40000, bdev=ffff88022e9aa400)
btrfsic: superblock @65536 (sdg/65536/1) with old gen 45 <= 45
root@30392320
chunk@20975616
log@35766272
btrfs: attempt to write superblock which references block M @35770368 (sdg/1117900800/2) which is never written!
btrfs: attempt to write superblock which references block M @35770368 (sdg/44158976/1) which is never written!
------------[ cut here ]------------
WARNING: at fs/btrfs/check-integrity.c:2533 btrfsic_process_written_superblock+0x256/0x3e0 [btrfs]()
Hardware name: X8SIL
Modules linked in: btrfs raid10 raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx raid1 raid0 mpt2sas scsi_transport_sas raid_class
Pid: 4992, comm: dbench Tainted: G        W    3.7.0+ #106
Call Trace:
 [<ffffffff8108657a>] warn_slowpath_common+0x7a/0xb0
 [<ffffffff810865c5>] warn_slowpath_null+0x15/0x20
 [<ffffffffa01468d6>] btrfsic_process_written_superblock+0x256/0x3e0 [btrfs]
 [<ffffffffa0147ce4>] btrfsic_process_written_block+0x634/0xf90 [btrfs]
 [<ffffffff810884b4>] ? console_unlock+0x274/0x440
 [<ffffffffa014866d>] ? btrfsic_submit_bh+0x2d/0x1d0 [btrfs]
 [<ffffffffa014876d>] btrfsic_submit_bh+0x12d/0x1d0 [btrfs]
 [<ffffffffa00d778e>] write_dev_supers.isra.113+0x1ee/0x280 [btrfs]
 [<ffffffffa00d9530>] write_all_supers+0x650/0x910 [btrfs]
 [<ffffffffa01348e7>] ? btrfs_scrub_pause_super+0x17/0x20 [btrfs]
 [<ffffffffa00d97fe>] write_ctree_super+0xe/0x10 [btrfs]
 [<ffffffffa011a344>] btrfs_sync_log+0x654/0x6c0 [btrfs]
 [<ffffffffa00efb36>] btrfs_sync_file+0x226/0x2c0 [btrfs]
 [<ffffffff811c75f8>] do_fsync+0x58/0x80
 [<ffffffff814427ce>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff811c799b>] sys_fsync+0xb/0x10
 [<ffffffff819666d2>] system_call_fastpath+0x16/0x1b
---[ end trace 757707b80c8cafa9 ]---
S-65536(sdg/65536/1) --> M-35766272(sdg/1117896704/0) --> M-35745792(sdg/1117876224/2) [...]
                                                      --> M-35745792(sdg/44134400/1) --> M-35753984(sdg/1117884416/0)
                                                                                     --> M-35753984(sdg/44142592/1)
                                                                                     --> M-35749888(sdg/1117880320/0)
                                                                                     --> M-35749888(sdg/44138496/1)
                                                                                     --> M-35770368(sdg/1117900800/2)   XXX
                                                                                     --> M-35770368(sdg/44158976/1)   XXX
...
                     --> M-35766272(sdg/44154880/0) --> M-35745792(sdg/1117876224/2) [...]
                                                    --> M-35745792(sdg/44134400/1) --> M-35753984(sdg/1117884416/0)
                                                                                   --> M-35753984(sdg/44142592/1)
...
...
                     --> M-20975616(sdg/29364224/2)
                     --> M-20975616(sdg/20975616/1)
                     --> M-30392320(sdg/1112522752/2) [...]
                     --> M-30392320(sdg/38780928/1) --> M-29380608(sdg/1111511040/2)
                                                    --> M-29380608(sdg/37769216/1)
...
bh_end_io(error=0) for S @65536 (sdg/65536/1)
submit_bio(rw=0x411, bi_vcnt=3, bi_sector=86248 (bytenr 44158976), bi_bdev=ffff88022e9aa400)   XXX
btrfs: attempt to overwrite M-block @35770368 (sdg/44158976/1), old(gen=18446744073709551615, objectid=1768, type=108, offset=0), new(gen=46), which is referenced by most recent superblock (superblockgen=45)!
S-65536(sdg/65536/1) --> M-35766272(sdg/1117896704/0) --> M-35745792(sdg/1117876224/2) [...]
                                                      --> M-35745792(sdg/44134400/1) --> M-35753984(sdg/1117884416/0)
                                                                                     --> M-35753984(sdg/44142592/1)
                                                                                     --> M-35749888(sdg/1117880320/0)
                                                                                     --> M-35749888(sdg/44138496/1)
                                                                                     --> M-35770368(sdg/1117900800/2)
                                                                                     --> M-35770368(sdg/44158976/1)   XXX
...
submit_bio(rw=0x411, bi_vcnt=1, bi_sector=29528 (bytenr 15118336), bi_bdev=ffff88022e9aa400)
submit_bio(rw=0x411, bi_vcnt=3, bi_sector=2183400 (bytenr 1117900800), bi_bdev=ffff88022e9aa400)   XXX
btrfs: attempt to overwrite M-block @35770368 (sdg/1117900800/2), old(gen=18446744073709551615, objectid=1768, type=108, offset=0), new(gen=46), which is referenced by most recent superblock (superblockgen=45)!
S-65536(sdg/65536/1) --> M-35766272(sdg/1117896704/0) --> M-35745792(sdg/1117876224/2) [...]
                                                      --> M-35745792(sdg/44134400/1) --> M-35753984(sdg/1117884416/0)
                                                                                     --> M-35753984(sdg/44142592/1)
                                                                                     --> M-35749888(sdg/1117880320/0)
                                                                                     --> M-35749888(sdg/44138496/1)
                                                                                     --> M-35770368(sdg/1117900800/2)   XXX
                                                                                     --> M-35770368(sdg/44158976/1)
...
bio_end_io(err=0) for M @35770368 (sdg/44158976/1)   XXX
...
submit_bio(rw=0x411, bi_vcnt=1, bi_sector=29536 (bytenr 15122432), bi_bdev=ffff88022e9aa400)
submit_bio(rw=0x411, bi_vcnt=4, bi_sector=86272 (bytenr 44171264), bi_bdev=ffff88022e9aa400)
submit_bio(rw=0x411, bi_vcnt=1, bi_sector=29544 (bytenr 15126528), bi_bdev=ffff88022e9aa400)
submit_bio(rw=0x411, bi_vcnt=4, bi_sector=2183424 (bytenr 1117913088), bi_bdev=ffff88022e9aa400)
bio_end_io(err=0) for M @35778560 (sdg/1117908992/0)
bio_end_io(err=0) for M @35774464 (sdg/1117904896/2)
bio_end_io(err=0) for M @35770368 (sdg/1117900800/2)   XXX
bio_end_io(err=0) for M @35794944 (sdg/44183552/0)
bio_end_io(err=0) for M @35790848 (sdg/44179456/0)
bio_end_io(err=0) for M @35786752 (sdg/44175360/0)
bio_end_io(err=0) for M @35782656 (sdg/44171264/0)
bio_end_io(err=0) for M @35794944 (sdg/1117925376/0)
bio_end_io(err=0) for M @35790848 (sdg/1117921280/0)
bio_end_io(err=0) for M @35786752 (sdg/1117917184/0)
bio_end_io(err=0) for M @35782656 (sdg/1117913088/0)
submit_bio(rw=0x1411 FLUSH, bdev=ffff88022e9aa400)
bio_end_io(err=0) for D @0 (sdg/0/0)
bio_end_io() new sdg flush_gen=241
submit_bh(rw=0xc11, blocknr=16 (bytenr 65536), size=4096, data=ffff880228d40000, bdev=ffff88022e9aa400)
btrfsic: superblock @65536 (sdg/65536/1) with old gen 45 <= 45
...

