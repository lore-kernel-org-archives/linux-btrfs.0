From: Vincent Vanackere <vincent.vanackere@gmail.com>
Subject: [v3.2-4874-ge4e1118 OOPS] btrfs-related kernel oops due to media
 error
Date: Tue, 10 Jan 2012 17:06:23 +0100
Message-ID: <4F0C61FF.5090709@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Vincent Vanackere <vincent.vanackere@gmail.com>
To: linux-btrfs@vger.kernel.org,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

[Note : this is a resent of a mail I send to linux-btrfs earlier, this 
time tested with the lastest git kernel]

Hi,

One of my disks, partitioned into a single btrfs partition, is showing 
media errors. The problem is that these errors lead to kernel panic from 
btrfs - that make the filesystem unusable until reboot - and therefore 
it is very hard for me to do a full backup of the data prior to changing 
the disk.
My current kernel is a vanilla kernel at current tip (output from git 
describe is v3.2-4874-ge4e1118).
I assume that the filesystem should not panic even in case of a media 
error... Is there any procedure I can follow / patch I could apply to 
salvage my data while ignoring media errors ?

logs/OOPS at the end of this mail, please let me know if more 
information is needed,

Best regards,

Vincent

-----------------------------------------------------------------------

[ 3210.717304] ata6.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[ 3210.717309] ata6.00: BMDMA stat 0x24
[ 3210.717312] ata6.00: failed command: READ DMA EXT
[ 3210.717318] ata6.00: cmd 25/00:08:5f:dc:2f/00:00:70:00:00/e0 tag 0 
dma 4096 in
[ 3210.717320]          res 51/40:00:61:dc:2f/40:00:70:00:00/e0 Emask 
0x9 (media error)
[ 3210.717323] ata6.00: status: { DRDY ERR }
[ 3210.717325] ata6.00: error: { UNC }
[ 3210.732234] ata6.00: configured for UDMA/133
[ 3210.732248] sd 5:0:0:0: [sdd] Unhandled sense code
[ 3210.732250] sd 5:0:0:0: [sdd]  Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3210.732254] sd 5:0:0:0: [sdd]  Sense Key : Medium Error [current] 
[descriptor]
[ 3210.732259] Descriptor sense data with sense descriptors (in hex):
[ 3210.732261]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
[ 3210.732270]         70 2f dc 61
[ 3210.732274] sd 5:0:0:0: [sdd]  Add. Sense: Unrecovered read error - 
auto reallocate failed
[ 3210.732278] sd 5:0:0:0: [sdd] CDB: Read(10): 28 00 70 2f dc 5f 00 00 
08 00
[ 3210.732287] end_request: I/O error, dev sdd, sector 1882184801
[ 3210.732305] ata6: EH complete
[ 3210.732322] BUG: unable to handle kernel NULL pointer dereference at 
           (null)
[ 3210.732373] IP: [<ffffffffa017f129>] extent_range_uptodate+0x59/0xe0 
[btrfs]
[ 3210.732426] PGD 21e9b7067 PUD 21e9b6067 PMD 0
[ 3210.732455] Oops: 0000 [#1] SMP
[ 3210.732475] CPU 3
[ 3210.732486] Modules linked in: ip6table_filter ip6_tables 
ipt_MASQUERADE bnep iptable_nat nf_nat rfcomm bluetooth 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT 
xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables 
bridge stp kvm_intel kvm parport_pc ppdev nfsd nfs lockd fscache 
binfmt_misc auth_rpcgss nfs_acl sunrpc dm_crypt snd_usb_audio 
snd_usbmidi_lib joydev snd_hda_codec_realtek snd_hda_intel snd_hda_codec 
snd_hwdep snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq 
snd_timer snd_seq_device snd soundcore snd_page_alloc psmouse serio_raw 
cdc_acm lp parport btrfs zlib_deflate libcrc32c hid_logitech ff_memless 
usbhid hid i915 drm_kms_helper drm r8169 i2c_algo_bit video pata_jmicron
[ 3210.732870]
[ 3210.732880] Pid: 3856, comm: btrfs-endio-met Not tainted 3.2.0-custom 
#2 Gigabyte Technology Co., Ltd. G33-DS3R/G33-DS3R
[ 3210.732933] RIP: 0010:[<ffffffffa017f129>]  [<ffffffffa017f129>] 
extent_range_uptodate+0x59/0xe0 [btrfs]
[ 3210.732989] RSP: 0018:ffff880006f3fde0  EFLAGS: 00010246
[ 3210.733014] RAX: 0000000000000000 RBX: 000000df57385000 RCX: 
0000000000000000
[ 3210.733047] RDX: 0000000000000001 RSI: 000000000df57385 RDI: 
0000000000000000
[ 3210.733079] RBP: ffff880006f3fe00 R08: 0000000000000000 R09: 
ffff88008bce5200
[ 3210.733111] R10: ffff8800299f9010 R11: 0000000000001000 R12: 
ffff8802190f4030
[ 3210.733143] R13: 000000df573853ff R14: ffff880006f3fe98 R15: 
ffff880143263d88
[ 3210.733175] FS:  0000000000000000(0000) GS:ffff88022fd80000(0000) 
knlGS:0000000000000000
[ 3210.733212] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 3210.733238] CR2: 0000000000000000 CR3: 000000021f35a000 CR4: 
00000000000406e0
[ 3210.733270] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[ 3210.733302] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[ 3210.733334] Process btrfs-endio-met (pid: 3856, threadinfo 
ffff880006f3e000, task ffff8801fa8d8000)
[ 3210.733374] Stack:
[ 3210.733385]  0000000000000000 ffff8800298dd838 ffff8801f9cc9840 
ffff88021ee05000
[ 3210.733423]  ffff880006f3fe30 ffffffffa01581f9 ffff880143263d80 
ffff8800298dd860
[ 3210.733461]  ffff880143263d80 ffff880143263d98 ffff880006f3fee0 
ffffffffa0187fef
[ 3210.733499] Call Trace:
[ 3210.733524]  [<ffffffffa01581f9>] end_workqueue_fn+0x119/0x140 [btrfs]
[ 3210.733567]  [<ffffffffa0187fef>] worker_loop+0x16f/0x5d0 [btrfs]
[ 3210.733608]  [<ffffffffa0187e80>] ? btrfs_queue_worker+0x310/0x310 
[btrfs]
[ 3210.733643]  [<ffffffff8106fa93>] kthread+0x93/0xa0
[ 3210.733668]  [<ffffffff8162caa4>] kernel_thread_helper+0x4/0x10
[ 3210.733697]  [<ffffffff8106fa00>] ? 
kthread_freezable_should_stop+0x70/0x70
[ 3210.733729]  [<ffffffff8162caa0>] ? gs_change+0x13/0x13
[ 3210.733752] Code: 01 f0 48 09 f0 a9 ff 0f 00 00 75 4e 49 39 dd b8 01 
00 00 00 72 36 0f 1f 40 00 49 8b 7c 24 18 48 89 de 48 c1 ee 0c e8 17 38 
f9 e0 <48> 8b 10 83 e2 08 74 5f 48 89 c7 48 81 c3 00 10 00 00 e8 f0 f7
[ 3210.733919] RIP  [<ffffffffa017f129>] extent_range_uptodate+0x59/0xe0 
[btrfs]
[ 3210.733965]  RSP <ffff880006f3fde0>
[ 3210.736202] CR2: 0000000000000000
[ 3210.805459] ---[ end trace 06f41a860c47870b ]---
