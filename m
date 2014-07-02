Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:51977 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbaGBUlx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Jul 2014 16:41:53 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.80 #2)
	id 1X2RLk-0007j2-Qv
	for <linux-btrfs@vger.kernel.org>; Wed, 02 Jul 2014 13:41:52 -0700
Date: Wed, 2 Jul 2014 13:41:52 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: 3.15.1: kernel BUG at fs/btrfs/locking.c:269
Message-ID: <20140702204152.GI20961@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This got triggered by an rsync I think. I'm not sure which of my btrfs FS
has the issue yet since BUG_ON isn't very helpful as discussed earlier.

[160562.925463] parent transid verify failed on 2776298520576 wanted 41015 found 18120
[160562.950297] ------------[ cut here ]------------
[160562.965904] kernel BUG at fs/btrfs/locking.c:269!

But shouldn't messages like 'parent transid verify failed' print which device 
this happened on to give the operator a hint on where the problem is?

Could someone do a pass at those and make sure they all print the device
ID/name?

Bug below:

Full log before the crash:
INFO: task btrfs-transacti:3358 blocked for more than 120 seconds.
      Not tainted 3.15.1-amd64-i915-preempt-20140216jbp #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
btrfs-transacti D 0000000000000000     0  3358      2 0x00000000
 ffff8800c50ebc50 0000000000000046 ffff8800c50ebc20 ffff8800c50ebfd8
 ffff8800c6914390 00000000000141c0 7fffffffffffffff ffff8801433b8f10
 0000000000000002 ffffffff8161c9b0 7fffffffffffffff ffff8800c50ebc60
Call Trace:
 [<ffffffff8161c9b0>] ? sock_rps_reset_flow+0x32/0x32
 [<ffffffff8161d3c6>] schedule+0x73/0x75
 [<ffffffff8161c9e9>] schedule_timeout+0x39/0x129
 [<ffffffff8107653d>] ? get_parent_ip+0xd/0x3c
 [<ffffffff8162338f>] ? preempt_count_add+0x7a/0x8d
 [<ffffffff8161dbac>] __wait_for_common+0x11a/0x159
 [<ffffffff8107810f>] ? wake_up_state+0x12/0x12
 [<ffffffff8161dc0f>] wait_for_completion+0x24/0x26
 [<ffffffff81237ce6>] btrfs_wait_and_free_delalloc_work+0x16/0x28
 [<ffffffff8123fd3a>] btrfs_run_ordered_operations+0x1e7/0x21e
 [<ffffffff81229aa4>] btrfs_flush_all_pending_stuffs+0x4e/0x55
 [<ffffffff8122b25a>] btrfs_commit_transaction+0x20d/0x8b0
 [<ffffffff81227b41>] transaction_kthread+0xf8/0x1ab
 [<ffffffff81227a49>] ? btrfs_cleanup_transaction+0x44c/0x44c
 [<ffffffff8106b4b4>] kthread+0xae/0xb6
 [<ffffffff8106b406>] ? __kthread_parkme+0x61/0x61
 [<ffffffff8162667c>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106b406>] ? __kthread_parkme+0x61/0x61
INFO: task kworker/u8:13:13157 blocked for more than 120 seconds.
      Not tainted 3.15.1-amd64-i915-preempt-20140216jbp #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/u8:13   D 0000000000000000     0 13157      2 0x00000080
Workqueue: btrfs-flush_delalloc normal_work_helper
 ffff8800041cfc00 0000000000000046 ffff8800041cfbd0 ffff8800041cffd8
 ffff8800034f40d0 00000000000141c0 ffff88021f2941c0 ffff8800034f40d0
 ffff8800041cfca0 ffffffff810fdc2f 0000000000000002 ffff8800041cfc10
