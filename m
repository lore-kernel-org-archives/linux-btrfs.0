Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:34330 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750846AbdCMV6p (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Mar 2017 17:58:45 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cnXz6-0006Ol-EJ
        for linux-btrfs@vger.kernel.org; Mon, 13 Mar 2017 22:58:32 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Hard crash on 4.9.5
Date: Mon, 13 Mar 2017 22:58:29 +0100
Message-ID: <20170313225829.01c06724@jupiter.sol.kaishome.de>
References: <83c1a49a-b2ea-c7b6-151d-cbd15b6c9c93@techsquare.com>
        <20170125210618.GA18416@localhost.localdomain>
        <1d4c2360-0e6d-b476-e1af-2789ca01e59f@techsquare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sat, 28 Jan 2017 15:50:38 -0500
schrieb Matt McKinnon <matt@techsquare.com>:

> This same file system (which crashed again with the same errors) is
> also giving this output during a metadata or data balance:

This looks somewhat familiar to the err=-17 that I am experiencing when
using VirtualBox image on btrfs in CoW mode (compress=lzo).

During IO intensive workloads, it results in "object already exists,
err -17" (or similar, someone else also experienced it through another
workload). The resulting btrfs check show the same errors, giving
inodes without csum.

Trying to continue using this file system in successive boots usually
results in boot freezes or complete unmountable filesystem, broken
beyond repair.

I'm feeling that using the bfq elevator usually enables me to trigger
this bug also without using VirtualBox, i.e. during normal system
usage, and mostly during boot when IO load is very high. So I also
stopped using bfq although it was giving me a much superior
interactivity.

Marking vbox images nocow and using standard elevators (cfq, deadline)
exposes no such problems so far - even during excessive IO loads.

EOM

