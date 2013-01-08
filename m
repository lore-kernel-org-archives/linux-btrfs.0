Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:35737 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380Ab3AHQt7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2013 11:49:59 -0500
Date: Tue, 8 Jan 2013 08:49:58 -0800
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: kernel BUG at fs/btrfs/volumes.c:3707 still not fixed in 3.7.1 (btrfs-zero-log required) but shown as "RIP btrfs_num_copies"
Message-ID: <20130108164958.GA2044@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Unfortunately my laptop deadlocks from time to time, and too often
it triggers this bug in btrfs which is quite hard to recover from.

The bigger problem is that all the user sees (if anything) is seemingly 
unrelated info, namely, "RIP: btrfs_num_copies+0x42/0x0b" or somesuch
http://marc.merlins.org/tmp/btrfs_num_copies.jpg

It's only if you have serial console, or netconsole, which we can't really
assume the average users to have, that you can get the correct oops and bug
info.
I lost another 3 hours with many reboots and a recovery drive to recover my
root drive.

Question #1:
I have hourly snapshots of my root filesystem, and I wasn't able to mount
any of them. I got the BUG at fs/btrfs/volumes.c:3707 each time.
gandalfthegreat:~# mount -o ro,recovery /dev/mapper/root -o 'subvol=root_daily_20130108_00:01:02,defaults,compress=lzo,discard,nossd,space_cache,noatime'

If my log is damaged, why are all other snapshots also broken?


Question #2:
This btrfs-zero-log business, which in the end fixed my problem, should 
not be a routine recovery method, especially because the ooops you get on
your screen doesn't have the proper info that tells you that it's actually
the right bug as described on
https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#I_can.27t_mount_my_filesystem.2C_and_I_get_a_kernel_oops.21

Could mainline kernels be fixed not to oops so badly and in a hard to debug 
way when this problem which happens too often (at least for me), is hit?


If that helps, here's what I got after the fact when trying to mount the
broken filesystem before zero'ing logs

[ 3964.728509] btrfs bad tree block start 2075122916315869932 4268204032
[ 3964.728714] btrfs bad tree block start 12746175583536274708 4268204032
[ 3964.728748] ------------[ cut here ]------------
[ 3964.728771] WARNING: at fs/btrfs/tree-log.c:1728 walk_down_log_tree+0x51/0x307()
[ 3964.730058] WARNING: at fs/btrfs/tree-log.c:1732 walk_down_log_tree+0x6c/0x307()
[ 3964.731287] kernel BUG at fs/btrfs/volumes.c:3707!
(full log below)


gandalfthegreat:~# btrfs-calc-size /dev/mapper/root 
Check tree block failed, want=4268204032, have=2075122916315869932
Check tree block failed, want=4268204032, have=2075122916315869932
Check tree block failed, want=4268204032, have=12746175583536274708
Check tree block failed, want=4268204032, have=2075122916315869932
Check tree block failed, want=4268204032, have=2075122916315869932
read block failed check_tree_block
Calculating size of root tree
	212.00KB total size, 0.00 inline data, 1 nodes, 52 leaves, 2 levels
Calculating size of extent tree
	396.43MB total size, 0.00 inline data, 1518 nodes, 99968 leaves, 4 levels
Calculating size of csum tree
	430.36MB total size, 0.00 inline data, 1434 nodes, 108737 leaves, 4 levels
Calculatin' size of fs tree
	16.00KB total size, 0.00 inline data, 1 nodes, 3 leaves, 2 levels


gandalfthegreat:~# btrfs-find-root /dev/mapper/root 
Super think's the tree root is at 4203188224, chunk root 20979712
Found tree root at 4203188224
gandalfthegreat:~# 

gandalfthegreat:~# btrfs filesystem show
Label: 'btrfs_pool1'  uuid: 92584fa9-85cd-4df6-b182-d32198b76a0b
	Total devices 1 FS bytes used 315.26GB
	devid    1 size 441.70GB used 441.70GB path /dev/dm-1