Call Trace:
 [<ffffffff810fdc2f>] ? wait_on_page_read+0x3c/0x3c
 [<ffffffff8161d3c6>] schedule+0x73/0x75
 [<ffffffff8161d56b>] io_schedule+0x60/0x7a
 [<ffffffff810fdc3d>] sleep_on_page+0xe/0x12
 [<ffffffff8161d7fd>] __wait_on_bit+0x48/0x7a
 [<ffffffff810fdbdd>] wait_on_page_bit+0x7a/0x7c
 [<ffffffff81084821>] ? autoremove_wake_function+0x34/0x34
 [<ffffffff810fef03>] filemap_fdatawait_range+0x7e/0x126
 [<ffffffff8122f1cf>] ? btrfs_submit_direct+0x3f4/0x3f4
 [<ffffffff8122d7aa>] ? btrfs_writepages+0x28/0x2a
 [<ffffffff811084c6>] ? do_writepages+0x1e/0x2c
 [<ffffffff810ff38e>] ? __filemap_fdatawrite_range+0x55/0x57
 [<ffffffff8124006f>] btrfs_wait_ordered_range+0x6a/0x11a
 [<ffffffff8122fe01>] btrfs_run_delalloc_work+0x27/0x69
 [<ffffffff812508db>] normal_work_helper+0xfe/0x240
 [<ffffffff81065d7e>] process_one_work+0x195/0x2d2
 [<ffffffff81066020>] worker_thread+0x136/0x205
 [<ffffffff81065eea>] ? process_scheduled_works+0x2f/0x2f
 [<ffffffff8106b4b4>] kthread+0xae/0xb6
 [<ffffffff8106b406>] ? __kthread_parkme+0x61/0x61
 [<ffffffff8162667c>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106b406>] ? __kthread_parkme+0x61/0x61
INFO: task btrfs-transacti:3358 blocked for more than 120 seconds.
      Not tainted 3.15.1-amd64-i915-preempt-20140216jbp #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
btrfs-transacti D 0000000000000000     0  3358      2 0x00000000
 ffff8800c50ebc50 0000000000000046 ffff8800c50ebc20 ffff8800c50ebfd8
 ffff8800c6914390 00000000000141c0 7fffffffffffffff ffff8801433b8f10
 0000000000000002 ffffffff8161c9b0 7fffffffffffffff ffff8800c50ebc60
Call Trace:
 [<ffffffff8161c9b0>] ? sock_rps_reset_flow+0x32/0x32
 [<ffffffff8161d3c6>] schedule+0x73/0x75
 [<ffffffff8161c9e9>] schedule_timeout+0x39/0x129
 [<ffffffff8107653d>] ? get_parent_ip+0xd/0x3c
 [<ffffffff8162338f>] ? preempt_count_add+0x7a/0x8d
 [<ffffffff8161dbac>] __wait_for_common+0x11a/0x159
 [<ffffffff8107810f>] ? wake_up_state+0x12/0x12
 [<ffffffff8161dc0f>] wait_for_completion+0x24/0x26
 [<ffffffff81237ce6>] btrfs_wait_and_free_delalloc_work+0x16/0x28
 [<ffffffff8123fd3a>] btrfs_run_ordered_operations+0x1e7/0x21e
 [<ffffffff81229aa4>] btrfs_flush_all_pending_stuffs+0x4e/0x55
 [<ffffffff8122b25a>] btrfs_commit_transaction+0x20d/0x8b0
 [<ffffffff81227b41>] transaction_kthread+0xf8/0x1ab
 [<ffffffff81227a49>] ? btrfs_cleanup_transaction+0x44c/0x44c
 [<ffffffff8106b4b4>] kthread+0xae/0xb6
 [<ffffffff8106b406>] ? __kthread_parkme+0x61/0x61
 [<ffffffff8162667c>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106b406>] ? __kthread_parkme+0x61/0x61
INFO: task kworker/u8:13:13157 blocked for more than 120 seconds.
      Not tainted 3.15.1-amd64-i915-preempt-20140216jbp #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/u8:13   D 0000000000000000     0 13157      2 0x00000080
Workqueue: btrfs-flush_delalloc normal_work_helper
 ffff8800041cfc00 0000000000000046 ffff8800041cfbd0 ffff8800041cffd8
 ffff8800034f40d0 00000000000141c0 ffff88021f2941c0 ffff8800034f40d0
 ffff8800041cfca0 ffffffff810fdc2f 0000000000000002 ffff8800041cfc10
