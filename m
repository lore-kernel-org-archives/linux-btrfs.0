Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:41256 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbaBPPa0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Feb 2014 10:30:26 -0500
Received: by mail-ee0-f42.google.com with SMTP id b15so6626870eek.29
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Feb 2014 07:30:23 -0800 (PST)
Received: from system (g228045053.adsl.alicedsl.de. [92.228.45.53])
        by mx.google.com with ESMTPSA id 46sm45765832ees.4.2014.02.16.07.30.21
        for <linux-btrfs@vger.kernel.org>
        (version=SSLv3 cipher=RC4-SHA bits=128/128);
        Sun, 16 Feb 2014 07:30:22 -0800 (PST)
Date: Sun, 16 Feb 2014 16:30:20 +0100
From: Saint Germain <saintger@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS with RAID1 cannot boot when removing drive
Message-ID: <20140216163020.4f774dea@system>
In-Reply-To: <CAJbEPe6-J=0n_qOmZ06NEOha-z7Xe_WwQkDx-3OnNWbzKr+H=g@mail.gmail.com>
References: <20140209224055.3175e70f@system>
	<pan$c13e9$73e2c595$53adb8c8$58509a35@cox.net>
	<20140211033059.34bd0ef7@system>
	<CAJbEPe6-J=0n_qOmZ06NEOha-z7Xe_WwQkDx-3OnNWbzKr+H=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 14 Feb 2014 15:33:10 +0100, Saint Germain <saintger@gmail.com>
wrote :

> On 11 February 2014 03:30, Saint Germain <saintger@gmail.com> wrote:
> >> > I am experimenting with BTRFS and RAID1 on my Debian Wheezy (with
> >> > backported kernel 3.12-0.bpo.1-amd64) using a a motherboard with
> >> > UEFI.
> >>
> >> > I have installed Debian with the following partition on the first
> >> > hard drive (no BTRFS subsystem):
> >> > /dev/sda1: for / (BTRFS)
> >> > /dev/sda2: for /home (BTRFS)
> >> > /dev/sda3: for swap
> >> >
> >> > Then I added another drive for a RAID1 configuration (with btrfs
> >> > balance) and I installed grub on the second hard drive with
> >> > "grub-install /dev/sdb".
> >>
> >> You should be able to mount a two-device btrfs raid1 filesystem
> >> with only a single device with the degraded mount option, tho I
> >> believe current kernels refuse a read-write mount in that case, so
> >> you'll have read-only access until you btrfs device add a second
> >> device, so it can do normal raid1 mode once again.
> >>
> >> Meanwhile, I don't believe it's on the wiki, but it's worth noting
> >> my experience with btrfs raid1 mode in my pre-deployment tests.
> >> Actually, with the (I believe) mandatory read-only mount if raid1
> >> is degraded below two devices, this problem's going to be harder
> >> to run into than it was in my testing several kernels ago, but
> >> here's what I found:
> >>
> >> But as I said, if btrfs only allows read-only mounts of filesystems
> >> without enough devices to properly complete the raidlevel, that
> >> shouldn't be as big an issue these days, since it should be more
> >> difficult or impossible to get the two devices separately mounted
> >> writable in the first place, with the consequence that the
> >> differing copies issue will be difficult or impossible to trigger
> >> in the first place. =:^)
> >>
> 
> Hello,
> 
> With your advices and Chris ones, I have now a (clean ?) partition to
> start experimenting with RAID1 (and which boot correctly in UEFI
> mode):
> sda1 = BIOS Boot partition
> sda2 = EFI System Partition
> sda3 = BTFS partition
> sda4 = swap partition
> For the moment I haven't created subvolumes (for "/" and for "/home"
> for instance) to keep things simple.
> 
> The idea is then to create a RAID1 with a sdb drive (duplicate sda
> partitioning, add/balance/convert sdb3 + grub-install on sdb, add sdb
> swap UUID in /etc/fstab), shutdown and remove sda to check the
> procedure to replace it.
> 
> I read the last thread on the subject "lost with degraded RAID1", but
> would like to really confirm what would be the current approved
> procedure and if it will be valid for future BTRFS version (especially
> about the read-only mount).
> 
> So what should I do from there ?
> Here are a few questions:
> 
> 1) Boot in degraded mode: currently with my kernel
> (3.12-0.bpo.1-amd64, from Debian wheezy-backports) it seems that I can
> mount in read-write mode.
> However for future kernel, it seems that I will be only able to mount
> read-only ? See here:
> http://www.spinics.net/lists/linux-btrfs/msg20164.html
> https://bugzilla.kernel.org/show_bug.cgi?id=60594
> 
> 2) If I am able to mount read-write, is this the correct procedure:
>   a) place a new drive in another physical location sdc (I don't think
> I can use the same sda physical location ?)
>   b) boot in degraded mode on sdb
>   c) use the 'replace' command to replace sda by sdc
>   d) perhaps a 'balance' is necessary ?
> 
> 3) Can I use also the above procedure if I am only allowed to mount
> read-only ?
> 
> 4) If I want to use my system without RAID1 support (dangerous I
> know), after booting in degraded mode with read-write, can I convert
> back sdb from RAID1 to RAID0 in a safe way ?
> (btrfs balance start -dconvert=raid0 -mconvert=raid0 /)
> 

