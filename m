Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-by2nam03on0071.outbound.protection.outlook.com ([104.47.42.71]:27680
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1946674AbdD3VIt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 30 Apr 2017 17:08:49 -0400
From: Zach Aller <ZAller@iteris.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: How to fix these btrfs errors
Date: Sun, 30 Apr 2017 21:08:48 +0000
Message-ID: <D52BBC8E.48696%zaller@iteris.com>
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So I have been getting a lot of errors with a btrfs filesystem. I would
like to figure out how to fix them without losing data or having to redo
the data. Below I have the output of some of the requested command. I have
ran a btrfs check without the ‹repair option I wanted to check here first
to see if it was safe to do so based off what I have read it seems to be
unsafe is this true for this case or is there some other thing I should do
to try and fix these errors?


uname -a
Linux server 4.11.0-041100rc8-generic #201704232131 SMP Mon Apr 24
01:32:55 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux

./btrfs --version
btrfs-progs v4.10

./btrfs fi show
Label: none  uuid: bdd89c26-038d-49fd-b895-52b8deb989cc
	Total devices 1 FS bytes used 17.04TiB
	devid    1 size 21.83TiB used 17.28TiB path /dev/sda

./btrfs fi df /mnt/btrfs/
Data, single: total=17.24TiB, used=17.02TiB
System, DUP: total=8.00MiB, used=1.81MiB
Metadata, DUP: total=19.50GiB, used=17.97GiB
GlobalReserve, single: total=512.00MiB, used=0.00B



Here is a dmesg snippet


[    3.633295] BTRFS: device fsid bdd89c26-038d-49fd-b895-52b8deb989cc
devid 1 transid 72387 /dev/sda
[   12.907658] BTRFS info (device sda): disk space caching is enabled
[   12.907659] BTRFS info (device sda): has skinny extents
[   13.129140] BTRFS info (device sda): bdev /dev/sda errs: wr 0, rd 0,
flush 0, corrupt 217, gen 19
[20956.415076] BTRFS info (device sda): The free space cache file
(9804365955072) is invalid. skip it
[36292.358558] BTRFS warning (device sda): checksum error at logical
5614914584576 on dev /dev/sda, sector 10979229344: metadata leaf (level 0)
in tree 7
[36292.358563] BTRFS warning (device sda): checksum error at logical
5614914584576 on dev /dev/sda, sector 10979229344: metadata leaf (level 0)
in tree 7
[36292.358569] BTRFS error (device sda): bdev /dev/sda errs: wr 0, rd 0,
flush 0, corrupt 218, gen 19
[36292.364717] BTRFS error (device sda): unable to fixup (regular) error
at logical 5614914584576 on dev /dev/sda
[36292.368359] BTRFS warning (device sda): checksum error at logical
5614914600960 on dev /dev/sda, sector 10979229376: metadata leaf (level 0)
in tree 7
[36292.368363] BTRFS warning (device sda): checksum error at logical
5614914600960 on dev /dev/sda, sector 10979229376: metadata leaf (level 0)
in tree 7
[36292.368369] BTRFS error (device sda): bdev /dev/sda errs: wr 0, rd 0,
flush 0, corrupt 219, gen 19
[36292.372004] BTRFS error (device sda): unable to fixup (regular) error
at logical 5614914600960 on dev /dev/sda
[36292.375825] BTRFS warning (device sda): checksum error at logical
5614914617344 on dev /dev/sda, sector 10979229408: metadata leaf (level 0)
in tree 7
[36292.375830] BTRFS warning (device sda): checksum error at logical
5614914617344 on dev /dev/sda, sector 10979229408: metadata leaf (level 0)
in tree 7
[36292.375836] BTRFS error (device sda): bdev /dev/sda errs: wr 0, rd 0,
flush 0, corrupt 220, gen 19
[36292.379664] BTRFS error (device sda): unable to fixup (regular) error
at logical 5614914617344 on dev /dev/sda
[36294.785933] BTRFS warning (device sda): checksum/header error at
logical 5614914584576 on dev /dev/sda, sector 10980277920: metadata leaf
(level 0) in tree 7
[36294.785938] BTRFS warning (device sda): checksum/header error at
logical 5614914584576 on dev /dev/sda, sector 10980277920: metadata leaf
(level 0) in tree 7
[36294.785945] BTRFS error (device sda): bdev /dev/sda errs: wr 0, rd 0,
flush 0, corrupt 220, gen 20
[36294.811292] BTRFS error (device sda): unable to fixup (regular) error
at logical 5614914584576 on dev /dev/sda
[36294.815711] BTRFS warning (device sda): checksum/header error at
logical 5614914600960 on dev /dev/sda, sector 10980277952: metadata leaf
(level 0) in tree 7
[36294.815715] BTRFS warning (device sda): checksum/header error at
logical 5614914600960 on dev /dev/sda, sector 10980277952: metadata leaf
(level 0) in tree 7
[36294.815721] BTRFS error (device sda): bdev /dev/sda errs: wr 0, rd 0,
flush 0, corrupt 220, gen 21
[36294.819616] BTRFS error (device sda): unable to fixup (regular) error
at logical 5614914600960 on dev /dev/sda
[36294.823458] BTRFS warning (device sda): checksum/header error at
logical 5614914617344 on dev /dev/sda, sector 10980277984: metadata leaf
(level 0) in tree 7
[36294.823463] BTRFS warning (device sda): checksum/header error at
logical 5614914617344 on dev /dev/sda, sector 10980277984: metadata leaf
(level 0) in tree 7
[36294.823469] BTRFS error (device sda): bdev /dev/sda errs: wr 0, rd 0,
flush 0, corrupt 220, gen 22
[36294.827285] BTRFS error (device sda): unable to fixup (regular) error
at logical 5614914617344 on dev /dev/sda
[38085.152105] BTRFS error (device sda): bad tree block start 65536
5614914584576
[38085.920817] BTRFS error (device sda): bad tree block start 65536
5614914584576
[38085.934875] BTRFS error (device sda): bad tree block start 499762348032
5614914584576
[60948.070835] BTRFS info (device sda): space_info 4 has 1641807872 free,
is not full
[60948.070836] BTRFS info (device sda): space_info total=20937965568,
used=19296026624, pinned=0, reserved=0, may_use=65536, readonly=65536



[60948.070623] ------------[ cut here ]------------
[60948.070636] WARNING: CPU: 5 PID: 18318 at
/home/kernel/COD/linux/fs/btrfs/extent-tree.c:5702
btrfs_free_block_groups+0x399/0x440 [btrfs]
[60948.070637] Modules linked in: xt_nat xt_tcpudp veth binfmt_misc
ipt_MASQUERADE nf_nat_masquerade_ipv4 xfrm_user xfrm_algo iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter
ip_tables xt_conntrack x_tables nf_nat nf_conntrack libcrc32c br_netfilter
bridge stp llc overlay nls_iso8859_1 intel_rapl x86_pkg_temp_thermal
intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul
crc32_pclmul ghash_clmulni_intel snd_hda_codec_hdmi pcbc
snd_hda_codec_realtek aesni_intel aes_x86_64 crypto_simd
snd_hda_codec_generic glue_helper cryptd input_leds snd_hda_intel
snd_hda_codec snd_hda_core hci_uart snd_hwdep btbcm ppdev btqca snd_pcm
intel_cstate snd_timer snd parport_pc intel_rapl_perf btintel bluetooth
mei_me mei intel_lpss_acpi soundcore parport acpi_als mac_hid kfifo_buf
[60948.070657]  intel_lpss shpchp industrialio acpi_pad autofs4 btrfs xor
raid6_pq hid_generic usbhid i915 i2c_algo_bit drm_kms_helper e1000e
syscopyarea sysfillrect sysimgblt fb_sys_fops ptp drm ahci pps_core hptiop
libahci pinctrl_sunrisepoint i2c_hid pinctrl_intel video hid
[60948.070667] CPU: 5 PID: 18318 Comm: umount Not tainted
4.11.0-041100rc8-generic #201704232131
[60948.070668] Hardware name: To Be Filled By O.E.M. To Be Filled By
O.E.M./Z270M Pro4, BIOS P1.10 11/14/2016
[60948.070668] Call Trace:
[60948.070671]  dump_stack+0x63/0x81
[60948.070672]  __warn+0xcb/0xf0
[60948.070673]  warn_slowpath_null+0x1d/0x20
[60948.070679]  btrfs_free_block_groups+0x399/0x440 [btrfs]
[60948.070686]  close_ctree+0x12b/0x310 [btrfs]
[60948.070690]  btrfs_put_super+0x15/0x20 [btrfs]
[60948.070692]  generic_shutdown_super+0x6f/0x100
[60948.070693]  kill_anon_super+0x12/0x20
[60948.070697]  btrfs_kill_super+0x18/0x110 [btrfs]
[60948.070698]  deactivate_locked_super+0x43/0x70
[60948.070699]  deactivate_super+0x5a/0x60
[60948.070700]  cleanup_mnt+0x3f/0x90
[60948.070701]  __cleanup_mnt+0x12/0x20
[60948.070702]  task_work_run+0x80/0xa0
[60948.070703]  exit_to_usermode_loop+0xaa/0xb0
[60948.070704]  syscall_return_slowpath+0x59/0x60
[60948.070705]  entry_SYSCALL_64_fastpath+0xab/0xad
[60948.070705] RIP: 0033:0x7f2903d44897
[60948.070706] RSP: 002b:00007fffcecd7e38 EFLAGS: 00000246 ORIG_RAX:
00000000000000a6
[60948.070706] RAX: 0000000000000000 RBX: 00000000020c6030 RCX:
00007f2903d44897
[60948.070707] RDX: 0000000000000001 RSI: 0000000000000000 RDI:
00000000020c6210
[60948.070707] RBP: 00000000020c6210 R08: 0000000000000000 R09:
0000000000000015
[60948.070708] R10: 00000000000006b2 R11: 0000000000000246 R12:
00007f290424d83c
[60948.070708] R13: 0000000000000000 R14: 0000000000000000 R15:
00007fffcecd80c0
[60948.070709] ---[ end trace dd48a6c484b9e2c4 ]---
[60948.070709] ------------[ cut here ]------------
[60948.070715] WARNING: CPU: 5 PID: 18318 at
/home/kernel/COD/linux/fs/btrfs/extent-tree.c:5703
btrfs_free_block_groups+0x3b8/0x440 [btrfs]
[60948.070715] Modules linked in: xt_nat xt_tcpudp veth binfmt_misc
ipt_MASQUERADE nf_nat_masquerade_ipv4 xfrm_user xfrm_algo iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter
ip_tables xt_conntrack x_tables nf_nat nf_conntrack libcrc32c br_netfilter
bridge stp llc overlay nls_iso8859_1 intel_rapl x86_pkg_temp_thermal
intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul
crc32_pclmul ghash_clmulni_intel snd_hda_codec_hdmi pcbc
snd_hda_codec_realtek aesni_intel aes_x86_64 crypto_simd
snd_hda_codec_generic glue_helper cryptd input_leds snd_hda_intel
snd_hda_codec snd_hda_core hci_uart snd_hwdep btbcm ppdev btqca snd_pcm
intel_cstate snd_timer snd parport_pc intel_rapl_perf btintel bluetooth
mei_me mei intel_lpss_acpi soundcore parport acpi_als mac_hid kfifo_buf
[60948.070728]  intel_lpss shpchp industrialio acpi_pad autofs4 btrfs xor
raid6_pq hid_generic usbhid i915 i2c_algo_bit drm_kms_helper e1000e
syscopyarea sysfillrect sysimgblt fb_sys_fops ptp drm ahci pps_core hptiop
libahci pinctrl_sunrisepoint i2c_hid pinctrl_intel video hid
[60948.070734] CPU: 5 PID: 18318 Comm: umount Tainted: G        W
4.11.0-041100rc8-generic #201704232131
[60948.070734] Hardware name: To Be Filled By O.E.M. To Be Filled By
O.E.M./Z270M Pro4, BIOS P1.10 11/14/2016
[60948.070734] Call Trace:
[60948.070735]  dump_stack+0x63/0x81
[60948.070736]  __warn+0xcb/0xf0
[60948.070737]  warn_slowpath_null+0x1d/0x20
[60948.070742]  btrfs_free_block_groups+0x3b8/0x440 [btrfs]
[60948.070748]  close_ctree+0x12b/0x310 [btrfs]
[60948.070753]  btrfs_put_super+0x15/0x20 [btrfs]
[60948.070754]  generic_shutdown_super+0x6f/0x100
[60948.070755]  kill_anon_super+0x12/0x20
[60948.070760]  btrfs_kill_super+0x18/0x110 [btrfs]
[60948.070761]  deactivate_locked_super+0x43/0x70
[60948.070762]  deactivate_super+0x5a/0x60
[60948.070762]  cleanup_mnt+0x3f/0x90
[60948.070763]  __cleanup_mnt+0x12/0x20
[60948.070764]  task_work_run+0x80/0xa0
[60948.070765]  exit_to_usermode_loop+0xaa/0xb0
[60948.070765]  syscall_return_slowpath+0x59/0x60
[60948.070766]  entry_SYSCALL_64_fastpath+0xab/0xad
[60948.070766] RIP: 0033:0x7f2903d44897
[60948.070767] RSP: 002b:00007fffcecd7e38 EFLAGS: 00000246 ORIG_RAX:
00000000000000a6
[60948.070768] RAX: 0000000000000000 RBX: 00000000020c6030 RCX:
00007f2903d44897
[60948.070768] RDX: 0000000000000001 RSI: 0000000000000000 RDI:
00000000020c6210
[60948.070768] RBP: 00000000020c6210 R08: 0000000000000000 R09:
0000000000000015
[60948.070769] R10: 00000000000006b2 R11: 0000000000000246 R12:
00007f290424d83c
[60948.070769] R13: 0000000000000000 R14: 0000000000000000 R15:
00007fffcecd80c0
[60948.070770] ---[ end trace dd48a6c484b9e2c5 ]---
[60948.070775] ------------[ cut here ]------------
[60948.070780] WARNING: CPU: 5 PID: 18318 at
/home/kernel/COD/linux/fs/btrfs/extent-tree.c:9826
btrfs_free_block_groups+0x29d/0x440 [btrfs]
[60948.070780] Modules linked in: xt_nat xt_tcpudp veth binfmt_misc
ipt_MASQUERADE nf_nat_masquerade_ipv4 xfrm_user xfrm_algo iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter
ip_tables xt_conntrack x_tables nf_nat nf_conntrack libcrc32c br_netfilter
bridge stp llc overlay nls_iso8859_1 intel_rapl x86_pkg_temp_thermal
intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul
crc32_pclmul ghash_clmulni_intel snd_hda_codec_hdmi pcbc
snd_hda_codec_realtek aesni_intel aes_x86_64 crypto_simd
snd_hda_codec_generic glue_helper cryptd input_leds snd_hda_intel
snd_hda_codec snd_hda_core hci_uart snd_hwdep btbcm ppdev btqca snd_pcm
intel_cstate snd_timer snd parport_pc intel_rapl_perf btintel bluetooth
mei_me mei intel_lpss_acpi soundcore parport acpi_als mac_hid kfifo_buf
[60948.070793]  intel_lpss shpchp industrialio acpi_pad autofs4 btrfs xor
raid6_pq hid_generic usbhid i915 i2c_algo_bit drm_kms_helper e1000e
syscopyarea sysfillrect sysimgblt fb_sys_fops ptp drm ahci pps_core hptiop
libahci pinctrl_sunrisepoint i2c_hid pinctrl_intel video hid
[60948.070799] CPU: 5 PID: 18318 Comm: umount Tainted: G        W
4.11.0-041100rc8-generic #201704232131
[60948.070799] Hardware name: To Be Filled By O.E.M. To Be Filled By
O.E.M./Z270M Pro4, BIOS P1.10 11/14/2016
[60948.070799] Call Trace:
[60948.070800]  dump_stack+0x63/0x81
[60948.070801]  __warn+0xcb/0xf0
[60948.070801]  warn_slowpath_null+0x1d/0x20
[60948.070807]  btrfs_free_block_groups+0x29d/0x440 [btrfs]
[60948.070813]  close_ctree+0x12b/0x310 [btrfs]
[60948.070817]  btrfs_put_super+0x15/0x20 [btrfs]
[60948.070818]  generic_shutdown_super+0x6f/0x100
[60948.070819]  kill_anon_super+0x12/0x20
[60948.070824]  btrfs_kill_super+0x18/0x110 [btrfs]
[60948.070825]  deactivate_locked_super+0x43/0x70
[60948.070826]  deactivate_super+0x5a/0x60
[60948.070826]  cleanup_mnt+0x3f/0x90
[60948.070827]  __cleanup_mnt+0x12/0x20
[60948.070828]  task_work_run+0x80/0xa0
[60948.070829]  exit_to_usermode_loop+0xaa/0xb0
[60948.070829]  syscall_return_slowpath+0x59/0x60
[60948.070830]  entry_SYSCALL_64_fastpath+0xab/0xad
[60948.070830] RIP: 0033:0x7f2903d44897
[60948.070831] RSP: 002b:00007fffcecd7e38 EFLAGS: 00000246 ORIG_RAX:
00000000000000a6
[60948.070831] RAX: 0000000000000000 RBX: 00000000020c6030 RCX:
00007f2903d44897
[60948.070832] RDX: 0000000000000001 RSI: 0000000000000000 RDI:
00000000020c6210
[60948.070832] RBP: 00000000020c6210 R08: 0000000000000000 R09:
0000000000000015
[60948.070832] R10: 00000000000006b2 R11: 0000000000000246 R12:
00007f290424d83c
[60948.070833] R13: 0000000000000000 R14: 0000000000000000 R15:
00007fffcecd80c0
[60948.070833] ---[ end trace dd48a6c484b9e2c6 ]---
[60948.070835] BTRFS info (device sda): space_info 4 has 1641807872 free,
is not full
[60948.070836] BTRFS info (device sda): space_info total=20937965568,
used=19296026624, pinned=0, reserved=0, may_use=65536, readonly=65536




./btrfs check /dev/sda
Checking filesystem on /dev/sda
UUID: bdd89c26-038d-49fd-b895-52b8deb989cc
checking extents
checksum verify failed on 5614914584576 found A74544D2 wanted 43A6F964
checksum verify failed on 5614914584576 found A74544D2 wanted 43A6F964
checksum verify failed on 5614914584576 found A74544D2 wanted 43A6F964
bytenr mismatch, want=5614914584576, have=65536
checksum verify failed on 5614914600960 found E0F4CA4E wanted 041777F8
checksum verify failed on 5614914600960 found E0F4CA4E wanted 041777F8
checksum verify failed on 5614914600960 found E0F4CA4E wanted 041777F8
bytenr mismatch, want=5614914600960, have=65536
checksum verify failed on 5614914617344 found 0258CB5B wanted E6BB76ED
checksum verify failed on 5614914617344 found 0258CB5B wanted E6BB76ED
checksum verify failed on 5614914617344 found 0258CB5B wanted E6BB76ED
bytenr mismatch, want=5614914617344, have=196608
checksum verify failed on 15732835876864 found 0EA0AA8A wanted EA43173C
checksum verify failed on 15732835876864 found 0EA0AA8A wanted EA43173C
checksum verify failed on 15732835893248 found E4E3BDB6 wanted 00000000
checksum verify failed on 15732835893248 found E4E3BDB6 wanted 00000000
owner ref check failed [5614914584576 16384]
owner ref check failed [5614914600960 16384]
owner ref check failed [5614914617344 16384]
checking free space cache
checking fs roots
checksum verify failed on 5614914584576 found A74544D2 wanted 43A6F964
checksum verify failed on 5614914584576 found A74544D2 wanted 43A6F964
checksum verify failed on 5614914584576 found A74544D2 wanted 43A6F964
bytenr mismatch, want=5614914584576, have=65536
checksum verify failed on 5614914600960 found E0F4CA4E wanted 041777F8
checksum verify failed on 5614914600960 found E0F4CA4E wanted 041777F8
checksum verify failed on 5614914600960 found E0F4CA4E wanted 041777F8
bytenr mismatch, want=5614914600960, have=65536
checksum verify failed on 5614914617344 found 0258CB5B wanted E6BB76ED
checksum verify failed on 5614914617344 found 0258CB5B wanted E6BB76ED
checksum verify failed on 5614914617344 found 0258CB5B wanted E6BB76ED
bytenr mismatch, want=5614914617344, have=196608
checksum verify failed on 15732835876864 found 0EA0AA8A wanted EA43173C
checksum verify failed on 15732835876864 found 0EA0AA8A wanted EA43173C
checksum verify failed on 15732835893248 found E4E3BDB6 wanted 00000000
checksum verify failed on 15732835893248 found E4E3BDB6 wanted 00000000
checking csums
checksum verify failed on 5614914584576 found A74544D2 wanted 43A6F964
checksum verify failed on 5614914584576 found A74544D2 wanted 43A6F964
checksum verify failed on 5614914584576 found A74544D2 wanted 43A6F964
bytenr mismatch, want=5614914584576, have=65536
Error going to next leaf -5
checking root refs
found 18737354526720 bytes used, no error found
total csum bytes: 18274778176
total tree bytes: 19297878016
total fs tree bytes: 388939776
total extent tree bytes: 132546560
btree space waste bytes: 421826725
file data blocks allocated: 18752764727296
 referenced 18717933031424

