Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:43305 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab3BZGvD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 01:51:03 -0500
Received: from merlin by mail1.merlins.org with local (Exim 4.80 #2)
	id 1UAENS-00047k-SG
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2013 22:51:02 -0800
Date: Mon, 25 Feb 2013 22:51:02 -0800
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: kernel BUG at fs/btrfs/volumes.c:3753! These btrfs crashes at mount time on log replay are really a problem
Message-ID: <20130226065102.GC11218@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

TL;DR;
WARNING: at fs/btrfs/tree-log.c:1984 walk_down_log_tree+0x51/0x307()
WARNING: at fs/btrfs/tree-log.c:1988 walk_down_log_tree+0x6c/0x307()
kernel BUG at fs/btrfs/volumes.c:3753!

It's way time for btrfs to stop crashing your system with no recovery flag
that works to clear the log if the log can't be replayed. Hell, on non
development systems, it should just auto discard the log if it can't be
replayed without user input.


Details:
It's been almost a year that I'm doing my best to test btrfs and report
bugs, but how quickly it crashes on mount if anything is off, is a huge
usability problem.

I just again, lost use of my machine today after an unrelated problem caused
a crash/reboot, and incomplete btrfs writes to my device.
That happens, it's life.

But after that, I get to roll a dice of whether btrfs will recover, or just
crash on mount.
It's slightly more liveable if it's a scratch filesystem on a developer box,
you just don't mount it.
It's really really sucky if it's your root filesystem and you need to boot
from a rescue partition/media to recover each time.

Then, I spent 3 hours reproducing the crash again, with netconsole working
so that I can get a useful bugreport, which I send here.

I also get an btrfs-image when this happens, but so far I haven't
had any interest from anyone for doing so.
So, again, I have an image if someone wants it
787M	fs_image

I'm really losing faith in btrfs here. I see 2 problems.
1) btrfs doesn't provide encryption. ecryptfs is so slow it's unusable (also it
doesn't encrypt long file names anyway), so that leaves us with dmcrypt. Therefore
I have to run btrfs on top of dmcrypt.

Either btrfs is buggy over dmcrypt in that its writes aren't atomic, and it very often
gets into a state of an unreplayable log.
I have no idea if that's fixable, or not.

Or, btrfs truly has a problem on unclean shutdown during writes even without
dmcrypt, and more specifically pulling a sata device off a running bus.
I'm not sure if developers are testing for pulling a drive from the sata bus while writing
to it, and trying this at least 10 times for each kernel version.


2) btrfs is a development filesystem, I understand that, but if it wants more acceptance,
it just can't keep crashing each time it can't replay a log.
At this point BTRFS really must have a 'please clear my log and continue mounting' if the 
log is corrupted in some way.
Corruption happens through multiple means, clearly getting an inconsistent log on unclean 
shutdown is not only possible, it's very frequent.

btrfs can't just panic and refuse to mount the filesystem without any override option. 

Will you please consider allowing sending the BUG statements that can happen during mount
to a function that just cleans the replay log and tries again?
If ext4 has a log it can't use, it doesn't crash my system, it simply tells me to run fsck
and possibly mounts read-only.

Below is the crash info, although I suppose it's not that different from my previous reports.

Again, I'm happy to give the fs_image to someone if you want it.


