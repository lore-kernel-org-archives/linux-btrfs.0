From: Andrea Gelmini <andrea.gelmini@gmail.com>
Subject: Re: [3.2.1] BUG at fs/btrfs/inode.c:1588
Date: Mon, 13 Feb 2012 22:05:13 +0100
Message-ID: <CAK-xaQbU5Cg0Qa3MS8QzU-pDfZmkSOZRTtYgBnxS_OKeqfTzdA@mail.gmail.com>
References: <vqfmv8-9ch.ln1@hurikhan.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Kai Krakow <hurikhan77+btrfs@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <vqfmv8-9ch.ln1@hurikhan.ath.cx>
List-ID: <linux-btrfs.vger.kernel.org>

2012/2/1 Kai Krakow <hurikhan77+btrfs@gmail.com>:
> Just happened while writing a huge avi file to my usb3 backup disk:

Same problem here, I try to give the filesystem history:
a) three days ago I format a 219GB partition:
   1) latest Linus' git kernel tree;
   2) two nested subvolumes;
   3) options: defaults,noatime,nobarrier,ssd,noacl,compress,subvol=root,autodefrag
b) I copy ~90GB of data;
c) I mount same as above, without compress;
d) I copy other data, to ~140GB;
e) run balance, after a while I had to poweroff;
f) two days ago, I boot and it finishes the balance;
g) I put in cron a snapshot every hour;
h) today (after a lot of clean resume/suspend in RAM) I run VirtualBox
and start an Ubuntu 12.04 install in Guest;
i) near the end of installation VirtualBox get stuck (but everything
else works) and kernel complain:

[16661.706465] ------------[ cut here ]------------
[16661.706514] kernel BUG at fs/btrfs/inode.c:1588!
[16661.706556] invalid opcode: 0000 [#1] SMP
[16661.706597] CPU 0
[16661.706615] Modules linked in: zram(C) xfs exportfs usbhid hid
binfmt_misc pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O)
rfcomm bnep joydev snd_hda_codec_realtek snd_hda_intel snd_hda_codec
snd_hwdep uvcvideo r852 sm_common nand videobuf2_core snd_pcm videodev
nand_ids btusb v4l2_compat_ioctl32 bluetooth mtd videobuf2_vmalloc
videobuf2_memops nand_bch bch option usb_wwan nand_ecc usbserial
psmouse snd_timer iwl3945 snd_page_alloc iwlegacy raid10 raid456
async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq
async_tx raid0 linear dm_mirror dm_region_hash dm_log usb_storage
sdhci_pci sdhci i915 drm_kms_helper mmc_core drm intel_agp intel_gtt
sky2 agpgart
[16661.707016]
[16661.707016] Pid: 710, comm: btrfs-fixup-1 Tainted: G         C O
3.3.0-rc3g+ #13 SAMSUNG ELECTRONICS CO., LTD. SQ45S70S/SQ45S70S
[16661.707016] RIP: 0010:[<ffffffff811aedc5>]  [<ffffffff811aedc5>]
btrfs_writepage_fixup_worker+0x145/0x150
[16661.707016] RSP: 0000:ffff8800b9bb3df0  EFLAGS: 00010246
[16661.707016] RAX: 0000000000000000 RBX: ffffea0002185900 RCX: 0000000002488000
[16661.707016] RDX: ffff8800897ae2a8 RSI: ffffffffffffffff RDI: ffff8800897ae428
[16661.707016] RBP: 0000000002488000 R08: 0000000000000008 R09: ffff8800b9bb3da8
[16661.707016] R10: 0000000000001000 R11: 0000000000000000 R12: ffff8800b75f5ff0
[16661.707016] R13: 0000000000000000 R14: 0000000002488fff R15: ffff8800b75f5e70
[16661.707016] FS:  0000000000000000(0000) GS:ffff8800bf400000(0000)
knlGS:0000000000000000
[16661.707016] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[16661.707016] CR2: 00007fa504fd40e0 CR3: 00000000ba515000 CR4: 00000000000006f0
[16661.707016] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[16661.707016] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[16661.707016] Process btrfs-fixup-1 (pid: 710, threadinfo
ffff8800b9bb2000, task ffff8800373edcd0)
[16661.707016] Stack:
[16661.707016]  ffffffff81046a30 ffff880085a0d960 00000000ffffffff
ffff88008e3602a0
[16661.707016]  ffff8800bf410b40 ffff8800b9ce3840 ffff880085a0d968
ffff8800b9ce3858
[16661.707016]  ffff8800b9ce3890 ffff8800b9bb3e90 ffff8800b9ce3858
ffffffff811d6972
[16661.707016] Call Trace:
[16661.707016]  [<ffffffff81046a30>] ? run_timer_softirq+0x220/0x220
[16661.707016]  [<ffffffff811d6972>] ? worker_loop+0xa2/0x500
[16661.707016]  [<ffffffff811d68d0>] ? btrfs_queue_worker+0x340/0x340
[16661.707016]  [<ffffffff81056966>] ? kthread+0x96/0xa0
[16661.707016]  [<ffffffff8150b534>] ? kernel_thread_helper+0x4/0x10
[16661.707016]  [<ffffffff810568d0>] ? kthread_freezable_should_stop+0x60/0x60
[16661.707016]  [<ffffffff8150b530>] ? gs_change+0xb/0xb
[16661.707016] Code: 41 5f c3 0f 1f 00 41 b8 50 00 00 00 48 8d 4c 24
18 4c 89 f2 48 89 ee 4c 89 ff e8 d7 a4 01 00 eb b8 48 89 df e8 3d 01
ef ff eb 9c <0f> 0b 66 0f 1f 84 00 00 00 00 00 41 55 4c 8d 6e 40 41 54
55 48
[16661.707016] RIP  [<ffffffff811aedc5>]
btrfs_writepage_fixup_worker+0x145/0x150
[16661.707016]  RSP <ffff8800b9bb3df0>
[16661.731968] ---[ end trace 9b36ae9483fc03e3 ]---

