Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:33222 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbcDAPoc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Apr 2016 11:44:32 -0400
Received: by mail-lb0-f176.google.com with SMTP id u8so74459291lbk.0
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Apr 2016 08:44:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160401134029.GH9342@torres.zugschlus.de>
References: <20160401134029.GH9342@torres.zugschlus.de>
Date: Fri, 1 Apr 2016 17:44:30 +0200
Message-ID: <CAPmG0jY7qftBouGb=g6RC5MTS4qjmAx2S=95p=Fpqqr35bk_eA@mail.gmail.com>
Subject: Re: Another ENOSPC situation
From: Henk Slager <eye1tm@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 1, 2016 at 3:40 PM, Marc Haber <mh+linux-btrfs@zugschlus.de> wrote:
> Hi,
>
> just for a change, this is another btrfs on a different host. The host
> is also running Debian unstable with mainline kernels, the btrfs in
> question was created (not converted) in March 2015 with btrfs-tools
> 3.17. It is the root fs of my main work notebook which is under
> workstation load, with lots of snapshots being created and deleted.
>
> Balance immediately fails with ENOSPC
>
> balance -dprofiles=single -dusage=1 goes through "fine" ("had to
> relocate 0 out of 602 chunks")
>
> balance -dprofiles=single -dusage=2 also ENOSPCes immediately.
>
> [4/502]mh@swivel:~$ sudo btrfs fi usage /
> Overall:
>     Device size:                 600.00GiB
>     Device allocated:            600.00GiB
>     Device unallocated:            1.00MiB
>     Device missing:                  0.00B
>     Used:                        413.40GiB
>     Free (estimated):            148.20GiB      (min: 148.20GiB)
>     Data ratio:                       1.00
>     Metadata ratio:                   2.00
>     Global reserve:              512.00MiB      (used: 0.00B)
>
> Data,single: Size:553.93GiB, Used:405.73GiB
>    /dev/mapper/swivelbtr         553.93GiB
>
> Metadata,DUP: Size:23.00GiB, Used:3.83GiB
>    /dev/mapper/swivelbtr          46.00GiB
>
> System,DUP: Size:32.00MiB, Used:112.00KiB
>    /dev/mapper/swivelbtr          64.00MiB
>
> Unallocated:
>    /dev/mapper/swivelbtr           1.00MiB
> [5/503]mh@swivel:~$
>
> btrfs balance -mprofiles seems to do something. one kworked and one
> btrfs-transaction process hog one CPU core each for hours, while
> blocking the filesystem for minutes apiece, which leads to the host
> being nearly unuseable up to the point of "clock and mouse pointer
> frozen for nearly ten minutes".

I assume you still have your every 10 minutes snapshotting running
while balancing?

> The btrfs balance cancel I issued after four hours of this state took
> eleven minutes alone to complete.
>
> These are all log entries that were obtained after starting btrfs
> balance -mprofiles on 09:43
> Apr  1 12:18:21 swivel kernel: [253651.970413] BTRFS info (device dm-14): found 3523 extents
> Apr  1 12:18:21 swivel kernel: [253652.035572] BTRFS info (device dm-14): relocating block group 1538365849600 flags 36
> Apr  1 13:30:57 swivel kernel: [258007.653597] BTRFS info (device dm-14): found 3585 extents
> Apr  1 13:30:57 swivel kernel: [258007.746541] BTRFS info (device dm-14): relocating block group 1536755236864 flags 36
> Apr  1 13:49:39 swivel kernel: [259130.296184] BTRFS info (device dm-14): found 3047 extents
> Apr  1 13:49:39 swivel kernel: [259130.357314] BTRFS info (device dm-14): relocating block group 1528702173184 flags 36
> Apr  1 14:30:00 swivel kernel: [261550.776348] BTRFS info (device dm-14): found 4200 extents
>
> This kernel trace from 11:16 is not btrfs-related, is it? I guess it's
> bluetooth related since it happened simultaneously to the bluetooth
> device popping out an in:
> Apr  1 11:16:38 swivel kernel: [249948.993751] usb 1-1.4: USB disconnect, device number 39
> Apr  1 11:16:38 swivel systemd[1]: Starting Load/Save RF Kill Switch Status...
> Apr  1 11:16:38 swivel systemd[1]: Started Load/Save RF Kill Switch Status.
> Apr  1 11:16:38 swivel systemd[1]: bluetooth.target: Unit not needed anymore. Stopping.
> Apr  1 11:16:38 swivel systemd[1]: Stopped target Bluetooth.
> Apr  1 11:16:38 swivel laptop-mode: Laptop mode
> Apr  1 11:16:38 swivel laptop-mode: enabled, not active
> Apr  1 11:16:39 swivel kernel: [249949.211549] usb 1-1.4: new full-speed USB device number 40 using ehci-pci
> Apr  1 11:16:39 swivel kernel: [249949.308386] usb 1-1.4: New USB device found, idVendor=0a5c, idProduct=217f
> Apr  1 11:16:39 swivel kernel: [249949.308397] usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> Apr  1 11:16:39 swivel kernel: [249949.308402] usb 1-1.4: Product: Broadcom Bluetooth Device
> Apr  1 11:16:39 swivel kernel: [249949.308407] usb 1-1.4: Manufacturer: Broadcom Corp
> Apr  1 11:16:39 swivel kernel: [249949.308412] usb 1-1.4: SerialNumber: CCAF78F1274F
> Apr  1 11:16:39 swivel systemd[1]: Reached target Bluetooth.
> Apr  1 11:16:39 swivel kernel: [249949.507794] ------------[ cut here ]------------
> Apr  1 11:16:39 swivel kernel: [249949.507810] WARNING: CPU: 1 PID: 11 at arch/x86/kernel/cpu/perf_event_intel_ds.c:325 reserve_ds_buffers+0x102/0x326()
> Apr  1 11:16:39 swivel kernel: [249949.507813] alloc_bts_buffer: BTS buffer allocation failure
> Apr  1 11:16:39 swivel kernel: [249949.507816] Modules linked in: cpuid hid_generic usbhid hid e1000e tun ctr ccm rfcomm bridge stp llc cpufreq_userspace cpufreq_stats cpufreq_conservative cpufreq_powersave nf_conntrack_netlink nfnetlink bnep binfmt_misc intel_rapl x86_pkg_temp_thermal arc4 intel_powerclamp kvm_intel kvm irqbypass iwldvm snd_hda_codec_conexant snd_hda_codec_generic mac80211 input_leds btusb btbcm i2c_i801 snd_hda_intel btintel snd_hda_codec bluetooth iwlwifi snd_hda_core cfg80211 snd_hwdep sg snd_pcm_oss snd_mixer_oss lpc_ich mfd_core snd_pcm shpchp snd_timer thinkpad_acpi nvram snd battery soundcore rfkill ac tpm_tis tpm evdev processor xt_TCPMSS xt_tcpudp iptable_mangle iptable_filter ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables ip6table_filter ip6_tables x_tables coretemp tp_smapi(O) thinkpad_ec(O) loop drbd lru_cache libcrc32c crc32c_generic autofs4 btrfs xor raid6_pq ext4 crc16 mbcache jbd2 algif_skcipher af_alg dm_snapshot dm_bufio dm_crypt dm_mod md_mod sd_mod usb_storage crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel jitterentropy_rng hmac sha256_ssse3 sha256_generic drbg ansi_cprng aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd psmouse ahci libahci i915 libata ehci_pci sdhci_pci i2c_algo_bit scsi_mod ehci_hcd sdhci drm_kms_helper mmc_core usbcore usb_common drm i2c_core thermal video button [last unloaded: e1000e]
> Apr  1 11:16:39 swivel kernel: [249949.507974] CPU: 1 PID: 11 Comm: watchdog/1 Tainted: G           O    4.5.0-zgws1 #2
> Apr  1 11:16:39 swivel kernel: [249949.507978] Hardware name: LENOVO 4240CTO/4240CTO, BIOS 8AET63WW (1.43 ) 05/08/2013
> Apr  1 11:16:39 swivel kernel: [249949.507981]  0000000000000047 ffffffff811e6bf3 ffff88017dd4fce8 0000000000000009
> Apr  1 11:16:39 swivel kernel: [249949.507987]  ffffffff81052619 ffffffff810230d1 0000000000000000 ffff88017dd4fd40
> Apr  1 11:16:39 swivel kernel: [249949.507992]  0000000000000000 00000000000106b0 ffffffff81052671 ffffffff817188a1
> Apr  1 11:16:39 swivel kernel: [249949.507997] Call Trace:
> Apr  1 11:16:39 swivel kernel: [249949.508006]  [<ffffffff811e6bf3>] ? dump_stack+0x5a/0x6f
> Apr  1 11:16:39 swivel kernel: [249949.508013]  [<ffffffff81052619>] ? warn_slowpath_common+0x8e/0xa3
> Apr  1 11:16:39 swivel kernel: [249949.508019]  [<ffffffff810230d1>] ? reserve_ds_buffers+0x102/0x326
> Apr  1 11:16:39 swivel kernel: [249949.508024]  [<ffffffff81052671>] ? warn_slowpath_fmt+0x43/0x4b
> Apr  1 11:16:39 swivel kernel: [249949.508029]  [<ffffffff810230d1>] ? reserve_ds_buffers+0x102/0x326
> Apr  1 11:16:39 swivel kernel: [249949.508035]  [<ffffffff810bfefd>] ? watchdog_timer_fn+0x1ad/0x1ad
> Apr  1 11:16:39 swivel kernel: [249949.508040]  [<ffffffff8101e15f>] ? x86_reserve_hardware+0xb9/0xc8
> Apr  1 11:16:39 swivel kernel: [249949.508045]  [<ffffffff8101e1b9>] ? x86_pmu_event_init+0x4b/0x1bb
> Apr  1 11:16:39 swivel kernel: [249949.508050]  [<ffffffff810dfca7>] ? perf_try_init_event+0x3d/0x6c
> Apr  1 11:16:39 swivel kernel: [249949.508055]  [<ffffffff810e17d2>] ? perf_event_alloc+0x3c2/0x500
> Apr  1 11:16:39 swivel kernel: [249949.508060]  [<ffffffff810e2cb7>] ? perf_event_create_kernel_counter+0x1f/0x122
> Apr  1 11:16:39 swivel kernel: [249949.508065]  [<ffffffff810bfc0e>] ? watchdog_enable+0x9d/0x199
> Apr  1 11:16:39 swivel kernel: [249949.508071]  [<ffffffff8106a8df>] ? smpboot_thread_fn+0xf7/0x13a
> Apr  1 11:16:39 swivel kernel: [249949.508075]  [<ffffffff8106a7e8>] ? sort_range+0x17/0x17
> Apr  1 11:16:39 swivel kernel: [249949.508081]  [<ffffffff81068756>] ? kthread+0x95/0x9d
> Apr  1 11:16:39 swivel kernel: [249949.508085]  [<ffffffff810686c1>] ? kthread_parkme+0x16/0x16
> Apr  1 11:16:39 swivel kernel: [249949.508092]  [<ffffffff8141dcff>] ? ret_from_fork+0x3f/0x70
> Apr  1 11:16:39 swivel kernel: [249949.508097]  [<ffffffff810686c1>] ? kthread_parkme+0x16/0x16
> Apr  1 11:16:39 swivel kernel: [249949.508100] ---[ end trace e082dccd90d0875a ]---
> Apr  1 11:16:39 swivel kernel: [249949.509383] watchdog/1: page allocation failure: order:4, mode:0x26040c0
> Apr  1 11:16:39 swivel kernel: [249949.509390] CPU: 1 PID: 11 Comm: watchdog/1 Tainted: G        W  O    4.5.0-zgws1 #2
> Apr  1 11:16:39 swivel kernel: [249949.509392] Hardware name: LENOVO 4240CTO/4240CTO, BIOS 8AET63WW (1.43 ) 05/08/2013
> Apr  1 11:16:39 swivel kernel: [249949.509395]  0000000000000047 ffffffff811e6bf3 0000000000000001 ffff88017dd4fb60
> Apr  1 11:16:39 swivel kernel: [249949.509401]  ffffffff810f01af 0000000000000010 0000000000000040 0000000000000000
> Apr  1 11:16:39 swivel kernel: [249949.509407]  00004c0800000001 000000001e5eeb00 0000000000000004 0000000000000040
> Apr  1 11:16:39 swivel kernel: [249949.509412] Call Trace:
> Apr  1 11:16:39 swivel kernel: [249949.509418]  [<ffffffff811e6bf3>] ? dump_stack+0x5a/0x6f
> Apr  1 11:16:39 swivel kernel: [249949.509425]  [<ffffffff810f01af>] ? warn_alloc_failed+0x10f/0x127
> Apr  1 11:16:39 swivel kernel: [249949.509431]  [<ffffffff810f2a55>] ? __alloc_pages_nodemask+0x8cc/0x966
> Apr  1 11:16:39 swivel kernel: [249949.509438]  [<ffffffff8112dd2c>] ? kmem_getpages+0x50/0x12c
> Apr  1 11:16:39 swivel kernel: [249949.509442]  [<ffffffff8112e046>] ? fallback_alloc+0xfe/0x1a7
> Apr  1 11:16:39 swivel kernel: [249949.509447]  [<ffffffff8112e73d>] ? kmem_cache_alloc_node_trace+0x89/0x14b
> Apr  1 11:16:39 swivel kernel: [249949.509454]  [<ffffffff8102314f>] ? reserve_ds_buffers+0x180/0x326
> Apr  1 11:16:39 swivel kernel: [249949.509459]  [<ffffffff810bfefd>] ? watchdog_timer_fn+0x1ad/0x1ad
> Apr  1 11:16:39 swivel kernel: [249949.509463]  [<ffffffff8101e15f>] ? x86_reserve_hardware+0xb9/0xc8
> Apr  1 11:16:39 swivel kernel: [249949.509468]  [<ffffffff8101e1b9>] ? x86_pmu_event_init+0x4b/0x1bb
> Apr  1 11:16:39 swivel kernel: [249949.509472]  [<ffffffff810dfca7>] ? perf_try_init_event+0x3d/0x6c
> Apr  1 11:16:39 swivel kernel: [249949.509477]  [<ffffffff810e17d2>] ? perf_event_alloc+0x3c2/0x500
> Apr  1 11:16:39 swivel kernel: [249949.509482]  [<ffffffff810e2cb7>] ? perf_event_create_kernel_counter+0x1f/0x122
> Apr  1 11:16:39 swivel kernel: [249949.509487]  [<ffffffff810bfc0e>] ? watchdog_enable+0x9d/0x199
> Apr  1 11:16:39 swivel kernel: [249949.509491]  [<ffffffff8106a8df>] ? smpboot_thread_fn+0xf7/0x13a
> Apr  1 11:16:39 swivel kernel: [249949.509495]  [<ffffffff8106a7e8>] ? sort_range+0x17/0x17
> Apr  1 11:16:39 swivel kernel: [249949.509500]  [<ffffffff81068756>] ? kthread+0x95/0x9d
> Apr  1 11:16:39 swivel kernel: [249949.509505]  [<ffffffff810686c1>] ? kthread_parkme+0x16/0x16
> Apr  1 11:16:39 swivel kernel: [249949.509510]  [<ffffffff8141dcff>] ? ret_from_fork+0x3f/0x70
> Apr  1 11:16:39 swivel kernel: [249949.509515]  [<ffffffff810686c1>] ? kthread_parkme+0x16/0x16
> Apr  1 11:16:39 swivel kernel: [249949.509519] Mem-Info:
> Apr  1 11:16:39 swivel kernel: [249949.509529] active_anon:1107088 inactive_anon:326101 isolated_anon:0
> Apr  1 11:16:39 swivel kernel: [249949.509529]  active_file:1104846 inactive_file:1367650 isolated_file:0
> Apr  1 11:16:39 swivel kernel: [249949.509529]  unevictable:2526 dirty:14757 writeback:0 unstable:0
> Apr  1 11:16:39 swivel kernel: [249949.509529]  slab_reclaimable:56106 slab_unreclaimable:33051
> Apr  1 11:16:39 swivel kernel: [249949.509529]  mapped:67336 shmem:87440 pagetables:12012 bounce:0
> Apr  1 11:16:39 swivel kernel: [249949.509529]  free:30592 free_pcp:170 free_cma:0
> Apr  1 11:16:39 swivel kernel: [249949.509538] Node 0 DMA free:15360kB min:12kB low:12kB high:16kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15984kB managed:15360kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
> Apr  1 11:16:39 swivel kernel: [249949.509553] lowmem_reserve[]: 0 3403 15919 15919
> Apr  1 11:16:39 swivel kernel: [249949.509559] Node 0 DMA32 free:64968kB min:3436kB low:4292kB high:5152kB active_anon:475148kB inactive_anon:357880kB active_file:1173604kB inactive_file:1314960kB unevictable:3416kB isolated(anon):0kB isolated(file):0kB present:3561088kB managed:3487816kB mlocked:3416kB dirty:13592kB writeback:0kB mapped:55924kB shmem:70004kB slab_reclaimable:47096kB slab_unreclaimable:17888kB kernel_stack:2000kB pagetables:8308kB unstable:0kB bounce:0kB free_pcp:4kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:128 all_unreclaimable? no
> Apr  1 11:16:39 swivel kernel: [249949.509575] lowmem_reserve[]: 0 0 12516 12516
> Apr  1 11:16:39 swivel kernel: [249949.509580] Node 0 Normal free:42040kB min:12648kB low:15808kB high:18972kB active_anon:3953204kB inactive_anon:946524kB active_file:3245780kB inactive_file:4155640kB unevictable:6688kB isolated(anon):0kB isolated(file):0kB present:13080576kB managed:12816596kB mlocked:6688kB dirty:45436kB writeback:0kB mapped:213420kB shmem:279756kB slab_reclaimable:177328kB slab_unreclaimable:114316kB kernel_stack:8688kB pagetables:39740kB unstable:0kB bounce:0kB free_pcp:764kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
> Apr  1 11:16:39 swivel kernel: [249949.509596] lowmem_reserve[]: 0 0 0 0
> Apr  1 11:16:39 swivel kernel: [249949.509601] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15360kB
> Apr  1 11:16:39 swivel kernel: [249949.509619] Node 0 DMA32: 11548*4kB (UME) 2282*8kB (UME) 55*16kB (UM) 2*32kB (UM) 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 65392kB
> Apr  1 11:16:39 swivel kernel: [249949.509638] Node 0 Normal: 3736*4kB (UME) 3206*8kB (UE) 131*16kB (U) 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 42688kB
> Apr  1 11:16:39 swivel kernel: [249949.509657] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
> Apr  1 11:16:39 swivel kernel: [249949.509661] 2561271 total pagecache pages
> Apr  1 11:16:39 swivel kernel: [249949.509664] 616 pages in swap cache
> Apr  1 11:16:39 swivel kernel: [249949.509667] Swap cache stats: add 28221, delete 27605, find 294750/295285
> Apr  1 11:16:39 swivel kernel: [249949.509670] Free swap  = 8277324kB
> Apr  1 11:16:39 swivel kernel: [249949.509672] Total swap = 8386556kB
> Apr  1 11:16:39 swivel kernel: [249949.509674] 4164412 pages RAM
> Apr  1 11:16:39 swivel kernel: [249949.509676] 0 pages HighMem/MovableOnly
> Apr  1 11:16:39 swivel kernel: [249949.509678] 84469 pages reserved
> Apr  1 11:16:39 swivel kernel: [249949.509681] 0 pages hwpoisoned
> Apr  1 11:16:39 swivel kernel: [249949.509717] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
> Apr  1 11:16:39 swivel kernel: [249949.537265] EXT4-fs (dm-16): re-mounted. Opts: data=ordered,commit=0
> Apr  1 11:16:39 swivel systemd[1]: Reloading Laptop Mode Tools.
> Apr  1 11:16:39 swivel kernel: [249949.664133] thinkpad_acpi: EC reports that Thermal Table has changed
> Apr  1 11:16:39 swivel kernel: [249949.723795] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
>
>
>
> This btrfs is ripe for the backup-format-restore procedure, right?
>
> Greetings
> Marc
>
>
> --
> -----------------------------------------------------------------------------
> Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
> Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
> Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