device label btrfs_pool1 devid 1 transid 89465 /dev/mapper/root
btrfs: disk space caching is enabled
Btrfs detected SSD devices, enabling SSD mode
btrfs bad tree block start 11014467582957347470 344223137792
btrfs bad tree block start 7450179628261340409 344223137792
------------[ cut here ]------------
WARNING: at fs/btrfs/tree-log.c:1984 walk_down_log_tree+0x51/0x307()
Hardware name: 2429A78
Modules linked in: iwldvm mac80211 iwlwifi cfg80211 e1000e tun cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative ppdev rfcomm bnep autofs4 pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc uinput nfsd auth_rpcgss nfs_acl nfs lockd fscache sunrpc fuse configs parport_pc lp parport input_polldev loop firewire_sbp2 firewire_core crc_itu_t ecryptfs uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev media hid_generic btusb usbhid hid coretemp bluetooth kvm_intel kvm snd_hda_codec_realtek ghash_clmulni_intel snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss arc4 snd_pcm snd_page_alloc snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq thinkpad_acpi sdhci_pci i915 iTCO_wdt iTCO_vendor_support drm_kms_helper drm tpm_tis acpi_cpufreq tpm mperf psmouse evdev tpm_bios sdhci serio_raw i2c_algo_bit pcspkr mmc_core xhci_hcd ehci_hcd ac nvram battery wmi lpc_ich usbcore video processor button usb_common mei microcode snd_seq_device snd_timer i2c_i801 snd soundcore i2c_core rfkill raid456 multipath dm_snapshot dm_mirror dm_region_hash dm_log dm_crypt dm_mod async_raid6_recov async_pq async_xor raid6_pq async_memcpy async_tx xor blowfish_x86_64 blowfish_common ecb thermal thermal_sys crc32c_intel aesni_intel xts aes_x86_64 lrw gf128mul ablk_helper cryptd [last unloaded: cfg80211]
Pid: 11214, comm: mount Tainted: G           O 3.7.8-amd64-preempt-20130222 #1
Call Trace:
 [<ffffffff81040ed4>] warn_slowpath_common+0x7e/0x96
 [<ffffffff81040f01>] warn_slowpath_null+0x15/0x17
 [<ffffffff8120dff1>] walk_down_log_tree+0x51/0x307
 [<ffffffff8120e321>] walk_log_tree+0x7a/0x1bc
 [<ffffffff81210a3d>] btrfs_recover_log_trees+0x9f/0x2ff
 [<ffffffff8120eafa>] ? replay_one_buffer+0x26d/0x26d
 [<ffffffff811e2c7c>] open_ctree+0x1443/0x1823
 [<ffffffff81299bde>] ? string.isra.3+0x3d/0xa4
 [<ffffffff811c4f97>] btrfs_mount+0x36d/0x4cd
 [<ffffffff810ea49e>] ? pcpu_next_pop+0x38/0x45
 [<ffffffff810eb51b>] ? pcpu_alloc+0x7ee/0x82a
 [<ffffffff8112c9fe>] ? alloc_vfsmnt+0xa6/0x192
 [<ffffffff81118d2c>] mount_fs+0x64/0x150
 [<ffffffff810eb562>] ? __alloc_percpu+0xb/0xd
 [<ffffffff8112cdb7>] vfs_kern_mount+0x64/0xde
 [<ffffffff8112d19a>] do_kern_mount+0x48/0xda
 [<ffffffff8112ec68>] do_mount+0x6b1/0x714
 [<ffffffff810e74de>] ? memdup_user+0x37/0x5f
 [<ffffffff810e753d>] ? strndup_user+0x37/0x4c
 [<ffffffff8112ed4e>] sys_mount+0x83/0xbd
 [<ffffffff814c6bed>] system_call_fastpath+0x1a/0x1f
