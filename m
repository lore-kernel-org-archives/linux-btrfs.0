Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:55906 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757381AbaDHPgY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Apr 2014 11:36:24 -0400
Received: from svh-gw.merlins.org ([173.11.111.145]:59333 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1WXY4K-0001Bk-KF by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Tue, 08 Apr 2014 08:36:23 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@legolas.merlins.org>)
	id 1WXY4H-0000Hu-RH
	for linux-btrfs@vger.kernel.org; Tue, 08 Apr 2014 08:36:09 -0700
Date: Tue, 8 Apr 2014 08:36:09 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <20140408153609.GE23524@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: Upgrade to 3.14.0 messed up raid0 array (btrfs cleaner crashes in
 fs/btrfs/extent-tree.c:5748 and fs/btrfs/free-space-cache.c:1183 )
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Soon after upgrading my server from 3.14rc5 to 3.14.0, my server went
into a crash loop.

Unfortunately because I used btrfs on my root filesystem, the problem
didn't get logged because btrfs failing on a separate array prevented
another thread to use btrfs to write on a healthy /var filesystem.

So I found my system in a reboot loop, and after commenting out the
devices in /etc/crypttab, prevented btrfs from mounting dm-5, which has
restored my system to sanity for now, but with a missing filesystem.

dm-5 was a 2 device raid0.
I'm afraid of mounting it, because I think it'll crash my system again, 
but I'm happy to run commands against it.

Question #1:
Will mounting with read-only stop the cleaner process?

Question #2:
Is mounting with recovery,ro and copying the data out if I can the best
way to recover?
(and destroying, recreating the filesystem after that)

Question #3:
Any idea what happened and what bug I hit?

Thanks,
Marc

Logs below:

