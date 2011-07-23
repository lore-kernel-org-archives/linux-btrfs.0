From: Jan Schubert <Jan.Schubert@GMX.li>
Subject: Re: [PATCH v7 0/8] Btrfs scrub: print path to corrupted files and trigger nodatasum fixup
Date: Sat, 23 Jul 2011 22:38:55 +0000 (UTC)
Message-ID: <loom.20110724T002821-609@post.gmane.org>
References: <cover.1311333004.git.list.btrfs@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Jan Schmidt <list.btrfs <at> jan-o-sch.net> writes:
> The first feature adds printk statements in case scrub finds an error which 
list
> all affected files. You will need patch 1, 2 and 3 for that.

Jan, I tried to apply these patches against official 3.0 and crashed the system 
while doing a scrub (as reportet for Patchset v5 also). This time I've been able 
to save the kernel oops:

------------[ cut here ]------------
kernel BUG at fs/btrfs/ctree.h:1669!
invalid opcode: 0000 [#1] PREEMPT SMP 
CPU 1 
Modules linked in: i2c_core ext2 mbcache aesni_intel cryptd aes_x86_64 
aes_generic xts gf128mul dm_crypt acpi_cpufreq mperf lzo snd_hda_codec_hdmi 
snd_hda_codec_conexant arc4 sr_mod cdrom thinkpad_acpi snd_hda_intel 
snd_hda_codec sdhci_pci backlight snd_pcm_oss sdhci ehci_hcd intel_agp snd_hwdep 
psmouse evdev mmc_core usbcore snd_pcm snd_timer thermal intel_gtt nvram 
snd_page_alloc battery snd_mixer_oss snd ac power_supply soundcore processor 
thermal_sys button hwmon iwlagn mac80211 cfg80211 [last unloaded: nvidia]

Pid: 930, comm: btrfs-scrub-3 Tainted: P            3.0.0-ARCH #1 LENOVO 
25223FG/25223FG
RIP: 0010:[<ffffffff811a6b13>]  [<ffffffff811a6b13>] 
__get_extent_inline_ref+0x113/0x120
RSP: 0018:ffff88012eb8fb10  EFLAGS: 00010283
RAX: 0000000000000009 RBX: ffff88012eb8fbd8 RCX: 0000000000000a56
RDX: 0000000000000a55 RSI: ffff88012e83c000 RDI: ffff88013304df80
RBP: ffff88013304df80 R08: ffff88012eb8fad0 R09: ffff88012eb8fad8
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000a3d
R13: 0000000000000018 R14: ffff88012eb8fbec R15: 0000002a63679000
FS:  0000000000000000(0000) GS:ffff880137c80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000006ac8f0 CR3: 000000012e98e000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process btrfs-scrub-3 (pid: 930, threadinfo ffff88012eb8e000, task 
ffff880131fc5160)
Stack:
 0000000000001000 ffff88012eb8fbe0 ffff8801331a7cf0 ffff88013304df80
 ffff880130ea8000 0000000000000a3d 0000000000000018 ffffffff811a7596
 ffff88012eb8fb90 00ff880100000004 0000000000000000 0000000000000001
Call Trace:
 [<ffffffff811a7596>] ? iterate_extent_inodes+0xc6/0x3f0
 [<ffffffff811a7fb0>] ? scrub_print_warning+0x2e0/0x2e0
 [<ffffffff811768ae>] ? btrfs_item_size+0xee/0x100
 [<ffffffff811a7e8e>] ? scrub_print_warning+0x1be/0x2e0
 [<ffffffff810373e2>] ? try_to_wake_up+0x1b2/0x260
 [<ffffffff811a8a06>] ? scrub_recheck_error+0x306/0x3e0
 [<ffffffff811a8385>] ? scrub_checksum_data+0xe5/0x120
 [<ffffffff811a937c>] ? scrub_checksum+0x39c/0x480
 [<ffffffff81047ce0>] ? usleep_range+0x40/0x40
 [<ffffffff81189bbe>] ? worker_loop+0x14e/0x4e0
 [<ffffffff81189a70>] ? btrfs_queue_worker+0x2d0/0x2d0
 [<ffffffff810574fe>] ? kthread+0x7e/0x90
 [<ffffffff81399994>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff81057480>] ? kthread_worker_fn+0x180/0x180
 [<ffffffff81399990>] ? gs_change+0xb/0xb
Code: eb e7 66 0f 1f 44 00 00 b8 0d 00 00 00 e9 61 ff ff ff be ef 00 00 00 48 c7 
c7 bb c7 44 81 e8 95 4e e9 ff 48 8b 03 e9 5a ff ff ff <0f> 0b 66 66 2e 0f 1f 84 
00 00 00 00 00 48 83 ec 28 48 89 6c 24 
RIP  [<ffffffff811a6b13>] __get_extent_inline_ref+0x113/0x120
 RSP <ffff88012eb8fb10>
---[ end trace b662579b95afa75a ]---

The filesystem seems to be dead afterwards, doing a sync or trying to write data 
has not been possible. I've not seen any csum errors in dmesg while oder after 
doing the scrub but after rebooting the system:

btrfs no csum found for inode 199934 start 729088
btrfs csum failed ino 199934 off 729088 csum 3390946210 private 0
btrfs no csum found for inode 199934 start 24096768
btrfs csum failed ino 199934 off 24096768 csum 439962552 private 0
btrfs no csum found for inode 199934 start 24801280
btrfs no csum found for inode 199934 start 24805376
btrfs csum failed ino 199934 off 24801280 csum 158010657 private 0
btrfs csum failed ino 199934 off 24805376 csum 127231121 private 0

The scrub status has been reported as follows (after kernel crash, not 
rebooted):

scrub status for 03201fc0-7695-4468-9a10-f61ad79f23ca
        scrub started at Sun Jul 24 00:07:58 2011, running for 932 seconds
        total bytes scrubbed: 165.86GB with 4 errors
        error details: csum=4
        corrected errors: 0, uncorrectable errors: 0

After rebooting the system the status is reported like this:

scrub status for 03201fc0-7695-4468-9a10-f61ad79f23ca
        scrub started at Sun Jul 24 00:07:58 2011, running for 742 seconds
        total bytes scrubbed: 164.10GB with 0 errors

Interessting to note is the difference in time and scrubbed bytes.

As reported before, this filesystem has shown more than 2000 unrecoverable 
errors before which seemed to be gone after upgrading to official 3.0 and your 
patches. 3.0 seems very robust when it comes to btrfs (at least much more than 
2.6).

I'm still very interested in knowing which of the files are corrupted.

HTH,
Jan

