From: "Carlos R. Mafra" <crmafra2@gmail.com>
Subject: [2.6.35.3] BUG: unable to handle kernel NULL pointer dereference
 at (null)
Date: Thu, 26 Aug 2010 11:53:57 +0200
Message-ID: <20100826095357.GA7202@Pilar.aei.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've just got this BUG: message in dmesg which I think is btrfs related.

I have a btrfs filesystem in a memory card which I use to contain the 
cache and config of chromium (to avoid writing to much in the SSD):

/dev/mmcblk0p1 on /home/mafra/mmc type btrfs (rw,noexec,nosuid,nodev,noatime,noacl,compress)

and the last message before the bug is about the memory card.

[  148.149179] mmcblk0: retrying using single block read
[  148.152014] BUG: unable to handle kernel NULL pointer dereference at (null)
[  148.152021] IP: [<ffffffff811b1301>] extent_range_uptodate+0x51/0xa0
[  148.152030] PGD 72c37067 PUD 7d64b067 PMD 0 
[  148.152035] Oops: 0000 [#1] SMP 
[  148.152038] last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
[  148.152041] CPU 1 
[  148.152043] Modules linked in: snd_seq snd_seq_device snd_hda_codec_idt i2c_i801 snd_hda_intel snd_hda_codec sky2 uvcvideo iwlagn snd_hwdep evdev
[  148.152053] 
[  148.152057] Pid: 2731, comm: btrfs-endio-met Not tainted 2.6.35.3+ #12 VAIO/VGN-FZ240E
[  148.152059] RIP: 0010:[<ffffffff811b1301>]  [<ffffffff811b1301>] extent_range_uptodate+0x51/0xa0
[  148.152064] RSP: 0018:ffff880079acddd0  EFLAGS: 00010246
[  148.152066] RAX: 0000000000000000 RBX: 0000000043eba000 RCX: 0000000000000000
[  148.152068] RDX: 0000000000000001 RSI: 0000000000043eba RDI: 0000000000000001
[  148.152071] RBP: ffff880079acddf0 R08: 0000000000000000 R09: 0000000000000000
[  148.152073] R10: 0000000000001000 R11: 0000000000000000 R12: ffff88007b40eb18
[  148.152076] R13: 0000000043ebadff R14: ffff880079ab0000 R15: ffff880079acde80
[  148.152079] FS:  0000000000000000(0000) GS:ffff880001b00000(0000) knlGS:0000000000000000
[  148.152081] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  148.152084] CR2: 0000000000000000 CR3: 0000000070be9000 CR4: 00000000000006e0
[  148.152086] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  148.152088] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  148.152091] Process btrfs-endio-met (pid: 2731, threadinfo ffff880079acc000, task ffff880079aca8c0)
[  148.152093] Stack:
[  148.152094]  ffffffff8104e730 ffff880069b9c8f8 ffff88007e87ca40 ffff880069b9c8c0
[  148.152098] <0> ffff880079acde20 ffffffff8118a42d ffff88007bbc70c0 ffff880069b9c8f8
[  148.152102] <0> ffff88007bbc70d8 ffff88007bbc7110 ffff880079acdee0 ffffffff811b98f0
[  148.152107] Call Trace:
[  148.152113]  [<ffffffff8104e730>] ? process_timeout+0x0/0x10
[  148.152118]  [<ffffffff8118a42d>] end_workqueue_fn+0x10d/0x130
[  148.152122]  [<ffffffff811b98f0>] worker_loop+0xb0/0x5a0
[  148.152126]  [<ffffffff811b9840>] ? worker_loop+0x0/0x5a0
[  148.152130]  [<ffffffff8105b60e>] kthread+0x8e/0xa0
[  148.152135]  [<ffffffff81003a54>] kernel_thread_helper+0x4/0x10
[  148.152138]  [<ffffffff8105b580>] ? kthread+0x0/0xa0
[  148.152142]  [<ffffffff81003a50>] ? kernel_thread_helper+0x0/0x10
[  148.152144] Code: d3 ff ff 89 c2 b8 01 00 00 00 85 d2 75 56 4c 39 eb 77 51 0f 1f 80 00 00 00 00 48 89 de 49 8b 7c 24 10 48 c1 ee 0c e8 3f 21 ef ff <f6> 00 08 74 2a 48 89 c7 48 81 c3 00 10 00 00 e8 4b af ef ff 49 
[  148.152176] RIP  [<ffffffff811b1301>] extent_range_uptodate+0x51/0xa0
[  148.152180]  RSP <ffff880079acddd0>
[  148.152182] CR2: 0000000000000000
[  148.152185] ---[ end trace c11a5009b12451d7 ]---


Full dmesg is here

http://www.aei.mpg.de/~crmafra/dmesg-2.6.35.3.txt

Is there something else I should provide to help debug this?
