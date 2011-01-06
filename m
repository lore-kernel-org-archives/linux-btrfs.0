From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug 26242] New: BUG: unable to handle kernel NULL pointer
 dereference at   (null)
Date: Thu, 6 Jan 2011 13:12:58 -0800
Message-ID: <20110106131258.c4b262bf.akpm@linux-foundation.org>
References: <bug-26242-27@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: bugzilla-daemon@bugzilla.kernel.org,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: StMichalke@web.de
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <bug-26242-27@https.bugzilla.kernel.org/>
List-ID: <linux-btrfs.vger.kernel.org>


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Thu, 6 Jan 2011 20:59:08 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=26242
> 
>            Summary: BUG: unable to handle kernel NULL pointer dereference
>                     at   (null)
>            Product: Memory Management
>            Version: 2.5
>     Kernel Version: 2.6.37
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: low
>           Priority: P1
>          Component: Other
>         AssignedTo: akpm@linux-foundation.org
>         ReportedBy: StMichalke@web.de
>         Regression: No
> 
> 
> My system crashed with the following output:
> 
> ___
> Jan  6 20:06:22 eser kernel: [19365.562621] BUG: unable to handle kernel NULL
> pointer dereference at   (null)
> Jan  6 20:06:22 eser kernel: [19365.562675] IP: [<c022989b>]
> kmap_atomic_prot+0x1b/0x100
> Jan  6 20:06:22 eser kernel: [19365.562709] *pde = 00000000 
> Jan  6 20:06:22 eser kernel: [19365.562726] Oops: 0000 [#1] PREEMPT SMP 
> Jan  6 20:06:22 eser kernel: [19365.562752] last sysfs file:
> /sys/devices/platform/coretemp.0/temp1_input
> Jan  6 20:06:22 eser kernel: [19365.562777] Modules linked in: isofs usblp
> usb_storage uas nls_utf8 udf crc_itu_t fuse ipt_MASQUERADE xt_pkttype xt_TCPMSS
> xt_tcpudp ipt_LOG xt_limit iptable_nat nf_nat snd_pcm_oss snd_mixer_oss snd_seq
> snd_seq_device xt_NOTRACK ipt_REJECT xt_state iptable_raw iptable_filter
> nf_conntrack_netbios_ns nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables
> cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf
> speedstep_lib ip6_tables x_tables loop arc4 ecb b43 snd_hda_codec_si3054
> mac80211 snd_hda_codec_realtek snd_hda_intel r8169 snd_hda_codec cfg80211
> sdhci_pci mii snd_hwdep acer_wmi sdhci snd_pcm rfkill iTCO_wdt yenta_socket ssb
> tifm_7xx1 iTCO_vendor_support sg sr_mod mmc_core snd_timer pcmcia_core
> tifm_core cdrom pcspkr wmi pcmcia_rsrc psmouse snd i2c_i801 shpchp evdev
> soundcore battery rng_core ac snd_page_alloc pci_hotplug dm_crypt usbhid hid
> nouveau ttm drm_kms_helper drm uhci_hcd rtc_cmos ata_piix i2c_algo_bit i2c_core
> rtc_core cfbcopyarea ehci_hcd usb
> Jan  6 20:06:22 eser kernel: core video cfbimgblt cfbfillrect rtc_lib output
> button nls_base dm_snapshot sha512_generic sha256_generic xts cbc aes_i586
> aes_generic cfq_iosched blk_cgroup btrfs zlib_deflate libcrc32c reiserfs ahci
> libahci libata coretemp hwmon fan thermal processor unix [last unloaded:
> pktcdvd]
> Jan  6 20:06:22 eser kernel: [19365.563014] 
> Jan  6 20:06:22 eser kernel: [19365.563014] Pid: 15675, comm: gimp-2.6 Not
> tainted 2.6.37 #1 Myall2                         /Aspire 9410
> Jan  6 20:06:22 eser kernel: [19365.563014] EIP: 0060:[<c022989b>] EFLAGS:
> 00010202 CPU: 0
> Jan  6 20:06:22 eser kernel: [19365.563014] EIP is at
> kmap_atomic_prot+0x1b/0x100
> Jan  6 20:06:22 eser kernel: [19365.563014] EAX: 00000000 EBX: 00000600 ECX:
> f3a82000 EDX: 00000163
> Jan  6 20:06:23 eser kernel: [19365.563014] ESI: f3a83eac EDI: 00000000 EBP:
> f3a83db8 ESP: f3a83da8
> Jan  6 20:06:23 eser kernel: [19365.563014]  DS: 007b ES: 007b FS: 00d8 GS:
> 0033 SS: 0068
> Jan  6 20:06:23 eser kernel: [19365.563014] Process gimp-2.6 (pid: 15675,
> ti=f3a82000 task=eaf28000 task.ti=f3a82000)
> Jan  6 20:06:23 eser kernel: [19365.563014] Stack:
> Jan  6 20:06:23 eser kernel: [19365.563014]  f3a83dc0 00000600 f3a83eac
> 00000000 f3a83dc0 c022998e f3a83dd8 c0299c0c
> Jan  6 20:06:23 eser kernel: [19365.563014]  e0359240 00000600 00001000
> 00001000 f3a83dfc f828d6da 00000600 00001008
> Jan  6 20:06:23 eser kernel: [19365.563014]  00000002 00000000 00000002
> 00002000 00001608 f3a83ed0 f828e1ff 00001608
> Jan  6 20:06:23 eser kernel: [19365.563014] Call Trace:
> Jan  6 20:06:23 eser kernel: [19365.563014]  [<c022998e>] ?
> __kmap_atomic+0xe/0x10
> Jan  6 20:06:23 eser kernel: [19365.563014]  [<c0299c0c>] ?
> iov_iter_copy_from_user_atomic+0x3c/0x90
> Jan  6 20:06:23 eser kernel: [19365.563014]  [<f828d6da>] ?
> btrfs_copy_from_user+0x5a/0xb0 [btrfs]
> Jan  6 20:06:23 eser kernel: [19365.563014]  [<f828e1ff>] ?
> btrfs_file_aio_write+0x52f/0x9c0 [btrfs]
> Jan  6 20:06:23 eser kernel: [19365.563014]  [<c02d0810>] ?
> __mem_cgroup_commit_charge+0x70/0xe0
> Jan  6 20:06:23 eser kernel: [19365.563014]  [<c02d672c>] ?
> do_sync_write+0x9c/0xd0
> Jan  6 20:06:23 eser kernel: [19365.563014]  [<c02d6b15>] ?
> rw_verify_area+0x65/0x100
> Jan  6 20:06:23 eser kernel: [19365.563014]  [<c02d6e7a>] ?
> vfs_write+0x9a/0x160
> Jan  6 20:06:23 eser kernel: [19365.563014]  [<c02d8211>] ?
> fget_light+0x91/0xb0
> Jan  6 20:06:23 eser kernel: [19365.563014]  [<c02d6690>] ?
> do_sync_write+0x0/0xd0
> Jan  6 20:06:23 eser kernel: [19365.563014]  [<c02d714d>] ? sys_write+0x3d/0x70
> Jan  6 20:06:23 eser kernel: [19365.563014]  [<c0202e18>] ?
> sysenter_do_call+0x12/0x28
> Jan  6 20:06:23 eser kernel: [19365.563014]  [<c04e0000>] ?
> quirk_amd_ide_mode+0x40/0x95
> Jan  6 20:06:23 eser kernel: [19365.563014] Code: 8b 15 4c 6a 6b c0 55 89 e5 e8
> e2 f8 ff ff 5d c3 55 89 e5 83 ec 10 89 e1 81 e1 00 e0 ff ff 89 5d f4 89 75 f8
> 89 7d fc 83 41 14 01 <8b> 08 c1 e9 1e 69 d9 40 03 00 00 8d 8b c0 42 64 c0 2b 8b
> cc 45 
> Jan  6 20:06:23 eser kernel: [19365.563014] EIP: [<c022989b>]
> kmap_atomic_prot+0x1b/0x100 SS:ESP 0068:f3a83da8
> Jan  6 20:06:23 eser kernel: [19365.563014] CR2: 0000000000000000
> Jan  6 20:06:23 eser kernel: [19365.568714] ---[ end trace afc2be06c7d06a71
> ]---
> Jan  6 20:06:23 eser kernel: [19365.568724] note: gimp-2.6[15675] exited with
> preempt_count 2
> ___
> 
> The kernel is an unpatched v2.6.37. I have not seen something like this before.

Bugzilla's habit of wordwrapping oops traces is fantastically
irritating.  Please use attachments to avoid this.

Either Peter's new kmap_atomic() stuff blew up or BTRFS is playing
around with a NULL page*.  I'd wager on the latter.

Thanks, I'll ask Rafael and Maciej to track this as a 2.6.36->2.6.37
regression.