---[ end trace 29a8d40b4129ace6 ]---
------------[ cut here ]------------
WARNING: at fs/btrfs/tree-log.c:1988 walk_down_log_tree+0x6c/0x307()
Hardware name: 2429A78
Modules linked in: iwldvm mac80211 iwlwifi cfg80211 e1000e tun cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative ppdev rfcomm bnep autofs4 pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc uinput nfsd auth_rpcgss nfs_acl nfs lockd fscache sunrpc fuse configs parport_pc lp parport input_polldev loop firewire_sbp2 firewire_core crc_itu_t ecryptfs uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev media hid_generic btusb usbhid hid coretemp bluetooth kvm_intel kvm snd_hda_codec_realtek ghash_clmulni_intel snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss arc4 snd_pcm snd_page_alloc snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq thinkpad_acpi sdhci_pci i915 iTCO_wdt iTCO_vendor_support drm_kms_helper drm tpm_tis acpi_cpufreq tpm mperf psmouse evdev tpm_bios sdhci serio_raw i2c_algo_bit pcspkr mmc_core xhci_hcd ehci_hcd ac nvram battery wmi lpc_ich usbcore video processor button usb_common mei microcode snd_seq_device snd_timer i2c_i801 snd soundcore i2c_core rfkill raid456 multipath dm_snapshot dm_mirror dm_region_hash dm_log dm_crypt dm_mod async_raid6_recov async_pq async_xor raid6_pq async_memcpy async_tx xor blowfish_x86_64 blowfish_common ecb thermal thermal_sys crc32c_intel aesni_intel xts aes_x86_64 lrw gf128mul ablk_helper cryptd [last unloaded: cfg80211]
Pid: 11214, comm: mount Tainted: G        W  O 3.7.8-amd64-preempt-20130222 #1
Call Trace:
 [<ffffffff81040ed4>] warn_slowpath_common+0x7e/0x96
 [<ffffffff81040f01>] warn_slowpath_null+0x15/0x17
 [<ffffffff8120e00c>] walk_down_log_tree+0x6c/0x307
 [<ffffffff8120e321>] walk_log_tree+0x7a/0x1bc
 [<ffffffff81210a3d>] btrfs_recover_log_trees+0x9f/0x2ff
 [<ffffffff8120eafa>] ? replay_one_buffer+0x26d/0x26d
 [<ffffffff811e2c7c>] open_ctree+0x1443/0x1823
 [<ffffffff81299bde>] ? string.isra.3+0x3d/0xa4
 [<ffffffff811c4f97>] btrfs_mount+0x36d/0x4cd
 [<ffffffff810ea49e>] ? pcpu_next_pop+0x38/0x45
 [<ffffffff810eb51b>] ? pcpu_alloc+0x7ee/0x82a
 [<ffffffff8112c9fe>] ? alloc_vfsmnt+0xa6/0x192
 [<ffffffff81118d2c>] mount_fs+0x64/0x150
 [<ffffffff810eb562>] ? __alloc_percpu+0xb/0xd
 [<ffffffff8112cdb7>] vfs_kern_mount+0x64/0xde
 [<ffffffff8112d19a>] do_kern_mount+0x48/0xda
 [<ffffffff8112ec68>] do_mount+0x6b1/0x714
 [<ffffffff810e74de>] ? memdup_user+0x37/0x5f
 [<ffffffff810e753d>] ? strndup_user+0x37/0x4c
 [<ffffffff8112ed4e>] sys_mount+0x83/0xbd
 [<ffffffff814c6bed>] system_call_fastpath+0x1a/0x1f
