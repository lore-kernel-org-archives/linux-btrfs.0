Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:34726 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbbHCSJs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Aug 2015 14:09:48 -0400
Received: by ioea135 with SMTP id a135so152463574ioe.1
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Aug 2015 11:09:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACsECNfH3Nc8eTWjmLAiCZ_h1T79A8MwN7PPPQnEGcVL9xBeRw@mail.gmail.com>
References: <CACsECNfH3Nc8eTWjmLAiCZ_h1T79A8MwN7PPPQnEGcVL9xBeRw@mail.gmail.com>
Date: Mon, 3 Aug 2015 20:09:47 +0200
Message-ID: <CACsECNdE3zQbHAZstKoZNrqhRVE2Bxj27oTnhOGquzGvY0Eoig@mail.gmail.com>
Subject: Fwd: Bug report - btrfs hanging
From: Alex <alexinbeijing@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear Btrfs devs,

I have an external HD formatted with btrfs, and have noticed that
various operations (copying files, deleting files, etc) hang from time
to time. Here's debug output from the latest hang:

dmesg output:
------------------------
[496960.834080] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2]
has bogus alignment
[496960.834192] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2]
has bogus alignment
[496960.834261] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2]
has bogus alignment
[496960.834334] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2]
has bogus alignment
[496960.834357] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2]
has bogus alignment
[496960.834658] pci_bus 0000:01: Allocating resources
[496960.834719] pci_bus 0000:06: Allocating resources
[496960.834777] pci_bus 0000:07: Allocating resources
[496960.834807] pci_bus 0000:0c: Allocating resources
[496960.834833] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2]
has bogus alignment
[496960.834976] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2]
has bogus alignment
[496960.835140] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2]
has bogus alignment
[501706.637861] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2]
has bogus alignment
[501706.638005] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2]
has bogus alignment
[501706.638114] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2]
has bogus alignment
[501706.638224] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2]
has bogus alignment
[501706.638261] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2]
has bogus alignment
[501706.638650] pci_bus 0000:01: Allocating resources
[501706.638760] pci_bus 0000:06: Allocating resources
[501706.638821] pci_bus 0000:07: Allocating resources
[501706.638851] pci_bus 0000:0c: Allocating resources
[501706.638878] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2]
has bogus alignment
[501706.639022] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2]
has bogus alignment
[501706.639226] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2]
has bogus alignment
[503148.505218] usb 4-1.5: new high-speed USB device number 4 using ehci-pci
[503148.659324] usb 4-1.5: New USB device found, idVendor=0480, idProduct=a200
[503148.659332] usb 4-1.5: New USB device strings: Mfr=2, Product=3,
SerialNumber=1
[503148.659336] usb 4-1.5: Product: External USB 3.0
[503148.659340] usb 4-1.5: Manufacturer: TOSHIBA
[503148.659343] usb 4-1.5: SerialNumber: 20140919001100F
[503148.659996] usb-storage 4-1.5:1.0: USB Mass Storage device detected
[503148.660322] scsi host10: usb-storage 4-1.5:1.0
[503149.659297] scsi 10:0:0:0: Direct-Access     TOSHIBA  External USB
3.0 0    PQ: 0 ANSI: 6
[503149.660108] sd 10:0:0:0: Attached scsi generic sg2 type 0
[503151.230437] sd 10:0:0:0: [sdb] 1953525168 512-byte logical blocks:
(1.00 TB/931 GiB)
[503151.231640] sd 10:0:0:0: [sdb] Write Protect is off
[503151.231658] sd 10:0:0:0: [sdb] Mode Sense: 43 00 00 00
[503151.232815] sd 10:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[503151.255437] sd 10:0:0:0: [sdb] Attached SCSI disk
[503151.491833] BTRFS: device label AlexEHD devid 1 transid 889 /dev/sdb
[503151.876617] BTRFS info (device sdb): disk space caching is enabled
[503371.659804] INFO: task cinnamon-settin:2211 blocked for more than
120 seconds.
[503371.659817]       Not tainted 4.1.0-rc3+ #2
[503371.659821] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[503371.659835] cinnamon-settin D ffff880213cdbca8     0  2211   2117 0x00000000
[503371.659848]  ffff880213cdbca8 ffff880215e56480 ffff8802032e1920
ffff88015afb6054
[503371.659856]  ffff880213cdc000 ffff880207f3be4c ffff8802032e1920
00000000ffffffff
[503371.659863]  ffff880207f3be50 ffff880213cdbcc8 ffffffff8179bd27
ffff8802030bc000
[503371.659868] Call Trace:
[503371.659882]  [<ffffffff8179bd27>] schedule+0x37/0x90
[503371.659898]  [<ffffffff8179c05e>] schedule_preempt_disabled+0xe/0x10
[503371.659903]  [<ffffffff8179dc45>] __mutex_lock_slowpath+0x95/0x110
[503371.659908]  [<ffffffff8179dce3>] mutex_lock+0x23/0x37
[503371.659946]  [<ffffffffa027efcb>] btrfs_show_devname+0x2b/0xe0 [btrfs]
[503371.659953]  [<ffffffff81229ccf>] show_vfsmnt+0x3f/0x150
[503371.659958]  [<ffffffff81209846>] m_show+0x16/0x20
[503371.659962]  [<ffffffff8120ee18>] seq_read+0x218/0x370
[503371.659968]  [<ffffffff811ea568>] __vfs_read+0x28/0xe0
[503371.659973]  [<ffffffff8130cc74>] ? security_file_permission+0x84/0xa0
[503371.659977]  [<ffffffff811eaac6>] ? rw_verify_area+0x56/0xe0
[503371.659982]  [<ffffffff811eabd6>] vfs_read+0x86/0x140
[503371.659986]  [<ffffffff811eba56>] SyS_read+0x46/0xb0
[503371.659992]  [<ffffffff81177903>] ? context_tracking_user_enter+0x13/0x20
[503371.659997]  [<ffffffff81024bb5>] ? syscall_trace_leave+0xa5/0x120
[503371.660001]  [<ffffffff8179ffb2>] system_call_fastpath+0x16/0x75
[503371.660064] INFO: task btrfs-transacti:32320 blocked for more than
120 seconds.
[503371.660069]       Not tainted 4.1.0-rc3+ #2
[503371.660071] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[503371.660073] btrfs-transacti D ffff8801d24a7c28     0 32320      2 0x00000000
[503371.660078]  ffff8801d24a7c28 ffff880215e56480 ffff8800be6d6480
0000000000000005
[503371.660083]  ffff8801d24a8000 7fffffffffffffff ffff880009106100
ffff8800be6d6480
[503371.660086]  0000000000000000 ffff8801d24a7c48 ffffffff8179bd27
ffff8801d24a7c88
[503371.660090] Call Trace:
[503371.660095]  [<ffffffff8179bd27>] schedule+0x37/0x90
[503371.660100]  [<ffffffff8179eaec>] schedule_timeout+0x1dc/0x260
[503371.660107]  [<ffffffff81368d20>] ? generic_make_request+0xc0/0x110
[503371.660112]  [<ffffffff81368dd8>] ? submit_bio+0x68/0x130
[503371.660116]  [<ffffffff8179c754>] wait_for_completion+0xa4/0x170
[503371.660121]  [<ffffffff810a3940>] ? wake_up_state+0x20/0x20
[503371.660152]  [<ffffffffa02ac276>] write_ctree_super+0xad6/0xcb0 [btrfs]
[503371.660176]  [<ffffffffa02b2e55>]
btrfs_commit_transaction+0x935/0xae0 [btrfs]
[503371.660196]  [<ffffffffa02ae115>] transaction_kthread+0x1b5/0x240 [btrfs]
[503371.660214]  [<ffffffffa02adf60>] ?
btrfs_cleanup_transaction+0x570/0x570 [btrfs]
[503371.660220]  [<ffffffff81095759>] kthread+0xc9/0xe0
[503371.660225]  [<ffffffff81095690>] ? kthread_create_on_node+0x180/0x180
[503371.660229]  [<ffffffff817a03e2>] ret_from_fork+0x42/0x70
[503371.660233]  [<ffffffff81095690>] ? kthread_create_on_node+0x180/0x180
[503491.796892] INFO: task cinnamon-settin:2211 blocked for more than
120 seconds.
[503491.796900]       Not tainted 4.1.0-rc3+ #2
[503491.796902] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[503491.796904] cinnamon-settin D ffff880213cdbca8     0  2211   2117 0x00000000
[503491.796911]  ffff880213cdbca8 ffff880215e56480 ffff8802032e1920
ffff88015afb6054
[503491.796916]  ffff880213cdc000 ffff880207f3be4c ffff8802032e1920
00000000ffffffff
[503491.796919]  ffff880207f3be50 ffff880213cdbcc8 ffffffff8179bd27
ffff8802030bc000
[503491.796923] Call Trace:
[503491.796934]  [<ffffffff8179bd27>] schedule+0x37/0x90
[503491.796939]  [<ffffffff8179c05e>] schedule_preempt_disabled+0xe/0x10
[503491.796943]  [<ffffffff8179dc45>] __mutex_lock_slowpath+0x95/0x110
[503491.796948]  [<ffffffff8179dce3>] mutex_lock+0x23/0x37
[503491.796980]  [<ffffffffa027efcb>] btrfs_show_devname+0x2b/0xe0 [btrfs]
[503491.796986]  [<ffffffff81229ccf>] show_vfsmnt+0x3f/0x150
[503491.796990]  [<ffffffff81209846>] m_show+0x16/0x20
[503491.796994]  [<ffffffff8120ee18>] seq_read+0x218/0x370
[503491.796999]  [<ffffffff811ea568>] __vfs_read+0x28/0xe0
[503491.797004]  [<ffffffff8130cc74>] ? security_file_permission+0x84/0xa0
[503491.797008]  [<ffffffff811eaac6>] ? rw_verify_area+0x56/0xe0
[503491.797012]  [<ffffffff811eabd6>] vfs_read+0x86/0x140
[503491.797016]  [<ffffffff811eba56>] SyS_read+0x46/0xb0
[503491.797021]  [<ffffffff81177903>] ? context_tracking_user_enter+0x13/0x20
[503491.797025]  [<ffffffff81024bb5>] ? syscall_trace_leave+0xa5/0x120
[503491.797028]  [<ffffffff8179ffb2>] system_call_fastpath+0x16/0x75
[503491.797086] INFO: task btrfs-transacti:32320 blocked for more than
120 seconds.
[503491.797089]       Not tainted 4.1.0-rc3+ #2
[503491.797090] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[503491.797092] btrfs-transacti D ffff8801d24a7c28     0 32320      2 0x00000000
[503491.797096]  ffff8801d24a7c28 ffff880215e56480 ffff8800be6d6480
0000000000000005
[503491.797100]  ffff8801d24a8000 7fffffffffffffff ffff880009106100
ffff8800be6d6480
[503491.797104]  0000000000000000 ffff8801d24a7c48 ffffffff8179bd27
ffff8801d24a7c88
[503491.797107] Call Trace:
[503491.797112]  [<ffffffff8179bd27>] schedule+0x37/0x90
[503491.797116]  [<ffffffff8179eaec>] schedule_timeout+0x1dc/0x260
[503491.797122]  [<ffffffff81368d20>] ? generic_make_request+0xc0/0x110
[503491.797126]  [<ffffffff81368dd8>] ? submit_bio+0x68/0x130
[503491.797130]  [<ffffffff8179c754>] wait_for_completion+0xa4/0x170
[503491.797135]  [<ffffffff810a3940>] ? wake_up_state+0x20/0x20
[503491.797158]  [<ffffffffa02ac276>] write_ctree_super+0xad6/0xcb0 [btrfs]
[503491.797179]  [<ffffffffa02b2e55>]
btrfs_commit_transaction+0x935/0xae0 [btrfs]
[503491.797197]  [<ffffffffa02ae115>] transaction_kthread+0x1b5/0x240 [btrfs]
[503491.797214]  [<ffffffffa02adf60>] ?
btrfs_cleanup_transaction+0x570/0x570 [btrfs]
[503491.797220]  [<ffffffff81095759>] kthread+0xc9/0xe0
[503491.797224]  [<ffffffff81095690>] ? kthread_create_on_node+0x180/0x180
[503491.797228]  [<ffffffff817a03e2>] ret_from_fork+0x42/0x70
[503491.797232]  [<ffffffff81095690>] ? kthread_create_on_node+0x180/0x180
[503553.950395] sd 10:0:0:0: timing out command, waited 360s
[503553.950413] blk_update_request: I/O error, dev sdb, sector 0
[503553.950465] BTRFS: bdev /dev/sdb errs: wr 0, rd 0, flush 1, corrupt 0, gen 0
[503553.950487] BTRFS: error (device sdb) in write_all_supers:3498:
errno=-5 IO failure (errors while submitting device barriers.)
[503553.950491] BTRFS info (device sdb): forced readonly
[503553.950496] BTRFS warning (device sdb): Skipping commit of aborted
transaction.
[503553.950498] ------------[ cut here ]------------
[503553.950534] WARNING: CPU: 3 PID: 32320 at fs/btrfs/super.c:260
__btrfs_abort_transaction+0x54/0x130 [btrfs]()
[503553.950537] BTRFS: Transaction aborted (error -5)
[503553.950539] Modules linked in: nls_iso8859_1 usb_storage pl2303
usbserial ctr ccm arc4 iwldvm mac80211 bnep rfcomm bluetooth iwlwifi
cfg80211 snd_hda_codec_hdmi rtsx_pci_ms rtsx_pci_sdmmc memstick
snd_hda_codec_realtek joydev snd_hda_codec_generic snd_hda_intel
snd_hda_controller snd_hda_codec x86_pkg_temp_thermal intel_powerclamp
coretemp kvm_intel snd_hda_core kvm snd_hwdep snd_pcm thinkpad_acpi
nvram snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq dm_multipath
scsi_dh snd_seq_device crct10dif_pclmul snd_timer crc32_pclmul psmouse
ghash_clmulni_intel snd rtsx_pci serio_raw shpchp lpc_ich soundcore
mac_hid binfmt_misc parport_pc ppdev lp parport btrfs xor raid6_pq
dm_crypt dm_mirror dm_region_hash dm_log i915 i2c_algo_bit
drm_kms_helper drm r8169 mii aesni_intel aes_x86_64 glue_helper lrw
gf128mul ablk_helper ahci cryptd libahci wmi video
[503553.950611] CPU: 3 PID: 32320 Comm: btrfs-transacti Not tainted
4.1.0-rc3+ #2
[503553.950613] Hardware name: LENOVO 2481CTO/2481CTO, BIOS
G3ET36WW(1.10) 06/20/2012
[503553.950616]  ffffffffa0330632 ffff8801d24a7c58 ffffffff8179823d
0000000000000000
[503553.950620]  ffff8801d24a7ca8 ffff8801d24a7c98 ffffffff8107631a
ffffffff81ef1122
[503553.950625]  ffff880018aeb000 ffff8800c31cd000 00000000fffffffb
ffffffffa032f130
[503553.950629] Call Trace:
[503553.950646]  [<ffffffff8179823d>] dump_stack+0x45/0x57
[503553.950656]  [<ffffffff8107631a>] warn_slowpath_common+0x8a/0xc0
[503553.950670]  [<ffffffff81076396>] warn_slowpath_fmt+0x46/0x50
[503553.950710]  [<ffffffffa0283cf4>]
__btrfs_abort_transaction+0x54/0x130 [btrfs]
[503553.950742]  [<ffffffffa02b1a7e>] cleanup_transaction+0x6e/0x2b0 [btrfs]
[503553.950765]  [<ffffffffa0283a20>] ? btrfs_printk+0x80/0xf0 [btrfs]
[503553.950772]  [<ffffffff810b98d0>] ? prepare_to_wait_event+0x110/0x110
[503553.950778]  [<ffffffff810b9368>] ? __wake_up+0x48/0x60
[503553.950805]  [<ffffffffa02b2831>]
btrfs_commit_transaction+0x311/0xae0 [btrfs]
[503553.950831]  [<ffffffffa02ae115>] transaction_kthread+0x1b5/0x240 [btrfs]
[503553.950853]  [<ffffffffa02adf60>] ?
btrfs_cleanup_transaction+0x570/0x570 [btrfs]
[503553.950859]  [<ffffffff81095759>] kthread+0xc9/0xe0
[503553.950865]  [<ffffffff81095690>] ? kthread_create_on_node+0x180/0x180
[503553.950870]  [<ffffffff817a03e2>] ret_from_fork+0x42/0x70
[503553.950875]  [<ffffffff81095690>] ? kthread_create_on_node+0x180/0x180
[503553.950878] ---[ end trace c494302704bb5eb1 ]---
[503553.950883] BTRFS: error (device sdb) in cleanup_transaction:1692:
errno=-5 IO failure
[503553.950887] BTRFS info (device sdb): delayed_refs has NO entry