l) I can't remove ~/VirtualBox VMs/Ubuntu (command "rm -rf" doesn't
return), but I can cleanly close others apps;
m) booting from recovery partition I can mount BTRFS and rm the directory above;
n) run btrfsck

fs tree 454 refs 12
	unresolved ref root 454 dir 844801 index 5 namelen 9 name snap-0212 error 600
	unresolved ref root 455 dir 844801 index 5 namelen 9 name snap-0212 error 600
	unresolved ref root 458 dir 844801 index 5 namelen 9 name snap-0212 error 600
	unresolved ref root 459 dir 844801 index 5 namelen 9 name snap-0212 error 600
	unresolved ref root 466 dir 844801 index 5 namelen 9 name snap-0212 error 600
	unresolved ref root 498 dir 844801 index 5 namelen 9 name snap-0212 error 600
	unresolved ref root 500 dir 844801 index 5 namelen 9 name snap-0212 error 600
	unresolved ref root 501 dir 844801 index 5 namelen 9 name snap-0212 error 600
	unresolved ref root 503 dir 844801 index 5 namelen 9 name snap-0212 error 600
	unresolved ref root 504 dir 844801 index 5 namelen 9 name snap-0212 error 600
	unresolved ref root 507 dir 844801 index 5 namelen 9 name snap-0212 error 600
fs tree 455 refs 11
	unresolved ref root 455 dir 844801 index 6 namelen 24 name
snap-2012-02-12.15:23:24 error 600
	unresolved ref root 458 dir 844801 index 6 namelen 24 name
snap-2012-02-12.15:23:24 error 600
	unresolved ref root 459 dir 844801 index 6 namelen 24 name
snap-2012-02-12.15:23:24 error 600
	unresolved ref root 466 dir 844801 index 6 namelen 24 name
snap-2012-02-12.15:23:24 error 600
	unresolved ref root 498 dir 844801 index 6 namelen 24 name
snap-2012-02-12.15:23:24 error 600
	unresolved ref root 500 dir 844801 index 6 namelen 24 name
snap-2012-02-12.15:23:24 error 600
	unresolved ref root 501 dir 844801 index 6 namelen 24 name
snap-2012-02-12.15:23:24 error 600
	unresolved ref root 503 dir 844801 index 6 namelen 24 name
snap-2012-02-12.15:23:24 error 600
	unresolved ref root 504 dir 844801 index 6 namelen 24 name
snap-2012-02-12.15:23:24 error 600
	unresolved ref root 507 dir 844801 index 6 namelen 24 name
snap-2012-02-12.15:23:24 error 600
fs tree 458 refs 10
	unresolved ref root 458 dir 844801 index 7 namelen 24 name
snap-2012-02-13.00:44:53 error 600
	unresolved ref root 459 dir 844801 index 7 namelen 24 name
snap-2012-02-13.00:44:53 error 600
	unresolved ref root 466 dir 844801 index 7 namelen 24 name
snap-2012-02-13.00:44:53 error 600
	unresolved ref root 498 dir 844801 index 7 namelen 24 name
snap-2012-02-13.00:44:53 error 600
	unresolved ref root 500 dir 844801 index 7 namelen 24 name
snap-2012-02-13.00:44:53 error 600
	unresolved ref root 501 dir 844801 index 7 namelen 24 name
snap-2012-02-13.00:44:53 error 600
	unresolved ref root 503 dir 844801 index 7 namelen 24 name
snap-2012-02-13.00:44:53 error 600
	unresolved ref root 504 dir 844801 index 7 namelen 24 name
snap-2012-02-13.00:44:53 error 600
	unresolved ref root 507 dir 844801 index 7 namelen 24 name
snap-2012-02-13.00:44:53 error 600
fs tree 459 refs 9
	unresolved ref root 459 dir 844801 index 8 namelen 24 name
snap-2012-02-13.01:00:01 error 600
	unresolved ref root 466 dir 844801 index 8 namelen 24 name
