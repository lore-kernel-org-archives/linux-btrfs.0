Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43359 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdJ0Ekb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Oct 2017 00:40:31 -0400
Date: Thu, 26 Oct 2017 21:36:11 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Guillaume Bouchard <bouchard@mercs-eng.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: brtfs BUG and erroneous IO
Message-ID: <20171027043610.GB18058@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CAGh0HCAeY4NFHeLdVcBarUB5LOKzdUmdWNyaiYdWGxoMTeOkcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGh0HCAeY4NFHeLdVcBarUB5LOKzdUmdWNyaiYdWGxoMTeOkcQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 26, 2017 at 09:01:33PM +0200, Guillaume Bouchard wrote:
> Hi.
> 
> I have a btrfs filesystem on linux 4.13.9 mounted with this options:
> 
> /dev/sda3 on / type btrfs (rw,relatime,ssd,space_cache,subvolid=5,subvol=/)
> /dev/sda3 on /nix/store type btrfs
> (ro,relatime,ssd,space_cache,subvolid=5,subvol=/nix/store)
> 
> (on nixos-17.09). I had the same issues with linux 4.9, the default
> kernel of my distribution.
> 
> I have a "BUG" wich appears in /dev/kmsg, short version (full version
> at the end of the email):
> 
> $ cat /dev/kmsg | grep BUG
> 2,1019,15265010400,-;kernel BUG at
> /tmp/nix-build-linux-4.13.9.drv-0/linux-4.13.9/fs/btrfs/inode.c:5815!
> 1,1065,15265079807,-;BUG: unable to handle kernel paging request at
> fffffffeff840020
> 
> This "BUG" appears when I try to "du -sh ." in my /home, it
> immediately results in a segmentation fault.
> 
> This fails reliably. However if I'm running again du -sh ., I have
> different possible behaviors, including the correct one, a total
> freeze of the system for an undefined amount of time or a freeze of
> the command.
> 
> When the command freeze, there is no solution to kill it. It sometimes
> appears in ps as Zombie or as uninterruptible sleep. When it is
> zombie, it is impossible to reap it (even init cannot do it).
> 
> I observed the same issue with many other command, with similar
> behaviors. "cd", "rm", "chromium", ... It usually ends with dozens of
> "defunct" processes, a system progressively blocked and a reboot. Note
> that it does not appears with a simple "find" in my home directory, so
> I suppose that it is only triggered by commands which are doing more
> than a simple directory listing. I think it happen on "cd" too because
> my shell is reading for VCS informations on the current directory. I
> also observed that some directory are triggering the issue when some
> others are not.
> 
> If I "strace" the "du -sh ." command, the last lines before the
> segmentation fault are:
> 
> fstatfs(8, {f_type=BTRFS_SUPER_MAGIC, f_bsize=4096,
> f_blocks=105154001, f_bfree=45472674, f_bavail=45061125, f_files=0,
> f_ffree=0, f_fsid={val=[73204674, 1138503007]}, f_namelen=255,
> f_frsize=4096, f_flags=ST_VALID|ST_RELATIME}) = 0
> brk(0x1112000)                          = 0x1112000
> sysinfo({uptime=1293, loads=[20192, 15904, 12416],
> totalram=33640140800, freeram=31046250496, sharedram=15400960,
> bufferram=2162688, totalswap=38654701568, freeswap=38654701568,
> procs=533, totalhigh=0, freehigh=0, mem_unit=1}) = 0
> newfstatat(8, "60cadaa98932a732_0",  <unfinished ...>) = ?
> +++ killed by SIGSEGV +++
> [1]    2387 segmentation fault  strace du -sh
> 
> so it faults inside a newfstatat, which confirms my hypothesis that it
> is more than just listing the directory content.
> 
> Someone (sorry, I forgot name) on irc suggested that I may have a
> corrupted data or metadata and that it may be possible to fix it using
> the usual process (fsck and perhaps a scrub / defrag / trim of the
> disk). However he also says that corrupted data should fail more
> gracefully and that I'll help the development of btrfs by reporting
> the bug before any attempt to fix the corruption.