other stuff:
-----------------------------
20:03 ~ % uname -a
Linux alex-ThinkPad-L530 4.1.0-rc3+ #2 SMP Sun Jul 5 22:24:05 CAT 2015
x86_64 x86_64 x86_64 GNU/Linux
20:04 ~ % btrfs --version
Btrfs v3.12
20:04 ~ % btrfs fi show
Label: AlexEHD  uuid: 6ae2df57-c009-4ad5-b59e-a7ffa1a3ce35
        Total devices 1 FS bytes used 527.48GiB
        devid    1 size 931.51GiB used 536.04GiB path /dev/sdb

Btrfs v3.12
20:04 ~ % btrfs fi df /media/alex/AlexEHD
Data, single: total=522.01GiB, used=521.48GiB
System, DUP: total=8.00MiB, used=80.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, DUP: total=7.00GiB, used=6.00GiB
Metadata, single: total=8.00MiB, used=0.00
unknown, single: total=512.00MiB, used=0.00

------------------------

I'm sending this in the hope that someone may have an idea how to fix
it... please let me know if any other information would be helpful. If
you'd like me to patch something to emit more debugging information,
and recompile my kernel, I can do that. Please note that although this
is a kernel which was built from source, the same problem also occurs
when I boot the pre-built kernel which comes with Linux Mint.

Thanks,
Alex Dowad