To continue with this RAID1 recovery procedure (Debian stable with
kernel 3.12-0.bpo.1-amd64), I tried to reproduce Duncan setup and the
result is not good.

Starting with a clean setup of 2 hard drive in RAID1 (sda and sdb) and
a clean snapshot of the rootfs:
1) poweroff, disconnect sda and boot on sdb with rootflags=ro,degraded
2) sdb is mounted ro but automatically remounted read-write by initramf
3) create a file witness1 and modify a file test.txt with 'alpha' inside
4) poweroff, connect sda, disconnect sdb and boot on sda
5) create a file witness2 and modify a file test.txt with 'beta' inside
6) poweroff, connect sdb and boot on sda
7) the modification from step 3 are there (but not from step 5)
8) launch scrub: a lot of errors are detected but no unrepairable errors
9) poweroff, disconnect sdb, boot on sda
10) the modification from step 3 are there (but not from step 5)
11) poweroff, boot on sda: kernel panic on startup
12) reboot, boot is possible
13) launch scrub: a lot of errors and kernel error
14) reboot, error on boot, and same error as step 13 with scrub
15) boot on previous snapshot of step1, same error on boot and
same error as step 13 with scrub.


I hope that it will be useful for someone. It seems that mounting
read-write is really not a good idea (have to find how to force ro with
Debian). The RAID1 configuration is a bit fagile and even snapshots
won't protect you when it is broken.

If someone has some insigths, please let me know.

