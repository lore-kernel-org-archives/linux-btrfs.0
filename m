Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:42207 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab2HaNvm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Aug 2012 09:51:42 -0400
Received: by qcro28 with SMTP id o28so2042166qcr.19
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2012 06:51:41 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 31 Aug 2012 20:51:41 +0700
Message-ID: <CAG1y0sc4twuEtdL2D1C6Gf4-Uzut=y1ifn-JE=Gc+QKs+PwjvA@mail.gmail.com>
Subject: oops with btrfs on zvol
From: "Fajar A. Nugraha" <list@fajar.net>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm experimenting with btrfs on top of zvol block device (using
zfsonlinux), and got oops on a simple mount test.

While I'm sure that zfsonlinux is somehow also at fault here (since
the same test with zram works fine), the oops only shows things
btrfs-related without any usable mention of zfs/zvol. Could anyone
help me interpret the kernel logs, which btrfs-zvol interaction is at
fault, so I can pass it on to zfs guys to work on their side as well?
Thanks.

The test is creating a sparse 100G block device (zfs create -V 100G -s
-o volblocksize=4k rpool/vbd/test1), format it (mkfs.btrfs
/dev/zvol/rpool/vbd/test1), and mount it. Oops occured, and the mount
process stuck. Same thing happens on ubuntu precise's kernel 3.2 and
quantal's 3.5.

What's interesting is:
- if I use ext4 (instead of btrfs) on the zvol, it works just fine
- if I add a layer on top of zvol (losetup, or iscsi export-import)
then btrfs works just fine.

