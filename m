From: Jan Engelhardt <jengelh@medozas.de>
Subject: scrub status causes Oops
Date: Fri, 13 Apr 2012 13:59:01 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1204131356030.15362@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


# df
/dev/sdd                5860554336 2651644680  20368600 100% /top.srv
# btrfs scrub status /top.srv
[ 4877.298065] BUG: unable to handle kernel NULL pointer dereference at           (null)
[ 4877.298122] IP: [<ffffffff811f4103>] strncpy+0x7/0x1f
[ 4877.298159] PGD 193cc067 PUD accb067 PMD 0 
[ 4877.298191] Oops: 0000 [#1] SMP 
[ 4877.298217] CPU 3 
[ 4877.298224] Modules linked in: f71882fg nfs fscache nfsd lockd auth_rpcgss nfs_acl sunrpc bonding mperf btrfs zlib_deflate i915 drm_kms_helper sg drm r8169 coretemp i2c_i801 i2c_algo_bit i2c_core pcspkr intel_agp iTCO_wdt snd_hda_codec_realtek iTCO_vendor_support snd_hda_intel snd_hda_codec mii snd_hwdep intel_gtt agpgart snd_pcm snd_timer snd soundcore snd_page_alloc rng_core video microcode button autofs4 raid456 async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx raid10 raid0 raid1 md_mod uhci_hcd ehci_hcd usbcore usb_common processor thermal_sys hwmon
[ 4877.298556] 
[ 4877.298577] Pid: 3817, comm: btrfs Not tainted 3.3.1-jng5-default #1 MICRO-STAR INTERNATIONAL CO.,LTD RX945GC/RX945GC
[ 4877.298628] RIP: 0010:[<ffffffff811f4103>]  [<ffffffff811f4103>] strncpy+0x7/0x1f
[ 4877.298674] RSP: 0018:ffff88000a397e40  EFLAGS: 00010287
[ 4877.298700] RAX: ffff88000a2a2c00 RBX: ffff88000a2a2000 RCX: 0000000000000000
[ 4877.298727] RDX: 0000000000000400 RSI: 0000000000000000 RDI: ffff88000a2a2c00
[ 4877.298754] RBP: ffff88000a2a2008 R08: 0000000000000000 R09: 0000000000000000
[ 4877.298783] R10: 0000000000000000 R11: 0000000000000000 R12: 000000000204b920
[ 4877.298811] R13: 00000000ffffffed R14: ffff88003d31f000 R15: 0000000000000000
[ 4877.298842] FS:  00007f0cd68da740(0000) GS:ffff88003f74d000(0000) knlGS:0000000000000000
[ 4877.298883] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4877.298908] CR2: 0000000000000000 CR3: 000000000ad34000 CR4: 00000000000006e0
[ 4877.298937] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 4877.298966] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 4877.298995] Process btrfs (pid: 3817, threadinfo ffff88000a396000, task ffff88000a0de140)
[ 4877.299034] Stack:
[ 4877.299054]  ffffffffa034af41 0000000000000000 0000000000000000 0000002900000286
[ 4877.299105]  ffff880012760400 000000000204b920 00000000d000941e ffff880037b87280
[ 4877.299154]  0000000002048920 0000000000000004 ffffffffa034e8a2 ffff88000fd651f0
[ 4877.299202] Call Trace:
[ 4877.299312]  [<ffffffffa034af41>] btrfs_ioctl_dev_info+0x101/0x13b [btrfs]
[ 4877.299709]  [<ffffffffa034e8a2>] btrfs_ioctl+0x3d8/0x6d6 [btrfs]
[ 4877.300014]  [<ffffffff8110de13>] do_vfs_ioctl+0x240/0x254
[ 4877.300014]  [<ffffffff8110de72>] sys_ioctl+0x4b/0x71
[ 4877.300014]  [<ffffffff813db839>] system_call_fastpath+0x16/0x1b
[ 4877.300014]  [<00007f0cd5fea837>] 0x7f0cd5fea836
[ 4877.300014] Code: 39 c4 74 d3 5b 41 29 c4 5d 44 89 e0 41 5c 41 5d c3 48 89 f8 31 d2 8a 0c 16 88 0c 10 48 ff c2 84 c9 75 f3 c3 48 89 f8 31 c9 eb 12 <40> 8a 3e 40 80 ff 01 40 88 3c 08 48 83 de ff 48 ff c1 48 39 d1 
[ 4877.300014] RIP  [<ffffffff811f4103>] strncpy+0x7/0x1f
[ 4877.300014]  RSP <ffff88000a397e40>
[ 4877.300014] CR2: 0000000000000000
[ 4877.300780] ---[ end trace 311aa451913a4064 ]---

btrfsprogs identifies itself only as "v0.19+".

It took me looking into the srpm to determine
the commit it is based on, btrfs-progs-v0.19-35-g1b444cd.tar.bz2.