Call Trace:
 [<ffffffff810fdc2f>] ? wait_on_page_read+0x3c/0x3c
 [<ffffffff8161d3c6>] schedule+0x73/0x75
 [<ffffffff8161d56b>] io_schedule+0x60/0x7a
 [<ffffffff810fdc3d>] sleep_on_page+0xe/0x12
 [<ffffffff8161d7fd>] __wait_on_bit+0x48/0x7a
 [<ffffffff810fdbdd>] wait_on_page_bit+0x7a/0x7c
 [<ffffffff81084821>] ? autoremove_wake_function+0x34/0x34
 [<ffffffff810fef03>] filemap_fdatawait_range+0x7e/0x126
 [<ffffffff8122f1cf>] ? btrfs_submit_direct+0x3f4/0x3f4
 [<ffffffff8122d7aa>] ? btrfs_writepages+0x28/0x2a
 [<ffffffff811084c6>] ? do_writepages+0x1e/0x2c
 [<ffffffff810ff38e>] ? __filemap_fdatawrite_range+0x55/0x57
 [<ffffffff8124006f>] btrfs_wait_ordered_range+0x6a/0x11a
 [<ffffffff8122fe01>] btrfs_run_delalloc_work+0x27/0x69
 [<ffffffff812508db>] normal_work_helper+0xfe/0x240
 [<ffffffff81065d7e>] process_one_work+0x195/0x2d2
 [<ffffffff81066020>] worker_thread+0x136/0x205
 [<ffffffff81065eea>] ? process_scheduled_works+0x2f/0x2f
 [<ffffffff8106b4b4>] kthread+0xae/0xb6
 [<ffffffff8106b406>] ? __kthread_parkme+0x61/0x61
 [<ffffffff8162667c>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106b406>] ? __kthread_parkme+0x61/0x61
