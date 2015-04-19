Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f170.google.com ([209.85.216.170]:36648 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbbDSUPi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Apr 2015 16:15:38 -0400
Received: by qcpm10 with SMTP id m10so48863714qcp.3
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2015 13:15:37 -0700 (PDT)
Received: from [192.168.1.129] (192-0-164-119.cpe.teksavvy.com. [192.0.164.119])
        by mx.google.com with ESMTPSA id j63sm12937140qga.12.2015.04.19.13.15.35
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 19 Apr 2015 13:15:36 -0700 (PDT)
Message-ID: <55340CEE.7010800@gmail.com>
Date: Sun, 19 Apr 2015 16:15:42 -0400
From: Joel Best <joelbest@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: 3.18.11 - "no space left on device" and 'fi usage' shows lots
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all, We have recently had major issues with our large btrfs volume 
crashing and remounting read-only because it thinks it's out of space. 
The volume is 55TB on h/w raid 6 with 44TB free and the server is 
running Ubuntu 14.04 server x64. The problem first happened with kernel 
3.13 but I've since upgraded to 3.18 while trying to resolve this issue. 
The volume was first created with kernel 3.13 and btfs-progs 3.12.

When this problem first cropped up, it crashed the kernel with the 
following error:

     BTRFS debug (device sda1): run_one_delayed_ref returned -28
     Apr 17 19:49:28 NAS1 kernel: [189102.821859] BTRFS error (device 
sda1) in btrfs_run_delayed_refs:2730: errno=-28 No space left
     Apr 17 19:49:28 NAS1 kernel: [189102.821861] BTRFS info (device 
sda1): forced readonly
     Apr 17 19:49:28 NAS1 kernel: [189102.916132] btrfs: Transaction 
aborted (error -28)

After some reading, it seemed like mounting with clear_cache to clear 
the disk caching but the problem recurred a short time later. We then 
tried a balance, and and fsck/fsck --repair which both failed to resolve 
the issue. Finally, we decided to upgrade kernels from 3.13 to 3.18.

To try and reproduce the issue after the upgrade, I created a script 
which uses fallocate to generate 1000 1GB files, deletes them, and repeats:

     #!/bin/bash
     while [ 1 ] ; do
         echo "Creating 1000 files..."
         i=0
         while [ 1 ] ; do
             fallocate -l 1G test.${i}
             (( i++ ))
             if [[ "$i" == "1000" ]] ; then
                 break
             fi
         done
         echo "Removing Files..."
         rm -f test.*
     done

After a few successful iterations, this happened:

     # /root/April2015-storage-failure/stress-fallocate.sh
     Creating 1000 files...
     fallocate: test.147: fallocate failed: No space left on device
     fallocate: test.148: fallocate failed: No space left on device
     fallocate: test.149: fallocate failed: No space left on device
     fallocate: test.150: fallocate failed: No space left on device
     fallocate: test.151: fallocate failed: No space left on device
     fallocate: test.152: fallocate failed: No space left on device
     fallocate: test.153: fallocate failed: No space left on device
     fallocate: test.154: fallocate failed: No space left on device
     fallocate: test.155: fallocate failed: No space left on device
     fallocate: test.156: fallocate failed: No space left on device
     ^C

There was no kernel crash this time. All btrfs tools show lots of space 
available:

     root@NAS1:/mlrg/tmp# btrfs fi usage /mlrg
     Overall:
         Device size:            54.56TiB
         Device allocated:           11.31TiB
         Device unallocated:           43.26TiB
         Used:           11.30TiB
         Free (estimated):           43.26TiB      (min: 43.26TiB)
         Data ratio:               1.00
         Metadata ratio:               1.00
         Global reserve:          512.00MiB      (used: 0.00B)
     Data,single: Size:11.26TiB, Used:11.26TiB
        /dev/sdc1  11.26TiB
     Metadata,single: Size:48.01GiB, Used:46.29GiB
        /dev/sdc1  48.01GiB
     System,single: Size:32.00MiB, Used:1.20MiB
        /dev/sdc1  32.00MiB
     Unallocated:
        /dev/sdc1  43.26TiB


I'm not sure if this is expected behaviour with fallocate or a bug. It's 
the only way I've found to reliably reproduce the problem (aside from 
making the server available to my users).


Also, I first inadvertently ran the fallocate script when a scrub was 
running I experienced a different crash... I'm not sure if it's related:

     [12996.654120] kernel BUG at 