snap-2012-02-13.01:00:01 error 600
	unresolved ref root 498 dir 844801 index 8 namelen 24 name
snap-2012-02-13.01:00:01 error 600
	unresolved ref root 500 dir 844801 index 8 namelen 24 name
snap-2012-02-13.01:00:01 error 600
	unresolved ref root 501 dir 844801 index 8 namelen 24 name
snap-2012-02-13.01:00:01 error 600
	unresolved ref root 503 dir 844801 index 8 namelen 24 name
snap-2012-02-13.01:00:01 error 600
	unresolved ref root 504 dir 844801 index 8 namelen 24 name
snap-2012-02-13.01:00:01 error 600
	unresolved ref root 507 dir 844801 index 8 namelen 24 name
snap-2012-02-13.01:00:01 error 600
fs tree 466 refs 8
	unresolved ref root 466 dir 844801 index 9 namelen 24 name
snap-2012-02-13.11:00:01 error 600
	unresolved ref root 498 dir 844801 index 9 namelen 24 name
snap-2012-02-13.11:00:01 error 600
	unresolved ref root 500 dir 844801 index 9 namelen 24 name
snap-2012-02-13.11:00:01 error 600
	unresolved ref root 501 dir 844801 index 9 namelen 24 name
snap-2012-02-13.11:00:01 error 600
	unresolved ref root 503 dir 844801 index 9 namelen 24 name
snap-2012-02-13.11:00:01 error 600
	unresolved ref root 504 dir 844801 index 9 namelen 24 name
snap-2012-02-13.11:00:01 error 600
	unresolved ref root 507 dir 844801 index 9 namelen 24 name
snap-2012-02-13.11:00:01 error 600
fs tree 498 refs 7
	unresolved ref root 498 dir 844801 index 10 namelen 24 name
snap-2012-02-13.12:00:01 error 600
	unresolved ref root 500 dir 844801 index 10 namelen 24 name
snap-2012-02-13.12:00:01 error 600
	unresolved ref root 501 dir 844801 index 10 namelen 24 name
snap-2012-02-13.12:00:01 error 600
	unresolved ref root 503 dir 844801 index 10 namelen 24 name
snap-2012-02-13.12:00:01 error 600
	unresolved ref root 504 dir 844801 index 10 namelen 24 name
snap-2012-02-13.12:00:01 error 600
	unresolved ref root 507 dir 844801 index 10 namelen 24 name
snap-2012-02-13.12:00:01 error 600
fs tree 500 refs 6
	unresolved ref root 500 dir 844801 index 11 namelen 24 name
snap-2012-02-13.14:00:01 error 600
	unresolved ref root 501 dir 844801 index 11 namelen 24 name
snap-2012-02-13.14:00:01 error 600
	unresolved ref root 503 dir 844801 index 11 namelen 24 name
snap-2012-02-13.14:00:01 error 600
	unresolved ref root 504 dir 844801 index 11 namelen 24 name
snap-2012-02-13.14:00:01 error 600
	unresolved ref root 507 dir 844801 index 11 namelen 24 name
snap-2012-02-13.14:00:01 error 600
fs tree 501 refs 5
	unresolved ref root 501 dir 844801 index 12 namelen 24 name
snap-2012-02-13.18:00:01 error 600
	unresolved ref root 503 dir 844801 index 12 namelen 24 name
snap-2012-02-13.18:00:01 error 600
	unresolved ref root 504 dir 844801 index 12 namelen 24 name
snap-2012-02-13.18:00:01 error 600
	unresolved ref root 507 dir 844801 index 12 namelen 24 name
snap-2012-02-13.18:00:01 error 600
fs tree 503 refs 4
	unresolved ref root 503 dir 844801 index 13 namelen 24 name
snap-2012-02-13.19:00:01 error 600
	unresolved ref root 504 dir 844801 index 13 namelen 24 name
snap-2012-02-13.19:00:01 error 600
	unresolved ref root 507 dir 844801 index 13 namelen 24 name
snap-2012-02-13.19:00:01 error 600
fs tree 504 refs 3
	unresolved ref root 504 dir 844801 index 14 namelen 24 name
snap-2012-02-13.20:00:01 error 600
	unresolved ref root 507 dir 844801 index 14 namelen 24 name
snap-2012-02-13.20:00:01 error 600
fs tree 507 refs 2
	unresolved ref root 507 dir 844801 index 15 namelen 24 name
snap-2012-02-13.21:00:01 error 600
found 148321431552 bytes used err is 1
total csum bytes: 143183508
total tree bytes: 1695162368
total fs tree bytes: 1380012032
btree space waste bytes: 395268619
file data blocks allocated: 181930553344
 referenced 190255210496

o) remove all snapshots, so btrsck stop complain:

found 144518303744 bytes used err is 0
total csum bytes: 139577232
total tree bytes: 1588137984
total fs tree bytes: 1281392640
btree space waste bytes: 370101450
file data blocks allocated: 143005290496
 referenced 152667561984

p) scrub is still running, but everything seems fine.

Thanks a lot for your time,
Andrea