Label: 'btrfs_pool2'  uuid: 04071703-df6b-4022-9632-6c3aeabff206
	Total devices 1 FS bytes used 770.67GB
	devid    1 size 872.51GB used 872.51GB path /dev/dm-0


gandalfthegreat:~# btrfs-zero-log /dev/mapper/root 
Check tree block failed, want=4268204032, have=2075122916315869932
Check tree block failed, want=4268204032, have=2075122916315869932
Check tree block failed, want=4268204032, have=12746175583536274708
Check tree block failed, want=4268204032, have=2075122916315869932
Check tree block failed, want=4268204032, have=2075122916315869932
read block failed check_tree_block
gandalfthegreat:~# btrfs-zero-log /dev/mapper/root 
gandalfthegreat:~# 


Full kernel debug info:
[ 3829.908692] device label btrfs_pool2 devid 1 transid 66367 /dev/mapper/cryptroot
[ 3964.563483] device label btrfs_pool1 devid 1 transid 305644 /dev/mapper/root
[ 3964.564164] btrfs: enabling auto recovery
[ 3964.564172] btrfs: disk space caching is enabled
[ 3964.728275] Btrfs detected SSD devices, enabling SSD mode
[ 3964.728509] btrfs bad tree block start 2075122916315869932 4268204032
[ 3964.728714] btrfs bad tree block start 12746175583536274708 4268204032
[ 3964.728748] ------------[ cut here ]------------
[ 3964.728771] WARNING: at fs/btrfs/tree-log.c:1728 walk_down_log_tree+0x51/0x307()
[ 3964.728796] Hardware name: 2429A78
[ 3964.728804] Modules linked in: tun cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative ppdev rfcomm bnep autofs4 binfmt_misc uinput nfsd auth_rpcgss nfs_acl nfs lockd fscache sunrpc fuse configs parport_pc lp parport input_polldev loop firewire_sbp2 firewire_core crc_itu_t ecryptfs uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev btusb hid_generic usbhid bluetooth media hid snd_hda_codec_realtek thinkpad_acpi snd_hda_intel snd_hda_codec nvram i915 snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq arc4 button battery iwldvm mac80211 iwlwifi iTCO_wdt coretemp iTCO_vendor_support psmouse kvm_intel snd_seq_device acpi_cpufreq drm_kms_helper drm video mperf xhci_hcd ehci_hcd i2c_i801 i2c_algo_bit kvm e1000e serio_raw evdev snd_timer processor i2c_core tpm_tis wmi tpm sdhci_pci mei sdhci pcspkr ac snd cfg80211 mmc_core lpc_ich soundcore rfkill usbcore tpm_bios ghash_clmulni_intel usb_common microcode raid456 multipath dm_snapshot dm_mirror dm_region_hash dm_log dm_crypt dm_mod async_raid6_recov async_pq async_xor raid6_pq async_memcpy async_tx xor blowfish_x86_64 blowfish_common ecb xts gf128mul crc32c_intel aesni_intel aes_x86_64 ablk_helper cryptd thermal thermal_sys
[ 3964.729795] Pid: 10083, comm: mount Not tainted 3.6.3-amd64-preempt-20120903 #1
[ 3964.729801] Call Trace:
[ 3964.729816]  [<ffffffff81040854>] warn_slowpath_common+0x7e/0x96
[ 3964.729836]  [<ffffffff81040881>] warn_slowpath_null+0x15/0x17
[ 3964.729845]  [<ffffffff81205f64>] walk_down_log_tree+0x51/0x307
[ 3964.729853]  [<ffffffff81206294>] walk_log_tree+0x7a/0x1bc
[ 3964.729862]  [<ffffffff81207ab8>] btrfs_recover_log_trees+0x9f/0x2ff
[ 3964.729881]  [<ffffffff81206a32>] ? replay_one_buffer+0x235/0x235
[ 3964.729891]  [<ffffffff811dcbe5>] open_ctree+0x143d/0x1820
[ 3964.729899]  [<ffffffff8128ffcc>] ? string.isra.3+0x3d/0xa4
[ 3964.729911]  [<ffffffff811bf3a2>] btrfs_mount+0x36d/0x4cd
[ 3964.729920]  [<ffffffff810e8412>] ? pcpu_next_pop+0x38/0x45
[ 3964.729942]  [<ffffffff8112a102>] ? alloc_vfsmnt+0xa6/0x192
[ 3964.729953]  [<ffffffff81116207>] mount_fs+0x64/0x14d
[ 3964.729961]  [<ffffffff810e94d8>] ? __alloc_percpu+0xb/0xd
[ 3964.729971]  [<ffffffff8112a4bb>] vfs_kern_mount+0x64/0xde
[ 3964.729990]  [<ffffffff8112a89e>] do_kern_mount+0x48/0xda
[ 3964.729998]  [<ffffffff8112c366>] do_mount+0x6b1/0x714
[ 3964.730010]  [<ffffffff810d2fb7>] ? __get_free_pages+0x9/0x45
[ 3964.730018]  [<ffffffff8112c44c>] sys_mount+0x83/0xbd
[ 3964.730038]  [<ffffffff814b60fd>] system_call_fastpath+0x1a/0x1f
[ 3964.730045] ---[ end trace cb9b09d3eae7696a ]---
[ 3964.730050] ------------[ cut here ]------------