/home/kernel/COD/linux/fs/btrfs/inode.c:3123!
     [12996.656776] invalid opcode: 0000 [#1] SMP
     [12996.658473] Modules linked in: nfsv3 ip6t_REJECT nf_reject_ipv6 
xt_hl ip6t_rt nf_conntrack_ipv6 nf_defrag_ipv6 x86_pkg_temp_thermal 
intel_powerclamp ipt_REJECT coretemp ipmi_devintf nf_reject_ipv4 
xt_limit xt_tcpudp kvm xt_addrtype crct10dif_pclmul crc32_pclmul 
ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper 
ablk_helper cryptd nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack 
ip6table_filter ip6_tables nf_conntrack_netbios_ns 
nf_conntrack_broadcast nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack 
iptable_filter ip_tables x_tables sb_edac lpc_ich edac_core mei_me mei 
ioatdma shpchp wmi ipmi_si ipmi_msghandler 8250_fintek mac_hid megaraid 
lp parport rpcsec_gss_krb5 nfsd auth_rpcgss nfs_acl nfs lockd grace 
sunrpc fscache btrfs raid10 raid456 async_raid6_recov async_memcpy 
async_pq async_xor async_tx xor raid6_pq igb isci i2c_algo_bit raid1 
hid_generic dca raid0 usbhid ptp ses libsas ahci multipath enclosure hid 
libahci pps_core scsi_transport_sas megaraid_sas linear
     [12996.697253] CPU: 5 PID: 10458 Comm: btrfs-cleaner Tainted: G     
     C 3.18.11-031811-generic #201504041535
     [12996.701338] Hardware name: Intel Corporation S2600CP/S2600CP, 
BIOS SE5C600.86B.02.03.0003.041920141333 04/19/2014
     [12996.705495] task: ffff881fdaafda00 ti: ffff881a49df4000 task.ti: 
ffff881a49df4000
     [12996.708514] RIP: 0010:[<ffffffffc03370a9>]  [<ffffffffc03370a9>] 
btrfs_orphan_add+0x1a9/0x1c0 [btrfs]
     [12996.712306] RSP: 0018:ffff881a49df7c98  EFLAGS: 00010286
     [12996.714429] RAX: 00000000ffffffe4 RBX: ffff880fd75f8000 RCX: 
0000000000000000
     [12996.717308] RDX: 0000000000002b12 RSI: 0000000000040000 RDI: 
ffff880f5a51c138
     [12996.791256] RBP: ffff881a49df7cd8 R08: ffffe8fffee20850 R09: 
ffff881aa38d5d40
     [12996.866007] R10: 0000000000000000 R11: 0000000000000010 R12: 
ffff881fe4608dc0
     [12996.941445] R13: ffff881c1f61d790 R14: ffff880fd75f8458 R15: 
0000000000000001
     [12997.016606] FS:  0000000000000000(0000) 
GS:ffff881ffe620000(0000) knlGS:0000000000000000
     [12997.163897] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
     [12997.238138] CR2: 000000000128d008 CR3: 0000000001c16000 CR4: 
00000000001407e0
     [12997.312295] Stack:
     [12997.383946]  ffff881a49df7cd8 ffffffffc0375e0f ffff881fd4b35800 
ffff880080ad8200
     [12997.528170]  ffff881fd4b35800 ffff881aa38d5d40 ffff881fe4608dc0 
0000000000000001
     [12997.672790]  ffff881a49df7d58 ffffffffc031f2c0 ffff880f5a51c000 
00000004c0305ffa
     [12997.816858] Call Trace:
     [12997.886473]  [<ffffffffc0375e0f>] ? 
lookup_free_space_inode+0x4f/0x100 [btrfs]
     [12998.025910]  [<ffffffffc031f2c0>] 
btrfs_remove_block_group+0x140/0x490 [btrfs]
     [12998.166112]  [<ffffffffc0359f55>] btrfs_remove_chunk+0x245/0x380 
[btrfs]
     [12998.238039]  [<ffffffffc031f846>] 
btrfs_delete_unused_bgs+0x236/0x270 [btrfs]
     [12998.309001]  [<ffffffffc0328bfc>] cleaner_kthread+0x12c/0x190 
[btrfs]
     [12998.378869]  [<ffffffffc0328ad0>] ? 
btree_readpage_end_io_hook+0x2c0/0x2c0 [btrfs]
     [12998.514511]  [<ffffffff81093bc9>] kthread+0xc9/0xe0
     [12998.581913]  [<ffffffff81093b00>] ? flush_kthread_worker+0x90/0x90
     [12998.648486]  [<ffffffff817b54d8>] ret_from_fork+0x58/0x90
     [12998.714302]  [<ffffffff81093b00>] ? flush_kthread_worker+0x90/0x90


All data seems to be in tact, but the system is unusable due to the 
frequent crashes. Does anyone have any suggestions on how to proceed? 
I've tried a balance (crashed after a long time), scrub (no errors), and 
fsck to no avail.

Thanks for any help!
-Joel
