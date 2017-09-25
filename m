Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from titan.hyper.fi ([80.83.3.82]:39758 "EHLO titan.hyper.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935560AbdIYQjZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 12:39:25 -0400
Received: from localhost (localhost [127.0.0.1])
        by titan.hyper.fi (Postfix) with ESMTP id AC741E7D69
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Sep 2017 19:11:01 +0300 (EEST)
Date: Mon, 25 Sep 2017 19:11:01 +0300 (EEST)
From: linux-btrfs@oh3mqu.pp.hyper.fi
To: linux-btrfs@vger.kernel.org
Subject: Wrong device?
In-Reply-To: <345d459f-0d32-0ff9-19d3-86f86f165dfe@rqc.ru>
Message-ID: <alpine.LFD.2.00.1709251835060.25674@titan.hyper.fi>
References: <cdca7f92-93c0-9906-f2ed-57c3d0a97fae@jp.fujitsu.com> <3b6d4951-dd71-989d-3287-12ffe643bfae@suse.com> <b1b5a231-ffc3-700b-b59d-e82accf2f2e7@rqc.ru> <095397b6-4865-1ea3-ae0d-6725b84c447c@gmx.com> <20170925075250.GC25529@carfax.org.uk>
 <7a345608-6c5d-bdc9-9b5f-74a8052ea228@gmx.com> <20170925141951.GD25529@carfax.org.uk> <d0e2c24a-c6c6-c154-c8ad-d37fdea669d5@gmx.com> <345d459f-0d32-0ff9-19d3-86f86f165dfe@rqc.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi,

I have 15 x 6 TB disks in md-raid (Because btrfs's raid6 was marked as 
not-for-real-use when I first time installed this machine)

Now I have got both problem twice.

At this last time I have 233 subvolums, and millions of files (all 
together)

Then filesystem went to read only with this dmesg:

[Sat Sep 23 07:25:28 2017] ------------[ cut here ]------------
[Sat Sep 23 07:25:28 2017] WARNING: CPU: 5 PID: 5431 at /build/linux-hwe-edge-CrMNv8/linux-hwe-edge-4.10.0/fs/btrfs/extent-tree.c:6947 __btrfs_free_extent.isra.61+0x2cb/0xeb0 [btrfs]
[Sat Sep 23 07:25:28 2017] BTRFS: Transaction aborted (error -28)
[Sat Sep 23 07:25:28 2017] Modules linked in: 8021q garp mrp stp llc bonding ip6table_filter ip6_tables ipt_REJECT nf_reject_ipv4 nf_log_ipv4 nf_log_common xt_LOG xt_limit xt_tcpudp xt_multiport iptable_filter ip_tables x_tables intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp ipmi_ssif kvm_intel kvm irqbypass intel_cstate intel_rapl_perf joydev input_leds mei_me mei lpc_ich shpchp ioatdma ipmi_si ipmi_devintf ipmi_msghandler acpi_pad acpi_power_meter mac_hid ib_iser rdma_cm iw_cm ib_cm ib_core configfs iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi autofs4 btrfs raid10 raid0 multipath linear raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c raid1 ses enclosure ixgbe ast crct10dif_pclmul i2c_algo_bit crc32_pclmul ttm drm_kms_helper ghash_clmulni_intel
[Sat Sep 23 07:25:28 2017]  dca syscopyarea pcbc sysfillrect aesni_intel aes_x86_64 hid_generic sysimgblt crypto_simd mpt3sas fb_sys_fops ptp r8169 raid_class ahci glue_helper usbhid pps_core mxm_wmi cryptd drm hid libahci mdio scsi_transport_sas mii fjes wmi
[Sat Sep 23 07:25:28 2017] CPU: 5 PID: 5431 Comm: btrfs-transacti Tainted: G        W       4.10.0-26-generic #30~16.04.1-Ubuntu
[Sat Sep 23 07:25:28 2017] Hardware name: Supermicro X10DRi/X10DRI-T, BIOS 2.1 09/13/2016
[Sat Sep 23 07:25:28 2017] Call Trace:
[Sat Sep 23 07:25:28 2017]  dump_stack+0x63/0x90
[Sat Sep 23 07:25:28 2017]  __warn+0xcb/0xf0
[Sat Sep 23 07:25:28 2017]  warn_slowpath_fmt+0x5f/0x80
[Sat Sep 23 07:25:28 2017]  __btrfs_free_extent.isra.61+0x2cb/0xeb0 [btrfs]
[Sat Sep 23 07:25:28 2017]  ? btrfs_merge_delayed_refs+0x64/0x640 [btrfs]
[Sat Sep 23 07:25:28 2017]  ? btrfs_search_slot+0x981/0x9c0 [btrfs]
[Sat Sep 23 07:25:28 2017]  __btrfs_run_delayed_refs+0xb44/0x13a0 [btrfs]
[Sat Sep 23 07:25:28 2017]  ? btree_set_page_dirty+0xe/0x10 [btrfs]
[Sat Sep 23 07:25:28 2017]  ? free_extent_buffer+0x4b/0xa0 [btrfs]
[Sat Sep 23 07:25:28 2017]  ? igrab+0x1e/0x60
[Sat Sep 23 07:25:28 2017]  btrfs_run_delayed_refs+0x7f/0x2a0 [btrfs]
[Sat Sep 23 07:25:28 2017]  btrfs_write_dirty_block_groups+0x169/0x3c0 [btrfs]
[Sat Sep 23 07:25:28 2017]  commit_cowonly_roots+0x221/0x2c0 [btrfs]
[Sat Sep 23 07:25:28 2017]  btrfs_commit_transaction+0x542/0x950 [btrfs]
[Sat Sep 23 07:25:28 2017]  transaction_kthread+0x1a6/0x1c0 [btrfs]
[Sat Sep 23 07:25:28 2017]  kthread+0x109/0x140
[Sat Sep 23 07:25:28 2017]  ? btrfs_cleanup_transaction+0x540/0x540 [btrfs]
[Sat Sep 23 07:25:28 2017]  ? kthread_create_on_node+0x60/0x60
[Sat Sep 23 07:25:28 2017]  ret_from_fork+0x2c/0x40
[Sat Sep 23 07:25:28 2017] ---[ end trace 76fd3c22e75c2b85 ]---
[Sat Sep 23 07:25:28 2017] BTRFS: error (device sdb) in __btrfs_free_extent:6947: errno=-28 No space left
[Sat Sep 23 07:25:28 2017] BTRFS: error (device sdb) in btrfs_drop_snapshot:9193: errno=-28 No space left
[Sat Sep 23 07:25:28 2017] BTRFS info (device sdb): forced readonly


After a long googling (about more complex situations) I suddenly noticed 
"device sdb" WTF???  Filesystem is mounted from /dev/md3 (sdb is part of 
that mdraid) so btrfs should not even know anything about that /dev/sdb.

So maybe the error is more simple that I thought.  It tries to allocate 
more metadata from physical drive (not from /dev/md3 as it was supposed to 
do), so that "no space left on device" could be the REAL error...

But why it is doing so?  Does it help if I add some extra virtualization 
layer, like LVM?


# grep data /etc/fstab
/dev/md3 /data btrfs   compress=zlib,space_cache,noatime 0 0

# btrfs fi df /data
Data, single: total=4.77TiB, used=4.77TiB
System, DUP: total=32.00MiB, used=592.00KiB
Metadata, DUP: total=92.00GiB, used=90.87GiB
GlobalReserve, single: total=512.00MiB, used=172.50MiB

# btrfs fi show /data
Label: none  uuid: 84a31ba6-d22d-4653-b071-5525dbdfe561
         Total devices 1 FS bytes used 4.85TiB
         devid    2 size 70.95TiB used 4.95TiB path /dev/md3

# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4] [linear] [multipath] [raid0] [raid10]
md3 : active raid6 sdl[17](S) sdb[16] sdq[15] sdp[14] sdm[11] sdc[1] sdo[13] sde[3] sdj[8] sdn[12] sdh[6] sdi[7] sdk[9] sdf[4] sdd[2] sdg[5]
       76185088512 blocks super 1.2 level 6, 512k chunk, algorithm 2 [15/15] [UUUUUUUUUUUUUUU]
       bitmap: 0/44 pages [0KB], 65536KB chunk

# btrfs --version
btrfs-progs v4.4

# uname -a
Linux backuprasia 4.10.0-26-generic #30~16.04.1-Ubuntu SMP Tue Jun 27 09:40:14 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux

( This usage have been done later after some balance tries..  and mounte to another moun point)
# btrfs fi usage /data2
Overall:
     Device size:                  70.95TiB
     Device allocated:              4.95TiB
     Device unallocated:           66.01TiB
     Device missing:                  0.00B
     Used:                          4.94TiB
     Free (estimated):             66.01TiB      (min: 33.01TiB)
     Data ratio:                       1.00
     Metadata ratio:                   2.00
     Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:4.77TiB, Used:4.76TiB
    /dev/md3        4.77TiB

Metadata,DUP: Size:92.00GiB, Used:90.79GiB
    /dev/md3      184.00GiB

System,DUP: Size:32.00MiB, Used:592.00KiB
    /dev/md3       64.00MiB

Unallocated:
    /dev/md3       66.01TiB



PS. I have noticed another bug too, but I haven't tested it with lastest 
kernels after I noticed that it happens only with compression=lzo.  So 
maybe it is already fixed.  With gzip or none compression probem does not 
happens.  I have email server with about 0.5 TB volume. It is using 
Maildir so it contains huge amount of files.  Sometimes some files goes 
unreadable.  After server reset problematic file could be readable again 
(but not always)...

But weird thing is that unreadable file always seems to be 
dovecot.index.log. I asked from dovecot author, and he said there is 
nothing special with that file usage, it is just opened with O_APPEND and 
some data is written to it.  Problem is hard to reproduce because it seems 
to be random

-- 
Ari Saastamoinen