Will now mount local filesystems:[   63.516591] EXT4-fs (md11): mounted filesystem with ordered data mode. Opts: (null)
[   63.540841] BTRFS: device label btrfs_boot devid 1 transid 130715 /dev/mapper/cryptroot
[   63.692581] BTRFS: device label btrfs_boot devid 1 transid 130715 /dev/mapper/cryptroot
[   63.836698] BTRFS: device label btrfs_boot devid 1 transid 130715 /dev/mapper/cryptroot
[   63.946790] BTRFS: device label btrfs_boot devid 1 transid 130715 /dev/mapper/cryptroot
[   64.119580] BTRFS: device label btrfs_raid0 devid 2 transid 50560 /dev/mapper/raid0d2
[   64.145339] BTRFS info (device dm-5): disk space caching is enabled
[   71.139007] BTRFS: device label btrfs_boot devid 1 transid 130715 /dev/mapper/cryptroot
[   71.337153] BTRFS: device label btrfs_raid0 devid 2 transid 50560 /dev/mapper/raid0d2
[   71.395269] BTRFS: device label btrfs_pool1 devid 1 transid 43963 /dev/mapper/dshelf1
[   71.420616] BTRFS info (device dm-1): disk space caching is enabled
[   96.523664] BTRFS: device label btrfs_pool2 devid 1 transid 42458 /dev/mapper/dshelf2
[   96.549209] BTRFS info (device dm-2): disk space caching is enabled
[   96.568833] BTRFS: has skinny extents
[  102.679436] ------------[ cut here ]------------
[  102.694202] WARNING: CPU: 2 PID: 3105 at fs/btrfs/extent-tree.c:5748 __btrfs_free_extent+0x359/0x712()
[  102.723152] Modules linked in: aes_x86_64 lm85 hwmon_vid dm_snapshot dm_bufio iptable_nat ip_tables nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_conntrack_ftp ipt_MASQUERADE nf_nat x_tables nf_conntrack sg st snd_pcm_oss snd_mixer_oss fuse snd_hda_codec_realtek microcode snd_hda_codec_generic snd_cmipci kvm_intel gameport kvm snd_hda_intel snd_hda_codec snd_opl3_lib eeepc_wmi snd_mpu401_uart snd_seq_midi snd_seq_midi_event snd_seq asus_wmi tpm_infineon snd_hwdep sparse_keymap snd_pcm snd_rawmidi coretemp rfkill battery snd_timer snd_seq_device intel_rapl rc_ati_x10 snd tpm_tis ati_remote processor x86_pkg_temp_thermal wmi tpm asix pl2303 lpc_ich i2c_i801 soundcore libphy parport_pc intel_powerclamp ftdi_sio keyspan parport usbnet pcspkr evdev rc_core xhci_hcd usbserial ezusb xts gf128mul dm_crypt dm_mod raid456 async_raid6_recov async_pq async_xor async_memcpy async_tx e1000e ptp pps_core crc32_pclmul crc32c_intel ehci_pci ehci_hcd crct10dif_pclmul sata_sil24 usbcore ghash_clmulni_intel cryptd fan thermal r8169 mii usb_common sata_mv
[  103.011058] CPU: 2 PID: 3105 Comm: btrfs-cleaner Not tainted 3.14.0-amd64-i915-preempt-20140216 #2
[  103.038925] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3806 08/20/2012
[  103.067351]  0000000000000000 ffff880213f63b38 ffffffff8160a06d 0000000000000000
[  103.090778]  ffff880213f63b70 ffffffff81050025 ffffffff812170f6 ffff880211a58f10
[  103.114210]  00000000fffffffe 0000000ee05cc000 0000000000000000 ffff880213f63b80
[  103.137678] Call Trace:
[  103.146122]  [<ffffffff8160a06d>] dump_stack+0x4e/0x7a
[  103.162653]  [<ffffffff81050025>] warn_slowpath_common+0x7f/0x98
[  103.181877]  [<ffffffff812170f6>] ? __btrfs_free_extent+0x359/0x712
[  103.201778]  [<ffffffff810500ec>] warn_slowpath_null+0x1a/0x1c
[  103.220393]  [<ffffffff812170f6>] __btrfs_free_extent+0x359/0x712
[  103.239793]  [<ffffffff8160f97b>] ? _raw_spin_unlock+0x17/0x2a
[  103.258428]  [<ffffffff8126518b>] ? btrfs_check_delayed_seq+0x84/0x90
[  103.278897]  [<ffffffff8121c262>] __btrfs_run_delayed_refs+0xa94/0xbdf
[  103.299623]  [<ffffffff8113fcf3>] ? __cache_free.isra.39+0x1b4/0x1c3
[  103.319852]  [<ffffffff8121df46>] btrfs_run_delayed_refs+0x81/0x18f
[  103.339823]  [<ffffffff8121ac3a>] ? walk_up_tree+0x72/0xf9
[  103.357452]  [<ffffffff8122af08>] btrfs_should_end_transaction+0x52/0x5b
[  103.378698]  [<ffffffff8121cba9>] btrfs_drop_snapshot+0x36f/0x610
[  103.398131]  [<ffffffff8122c73d>] btrfs_clean_one_deleted_snapshot+0x103/0x10f
[  103.420997]  [<ffffffff81224f09>] cleaner_kthread+0x103/0x136
[  103.439399]  [<ffffffff81224e06>] ? btrfs_alloc_root+0x26/0x26
[  103.458068]  [<ffffffff8106bc62>] kthread+0xae/0xb6
[  103.473886]  [<ffffffff8106bbb4>] ? __kthread_parkme+0x61/0x61
[  103.492615]  [<ffffffff8161637c>] ret_from_fork+0x7c/0xb0
[  103.509950]  [<ffffffff8106bbb4>] ? __kthread_parkme+0x61/0x61
[  103.528605] ---[ end trace a51c57d8cb84bfb4 ]---
[  103.543602] BTRFS info (device dm-5): leaf 264060928 total ptrs 186 free space 4751
[  103.568045]  item 0 key (1125730791424 168 40960) itemoff 16246 itemsize 37
[  103.590080]          extent refs 1 gen 12770 flags 1
[  103.604291]          shared data backref parent 223898337280 count 1
[  103.622671]  item 1 key (1125732311040 168 40960) itemoff 16209 itemsize 37
[  103.644693]          extent refs 1 gen 12770 flags 1
[  103.658909]          shared data backref parent 223898337280 count 1
[  103.677261]  item 2 key (1125733752832 168 40960) itemoff 16172 itemsize 37
[  103.699293]          extent refs 1 gen 12770 flags 1
[  103.713432]          shared data backref parent 223898337280 count 1
[  103.731703]  item 3 key (1125738274816 168 40960) itemoff 16135 itemsize 37
[  103.753599]          extent refs 1 gen 12770 flags 1
[  103.767668]          shared data backref parent 223898337280 count 1
[  103.785898]  item 4 key (1125740027904 168 40960) itemoff 16098 itemsize 37
[  103.807734]          extent refs 1 gen 12770 flags 1
[  103.821722]          shared data backref parent 223898337280 count 1
[  103.839879]  item 5 key (1125741158400 168 40960) itemoff 16061 itemsize 37
[  103.861682]          extent refs 1 gen 12770 flags 1
[  103.875633]          shared data backref parent 223898337280 count 1
[  103.893775]  item 6 key (1125742604288 168 40960) itemoff 16024 itemsize 37
[  103.915557]          extent refs 1 gen 12770 flags 1
[  103.929519]          shared data backref parent 223898468352 count 1
[  103.947641]  item 7 key (1125745111040 168 40960) itemoff 15987 itemsize 37
[  103.969435]          extent refs 1 gen 12770 flags 1
[  103.983401]          shared data backref parent 223898468352 count 1
[  104.001546]  item 8 key (1125746237440 168 40960) itemoff 15950 itemsize 37
[  104.023342]          extent refs 1 gen 12770 flags 1
[  104.037334]          shared data backref parent 223898468352 count 1
[  104.055509]  item 9 key (1125749014528 168 40960) itemoff 15913 itemsize 37
[  104.077335]          extent refs 1 gen 12770 flags 1
[  104.091347]          shared data backref parent 223898468352 count 1
[  104.109514]  item 10 key (1125751156736 168 40960) itemoff 15876 itemsize 37
[  104.131628]          extent refs 1 gen 12770 flags 1
[  104.145784]          shared data backref parent 223898468352 count 1
[  104.163977]  item 11 key (1125752602624 168 40960) itemoff 15839 itemsize 37
[  104.186107]          extent refs 1 gen 12770 flags 1
[  104.200151]          shared data backref parent 223898468352 count 1
[  104.218373]  item 12 key (1125755486208 168 40960) itemoff 15802 itemsize 37
[  104.240572]          extent refs 1 gen 12770 flags 1
[  104.254636]          shared data backref parent 223898468352 count 1
[  104.272895]  item 13 key (1125756932096 168 40960) itemoff 15765 itemsize 37
[  104.295062]          extent refs 1 gen 12770 flags 1
[  104.309145]          shared data backref parent 223898468352 count 1
[  104.327391]  item 14 key (1125758607360 168 40960) itemoff 15728 itemsize 37
[  104.349541]          extent refs 1 gen 12770 flags 1
[  104.363630]          shared data backref parent 223898468352 count 1
[  104.381880]  item 15 key (1125759422464 168 40960) itemoff 15691 itemsize 37
[  104.404193]          extent refs 1 gen 12770 flags 1
[  104.418281]          shared data backref parent 223898468352 count 1
[  104.436527]  item 16 key (1125762203648 168 40960) itemoff 15654 itemsize 37
[  104.458707]          extent refs 1 gen 12770 flags 1
[  104.472797]          shared data backref parent 223898468352 count 1
[  104.491049]  item 17 key (1125763727360 168 40960) itemoff 15617 itemsize 37
[  104.513226]          extent refs 1 gen 12770 flags 1
[  104.527314]          shared data backref parent 223898468352 count 1
[  104.545561]  item 18 key (1125765218304 168 40960) itemoff 15580 itemsize 37
[  104.567749]          extent refs 1 gen 12770 flags 1
[  104.581835]          shared data backref parent 223898468352 count 1
[  104.600110]  item 19 key (1125765726208 168 40960) itemoff 15543 itemsize 37
[  104.622290]          extent refs 1 gen 12770 flags 1
[  104.636377]          shared data backref parent 223898468352 count 1
[  104.654657]  item 20 key (1125766475776 168 40960) itemoff 15506 itemsize 37
[  104.676833]          extent refs 1 gen 12770 flags 1
[  104.690918]          shared data backref parent 223898468352 count 1
[  104.709197]  item 21 key (1125766668288 168 40960) itemoff 15469 itemsize 37
[  104.731375]          extent refs 1 gen 12770 flags 1
[  104.745463]          shared data backref parent 223898468352 count 1
[  104.763745]  item 22 key (1125767483392 168 40960) itemoff 15432 itemsize 37
[  104.785917]          extent refs 1 gen 12770 flags 1
[  104.800064]          shared data backref parent 223898468352 count 1
[  104.818330]  item 23 key (1125767868416 168 40960) itemoff 15395 itemsize 37
[  104.840515]          extent refs 1 gen 12770 flags 1
[  104.854637]          shared data backref parent 223898468352 count 1
[  104.872905]  item 24 key (1125771141120 168 40960) itemoff 15358 itemsize 37
[  104.895080]          extent refs 1 gen 12770 flags 1
[  104.909198]          shared data backref parent 223898468352 count 1
[  104.927474]  item 25 key (1125771886592 168 40960) itemoff 15321 itemsize 37
[  104.949648]          extent refs 1 gen 12770 flags 1
[  104.963760]          shared data backref parent 223898468352 count 1
[  104.982034]  item 26 key (1125773021184 168 40960) itemoff 15284 itemsize 37
[  105.004216]          extent refs 1 gen 12770 flags 1
[  105.018331]          shared data backref parent 223898468352 count 1
[  105.036604]  item 27 key (1125774393344 168 40960) itemoff 15247 itemsize 37
[  105.058784]          extent refs 1 gen 12770 flags 1
[  105.072898]          shared data backref parent 223898468352 count 1
[  105.091171]  item 28 key (1125779865600 168 40960) itemoff 15210 itemsize 37
[  105.113350]          extent refs 1 gen 12770 flags 1
[  105.127464]          shared data backref parent 223898468352 count 1
[  105.145740]  item 29 key (1125781073920 168 40960) itemoff 15173 itemsize 37
[  105.167919]          extent refs 1 gen 12770 flags 1
[  105.182036]          shared data backref parent 223898468352 count 1
[  105.200307]  item 30 key (1125782454272 168 40960) itemoff 15136 itemsize 37
[  105.222488]          extent refs 1 gen 12770 flags 1
[  105.236605]          shared data backref parent 223898468352 count 1
[  105.254879]  item 31 key (1125785354240 168 40960) itemoff 15099 itemsize 37
[  105.277055]          extent refs 1 gen 12770 flags 1
[  105.291166]          shared data backref parent 223898468352 count 1
[  105.309445]  item 32 key (1125785784320 168 40960) itemoff 15062 itemsize 37
[  105.331622]          extent refs 1 gen 12770 flags 1
[  105.345737]          shared data backref parent 223898468352 count 1
[  105.364011]  item 33 key (1125786988544 168 40960) itemoff 15025 itemsize 37
[  105.386193]          extent refs 1 gen 12770 flags 1
[  105.400302]          shared data backref parent 223898468352 count 1
[  105.418585]  item 34 key (1125790654464 168 40960) itemoff 14988 itemsize 37
[  105.440785]          extent refs 1 gen 12770 flags 1
[  105.454897]          shared data backref parent 223898468352 count 1
[  105.473181]  item 35 key (1125791793152 168 40960) itemoff 14951 itemsize 37
[  105.495381]          extent refs 1 gen 12770 flags 1
[  105.509493]          shared data backref parent 223898468352 count 1
[  105.527774]  item 36 key (1125793554432 168 40960) itemoff 14914 itemsize 37
[  105.550052]          extent refs 1 gen 12770 flags 1
[  105.564169]          shared data backref parent 223898468352 count 1
[  105.582441]  item 37 key (1125794611200 168 40960) itemoff 14877 itemsize 37
[  105.604643]          extent refs 1 gen 12770 flags 1
[  105.618762]          shared data backref parent 223898468352 count 1
[  105.637094]  item 38 key (1125797896192 168 40960) itemoff 14840 itemsize 37
[  105.659379]          extent refs 1 gen 12770 flags 1
[  105.673483]          shared data backref parent 223898468352 count 1
[  105.691765]  item 39 key (1125801062400 168 40960) itemoff 14803 itemsize 37
[  105.714015]          extent refs 1 gen 12770 flags 1
[  105.728135]          shared data backref parent 223898468352 count 1
[  105.746428]  item 40 key (1125802123264 168 40960) itemoff 14766 itemsize 37
[  105.768688]          extent refs 1 gen 12770 flags 1
[  105.782796]          shared data backref parent 223898468352 count 1
[  105.801145]  item 41 key (1125803565056 168 40960) itemoff 14729 itemsize 37
[  105.823332]          extent refs 1 gen 12770 flags 1
[  105.837445]          shared data backref parent 223898468352 count 1
[  105.855720]  item 42 key (1125804216320 168 40960) itemoff 14692 itemsize 37
[  105.877921]          extent refs 1 gen 12770 flags 1
[  105.892040]          shared data backref parent 223898468352 count 1
[  105.910310]  item 43 key (1125804675072 168 40960) itemoff 14655 itemsize 37
[  105.932487]          extent refs 1 gen 12770 flags 1
[  105.946599]          shared data backref parent 223898468352 count 1
[  105.964877]  item 44 key (1125804867584 168 40960) itemoff 14618 itemsize 37
[  105.987054]          extent refs 1 gen 12770 flags 1
[  106.001172]          shared data backref parent 223898468352 count 1
[  106.019443]  item 45 key (1125806006272 168 40960) itemoff 14581 itemsize 37
[  106.041617]          extent refs 1 gen 12770 flags 1
[  106.055743]          shared data backref parent 223898468352 count 1
[  106.074014]  item 46 key (1125807456256 168 40960) itemoff 14544 itemsize 37
[  106.096229]          extent refs 1 gen 12770 flags 1
[  106.110327]          shared data backref parent 223898468352 count 1
[  106.128616]  item 47 key (1125810675712 168 40960) itemoff 14507 itemsize 37
[  106.150814]          extent refs 1 gen 12770 flags 1
[  106.164927]          shared data backref parent 223898468352 count 1
[  106.183256]  item 48 key (1125812047872 168 40960) itemoff 14470 itemsize 37
[  106.205454]          extent refs 1 gen 12770 flags 1
[  106.219629]          shared data backref parent 223898468352 count 1
[  106.237898]  item 49 key (1125813186560 168 40960) itemoff 14433 itemsize 37
[  106.260080]          extent refs 1 gen 12770 flags 1
[  106.274206]          shared data backref parent 223898468352 count 1
[  106.292494]  item 50 key (1125814251520 168 40960) itemoff 14396 itemsize 37
[  106.314695]          extent refs 1 gen 12770 flags 1
(...)
[  113.651650]  item 185 key (1126124646400 168 45056) itemoff 9401 itemsize 37
[  113.673859]          extent refs 1 gen 12537 flags 1
[  113.687970]          shared data backref parent 63894044672 count 1
[  113.706013] BTRFS error (device dm-5): unable to find ref byte nr 1125950996480 parent 63893716992 root 0  owner 7977109 offset 0
[  113.788672] ------------[ cut here ]------------
[  113.803626] WARNING: CPU: 2 PID: 3105 at fs/btrfs/free-space-cache.c:1183 tree_insert_offset+0x81/0xc5()
[  113.833793] Modules linked in: aes_x86_64 lm85 hwmon_vid dm_snapshot dm_bufio iptable_nat ip_tables nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_conntrack_ftp ipt_MASQUERADE nf_nat x_tables nf_conntrack sg st snd_pcm_oss snd_mixer_oss fuse snd_hda_codec_realtek microcode snd_hda_codec_generic snd_cmipci kvm_intel gameport kvm snd_hda_intel snd_hda_codec snd_opl3_lib eeepc_wmi snd_mpu401_uart snd_seq_midi snd_seq_midi_event snd_seq asus_wmi tpm_infineon snd_hwdep sparse_keymap snd_pcm snd_rawmidi coretemp rfkill battery snd_timer snd_seq_device intel_rapl rc_ati_x10 snd tpm_tis ati_remote processor x86_pkg_temp_thermal wmi tpm asix pl2303 lpc_ich i2c_i801 soundcore libphy parport_pc intel_powerclamp ftdi_sio keyspan parport usbnet pcspkr evdev rc_core xhci_hcd usbserial ezusb xts gf128mul dm_crypt dm_mod raid456 async_raid6_recov async_pq async_xor async_memcpy async_tx e1000e ptp pps_core crc32_pclmul crc32c_intel ehci_pci ehci_hcd crct10dif_pclmul sata_sil24 usbcore ghash_clmulni_intel cryptd fan thermal r8169 mii usb_common sata_mv
[  114.125608] CPU: 2 PID: 3105 Comm: btrfs-cleaner Tainted: G        W    3.14.0-amd64-i915-preempt-20140216 #2
[  114.156659] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3806 08/20/2012
[  114.185373]  0000000000000000 ffff880213f63928 ffffffff8160a06d 0000000000000000
[  114.209071]  ffff880213f63960 ffffffff81050025 ffffffff8125e81a 00000000ffffffef
[  114.232737]  ffff88020ce2a1b0 0000000000000000 ffff8802125f8800 ffff880213f63970
[  114.256422] Call Trace:
[  114.265075]  [<ffffffff8160a06d>] dump_stack+0x4e/0x7a
[  114.281817]  [<ffffffff81050025>] warn_slowpath_common+0x7f/0x98
[  114.301150]  [<ffffffff8125e81a>] ? tree_insert_offset+0x81/0xc5
[  114.320518]  [<ffffffff810500ec>] warn_slowpath_null+0x1a/0x1c
[  114.339318]  [<ffffffff8125e81a>] tree_insert_offset+0x81/0xc5
[  114.358249]  [<ffffffff8125e88a>] link_free_space+0x2c/0x41
[  114.376238]  [<ffffffff81260f1b>] __load_free_space_cache+0x304/0x56c
[  114.396812]  [<ffffffff81261269>] load_free_space_cache+0xe6/0x199
[  114.416619]  [<ffffffff81141648>] ? kmem_cache_alloc_trace+0x11b/0x12b
[  114.437456]  [<ffffffff81216354>] cache_block_group+0x1b2/0x33d
[  114.456465]  [<ffffffff81085116>] ? finish_wait+0x65/0x65
[  114.473916]  [<ffffffff81216c49>] update_block_group.isra.38+0xaa/0x1fe
[  114.495009]  [<ffffffff81217449>] __btrfs_free_extent+0x6ac/0x712
[  114.514526]  [<ffffffff8160f97b>] ? _raw_spin_unlock+0x17/0x2a
[  114.533262]  [<ffffffff8126518b>] ? btrfs_check_delayed_seq+0x84/0x90
[  114.553842]  [<ffffffff8121c262>] __btrfs_run_delayed_refs+0xa94/0xbdf
[  114.574789]  [<ffffffff8113fcf3>] ? __cache_free.isra.39+0x1b4/0x1c3
[  114.595070]  [<ffffffff8121df46>] btrfs_run_delayed_refs+0x81/0x18f
[  114.615064]  [<ffffffff8121ac3a>] ? walk_up_tree+0x72/0xf9
[  114.632726]  [<ffffffff8122af08>] btrfs_should_end_transaction+0x52/0x5b
[  114.654014]  [<ffffffff8121cba9>] btrfs_drop_snapshot+0x36f/0x610
[  114.673530]  [<ffffffff8122c73d>] btrfs_clean_one_deleted_snapshot+0x103/0x10f
[  114.696360]  [<ffffffff81224f09>] cleaner_kthread+0x103/0x136
[  114.714783]  [<ffffffff81224e06>] ? btrfs_alloc_root+0x26/0x26
[  114.733435]  [<ffffffff8106bc62>] kthread+0xae/0xb6
[  114.749169]  [<ffffffff8106bbb4>] ? __kthread_parkme+0x61/0x61
[  114.767775]  [<ffffffff8161637c>] ret_from_fork+0x7c/0xb0
[  114.785052]  [<ffffffff8106bbb4>] ? __kthread_parkme+0x61/0x61
[  114.803608] ---[ end trace a51c57d8cb84bfb5 ]---
[  114.818501] BTRFS error (device dm-5): Duplicate entries in free space cache, dumping
[  114.843818] BTRFS error (device dm-5): failed to load free space cache for block group 1125310791680
[  114.873135] ------------[ cut here ]------------
[  114.888456] WARNING: CPU: 0 PID: 3105 at fs/btrfs/extent-tree.c:5748 __btrfs_free_extent+0x359/0x712()
[  114.917736] Modules linked in: aes_x86_64 lm85 hwmon_vid dm_snapshot dm_bufio iptable_nat ip_tables nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_conntrack_ftp ipt_MASQUERADE nf_nat x_tables nf_conntrack sg st snd_pcm_oss snd_mixer_oss fuse snd_hda_codec_realtek microcode snd_hda_codec_generic snd_cmipci kvm_intel gameport kvm snd_hda_intel snd_hda_codec snd_opl3_lib eeepc_wmi snd_mpu401_uart snd_seq_midi snd_seq_midi_event snd_seq asus_wmi tpm_infineon snd_hwdep sparse_keymap snd_pcm snd_rawmidi coretemp rfkill battery snd_timer snd_seq_device intel_rapl rc_ati_x10 snd tpm_tis ati_remote processor x86_pkg_temp_thermal wmi tpm asix pl2303 lpc_ich i2c_i801 soundcore libphy parport_pc intel_powerclamp ftdi_sio keyspan parport usbnet pcspkr evdev rc_core xhci_hcd usbserial ezusb xts gf128mul dm_crypt dm_mod raid456 async_raid6_recov async_pq async_xor async_memcpy async_tx e1000e ptp pps_core crc32_pclmul crc32c_intel ehci_pci ehci_hcd crct10dif_pclmul sata_sil24 usbcore ghash_clmulni_intel cryptd fan thermal r8169 mii usb_common sata_mv
[  115.207261] CPU: 0 PID: 3105 Comm: btrfs-cleaner Tainted: G        W    3.14.0-amd64-i915-preempt-20140216 #2
[  115.238090] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3806 08/20/2012
[  115.266591]  0000000000000000 ffff880213f63b38 ffffffff8160a06d 0000000000000000
[  115.290066]  ffff880213f63b70 ffffffff81050025 ffffffff812170f6 ffff880211a58f10
[  115.313567]  00000000fffffffe 0000000ee05cc000 0000000000000000 ffff880213f63b80
[  115.337073] Call Trace:
[  115.345558]  [<ffffffff8160a06d>] dump_stack+0x4e/0x7a
[  115.362133]  [<ffffffff81050025>] warn_slowpath_common+0x7f/0x98
[  115.381302]  [<ffffffff812170f6>] ? __btrfs_free_extent+0x359/0x712
[  115.401258]  [<ffffffff810500ec>] warn_slowpath_null+0x1a/0x1c
[  115.419913]  [<ffffffff812170f6>] __btrfs_free_extent+0x359/0x712
[  115.439328]  [<ffffffff81610200>] ? retint_signal+0x8c/0x8c
[  115.457198]  [<ffffffff8160f97b>] ? _raw_spin_unlock+0x17/0x2a
[  115.475833]  [<ffffffff8126518b>] ? btrfs_check_delayed_seq+0x84/0x90
[  115.496285]  [<ffffffff8121c262>] __btrfs_run_delayed_refs+0xa94/0xbdf
[  115.516999]  [<ffffffff8113fcf3>] ? __cache_free.isra.39+0x1b4/0x1c3
[  115.537191]  [<ffffffff8121df46>] btrfs_run_delayed_refs+0x81/0x18f
[  115.557128]  [<ffffffff8121ac3a>] ? walk_up_tree+0x72/0xf9
[  115.574739]  [<ffffffff8122af08>] btrfs_should_end_transaction+0x52/0x5b
[  115.595976]  [<ffffffff8121cba9>] btrfs_drop_snapshot+0x36f/0x610
[  115.615413]  [<ffffffff8122c73d>] btrfs_clean_one_deleted_snapshot+0x103/0x10f
[  115.638217]  [<ffffffff81224f09>] cleaner_kthread+0x103/0x136
[  115.656608]  [<ffffffff81224e06>] ? btrfs_alloc_root+0x26/0x26
[  115.675260]  [<ffffffff8106bc62>] kthread+0xae/0xb6
[  115.691028]  [<ffffffff8106bbb4>] ? __kthread_parkme+0x61/0x61
[  115.709660]  [<ffffffff8161637c>] ret_from_fork+0x7c/0xb0
[  115.726989]  [<ffffffff8106bbb4>] ? __kthread_parkme+0x61/0x61
[  115.745622] ---[ end trace a51c57d8cb84bfb6 ]---
[  115.760616] BTRFS info (device dm-5): leaf 264060928 total ptrs 185 free space 4813
[  115.784754]  item 0 key (1125730791424 168 40960) itemoff 16246 itemsize 37
[  115.806782]          extent refs 1 gen 12770 flags 1
[  115.821011]          shared data backref parent 223898337280 count 1
[  115.839401]  item 1 key (1125732311040 168 40960) itemoff 16209 itemsize 37
[  115.861406]          extent refs 1 gen 12770 flags 1
[  115.875593]          shared data backref parent 223898337280 count 1
[  115.893927]  item 2 key (1125733752832 168 40960) itemoff 16172 itemsize 37
[  115.915880]          extent refs 1 gen 12770 flags 1
[  115.929977]          shared data backref parent 223898337280 count 1
(...)
[  125.804965]  item 184 key (1126124646400 168 45056) itemoff 9438 itemsize 37
[  125.827174]          extent refs 1 gen 12537 flags 1
[  125.841290]          shared data backref parent 63894044672 count 1
[  125.859328] BTRFS error (device dm-5): unable to find ref byte nr 1125993029632 parent 63893716992 root 0  owner 7976978 offset 0
[  125.896481] ------------[ cut here ]------------
[  125.912031] WARNING: CPU: 2 PID: 3105 at fs/btrfs/extent-tree.c:5748 __btrfs_free_extent+0x359/0x712()
[  125.941657] Modules linked in: aes_x86_64 lm85 hwmon_vid dm_snapshot dm_bufio iptable_nat ip_tables nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_conntrack_ftp ipt_MASQUERADE nf_nat x_tables nf_conntrack sg st snd_pcm_oss snd_mixer_oss fuse snd_hda_codec_realtek microcode snd_hda_codec_generic snd_cmipci kvm_intel gameport kvm snd_hda_intel snd_hda_codec snd_opl3_lib eeepc_wmi snd_mpu401_uart snd_seq_midi snd_seq_midi_event snd_seq asus_wmi tpm_infineon snd_hwdep sparse_keymap snd_pcm snd_rawmidi coretemp rfkill battery snd_timer snd_seq_device intel_rapl rc_ati_x10 snd tpm_tis ati_remote processor x86_pkg_temp_thermal wmi tpm asix pl2303 lpc_ich i2c_i801 soundcore libphy parport_pc intel_powerclamp ftdi_sio keyspan parport usbnet pcspkr evdev rc_core xhci_hcd usbserial ezusb xts gf128mul dm_crypt dm_mod raid456 async_raid6_recov async_pq async_xor async_memcpy async_tx e1000e ptp pps_core crc32_pclmul crc32c_intel ehci_pci ehci_hcd crct10dif_pclmul sata_sil24 usbcore ghash_clmulni_intel cryptd fan thermal r8169 mii usb_common sata_mv
[  126.233519] CPU: 2 PID: 3105 Comm: btrfs-cleaner Tainted: G        W    3.14.0-amd64-i915-preempt-20140216 #2
[  126.264560] Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3806 08/20/2012
[  126.293279]  0000000000000000 ffff880213f63b38 ffffffff8160a06d 0000000000000000
[  126.316958]  ffff880213f63b70 ffffffff81050025 ffffffff812170f6 ffff880211a58f10
[  126.340621]  00000000fffffffe 0000000ee05cc000 0000000000000000 ffff880213f63b80
[  126.364309] Call Trace:
[  126.372966]  [<ffffffff8160a06d>] dump_stack+0x4e/0x7a
[  126.389719]  [<ffffffff81050025>] warn_slowpath_common+0x7f/0x98
[  126.409086]  [<ffffffff812170f6>] ? __btrfs_free_extent+0x359/0x712
[  126.429198]  [<ffffffff810500ec>] warn_slowpath_null+0x1a/0x1c
[  126.447995]  [<ffffffff812170f6>] __btrfs_free_extent+0x359/0x712
[  126.467566]  [<ffffffff8160f97b>] ? _raw_spin_unlock+0x17/0x2a
[  126.486341]  [<ffffffff8126518b>] ? btrfs_check_delayed_seq+0x84/0x90
[  126.507009]  [<ffffffff8121c262>] __btrfs_run_delayed_refs+0xa94/0xbdf
[  126.527865]  [<ffffffff8113fcf3>] ? __cache_free.isra.39+0x1b4/0x1c3
[  126.548231]  [<ffffffff8121df46>] btrfs_run_delayed_refs+0x81/0x18f
[  126.568283]  [<ffffffff8121ac3a>] ? walk_up_tree+0x72/0xf9
[  126.586109]  [<ffffffff8122af08>] btrfs_should_end_transaction+0x52/0x5b
[  126.607470]  [<ffffffff8121cba9>] btrfs_drop_snapshot+0x36f/0x610
[  126.626998]  [<ffffffff8122c73d>] btrfs_clean_one_deleted_snapshot+0x103/0x10f
[  126.649898]  [<ffffffff81224f09>] cleaner_kthread+0x103/0x136
[  126.668364]  [<ffffffff81224e06>] ? btrfs_alloc_root+0x26/0x26
[  126.687087]  [<ffffffff8106bc62>] kthread+0xae/0xb6
[  126.702931]  [<ffffffff8106bbb4>] ? __kthread_parkme+0x61/0x61
[  126.721652]  [<ffffffff8161637c>] ret_from_fork+0x7c/0xb0
[  126.739054]  [<ffffffff8106bbb4>] ? __kthread_parkme+0x61/0x61
[  126.757757] ---[ end trace a51c57d8cb84bfb7 ]---
[  126.772784] BTRFS info (device dm-5): leaf 264060928 total ptrs 184 free space 4875
[  126.796952]  item 0 key (1125730791424 168 40960) itemoff 16246 itemsize 37
[  126.819017]          extent refs 1 gen 12770 flags 1
[  126.833247]          shared data backref parent 223898337280 count 1
[  126.851622]  item 1 key (1125732311040 168 40960) itemoff 16209 itemsize 37
[  126.873650]          extent refs 1 gen 12770 flags 1
[  126.887857]          shared data backref parent 223898337280 count 1
[  126.906246]  item 2 key (1125733752832 168 40960) itemoff 16172 itemsize 37
[  126.928237]          extent refs 1 gen 12770 flags 1
[  126.942386]          shared data backref parent 223898337280 count 1
(...)


-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