[ 3964.730058] WARNING: at fs/btrfs/tree-log.c:1732 walk_down_log_tree+0x6c/0x307()
[ 3964.730063] Hardware name: 2429A78
[ 3964.730069] Modules linked in: tun cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative ppdev rfcomm bnep autofs4 binfmt_misc uinput nfsd auth_rpcgss nfs_acl nfs lockd fscache sunrpc fuse configs parport_pc lp parport input_polldev loop firewire_sbp2 firewire_core crc_itu_t ecryptfs uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev btusb hid_generic usbhid bluetooth media hid snd_hda_codec_realtek thinkpad_acpi snd_hda_intel snd_hda_codec nvram i915 snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq arc4 button battery iwldvm mac80211 iwlwifi iTCO_wdt coretemp iTCO_vendor_support psmouse kvm_intel snd_seq_device acpi_cpufreq drm_kms_helper drm video mperf xhci_hcd ehci_hcd i2c_i801 i2c_algo_bit kvm e1000e serio_raw evdev snd_timer processor i2c_core tpm_tis wmi tpm sdhci_pci mei sdhci pcspkr ac snd cfg80211 mmc_core lpc_ich soundcore rfkill usbcore tpm_bios ghash_clmulni_intel usb_common microcode raid456 multipath dm_snapshot dm_mirror dm_region_hash dm_log dm_crypt dm_mod async_raid6_recov async_pq async_xor raid6_pq async_memcpy async_tx xor blowfish_x86_64 blowfish_common ecb xts gf128mul crc32c_intel aesni_intel aes_x86_64 ablk_helper cryptd thermal thermal_sys
[ 3964.730924] Pid: 10083, comm: mount Tainted: G        W    3.6.3-amd64-preempt-20120903 #1
[ 3964.730929] Call Trace:
[ 3964.730951]  [<ffffffff81040854>] warn_slowpath_common+0x7e/0x96
[ 3964.730961]  [<ffffffff81040881>] warn_slowpath_null+0x15/0x17
[ 3964.730969]  [<ffffffff81205f7f>] walk_down_log_tree+0x6c/0x307
[ 3964.730977]  [<ffffffff81206294>] walk_log_tree+0x7a/0x1bc
[ 3964.730986]  [<ffffffff81207ab8>] btrfs_recover_log_trees+0x9f/0x2ff
[ 3964.731006]  [<ffffffff81206a32>] ? replay_one_buffer+0x235/0x235
[ 3964.731015]  [<ffffffff811dcbe5>] open_ctree+0x143d/0x1820
[ 3964.731023]  [<ffffffff8128ffcc>] ? string.isra.3+0x3d/0xa4
[ 3964.731034]  [<ffffffff811bf3a2>] btrfs_mount+0x36d/0x4cd
[ 3964.731051]  [<ffffffff810e8412>] ? pcpu_next_pop+0x38/0x45
[ 3964.731061]  [<ffffffff8112a102>] ? alloc_vfsmnt+0xa6/0x192
[ 3964.731071]  [<ffffffff81116207>] mount_fs+0x64/0x14d
[ 3964.731079]  [<ffffffff810e94d8>] ? __alloc_percpu+0xb/0xd
[ 3964.731098]  [<ffffffff8112a4bb>] vfs_kern_mount+0x64/0xde
[ 3964.731107]  [<ffffffff8112a89e>] do_kern_mount+0x48/0xda
[ 3964.731115]  [<ffffffff8112c366>] do_mount+0x6b1/0x714
[ 3964.731124]  [<ffffffff810d2fb7>] ? __get_free_pages+0x9/0x45
[ 3964.731131]  [<ffffffff8112c44c>] sys_mount+0x83/0xbd
[ 3964.731150]  [<ffffffff814b60fd>] system_call_fastpath+0x1a/0x1f
[ 3964.731157] ---[ end trace cb9b09d3eae7696b ]---