Thanks for all the details, given the log you attached here, the
information (file's metadata) that du read from the disk is simply
wrong, and it ended up with the following BUG_ON().  However, the NULL
pointer looks irrelavant to btrfs and comes from kthread workers.

Since the metadata checksum reported no problems, that incorrect
file's metadata got written into disk in an earlier time, probably due
to memory errors or something similar.

I'm not sure how to remove it (I think 'rm' would also call
lookup_path), but anyway we could surely bail out gracefully with a
warning in this case rather than putting a BUG_ON().  You can expect a
fix in the future release.

thanks,

-liubo

> 
> Thank you
> 
> Now the FULL LOG, starting from the first BUG event.
> 
> 4,964,55824786,-;------------[ cut here ]------------
> 2,965,55824789,-;kernel BUG at
> /tmp/nix-build-linux-4.13.9.drv-0/linux-4.13.9/fs/btrfs/inode.c:5815!
> 4,966,55824794,-;invalid opcode: 0000 [#1] SMP
> 4,967,55824795,-;Modules linked in: fuse af_packet msr
> snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic
> iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv6 nf_defrag_ipv6
> nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack libcrc32c
> ip6t_rpfilter ipt_rpfilter ip6table_raw iptable_raw xt_pkttype
> nf_log_ipv6 nf_log_ipv4 nf_log_common xt_LOG xt_tcpudp ip6table_filter
> ip6_tables edac_core iptable_filter x86_pkg_temp_thermal
> intel_powerclamp coretemp crct10dif_pclmul crc32_pclmul
> ghash_clmulni_intel pcbc uvcvideo snd_usb_audio videobuf2_vmalloc
> videobuf2_memops videobuf2_v4l2 snd_hda_intel videobuf2_core mousedev
> aesni_intel snd_usbmidi_lib snd_hda_codec nvidia_drm(PO) snd_rawmidi
> drm_kms_helper aes_x86_64 input_leds uas joydev led_class crypto_simd
> videodev snd_seq_device evdev usb_storage
> 4,968,55824820,c; glue_helper usblp snd_hda_core iTCO_wdt cryptd
> efi_pstore mxm_wmi mac_hid e1000e drm snd_hwdep pstore tpm_tis snd_pcm
> mei_me agpgart snd_timer fb_sys_fops intel_cstate tpm_tis_core
> syscopyarea snd sysfillrect intel_uncore sysimgblt ptp intel_rapl_perf
> mei soundcore efivars pps_core lpc_ich tpm shpchp nvidia_modeset(PO)
> nvidia_uvm(PO) nvidia(PO) wmi i2c_core arc4 ecb ppp_mppe ppp_generic
> slhc button atkbd libps2 loop cpufreq_ondemand vboxnetflt(O)
> vboxnetadp(O) vboxdrv(O) kvm_intel kvm irqbypass efivarfs ip_tables
> x_tables ipv6 crc_ccitt autofs4 hid_generic usbhid hid sd_mod ahci
> xhci_pci libahci xhci_hcd ehci_pci ehci_hcd libata usbcore scsi_mod
> usb_common serio rtc_cmos dm_mod dax crc32c_generic crc32c_intel btrfs
> xor raid6_pq
> 4,969,55824851,-;CPU: 7 PID: 3264 Comm: du Tainted: P           O
> 4.13.9 #1-NixOS
> 4,970,55824852,-;Hardware name: MSI MS-7885/X99A RAIDER (MS-7885),
> BIOS P.50 07/19/2016
> 4,971,55824854,-;task: ffff98425bc69b80 task.stack: ffffaa9589564000
> 4,972,55824873,-;RIP: 0010:btrfs_lookup_dentry+0x384/0x490 [btrfs]
> 4,973,55824874,-;RSP: 0018:ffffaa9589567b40 EFLAGS: 00010293
> 4,974,55824876,-;RAX: 0000000000000081 RBX: ffff9842330cd6e8 RCX:
> 0000000000003d7b
> 4,975,55824877,-;RDX: 0000000000003d7a RSI: ffff98435f3e3ae0 RDI:
> ffffe6b3a25974c0
> 4,976,55824879,-;RBP: ffffaa9589567bb8 R08: 0000000000023ae0 R09:
> ffffffffc028aa76
> 4,977,55824880,-;R10: 0000000000001000 R11: 0000000000000003 R12:
> ffff984235b7cd80
> 4,978,55824881,-;R13: ffff9843580bc000 R14: ffff9843565d3d90 R15:
> 0000000000003fd0
> 4,979,55824883,-;FS:  00007fbcf3bc8700(0000) GS:ffff98435f3c0000(0000)
> knlGS:0000000000000000
> 4,980,55824884,-;CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> 4,981,55824885,-;CR2: 0000000001d2c000 CR3: 00000007deb98000 CR4:
> 00000000003406e0
> 4,982,55824886,-;DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> 4,983,55824888,-;DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> 4,984,55824888,-;Call Trace:
> 4,985,55824899,-; btrfs_lookup+0x12/0x40 [btrfs]
> 4,986,55824903,-; lookup_slow+0x96/0x140
> 4,987,55824905,-; walk_component+0x19a/0x330
> 4,988,55824907,-; ? path_init+0x174/0x300
> 4,989,55824909,-; path_lookupat+0x64/0x1f0
> 4,990,55824912,-; filename_lookup+0xa9/0x170
> 4,991,55824915,-; ? mem_cgroup_commit_charge+0x82/0x530
> 4,992,55824918,-; ? kmem_cache_alloc+0x146/0x1a0
> 4,993,55824920,-; ? getname_flags+0x4f/0x1f0
> 4,994,55824922,-; user_path_at_empty+0x36/0x40
> 4,995,55824924,-; ? user_path_at_empty+0x36/0x40
> 4,996,55824926,-; vfs_statx+0x67/0xc0
> 4,997,55824928,-; SYSC_newfstatat+0x26/0x50
> 4,998,55824930,-; ? __do_page_fault+0x25e/0x4c0
> 4,999,55824932,-; SyS_newfstatat+0xe/0x10
> 4,1000,55824935,-; entry_SYSCALL_64_fastpath+0x1a/0xa5
> 4,1001,55824937,-;RIP: 0033:0x7fbcf2eb4aea
> 4,1002,55824938,-;RSP: 002b:00007ffeadbc6da8 EFLAGS: 00000246
> ORIG_RAX: 0000000000000106
> 4,1003,55824940,-;RAX: ffffffffffffffda RBX: 0000000000001897 RCX:
> 00007fbcf2eb4aea
> 4,1004,55824941,-;RDX: 0000000001942b88 RSI: 0000000001942c18 RDI:
> 0000000000000008
> 4,1005,55824942,-;RBP: 0000000000000044 R08: 0000000000000100 R09:
> 0000000000018981
> 4,1006,55824943,-;R10: 0000000000000100 R11: 0000000000000246 R12:
> 0000000001d13548
> 4,1007,55824944,-;R13: 0000000001d13768 R14: 00000000004c2cf0 R15:
> 0000000001d2c000
> 4,1008,55824946,-;Code: b8 fe ff ff ff e9 0f fe ff ff 48 8b 53 40 e9
> cb fe ff ff 48 8b 7b 28 48 8b 55 a0 48 8d 75 ae 31 c9 e8 01 f1 ff ff
> e9 38 fe ff ff <0f> 0b 48 8b 7b 28 e8 a1 a4 55 c8 48 85 c0 48 89 c3 0f
> 84 d3 00
> 1,1009,55824976,-;RIP: btrfs_lookup_dentry+0x384/0x490 [btrfs] RSP:
> ffffaa9589567b40
> 4,1010,55824978,-;---[ end trace 2f2cf349eabc236c ]---
> 1,1011,55891936,-;BUG: unable to handle kernel paging request at
> fffffffeff800030
> 1,1012,55891941,-;IP: 0xfffffffeee3ae1fd
> 4,1013,55891942,-;PGD 5ab40c067
> 4,1014,55891942,-;P4D 5ab40c067
> 4,1015,55891943,-;PUD 0
> 4,1016,55891943,-;
> 4,1017,55891945,-;Oops: 0000 [#2] SMP
> 4,1018,55891946,-;Modules linked in: fuse af_packet msr
> snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic
> iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv6 nf_defrag_ipv6
> nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack libcrc32c
> ip6t_rpfilter ipt_rpfilter ip6table_raw iptable_raw xt_pkttype
> nf_log_ipv6 nf_log_ipv4 nf_log_common xt_LOG xt_tcpudp ip6table_filter
> ip6_tables edac_core iptable_filter x86_pkg_temp_thermal
> intel_powerclamp coretemp crct10dif_pclmul crc32_pclmul
> ghash_clmulni_intel pcbc uvcvideo snd_usb_audio videobuf2_vmalloc
> videobuf2_memops videobuf2_v4l2 snd_hda_intel videobuf2_core mousedev
> aesni_intel snd_usbmidi_lib snd_hda_codec nvidia_drm(PO) snd_rawmidi
> drm_kms_helper aes_x86_64 input_leds uas joydev led_class crypto_simd
> videodev snd_seq_device evdev usb_storage
> 4,1019,55891969,c; glue_helper usblp snd_hda_core iTCO_wdt cryptd
> efi_pstore mxm_wmi mac_hid e1000e drm snd_hwdep pstore tpm_tis snd_pcm
> mei_me agpgart snd_timer fb_sys_fops intel_cstate tpm_tis_core
> syscopyarea snd sysfillrect intel_uncore sysimgblt ptp intel_rapl_perf
> mei soundcore efivars pps_core lpc_ich tpm shpchp nvidia_modeset(PO)
> nvidia_uvm(PO) nvidia(PO) wmi i2c_core arc4 ecb ppp_mppe ppp_generic
> slhc button atkbd libps2 loop cpufreq_ondemand vboxnetflt(O)
> vboxnetadp(O) vboxdrv(O) kvm_intel kvm irqbypass efivarfs ip_tables
> x_tables ipv6 crc_ccitt autofs4 hid_generic usbhid hid sd_mod ahci
> xhci_pci libahci xhci_hcd ehci_pci ehci_hcd libata usbcore scsi_mod
> usb_common serio rtc_cmos dm_mod dax crc32c_generic crc32c_intel btrfs
> xor raid6_pq
> 4,1020,55892001,-;CPU: 7 PID: 102 Comm: kworker/7:1 Tainted: P      D
>   O    4.13.9 #1-NixOS
> 4,1021,55892001,-;Hardware name: MSI MS-7885/X99A RAIDER (MS-7885),
> BIOS P.50 07/19/2016
> 4,1022,55892004,-;Workqueue: events efivar_update_sysfs_entries [efivars]
> 4,1023,55892005,-;task: ffff984359680000 task.stack: ffffaa9583f04000
> 4,1024,55892006,-;RIP: 0010:0xfffffffeee3ae1fd
> 4,1025,55892007,-;RSP: 0018:ffffaa9583f07b08 EFLAGS: 00010246
> 4,1026,55892008,-;RAX: 0000000000000007 RBX: ffffaa9583f07c18 RCX:
> fffffffeff84005f
> 4,1027,55892009,-;RDX: 0000000000000020 RSI: fffffffeff840000 RDI:
> fffffffeee3b2698
> 4,1028,55892010,-;RBP: ffff9843564c5800 R08: 0000000000000007 R09:
> 0000000000000000
> 4,1029,55892010,-;R10: fffffffeff800000 R11: 0000000000040000 R12:
> ffffaa9583f07db8
> 4,1030,55892011,-;R13: 0000000000000040 R14: 8000000000000015 R15:
> 0000000000000282
> 4,1031,55892012,-;FS:  0000000000000000(0000)
> GS:ffff98435f3c0000(0000) knlGS:0000000000000000
> 4,1032,55892013,-;CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> 4,1033,55892014,-;CR2: fffffffeff800030 CR3: 00000005ab409000 CR4:
> 00000000003406e0
> 4,1034,55892015,-;DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> 4,1035,55892015,-;DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> 4,1036,55892016,-;Call Trace:
> 4,1037,55892020,-; ? find_busiest_group+0x10b/0x960
> 4,1038,55892022,-; ? efi_call+0x58/0x90
> 4,1039,55892025,-; ? virt_efi_get_next_variable+0x7d/0x130
> 4,1040,55892027,-; ? efivar_init+0x13e/0x3d0
> 4,1041,55892029,-; ? efivar_release+0x20/0x20 [efivars]
> 4,1042,55892031,-; ? __slab_alloc+0x20/0x40
> 4,1043,55892033,-; ? __switch_to+0x202/0x460
> 4,1044,55892035,-; ? efivar_update_sysfs_entries+0x29/0x70 [efivars]
> 4,1045,55892036,-; ? efivar_update_sysfs_entries+0x29/0x70 [efivars]
> 4,1046,55892038,-; ? process_one_work+0x1e9/0x410
> 4,1047,55892039,-; ? worker_thread+0x4b/0x410
> 4,1048,55892040,-; ? kthread+0x109/0x140
> 4,1049,55892042,-; ? process_one_work+0x410/0x410
> 4,1050,55892043,-; ? kthread_create_on_node+0x40/0x40
> 4,1051,55892045,-; ? ret_from_fork+0x25/0x30
> 4,1052,55892046,-;Code: 10 17 eb 03 49 8b c9 ba 20 00 00 00 49 3b c9
> 75 05 44 8a c2 eb 0f 8a 01 f6 d0 44 0f b6 c0 41 3a c1 44 0f 44 c2 4d
> 39 5a 20 75 0c <41> 0f b7 42 30 4a 8d 4c 10 17 eb 03 49 8b c9 49 3b c9
> 74 0f 8a
> 1,1053,55892062,-;RIP: 0xfffffffeee3ae1fd RSP: ffffaa9583f07b08
> 4,1054,55892062,-;CR2: fffffffeff800030
> 4,1055,55892063,-;---[ end trace 2f2cf349eabc236d ]---
> 4,1056,57108566,-;------------[ cut here ]------------
> 4,1057,57108573,-;WARNING: CPU: 7 PID: 262 at
> /tmp/nix-build-linux-4.13.9.drv-0/linux-4.13.9/arch/x86/kernel/fpu/core.c:46
> __kernel_fpu_begin+0xa4/0xb0
> 4,1058,57108574,-;Modules linked in: fuse af_packet msr
> snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic
> iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv6 nf_defrag_ipv6
> nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack libcrc32c
> ip6t_rpfilter ipt_rpfilter ip6table_raw iptable_raw xt_pkttype
> nf_log_ipv6 nf_log_ipv4 nf_log_common xt_LOG xt_tcpudp ip6table_filter
> ip6_tables edac_core iptable_filter x86_pkg_temp_thermal
> intel_powerclamp coretemp crct10dif_pclmul crc32_pclmul
> ghash_clmulni_intel pcbc uvcvideo snd_usb_audio videobuf2_vmalloc
> videobuf2_memops videobuf2_v4l2 snd_hda_intel videobuf2_core mousedev
> aesni_intel snd_usbmidi_lib snd_hda_codec nvidia_drm(PO) snd_rawmidi
> drm_kms_helper aes_x86_64 input_leds uas joydev led_class crypto_simd
> videodev snd_seq_device evdev usb_storage
> 4,1059,57108597,c; glue_helper usblp snd_hda_core iTCO_wdt cryptd
> efi_pstore mxm_wmi mac_hid e1000e drm snd_hwdep pstore tpm_tis snd_pcm
> mei_me agpgart snd_timer fb_sys_fops intel_cstate tpm_tis_core
> syscopyarea snd sysfillrect intel_uncore sysimgblt ptp intel_rapl_perf
> mei soundcore efivars pps_core lpc_ich tpm shpchp nvidia_modeset(PO)
> nvidia_uvm(PO) nvidia(PO) wmi i2c_core arc4 ecb ppp_mppe ppp_generic
> slhc button atkbd libps2 loop cpufreq_ondemand vboxnetflt(O)
> vboxnetadp(O) vboxdrv(O) kvm_intel kvm irqbypass efivarfs ip_tables
> x_tables ipv6 crc_ccitt autofs4 hid_generic usbhid hid sd_mod ahci
> xhci_pci libahci xhci_hcd ehci_pci ehci_hcd libata usbcore scsi_mod
> usb_common serio rtc_cmos dm_mod dax crc32c_generic crc32c_intel btrfs
> xor raid6_pq
> 4,1060,57108628,-;CPU: 7 PID: 262 Comm: kworker/u25:0 Tainted: P
> D    O    4.13.9 #1-NixOS
> 4,1061,57108629,-;Hardware name: MSI MS-7885/X99A RAIDER (MS-7885),
> BIOS P.50 07/19/2016
> 4,1062,57108647,-;Workqueue: btrfs-worker-high btrfs_worker_helper [btrfs]
> 4,1063,57108648,-;task: ffff9843596cd280 task.stack: ffffaa9584050000
> 4,1064,57108650,-;RIP: 0010:__kernel_fpu_begin+0xa4/0xb0
> 4,1065,57108651,-;RSP: 0018:ffffaa9584053c28 EFLAGS: 00010202
> 4,1066,57108652,-;RAX: 0000000080000001 RBX: 0000000000001000 RCX:
> ffff9843596cd280
> 4,1067,57108653,-;RDX: 0000000000000000 RSI: ffff98422eba8000 RDI:
> ffffaa9584053cd0
> 4,1068,57108654,-;RBP: ffffaa9584053c28 R08: 0000000000000000 R09:
> 0000000000001000
> 4,1069,57108655,-;R10: 0000000000000001 R11: ffff984233947f80 R12:
> ffffaa9584053cd0
> 4,1070,57108655,-;R13: ffff98422eba8000 R14: ffff98422eba8000 R15:
> ffffffffc03a6050
> 4,1071,57108656,-;FS:  0000000000000000(0000)
> GS:ffff98435f3c0000(0000) knlGS:0000000000000000
> 4,1072,57108657,-;CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> 4,1073,57108658,-;CR2: 00000c0aa4045000 CR3: 00000005ab409000 CR4:
> 00000000003406e0
> 4,1074,57108659,-;DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> 4,1075,57108660,-;DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> 4,1076,57108660,-;Call Trace:
> 4,1077,57108663,-; kernel_fpu_begin+0xe/0x10
> 4,1078,57108665,-; crc32c_pcl_intel_update+0x84/0xb0 [crc32c_intel]
> 4,1079,57108668,-; crypto_shash_update+0x3f/0x110
> 4,1080,57108669,-; ? wake_up_process+0x15/0x20
> 4,1081,57108676,-; btrfs_crc32c+0x6e/0xa0 [btrfs]
> 4,1082,57108682,-; btrfs_csum_data+0x16/0x20 [btrfs]
> 4,1083,57108688,-; btrfs_csum_one_bio+0x214/0x490 [btrfs]
> 4,1084,57108694,-; ? __btree_submit_bio_start+0x20/0x20 [btrfs]
> 4,1085,57108700,-; __btrfs_submit_bio_start+0x12/0x20 [btrfs]
> 4,1086,57108705,-; run_one_async_start+0x23/0x30 [btrfs]
> 4,1087,57108712,-; btrfs_scrubparity_helper+0xc8/0x2e0 [btrfs]
> 4,1088,57108719,-; btrfs_worker_helper+0xe/0x10 [btrfs]
> 4,1089,57108721,-; process_one_work+0x1e9/0x410
> 4,1090,57108722,-; worker_thread+0x4b/0x410
> 4,1091,57108724,-; kthread+0x109/0x140
> 4,1092,57108725,-; ? process_one_work+0x410/0x410
> 4,1093,57108737,-; ? kthread_create_on_node+0x40/0x40
> 4,1094,57108740,-; ret_from_fork+0x25/0x30
> 4,1095,57108741,-;Code: 80 0a 00 00 85 c0 74 27 b8 ff ff ff ff 89 c2
> 48 0f ae 37 31 c0 85 c0 74 d7 0f ff 5d c3 0f ff eb a7 48 0f ae 81 80
> 0a 00 00 5d c3 <0f> ff eb a4 0f ff eb d5 0f 1f 40 00 0f 1f 44 00 00 55
> 48 89 e5
> 4,1096,57108777,-;---[ end trace 2f2cf349eabc236e ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
