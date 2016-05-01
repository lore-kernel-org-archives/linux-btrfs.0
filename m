Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51698 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbcEANkd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 1 May 2016 09:40:33 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1awrbq-0001aF-Pb
	for linux-btrfs@vger.kernel.org; Sun, 01 May 2016 15:40:30 +0200
Received: from chello212017088045.1.15.vie.surfer.at ([212.17.88.45])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 01 May 2016 15:40:30 +0200
Received: from wertstoffe by chello212017088045.1.15.vie.surfer.at with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 01 May 2016 15:40:30 +0200
To: linux-btrfs@vger.kernel.org
From: =?UTF-8?Q?Jakob_Sch=c3=bcrz?= <wertstoffe@nurfuerspam.de>
Subject: apt taints kernel - btrfs destroys inode
Date: Sun, 1 May 2016 15:38:22 +0200
Message-ID: <efdhvc-3p8.ln1@aldebaran.xundeenergie.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

What does this mean???

Mai 01 15:36:42 aldebaran kernel: ------------[ cut here ]------------
Mai 01 15:36:42 aldebaran kernel: WARNING: CPU: 3 PID: 8937 at
/build/linux-aGlcVo/linux-4.6~rc3/fs/btrfs/inode.c:9261
btrfs_destroy_inode+0x234/0x2a0 [btrfs]
Mai 01 15:36:42 aldebaran kernel: Modules linked in: cpuid(E)
udp_diag(E) tcp_diag(E) inet_diag(E) ip_set_hash_net(E) ip_set(E)
nfnetlink(E) uas(E) usb_storage(E) rfcomm(E) xt_multiport(E) ctr(E)
ccm(E) bnep(E)
Mai 01 15:36:42 aldebaran kernel:  videobuf2_v4l2(E) rtlwifi(E)
joydev(E) videobuf2_core(E) mac80211(E) videodev(E) media(E) cfg80211(E)
rtsx_pci_ms(E) memstick(E) battery(E) parport_pc(E) 8250_fintek(E) snd_hda
Mai 01 15:36:42 aldebaran kernel:  ppdev(E) lp(E) parport(E) efivarfs(E)
autofs4(E) btrfs(E) crc32c_generic(E) xor(E) raid6_pq(E) sr_mod(E)
cdrom(E) sd_mod(E) hid_generic(E) usbhid(E) hid(E) rtsx_pci_sdmmc(E) mm
Mai 01 15:36:42 aldebaran kernel: CPU: 3 PID: 8937 Comm: apt-get
Tainted: G     U  W   E   4.6.0-rc3-amd64 #1 Debian 4.6~rc3-1~exp1
Mai 01 15:36:42 aldebaran kernel: Hardware name: Hewlett-Packard  /2248,
BIOS M74 Ver. 01.08 12/12/2014
Mai 01 15:36:42 aldebaran kernel:  0000000000000286 00000000bf954d90
ffffffff81310e95 0000000000000000
Mai 01 15:36:42 aldebaran kernel:  0000000000000000 ffffffff8107a4ee
ffff88004dd46180 ffff88010c9f7dc8
Mai 01 15:36:42 aldebaran kernel:  ffff8800a09eb800 ffff88010c9f7dc8
ffff880008b87058 ffff88010c9f7dc8
Mai 01 15:36:42 aldebaran kernel: Call Trace:
Mai 01 15:36:42 aldebaran kernel:  [<ffffffff81310e95>] ?
dump_stack+0x5c/0x77
Mai 01 15:36:42 aldebaran kernel:  [<ffffffff8107a4ee>] ? __warn+0xbe/0xe0
Mai 01 15:36:42 aldebaran kernel:  [<ffffffffc04fed34>] ?
btrfs_destroy_inode+0x234/0x2a0 [btrfs]
Mai 01 15:36:42 aldebaran kernel:  [<ffffffff81207b98>] ?
__dentry_kill+0x178/0x1d0
Mai 01 15:36:42 aldebaran kernel:  [<ffffffff81207d0b>] ? dput+0x11b/0x210
Mai 01 15:36:42 aldebaran kernel:  [<ffffffff811f2dd4>] ? __fput+0x164/0x1e0
Mai 01 15:36:42 aldebaran kernel:  [<ffffffff81097431>] ?
task_work_run+0x71/0x90
Mai 01 15:36:42 aldebaran kernel:  [<ffffffff8100333a>] ?
exit_to_usermode_loop+0xba/0xc0
Mai 01 15:36:42 aldebaran kernel:  [<ffffffff81003c05>] ?
syscall_return_slowpath+0x45/0x50
Mai 01 15:36:42 aldebaran kernel:  [<ffffffff815c44fe>] ?
system_call_fast_compare_end+0x94/0x96
Mai 01 15:36:42 aldebaran kernel: ---[ end trace 6c4d524799d6f2a2 ]---

-- 
http://xundeenergie.at
http://verkehrsloesungen.wordpress.com/
http://cogitationum.wordpress.com/

