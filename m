Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:44289 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757949Ab3KICuL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Nov 2013 21:50:11 -0500
Received: by mail-ea0-f173.google.com with SMTP id g10so1499439eak.18
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Nov 2013 18:50:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAC4gV=6yDhYHfWHOer_uVYZ8dgCQ5C=7JXkN3rpkXs=tH_jPZQ@mail.gmail.com>
References: <CAOMFOmUDd0jS=R+MAVwfwmNj7Bt9VUM46b8zYmC59BA65qhUfA@mail.gmail.com>
	<CAC4gV=7FgL=wixYf6w-yfuZNbz8QCt5t9T8_jStjpkKgTBc+Vw@mail.gmail.com>
	<CAOMFOmXj=-8g6hYs_qcj417OUmgLEGdms2kMzUdorCuxJ7292w@mail.gmail.com>
	<CAOMFOmWee0NX=ZmcdG2FpkKyu-XLC5druy-Cn5+6ZAZa34WdZg@mail.gmail.com>
	<CAC4gV=6yDhYHfWHOer_uVYZ8dgCQ5C=7JXkN3rpkXs=tH_jPZQ@mail.gmail.com>
Date: Fri, 8 Nov 2013 18:50:09 -0800
Message-ID: <CAOMFOmWB0ojMDAFF=AJti6Nit+3UUutYDYaAVgnfM113aVRVGg@mail.gmail.com>
Subject: Re: How to fix/remove "csum failed ino" error
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: Frank Holton <fholton@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Frank, thanks for your help again.

Continuing my saga with filesystem recovering.

btrfsck $DEVICE

fails and says some files are corrupted. That is because of my recent
disk crash. I found all these files and indeed - reading it produces
an error. I removed those files and ran btrfsck again. Now it fails
with