Syslog shows this (from Ubuntu's 3.2 kernel):

#=====
Aug 31 20:30:13 DELL kernel: [34307.828311]  zd0: unknown partition table
Aug 31 20:30:34 DELL kernel: [34328.129249] device fsid
cfd88ff9-def8-4d1f-9435-65becd5fa2b7 devid 1 transid 4 /dev/zd0
Aug 31 20:30:34 DELL kernel: [34328.134001] btrfs: disk space caching is enabled
Aug 31 20:30:34 DELL kernel: [34328.135701] BUG: unable to handle
kernel NULL pointer dereference at           (null)
Aug 31 20:30:34 DELL kernel: [34328.137200] IP: [<ffffffffa0068439>]
extent_range_uptodate+0x59/0xe0 [btrfs]
Aug 31 20:30:34 DELL kernel: [34328.138759] PGD 0
Aug 31 20:30:34 DELL kernel: [34328.140248] Oops: 0000 [#1] SMP
Aug 31 20:30:34 DELL kernel: [34328.141777] CPU 3
Aug 31 20:30:34 DELL kernel: [34328.141811] Modules linked in: ses
enclosure ppp_mppe ppp_async crc_ccitt pci_stub vboxpci(O)
vboxnetadp(O) vboxnetflt
(O) vboxdrv(O) arc4 ath9k mac80211 radeon uvcvideo snd_hda_codec_hdmi
ath9k_common snd_hda_codec_realtek ath9k_hw videodev ipt_MASQUERADE
xt_state ipt
able_nat nf_nat v4l2_compat_ioctl32 i915 nf_conntrack_ipv4
nf_conntrack iptable_filter nf_defrag_ipv4 ip_tables dm_multipath
dummy x_tables bnep ath3k
 btusb bridge rfcomm bluetooth snd_hda_intel snd_hda_codec stp joydev
ath snd_hwdep ttm snd_pcm mei(C) drm_kms_helper drm snd_seq_midi
snd_rawmidi snd
_seq_midi_event dell_wmi sparse_keymap snd_seq dell_laptop wmi
snd_timer i2c_algo_bit video psmouse snd_seq_device cfg80211 snd
mac_hid serio_raw soun
dcore dcdbas snd_page_alloc parport_pc ppdev lp parport binfmt_misc
zfs(P) zcommon(P) znvpair(P) zavl(P) zunicode(P) spl(O) ums_realtek
uas r8169 btrf
s zlib_deflate libcrc32c usb_storage
Aug 31 20:30:34 DELL kernel: [34328.155820]
Aug 31 20:30:34 DELL kernel: [34328.157974] Pid: 15887, comm:
btrfs-endio-met Tainted: P         C O 3.2.0-29-generic #46-Ubuntu
Dell Inc.          De
ll System Inspiron N4110/03NKW8
Aug 31 20:30:34 DELL kernel: [34328.160283] RIP:
0010:[<ffffffffa0068439>]  [<ffffffffa0068439>]
extent_range_uptodate+0x59/0xe0 [btrfs]
Aug 31 20:30:34 DELL kernel: [34328.162700] RSP: 0018:ffff8800351dfde0
 EFLAGS: 00010246
Aug 31 20:30:34 DELL kernel: [34328.165099] RAX: 0000000000000000 RBX:
0000000001401000 RCX: 0000000000000000
Aug 31 20:30:34 DELL kernel: [34328.167548] RDX: 0000000000000001 RSI:
0000000000001401 RDI: 0000000000000000
Aug 31 20:30:34 DELL kernel: [34328.169989] RBP: ffff8800351dfe00 R08:
0000000000000000 R09: ffff880067021418
Aug 31 20:30:34 DELL kernel: [34328.172474] R10: ffff8800b680d010 R11:
0000000000001000 R12: ffff88011d997bf0
Aug 31 20:30:34 DELL kernel: [34328.174922] R13: 0000000001401fff R14:
ffff880031c45c00 R15: ffff88011aedc9b0
Aug 31 20:30:34 DELL kernel: [34328.177401] FS:
0000000000000000(0000) GS:ffff88013e6c0000(0000)
knlGS:0000000000000000
Aug 31 20:30:34 DELL kernel: [34328.179904] CS:  0010 DS: 0000 ES:
0000 CR0: 000000008005003b
Aug 31 20:30:34 DELL kernel: [34328.182426] CR2: 0000000000000000 CR3:
00000001291e0000 CR4: 00000000000406e0
Aug 31 20:30:34 DELL kernel: [34328.185005] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Aug 31 20:30:34 DELL kernel: [34328.187602] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Aug 31 20:30:34 DELL kernel: [34328.190246] Process btrfs-endio-met
(pid: 15887, threadinfo ffff8800351de000, task ffff880031c45c00)
Aug 31 20:30:34 DELL kernel: [34328.193171] Stack:
Aug 31 20:30:34 DELL kernel: [34328.196542]  ffff8800351dfdf0
ffff880088ff6638 ffff8800b61953c0 ffff88011cbbb000
Aug 31 20:30:34 DELL kernel: [34328.199469]  ffff8800351dfe10
ffffffffa004224d ffff8800351dfe40 ffffffffa00422d6
Aug 31 20:30:34 DELL kernel: [34328.202295]  ffff8800351dfe88
ffff88011aedc960 ffff8800351dfe88 ffff8800351dfe98
Aug 31 20:30:34 DELL kernel: [34328.204685] Call Trace:
Aug 31 20:30:34 DELL kernel: [34328.206645]  [<ffffffffa004224d>]
bio_ready_for_csum.isra.107+0xbd/0xc0 [btrfs]
Aug 31 20:30:34 DELL kernel: [34328.208591]  [<ffffffffa00422d6>]
end_workqueue_fn+0x86/0xa0 [btrfs]
Aug 31 20:30:34 DELL kernel: [34328.210565]  [<ffffffffa00714e0>]
worker_loop+0xa0/0x2b0 [btrfs]
Aug 31 20:30:34 DELL kernel: [34328.212531]  [<ffffffff8165737c>] ?
__schedule+0x3cc/0x6f0
Aug 31 20:30:34 DELL kernel: [34328.214540]  [<ffffffffa0071440>] ?
check_pending_worker_creates.isra.1+0xf0/0xf0 [btrfs]
Aug 31 20:30:34 DELL kernel: [34328.216563]  [<ffffffff81089fbc>]
kthread+0x8c/0xa0
Aug 31 20:30:34 DELL kernel: [34328.218604]  [<ffffffff81664034>]
kernel_thread_helper+0x4/0x10
Aug 31 20:30:34 DELL kernel: [34328.220886]  [<ffffffff81089f30>] ?
flush_kthread_worker+0xa0/0xa0
Aug 31 20:30:34 DELL kernel: [34328.223019]  [<ffffffff81664030>] ?
gs_change+0x13/0x13
Aug 31 20:30:34 DELL kernel: [34328.225103] Code: 01 f0 48 09 f0 a9 ff
0f 00 00 75 4e 49 39 dd b8 01 00 00 00 72 36 0f 1f 40 00 49 8b 7c 24
18 48 89 de 48 c1 ee 0c e8 c7 f3 0a e1 <48> 8b 10 83 e2 08 74 5f 48 89
c7 48 81 c3 00 10 00 00 e8 10 b2
Aug 31 20:30:34 DELL kernel: [34328.229876] RIP  [<ffffffffa0068439>]
extent_range_uptodate+0x59/0xe0 [btrfs]
Aug 31 20:30:34 DELL kernel: [34328.232272]  RSP <ffff8800351dfde0>
Aug 31 20:30:34 DELL kernel: [34328.234619] CR2: 0000000000000000
Aug 31 20:30:34 DELL kernel: [34328.246500] ---[ end trace 1744873168fb9394 ]---
#====

-- 
Fajar
