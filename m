From: Vincent Vanackere <vincent.vanackere@gmail.com>
Subject: [BUG - btrfs] kernel oops in extent_range_uptodate
Date: Thu, 19 Jan 2012 15:42:53 +0100
Message-ID: <4F182BED.3090009@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Vincent Vanackere <vincent.vanackere@gmail.com>
To: linux-btrfs@vger.kernel.org,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

With the most current git kernel 
(90a4c0f51e8e44111a926be6f4c87af3938a79c3) I'm still getting the same 
reproducible kernel panic when trying to read a particular file stored 
on a btrfs filesystem (as seen in the log there are indeed disk media 
errors on this disk).
I'd like the "software" part of this to be fixed - btrfs should 
definitely not oops even in case of media error - before sending the 
disk to RMA. Is there anything I can do to make progress on this ?

Regards,

Vincent

--------------------------------
ata6.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata6.00: BMDMA stat 0x24
ata6.00: failed command: READ DMA EXT
ata6.00: cmd 25/00:08:5f:dc:2f/00:00:70:00:00/e0 tag 0 dma 4096 in
          res 51/40:00:61:dc:2f/40:00:70:00:00/e0 Emask 0x9 (media error)
ata6.00: status: { DRDY ERR }
ata6.00: error: { UNC }
ata6.00: configured for UDMA/133
sd 5:0:0:0: [sdd] Unhandled sense code
sd 5:0:0:0: [sdd]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 5:0:0:0: [sdd]  Sense Key : Medium Error [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
         70 2f dc 61
sd 5:0:0:0: [sdd]  Add. Sense: Unrecovered read error - auto reallocate 
failed
sd 5:0:0:0: [sdd] CDB: Read(10): 28 00 70 2f dc 5f 00 00 08 00
end_request: I/O error, dev sdd, sector 1882184801
ata6: EH complete
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffffa0191b09>] extent_range_uptodate+0x59/0xe0 [btrfs]
PGD 221bf8067 PUD 222864067 PMD 0
Oops: 0000 [#1] SMP
CPU 1
Modules linked in: ip6table_filter ip6_tables ipt_MASQUERADE iptable_nat 
nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT 
xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables 
bridge stp kvm_intel kvm parport_pc ppdev dm_crypt nfsd nfs lockd 
fscache auth_rpcgss nfs_acl binfmt_misc sunrpc snd_usb_audio joydev 
snd_usbmidi_lib snd_hda_codec_realtek snd_hda_intel snd_hda_codec 
snd_hwdep snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq 
snd_timer psmouse snd_seq_device serio_raw snd soundcore snd_page_alloc 
lp parport btrfs zlib_deflate libcrc32c hid_logitech ff_memless usbhid 
hid i915 r8169 drm_kms_helper drm pata_jmicron i2c_algo_bit video

Pid: 1003, comm: btrfs-endio-met Not tainted 3.2.0-custom-9429-g90a4c0f 
#3 Gigabyte Technology Co., Ltd. G33-DS3R/G33-DS3R
RIP: 0010:[<ffffffffa0191b09>]  [<ffffffffa0191b09>] 
extent_range_uptodate+0x59/0xe0 [btrfs]
RSP: 0018:ffff88022191dde0  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 000000df57385000 RCX: 0000000000000000
RDX: 0000000000000001 RSI: 000000000df57385 RDI: 0000000000000000
RBP: ffff88022191de00 R08: 0000000000000000 R09: ffff8801da949ae0
R10: ffff8801fda37010 R11: 0000000000001000 R12: ffff88021b4487f0
R13: 000000df573853ff R14: ffff88022191de98 R15: ffff880221ac2ae8
FS:  0000000000000000(0000) GS:ffff88022fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000221bf9000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process btrfs-endio-met (pid: 1003, threadinfo ffff88022191c000, task 
ffff880221b9db80)
Stack:
  0000000000000000 ffff8801fdb64eb8 ffff8802221be840 ffff880220b3e000
  ffff88022191de30 ffffffffa016ad89 ffff880221ac2ae0 ffff8801fdb64ee0
  ffff880221ac2ae0 ffff880221ac2af8 ffff88022191dee0 ffffffffa019c18f
Call Trace:
  [<ffffffffa016ad89>] end_workqueue_fn+0x119/0x140 [btrfs]
  [<ffffffffa019c18f>] worker_loop+0x16f/0x5d0 [btrfs]
  [<ffffffffa019c020>] ? btrfs_queue_worker+0x310/0x310 [btrfs]
  [<ffffffff81070193>] kthread+0x93/0xa0
  [<ffffffff81636f24>] kernel_thread_helper+0x4/0x10
  [<ffffffff81070100>] ? kthread_freezable_should_stop+0x70/0x70
  [<ffffffff81636f20>] ? gs_change+0x13/0x13
Code: 01 f0 48 09 f0 a9 ff 0f 00 00 75 4e 49 39 dd b8 01 00 00 00 72 36 
0f 1f 40 00 49 8b 7c 24 18 48 89 de 48 c1 ee 0c e8 e7 36 f8 e0 <48> 8b 
10 83 e2 08 74 5f 48 89 c7 48 81 c3 00 10 00 00 e8 40 00
RIP  [<ffffffffa0191b09>] extent_range_uptodate+0x59/0xe0 [btrfs]
  RSP <ffff88022191dde0>
CR2: 0000000000000000
---[ end trace 4c48da444d2270f0 ]---
