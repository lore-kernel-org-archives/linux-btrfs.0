From: Chris Mason <chris.mason@oracle.com>
Subject: Re: null pointer dereference in iov_iter_copy_from_user_atomic while updating rpm packages
Date: Fri, 11 Feb 2011 18:23:27 -0500
Message-ID: <1297466575-sup-6809@think>
References: <AANLkTima3tp6T-ochZGpfCpD_Z0nzNX3bX2YgXc+hdMz@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Clemens Eisserer <linuxhippy@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <AANLkTima3tp6T-ochZGpfCpD_Z0nzNX3bX2YgXc+hdMz@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Clemens Eisserer's message of 2011-02-11 18:05:55 -0500:
> Hi,
> 
> While updating my fedora rawhide installation, I got the Ooops listed
> at the end of the Email.
> Is this a known bug (I didn't find anything specific), or should I file a bug?
> 
> Thank you in advance, Clemens

I think we've fixed this in rc4, or you can git pull from the current
btrfs-unstable tree.

-chris

> 
> 
> Feb 10 10:59:45 testbox kernel: [  524.495751] BUG: unable to handle
> kernel NULL pointer dereference at   (null)
> Feb 10 10:59:45 testbox kernel: [  524.496006] IP: [<c04267a2>]
> kmap_atomic_prot+0x1c/0x111
> Feb 10 10:59:45 testbox kernel: [  524.496006] *pde = 00000000
> Feb 10 10:59:45 testbox kernel: [  524.496006] Oops: 0000 [#1] SMP
> Feb 10 10:59:45 testbox kernel: [  524.496006] last sysfs file:
> /sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
> Feb 10 10:59:45 testbox kernel: [  524.496006] Modules linked in:
> sunrpc cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT
> nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables
> snd_hda_codec_si3054 snd_hda_codec_realtek arc4 snd_hda_intel
> snd_hda_codec snd_hwdep snd_seq snd_seq_device iwl3945 snd_pcm iwlcore
> mac80211 snd_timer ppdev e1000e snd cfg80211 parport_pc soundcore
> iTCO_wdt toshiba_bluetooth joydev parport snd_page_alloc toshiba_acpi
> microcode iTCO_vendor_support sparse_keymap rfkill uinput ipv6 btrfs
> zlib_deflate libcrc32c sdhci_pci sdhci firewire_ohci mmc_core
> firewire_core crc_itu_t yenta_socket i915 drm_kms_helper drm
> i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
> Feb 10 10:59:45 testbox kernel: [  524.496006]
> Feb 10 10:59:45 testbox kernel: [  524.496006] Pid: 1465, comm:
> build-locale-ar Not tainted 2.6.38-0.rc3.git4.1.fc15.i686 #1 Portable
> PC/Tecra A8
> Feb 10 10:59:45 testbox kernel: [  524.496006] EIP: 0060:[<c04267a2>]
> EFLAGS: 00210202 CPU: 0
> Feb 10 10:59:45 testbox kernel: [  524.496006] EIP is at
> kmap_atomic_prot+0x1c/0x111
> Feb 10 10:59:45 testbox kernel: [  524.496006] EAX: f1d56000 EBX:
> f1d57eb8 ECX: 00000000 EDX: 00000163
> Feb 10 10:59:45 testbox kernel: [  524.496006] ESI: 00000000 EDI:
> 00000163 EBP: f1d57de8 ESP: f1d57dd4
> Feb 10 10:59:45 testbox kernel: [  524.496006]  DS: 007b ES: 007b FS:
> 00d8 GS: 00e0 SS: 0068
> Feb 10 10:59:45 testbox kernel: [  524.496006] Process build-locale-ar
> (pid: 1465, ti=f1d56000 task=f1d1f110 task.ti=f1d56000)
> Feb 10 10:59:45 testbox kernel: [  524.496006] Stack:
> Feb 10 10:59:45 testbox kernel: [  524.496006]  00000000 f1d57df0
> f1d57eb8 00001000 00000000 f1d57df0 c04268aa f1d57e08
> Feb 10 10:59:45 testbox kernel: [  524.496006]  c04ab3cd 00000000
> 0000012c 00001000 00000000 f1d57e2c f8217b41 0000012c
> Feb 10 10:59:45 testbox kernel: [  524.496006]  00001010 00000002
> 00001000 f1d57eb8 0000113c 00000000 f1d57edc f8218129
> Feb 10 10:59:45 testbox kernel: [  524.496006] Call Trace:
> Feb 10 10:59:45 testbox kernel: [  524.496006]  [<c04268aa>]
> __kmap_atomic+0x13/0x15
> Feb 10 10:59:45 testbox kernel: [  524.496006]  [<c04ab3cd>]
> iov_iter_copy_from_user_atomic+0x28/0x6c
> Feb 10 10:59:45 testbox kernel: [  524.496006]  [<f8217b41>]
> btrfs_copy_from_user.isra.6+0x5c/0x96 [btrfs]
> Feb 10 10:59:45 testbox kernel: [  524.496006]  [<f8218129>]
> btrfs_file_aio_write+0x480/0x79b [btrfs]
> Feb 10 10:59:45 testbox kernel: [  524.496006]  [<c04dd8e4>] ?
> mem_cgroup_update_page_stat+0x1a/0xd4
> Feb 10 10:59:45 testbox kernel: [  524.496006]  [<c04e3e76>]
> do_sync_write+0x96/0xcf
> Feb 10 10:59:45 testbox kernel: [  524.496006]  [<c04e4265>] ?
> rw_verify_area+0xd0/0xf3
> Feb 10 10:59:45 testbox kernel: [  524.496006]  [<c04e44fd>] vfs_write+0x8f/0xd7
> Feb 10 10:59:45 testbox kernel: [  524.496006]  [<c04e3de0>] ?
> do_sync_write+0x0/0xcf
> Feb 10 10:59:45 testbox kernel: [  524.496006]  [<c04e46bf>] sys_write+0x42/0x63
> Feb 10 10:59:45 testbox kernel: [  524.496006]  [<c07d449c>]
> syscall_call+0x7/0xb
> Feb 10 10:59:45 testbox kernel: [  524.496006] Code: 26 00 8b 15 08 b9
> af c0 e8 58 f9 ff ff 5d c3 55 89 e5 57 56 53 83 ec 08 3e 8d 74 26 00
> 89 c6 89 e0 25 00 e0 ff ff 89 d7 ff 40 14 <8b> 06 c1 e8 1e 69 c0 80 03
> 00 00 05 00 07 a3 c0 e8 49 fe ff ff
> Feb 10 10:59:45 testbox kernel: [  524.496006] EIP: [<c04267a2>]
> kmap_atomic_prot+0x1c/0x111 SS:ESP 0068:f1d57dd4
> Feb 10 10:59:45 testbox kernel: [  524.496006] CR2: 0000000000000000
> Feb 10 10:59:45 testbox kernel: [  524.582447] ---[ end trace
> e16f2400ae6eb809 ]---
> Feb 10 10:59:45 testbox kernel: [  524.584816] note:
> build-locale-ar[1465] exited with preempt_count 2
> Feb 10 10:59:45 testbox kernel: [  524.584819] BUG: sleeping function
> called from invalid context at kernel/rwsem.c:21
> Feb 10 10:59:45 testbox kernel: [  524.584822] in_atomic(): 1,
> irqs_disabled(): 0, pid: 1465, name: build-locale-ar
> Feb 10 10:59:45 testbox kernel: [  524.584828] Pid: 1465, comm:
> build-locale-ar Tainted: G      D     2.6.38-0.rc3.git4.1.fc15.i686 #1
> Feb 10 10:59:45 testbox kernel: [  524.584830] Call Trace:
> Feb 10 10:59:45 testbox kernel: [  524.584835]  [<c042e20a>] ?
> __might_sleep+0xdd/0xe4
> Feb 10 10:59:45 testbox kernel: [  524.584839]  [<c07d382c>] ?
> down_read+0x1c/0x30
> Feb 10 10:59:45 testbox kernel: [  524.584843]  [<c046c69f>] ?
> acct_collect+0x3e/0x138
> Feb 10 10:59:45 testbox kernel: [  524.584847]  [<c043da92>] ?
> do_exit+0x1d0/0x62c
> Feb 10 10:59:45 testbox kernel: [  524.584850]  [<c043bf68>] ?
> kmsg_dump+0x3a/0xb6
> Feb 10 10:59:45 testbox kernel: [  524.584853]  [<c07d555b>] ?
> oops_end+0xa2/0xa8
> Feb 10 10:59:45 testbox kernel: [  524.584858]  [<c07cc31f>] ?
> no_context+0x128/0x130
> Feb 10 10:59:45 testbox kernel: [  524.584861]  [<c07cc441>] ?
> __bad_area_nosemaphore+0x11a/0x122
> Feb 10 10:59:45 testbox kernel: [  524.584884]  [<f81fdd20>] ?
> btrfs_block_rsv_release+0x51/0x57 [btrfs]
> Feb 10 10:59:45 testbox kernel: [  524.584888]  [<c07cc460>] ?
> bad_area_nosemaphore+0x17/0x19
> Feb 10 10:59:45 testbox kernel: [  524.584891]  [<c07d6ef3>] ?
> do_page_fault+0x159/0x30c
> Feb 10 10:59:45 testbox kernel: [  524.584916]  [<f8225975>] ?
> free_extent_state+0x3c/0x3f [btrfs]
> Feb 10 10:59:45 testbox kernel: [  524.584940]  [<f8226053>] ?
> clear_extent_bit+0x31b/0x36c [btrfs]
> Feb 10 10:59:45 testbox kernel: [  524.584964]  [<f8225975>] ?
> free_extent_state+0x3c/0x3f [btrfs]
> Feb 10 10:59:45 testbox kernel: [  524.584968]  [<c07d6d9a>] ?
> do_page_fault+0x0/0x30c
> Feb 10 10:59:45 testbox kernel: [  524.584971]  [<c07d4b87>] ?
> error_code+0x67/0x6c
> Feb 10 10:59:45 testbox kernel: [  524.584974]  [<c04267a2>] ?
> kmap_atomic_prot+0x1c/0x111
> Feb 10 10:59:45 testbox kernel: [  524.584977]  [<c04268aa>] ?
> __kmap_atomic+0x13/0x15
> Feb 10 10:59:45 testbox kernel: [  524.584980]  [<c04ab3cd>] ?
> iov_iter_copy_from_user_atomic+0x28/0x6c
> Feb 10 10:59:45 testbox kernel: [  524.585005]  [<f8217b41>] ?
> btrfs_copy_from_user.isra.6+0x5c/0x96 [btrfs]
> Feb 10 10:59:45 testbox kernel: [  524.585039]  [<f8218129>] ?
> btrfs_file_aio_write+0x480/0x79b [btrfs]
> Feb 10 10:59:45 testbox kernel: [  524.585043]  [<c04dd8e4>] ?
> mem_cgroup_update_page_stat+0x1a/0xd4
> Feb 10 10:59:45 testbox kernel: [  524.585051]  [<c04e3e76>] ?
> do_sync_write+0x96/0xcf
> Feb 10 10:59:45 testbox kernel: [  524.585055]  [<c04e4265>] ?
> rw_verify_area+0xd0/0xf3
> Feb 10 10:59:45 testbox kernel: [  524.585058]  [<c04e44fd>] ?
> vfs_write+0x8f/0xd7
> Feb 10 10:59:45 testbox kernel: [  524.585061]  [<c04e3de0>] ?
> do_sync_write+0x0/0xcf
> Feb 10 10:59:45 testbox kernel: [  524.585064]  [<c04e46bf>] ?
> sys_write+0x42/0x63
> Feb 10 10:59:45 testbox kernel: [  524.585067]  [<c07d449c>] ?
> syscall_call+0x7/0xb
> Feb 10 10:59:45 testbox kernel: [  524.585070] BUG: scheduling while
> atomic: build-locale-ar/1465/0x10000002
> Feb 10 10:59:45 testbox kernel: [  524.585072] Modules linked in:
> sunrpc cpufreq_ondemand acpi_cpufreq mperf ip6t_REJECT
> nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables
> snd_hda_codec_si3054 snd_hda_codec_realtek arc4 snd_hda_intel
> snd_hda_codec snd_hwdep snd_seq snd_seq_device iwl3945 snd_pcm iwlcore
> mac80211 snd_timer ppdev e1000e snd cfg80211 parport_pc soundcore
> iTCO_wdt toshiba_bluetooth joydev parport snd_page_alloc toshiba_acpi
> microcode iTCO_vendor_support sparse_keymap rfkill uinput ipv6 btrfs
> zlib_deflate libcrc32c sdhci_pci sdhci firewire_ohci mmc_core
> firewire_core crc_itu_t yenta_socket i915 drm_kms_helper drm
> i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
> Feb 10 10:59:45 testbox kernel: [  524.585102] Pid: 1465, comm:
> build-locale-ar Tainted: G      D     2.6.38-0.rc3.git4.1.fc15.i686 #1
> Feb 10 10:59:45 testbox kernel: [  524.585104] Call Trace:
> Feb 10 10:59:45 testbox kernel: [  524.585107]  [<c07cc721>] ?
> __schedule_bug+0x5d/0x63
> Feb 10 10:59:45 testbox kernel: [  524.585110]  [<c07d277e>] ?
> schedule+0x69/0x67d
> Feb 10 10:59:45 testbox kernel: [  524.585115]  [<c0405c90>] ?
> show_trace_log_lvl+0x40/0x47
> Feb 10 10:59:45 testbox kernel: [  524.585118]  [<c0405cae>] ?
> show_trace+0x17/0x19
> Feb 10 10:59:45 testbox kernel: [  524.585121]  [<c07cb105>] ?
> dump_stack+0x6d/0x73
> Feb 10 10:59:45 testbox kernel: [  524.585124]  [<c042e20a>] ?
> __might_sleep+0xdd/0xe4
> Feb 10 10:59:45 testbox kernel: [  524.585128]  [<c0436e23>] ?
> __cond_resched+0x1b/0x2b
> Feb 10 10:59:45 testbox kernel: [  524.585130]  [<c07d2e39>] ?
> _cond_resched+0x18/0x21
> Feb 10 10:59:45 testbox kernel: [  524.585133]  [<c07d3831>] ?
> down_read+0x21/0x30
> Feb 10 10:59:45 testbox kernel: [  524.585136]  [<c046c69f>] ?
> acct_collect+0x3e/0x138
> Feb 10 10:59:45 testbox kernel: [  524.585139]  [<c043da92>] ?
> do_exit+0x1d0/0x62c
> Feb 10 10:59:45 testbox kernel: [  524.585141]  [<c043bf68>] ?
> kmsg_dump+0x3a/0xb6
> Feb 10 10:59:45 testbox kernel: [  524.585145]  [<c07d555b>] ?
> oops_end+0xa2/0xa8
> Feb 10 10:59:45 testbox kernel: [  524.585148]  [<c07cc31f>] ?
> no_context+0x128/0x130
> Feb 10 10:59:45 testbox kernel: [  524.585151]  [<c07cc441>] ?
> __bad_area_nosemaphore+0x11a/0x122
> Feb 10 10:59:45 testbox kernel: [  524.585171]  [<f81fdd20>] ?
> btrfs_block_rsv_release+0x51/0x57 [btrfs]
> Feb 10 10:59:45 testbox kernel: [  524.585174]  [<c07cc460>] ?
> bad_area_nosemaphore+0x17/0x19
> Feb 10 10:59:45 testbox kernel: [  524.585178]  [<c07d6ef3>] ?
> do_page_fault+0x159/0x30c
> Feb 10 10:59:45 testbox kernel: [  524.585202]  [<f8225975>] ?
> free_extent_state+0x3c/0x3f [btrfs]
> Feb 10 10:59:45 testbox kernel: [  524.585226]  [<f8226053>] ?
> clear_extent_bit+0x31b/0x36c [btrfs]
> Feb 10 10:59:45 testbox kernel: [  524.585251]  [<f8225975>] ?
> free_extent_state+0x3c/0x3f [btrfs]
> Feb 10 10:59:45 testbox kernel: [  524.585254]  [<c07d6d9a>] ?
> do_page_fault+0x0/0x30c
> Feb 10 10:59:45 testbox kernel: [  524.585257]  [<c07d4b87>] ?
> error_code+0x67/0x6c
> Feb 10 10:59:45 testbox kernel: [  524.585260]  [<c04267a2>] ?
> kmap_atomic_prot+0x1c/0x111
> Feb 10 10:59:45 testbox kernel: [  524.585263]  [<c04268aa>] ?
> __kmap_atomic+0x13/0x15
> Feb 10 10:59:45 testbox kernel: [  524.585266]  [<c04ab3cd>] ?
> iov_iter_copy_from_user_atomic+0x28/0x6c
> Feb 10 10:59:45 testbox kernel: [  524.585292]  [<f8217b41>] ?
> btrfs_copy_from_user.isra.6+0x5c/0x96 [btrfs]
> Feb 10 10:59:45 testbox kernel: [  524.585316]  [<f8218129>] ?
> btrfs_file_aio_write+0x480/0x79b [btrfs]
> Feb 10 10:59:45 testbox kernel: [  524.585319]  [<c04dd8e4>] ?
> mem_cgroup_update_page_stat+0x1a/0xd4
> Feb 10 10:59:45 testbox kernel: [  524.585328]  [<c04e3e76>] ?
> do_sync_write+0x96/0xcf
> Feb 10 10:59:45 testbox kernel: [  524.585331]  [<c04e4265>] ?
> rw_verify_area+0xd0/0xf3
> Feb 10 10:59:45 testbox kernel: [  524.585334]  [<c04e44fd>] ?
> vfs_write+0x8f/0xd7
> Feb 10 10:59:45 testbox kernel: [  524.585337]  [<c04e3de0>] ?
> do_sync_write+0x0/0xcf
> Feb 10 10:59:45 testbox kernel: [  524.585340]  [<c04e46bf>] ?
> sys_write+0x42/0x63
> Feb 10 10:59:45 testbox kernel: [  524.585343]  [<c07d449c>] ?
> syscall_call+0x7/0xb
