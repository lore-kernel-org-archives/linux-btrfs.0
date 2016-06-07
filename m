Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:45292 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983AbcFGP4d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Jun 2016 11:56:33 -0400
Received: from [195.4.92.140] (helo=mjail0.freenet.de)
	by mout2.freenet.de with esmtpa (ID master.b.at.raven@chefmail.de) (port 25) (Exim 4.85 #1)
	id 1bAJMk-0004sx-Bb
	for linux-btrfs@vger.kernel.org; Tue, 07 Jun 2016 17:56:30 +0200
Received: from localhost ([::1]:49790 helo=mjail0.freenet.de)
	by mjail0.freenet.de with esmtpa (ID master.b.at.raven@chefmail.de) (Exim 4.85 #1)
	id 1bAJMk-0006Yi-6q
	for linux-btrfs@vger.kernel.org; Tue, 07 Jun 2016 17:56:30 +0200
Received: from mx16.freenet.de ([195.4.92.26]:43951)
	by mjail0.freenet.de with esmtpa (ID master.b.at.raven@chefmail.de) (Exim 4.85 #1)
	id 1bAJKk-0001Kn-Do
	for linux-btrfs@vger.kernel.org; Tue, 07 Jun 2016 17:54:26 +0200
Received: from ppp-88-217-30-61.dynamic.mnet-online.de ([88.217.30.61]:34934 helo=[192.168.1.204])
	by mx16.freenet.de with esmtpsa (ID master.b.at.raven@chefmail.de) (TLSv1.2:DHE-RSA-AES128-SHA:128) (port 465) (Exim 4.85 #1)
	id 1bAJKk-0005hE-2i
	for linux-btrfs@vger.kernel.org; Tue, 07 Jun 2016 17:54:26 +0200
From: g6094199@freenet.de
Subject: [Bug] Kernel 4.6.1 errors
To: linux-btrfs@vger.kernel.org
Message-ID: <24157b0e-7fd5-b5c7-8411-af7c3d133c11@chefmail.de>
Date: Tue, 7 Jun 2016 17:54:26 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

he guys!

I´m running Debian Sid where i have found several kernel errors today
and most of them are btrfs related.

uname -a
Linux NAS 4.6.0-trunk-amd64 #1 SMP Debian 4.6-1~exp1 (2016-05-17) x86_64
GNU/Linux


Inside are 2 disks as Raid0, another disk as single and the system disk
also as single...all BTRFS of cause.

Raid0: sdd1, sdd1

Single: sdc1

System: sda1


[  486.821206] ------------[ cut here ]------------
[  486.821284] WARNING: CPU: 0 PID: 923 at
/build/linux-_jiRqf/linux-4.6/fs/btrfs/inode.c:9261
btrfs_destroy_inode+0x234/0x2a0 [btrfs]
[  486.821289] Modules linked in: nfsd(E) auth_rpcgss(E) nfs_acl(E)
lockd(E) grace(E) sunrpc(E) ppdev(E) iTCO_wdt(E) iTCO_vendor_support(E)
i915(E) video(E) coretemp(E) drm_kms_helper(E) serio_raw(E) i2c_i801(E)
pcspkr(E) sg(E) evdev(E) drm(E) parport_pc(E) 8250_fintek(E)
acpi_cpufreq(E) i2c_algo_bit(E) parport(E) lpc_ich(E) tpm_tis(E) tpm(E)
shpchp(E) mfd_core(E) button(E) processor(E) autofs4(E) btrfs(E)
crc32c_generic(E) xor(E) raid6_pq(E) hid_generic(E) usbhid(E) hid(E)
sd_mod(E) ata_generic(E) psmouse(E) ahci(E) libahci(E) pata_jmicron(E)
uhci_hcd(E) ehci_pci(E) ehci_hcd(E) libata(E) usbcore(E) usb_common(E)
scsi_mod(E) r8169(E) mii(E) fjes(E)
[  486.821389] CPU: 0 PID: 923 Comm: apt Tainted: G            E  
4.6.0-trunk-amd64 #1 Debian 4.6-1~exp1
[  486.821394] Hardware name: Gigabyte Technology Co., Ltd.
D525TUD/D525TUD, BIOS F5 06/20/2011
[  486.821400]  0000000000000286 00000000143e21ca ffffffff81311345
0000000000000000
[  486.821409]  0000000000000000 ffffffff8107a50e ffff88010bb80840
ffff88010b9c4dc8
[  486.821418]  ffff880036865000 ffff88010b9c4dc8 ffff880113846958
ffff88010b9c4dc8
[  486.821426] Call Trace:
[  486.821440]  [<ffffffff81311345>] ? dump_stack+0x5c/0x77
[  486.821450]  [<ffffffff8107a50e>] ? __warn+0xbe/0xe0
[  486.821509]  [<ffffffffc02dcd34>] ? btrfs_destroy_inode+0x234/0x2a0
[btrfs]
[  486.821519]  [<ffffffff81208288>] ? __dentry_kill+0x178/0x1d0
[  486.821526]  [<ffffffff812083fb>] ? dput+0x11b/0x210
[  486.821534]  [<ffffffff811f3404>] ? __fput+0x164/0x1e0
[  486.821544]  [<ffffffff81097511>] ? task_work_run+0x71/0x90
[  486.821553]  [<ffffffff8100333a>] ? exit_to_usermode_loop+0xba/0xc0
[  486.821561]  [<ffffffff81003c05>] ? syscall_return_slowpath+0x45/0x50
[  486.821570]  [<ffffffff815c64be>] ?
system_call_fast_compare_end+0x94/0x96
[  486.821576] ---[ end trace 7abb318f298fe822 ]---
[  680.891145] perf: interrupt took too long (6232 > 6230), lowering
kernel.perf_event_max_sample_rate to 32000
[  893.466537] TCP: request_sock_TCP: Possible SYN flooding on port
19442. Sending cookies.  Check SNMP counters.
[ 1287.544609] perf: interrupt took too long (7809 > 7790), lowering
kernel.perf_event_max_sample_rate to 25500
[ 4440.364135] INFO: task kcompactd0:36 blocked for more than 120 seconds.
[ 4440.364287]       Tainted: G        W   E   4.6.0-trunk-amd64 #1
[ 4440.364412] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 4440.364570] kcompactd0      D ffffffff815c2f10     0    36      2
0x00000000
[ 4440.364585]  ffff88013a68c4c0 ffff88013abe6d40 ffff88013a698000
ffff88013a697bb8
[ 4440.364596]  7fffffffffffffff ffff88013ffd0138 ffff88013a697c50
ffffffff815c2f10
[ 4440.364606]  ffffffff815c2771 0000000000000000 ffffffff815c5632
7fffffffffffffff
[ 4440.364616] Call Trace:
[ 4440.364635]  [<ffffffff815c2f10>] ? bit_wait+0x60/0x60
[ 4440.364647]  [<ffffffff815c2771>] ? schedule+0x31/0x80
[ 4440.364657]  [<ffffffff815c5632>] ? schedule_timeout+0x1b2/0x270
[ 4440.364668]  [<ffffffff81179933>] ? free_hot_cold_page_list+0x43/0xa0
[ 4440.364678]  [<ffffffff81182202>] ? release_pages+0x272/0x350
[ 4440.364687]  [<ffffffff815c2f10>] ? bit_wait+0x60/0x60
[ 4440.364698]  [<ffffffff815c1dad>] ? io_schedule_timeout+0x9d/0x100
[ 4440.364710]  [<ffffffff810ba465>] ? prepare_to_wait_exclusive+0x55/0x80
[ 4440.364719]  [<ffffffff815c2f27>] ? bit_wait_io+0x17/0x60
[ 4440.364727]  [<ffffffff815c2cc7>] ? __wait_on_bit_lock+0x47/0xa0
[ 4440.364735]  [<ffffffff81170934>] ? __lock_page+0xc4/0xe0
[ 4440.364744]  [<ffffffff810ba840>] ? autoremove_wake_function+0x40/0x40
[ 4440.364753]  [<ffffffff811d8e0c>] ? migrate_pages+0x89c/0xa80
[ 4440.364763]  [<ffffffff8119b5e0>] ? isolate_freepages_block+0x3f0/0x3f0
[ 4440.364770]  [<ffffffff8119aee0>] ? update_pageblock_skip+0xb0/0xb0
[ 4440.364778]  [<ffffffff8119cf0f>] ? compact_zone+0x47f/0x840
[ 4440.364787]  [<ffffffff8119ca66>] ? compaction_suitable+0xf6/0x120
[ 4440.364795]  [<ffffffff8119d715>] ? kcompactd_do_work+0x1a5/0x2d0
[ 4440.364804]  [<ffffffff810b4d5d>] ? pick_next_task_fair+0x10d/0x4a0
[ 4440.364813]  [<ffffffff8119d8db>] ? kcompactd+0x9b/0x1c0
[ 4440.364822]  [<ffffffff810ba800>] ? wake_atomic_t_function+0x60/0x60
[ 4440.364830]  [<ffffffff8119d840>] ? kcompactd_do_work+0x2d0/0x2d0
[ 4440.364839]  [<ffffffff81098efd>] ? kthread+0xcd/0xf0
[ 4440.364849]  [<ffffffff815c6672>] ? ret_from_fork+0x22/0x40
[ 4440.364858]  [<ffffffff81098e30>] ? kthread_create_on_node+0x190/0x190
[ 4560.364059] INFO: task kcompactd0:36 blocked for more than 120 seconds.
[ 4560.364179]       Tainted: G        W   E   4.6.0-trunk-amd64 #1
[ 4560.364276] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 4560.364401] kcompactd0      D ffffffff815c2f10     0    36      2
0x00000000
[ 4560.364410]  ffff88013a68c4c0 ffff88013abe6d40 ffff88013a698000
ffff88013a697bb8
[ 4560.364417]  7fffffffffffffff ffff88013ffd0138 ffff88013a697c50
ffffffff815c2f10
[ 4560.364424]  ffffffff815c2771 0000000000000000 ffffffff815c5632
7fffffffffffffff
[ 4560.364430] Call Trace:
[ 4560.364444]  [<ffffffff815c2f10>] ? bit_wait+0x60/0x60
[ 4560.364451]  [<ffffffff815c2771>] ? schedule+0x31/0x80
[ 4560.364458]  [<ffffffff815c5632>] ? schedule_timeout+0x1b2/0x270
[ 4560.364465]  [<ffffffff81179933>] ? free_hot_cold_page_list+0x43/0xa0
[ 4560.364472]  [<ffffffff81182202>] ? release_pages+0x272/0x350
[ 4560.364477]  [<ffffffff815c2f10>] ? bit_wait+0x60/0x60
[ 4560.364484]  [<ffffffff815c1dad>] ? io_schedule_timeout+0x9d/0x100
[ 4560.364491]  [<ffffffff810ba465>] ? prepare_to_wait_exclusive+0x55/0x80
[ 4560.364497]  [<ffffffff815c2f27>] ? bit_wait_io+0x17/0x60
[ 4560.364503]  [<ffffffff815c2cc7>] ? __wait_on_bit_lock+0x47/0xa0
[ 4560.364510]  [<ffffffff81170934>] ? __lock_page+0xc4/0xe0
[ 4560.364516]  [<ffffffff810ba840>] ? autoremove_wake_function+0x40/0x40
[ 4560.364523]  [<ffffffff811d8e0c>] ? migrate_pages+0x89c/0xa80
[ 4560.364530]  [<ffffffff8119b5e0>] ? isolate_freepages_block+0x3f0/0x3f0
[ 4560.364535]  [<ffffffff8119aee0>] ? update_pageblock_skip+0xb0/0xb0
[ 4560.364541]  [<ffffffff8119cf0f>] ? compact_zone+0x47f/0x840
[ 4560.364547]  [<ffffffff8119ca66>] ? compaction_suitable+0xf6/0x120
[ 4560.364552]  [<ffffffff8119d715>] ? kcompactd_do_work+0x1a5/0x2d0
[ 4560.364558]  [<ffffffff810b4d5d>] ? pick_next_task_fair+0x10d/0x4a0
[ 4560.364565]  [<ffffffff8119d8db>] ? kcompactd+0x9b/0x1c0
[ 4560.364571]  [<ffffffff810ba800>] ? wake_atomic_t_function+0x60/0x60
[ 4560.364576]  [<ffffffff8119d840>] ? kcompactd_do_work+0x2d0/0x2d0
[ 4560.364583]  [<ffffffff81098efd>] ? kthread+0xcd/0xf0
[ 4560.364589]  [<ffffffff815c6672>] ? ret_from_fork+0x22/0x40
[ 4560.364595]  [<ffffffff81098e30>] ? kthread_create_on_node+0x190/0x190
[ 7440.364169] INFO: task mlnet:533 blocked for more than 120 seconds.
[ 7440.364315]       Tainted: G        W   E   4.6.0-trunk-amd64 #1
[ 7440.364439] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 7440.364599] mlnet           D ffff88013fc95bc0     0   533      1
0x00000000
[ 7440.364611]  ffff8800b86b6280 ffff88013a464dc0 ffff8801389dc000
ffff8801389dbbb8
[ 7440.364622]  7fffffffffffffff ffff88013ffcdac8 ffff8801389dbc50
ffffffff815c2f10
[ 7440.364632]  ffffffff815c2771 0000000000000000 ffffffff815c5632
7fffffffffffffff
[ 7440.364642] Call Trace:
[ 7440.364659]  [<ffffffff815c2f10>] ? bit_wait+0x60/0x60
[ 7440.364669]  [<ffffffff815c2771>] ? schedule+0x31/0x80
[ 7440.364679]  [<ffffffff815c5632>] ? schedule_timeout+0x1b2/0x270
[ 7440.364748]  [<ffffffffc033f01e>] ? btrfs_bio_counter_sub+0x1e/0x50
[btrfs]
[ 7440.364810]  [<ffffffffc02f941e>] ? btrfs_map_bio+0x20e/0x370 [btrfs]
[ 7440.364819]  [<ffffffff815c2f10>] ? bit_wait+0x60/0x60
[ 7440.364830]  [<ffffffff815c1dad>] ? io_schedule_timeout+0x9d/0x100
[ 7440.364841]  [<ffffffff810ba465>] ? prepare_to_wait_exclusive+0x55/0x80
[ 7440.364850]  [<ffffffff815c2f27>] ? bit_wait_io+0x17/0x60
[ 7440.364859]  [<ffffffff815c2cc7>] ? __wait_on_bit_lock+0x47/0xa0
[ 7440.364868]  [<ffffffff81170934>] ? __lock_page+0xc4/0xe0
[ 7440.364878]  [<ffffffff810ba840>] ? autoremove_wake_function+0x40/0x40
[ 7440.364937]  [<ffffffffc02de26a>] ? prepare_uptodate_page+0x9a/0xb0
[btrfs]
[ 7440.364997]  [<ffffffffc02de7a2>] ? prepare_pages+0x182/0x240 [btrfs]
[ 7440.365058]  [<ffffffffc02df037>] ?
__btrfs_buffered_write+0x267/0x660 [btrfs]
[ 7440.365119]  [<ffffffffc02e29ce>] ? btrfs_file_write_iter+0x17e/0x5f0
[btrfs]
[ 7440.365130]  [<ffffffff81201955>] ? do_filp_open+0xa5/0x100
[ 7440.365142]  [<ffffffff811f0a8a>] ? new_sync_write+0xaa/0xf0
[ 7440.365152]  [<ffffffff811f12f4>] ? vfs_write+0xa4/0x1a0
[ 7440.365161]  [<ffffffff811f26e2>] ? SyS_write+0x52/0xc0
[ 7440.365171]  [<ffffffff815c6436>] ? system_call_fast_compare_end+0xc/0x96
[ 7560.364106] INFO: task mlnet:533 blocked for more than 120 seconds.
[ 7560.364216]       Tainted: G        W   E   4.6.0-trunk-amd64 #1
[ 7560.364313] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 7560.364436] mlnet           D ffff88013fc95bc0     0   533      1
0x00000000
[ 7560.364445]  ffff8800b86b6280 ffff88013a464dc0 ffff8801389dc000
ffff8801389dbbb8
[ 7560.364453]  7fffffffffffffff ffff88013ffcdac8 ffff8801389dbc50
ffffffff815c2f10
[ 7560.364459]  ffffffff815c2771 0000000000000000 ffffffff815c5632
7fffffffffffffff
[ 7560.364465] Call Trace:
[ 7560.364478]  [<ffffffff815c2f10>] ? bit_wait+0x60/0x60
[ 7560.364485]  [<ffffffff815c2771>] ? schedule+0x31/0x80
[ 7560.364491]  [<ffffffff815c5632>] ? schedule_timeout+0x1b2/0x270
[ 7560.364547]  [<ffffffffc033f01e>] ? btrfs_bio_counter_sub+0x1e/0x50
[btrfs]
[ 7560.364595]  [<ffffffffc02f941e>] ? btrfs_map_bio+0x20e/0x370 [btrfs]
[ 7560.364601]  [<ffffffff815c2f10>] ? bit_wait+0x60/0x60
[ 7560.364607]  [<ffffffff815c1dad>] ? io_schedule_timeout+0x9d/0x100
[ 7560.364615]  [<ffffffff810ba465>] ? prepare_to_wait_exclusive+0x55/0x80
[ 7560.364620]  [<ffffffff815c2f27>] ? bit_wait_io+0x17/0x60
[ 7560.364626]  [<ffffffff815c2cc7>] ? __wait_on_bit_lock+0x47/0xa0
[ 7560.364633]  [<ffffffff81170934>] ? __lock_page+0xc4/0xe0
[ 7560.364640]  [<ffffffff810ba840>] ? autoremove_wake_function+0x40/0x40
[ 7560.364685]  [<ffffffffc02de26a>] ? prepare_uptodate_page+0x9a/0xb0
[btrfs]
[ 7560.364731]  [<ffffffffc02de7a2>] ? prepare_pages+0x182/0x240 [btrfs]
[ 7560.364778]  [<ffffffffc02df037>] ?
__btrfs_buffered_write+0x267/0x660 [btrfs]
[ 7560.364824]  [<ffffffffc02e29ce>] ? btrfs_file_write_iter+0x17e/0x5f0
[btrfs]
[ 7560.364831]  [<ffffffff81201955>] ? do_filp_open+0xa5/0x100
[ 7560.364839]  [<ffffffff811f0a8a>] ? new_sync_write+0xaa/0xf0
[ 7560.364845]  [<ffffffff811f12f4>] ? vfs_write+0xa4/0x1a0
[ 7560.364851]  [<ffffffff811f26e2>] ? SyS_write+0x52/0xc0
[ 7560.364857]  [<ffffffff815c6436>] ? system_call_fast_compare_end+0xc/0x96
[ 7680.364139] INFO: task mlnet:533 blocked for more than 120 seconds.
[ 7680.364276]       Tainted: G        W   E   4.6.0-trunk-amd64 #1
[ 7680.364400] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 7680.364558] mlnet           D ffff88013fc95bc0     0   533      1
0x00000000
[ 7680.364572]  ffff8800b86b6280 ffff88013a464dc0 ffff8801389dc000
ffff8801389dbbb8
[ 7680.364583]  7fffffffffffffff ffff88013ffcdac8 ffff8801389dbc50
ffffffff815c2f10
[ 7680.364593]  ffffffff815c2771 0000000000000000 ffffffff815c5632
7fffffffffffffff
[ 7680.364601] Call Trace:
[ 7680.364616]  [<ffffffff815c2f10>] ? bit_wait+0x60/0x60
[ 7680.364626]  [<ffffffff815c2771>] ? schedule+0x31/0x80
[ 7680.364636]  [<ffffffff815c5632>] ? schedule_timeout+0x1b2/0x270
[ 7680.364705]  [<ffffffffc033f01e>] ? btrfs_bio_counter_sub+0x1e/0x50
[btrfs]
[ 7680.364766]  [<ffffffffc02f941e>] ? btrfs_map_bio+0x20e/0x370 [btrfs]
[ 7680.364776]  [<ffffffff815c2f10>] ? bit_wait+0x60/0x60
[ 7680.364787]  [<ffffffff815c1dad>] ? io_schedule_timeout+0x9d/0x100
[ 7680.364798]  [<ffffffff810ba465>] ? prepare_to_wait_exclusive+0x55/0x80
[ 7680.364807]  [<ffffffff815c2f27>] ? bit_wait_io+0x17/0x60
[ 7680.364817]  [<ffffffff815c2cc7>] ? __wait_on_bit_lock+0x47/0xa0
[ 7680.364827]  [<ffffffff81170934>] ? __lock_page+0xc4/0xe0
[ 7680.364838]  [<ffffffff810ba840>] ? autoremove_wake_function+0x40/0x40
[ 7680.364897]  [<ffffffffc02de26a>] ? prepare_uptodate_page+0x9a/0xb0
[btrfs]
[ 7680.364956]  [<ffffffffc02de7a2>] ? prepare_pages+0x182/0x240 [btrfs]
[ 7680.365017]  [<ffffffffc02df037>] ?
__btrfs_buffered_write+0x267/0x660 [btrfs]
[ 7680.365077]  [<ffffffffc02e29ce>] ? btrfs_file_write_iter+0x17e/0x5f0
[btrfs]
[ 7680.365088]  [<ffffffff81201955>] ? do_filp_open+0xa5/0x100
[ 7680.365099]  [<ffffffff811f0a8a>] ? new_sync_write+0xaa/0xf0
[ 7680.365110]  [<ffffffff811f12f4>] ? vfs_write+0xa4/0x1a0
[ 7680.365118]  [<ffffffff811f26e2>] ? SyS_write+0x52/0xc0
[ 7680.365126]  [<ffffffff815c6436>] ? system_call_fast_compare_end+0xc/0x96
[ 7800.364124] INFO: task mlnet:533 blocked for more than 120 seconds.
[ 7800.364234]       Tainted: G        W   E   4.6.0-trunk-amd64 #1
[ 7800.364331] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 7800.364455] mlnet           D ffff88013fc95bc0     0   533      1
0x00000000
[ 7800.364464]  ffff8800b86b6280 ffff88013a464dc0 ffff8801389dc000
ffff8801389dbbb8
[ 7800.364472]  7fffffffffffffff ffff88013ffcdac8 ffff8801389dbc50
ffffffff815c2f10
[ 7800.364478]  ffffffff815c2771 0000000000000000 ffffffff815c5632
7fffffffffffffff
[ 7800.364485] Call Trace:
[ 7800.364497]  [<ffffffff815c2f10>] ? bit_wait+0x60/0x60
[ 7800.364504]  [<ffffffff815c2771>] ? schedule+0x31/0x80
[ 7800.364511]  [<ffffffff815c5632>] ? schedule_timeout+0x1b2/0x270
[ 7800.364567]  [<ffffffffc033f01e>] ? btrfs_bio_counter_sub+0x1e/0x50
[btrfs]
[ 7800.364614]  [<ffffffffc02f941e>] ? btrfs_map_bio+0x20e/0x370 [btrfs]
[ 7800.364620]  [<ffffffff815c2f10>] ? bit_wait+0x60/0x60
[ 7800.364627]  [<ffffffff815c1dad>] ? io_schedule_timeout+0x9d/0x100
[ 7800.364635]  [<ffffffff810ba465>] ? prepare_to_wait_exclusive+0x55/0x80
[ 7800.364640]  [<ffffffff815c2f27>] ? bit_wait_io+0x17/0x60
[ 7800.364646]  [<ffffffff815c2cc7>] ? __wait_on_bit_lock+0x47/0xa0
[ 7800.364653]  [<ffffffff81170934>] ? __lock_page+0xc4/0xe0
[ 7800.364659]  [<ffffffff810ba840>] ? autoremove_wake_function+0x40/0x40
[ 7800.364705]  [<ffffffffc02de26a>] ? prepare_uptodate_page+0x9a/0xb0
[btrfs]
[ 7800.364751]  [<ffffffffc02de7a2>] ? prepare_pages+0x182/0x240 [btrfs]
[ 7800.364798]  [<ffffffffc02df037>] ?
__btrfs_buffered_write+0x267/0x660 [btrfs]
[ 7800.364844]  [<ffffffffc02e29ce>] ? btrfs_file_write_iter+0x17e/0x5f0
[btrfs]
[ 7800.364851]  [<ffffffff81201955>] ? do_filp_open+0xa5/0x100
[ 7800.364859]  [<ffffffff811f0a8a>] ? new_sync_write+0xaa/0xf0
[ 7800.364866]  [<ffffffff811f12f4>] ? vfs_write+0xa4/0x1a0
[ 7800.364871]  [<ffffffff811f26e2>] ? SyS_write+0x52/0xc0
[ 7800.364877]  [<ffffffff815c6436>] ? system_call_fast_compare_end+0xc/0x96
[ 7920.364206] INFO: task mlnet:533 blocked for more than 120 seconds.
[ 7920.364350]       Tainted: G        W   E   4.6.0-trunk-amd64 #1
[ 7920.364466] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 7920.364620] mlnet           D ffff88013fc95bc0     0   533      1
0x00000000
[ 7920.364634]  ffff8800b86b6280 ffff88013a464dc0 ffff8801389dc000
ffff8801389dbbb8
[ 7920.364645]  7fffffffffffffff ffff88013ffcdac8 ffff8801389dbc50
ffffffff815c2f10
[ 7920.364655]  ffffffff815c2771 0000000000000000 ffffffff815c5632
7fffffffffffffff
[ 7920.364665] Call Trace:
[ 7920.364682]  [<ffffffff815c2f10>] ? bit_wait+0x60/0x60
[ 7920.364692]  [<ffffffff815c2771>] ? schedule+0x31/0x80
[ 7920.364702]  [<ffffffff815c5632>] ? schedule_timeout+0x1b2/0x270
[ 7920.364771]  [<ffffffffc033f01e>] ? btrfs_bio_counter_sub+0x1e/0x50
[btrfs]
[ 7920.364832]  [<ffffffffc02f941e>] ? btrfs_map_bio+0x20e/0x370 [btrfs]
[ 7920.364841]  [<ffffffff815c2f10>] ? bit_wait+0x60/0x60
[ 7920.364851]  [<ffffffff815c1dad>] ? io_schedule_timeout+0x9d/0x100
[ 7920.364863]  [<ffffffff810ba465>] ? prepare_to_wait_exclusive+0x55/0x80
[ 7920.364871]  [<ffffffff815c2f27>] ? bit_wait_io+0x17/0x60
[ 7920.364881]  [<ffffffff815c2cc7>] ? __wait_on_bit_lock+0x47/0xa0
[ 7920.364890]  [<ffffffff81170934>] ? __lock_page+0xc4/0xe0
[ 7920.364898]  [<ffffffff810ba840>] ? autoremove_wake_function+0x40/0x40
[ 7920.364956]  [<ffffffffc02de26a>] ? prepare_uptodate_page+0x9a/0xb0
[btrfs]
[ 7920.365015]  [<ffffffffc02de7a2>] ? prepare_pages+0x182/0x240 [btrfs]
[ 7920.365074]  [<ffffffffc02df037>] ?
__btrfs_buffered_write+0x267/0x660 [btrfs]
[ 7920.365136]  [<ffffffffc02e29ce>] ? btrfs_file_write_iter+0x17e/0x5f0
[btrfs]
[ 7920.365146]  [<ffffffff81201955>] ? do_filp_open+0xa5/0x100
[ 7920.365158]  [<ffffffff811f0a8a>] ? new_sync_write+0xaa/0xf0
[ 7920.365167]  [<ffffffff811f12f4>] ? vfs_write+0xa4/0x1a0
[ 7920.365174]  [<ffffffff811f26e2>] ? SyS_write+0x52/0xc0
[ 7920.365184]  [<ffffffff815c6436>] ? system_call_fast_compare_end+0xc/0x96
[ 8760.364190] INFO: task mlnet:533 blocked for more than 120 seconds.
[ 8760.364334]       Tainted: G        W   E   4.6.0-trunk-amd64 #1
[ 8760.364456] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 8760.364613] mlnet           D 0000000000000000     0   533      1
0x00000000
[ 8760.364626]  ffff8800b86b6280 ffff880036738f00 ffff8801389dc000
ffff8801389db450
[ 8760.364637]  7fffffffffffffff ffffffff815c2f10 ffff8801389db4d0
0000000000000000
[ 8760.364647]  ffffffff815c2771 0000000000000000 ffffffff815c5632
7fffffffffffffff
[ 8760.364655] Call Trace:
[ 8760.364670]  [<ffffffff815c2f10>] ? bit_wait+0x60/0x60
[ 8760.364681]  [<ffffffff815c2771>] ? schedule+0x31/0x80
[ 8760.364691]  [<ffffffff815c5632>] ? schedule_timeout+0x1b2/0x270
[ 8760.364702]  [<ffffffff812dfe18>] ? queue_unplugged+0x98/0xa0
[ 8760.364711]  [<ffffffff815c2f10>] ? bit_wait+0x60/0x60
[ 8760.364721]  [<ffffffff815c1dad>] ? io_schedule_timeout+0x9d/0x100
[ 8760.364731]  [<ffffffff810ba3a5>] ? prepare_to_wait+0x55/0x80
[ 8760.364740]  [<ffffffff815c2f27>] ? bit_wait_io+0x17/0x60
[ 8760.364749]  [<ffffffff815c2ae8>] ? __wait_on_bit+0x58/0x90
[ 8760.364815]  [<ffffffffc02c1b50>] ? free_root_pointers+0x60/0x60 [btrfs]
[ 8760.364826]  [<ffffffff81170528>] ? wait_on_page_bit+0xc8/0xf0
[ 8760.364836]  [<ffffffff810ba840>] ? autoremove_wake_function+0x40/0x40
[ 8760.364897]  [<ffffffffc02f0113>] ?
read_extent_buffer_pages+0x233/0x350 [btrfs]
[ 8760.364953]  [<ffffffffc02c1b50>] ? free_root_pointers+0x60/0x60 [btrfs]
[ 8760.365010]  [<ffffffffc02c2ea1>] ?
btree_read_extent_buffer_pages.constprop.53+0xa1/0x100 [btrfs]
[ 8760.365068]  [<ffffffffc02c3a28>] ? read_tree_block+0x38/0x60 [btrfs]
[ 8760.365123]  [<ffffffffc02a2bd8>] ?
read_block_for_search.isra.34+0x138/0x340 [btrfs]
[ 8760.365179]  [<ffffffffc02a4e24>] ? btrfs_search_slot+0x394/0x9f0 [btrfs]
[ 8760.365237]  [<ffffffffc02bdf8e>] ? btrfs_lookup_csum+0x4e/0x150 [btrfs]
[ 8760.365294]  [<ffffffffc02be2b6>] ?
__btrfs_lookup_bio_sums.isra.8+0x226/0x560 [btrfs]
[ 8760.365352]  [<ffffffffc02be8a2>] ? btrfs_lookup_bio_sums+0x32/0x40
[btrfs]
[ 8760.365413]  [<ffffffffc031666f>] ?
btrfs_submit_compressed_read+0x2df/0x4a0 [btrfs]
[ 8760.365473]  [<ffffffffc02cd5e8>] ? btrfs_submit_bio_hook+0x188/0x190
[btrfs]
[ 8760.365534]  [<ffffffffc02e8168>] ? submit_one_bio+0x68/0x90 [btrfs]
[ 8760.365595]  [<ffffffffc02ecb9f>] ? submit_extent_page+0x12f/0x270
[btrfs]
[ 8760.365656]  [<ffffffffc02ec2d0>] ?
btrfs_create_repair_bio+0x100/0x100 [btrfs]
[ 8760.365717]  [<ffffffffc02edeb2>] ? __do_readpage+0x3e2/0x910 [btrfs]
[ 8760.365777]  [<ffffffffc02ec2d0>] ?
btrfs_create_repair_bio+0x100/0x100 [btrfs]
[ 8760.365837]  [<ffffffffc02d0770>] ? btrfs_releasepage+0x40/0x40 [btrfs]
[ 8760.365898]  [<ffffffffc02e78d8>] ?
btrfs_lookup_ordered_range+0x148/0x190 [btrfs]
[ 8760.365959]  [<ffffffffc02ee6b0>] ?
__extent_readpages.constprop.45+0x1d0/0x380 [btrfs]
[ 8760.366018]  [<ffffffffc02d0770>] ? btrfs_releasepage+0x40/0x40 [btrfs]
[ 8760.366080]  [<ffffffffc02eee7a>] ? extent_readpages+0x1da/0x1f0 [btrfs]
[ 8760.366139]  [<ffffffffc02d0770>] ? btrfs_releasepage+0x40/0x40 [btrfs]
[ 8760.366152]  [<ffffffff811c8a24>] ? alloc_pages_current+0x84/0x110
[ 8760.366164]  [<ffffffff8118062d>] ? __do_page_cache_readahead+0x19d/0x250
[ 8760.366174]  [<ffffffff81171d67>] ? pagecache_get_page+0x27/0x2b0
[ 8760.366182]  [<ffffffff81173f91>] ? filemap_fault+0x281/0x590
[ 8760.366191]  [<ffffffff811a24c4>] ? __do_fault+0x74/0x160
[ 8760.366201]  [<ffffffff811a630a>] ? handle_mm_fault+0x117a/0x1d00
[ 8760.366211]  [<ffffffff814ab17a>] ? SYSC_recvfrom+0x11a/0x130
[ 8760.366224]  [<ffffffff810648b5>] ? __do_page_fault+0x1e5/0x500
[ 8760.366235]  [<ffffffff815c8478>] ? page_fault+0x28/0x30
[ 9840.368112] INFO: task mlnet:533 blocked for more than 120 seconds.
[ 9840.368228]       Tainted: G        W   E   4.6.0-trunk-amd64 #1
[ 9840.368325] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 9840.368449] mlnet           D 0000000000000000     0   533      1
0x00000000
[ 9840.368458]  ffff8800b86b6280 ffff88003659e1c0 ffff8801389dc000
ffff8801389db730
[ 9840.368466]  7fffffffffffffff ffffffff815c2f10 ffff8801389db7b0
0000000000000000
[ 9840.368472]  ffffffff815c2771 0000000000000000 ffffffff815c5632
7fffffffffffffff
[ 9840.368479] Call Trace:
[ 9840.368491]  [<ffffffff815c2f10>] ? bit_wait+0x60/0x60
[ 9840.368498]  [<ffffffff815c2771>] ? schedule+0x31/0x80
[ 9840.368504]  [<ffffffff815c5632>] ? schedule_timeout+0x1b2/0x270
[ 9840.368511]  [<ffffffff812dfe18>] ? queue_unplugged+0x98/0xa0
[ 9840.368517]  [<ffffffff815c2f10>] ? bit_wait+0x60/0x60
[ 9840.368523]  [<ffffffff815c1dad>] ? io_schedule_timeout+0x9d/0x100
[ 9840.368531]  [<ffffffff810ba3a5>] ? prepare_to_wait+0x55/0x80
[ 9840.368536]  [<ffffffff815c2f27>] ? bit_wait_io+0x17/0x60
[ 9840.368542]  [<ffffffff815c2ae8>] ? __wait_on_bit+0x58/0x90
[ 9840.368593]  [<ffffffffc02c1b50>] ? free_root_pointers+0x60/0x60 [btrfs]
[ 9840.368600]  [<ffffffff81170528>] ? wait_on_page_bit+0xc8/0xf0
[ 9840.368607]  [<ffffffff810ba840>] ? autoremove_wake_function+0x40/0x40
[ 9840.368654]  [<ffffffffc02f0113>] ?
read_extent_buffer_pages+0x233/0x350 [btrfs]
[ 9840.368698]  [<ffffffffc02c1b50>] ? free_root_pointers+0x60/0x60 [btrfs]
[ 9840.368742]  [<ffffffffc02c2ea1>] ?
btree_read_extent_buffer_pages.constprop.53+0xa1/0x100 [btrfs]
[ 9840.368786]  [<ffffffffc02c3a28>] ? read_tree_block+0x38/0x60 [btrfs]
[ 9840.368827]  [<ffffffffc02a2bd8>] ?
read_block_for_search.isra.34+0x138/0x340 [btrfs]
[ 9840.368869]  [<ffffffffc02a4e24>] ? btrfs_search_slot+0x394/0x9f0 [btrfs]
[ 9840.368912]  [<ffffffffc02bdf8e>] ? btrfs_lookup_csum+0x4e/0x150 [btrfs]
[ 9840.368955]  [<ffffffffc02be2b6>] ?
__btrfs_lookup_bio_sums.isra.8+0x226/0x560 [btrfs]
[ 9840.368999]  [<ffffffffc02be8a2>] ? btrfs_lookup_bio_sums+0x32/0x40
[btrfs]
[ 9840.369044]  [<ffffffffc02cd586>] ? btrfs_submit_bio_hook+0x126/0x190
[btrfs]
[ 9840.369091]  [<ffffffffc02e8168>] ? submit_one_bio+0x68/0x90 [btrfs]
[ 9840.369138]  [<ffffffffc02eedd4>] ? extent_readpages+0x134/0x1f0 [btrfs]
[ 9840.369184]  [<ffffffffc02d0770>] ? btrfs_releasepage+0x40/0x40 [btrfs]
[ 9840.369192]  [<ffffffff811c8a24>] ? alloc_pages_current+0x84/0x110
[ 9840.369198]  [<ffffffff8118062d>] ? __do_page_cache_readahead+0x19d/0x250
[ 9840.369205]  [<ffffffff81180920>] ? ondemand_readahead+0x240/0x250
[ 9840.369211]  [<ffffffff811739fd>] ? generic_file_read_iter+0x58d/0x7d0
[ 9840.369219]  [<ffffffff811f08a3>] ? new_sync_read+0xa3/0xe0
[ 9840.369226]  [<ffffffff811f11b1>] ? vfs_read+0x81/0x120
[ 9840.369231]  [<ffffffff811f2622>] ? SyS_read+0x52/0xc0
[ 9840.369237]  [<ffffffff815c6436>] ? system_call_fast_compare_end+0xc/0x96
[ 9960.368169] INFO: task mlnet:533 blocked for more than 120 seconds.
[ 9960.368287]       Tainted: G        W   E   4.6.0-trunk-amd64 #1
[ 9960.368385] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 9960.368510] mlnet           D 0000000000000000     0   533      1
0x00000000
[ 9960.368519]  ffff8800b86b6280 ffff88003659e1c0 ffff8801389dc000
ffff8801389db730
[ 9960.368526]  7fffffffffffffff ffffffff815c2f10 ffff8801389db7b0
0000000000000000
[ 9960.368533]  ffffffff815c2771 0000000000000000 ffffffff815c5632
7fffffffffffffff
[ 9960.368539] Call Trace:
[ 9960.368553]  [<ffffffff815c2f10>] ? bit_wait+0x60/0x60
[ 9960.368561]  [<ffffffff815c2771>] ? schedule+0x31/0x80
[ 9960.368567]  [<ffffffff815c5632>] ? schedule_timeout+0x1b2/0x270
[ 9960.368575]  [<ffffffff812dfe18>] ? queue_unplugged+0x98/0xa0
[ 9960.368581]  [<ffffffff815c2f10>] ? bit_wait+0x60/0x60
[ 9960.368587]  [<ffffffff815c1dad>] ? io_schedule_timeout+0x9d/0x100
[ 9960.368596]  [<ffffffff810ba3a5>] ? prepare_to_wait+0x55/0x80
[ 9960.368601]  [<ffffffff815c2f27>] ? bit_wait_io+0x17/0x60
[ 9960.368607]  [<ffffffff815c2ae8>] ? __wait_on_bit+0x58/0x90
[ 9960.368671]  [<ffffffffc02c1b50>] ? free_root_pointers+0x60/0x60 [btrfs]
[ 9960.368679]  [<ffffffff81170528>] ? wait_on_page_bit+0xc8/0xf0
[ 9960.368686]  [<ffffffff810ba840>] ? autoremove_wake_function+0x40/0x40
[ 9960.368735]  [<ffffffffc02f0113>] ?
read_extent_buffer_pages+0x233/0x350 [btrfs]
[ 9960.368779]  [<ffffffffc02c1b50>] ? free_root_pointers+0x60/0x60 [btrfs]
[ 9960.368823]  [<ffffffffc02c2ea1>] ?
btree_read_extent_buffer_pages.constprop.53+0xa1/0x100 [btrfs]
[ 9960.368869]  [<ffffffffc02c3a28>] ? read_tree_block+0x38/0x60 [btrfs]
[ 9960.368911]  [<ffffffffc02a2bd8>] ?
read_block_for_search.isra.34+0x138/0x340 [btrfs]
[ 9960.368954]  [<ffffffffc02a4e24>] ? btrfs_search_slot+0x394/0x9f0 [btrfs]
[ 9960.368998]  [<ffffffffc02bdf8e>] ? btrfs_lookup_csum+0x4e/0x150 [btrfs]
[ 9960.369042]  [<ffffffffc02be2b6>] ?
__btrfs_lookup_bio_sums.isra.8+0x226/0x560 [btrfs]
[ 9960.369086]  [<ffffffffc02be8a2>] ? btrfs_lookup_bio_sums+0x32/0x40
[btrfs]
[ 9960.369131]  [<ffffffffc02cd586>] ? btrfs_submit_bio_hook+0x126/0x190
[btrfs]
[ 9960.369179]  [<ffffffffc02e8168>] ? submit_one_bio+0x68/0x90 [btrfs]
[ 9960.369227]  [<ffffffffc02eedd4>] ? extent_readpages+0x134/0x1f0 [btrfs]
[ 9960.369273]  [<ffffffffc02d0770>] ? btrfs_releasepage+0x40/0x40 [btrfs]
[ 9960.369281]  [<ffffffff811c8a24>] ? alloc_pages_current+0x84/0x110
[ 9960.369289]  [<ffffffff8118062d>] ? __do_page_cache_readahead+0x19d/0x250
[ 9960.369295]  [<ffffffff81180920>] ? ondemand_readahead+0x240/0x250
[ 9960.369302]  [<ffffffff811739fd>] ? generic_file_read_iter+0x58d/0x7d0
[ 9960.369310]  [<ffffffff811f08a3>] ? new_sync_read+0xa3/0xe0
[ 9960.369316]  [<ffffffff811f11b1>] ? vfs_read+0x81/0x120
[ 9960.369322]  [<ffffffff811f2622>] ? SyS_read+0x52/0xc0
[ 9960.369329]  [<ffffffff815c6436>] ? system_call_fast_compare_end+0xc/0x96
[24689.971809] ------------[ cut here ]------------
[24689.971875] WARNING: CPU: 0 PID: 48 at
/build/linux-_jiRqf/linux-4.6/fs/btrfs/inode.c:9261
btrfs_destroy_inode+0x234/0x2a0 [btrfs]
[24689.971878] Modules linked in: nfsd(E) auth_rpcgss(E) nfs_acl(E)
lockd(E) grace(E) sunrpc(E) ppdev(E) iTCO_wdt(E) iTCO_vendor_support(E)
i915(E) video(E) coretemp(E) drm_kms_helper(E) serio_raw(E) i2c_i801(E)
pcspkr(E) sg(E) evdev(E) drm(E) parport_pc(E) 8250_fintek(E)
acpi_cpufreq(E) i2c_algo_bit(E) parport(E) lpc_ich(E) tpm_tis(E) tpm(E)
shpchp(E) mfd_core(E) button(E) processor(E) autofs4(E) btrfs(E)
crc32c_generic(E) xor(E) raid6_pq(E) hid_generic(E) usbhid(E) hid(E)
sd_mod(E) ata_generic(E) psmouse(E) ahci(E) libahci(E) pata_jmicron(E)
uhci_hcd(E) ehci_pci(E) ehci_hcd(E) libata(E) usbcore(E) usb_common(E)
scsi_mod(E) r8169(E) mii(E) fjes(E)
[24689.971961] CPU: 0 PID: 48 Comm: kswapd0 Tainted: G        W   E  
4.6.0-trunk-amd64 #1 Debian 4.6-1~exp1
[24689.971965] Hardware name: Gigabyte Technology Co., Ltd.
D525TUD/D525TUD, BIOS F5 06/20/2011
[24689.971970]  0000000000000286 00000000d50a7872 ffffffff81311345
0000000000000000
[24689.971978]  0000000000000000 ffffffff8107a50e ffff8801104956d8
ffff8801104955c8
[24689.971985]  ffff880036865000 ffff8800365e5000 0000000000000000
0000000000000000
[24689.971991] Call Trace:
[24689.972003]  [<ffffffff81311345>] ? dump_stack+0x5c/0x77
[24689.972011]  [<ffffffff8107a50e>] ? __warn+0xbe/0xe0
[24689.972014]  [<ffffffffc02dcd34>] ? btrfs_destroy_inode+0x234/0x2a0
[btrfs]
[24689.972014]  [<ffffffff8120c696>] ? dispose_list+0x36/0x50
[24689.972014]  [<ffffffff8120d732>] ? prune_icache_sb+0x52/0x70
[24689.972014]  [<ffffffff811f4a6b>] ? super_cache_scan+0x13b/0x190
[24689.972014]  [<ffffffff81185926>] ? shrink_slab.part.39+0x1e6/0x3d0
[24689.972014]  [<ffffffff81189f53>] ? shrink_zone+0x303/0x310
[24689.972014]  [<ffffffff8118afce>] ? kswapd+0x4fe/0x850
[24689.972014]  [<ffffffff8118aad0>] ?
mem_cgroup_shrink_node_zone+0x170/0x170
[24689.972014]  [<ffffffff81098efd>] ? kthread+0xcd/0xf0
[24689.972014]  [<ffffffff815c6672>] ? ret_from_fork+0x22/0x40
[24689.972014]  [<ffffffff81098e30>] ? kthread_create_on_node+0x190/0x190
[24689.972193] ---[ end trace 7abb318f298fe823 ]---

