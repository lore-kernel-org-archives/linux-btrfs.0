Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:58493 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbaEPNGe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 May 2014 09:06:34 -0400
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: 3.14.4 Kernel BUG at fs/namei.c : KDE's kate + ecryptfs + BTRFS + LVM2 + LUKS
Date: Fri, 16 May 2014 15:06:24 +0200
Message-ID: <1496827.xlXt6pDnuG@zafu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(I'm not subscribed to linux-kernel, pls copy me on the anwsers)

Hi there,

# uname -a
Linux zafu 3.14.4-1-ARCH #1 SMP PREEMPT Tue May 13 16:41:39 CEST 2014 x86_64 
GNU/Linux

I've seen the same thing happen several times in the last couple of months (so 
with said kernel version + at least 3.13)

Symptom: KDE's kate freezes while saving a small (arbitrary) text file.

(Yes, always KDE's kate and only KDE's kate, while saving a quite small text 
file... Besides this, machine's stability is rock-solid.)

Afterwards the machine remains more or less able to access its filesystems, 
however KDE's Dolphin file manager is usually dead as well.

Underlying is ecryptfs over BTRFS over LVM2 over LUKS (what else ?)

System logs :


kernel: ------------[ cut here ]------------
kernel: kernel BUG at fs/namei.c:2404!
kernel: invalid opcode: 0000 [#1] PREEMPT SMP 
kernel: Modules linked in: nls_iso8859_1 usb_storage ctr ccm md5 fuse ecb 
ecryptfs encrypted_keys sha1_ssse3 sha1_generic hmac trusted nls_utf8 
nls_cp437 vfat fat uvcvideo
kernel:  vboxdrv(O) sha256_ssse3 sha256_generic cbc dm_crypt dm_mod btrfs xor 
raid6_pq hid_multitouch hid_generic hid_logitech_dj usbhid hid sd_mod 
crc_t10dif atkbd libps2
kernel: CPU: 0 PID: 2142 Comm: kate Tainted: G           O 3.14.4-1-ARCH #1
kernel: Hardware name: ASUSTeK COMPUTER INC. X202EV/X202EV, BIOS X202EV.200 
02/27/2013
kernel: task: ffff8800a503bae0 ti: ffff880012dba000 task.ti: ffff880012dba000
kernel: RIP: 0010:[<ffffffff811ca378>]  [<ffffffff811ca378>] may_delete+0x138/0x150
kernel: RSP: 0018:ffff880012dbbd78  EFLAGS: 00010283
kernel: RAX: ffff88006ae82cc0 RBX: ffff8800b0f23d80 RCX: 0000000d00001616
kernel: RDX: 0000000000000000 RSI: ffff8800b0f23d80 RDI: ffff8800ba841568
kernel: RBP: ffff880012dbbd98 R08: 7077732d6574616b R09: ffff8800b0f23c00
kernel: R10: 8080808080808080 R11: fefefefefefefeff R12: ffff8800a3836918
kernel: R13: ffff8800561501b8 R14: ffff8800b0f23d80 R15: ffff8800ba841568
kernel: FS:  00007fe1e2648780(0000) GS:ffff88011ee00000(0000) 
knlGS:0000000000000000
kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kernel: CR2: 00007f2875f70000 CR3: 0000000013ee5000 CR4: 00000000001407f0
kernel: Stack:
kernel:  ffff8800b0f23d80 ffff8800ba841568 ffff8800561501b8 ffff8800b0f23d80
kernel:  ffff880012dbbdd8 ffffffff811ca6db 0000000000000000 ffff8800b0f23d80
kernel:  ffff88006ae82cc0 ffff880012f0e000 ffff88008cc52000 ffff8800ba841568
kernel: Call Trace:
kernel:  [<ffffffff811ca6db>] vfs_unlink+0x2b/0x160
kernel:  [<ffffffffa05afed5>] ecryptfs_do_unlink+0x65/0x120 [ecryptfs]
kernel:  [<ffffffffa05affa2>] ecryptfs_unlink+0x12/0x20 [ecryptfs]
kernel:  [<ffffffff811ca796>] vfs_unlink+0xe6/0x160
kernel:  [<ffffffff811caaa9>] do_unlinkat+0x299/0x300
kernel:  [<ffffffff811bc6fe>] ? ____fput+0xe/0x10
kernel:  [<ffffffff8108c254>] ? task_work_run+0xb4/0xe0
kernel:  [<ffffffff81016c55>] ? do_notify_resume+0x95/0xa0
kernel:  [<ffffffff811cb986>] SyS_unlink+0x16/0x20
kernel:  [<ffffffff81517769>] system_call_fastpath+0x16/0x1b
kernel: Code: 1f 41 5d 83 e0 f0 41 5e 5d c3 66 0f 1f 84 00 00 00 00 00 b8 ff ff 
ff ff eb b1 66 0f 1f 84 00 00 00 00 00 0f 0b 66 0f 1f 44 00 00 <0f> 0b 66 0f 1f 
44 00 00 b8
kernel: RIP  [<ffffffff811ca378>] may_delete+0x138/0x150
kernel:  RSP <ffff880012dbbd78>
kernel: ---[ end trace 73914218811ba28d ]---

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E