[ 3964.731201] parent transid verify failed on 10056379431157275594 wanted 6327746181234947034 found 0
[ 3964.731227] ------------[ cut here ]------------
[ 3964.731287] kernel BUG at fs/btrfs/volumes.c:3707!
[ 3964.731342] invalid opcode: 0000 [#1] PREEMPT SMP
[ 3964.731415] Modules linked in: tun cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative ppdev rfcomm bnep autofs4 binfmt_misc uinput nfsd auth_rpcgss nfs_acl nfs lockd fscache sunrpc fuse configs parport_pc lp parport input_polldev loop firewire_sbp2 firewire_core crc_itu_t ecryptfs uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev btusb hid_generic usbhid bluetooth media hid snd_hda_codec_realtek thinkpad_acpi snd_hda_intel snd_hda_codec nvram i915 snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq arc4 button battery iwldvm mac80211 iwlwifi iTCO_wdt coretemp iTCO_vendor_support psmouse kvm_intel snd_seq_device acpi_cpufreq drm_kms_helper drm video mperf xhci_hcd ehci_hcd i2c_i801 i2c_algo_bit kvm e1000e serio_raw evdev snd_timer processor i2c_core tpm_tis wmi tpm sdhci_pci mei sdhci pcspkr ac snd cfg80211 mmc_core lpc_ich soundcore rfkill usbcore tpm_bios ghash_clmulni_intel usb_common microcode raid456 multipath dm_snapshot dm_mirror dm_region_hash dm_log dm_crypt dm_mod async_raid6_recov async_pq async_xor raid6_pq async_memcpy async_tx xor blowfish_x86_64 blowfish_common ecb xts gf128mul crc32c_intel aesni_intel aes_x86_64 ablk_helper cryptd thermal thermal_sys
[ 3964.733325] CPU 0
[ 3964.733354] Pid: 10083, comm: mount Tainted: G        W    3.6.3-amd64-preempt-20120903 #1 LENOVO 2429A78/2429A78
[ 3964.733464] RIP: 0010:[<ffffffff811fabfa>]  [<ffffffff811fabfa>] btrfs_num_copies+0x42/0x8b
[ 3964.733563] RSP: 0018:ffff88020f3c1948  EFLAGS: 00010246
[ 3964.733622] RAX: 0000000000000000 RBX: 8b8f6fcfc8ac9bca RCX: 0000000000000001
[ 3964.733698] RDX: ffffffffffffffff RSI: 8b8f6fcfc8ac9bca RDI: ffff88020f3c0000
[ 3964.733775] RBP: ffff88020f3c1978 R08: 00000000ffffffff R09: 00000000ffec3402
[ 3964.733850] R10: 00000000ffec3402 R11: 00000000000000c0 R12: ffff88021e0fc128
[ 3964.733925] R13: 0000000000000000 R14: 00000000fffffffb R15: 0000000000000000
[ 3964.734001] FS:  00007f9d21e957e0(0000) GS:ffff88021e200000(0000) knlGS:0000000000000000
[ 3964.734086] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 3964.734148] CR2: 00007fff9d573b18 CR3: 0000000129052000 CR4: 00000000001407f0
[ 3964.734222] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 3964.734297] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 3964.734374] Process mount (pid: 10083, threadinfo ffff88020f3c0000, task ffff88021e0d4580)
[ 3964.734458] Stack:
[ 3964.734485]  ffff88020f3c1968 0000000000001000 ffff88021e16e000 ffff8801e946a1b8
[ 3964.734586]  ffff88021e16e000 0000000000000000 ffff88020f3c19d8 ffffffff811d93d2
[ 3964.734689]  ffff88017ee38828 57d0aba04157f3da 0000000000001000 ffff88017ee38820
[ 3964.734792] Call Trace:
[ 3964.734830]  [<ffffffff811d93d2>] btree_read_extent_buffer_pages.constprop.118+0xa8/0x105
[ 3964.734920]  [<ffffffff811daf17>] btrfs_read_buffer+0x2a/0x2c
[ 3964.734984]  [<ffffffff81206143>] walk_down_log_tree+0x230/0x307
[ 3964.735052]  [<ffffffff81206294>] walk_log_tree+0x7a/0x1bc
[ 3964.735116]  [<ffffffff81207ab8>] btrfs_recover_log_trees+0x9f/0x2ff
[ 3964.735186]  [<ffffffff81206a32>] ? replay_one_buffer+0x235/0x235
[ 3964.735257]  [<ffffffff811dcbe5>] open_ctree+0x143d/0x1820
[ 3964.735319]  [<ffffffff8128ffcc>] ? string.isra.3+0x3d/0xa4
[ 3964.735385]  [<ffffffff811bf3a2>] btrfs_mount+0x36d/0x4cd
[ 3964.735446]  [<ffffffff810e8412>] ? pcpu_next_pop+0x38/0x45
[ 3964.735512]  [<ffffffff8112a102>] ? alloc_vfsmnt+0xa6/0x192
[ 3964.735580]  [<ffffffff81116207>] mount_fs+0x64/0x14d
[ 3964.735638]  [<ffffffff810e94d8>] ? __alloc_percpu+0xb/0xd
[ 3964.735703]  [<ffffffff8112a4bb>] vfs_kern_mount+0x64/0xde
[ 3964.735768]  [<ffffffff8112a89e>] do_kern_mount+0x48/0xda
[ 3964.735829]  [<ffffffff8112c366>] do_mount+0x6b1/0x714
[ 3964.735889]  [<ffffffff810d2fb7>] ? __get_free_pages+0x9/0x45
[ 3964.735954]  [<ffffffff8112c44c>] sys_mount+0x83/0xbd
[ 3964.736014]  [<ffffffff814b60fd>] system_call_fastpath+0x1a/0x1f
[ 3964.736080] Code: 83 ec 18 48 89 55 d8 e8 05 69 2b 00 48 8b 55 d8 4c 89 ef 48 89 de e8 ad 28 ff ff 4c 89 e7 49 89 c5 e8 b3 6b 2b 00 4d 85 ed 75 02 <0f> 0b 49 8b 45 18 48 39 d8 77 09 49 03 45 20 48 39 d8 73 02 0f
[ 3964.737062] RIP  [<ffffffff811fabfa>] btrfs_num_copies+0x42/0x8b
[ 3964.737139]  RSP <ffff88020f3c1948>
[ 3964.779792] ---[ end trace cb9b09d3eae7696c ]---
[ 3964.779807] Kernel panic - not syncing: Fatal exception

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
