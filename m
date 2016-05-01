Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout3.freenet.de ([195.4.92.93]:39758 "EHLO mout3.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbcEAPMY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 1 May 2016 11:12:24 -0400
Received: from [195.4.92.142] (helo=mjail2.freenet.de)
	by mout3.freenet.de with esmtpa (ID master.b.at.raven@chefmail.de) (port 25) (Exim 4.85 #1)
	id 1awswF-0005pW-Gd
	for linux-btrfs@vger.kernel.org; Sun, 01 May 2016 17:05:39 +0200
Received: from localhost ([::1]:36860 helo=mjail2.freenet.de)
	by mjail2.freenet.de with esmtpa (ID master.b.at.raven@chefmail.de) (Exim 4.85 #1)
	id 1awswF-0000ow-CL
	for linux-btrfs@vger.kernel.org; Sun, 01 May 2016 17:05:39 +0200
Received: from mx6.freenet.de ([195.4.92.16]:53559)
	by mjail2.freenet.de with esmtpa (ID master.b.at.raven@chefmail.de) (Exim 4.85 #1)
	id 1awstE-0004vE-8N
	for linux-btrfs@vger.kernel.org; Sun, 01 May 2016 17:02:32 +0200
Received: from ppp-88-217-28-31.dynamic.mnet-online.de ([88.217.28.31]:64241 helo=[192.168.1.164])
	by mx6.freenet.de with esmtpsa (ID master.b.at.raven@chefmail.de) (TLSv1.2:DHE-RSA-AES128-SHA:128) (port 587) (Exim 4.85 #1)
	id 1awstD-0006ah-UG
	for linux-btrfs@vger.kernel.org; Sun, 01 May 2016 17:02:32 +0200
Reply-To: g6094199@freenet.de
To: linux-btrfs@vger.kernel.org
From: "." <master.b.at.raven@chefmail.de>
Subject: Balance kernel bug in 4.6- rc
Message-ID: <0f6134a8-1113-51d0-fbf7-b0020e1cf34d@chefmail.de>
Date: Sun, 1 May 2016 17:02:26 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

He Guys!


I think i found a bug in:

uname -a
Linux NAS 4.6.0-rc3-amd64 #1 SMP Debian 4.6~rc3-1~exp1 (2016-04-14) 
x86_64 GNU/Linux


The fliesystem has some corrupt sectors caused by an faulty drive.

While adding a new drive, removing the damaged failed, I had some 
success with the replace command.

Balancing fails now.

The kernel message is as follows:

[  747.642497] BTRFS info (device sdb2): disk space caching is enabled
[  747.648272] BTRFS info (device sdb2): bdev /dev/sdc1 errs: wr 2, rd 
0, flush 0, corrupt 633433, gen 0
[  747.673858] BTRFS info (device sdb2): continuing balance
[  748.380758] BTRFS info (device sdb2): relocating block group 
61336453120 flags 1
[  748.412392] BTRFS warning (device sdb2): csum failed ino 257 off 
895795200 csum 2566472073 expected csum 2554651624
[  748.412899] BTRFS warning (device sdb2): csum failed ino 257 off 
895795200 csum 2566472073 expected csum 2554651624
[  748.430037] ------------[ cut here ]------------
[  748.430131] kernel BUG at 
/build/linux-aGlcVo/linux-4.6~rc3/fs/btrfs/volumes.c:3421!
[  748.430256] invalid opcode: 0000 [#1] SMP
[  748.430334] Modules linked in: nfsd(E) auth_rpcgss(E) nfs_acl(E) 
nfs(E) lockd(E) grace(E) fscache(E) sunrpc(E) zram(E) zsmalloc(E) 
lz4_compress(E) i915(E) video(E) ppdev(E) iTCO_wdt(E) 
iTCO_vendor_support(E) drm_kms_helper(E) evdev(E) serio_raw(E) pcspkr(E) 
coretemp(E) i2c_i801(E) drm(E) acpi_cpufreq(E) tpm_tis(E) 
i2c_algo_bit(E) tpm(E) sg(E) parport_pc(E) lpc_ich(E) mfd_core(E) 
parport(E) shpchp(E) 8250_fintek(E) button(E) processor(E) ext4(E) 
crc16(E) jbd2(E) mbcache(E) btrfs(E) crc32c_generic(E) xor(E) 
raid6_pq(E) hid_generic(E) usbhid(E) hid(E) uas(E) usb_storage(E) 
sd_mod(E) ata_generic(E) ehci_pci(E) ahci(E) pata_jmicron(E) libahci(E) 
uhci_hcd(E) ehci_hcd(E) usbcore(E) libata(E) usb_common(E) scsi_mod(E) 
r8169(E) mii(E) fjes(E)
[  748.431644] CPU: 3 PID: 2325 Comm: btrfs-balance Tainted: 
G            E   4.6.0-rc3-amd64 #1 Debian 4.6~rc3-1~exp1
[  748.431807] Hardware name: Gigabyte Technology Co., Ltd. 
D525TUD/D525TUD, BIOS F5 06/20/2011
[  748.431942] task: ffff88013abdc080 ti: ffff8800ba5c0000 task.ti: 
ffff8800ba5c0000
[  748.432060] RIP: 0010:[<ffffffffc02bbfc8>] [<ffffffffc02bbfc8>] 
btrfs_balance+0x1038/0x11c0 [btrfs]
[  748.432262] RSP: 0018:ffff8800ba5c3d98  EFLAGS: 00010282
[  748.432348] RAX: 00000000fffffffb RBX: cccccccccccccccd RCX: 
0000000000000000
[  748.432462] RDX: 0000000000000001 RSI: 0000000000100000 RDI: 
ffff8801391d4740
[  748.432575] RBP: ffff880036830670 R08: 0000000000000000 R09: 
ffff8800ba1f26c0
[  748.432688] R10: 0000000000000000 R11: ffffffff81b05740 R12: 
ffff880139bab000
[  748.432801] R13: 0000000000000000 R14: 000000007f700000 R15: 
ffff8801391d4000
[  748.432915] FS:  0000000000000000(0000) GS:ffff88013fd80000(0000) 
knlGS:0000000000000000
[  748.433043] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  748.433043] CR2: 0000000001f8c808 CR3: 00000000ba8c2000 CR4: 
00000000000006e0
[  748.433043] Stack:
[  748.433043]  ffff8800bb0a5000 ffff880036341600 0000000000000000 
ffff8800b8b20000
[  748.433043]  ffff88013ab46508 ffff8800baf38d68 ffffffff8116f85f 
ffff880036341600
[  748.433043]  ffff8800ba5c3e38 ffff8800ba5c3df0 0000000070f7f732 
0000000000000721
[  748.433043] Call Trace:
[  748.433043]  [<ffffffff8116f85f>] ? printk+0x57/0x73
[  748.433043]  [<ffffffffc025fe7d>] ? btrfs_printk+0x8d/0xf0 [btrfs]
[  748.433043]  [<ffffffffc02bc1a6>] ? balance_kthread+0x56/0x80 [btrfs]
[  748.433043]  [<ffffffffc02bc150>] ? btrfs_balance+0x11c0/0x11c0 [btrfs]
[  748.433043]  [<ffffffff81098e1d>] ? kthread+0xcd/0xf0
[  748.433043]  [<ffffffff815c46b2>] ? ret_from_fork+0x22/0x40
[  748.433043]  [<ffffffff81098d50>] ? kthread_create_on_node+0x190/0x190
[  748.433043] Code: 24 70 e8 ec 90 fa ff 8b 44 24 68 85 c0 0f 84 21 fa 
ff ff 8b 54 24 68 48 c7 c6 c0 8e 31 c0 4c 89 ff e8 2d 3e fa ff e9 09 fa 
ff ff <0f> 0b 48 b8 18 00 00 00 00 00 01 00 e9 00 f1 ff ff 0f 0b 4c 89
[  748.433043] RIP  [<ffffffffc02bbfc8>] btrfs_balance+0x1038/0x11c0 [btrfs]
[  748.433043]  RSP <ffff8800ba5c3d98>
[  748.451365] ---[ end trace 5b324cae3a38b34a ]---


The filesystem it OOOOPS:

btrfs fi show /mnt/
Label: none  uuid: 456808c9-5049-44a0-b1d3-17565df6fe11
     Total devices 2 FS bytes used 45.00GiB
     devid    1 size 50.12GiB used 49.31GiB path /dev/sdb2
     devid    2 size 1.99GiB used 1.99GiB path /dev/sdc1

btrfs fi df /mnt/
Data, single: total=48.51GiB, used=43.83GiB
System, single: total=32.00MiB, used=16.00KiB
Metadata, single: total=2.76GiB, used=1.17GiB
GlobalReserve, single: total=400.00MiB, used=0.00B


Maybe this problem is still valid.


regards

sash