---[ end trace 29a8d40b4129ace7 ]---
parent transid verify failed on 11731997996535126505 wanted 2669605077570711694 found 0
------------[ cut here ]------------
kernel BUG at fs/btrfs/volumes.c:3753!
invalid opcode: 0000 [#1] PREEMPT SMP 
Modules linked in: iwldvm mac80211 iwlwifi cfg80211 e1000e tun cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative ppdev rfcomm bnep autofs4 pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc uinput nfsd auth_rpcgss nfs_acl nfs lockd fscache sunrpc fuse configs parport_pc lp parport input_polldev loop firewire_sbp2 firewire_core crc_itu_t ecryptfs uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev media hid_generic btusb usbhid hid coretemp bluetooth kvm_intel kvm snd_hda_codec_realtek ghash_clmulni_intel snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss arc4 snd_pcm snd_page_alloc snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq thinkpad_acpi sdhci_pci i915 iTCO_wdt iTCO_vendor_support drm_kms_helper drm tpm_tis acpi_cpufreq tpm mperf psmouse evdev tpm_bios sdhci serio_raw i2c_algo_bit pcspkr mmc_core xhci_hcd ehci_hcd ac nvram battery wmi lpc_ich usbcore video processor button usb_common mei microcode snd_seq_device snd_timer i2c_i801 snd soundcore i2c_core rfkill raid456 multipath dm_snapshot dm_mirror dm_region_hash dm_log dm_crypt dm_mod async_raid6_recov async_pq async_xor raid6_pq async_memcpy async_tx xor blowfish_x86_64 blowfish_common ecb thermal thermal_sys crc32c_intel aesni_intel xts aes_x86_64 lrw gf128mul ablk_helper cryptd [last unloaded: cfg80211]
CPU 0 
Pid: 11214, comm: mount Tainted: G        W  O 3.7.8-amd64-preempt-20130222 #1 LENOVO 2429A78/2429A78
RIP: 0010:[<ffffffff81202160>]  [<ffffffff81202160>] btrfs_num_copies+0x42/0x8b
RSP: 0018:ffff88013329b948  EFLAGS: 00010246
RAX: 0000000000000000 RBX: a2d06e04e11219e9 RCX: 0000000000000001
RDX: ffffffffffffffff RSI: a2d06e04e11219e9 RDI: ffff88013329a000
RBP: ffff88013329b978 R08: 0000000000000000 R09: 00000000ffe7d802
R10: 00000000ffe7d802 R11: 00000000000000c0 R12: ffff88010267e138
R13: 0000000000000000 R14: 00000000fffffffb R15: 0000000000000000
FS:  00007f3b6578d7e0(0000) GS:ffff88021e200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000604130 CR3: 00000001419c5000 CR4: 00000000001407f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process mount (pid: 11214, threadinfo ffff88013329a000, task ffff880132d38180)
Stack:
 ffff88013329b968 0000000000001000 ffff8801df36a800 ffff8801ef7e25c0
 ffff8801df36a800 0000000000000000 ffff88013329b9d8 ffffffff811df295
 ffff88013043cc58 250c57ac832e708e 0000000000001000 ffff88013043cc50
Call Trace:
 [<ffffffff811df295>] btree_read_extent_buffer_pages.constprop.116+0xa8/0x105
 [<ffffffff811e0fbf>] btrfs_read_buffer+0x2a/0x2c
 [<ffffffff8120e1d0>] walk_down_log_tree+0x230/0x307
 [<ffffffff8120e321>] walk_log_tree+0x7a/0x1bc
 [<ffffffff81210a3d>] btrfs_recover_log_trees+0x9f/0x2ff
 [<ffffffff8120eafa>] ? replay_one_buffer+0x26d/0x26d
 [<ffffffff811e2c7c>] open_ctree+0x1443/0x1823
 [<ffffffff81299bde>] ? string.isra.3+0x3d/0xa4
 [<ffffffff811c4f97>] btrfs_mount+0x36d/0x4cd
 [<ffffffff810ea49e>] ? pcpu_next_pop+0x38/0x45
 [<ffffffff810eb51b>] ? pcpu_alloc+0x7ee/0x82a
 [<ffffffff8112c9fe>] ? alloc_vfsmnt+0xa6/0x192
 [<ffffffff81118d2c>] mount_fs+0x64/0x150
 [<ffffffff810eb562>] ? __alloc_percpu+0xb/0xd
 [<ffffffff8112cdb7>] vfs_kern_mount+0x64/0xde
 [<ffffffff8112d19a>] do_kern_mount+0x48/0xda
 [<ffffffff8112ec68>] do_mount+0x6b1/0x714
 [<ffffffff810e74de>] ? memdup_user+0x37/0x5f
 [<ffffffff810e753d>] ? strndup_user+0x37/0x4c
 [<ffffffff8112ed4e>] sys_mount+0x83/0xbd
 [<ffffffff814c6bed>] system_call_fastpath+0x1a/0x1f
Code: 83 ec 18 48 89 55 d8 e8 cf fc 2b 00 48 8b 55 d8 4c 89 ef 48 89 de e8 22 26 ff ff 4c 89 e7 49 89 c5 e8 7d ff 2b 00 4d 85 ed 75 02 <0f> 0b 49 8b 45 18 48 39 d8 77 09 49 03 45 20 48 39 d8 73 02 0f 
RIP  [<ffffffff81202160>] btrfs_num_copies+0x42/0x8b
 RSP <ffff88013329b948>
---[ end trace 29a8d40b4129ace8 ]---
Kernel panic - not syncing: Fatal exception


-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
