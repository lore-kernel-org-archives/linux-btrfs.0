Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37264 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab3AFKez (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 6 Jan 2013 05:34:55 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1TrnZI-00072Q-D1
	for linux-btrfs@vger.kernel.org; Sun, 06 Jan 2013 11:35:04 +0100
Received: from host385.static.otenet.gr ([62.103.130.130])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Jan 2013 11:35:04 +0100
Received: from tmjuju by host385.static.otenet.gr with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Jan 2013 11:35:04 +0100
To: linux-btrfs@vger.kernel.org
From: TM <tmjuju@yahoo.com>
Subject: block rsv returned -28
Date: Sun, 6 Jan 2013 10:28:30 +0000 (UTC)
Message-ID: <loom.20130106T102511-102@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,
in a newly created btrfs filesystem, just after two days and ~4K dirs, 40K
files, performance has degraded very bad. 
I did a chmod / chown the files once (that might have implications on the
filesystem) but this is casual/expected  use. 

Only notable thing in dmesg is  [9 times]

btrfs: block rsv returned -28
------------[ cut here ]------------
WARNING: at fs/btrfs/extent-tree.c:6297 use_block_rsv+0x192/0x1a0 [btrfs]()
Hardware name: ProLiant MicroServer
Modules linked in: bnx2fc cnic uio fcoe libfcoe libfc scsi_transport_fc scsi_tgt
vboxpci(OF) vboxnetadp(OF) vboxnetflt(OF) 8021q vboxdrv(OF) garp stp llc sunrpc
ipt_REJECT ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack
ip6table_filter ip6_tables ipv6 btrfs zlib_deflate libcrc32c kvm_amd kvm
microcode pcspkr k10temp amd64_edac_mod edac_core edac_mce_amd i2c_piix4 tg3 sg
shpchp ext4 mbcache jbd2 sd_mod crc_t10dif ahci libahci radeon ttm
drm_kms_helper drm i2c_algo_bit i2c_core dm_mirror dm_region_hash dm_log dm_mod
[last unloaded: nf_defrag_ipv4]
Pid: 1859, comm: btrfs-transacti Tainted: GF       W  O 3.7.1 #1
Call Trace:
 [<ffffffff8105556f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff810555ca>] warn_slowpath_null+0x1a/0x20
 [<ffffffffa0406e02>] use_block_rsv+0x192/0x1a0 [btrfs]
 [<ffffffffa040bb9d>] btrfs_alloc_free_block+0x3d/0x210 [btrfs]
 [<ffffffffa0432ab1>] ? read_extent_buffer+0xd1/0x130 [btrfs]
 [<ffffffffa03f6eb0>] __btrfs_cow_block+0x130/0x560 [btrfs]
 [<ffffffffa03f7942>] btrfs_cow_block+0x102/0x210 [btrfs]
 [<ffffffffa03fad11>] btrfs_search_slot+0x391/0x810 [btrfs]
 [<ffffffffa04577f7>] __btrfs_write_out_cache+0x757/0x960 [btrfs]
 [<ffffffffa045b3ae>] ? btrfs_find_ref_cluster+0x5e/0x160 [btrfs]
 [<ffffffffa0457b72>] btrfs_write_out_cache+0xb2/0xf0 [btrfs]
 [<ffffffffa0409fe8>] btrfs_write_dirty_block_groups+0x238/0x270 [btrfs]
 [<ffffffffa041a2c1>] commit_cowonly_roots+0x171/0x250 [btrfs]
 [<ffffffffa041b120>] btrfs_commit_transaction+0x570/0xa20 [btrfs]
 [<ffffffffa041ba84>] ? start_transaction+0x94/0x430 [btrfs]
 [<ffffffff81079cb0>] ? wake_up_bit+0x40/0x40
 [<ffffffffa0415d26>] transaction_kthread+0x1a6/0x220 [btrfs]
 [<ffffffffa0415b80>] ? btree_readpage_end_io_hook+0x290/0x290 [btrfs]
 [<ffffffffa0415b80>] ? btree_readpage_end_io_hook+0x290/0x290 [btrfs]
 [<ffffffff8107942e>] kthread+0xce/0xe0
 [<ffffffff81079360>] ? kthread_freezable_should_stop+0x70/0x70
 [<ffffffff8153e6ac>] ret_from_fork+0x7c/0xb0
 [<ffffffff81079360>] ? kthread_freezable_should_stop+0x70/0x70
---[ end trace 592323d6a331318d ]---



Kernel: 
Linux microserver 3.7.1 #1 SMP Sun Dec 30 21:34:59 EET 2012 x86_64 x86_64 x86_64
GNU/Linux
Toos: 
Btrfs v0.20-rc1-37-g91d9eec

# btrfs fi show
Label: 'tm_0'  uuid: f2866a33-fe53-4fc0-98bf-52d347b43824
        Total devices 1 FS bytes used 712.21GB
        devid    1 size 1.82TB used 714.04GB path /dev/sdb1


# btrfs fi df /mnt/dls
Data: total=712.01GB, used=711.24GB
System, DUP: total=8.00MB, used=80.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=1.00GB, used=998.53MB
Metadata: total=8.00MB, used=0.00


Performance is horrible for the last 12 hours at least
I tried remounting with noatime nothing changed
I tried rebooting, stopping any services like smb etc.
I tried defragmenting nothing changed

Metadata seems full
Darksatanic suggested That's ENOSPC 
(Thanks to the guys at irc chanel for their support :)
But how can I regain space on Metadata? 
Any suggestions?

TM