parent transid verify failed on 2776298520576 wanted 41015 found 18120
------------[ cut here ]------------
kernel BUG at fs/btrfs/locking.c:269!
invalid opcode: 0000 [#1] PREEMPT SMP
Modules linked in: udp_diag tcp_diag inet_diag ip6table_filter ip6_tables ebtable_nat ebtables tun ppdev lp autofs4 binfmt_misc kl5kusb105 deflate ctr twofish_avx_x86_64 twofish_x86_64_3way twofish_x86_64 twofish_generic twofish_common camellia_x86_64 camellia_generic serpent_avx_x86_64 serpent_sse2_x86_64 glue_helper lrw serpent_generic blowfish_x86_64 blowfish_generic blowfish_common cast5_avx_x86_64 ablk_helper cast5_generic cast_common des_generic cmac xcbc rmd160 sha512_ssse3 sha512_generic ftdi_sio crypto_null keyspan af_key xfrm_algo dm_mirror dm_region_hash dm_log nfsd nfs_acl auth_rpcgss nfs fscache lockd sunrpc ipt_REJECT xt_conntrack xt_nat xt_tcpudp xt_LOG iptable_mangle iptable_filter aes_x86_64 lm85 hwmon_vid dm_snapshot dm_bufio iptable_nat ip_tables nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_conntrack_ftp ipt_MASQUERADE nf_nat x_tables nf_conntrack sg st snd_pcm_oss snd_mixer_oss fuse eeepc_wmi snd_hda_codec_realtek snd_hda_codec_generic asus_wmi microcode snd_cmipci gameport sparse_keymap kvm_intel snd_hda_intel snd_opl3_lib rfkill kvm snd_mpu401_uart snd_seq_midi tpm_infineon snd_seq_midi_event snd_hda_controller snd_hda_codec rc_ati_x10 snd_hwdep snd_pcm snd_seq snd_rawmidi ati_remote asix battery coretemp libphy processor snd_seq_device snd_timer wmi usbnet evdev rc_core tpm_tis intel_rapl parport_pc snd parport tpm pcspkr lpc_ich i2c_i801 pl2303 xhci_hcd intel_powerclamp ezusb soundcore x86_pkg_temp_thermal usbserial xts gf128mul dm_crypt dm_mod raid456 async_raid6_recov async_pq async_xor async_memcpy async_tx e1000e ptp pps_core crc32c_intel ghash_clmulni_intel sata_sil24 cryptd crct10dif_pclmul r8169 ehci_pci thermal ehci_hcd crc32_pclmul fan mii sata_mv usbcore usb_common [last unloaded: kl5kusb105]
CPU: 0 PID: 25515 Comm: kworker/u8:2 Not tainted 3.15.1-amd64-i915-preempt-20140216jbp #1
Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3806 08/20/2012
Workqueue: btrfs-endio-write normal_work_helper
task: ffff880019d58610 ti: ffff880004c24000 task.ti: ffff880004c24000
RIP: 0010:[<ffffffff8125751c>]  [<ffffffff8125751c>] btrfs_assert_tree_read_locked+0x10/0x14
RSP: 0018:ffff880004c27848  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8800353cadd0 RCX: 0000000000000000
RDX: 000000000000001e RSI: ffff8801d6e46e10 RDI: ffff8800353cadd0
RBP: ffff880004c27848 R08: 0000000000000000 R09: ffff880041c943c8
R10: ffffffffffffffff R11: 0000000000000000 R12: 000000000000a037
R13: 0000000000000001 R14: ffff88020f032c00 R15: ffff8801957d201f
FS:  0000000000000000(0000) GS:ffff88021f200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000f777c064 CR3: 0000000045787000 CR4: 00000000000407f0
Stack:
 ffff880004c27868 ffffffff812578bd ffff8800353cadd0 000000000000a037
 ffff880004c278b0 ffffffff81224799 0000000000000000 0000000000000000
 0000000000000000 0000000000000000 0000000000000000 ffff8802121b2800
Call Trace:
 [<ffffffff812578bd>] btrfs_tree_read_unlock_blocking+0x5c/0xb7
 [<ffffffff81224799>] verify_parent_transid+0x138/0x150
 [<ffffffff81224867>] btree_read_extent_buffer_pages.constprop.45+0x7f/0x100
 [<ffffffff8122722a>] btrfs_read_buffer+0x2c/0x2e
 [<ffffffff8120e7cf>] read_block_for_search.isra.26+0xae/0x287
 [<ffffffff8121078d>] btrfs_search_old_slot+0x3e6/0x6bc
 [<ffffffff812454f9>] ? release_extent_buffer+0xad/0xb8
 [<ffffffff812747cd>] __resolve_indirect_refs+0x16c/0x50d
 [<ffffffff81275a48>] find_parent_nodes+0x8e6/0x90a
 [<ffffffff81275aee>] __btrfs_find_all_roots+0x82/0xe0
 [<ffffffff81275bb2>] btrfs_find_all_roots+0x4a/0x6a
 [<ffffffff81278c4a>] btrfs_qgroup_account_ref+0x10c/0x403
 [<ffffffff8113fb2c>] ? __cache_free.isra.40+0x1b4/0x1c3
 [<ffffffff81217de9>] btrfs_delayed_refs_qgroup_accounting+0xb5/0xe8
 [<ffffffff8122bf37>] __btrfs_end_transaction+0x60/0x2cd
 [<ffffffff8122c1b4>] btrfs_end_transaction+0x10/0x12
 [<ffffffff812327fd>] btrfs_finish_ordered_io+0x307/0x3bd
 [<ffffffff81232ab2>] finish_ordered_fn+0x15/0x17
 [<ffffffff812508db>] normal_work_helper+0xfe/0x240
 [<ffffffff81065d7e>] process_one_work+0x195/0x2d2
 [<ffffffff81066020>] worker_thread+0x136/0x205
 [<ffffffff81065eea>] ? process_scheduled_works+0x2f/0x2f
 [<ffffffff8106b4b4>] kthread+0xae/0xb6
 [<ffffffff8106b406>] ? __kthread_parkme+0x61/0x61
 [<ffffffff8162667c>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106b406>] ? __kthread_parkme+0x61/0x61
Code: 89 e5 f0 ff 0f 5d c3 55 48 89 e5 f0 ff 0f 74 04 31 c0 eb 05 b8 01 00 00 00 5d c3 66 66 66 66 90 8b 47 58 55 48 89 e5 85 c0 75 02 <0f> 0b 5d c3 66 66 66 66 90 55 48 89 e5 41 55 41 89 f5 41 54 53
RIP  [<ffffffff8125751c>] btrfs_assert_tree_read_locked+0x10/0x14
 RSP <ffff880004c27848>
---[ end trace b88f907c1447016f ]---
Kernel panic - not syncing: Fatal exception
Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
drm_kms_helper: panic occurred, switching back to text console
Rebooting in 20 seconds..
ACPI MEMORY or I/O RESET_REG.


-- 
                       OSPO Team, 1225-1-1S8D x34566
Remember the time we stored data on cassettes? Now we store music on SSDs...
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
1024R/763BE901 / Fingerprint: A1 9F 94 B7 78 01 E5 21  21 E0 F1 2E A2 85 E2 77
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
