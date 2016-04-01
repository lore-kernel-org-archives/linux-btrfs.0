Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:35826 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbcDASx1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Apr 2016 14:53:27 -0400
Received: by mail-io0-f176.google.com with SMTP id g185so162850984ioa.2
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Apr 2016 11:53:26 -0700 (PDT)
Message-ID: <1459536804.8310.8.camel@gmail.com>
Subject: Re: Compression causes kernel crashes if there are I/O or checksum
 errors (was: RE: kernel BUG at fs/btrfs/volumes.c:5519 when hot-removing
 device in RAID-1)
From: mitch <msfossen@gmail.com>
To: James Johnston <johnstonj.public@codenest.com>,
        Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Date: Fri, 01 Apr 2016 13:53:24 -0500
In-Reply-To: <CA+ve2MbcU8W_084oOo_JGToJB5XZ1cWnwW=wGhT2gp4fCZa30w@mail.gmail.com>
References: <001b01d188ac$16740630$435c1290$@codenest.com>
	 <pan$284e3$6ee9615a$919b0339$15e3af27@cox.net>
	 <003801d188fe$e8c9b920$ba5d2b60$@codenest.com>
	 <CA+ve2MbcU8W_084oOo_JGToJB5XZ1cWnwW=wGhT2gp4fCZa30w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I grabbed this part from the log after the machine crashed again
following trying to transfer a bunch of files that included ones with
csum errors, let me know if this looks like the same issue you were
having:


Mar 31 00:49:42 sl-server kernel: NMI watchdog: BUG: soft lockup -
CPU#21 stuck for 22s! [kworker/u67:5:80994]
Mar 31 00:49:42 sl-server kernel: Modules linked in: fuse xt_CHECKSUM
ipt_MASQUERADE nf_nat_masquerade_ipv4 tun ip6t_rpfilter ip6t_REJECT
nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack ebtable_nat
ebtable_broute ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6
nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security
ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle
iptable_security iptable_raw iptable_filter dm_mirror dm_region_hash
dm_log dm_mod kvm_amd kvm irqbypass crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel xfs aesni_intel lrw gf128mul glue_helper libcrc32c
ablk_helper cryptd joydev input_leds edac_mce_amd k10temp edac_core
fam15h_power sp5100_tco sg i2c_piix4 8250_fintek acpi_cpufreq shpchp
nfsd auth_rpcgss nfs_acl
Mar 31 00:49:42 sl-server kernel:  lockd grace sunrpc ip_tables btrfs
xor ata_generic pata_acpi raid6_pq sd_mod mgag200 crc32c_intel
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm ahci
serio_raw pata_atiixp libahci igb drm ptp pps_core mpt3sas dca
raid_class libata i2c_algo_bit scsi_transport_sas fjes uas usb_storage
Mar 31 00:49:42 sl-server kernel: CPU: 21 PID: 80994 Comm:
kworker/u67:5 Not tainted 4.5.0-1.el7.elrepo.x86_64 #1
Mar 31 00:49:42 sl-server kernel: Hardware name: Supermicro
H8DG6/H8DGi/H8DG6/H8DGi, BIOS 3.5        11/25/2013
Mar 31 00:49:42 sl-server kernel: Workqueue: btrfs-endio
btrfs_endio_helper [btrfs]
Mar 31 00:49:42 sl-server kernel: task: ffff8817f6fa8000 ti:
ffff8800b7310000 task.ti: ffff8800b7310000
Mar 31 00:49:42 sl-server kernel: RIP:
0010:[<ffffffffa0347b13>]  [<ffffffffa0347b13>]
btrfs_decompress_buf2page+0x123/0x200 [btrfs]
Mar 31 00:49:42 sl-server kernel: RSP: 0018:ffff8800b7313be0  EFLAGS:
00000246
Mar 31 00:49:42 sl-server kernel: RAX: 0000000000000000 RBX:
0000000000000000 RCX: 0000000000000000
Mar 31 00:49:42 sl-server kernel: RDX: 0000000000000000 RSI:
ffffc9000e3d8000 RDI: ffff88144c7cc000
Mar 31 00:49:42 sl-server kernel: RBP: ffff8800b7313c48 R08:
ffff8810f0295000 R09: 0000000000000020
Mar 31 00:49:42 sl-server kernel: R10: ffff8810d2ba7869 R11:
0000000000010008 R12: ffff8817f6fa8000
Mar 31 00:49:42 sl-server kernel: R13: ffff8800b7313ce0 R14:
0000000000000008 R15: 0000000000001000
Mar 31 00:49:42 sl-server kernel: FS:  00007efce58fb740(0000)
GS:ffff881807d40000(0000) knlGS:0000000000000000
Mar 31 00:49:42 sl-server kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
000000008005003b
Mar 31 00:49:42 sl-server kernel: CR2: 00007f00caf249e8 CR3:
0000001062121000 CR4: 00000000000406e0
Mar 31 00:49:42 sl-server kernel: Stack:
Mar 31 00:49:42 sl-server kernel:  0000000000000020 000000000000f000
ffff8810f0295000 0000000087440000
Mar 31 00:49:42 sl-server kernel:  0000000000010008 ffffc9000e3d7000
ffffea005131f300 0000000000010000
Mar 31 00:49:42 sl-server kernel:  0000000000000797 0000000000002869
0000000000000869 ffff8810d2ba7000
Mar 31 00:49:42 sl-server kernel: Call Trace:
Mar 31 00:49:42 sl-server kernel:  [<ffffffffa0345dd2>]
lzo_decompress_biovec+0x202/0x300 [btrfs]
Mar 31 00:49:42 sl-server kernel:  [<ffffffffa0346bb6>]
end_compressed_bio_read+0x1f6/0x2f0 [btrfs]
Mar 31 00:49:42 sl-server kernel:  [<ffffffff81307b20>]
bio_endio+0x40/0x60
Mar 31 00:49:42 sl-server kernel:  [<ffffffffa02f1e5c>]
end_workqueue_fn+0x3c/0x40 [btrfs]
Mar 31 00:49:42 sl-server kernel:  [<ffffffffa032e5f0>]
normal_work_helper+0xc0/0x2c0 [btrfs]
Mar 31 00:49:42 sl-server kernel:  [<ffffffffa032e8c2>]
btrfs_endio_helper+0x12/0x20 [btrfs]
Mar 31 00:49:42 sl-server kernel:  [<ffffffff8109736f>]
process_one_work+0x14f/0x400
Mar 31 00:49:42 sl-server kernel:  [<ffffffff81097c55>]
worker_thread+0x125/0x4b0
Mar 31 00:49:42 sl-server kernel:  [<ffffffff81097b30>] ?
rescuer_thread+0x370/0x370
Mar 31 00:49:42 sl-server kernel:  [<ffffffff8109d7c8>]
kthread+0xd8/0xf0
Mar 31 00:49:42 sl-server kernel:  [<ffffffff8109d6f0>] ?
kthread_park+0x60/0x60
Mar 31 00:49:42 sl-server kernel:  [<ffffffff81703f4f>]
ret_from_fork+0x3f/0x70
Mar 31 00:49:42 sl-server kernel:  [<ffffffff8109d6f0>] ?
kthread_park+0x60/0x60
Mar 31 00:49:42 sl-server kernel: Code: c7 48 8b 45 c0 49 03 7d 00 4a
8d 34 38 e8 06 18 00 e1 41 83 ac 24 28 12 00 00 01 41 8b 84 24 28 12 00
00 85 c0 0f 88 bf 00 00 00 <48> 89 d8 49 03 45 00 49 01 df 49 29 de 48
01 5d d0 48 3d 00 10 
Mar 31 00:49:43 sl-server sh[1297]: abrt-dump-oops: Found oopses: 1
Mar 31 00:49:43 sl-server sh[1297]: abrt-dump-oops: Creating problem
directories
Mar 31 00:49:43 sl-server sh[1297]: abrt-dump-oops: Not going to make
dump directories world readable because PrivateReports is on