Unable to find block group for 0
btrfsck: extent-tree.c:284: find_search_start: Assertion `!(1)' failed.

Hmm.. Google recommended me to run

btrfsck --init-extent-tree $DEVICE

and surprisingly the problem gone away and btrfsck finished
successfully. It looks promising. (BTW having man pages for btrfsck
would be really helpful)

Now it is time scrub the filesystem. It still shows a bunch of problems

scrub status for 25e6a6fa-fe1f-4be5-a638-eeac948f8c21
scrub started at Fri Nov  8 18:45:07 2013 and finished after 16564 seconds
total bytes scrubbed: 3.62TB with 90145 errors
error details: csum=90145
corrected errors: 0, uncorrectable errors: 90145, unverified errors: 0


Here is part of dmesg:

[ 7162.786759] btrfs: checksum error at logical 7915755577344 on dev
/dev/sdd, sector 125636176, root 5, inode 5224916, offset 44695552,
length 4096, links 1 (path:
var/log/journal/b4d8ffd8ac454d02849f8c8925432368/system@dcae59172d794892a7ca0cdc2d381fa3-000000000018ee6d-0004eaac687ad6bb.journal)
[ 7162.786766] btrfs: checksum error at logical 7915759673344 on dev
/dev/sdd, sector 125644176, root 5, inode 5224916, offset 48791552,
length 4096, links 1 (path:
var/log/journal/b4d8ffd8ac454d02849f8c8925432368/system@dcae59172d794892a7ca0cdc2d381fa3-000000000018ee6d-0004eaac687ad6bb.journal)
[ 7162.786767] btrfs_dev_stat_print_on_error: 9 callbacks suppressed


system journal issues? Hmmm.. Let's remove the journal files. Here are
more errors in dmesg though..

[ 7677.380386] BTRFS info (device sda3): csum failed ino 5224853 off
46080000 csum 1253352426 private 0
[ 7677.384271] BTRFS info (device sda3): csum failed ino 5224853 off
48812032 csum 2784483749 private 0
[ 7677.387325] BTRFS info (device sda3): csum failed ino 5224853 off
47443968 csum 1928606421 private 0
[ 7677.518090] BTRFS info (device sda3): csum failed ino 5224853 off
51552256 csum 2439491854 private 0

D'oh the same csum issue that I had before. And here are more cryptic errors:


[19374.896393] btrfs: bdev /dev/sdc1 errs: wr 0, rd 0, flush 0, corrupt 7, gen 0
[19374.896395] btrfs: unable to fixup (regular) error at logical
7325276450816 on dev /dev/sdc1
[19374.902842] btrfs: unable to fixup (regular) error at logical
7325276971008 on dev /dev/sdc1
[19374.903125] btrfs: bdev /dev/sdc1 errs: wr 0, rd 0, flush 0, corrupt 8, gen 0
[19374.903126] btrfs: unable to fixup (regular) error at logical
7325276454912 on dev /dev/sdc1
[19374.909514] btrfs: bdev /dev/sdc1 errs: wr 0, rd 0, flush 0, corrupt 9, gen 0
[19374.911597] btrfs: unable to fixup (regular) error at logical
7325276459008 on dev /dev/sdc1
[19374.911763] btrfs: bdev /dev/sdc1 errs: wr 0, rd 0, flush 0,
corrupt 10, gen 0
[19374.911765] btrfs: unable to fixup (regular) error at logical
7325276975104 on dev /dev/sdc1
[19379.864446] scrub_handle_errored_block: 24910 callbacks suppressed


I even do not understand what does it mean.


But maybe rebalance can be run now? Let's try it:

btrfs balance start -dconvert=raid1 -mconvert=raid1 $MOUNT


Ouch, got a kernel OOPs:

[25185.855910] ------------[ cut here ]------------
[25185.858066] kernel BUG at fs/btrfs/relocation.c:1055!
[25185.860200] invalid opcode: 0000 [#1] PREEMPT SMP
[25185.862330] Modules linked in: x86_pkg_temp_thermal
intel_powerclamp coretemp kvm_intel kvm crc32_pclmul
ghash_clmulni_intel iTCO_wdt iTCO_vendor_support ppdev cryptd psmouse
i2c_i801 microcode pcspkr snd_hda_codec_hdmi serio_raw
snd_hda_codec_realtek snd_hda_intel lpc_ich snd_hda_codec snd_hwdep
snd_pcm parport_pc parport snd_page_alloc snd_timer snd evdev mperf
soundcore mei_me mei shpchp processor nfs lockd sunrpc fscache ext4
crc16 mbcache jbd2 dm_snapshot dm_mod squashfs loop isofs btrfs
raid6_pq libcrc32c zlib_deflate xor hid_generic usbhid hid sd_mod
usb_storage ahci libahci libata scsi_mod crc32c_intel atl1c xhci_hcd
i915 intel_agp intel_gtt i2c_algo_bit drm_kms_helper ehci_pci ehci_hcd
drm usbcore usb_common i2c_core video button
[25185.871704] CPU: 1 PID: 902 Comm: btrfs Tainted: G        W
3.11.2-1-ARCH #1
[25185.874058] Hardware name: To Be Filled By O.E.M. To Be Filled By
O.E.M./H61M/U3S3, BIOS P2.20 07/30/2012
[25185.876433] task: ffff880113840000 ti: ffff880078582000 task.ti:
ffff880078582000
[25185.878807] RIP: 0010:[<ffffffffa037a6fa>]  [<ffffffffa037a6fa>]
build_backref_tree+0x111a/0x11c0 [btrfs]
[25185.881210] RSP: 0018:ffff8800785839d0  EFLAGS: 00010246
[25185.883588] RAX: 0000000000000000 RBX: ffff88009c633800 RCX: ffff8800be682d50
[25185.885971] RDX: ffff880078583a40 RSI: ffff88009c633820 RDI: ffff8800be682d40
[25185.888361] RBP: ffff880078583ab0 R08: ffff8800a53a7400 R09: ffff8800a53a7280
[25185.890733] R10: ffff88011ac01900 R11: ffff880078583fd8 R12: 0000000000000000
[25185.893114] R13: ffff8800c4a6a480 R14: ffff8800a53a7e80 R15: ffff8800be682d50
[25185.895488] FS:  00007f5585c96780(0000) GS:ffff88011f300000(0000)
knlGS:0000000000000000
[25185.897870] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[25185.900240] CR2: 00007f1aecd8b040 CR3: 0000000009ee1000 CR4: 00000000000407e0
[25185.902609] Stack:
[25185.904955]  ffff8800a53a7280 ffff8800be7889a0 ffff8800a53a7400
ffff8800c4a6a480
[25185.907332]  ffff8800a53a7400 ffff8800a3cc4000 ffff8800c4a6a990
ffff8800a53a7440
[25185.909692]  ffff88009c633920 ffff8800a53a7280 ffff88009c633924
ffff88009c633820
[25185.912037] Call Trace:
[25185.914363]  [<ffffffffa037bbe8>] relocate_tree_blocks+0x1d8/0x630 [btrfs]
[25185.916706]  [<ffffffffa037c468>] ? add_data_references+0x248/0x280 [btrfs]
[25185.919031]  [<ffffffffa037d070>] relocate_block_group+0x280/0x690 [btrfs]
[25185.921348]  [<ffffffffa037d61f>]
btrfs_relocate_block_group+0x19f/0x2e0 [btrfs]
[25185.923664]  [<ffffffffa0355a78>]
btrfs_relocate_chunk.isra.32+0x68/0x780 [btrfs]
[25185.925962]  [<ffffffffa030fa76>] ? btrfs_search_slot+0x436/0x940 [btrfs]
[25185.928254]  [<ffffffffa034b549>] ? release_extent_buffer+0xa9/0xd0 [btrfs]
[25185.930539]  [<ffffffffa0350cdf>] ? free_extent_buffer+0x4f/0xa0 [btrfs]
[25185.932814]  [<ffffffffa035939f>] btrfs_balance+0x8ef/0xe90 [btrfs]
[25185.935097]  [<ffffffffa03605a3>] btrfs_ioctl_balance+0x163/0x510 [btrfs]
[25185.937365]  [<ffffffffa03642b4>] btrfs_ioctl+0xdb4/0x1e00 [btrfs]
[25185.939635]  [<ffffffff814e50bc>] ? __do_page_fault+0x2ec/0x5c0
[25185.941891]  [<ffffffff81160a0a>] ? __vma_link_rb+0x6a/0x90
[25185.944156]  [<ffffffff81160ae7>] ? vma_link+0xb7/0xc0
[25185.946402]  [<ffffffff811b1055>] do_vfs_ioctl+0x2e5/0x4d0
[25185.948631]  [<ffffffff811b12c1>] SyS_ioctl+0x81/0xa0
[25185.950846]  [<ffffffff814e539e>] ? do_page_fault+0xe/0x10
[25185.953045]  [<ffffffff814e931d>] system_call_fastpath+0x1a/0x1f
[25185.955232] Code: 4c 89 ef e8 59 05 f9 ff 48 8b bd 50 ff ff ff e8
4d 05 f9 ff 48 83 bd 30 ff ff ff 00 0f 85 14 fd ff ff 31 c0 e9 be ef
ff ff 0f 0b <0f> 0b 48 8b 85 30 ff ff ff 49 8d 7e 20 48 8b 70 18 48 89
c2 e8
[25185.957655] RIP  [<ffffffffa037a6fa>]
build_backref_tree+0x111a/0x11c0 [btrfs]
[25185.959995]  RSP <ffff8800785839d0>
[25186.196680] ---[ end trace 9ab9ad3c7961486e ]---




So my attempt to recover my filesystem and convert it to raid1 failed
again. I feel that the easies way for me to reinstall system
completely and copy important files to newly created btrfs raid.




Why is that difficult to recover a broken filesystem. I bet it is
something that users will have a lot in the future. Do btrfs
developers test error path at all? I think you can repro my situation
by

1) Create 'single' multi-device filesystem and then crash one of the
disks. It should be easily to do with loop block devices.
2) Run some lengthy operation (e.g. rebalance) and then reboot computer.

Speaking of long operations: why there is no way to stop it? I think
'btrfs' should handle 'Ctrl+C' and interrupt the operation correctly
instead of sitting in 'D' state for 10 hours. Should I file a ticket?