Here is for info the kernel error at boot and the scrub error:
[   37.575270] BUG: unable to handle kernel NULL pointer dereference at 00000000000000c0
[   37.575299] IP: [<ffffffffa01a8a3b>] __btrfs_cow_block+0x28b/0x540 [btrfs]
[   37.575328] PGD 0 
[   37.575337] Oops: 0000 [#1] SMP 
[   37.575351] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc nls_utf8 nls_cp437 vfat fat loop x86_pkg_temp_thermal coretemp kvm_intel snd_hda_codec_hdmi snd_hda_codec_realtek kvm snd_hda_intel snd_hda_codec lib80211_crypt_tkip snd_hwdep crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel wl(PO) snd_pcm aes_x86_64 lrw gf128mul glue_helper snd_page_alloc ablk_helper snd_timer iTCO_wdt iTCO_vendor_support cryptd psmouse acpi_cpufreq snd cfg80211 lib80211 i915 serio_raw drm_kms_helper drm processor button video thermal_sys joydev evdev rfkill i2c_i801 i2c_algo_bit lpc_ich i2c_core pcspkr mei_me mei mfd_core soundcore btrfs xor hid_generic usbhid hid raid6_pq crc32c libcrc32c sg sd_mod sr_mod cdrom crc_t10dif crct10dif_common ahci libahci libata scsi_mod xhci_hcd ehci_pci ehci_hcd e1000e ptp pps_core usbcore usb_common
[   37.575667] CPU: 0 PID: 297 Comm: btrfs-transacti Tainted: P           O 3.12-0.bpo.1-amd64 #1 Debian 3.12.9-1~bpo70+1
[   37.575695] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./Z87E-ITX, BIOS P2.10 10/04/2013
[   37.575719] task: ffff8800610747c0 ti: ffff880061060000 task.ti: ffff880061060000
[   37.575738] RIP: 0010:[<ffffffffa01a8a3b>]  [<ffffffffa01a8a3b>] __btrfs_cow_block+0x28b/0x540 [btrfs]
[   37.575766] RSP: 0018:ffff8800610618e8  EFLAGS: 00010217
[   37.575781] RAX: 0000160000000000 RBX: ffff88006124f800 RCX: ffff880060f92ea8
[   37.575799] RDX: ffff880000000000 RSI: 000000000000027b RDI: ffff880064a79270
[   37.575818] RBP: ffff880064948920 R08: ffff880061061944 R09: 0000000000000000
[   37.575837] R10: ffff88003734a000 R11: 0000000000000000 R12: ffff880060fe5960
[   37.575856] R13: ffff880064a79270 R14: 0000000000000000 R15: 0000000000000000
[   37.575874] FS:  0000000000000000(0000) GS:ffff880100200000(0000) knlGS:0000000000000000
[   37.575895] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   37.575910] CR2: 00000000000000c0 CR3: 000000000180c000 CR4: 00000000001407f0
[   37.575928] Stack:
[   37.575935]  ffff880000000000 0000000300000000 0000000000000000 ffffffffa01cb08d
[   37.575959]  ffff880061061a38 0000000000000000 ffff880064948920 0000000000000000
[   37.575983]  0000000000001000 000000b8a21aab99 0000000001000000 0000000100000000
[   37.576007] Call Trace:
[   37.576022]  [<ffffffffa01cb08d>] ? btrfs_buffer_uptodate+0x6d/0x80 [btrfs]
[   37.576044]  [<ffffffffa01a8ecb>] ? btrfs_cow_block+0x13b/0x200 [btrfs]
[   37.576069]  [<ffffffffa02044e2>] ? btrfs_set_lock_blocking_rw+0xa2/0xe0 [btrfs]
[   37.576092]  [<ffffffffa01ad33f>] ? btrfs_search_slot+0x46f/0x9c0 [btrfs]
[   37.576115]  [<ffffffffa01b365d>] ? lookup_inline_extent_backref+0xcd/0x5e0 [btrfs]
[   37.576139]  [<ffffffffa01b3be4>] ? insert_inline_extent_backref+0x74/0x120 [btrfs]
[   37.576163]  [<ffffffffa01b5a7f>] ? update_block_group.isra.75+0xbf/0x270 [btrfs]
[   37.576183]  [<ffffffff8116f97c>] ? kmem_cache_alloc+0x1bc/0x1f0
[   37.576203]  [<ffffffffa01b44ef>] ? __btrfs_inc_extent_ref+0xaf/0x250 [btrfs]
[   37.576227]  [<ffffffffa01bb47b>] ? run_clustered_refs+0xd4b/0xef0 [btrfs]
[   37.576251]  [<ffffffffa0214804>] ? btrfs_find_ref_cluster+0x74/0x170 [btrfs]
[   37.576274]  [<ffffffffa01bf370>] ? btrfs_run_delayed_refs+0xd0/0x530 [btrfs]
[   37.576300]  [<ffffffffa01e8683>] ? btrfs_run_ordered_operations+0x213/0x2b0 [btrfs]
[   37.576326]  [<ffffffffa01cf90a>] ? btrfs_commit_transaction+0x5a/0x9f0 [btrfs]
[   37.576350]  [<ffffffffa01c9385>] ? transaction_kthread+0x1b5/0x220 [btrfs]
[   37.576373]  [<ffffffffa01c91d0>] ? btree_readpage_end_io_hook+0x2d0/0x2d0 [btrfs]
[   37.576394]  [<ffffffff81082333>] ? kthread+0xb3/0xc0
[   37.576408]  [<ffffffff81082280>] ? flush_kthread_worker+0xa0/0xa0
[   37.576426]  [<ffffffff814cb70c>] ? ret_from_fork+0x7c/0xb0
[   37.576442]  [<ffffffff81082280>] ? flush_kthread_worker+0xa0/0xa0
[   37.576458] Code: 00 48 39 2b 0f 84 e6 01 00 00 48 83 bb d7 01 00 00 f8 48 c7 44 24 38 00 00 00 00 0f 84 bf 01 00 00 48 b8 00 00 00 00 00 16 00 00 <49> 03 87 c0 00 00 00 48 ba b7 6d db b6 6d db b6 6d 48 c1 f8 03 
[   37.576578] RIP  [<ffffffffa01a8a3b>] __btrfs_cow_block+0x28b/0x540 [btrfs]
[   37.576601]  RSP <ffff8800610618e8>
[   37.576611] CR2: 00000000000000c0
[   37.576622] ---[ end trace eb7650bbae358a3a ]---