> Jan 27 19:42:47 my_machine kernel: [  335.018123] BTRFS info (device 
> sda1): no csum found for inode 28472371 start 2191360
> Jan 27 19:42:47 my_machine kernel: [  335.018128] BTRFS info (device 
> sda1): no csum found for inode 28472371 start 2195456
> Jan 27 19:42:47 my_machine kernel: [  335.018491] BTRFS info (device 
> sda1): no csum found for inode 28472371 start 4018176
> Jan 27 19:42:47 my_machine kernel: [  335.018496] BTRFS info (device 
> sda1): no csum found for inode 28472371 start 4022272
> Jan 27 19:42:47 my_machine kernel: [  335.018499] BTRFS info (device 
> sda1): no csum found for inode 28472371 start 4026368
> Jan 27 19:42:47 my_machine kernel: [  335.018502] BTRFS info (device 
> sda1): no csum found for inode 28472371 start 4030464
> Jan 27 19:42:47 my_machine kernel: [  335.019443] BTRFS info (device 
> sda1): no csum found for inode 28472371 start 6156288
> Jan 27 19:42:47 my_machine kernel: [  335.019688] BTRFS info (device 
> sda1): no csum found for inode 28472371 start 7933952
> Jan 27 19:42:47 my_machine kernel: [  335.019693] BTRFS info (device 
> sda1): no csum found for inode 28472371 start 7938048
> Jan 27 19:42:47 my_machine kernel: [  335.019754] BTRFS info (device 
> sda1): no csum found for inode 28472371 start 8077312
> Jan 27 19:42:47 my_machine kernel: [  335.025485] BTRFS warning
> (device sda1): csum failed ino 28472371 off 2191360 csum 4031061501
> expected csum 0 Jan 27 19:42:47 my_machine kernel: [  335.025490]
> BTRFS warning (device sda1): csum failed ino 28472371 off 2195456
> csum 2371784003 expected csum 0 Jan 27 19:42:47 my_machine kernel:
> [  335.025526] BTRFS warning (device sda1): csum failed ino 28472371
> off 4018176 csum 3812080098 expected csum 0 Jan 27 19:42:47
> my_machine kernel: [  335.025531] BTRFS warning (device sda1): csum
> failed ino 28472371 off 4022272 csum 2776681411 expected csum 0 Jan
> 27 19:42:47 my_machine kernel: [  335.025534] BTRFS warning (device
> sda1): csum failed ino 28472371 off 4026368 csum 1179241675 expected
> csum 0 Jan 27 19:42:47 my_machine kernel: [  335.025540] BTRFS
> warning (device sda1): csum failed ino 28472371 off 4030464 csum
> 1256914217 expected csum 0 Jan 27 19:42:47 my_machine kernel:
> [  335.026142] BTRFS warning (device sda1): csum failed ino 28472371
> off 7933952 csum 2695958066 expected csum 0 Jan 27 19:42:47
> my_machine kernel: [  335.026147] BTRFS warning (device sda1): csum
> failed ino 28472371 off 7938048 csum 3260800596 expected csum 0 Jan
> 27 19:42:47 my_machine kernel: [  335.026934] BTRFS warning (device
> sda1): csum failed ino 28472371 off 6156288 csum 4293116449 expected
> csum 0 Jan 27 19:42:47 my_machine kernel: [  335.033249] BTRFS
> warning (device sda1): csum failed ino 28472371 off 8077312 csum
> 4031878292 expected csum 0
> 
> Can these be ignored?
> 
> 
> On 01/25/2017 04:06 PM, Liu Bo wrote:
> > On Mon, Jan 23, 2017 at 03:03:55PM -0500, Matt McKinnon wrote:  
> >> Wondering what to do about this error which says 'reboot needed'.
> >> Has happened a three times in the past week:
> >>  
> >
> > Well, I don't think btrfs's logic here is wrong, the following stack
> > shows that a nfs client has sent a second unlink against the same
> > inode while somehow the inode was not fully deleted by the first
> > unlink.
> >
> > So it'd be good that you could add some debugging information to
> > get us further.
> >
> > Thanks,
> >
> > -liubo
> >  
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.595648] BTRFS error
> >> (device sda1): err add delayed dir index item(index: 23810) into
> >> the deletion tree of the delayed node(root id: 257, inode id:
> >> 2661433, errno: -17) Jan 23 14:16:17 my_machine kernel:
> >> [ 2568.611010] ------------[ cut here ]------------
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.615628] kernel BUG at
> >> fs/btrfs/delayed-inode.c:1557!
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.620942] invalid opcode:
> >> 0000 [#1] SMP
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.624960] Modules linked
> >> in: ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs ipt_REJECT nf_rej
> >> ect_ipv4 xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack
> >> nf_conntrack iptable_filter ip_tables x_tables ipmi_devintf nfsd au
> >> th_rpcgss nfs_acl nfs lockd grace sunrpc fscache intel_rapl sb_edac
> >> edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_int
> >> el kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel
> >> aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper crypt
> >> d dm_multipath joydev mei_me mei lpc_ich ioatdma wmi ipmi_si
> >> ipmi_msghandler btrfs shpchp mac_hid lp parport ses enclosure
> >> scsi_tran sport_sas raid10 raid456 async_raid6_recov async_memcpy
> >> async_pq async_xor async_tx xor raid6_pq libcrc32c igb hid_generic
> >> i2c_algo_ bit raid1 dca usbhid ahci raid0 ptp megaraid_sas
> >> multipath Jan 23 14:16:17 my_machine kernel: [ 2568.697150]  hid
> >> libahci pps_core linear dm_mirror dm_region_hash dm_log
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.702689] CPU: 0 PID: 2440
> >> Comm: nfsd Tainted: G        W       4.9.5-custom #1
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.710166] Hardware name:
> >> Supermicro X9DRH-7TF/7F/iTF/iF/X9DRH-7TF/7F/iTF/iF, BIOS 3.0b 04/28
> >> /2014
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.719207] task:
> >> ffff95a42addab80 task.stack: ffffb9da85330000
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.725124] RIP:
> >> 0010:[<ffffffffc0567ee6>]  [<ffffffffc0567ee6>]
> >> btrfs_delete_delayed_dir_inde
> >> x+0x286/0x290 [btrfs]
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.735604] RSP:
> >> 0018:ffffb9da85333be0 EFLAGS: 00010286
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.740917] RAX:
> >> 0000000000000000 RBX: ffff95a3b104b690 RCX: 0000000000000000
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.748048] RDX:
> >> 0000000000000001 RSI: ffff95a42fc0dcc8 RDI: ffff95a42fc0dcc8
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.755171] RBP:
> >> ffffb9da85333c48 R08: 0000000000000491 R09: 0000000000000000
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.762297] R10:
> >> 0000000000000005 R11: 0000000000000006 R12: ffff95a3b104b6d8
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.769429] R13:
> >> 0000000000005d02 R14: ffff95a82953d800 R15: 00000000ffffffef
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.776555] FS:
> >> 0000000000000000(0000) GS:ffff95a42fc00000(0000)
> >> knlGS:0000000000000000 Jan 23 14:16:17 my_machine kernel:
> >> [ 2568.784639] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.790377] CR2:
> >> 00007f12ea376000 CR3: 00000003e1e07000 CR4: 00000000001406f0
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.797503] Stack:
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.799524]  ffffffff9b7fe5f2
> >> ffff95a3b104b560 0000000000040000 ffff95a3f96b3e80
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.806983]  ffff95a3f96b3e80
> >> 39ff95a814eeeb68 600000000000289c 0000000000005d02
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.814436]  ffff95a3f7457c40
> >> ffff95a3bcb74138 ffff95a814eeeb68 0000000000289c39
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.821891] Call Trace:
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.824343]
> >> [<ffffffff9b7fe5f2>] ? mutex_lock+0x12/0x2f
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.829671]
> >> [<ffffffffc0513488>] __btrfs_unlink_inode+0x198/0x4c0 [btrfs]
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.836555]
> >> [<ffffffffc0516dec>] btrfs_unlink_inode+0x1c/0x40 [btrfs]
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.843086]
> >> [<ffffffffc0516e7b>] btrfs_unlink+0x6b/0xb0 [btrfs]
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.849091]
> >> [<ffffffff9b21ea9a>] vfs_unlink+0xda/0x190
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.854315]
> >> [<ffffffff9b21ac83>] ? lookup_one_len+0xd3/0x130
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.860075]
> >> [<ffffffffc09160ae>] nfsd_unlink+0x16e/0x210 [nfsd]
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.866084]
> >> [<ffffffffc091d63c>] nfsd3_proc_remove+0x7c/0x110 [nfsd]
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.872529]
> >> [<ffffffffc09102a8>] nfsd_dispatch+0xb8/0x1f0 [nfsd]
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.878641]
> >> [<ffffffffc064e68f>] svc_process_common+0x43f/0x700 [sunrpc]
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.885432]
> >> [<ffffffffc064f80c>] svc_process+0xfc/0x1c0 [sunrpc]
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.891528]
> >> [<ffffffffc090fd00>] nfsd+0xf0/0x160 [nfsd]
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.896838]
> >> [<ffffffffc090fc10>] ? nfsd_destroy+0x60/0x60 [nfsd]
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.902931]
> >> [<ffffffff9b09cd4a>] kthread+0xca/0xe0
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.907807]
> >> [<ffffffff9b09cc80>] ? kthread_park+0x60/0x60
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.913296]
> >> [<ffffffff9b801075>] ret_from_fork+0x25/0x30
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.918693] Code: ff ff 48
> >> 8b 43 10 49 8b be f0 01 00 00 45 89 f9 4c 8b 03 4c 89 ea 48 c7 c6 f
> >> 0 8f 59 c0 48 8b 88 48 03 00 00 31 c0 e8 ba 36 f7 ff <0f> 0b 0f 1f
> >> 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 53 48
> >> Jan 23 14:16:17 my_machine kernel: [ 2568.938651] RIP
> >> [<ffffffffc0567ee6>] btrfs_delete_delayed_dir_index+0x286/0x290
> >> [btrfs] Jan 23 14:16:17 my_machine kernel: [ 2568.946773]  RSP
> >> <ffffb9da85333be0> Jan 23 14:16:17 my_machine kernel:
> >> [ 2568.996481] ---[ end trace e8c95b69e4ef5f70 ]---
> >> Jan 23 14:16:19 my_machine kernel: [ 2570.503671] BUG: unable to
> >> handle kernel NULL pointer dereference at 0000000000000246
> >> Jan 23 14:16:19 my_machine kernel: [ 2570.511551] IP:
> >> [<ffffffff9b0c0ecb>] __wake_up_common+0x2b/0x90
> >> Jan 23 14:16:19 my_machine kernel: [ 2570.517498] PGD 46a002067
> >> Jan 23 14:16:19 my_machine kernel: [ 2570.520036] PUD 45af9c067
> >> Jan 23 14:16:19 my_machine kernel: [ 2570.522748] PMD 0
> >> Jan 23 14:16:19 my_machine kernel: [ 2570.523284]
> >> Jan 23 14:23:50 riperton kernel: [ 3021.853513]
> >> [<ffffffff9b18407f>] queued_spin_lock_slowpath+0xb/0xf
> >> Jan 23 14:23:50 riperton kernel: [ 3021.859776]
> >> [<ffffffff9b800b80>] _raw_spin_lock+0x20/0x30
> >> Jan 23 14:23:50 riperton kernel: [ 3021.865261]
> >> [<ffffffff9b27c0bd>] pid_revalidate+0x4d/0xf0
> >> Jan 23 14:23:50 riperton kernel: [ 3021.870747]
> >> [<ffffffff9b21a74b>] lookup_fast+0x29b/0x2c0
> >> Jan 23 14:23:50 riperton kernel: [ 3021.876147]
> >> [<ffffffff9b21d7c2>] path_openat+0x172/0x1370
> >> Jan 23 14:16:19 my_machine kernel: [ 2570.524789] Oops: 0000 [#2]
> >> SMP Jan 23 14:16:19 my_machine kernel: [ 2570.527932] Modules
> >> linked in: ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs
> >> ipt_REJECT nf_reject_ipv4 xt_tcpudp nf_conntrack_ipv4
> >> nf_defrag_ipv4 xt_conntrack nf_conntrack iptable_filter ip_tables
> >> x_tables ipmi_devintf nfsd auth_rpcgss nfs_acl nfs lockd grace
> >> sunrpc fscache intel_rapl sb_edac edac_core x86_pkg_temp_thermal
> >> intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul
> >> crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw
> >> gf128mul glue_helper ablk_helper cryptd dm_multipath joydev mei_me
> >> mei lpc_ich ioatdma wmi ipmi_si ipmi_msghandler btrfs shpchp
> >> mac_hid lp parport ses enclosure scsi_transport_sas raid10 raid456
> >> async_raid6_recov async_memcpy async_pq async_xor async_tx xor
> >> raid6_pq libcrc32c igb hid_generic i2c_algo_bit raid1 dca usbhid
> >> ahci raid0 ptp megaraid_sas multipath Jan 23 14:16:19 my_machine
> >> kernel: [ 2570.600135]  hid libahci pps_core linear dm_mirror
> >> dm_region_hash dm_log Jan 23 14:16:19 my_machine kernel:
> >> [ 2570.605651] CPU: 2 PID: 2440 Comm: nfsd Tainted: G      D
> >> W       4.9.5-custom #1 Jan 23 14:16:19 my_machine kernel:
> >> [ 2570.613128] Hardware name: Supermicro
> >> X9DRH-7TF/7F/iTF/iF/X9DRH-7TF/7F/iTF/iF, BIOS 3.0b 04/28/2014 Jan
> >> 23 14:16:19 my_machine kernel: [ 2570.622168] task:
> >> ffff95a42addab80 task.stack: ffffb9da85330000 Jan 23 14:16:19
> >> my_machine kernel: [ 2570.628085] RIP: 0010:[<ffffffff9b0c0ecb>]
> >> [<ffffffff9b0c0ecb>] __wake_up_common+0x2b/0x90 Jan 23 14:16:19
> >> my_machine kernel: [ 2570.636451] RSP: 0018:ffffb9da85333e58
> >> EFLAGS: 00010082 Jan 23 14:16:19 my_machine kernel: [ 2570.641762]
> >> RAX: 0000000000000282 RBX: ffffb9da85333f18 RCX: 0000000000000000
> >> Jan 23 14:16:19 my_machine kernel: [ 2570.648897] RDX:
> >> 0000000000000246 RSI: 0000000000000003 RDI: ffffb9da85333f18 Jan
> >> 23 14:16:19 my_machine kernel: [ 2570.656028] RBP:
> >> ffffb9da85333e90 R08: 0000000000000000 R09: ffff95a429c7ba00 Jan
> >> 23 14:16:19 my_machine kernel: [ 2570.663162] R10:
> >> 000002567df4f057 R11: 0000000000000001 R12: ffffb9da85333f20 Jan
> >> 23 14:16:19 my_machine kernel: [ 2570.670295] R13:
> >> 0000000000000282 R14: 0000000000000000 R15: 0000000000000003 Jan
> >> 23 14:16:19 my_machine kernel: [ 2570.677427] FS:
> >> 0000000000000000(0000) GS:ffff95a42fd00000(0000)
> >> knlGS:0000000000000000 Jan 23 14:16:19 my_machine kernel:
> >> [ 2570.685513] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >> Jan 23 14:16:19 my_machine kernel: [ 2570.691261] CR2:
> >> 0000000000000246 CR3: 000000045a400000 CR4: 00000000001406e0 Jan
> >> 23 14:16:19 my_machine kernel: [ 2570.698393] Stack: Jan 23
> >> 14:16:19 my_machine kernel: [ 2570.700411]  0000000100000246
> >> 0000000000000000 ffffb9da85333f18 ffffb9da85333f10 Jan 23 14:16:19
> >> my_machine kernel: [ 2570.707865]  0000000000000282
> >> ffff95a42addab80 0000000000000000 ffffb9da85333ea0 Jan 23 14:16:19
> >> my_machine kernel: [ 2570.715326]  ffffffff9b0c0f43
> >> ffffb9da85333ec8 ffffffff9b0c1967 ffff95a42addb2a8 Jan 23 14:16:19
> >> my_machine kernel: [ 2570.722797] Call Trace: Jan 23 14:16:19
> >> my_machine kernel: [ 2570.725267]  [<ffffffff9b0c0f43>]
> >> __wake_up_locked+0x13/0x20 Jan 23 14:16:19 my_machine kernel:
> >> [ 2570.730923]  [<ffffffff9b0c1967>] complete+0x37/0x50
> >> Jan 23 14:16:19 my_machine kernel: [ 2570.735892]
> >> [<ffffffff9b07a74f>] mm_release+0xbf/0x140
> >> Jan 23 14:16:19 my_machine kernel: [ 2570.741113]
> >> [<ffffffff9b08168a>] do_exit+0x13a/0xad0
> >> Jan 23 14:16:19 my_machine kernel: [ 2570.746169]
> >> [<ffffffff9b802627>] rewind_stack_do_exit+0x17/0x20
> >> Jan 23 14:16:19 my_machine kernel: [ 2570.752170] Code: 0f 1f 44
> >> 00 00 55 48 89 e5 41 57 41 89 f7 41 56 41 89 ce 41 55 41 54 4c 8d
> >> 67 08 53 48 83 ec 10 89 55 cc 48 8b 57 08 4c 89 45 d0 <48> 8b 0a
> >> 49 39 d4 48 8d 42 e8 4c 8d 69 e8 75 08 eb 38 4c 89 e8
> >> Jan 23 14:16:19 my_machine kernel: [ 2570.772172] RIP
> >> [<ffffffff9b0c0ecb>] __wake_up_common+0x2b/0x90
> >> Jan 23 14:16:19 my_machine kernel: [ 2570.778196]  RSP
> >> <ffffb9da85333e58> Jan 23 14:16:19 my_machine kernel:
> >> [ 2570.781680] CR2: 0000000000000246 Jan 23 14:16:19 my_machine
> >> kernel: [ 2570.784993] ---[ end trace e8c95b69e4ef5f71 ]---
> >> Jan 23 14:16:19 my_machine kernel: [ 2570.794692] Fixing recursive
> >> fault but reboot is needed!
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe
> >> linux-btrfs" in the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at
> >> http://vger.kernel.org/majordomo-info.html  

-- 
Regards,
Kai

Replies to list-only preferred.