And here is for info the scrub error:
[  390.015858] BTRFS critical (device sdb3): unable to find logical 687194767360 len 4096
[  390.015957] ------------[ cut here ]------------
[  390.015989] kernel BUG at /build/linux-SMWX37/linux-3.12.9/fs/btrfs/inode.c:1595!
[  390.016037] invalid opcode: 0000 [#1] SMP 
[  390.016070] Modules linked in: cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc nls_utf8 nls_cp437 vfat fat loop x86_pkg_temp_thermal coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 snd_hda_codec_hdmi snd_hda_codec_realtek lrw gf128mul snd_hda_intel snd_hda_codec snd_hwdep lib80211_crypt_tkip wl(PO) iTCO_wdt iTCO_vendor_support glue_helper ablk_helper snd_pcm cryptd acpi_cpufreq pcspkr psmouse mei_me mei i915 lpc_ich video processor drm_kms_helper drm mfd_core i2c_algo_bit snd_page_alloc snd_timer snd cfg80211 lib80211 rfkill i2c_i801 soundcore thermal_sys serio_raw i2c_core joydev evdev button hid_generic usbhid hid btrfs xor raid6_pq crc32c libcrc32c sg sd_mod sr_mod cdrom crc_t10dif crct10dif_common ahci libahci xhci_hcd ehci_pci ehci_hcd e1000e ptp pps_core libata scsi_mod usbcore usb_common
[  390.016840] CPU: 0 PID: 3045 Comm: btrfs Tainted: P           O 3.12-0.bpo.1-amd64 #1 Debian 3.12.9-1~bpo70+1
[  390.016899] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./Z87E-ITX, BIOS P2.10 10/04/2013
[  390.016957] task: ffff88006a9207c0 ti: ffff8800641be000 task.ti: ffff8800641be000
[  390.017004] RIP: 0010:[<ffffffffa01b5671>]  [<ffffffffa01b5671>] btrfs_merge_bio_hook+0x71/0x80 [btrfs]
[  390.017084] RSP: 0018:ffff8800641bf4f8  EFLAGS: 00010282
[  390.017119] RAX: 00000000ffffffea RBX: 0000000000001000 RCX: 0000000000000000
[  390.017163] RDX: ffff88010020ffa8 RSI: ffff88010020e4b8 RDI: 0000000000000246
[  390.017207] RBP: 0000000000001000 R08: 0000000000000000 R09: ffff8800606c5970
[  390.017250] R10: 00000000000002fb R11: ffffffff8164e348 R12: ffff880063c08c28
[  390.017294] R13: 0000000000000000 R14: ffff880064bd88b0 R15: 0000000050000008
[  390.017338] FS:  00007fe25f8fe700(0000) GS:ffff880100200000(0000) knlGS:0000000000000000
[  390.017388] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  390.017424] CR2: 00007fe25f933f80 CR3: 0000000036435000 CR4: 00000000001407f0
[  390.017493] Stack:
[  390.017518]  0000000000001000 0000000000001000 ffff880064bd88b0 ffff8800641bf768
[  390.017616]  0000000000001000 ffffffffa01cf313 0000000000000000 ffffea000159bff0
[  390.017712]  0000000000000000 ffff880100240380 ffffffffa01cf700 0000000000000020
[  390.017809] Call Trace:
[  390.017867]  [<ffffffffa01cf313>] ? submit_extent_page.isra.38+0xf3/0x250 [btrfs]
[  390.017967]  [<ffffffffa01cf700>] ? repair_io_failure+0x240/0x240 [btrfs]
[  390.018039]  [<ffffffffa01d0587>] ? __do_readpage+0x4b7/0x720 [btrfs]
[  390.018092]  [<ffffffffa01cf700>] ? repair_io_failure+0x240/0x240 [btrfs]
[  390.018150]  [<ffffffffa01a99d0>] ? verify_parent_transid+0x190/0x190 [btrfs]
[  390.018207]  [<ffffffffa01d08a4>] ? __extent_read_full_page+0xb4/0xd0 [btrfs]
[  390.018264]  [<ffffffffa01a99d0>] ? verify_parent_transid+0x190/0x190 [btrfs]
[  390.018320]  [<ffffffffa01a99d0>] ? verify_parent_transid+0x190/0x190 [btrfs]
[  390.018380]  [<ffffffffa01d312d>] ? read_extent_buffer_pages+0x25d/0x350 [btrfs]
[  390.018437]  [<ffffffffa01a99d0>] ? verify_parent_transid+0x190/0x190 [btrfs]
[  390.018493]  [<ffffffffa01aaf59>] ? btree_read_extent_buffer_pages.constprop.128+0xa9/0x110 [btrfs]
[  390.018559]  [<ffffffffa01ad5d3>] ? read_tree_block+0x33/0x60 [btrfs]
[  390.018610]  [<ffffffffa018dc65>] ? read_block_for_search.isra.45+0x195/0x3d0 [btrfs]
[  390.018669]  [<ffffffffa01938b9>] ? btrfs_next_old_leaf+0x2f9/0x490 [btrfs]
[  390.018726]  [<ffffffffa0206056>] ? scrub_stripe+0x5f6/0x1200 [btrfs]
[  390.018771]  [<ffffffff81082d00>] ? add_wait_queue+0x40/0x60
[  390.018820]  [<ffffffffa0206d8c>] ? scrub_chunk.isra.18+0x12c/0x150 [btrfs]
[  390.018875]  [<ffffffffa0207013>] ? scrub_enumerate_chunks+0x263/0x5a0 [btrfs]
[  390.018922]  [<ffffffff81082d00>] ? add_wait_queue+0x40/0x60
[  390.018971]  [<ffffffffa0208756>] ? btrfs_scrub_dev+0x1e6/0x570 [btrfs]
[  390.019027]  [<ffffffffa01e5e31>] ? btrfs_ioctl+0xe91/0x1d30 [btrfs]
[  390.019079]  [<ffffffffa01e5e8b>] ? btrfs_ioctl+0xeeb/0x1d30 [btrfs]
[  390.019123]  [<ffffffff814c305d>] ? rwsem_down_read_failed+0x9d/0xf0
[  390.019165]  [<ffffffff8128ef54>] ? call_rwsem_down_read_failed+0x14/0x30
[  390.019210]  [<ffffffff814c75b8>] ? __do_page_fault+0x2b8/0x540
[  390.019252]  [<ffffffff811971ca>] ? do_vfs_ioctl+0x8a/0x4f0
[  390.019289]  [<ffffffff81062c1d>] ? do_exit+0x6fd/0xa80
[  390.019325]  [<ffffffff810135f1>] ? __switch_to+0x171/0x4c0
[  390.019363]  [<ffffffff811976d0>] ? SyS_ioctl+0xa0/0xc0
[  390.019399]  [<ffffffff814cb7b9>] ? system_call_fastpath+0x16/0x1b
[  390.019437] Code: c9 45 31 c0 89 fe 48 89 c7 48 89 6c 24 08 e8 97 5f 02 00 85 c0 78 14 48 01 eb 31 c0 48 3b 5c 24 08 0f 97 c0 48 83 c4 18 5b 5d c3 <0f> 0b 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 53 48 89 fb 89 f1 
[  390.019733] RIP  [<ffffffffa01b5671>] btrfs_merge_bio_hook+0x71/0x80 [btrfs]
[  390.019793]  RSP <ffff8800641bf4f8>
[  390.019838] ---[ end trace 74720f4e8a3bc0fa ]---

